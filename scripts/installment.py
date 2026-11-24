from pymongo import MongoClient
import mysql.connector
from mysql.connector import Error
from datetime import datetime, timedelta
import csv

# --- Configuration ---
MONGO_URI = "mongodb://switch_credit_user:123456@10.198.111.51:27017/switch_credit_db?directConnection=true"  # Change if needed
MYSQL_CONFIG = {
    "host": "10.198.111.65",
    "user": "installment_user",
    "password": "123456",
    "database": "installment_db"
}
BATCH_SIZE = 2500
MODIFICATION_DATE = 1720182319000  # static timestamp as required
EXTERNAL_CONTRACT_NUMBER = "0142.011.11111111.01"

# --- Step 1: Extract credit_ids from MongoDB ---
print("🔍 Connecting to MongoDB...")
mongo_client = MongoClient(MONGO_URI)
mongo_db = mongo_client["switch_credit_db"]
activations = mongo_db["activations"]

# Epoch time for yesterday
yesterday = datetime.now() - timedelta(days=1)
yesterday_epoch_ms = int(yesterday.timestamp() * 1000)
mongo_query = {
    "cellNumber": {"$regex": "^098"},
    "creationDate": {"$gt": yesterday_epoch_ms},
    "serviceType": "CREDIT",
    "status": "ACTIVE",
    "group.fundProvider.code": "TEJARAT_BANK"
}

print("📦 Querying MongoDB...")
cursor = activations.find(mongo_query, {"creditId": 1})
credit_ids = [str(doc["creditId"]) for doc in cursor if "creditId" in doc]

if not credit_ids:
    print("⚠️ No matching creditIds found. Exiting.")
    exit()

print(f"✅ Retrieved {len(credit_ids)} credit_ids from MongoDB.")

# --- Step 2: Batch update in MySQL ---
not_found = []

print("🔄 Connecting to MySQL...")
try:
    connection = mysql.connector.connect(**MYSQL_CONFIG)
    cursor = connection.cursor(dictionary=True)

    for i in range(0, len(credit_ids), BATCH_SIZE):
        batch = credit_ids[i:i + BATCH_SIZE]
        placeholders = ','.join(['%s'] * len(batch))

        print(
            f"🔹 Processing batch {i // BATCH_SIZE + 1} ({len(batch)} items)...")

        # 1. Fetch account IDs by credit_id
        fetch_accounts = f"""
            SELECT id, credit_id FROM accounts
            WHERE credit_id IN ({placeholders})
        """
        cursor.execute(fetch_accounts, batch)
        account_rows = cursor.fetchall()

        if not account_rows:
            not_found.extend(batch)
            continue

        found_credit_ids = {row['credit_id'] for row in account_rows}
        account_ids = [row['id'] for row in account_rows]
        missing_ids = [cid for cid in batch if cid not in found_credit_ids]
        not_found.extend(missing_ids)

        # 2. Update accounts
        update_accounts = f"""
            UPDATE accounts
            SET external_contract_number = %s
            WHERE id IN ({','.join(['%s'] * len(account_ids))})
        """
        cursor.execute(update_accounts, [EXTERNAL_CONTRACT_NUMBER] + account_ids)

        # 3. Update contracts
        update_contracts = f"""
            UPDATE contracts
            SET status = 6,
                modification_date = %s
            WHERE account_id IN ({','.join(['%s'] * len(account_ids))})
        """
        cursor.execute(update_contracts, [MODIFICATION_DATE] + account_ids)

        connection.commit()
        print(f"✅ Updated {len(account_ids)} accounts and contracts.")

except Error as e:
    print("❌ MySQL Error:", e)

finally:
    if connection.is_connected():
        cursor.close()
        connection.close()

# --- Step 3: Log not found credit_ids to CSV ---
if not_found:
    with open("not_found_credit_ids.csv", "w", newline="") as f:
        writer = csv.writer(f)
        writer.writerow(["missing_credit_id"])
        for cid in not_found:
            writer.writerow([cid])
    print(f"⚠️ {len(not_found)} credit_ids not found in MySQL — logged to 'not_found_credit_ids.csv'")
else:
    print("✅ All credit_ids were successfully processed and updated.")
