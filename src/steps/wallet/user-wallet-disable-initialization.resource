*** Settings ***
Library         library/faker_utils.py    WITH NAME    FakerLibrary
Resource        apis/wallet-provider/wallets/get-wallets-users-balances.resource
Resource        apis/wallet-provider/wallets/get-wallets-users-balance.resource
Resource        apis/wallet-provider/wallets/get-wallets-users-total-balance.resource
Resource        apis/wallet-provider/wallets/post-disable-wallets-users.resource
Resource        services/backend/auth-service.resource
Resource        services/backend/user-wallet-initializer-service.resource
Variables       data/wallet/transactions/transactions-spend-custom-source-variables.yaml
Variables       data/wallet/user-wallet-disable-variables.yaml


*** Keywords ***
Initialize User And Disable Wallet , Business And Wallet
    ${USER_WALLET_CHARGE_AMOUNT}    Random Int    100    200

    ${DEFAULT_WALLET_CASHOUTABLE_AMOUNT}    Evaluate    ${USER_WALLET_CHARGE_AMOUNT} - 50

    ${default_wallet}    Create Dictionary
    ...    definition=${WALLET_DEFAULT_DEFINITION}
    ...    wallet_charge_amount=${USER_WALLET_CHARGE_AMOUNT}
    ...    cashoutable_charge_amount=${DEFAULT_WALLET_CASHOUTABLE_AMOUNT}

    @{wallet_setup_list}    Create List
    ...    ${default_wallet}

    ${DEFAULT_WALLET_AS_SOURCE_USER}    Get Initialized User With Charged Wallet Based On Configuration
    ...    ${USER_CELL_NUMBER_PREFIX}
    ...    ${wallet_setup_list}

    ${USER_ID}    Get From Dictionary    ${DEFAULT_WALLET_AS_SOURCE_USER}    user_id

    ${disable_wallet_response}    Post Disable User Wallet
    ...    ${MICROSERVICE_SIDE}
    ...    ${user_id}
    ...    ${WALLET_DEFAULT_DEFINITION}

    Should Be Equal As Integers
    ...    ${disable_wallet_response['status_code']}
    ...    ${SUCESSFUL_DISABLE_WALLET_STATUS_CODE}
    ...    msg=Status code should be 200 after disabling wallet

    Should Be Equal As Strings
    ...    ${disable_wallet_response['body']}
    ...    ${SUCCESSFULL_DISABLE_WALLET_RESPONSE}
    ...    msg=Body should match the expected body

    ${business_wallet_for_payout_config}    Create Dictionary
    ...    definition=${B_WALLET_FOR_PAYOUT}
    ...    wallet_charge_amount=70
    ...    currency=${CURRENCY_IRR}

    @{main_business_config}    Create List    ${business_wallet_for_payout_config}

    ${init_business_obj}    Get Initialized Business With Charged Wallet Based On Configuration
    ...    ${main_business_config}

    ${BUSINESS_ID}    Set Variable    ${init_business_obj['business_id']}

    Set Suite Variable    ${BUSINESS_ID}
    Set Suite Variable    ${USER_ID}
    Set Suite Variable    ${DEFAULT_WALLET_AS_SOURCE_USER}
    Set Suite Variable    ${DEFAULT_WALLET_CASHOUTABLE_AMOUNT}
    Set Suite Variable    ${USER_WALLET_CHARGE_AMOUNT}
