*** Settings ***
Library         library/faker_utils.py    WITH NAME    FakerLibrary
Resource        services/backend/auth-service.resource
Resource        services/backend/user-wallet-initializer-service.resource
Variables       data/wallet/transactions/transactions-spend-custom-source-variables.yaml


*** Keywords ***
Initialize User And Wallets
    ${B_WALLET_SPEND_DEFINITION_EXPECTED_BALANCE}    Set Variable    0
    ${business_wallet_spend_config}    Create Dictionary
    ...    definition=${B_WALLET_SPEND_DEFINITION}
    ...    wallet_charge_amount=0
    ...    currency=${CURRENCY_IRR}
    @{main_business_config}    Create List    ${business_wallet_spend_config}

    ${init_business_obj}    Get Initialized Business With Charged Wallet Based On Configuration
    ...    ${main_business_config}
    ${INIT_BUSINESS_ID}    Set Variable    ${init_business_obj['business_id']}

    # Create user wallet setup configuration
    ${wallet_charge_amount}    Random Int    100    200
    ${default_wallet_cashoutable_amount}    Evaluate    ${wallet_charge_amount} - 50
    ${expired_wallet}    Create Dictionary
    ...    definition=${WALLET_TIME_BOUND_DEFINITION}
    ...    should_be_expired=${True}
    ...    wallet_charge_amount=${wallet_charge_amount}
    ${unexpired_wallet}    Create Dictionary
    ...    definition=${WALLET_TIME_BOUND_DEFINITION}
    ...    wallet_charge_amount=${wallet_charge_amount}
    ${unexpired_zero_amount_wallet}    Create Dictionary
    ...    definition=${WALLET_TIME_BOUND_DEFINITION}
    ...    wallet_charge_amount=0
    ${default_wallet}    Create Dictionary
    ...    definition=${WALLET_DEFAULT_DEFINITION}
    ...    wallet_charge_amount=${wallet_charge_amount}
    ...    cashoutable_charge_amount=${default_wallet_cashoutable_amount}

    @{wallet_setup_list}    Create List
    ...    ${expired_wallet}
    ...    ${unexpired_wallet}
    ...    ${default_wallet}
    ...    ${unexpired_zero_amount_wallet}

    ${DEFAULT_WALLET_AS_SOURCE_USER}    Get Initialized User With Charged Wallet Based On Configuration
    ...    ${USER_CELL_NUMBER_PREFIX}
    ...    ${wallet_setup_list}

    ## Unexpired wallet as source
    ${UNEXPIRED_WALLET_AS_SOURCE_USER}    Get Initialized User With Charged Wallet Based On Configuration
    ...    ${USER_CELL_NUMBER_PREFIX}
    ...    ${wallet_setup_list}

    ## Default & Unexpired wallets with order as source
    ${DEFAULT_AND_UNEXPIRED_WALLET_AS_SOURCE_USER}    Get Initialized User With Charged Wallet Based On Configuration
    ...    ${USER_CELL_NUMBER_PREFIX}
    ...    ${wallet_setup_list}

    ## Unexpired zero amount wallets with order as source
    ${UNEXPIRED_ZERO_AMOUNT_WALLET_AS_SOURCE_USER}    Get Initialized User With Charged Wallet Based On Configuration
    ...    ${USER_CELL_NUMBER_PREFIX}
    ...    ${wallet_setup_list}

    ## Invalid scenario wallet
    ${INVALID_SCENARIO_SOURCE_USER}    Get Initialized User With Charged Wallet Based On Configuration
    ...    ${USER_CELL_NUMBER_PREFIX}
    ...    ${wallet_setup_list}

    ## Just gift wallet user
    @{gift_only_user_setup_wallet_list}    Create List
    ...    ${expired_wallet}
    ...    ${unexpired_wallet}
    ${GIFT_ONLY_WALLET_USER}    Get Initialized User With Charged Wallet Based On Configuration
    ...    ${USER_CELL_NUMBER_PREFIX}
    ...    ${gift_only_user_setup_wallet_list}

    ## Just Default wallet user
    @{default_only_user_setup_wallet_list}    Create List    ${default_wallet}
    ${DEFAULT_ONLY_WALLET_USER}    Get Initialized User With Charged Wallet Based On Configuration
    ...    ${USER_CELL_NUMBER_PREFIX}
    ...    ${default_only_user_setup_wallet_list}

    ## User Without Wallet
    ${WITHOUT_WALLET_USER}    Get A Fresh User    ${USER_CELL_NUMBER_PREFIX}

    Sleep    40s    reason=wait for wallet expiration time.

    Set Suite Variable    ${INIT_BUSINESS_ID}
    Set Suite Variable    ${B_WALLET_SPEND_DEFINITION_EXPECTED_BALANCE}
    Set Suite Variable    ${DEFAULT_WALLET_AS_SOURCE_USER}
    Set Suite Variable    ${UNEXPIRED_WALLET_AS_SOURCE_USER}
    Set Suite Variable    ${DEFAULT_AND_UNEXPIRED_WALLET_AS_SOURCE_USER}
    Set Suite Variable    ${UNEXPIRED_ZERO_AMOUNT_WALLET_AS_SOURCE_USER}
    Set Suite Variable    ${INVALID_SCENARIO_SOURCE_USER}
    Set Suite Variable    ${GIFT_ONLY_WALLET_USER}
    Set Suite Variable    ${DEFAULT_ONLY_WALLET_USER}
    Set Suite Variable    ${WITHOUT_WALLET_USER}
