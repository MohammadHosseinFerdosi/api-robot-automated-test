# 🏦 User Wallet Initializer Service 🏦

## 📝 Introduction
This service is a powerful tool for setting up and managing user and business wallets. Using this service, you can:

- 🧑‍💼 Create new users
- 🏢 Create new businesses
- 💰 Set up various wallets
- 💵 Charge wallets with different amounts
- 🔄 Manage financial transactions
- 🧹 Manage balance in Teardown phase

> ⚠️ **Important Note [1]:** Currently, this service only supports Iranian Rial (IRR) currency.

> ⚠️ **Important Note [2]:** The Collection of the wallets now supports both types of, IRR and CRR.

## 🚀 Complete Example
```robot
*** Test Cases ***
Test Wallet Operations
    # Create user with two wallets
    ${user}    Get Initialized User With Charged Wallet Based On Configuration
    ...    0912
    ...    [
        {'definition': '${WALLET_DEFAULT_DEFINITION}', 'wallet_charge_amount': 1000, 'cashoutable_charge_amount': 200},
        {'definition': '${WALLET_TIME_BOUND_DEFINITION}', 'wallet_charge_amount': 500}
    ]

    # Create business with wallet
    ${business}    Get Initialized Business With Charged Wallet Based On Configuration
    ...    [{'definition': '${B_WALLET_REFUND_DEFINITION}', 'wallet_charge_amount': 2000}]
    ...    ['BUSINESS_ADMIN']

    # Perform test operations
    # ...

    [Teardown]    Collect All Amount For Tear Down
```

## 🔑 Key Keywords

### 1. Get Initialized User With Charged Wallet Based On Configuration
This keyword is used to create a new user with charged wallets.

**Inputs:**
- `user_cell_number_prefix`: User's mobile number prefix (4 digits)
- `wallets_config_list`: List of wallet configurations

**Usage Example:**
```robot
${user}    Get Initialized User With Charged Wallet Based On Configuration
...    0912
...    [{'definition': '${WALLET_DEFAULT_DEFINITION}', 'wallet_charge_amount': 1000}]
```

**Output:**
```json
{
    "user_id": "user123",
    "user_cell_number": "09121234567",
    "wallets": [
        {
            "name": "DEFAULT",
            "type": "DEFAULT",
            "initial_amount": 1000
        }
    ],
    "total_initial_amount": 1000
}
```

### 2. Create And Charge User Wallet Based On Configuration
This keyword is used to create and charge a wallet for an existing user.

**Inputs:**
- `user_id`: User ID
- `wallets_config_list`: List of wallet configurations

**Usage Example:**
```robot
${result}    Create And Charge User Wallet Based On Configuration
...    user123
...    [{'definition': '${WALLET_TIME_BOUND_DEFINITION}', 'wallet_charge_amount': 500}]
```

### 3. Get Initialized Business With Charged Wallet Based On Configuration
This keyword is used to create a new business with charged wallets.

**Inputs:**
- `wallets_config_list`: List of wallet configurations (optional)
- `role_list`: List of business roles (optional)
- `zone`: Business zone (optional)

**Usage Example:**
```robot
${business}    Get Initialized Business With Charged Wallet Based On Configuration
...    [{'definition': '${B_WALLET_REFUND_DEFINITION}', 'wallet_charge_amount': 2000}]
...    ['BUSINESS_ADMIN']
...    'zone1'
```

**Output:**
```json
{
    "business_id": "biz123",
    "business_name": "Test Business",
    "user_name": "test_user",
    "password": "****",
    "wallets": [
        {
            "name": "REFUND",
            "initial_amount": 2000
        }
    ]
}
```

## 💡 Important Notes
- For Time Bound wallets, you can set the expiration time
- Default wallets can have withdrawable amounts
- This service automatically collects wallet balances at the end of tests

## 🧹 Balance Management in Teardown Phase
It is very important to return the charged wallet balances to the main wallet at the end of each test. Use the `Collect All Amount For Tear Down` keyword for this purpose.

Currently includes the collection strategies for both currency types. A new dynamic API call is utilized to return a JSON that includes all the wallets of the user based on their currency. This dictionary is later used to perform a spent action of the wallets with balance more than 0. 

Additionally, a new list is passed through this function to perform a "Collection" act on the data/users/business created outside this service. A prime example of this would be during LMS import allocations.

**Usage Example in Teardown Phase:**
```robot
*** Test Cases ***
Test Example
    # Create user and charge wallet
    ${user}    Get Initialized User With Charged Wallet Based On Configuration
    ...    0912
    ...    [{'definition': '${WALLET_DEFAULT_DEFINITION}', 'wallet_charge_amount': 1000}]
    
    # Perform desired tests
    # ...
    
    [Teardown]    Collect All Amount For Tear Down
```

**Important Notes about Teardown:**
- 🔄 This keyword automatically collects all balances from user and business wallets
- 💰 Collected balances are transferred to the main test wallet
- ⚠️ Don't forget to place this keyword in the Teardown phase
- 🚫 If this keyword is not used, wallet balances will remain in the system

## 🤝 Contribution
If you have any suggestions or questions, we'd be happy to hear from you! 🙌 