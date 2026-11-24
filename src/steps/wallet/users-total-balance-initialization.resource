*** Settings ***
Library         library/faker_utils.py    WITH NAME    FakerLibrary
Resource        services/backend/auth-service.resource
Resource        services/backend/user-wallet-initializer-service.resource
Variables       data/wallet/users-total-balance-variables.yaml


*** Keywords ***
 Initialize User And Wallets
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

    ${default_wallet_only_cashoutable}    Create Dictionary
    ...    definition=${WALLET_DEFAULT_DEFINITION}
    ...    wallet_charge_amount=${wallet_charge_amount}
    ...    cashoutable_charge_amount=${wallet_charge_amount}

    ${default_wallet_only_noncashoutable}    Create Dictionary
    ...    definition=${WALLET_DEFAULT_DEFINITION}
    ...    wallet_charge_amount=${wallet_charge_amount}
    ...    cashoutable_charge_amount=0

    @{wallet_setup_list}    Create List
    ...    ${expired_wallet}
    ...    ${unexpired_wallet}
    ...    ${default_wallet}
    ...    ${unexpired_zero_amount_wallet}

    @{default_only_wallet_setup_list}    Create List
    ...    ${default_wallet}

    @{default_cashoutable_only_wallet_setup_list}    Create List
    ...    ${default_wallet_only_cashoutable}

    @{default_noncashoutable_only_wallet_setup_list}    Create List
    ...    ${default_wallet_only_noncashoutable}

    @{gift_only_wallet_setup_list}    Create List
    ...    ${expired_wallet}
    ...    ${unexpired_wallet}
    ...    ${unexpired_zero_amount_wallet}

    @{expired_gift_only_wallet_setup_list}    Create List
    ...    ${expired_wallet}

    ${MULTI_TYPE_WALLET_USER}    Get Initialized User With Charged Wallet Based On Configuration
    ...    ${USER_CELL_NUMBER_PREFIX}
    ...    ${wallet_setup_list}

    ${GIFT_ONLY_WALLET_USER}    Get Initialized User With Charged Wallet Based On Configuration
    ...    ${USER_CELL_NUMBER_PREFIX}
    ...    ${gift_only_wallet_setup_list}

    ${DEFAULT_ONLY_WALLET_USER}    Get Initialized User With Charged Wallet Based On Configuration
    ...    ${USER_CELL_NUMBER_PREFIX}
    ...    ${default_only_wallet_setup_list}

    ${CASHOUTABLE_ONLY_WALLET_USER}    Get Initialized User With Charged Wallet Based On Configuration
    ...    ${USER_CELL_NUMBER_PREFIX}
    ...    ${default_cashoutable_only_wallet_setup_list}

    ${NON_CASHOUTABLE_ONLY_WALLET_USER}    Get Initialized User With Charged Wallet Based On Configuration
    ...    ${USER_CELL_NUMBER_PREFIX}
    ...    ${default_noncashoutable_only_wallet_setup_list}

    ${ONLY_EXPIRED_WALLET_USER}    Get Initialized User With Charged Wallet Based On Configuration
    ...    ${USER_CELL_NUMBER_PREFIX}
    ...    ${expired_gift_only_wallet_setup_list}

    ${fresh_user}    Get A Fresh User    ${USER_CELL_NUMBER_PREFIX}
    ${WITHOUT_WALLET_USER_ID}    Set Variable    ${fresh_user['user_id']}
    ${WITHOUT_WALLET_USER_CELL_NUMBER}    Set Variable    ${fresh_user['user_cell_number']}

    Sleep    40s    reason=wait for wallet expiration time.

    Set Suite Variable    ${MULTI_TYPE_WALLET_USER_ID}    ${MULTI_TYPE_WALLET_USER['user_id']}
    Set Suite Variable    ${MULTI_TYPE_WALLET_USER_CELL_NUMBER}    ${MULTI_TYPE_WALLET_USER['user_cell_number']}
    Set Suite Variable    ${MULTI_TYPE_WALLET_USER_UNEXPIRED_WALLET_INITIAL_AMOUNT}    ${wallet_charge_amount}
    Set Suite Variable    ${MULTI_TYPE_WALLET_USER_DEFAULT_WALLET_ALL_INITIAL_AMOUNT}    ${wallet_charge_amount}
    Set Suite Variable
    ...    ${MULTI_TYPE_WALLET_USER_DEFAULT_WALLET_CASHOUTABLE_INITIAL_AMOUNT}
    ...    ${default_wallet_cashoutable_amount}
    Set Suite Variable    ${GIFT_ONLY_WALLET_USER_ID}    ${GIFT_ONLY_WALLET_USER['user_id']}
    Set Suite Variable    ${GIFT_ONLY_WALLET_USER_CELL_NUMBER}    ${GIFT_ONLY_WALLET_USER['user_cell_number']}
    Set Suite Variable    ${GIFT_ONLY_USER_UNEXPIRED_WALLET_INITIAL_AMOUNT}    ${wallet_charge_amount}
    Set Suite Variable    ${DEFAULT_ONLY_WALLET_USER_ID}    ${DEFAULT_ONLY_WALLET_USER['user_id']}
    Set Suite Variable    ${DEFAULT_ONLY_WALLET_USER_CELL_NUMBER}    ${DEFAULT_ONLY_WALLET_USER['user_cell_number']}
    Set Suite Variable    ${DEFAULT_ONLY_USER_WALLET_ALL_INITIAL_AMOUNT}    ${wallet_charge_amount}
    Set Suite Variable    ${DEFAULT_ONLY_USER_CASHOUTABLE_INITIAL_AMOUNT}    ${default_wallet_cashoutable_amount}
    Set Suite Variable    ${CASHOUTABLE_ONLY_WALLET_USER_ID}    ${CASHOUTABLE_ONLY_WALLET_USER['user_id']}
    Set Suite Variable
    ...    ${CASHOUTABLE_ONLY_WALLET_USER_CELL_NUMBER}
    ...    ${CASHOUTABLE_ONLY_WALLET_USER['user_cell_number']}
    Set Suite Variable    ${CASHOUTABLE_ONLY_USER_WALLET_INITIAL_AMOUNT}    ${wallet_charge_amount}
    Set Suite Variable    ${NON_CASHOUTABLE_ONLY_WALLET_USER_ID}    ${NON_CASHOUTABLE_ONLY_WALLET_USER['user_id']}
    Set Suite Variable
    ...    ${NON_CASHOUTABLE_ONLY_WALLET_USER_CELL_NUMBER}
    ...    ${NON_CASHOUTABLE_ONLY_WALLET_USER['user_cell_number']}
    Set Suite Variable    ${NON_CASHOUTABLE_ONLY_USER_WALLET_INITIAL_AMOUNT}    ${wallet_charge_amount}
    Set Suite Variable    ${ONLY_EXPIRED_WALLET_USER_ID}    ${ONLY_EXPIRED_WALLET_USER['user_id']}
    Set Suite Variable    ${ONLY_EXPIRED_WALLET_USER_CELL_NUMBER}    ${ONLY_EXPIRED_WALLET_USER['user_cell_number']}
    Set Suite Variable    ${WITHOUT_WALLET_USER_ID}
    Set Suite Variable    ${WITHOUT_WALLET_USER_CELL_NUMBER}
