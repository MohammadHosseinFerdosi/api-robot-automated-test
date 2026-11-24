# 💳 Purchase Services 

The **Purchase Service** provides keywords within the Robot Framework test automation suite to simulate various purchase flows, primarily focusing on Wallet and Direct Payment Gateway (DPG) transactions. It handles scenarios involving both newly created users and existing users, along with necessary business configurations.

This guide details the primary keywords offered by the service, explaining their usage, arguments, and expected outcomes.

## 📑 Description

Automated testing frequently requires simulating purchase actions to validate payment flows, user balances, transaction logging, and related system behaviors. Directly orchestrating the multiple API calls involved in creating users, managing tickets, selecting payment gateways, and verifying transactions for each test case can be complex and repetitive.

The **Purchase Service** (`purchases.resource`) abstracts these complexities by providing high-level keywords that encapsulate common purchase scenarios. This simplifies test case creation, improves readability, and ensures consistency in how purchases are simulated across different tests.

This service allows tests to:
- Create verified purchases using a user's wallet.
- Create verified purchases using a Direct Payment Gateway (DPG).
- Handle scenarios for both newly generated users and existing users.
- Configure business-specific settings related to purchases and ticketing.

> **Note**  
> This guide covers the main keywords provided by this service. Refer to the keyword definitions within the resource file (`src/services/backend/purchases.resource`) and the documentation of the underlying API resources it imports for more granular details.

# Table of Contents

1. [Getting Started](#▶️-getting-started)
2. [Keywords](#🔑-keywords)
    - [Create A Verified Wallet purchase With A Fresh User](#🛒-create-a-verified-wallet-purchase-with-a-fresh-user)
    - [Create Verified Wallet Purchase For Exsisting User](#👤-create-verified-wallet-purchase-for-exsisting-user) 
    - [Create A Verified DPG purchase With A Fresh User](#💳-create-a-verified-dpg-purchase-with-a-fresh-user)
    - [Create Business Purchase And Ticket Setting For Purchase And Refund](#⚙️-create-business-purchase-and-ticket-setting-for-purchase-and-refund)
3. [Dependencies](#🔗-dependencies)


# ▶️ Getting Started

To use the keywords provided by this service, import the resource file into your Robot Framework test suite or step definition file:

```robotframework
*** Settings ***
Resource        services/backend/purchases.resource 
```

You can then call the keywords defined within this resource.

# 🔑 Keywords

This section describes the main keywords provided by the Purchase Service.

## 🛒 Create A Verified Wallet purchase With A Fresh User

This keyword orchestrates the entire flow of creating a new user, initializing their wallet with sufficient funds (implicitly handled by the imported `user-wallet-initializer-service.resource`), obtaining a purchase ticket, selecting the wallet payment gateway, executing the payment, and verifying the transaction.

**Usage:**

```robotframework
${tracking_code}=    Create A Verified Wallet purchase With A Fresh User
...    ${prefix_cellnumber}    # e.g., '0912'
...    ${amount}               # Purchase amount
...    ${agent}                # e.g., 'WEB', 'ANDROID'
...    ${business_username}    # Username for business login
...    ${business_password}    # Password for business login
```

**Arguments:**

- `${prefix_cellnumber}`: The desired prefix for the newly generated user's cell number (e.g., '0912'). A random suffix will be appended.
- `${amount}`: The monetary amount for the purchase. The user's wallet will be implicitly charged with this amount beforehand.
- `${agent}`: The agent string indicating the source platform (e.g., `${WEB_AGENT}`, `${ANDROID_AGENT}`).
- `${business_username}`: The username of the business initiating the purchase ticket.
- `${business_password}`: The password for the specified business user.

**Returns:**

- `${tracking_code}`: The tracking code of the successfully verified wallet purchase.

**Example Usage (Refund Initialization):**

While not directly used in the refund *step* resource, the underlying `user-wallet-initializer-service.resource` (imported by `purchases.resource`) is heavily used in `src/steps/payment/refund/refund-initialization.resource` to set up users with specific wallet balances before tests:

```robotframework
# From: src/steps/payment/refund/refund-initialization.resource
# (Inside Create Business With Charged Refund Wallet And Users With Wallets Activated)

# Create user with cashoutable charged wallet
${default_wallet}=    Create Dictionary
...    definition=${WALLET_DEFAULT_DEFINITION}
...    wallet_charge_amount=${USER_WALLET_CASHOUTABLE_AMOUNT}
...    cashoutable_charge_amount=${USER_WALLET_CASHOUTABLE_AMOUNT}

@{wallet_setup_list}=    Create List
...    ${default_wallet}

${default_wallet_user}=    Get Initialized User With Charged Wallet Based On Configuration
...    ${USER_CELL_NUMBER_PREFIX}
...    ${wallet_setup_list}

Set Suite Variable    ${DEFAULT_ONLY_WALLET_USER_ID}    ${default_wallet_user['user_id']}
Set Suite Variable    ${DEFAULT_ONLY_WALLET_CELL_NUMBER}   ${default_wallet_user['user_cell_number']}
```

## 👤 Create Verified Wallet Purchase For Exsisting User

This keyword performs a verified wallet purchase for a user that already exists in the system. It assumes the user has an active wallet with sufficient balance.

**Usage:**

```robotframework
${tracking_code}=    Create Verified Wallet Purchase For Exsisting User
...    ${user_cell_number}    # Cell number of the existing user
...    ${amount}              # Purchase amount
```

**Arguments:**

- `${user_cell_number}`: The cell number of the existing user performing the purchase.
- `${amount}`: The monetary amount for the purchase.

**Returns:**

- `${tracking_code}`: The tracking code of the successfully verified wallet purchase.

**Example Usage (Refund Step):**

In `src/steps/payment/refund/refund-step.resource`, this keyword is wrapped in a simpler custom keyword `Create Verified Wallet Purchase` which is then used in the test setup:

```robotframework
# From: src/steps/payment/refund/refund-step.resource
*** Keywords ***
Create Verified Wallet Purchase
    [Arguments]    ${user_cell_number}    ${purchase_amount}
    ${SALE_TRACKING_CODE}=    Create Verified Wallet Purchase For Exsisting User    ${user_cell_number}    ${purchase_amount}
    Set Test Variable    ${SALE_TRACKING_CODE}

# Example call from features/payment/refund.robot:
# Given Create Verified Wallet Purchase    ${DEFAULT_ONLY_WALLET_CELL_NUMBER}    ${USER_WALLET_CASHOUTABLE_AMOUNT}
```
This creates the initial purchase that the subsequent refund steps will target.

## 💳 Create A Verified DPG purchase With A Fresh User

Similar to the wallet purchase with a fresh user, this keyword handles creating a new user, obtaining a purchase ticket, selecting the DPG (Direct Payment Gateway), executing the DPG payment using test card details, and verifying the transaction.

**Usage:**

```robotframework
${tracking_code}=    Create A Verified DPG purchase With A Fresh User
...    ${prefix_cellnumber}    # e.g., '0936'
...    ${amount}               # Purchase amount
...    ${business_username}    # Username for business login
...    ${business_password}    # Password for business login
```

**Arguments:**

- `${prefix_cellnumber}`: The desired prefix for the newly generated user's cell number.
- `${amount}`: The monetary amount for the purchase.
- `${business_username}`: The username of the business initiating the purchase ticket.
- `${business_password}`: The password for the specified business user.

**Returns:**

- `${tracking_code}`: The tracking code of the successfully verified DPG purchase.

**Example Usage:**

*(This keyword is not directly used in the provided refund example files, but usage would be similar to the wallet purchase examples.)*

## ⚙️ Create Business Purchase And Ticket Setting For Purchase And Refund

This keyword configures purchase and ticket settings for a specific business. It allows activating specific payment gateways and setting parameters like transaction types, ticket Time-To-Live (TTL), and feature priorities. This is often a prerequisite step before initiating purchases for a business.

**Usage:**

```robotframework
Create Business Purchase And Ticket Setting For Purchase And Refund
...    ${business_id}          # ID of the business to configure
...    @{active_gateways}      # List of gateways to activate (e.g., ['WALLET', 'DPG'])
```

**Arguments:**

- `${business_id}`: The unique identifier of the business whose settings are being configured.
- `@{active_gateways}`: A list of strings representing the payment gateways to be activated for this business (e.g., `${WALLET_FEATURE_NAME}`, `${DPG_FEATURE_NAME}`). Constants defined in `data/CONSTANTS.yaml` are typically used here.

**Internal Logic:**

- This keyword internally sets default `transaction_types`, `ttl`, `type`, and `feature_orders` based on predefined constants.
- It calls the `Post admin Purchase setting` and `Post admin ticket config` APIs to apply the configuration.

**Returns:**

- This keyword does not explicitly return a value but performs internal assertions to ensure the API calls for setting configurations were successful (HTTP status 200).

**Example Usage (Refund Initialization):**

This keyword is used in the suite setup within `src/steps/payment/refund/refund-initialization.resource` to configure the business before any refund tests run:

```robotframework
# From: src/steps/payment/refund/refund-initialization.resource
# (Inside Create Business With Charged Refund Wallet And Users With Wallets Activated)

# Create business details... (omitted for brevity)

# Set Wallet Gateway For Business
@{active_gateways}=    Create List    ${WALLET_GATEWAY_METHOD}

Create Business Purchase And Ticket Setting For Purchase And Refund
...    ${REFUND_TEST_BUSINESS_ID}
...    @{active_gateways}

# Login by new business... (omitted for brevity)
```
This ensures the test business is correctly set up to handle wallet purchases, which are prerequisites for the refund scenarios.

# 🔗 Dependencies

This service relies on several other resources and APIs, including:

- `services/backend/user-wallet-initializer-service.resource`: For creating users and managing wallets.
- `apis/tgs/`: Resources for interacting with the Ticket Granting Service (TGS) to create and manage purchase tickets.
- `apis/purchase-mng/`: Resources for interacting with the Purchase Management service to execute payments (Wallet, DPG) and verify transactions.
- `apis/purchase-mng/setting/`: Resource for configuring business-specific purchase settings.
- `apis/switch-psp/`: Resource for terminal configurations (though potentially less directly used by the documented keywords).
- `services/backend/session-service.resource`: For managing API sessions.
- `data/CONSTANTS.yaml`: For various constants like feature names, agent types, etc. 