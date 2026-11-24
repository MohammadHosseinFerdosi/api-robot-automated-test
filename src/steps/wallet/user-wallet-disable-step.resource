*** Settings ***
Library         library/faker_utils.py    WITH NAME    FakerLibrary
Resource        apis/wallet-provider/wallets/get-wallets-users-balances.resource
Resource        apis/wallet-provider/wallets/get-wallets-users-balance.resource
Resource        apis/wallet-provider/wallets/get-wallets-users-total-balance.resource
Resource        apis/wallet-provider/wallets/post-disable-wallets-users.resource
Resource        apis/wallet-provider/transactions/post-transactions-withdraw.resource
Resource        apis/wallet-provider/transactions/post-transactions-user-transfer.resource
Resource        apis/wallet-provider/transactions/post-transactions-collect.resource
Resource        apis/wallet-provider/transactions/post-transactions-deposit.resource
Resource        apis/wallet-provider/transactions/post-transactions-receive.resource
Resource        services/backend/auth-service.resource
Resource        services/backend/user-wallet-initializer-service.resource
Variables       data/wallet/transactions/transactions-spend-custom-source-variables.yaml
Variables       data/wallet/user-wallet-disable-variables.yaml


*** Keywords ***
# ADD TEST CASES
Withdraw Transaction On Disabled Wallet
    ${fee}    Random Int    1    5

    ${transaction_on_disable_wallet_response}    POST Transactions Withdraw
    ...    ${MICROSERVICE_SIDE}
    ...    ${TRACKING_CODE}
    ...    ${USER_ID}
    ...    ${WALLET_DEFAULT_DEFINITION}
    ...    ${USER_WALLET_CHARGE_AMOUNT}
    ...    ${fee}
    ...    ${BUSINESS_ID}
    ...    ${B_WALLET_FOR_PAYOUT}
    ...    ${CURRENCY_IRR}
    ...    ${DESCRIPTION}
    Set Test Variable    ${transaction_on_disable_wallet_response}

Transfer Transaction On Disabled Wallet
    ${default_wallet}    Create Dictionary
    ...    definition=${WALLET_DEFAULT_DEFINITION}
    ...    wallet_charge_amount=${USER_WALLET_CHARGE_AMOUNT}
    ...    cashoutable_charge_amount=${DEFAULT_WALLET_CASHOUTABLE_AMOUNT}

    @{wallet_setup_list}    Create List
    ...    ${default_wallet}

    ${DEFAULT_WALLET_AS_DESTINATION_USER}    Get Initialized User With Charged Wallet Based On Configuration
    ...    ${USER_CELL_NUMBER_PREFIX}
    ...    ${wallet_setup_list}

    ${tracking_code}    Generate Random String    18    [LOWER]
    ${destination_user_id}    Get From Dictionary    ${DEFAULT_WALLET_AS_DESTINATION_USER}    user_id
    ${amount}    Random Int    10000    50000

    ${transaction_on_disable_wallet_response}    POST Transactions user-Transfer
    ...    ${MICROSERVICE_SIDE}
    ...    ${tracking_code}
    ...    ${USER_ID}
    ...    ${WALLET_DEFAULT_DEFINITION}
    ...    ${destination_user_id}
    ...    ${WALLET_DEFAULT_DEFINITION}
    ...    ${USER_WALLET_CHARGE_AMOUNT}
    ...    ${DEFAULT_WALLET_CASHOUTABLE_AMOUNT}

    Set Test Variable    ${transaction_on_disable_wallet_response}

Collect Transaction On Disabled Wallet
    ${transaction_on_disable_wallet_response}    POST Transactions Collect
    ...    ${MICROSERVICE_SIDE}
    ...    ${USER_ID}
    ...    ${WALLET_DEFAULT_DEFINITION}
    ...    ${BUSINESS_ID}
    ...    ${B_WALLET_FOR_PAYOUT}
    Set Test Variable    ${transaction_on_disable_wallet_response}

Deposit Transaction On Disabled Wallet
    ${tracking_code}    Generate Random String    18    [LOWER]

    ${transaction_on_disable_wallet_response}    Post Deposit Wallet
    ...    ${MICROSERVICE_SIDE}
    ...    ${tracking_code}
    ...    ${USER_ID}
    ...    ${WALLET_DEFAULT_DEFINITION}
    ...    ${USER_WALLET_CHARGE_AMOUNT}
    Set Test Variable    ${transaction_on_disable_wallet_response}

Business Receive Transaction From Dsiabled Wallet
    ${amount}    Random Int    10000    50000
    ${cashoutable_amount}    Evaluate    ${amount} - 50

    ${transaction_on_disable_wallet_response}    Post Receive Wallet
    ...    ${MICROSERVICE_SIDE}
    ...    ${tracking_code}
    ...    ${USER_ID}
    ...    ${WALLET_DEFAULT_DEFINITION}
    ...    ${BUSINESS_ID}
    ...    ${B_WALLET_FOR_PAYOUT}
    ...    ${USER_WALLET_CHARGE_AMOUNT}
    ...    ${DEFAULT_WALLET_CASHOUTABLE_AMOUNT}

    Set Test Variable    ${transaction_on_disable_wallet_response}

# Payout To Disabled Wallet

Payout To Disabled Wallet
    ${amount}    Random Int    10000    50000
    ${sale_tracking_code}    Generate Random String    16

    ${transaction_on_disable_wallet_response}    POST Transactions Payout
    ...    ${MICROSERVICE_SIDE}
    ...    ${USER_WALLET_CHARGE_AMOUNT}
    ...    ${BUSINESS_ID}
    ...    ${B_WALLET_FOR_PAYOUT}
    ...    ${USER_ID}
    ...    ${WALLET_DEFAULT_DEFINITION}
    ...    ${DEFAULT_WALLET_CASHOUTABLE_AMOUNT}
    ...    ${sale_tracking_code}
    ...    ${description}

    Set Test Variable    ${transaction_on_disable_wallet_response}

Spend From Disabled Wallet
    ${user_amount}    Random Int    10000    50000

 # Create business list for spend transaction
    @{spend_businesses_list}    Create List
    ${main_business}    Create Dictionary
    ...    businessId=${BUSINESS_ID}
    ...    walletName=${B_WALLET_FOR_PAYOUT}
    ...    amount=${USER_WALLET_CHARGE_AMOUNT}
    Append To List    ${spend_businesses_list}    ${main_business}

    ${transaction_on_disable_wallet_response}    POST Transactions Spend Pay
    ...    ${MICROSERVICE_SIDE}
    ...    ${USER_ID}
    ...    ${spend_businesses_list}
    ...    ${CURRENCY_IRR}
    Set Test Variable    ${transaction_on_disable_wallet_response}

Transaction Should Be Failed With
    [Arguments]    ${transaction_on_disable_wallet_content}
    Should Be Equal As Integers
    ...    ${transaction_on_disable_wallet_content['status_code']}
    ...    ${transaction_on_disable_wallet_response['status_code']}
    Should Be Equal As Strings
    ...    ${transaction_on_disable_wallet_response['body']['result']['title']}
    ...    ${transaction_on_disable_wallet_content['title']}
