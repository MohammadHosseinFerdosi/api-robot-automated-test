*** Settings ***
Library         library/faker_utils.py    WITH NAME    FakerLibrary
Resource        services/backend/auth-service.resource
Resource        services/backend/user-wallet-initializer-service.resource
Resource        services/backend/purchases.resource
Resource        apis/purchase-mng/refund/post-purchase-refund.resource
Variables       data/payment/purchase/refund.yaml


*** Keywords ***
Create Business With Charged Refund Wallet And Users With Wallets Activated
    [Documentation]    Create business with charged refund wallet and required roles
    ...    and create user with charged wallet

    # Create user with cashoutable charged wallet
    ${default_wallet}    Create Dictionary
    ...    definition=${WALLET_DEFAULT_DEFINITION}
    ...    wallet_charge_amount=${USER_WALLET_CASHOUTABLE_AMOUNT}
    ...    cashoutable_charge_amount=${USER_WALLET_CASHOUTABLE_AMOUNT}

    @{wallet_setup_list}    Create List
    ...    ${default_wallet}

    ${default_wallet_user}    Get Initialized User With Charged Wallet Based On Configuration
    ...    ${USER_CELL_NUMBER_PREFIX}
    ...    ${wallet_setup_list}

    Set Suite Variable    ${DEFAULT_ONLY_WALLET_USER_ID}    ${default_wallet_user['user_id']}
    Set Suite Variable    ${DEFAULT_ONLY_WALLET_CELL_NUMBER}    ${default_wallet_user['user_cell_number']}

    # Create user with non-cashoutable charged wallet
    ${non_cashoutable_wallet}    Create Dictionary
    ...    definition=${WALLET_DEFAULT_DEFINITION}
    ...    wallet_charge_amount=${USER_WALLET_NON_CASHOUTABLE_AMOUNT}
    ...    cashoutable_charge_amount=0

    @{non_cashoutable_wallet_setup_list}    Create List
    ...    ${non_cashoutable_wallet}

    ${non_cashoutable_wallet_user}    Get Initialized User With Charged Wallet Based On Configuration
    ...    ${USER_CELL_NUMBER_PREFIX}
    ...    ${non_cashoutable_wallet_setup_list}

    Set Suite Variable    ${NON_CASHOUTABLE_WALLET_USER_ID}    ${non_cashoutable_wallet_user['user_id']}
    Set Suite Variable    ${NON_CASHOUTABLE_WALLET_CELL_NUMBER}    ${non_cashoutable_wallet_user['user_cell_number']}

    # Create user with gift wallet
    ${gift_wallet}    Create Dictionary
    ...    definition=${WALLET_TIME_BOUND_DEFINITION}
    ...    wallet_charge_amount=${USER_WALLET_GIFT_AMOUNT}

    @{gift_wallet_setup_list}    Create List
    ...    ${gift_wallet}

    ${gift_wallet_user}    Get Initialized User With Charged Wallet Based On Configuration
    ...    ${USER_CELL_NUMBER_PREFIX}
    ...    ${gift_wallet_setup_list}

    Set Suite Variable    ${GIFT_WALLET_USER_ID}    ${gift_wallet_user['user_id']}
    Set Suite Variable    ${GIFT_WALLET_CELL_NUMBER}    ${gift_wallet_user['user_cell_number']}

    # Create user with cashoutable and non-cashoutable charged wallet
    ${cashoutable_plus_non_cashoutable_amount}    Evaluate
    ...    ${USER_WALLET_CASHOUTABLE_AMOUNT} + ${USER_WALLET_NON_CASHOUTABLE_AMOUNT}

    ${default_wallet}    Create Dictionary
    ...    definition=${WALLET_DEFAULT_DEFINITION}
    ...    wallet_charge_amount=${cashoutable_plus_non_cashoutable_amount}
    ...    cashoutable_charge_amount=${USER_WALLET_CASHOUTABLE_AMOUNT}

    @{cashoutable_plus_non_cashoutable_wallet_setup_list}    Create List
    ...    ${default_wallet}

    ${cashoutable_plus_non_cashoutable_wallet_user}    Get Initialized User With Charged Wallet Based On Configuration
    ...    ${USER_CELL_NUMBER_PREFIX}
    ...    ${cashoutable_plus_non_cashoutable_wallet_setup_list}

    Set Suite Variable
    ...    ${CASHOUTABLE_PLUS_NON_CASHOUTABLE_WALLET_USER_ID}
    ...    ${cashoutable_plus_non_cashoutable_wallet_user['user_id']}
    Set Suite Variable
    ...    ${CASHOUTABLE_PLUS_NON_CASHOUTABLE_WALLET_CELL_NUMBER}
    ...    ${cashoutable_plus_non_cashoutable_wallet_user['user_cell_number']}
    Set Suite Variable
    ...    ${USER_WALLET_CASHOUTABLE_PLUSE_NON_CASHOUTABLE_AMOUNT}
    ...    ${cashoutable_plus_non_cashoutable_amount}

    # Create user with cashoutable and non-cashoutable and gift charged wallet
    ${default_wallet}    Create Dictionary
    ...    definition=${WALLET_DEFAULT_DEFINITION}
    ...    wallet_charge_amount=${cashoutable_plus_non_cashoutable_amount}
    ...    cashoutable_charge_amount=${USER_WALLET_CASHOUTABLE_AMOUNT}

    ${gift_wallet}    Create Dictionary
    ...    definition=${WALLET_TIME_BOUND_DEFINITION}
    ...    wallet_charge_amount=${USER_WALLET_GIFT_AMOUNT}

    @{cashoutable_plus_non_cashoutable_plus_gift_wallet_setup_list}    Create List
    ...    ${default_wallet}
    ...    ${gift_wallet}

    ${cashoutable_plus_non_cashoutable_plus_gift_wallet_user}
    ...    Get Initialized User With Charged Wallet Based On Configuration
    ...    ${USER_CELL_NUMBER_PREFIX}
    ...    ${cashoutable_plus_non_cashoutable_plus_gift_wallet_setup_list}

    ${cashoutable_plus_non_cashoutable_plus_gift_amount}    Evaluate
    ...    ${USER_WALLET_CASHOUTABLE_AMOUNT} + ${USER_WALLET_NON_CASHOUTABLE_AMOUNT} + ${USER_WALLET_GIFT_AMOUNT}

    Set Suite Variable
    ...    ${CASHOUTABLE_PLUS_NON_CASHOUTABLE_PLUS_GIFT_WALLET_USER_ID}
    ...    ${cashoutable_plus_non_cashoutable_plus_gift_wallet_user['user_id']}
    Set Suite Variable
    ...    ${CASHOUTABLE_PLUS_NON_CASHOUTABLE_PLUS_GIFT_WALLET_CELL_NUMBER}
    ...    ${cashoutable_plus_non_cashoutable_plus_gift_wallet_user['user_cell_number']}
    Set Suite Variable
    ...    ${USER_WALLET_CASHOUTABLE_PLUSE_NON_CASHOUTABLE_PLUS_GIFT_AMOUNT}
    ...    ${cashoutable_plus_non_cashoutable_plus_gift_amount}

    # Create user with default wallet for manual refund
    ${manual_refund_wallet}    Create Dictionary
    ...    definition=${WALLET_DEFAULT_DEFINITION}
    ...    wallet_charge_amount=${MANUAL_REFUND_INITIAL_WALLET_AMOUNT}
    ...    cashoutable_charge_amount=${MANUAL_REFUND_INITIAL_WALLET_AMOUNT}

    @{manual_refund_wallet_setup_list}    Create List
    ...    ${manual_refund_wallet}

    ${manual_refund_wallet_user}    Get Initialized User With Charged Wallet Based On Configuration
    ...    ${USER_CELL_NUMBER_PREFIX}
    ...    ${manual_refund_wallet_setup_list}

    Set Suite Variable    ${MANUAL_REFUND_USER_ID}    ${manual_refund_wallet_user['user_id']}
    Set Suite Variable    ${MANUAL_REFUND_CELL_NUMBER}    ${manual_refund_wallet_user['user_cell_number']}

    # Create user with cashoutable charged wallet for partial refund
    ${default_wallet}    Create Dictionary
    ...    definition=${WALLET_DEFAULT_DEFINITION}
    ...    wallet_charge_amount=${USER_WALLET_CASHOUTABLE_AMOUNT}
    ...    cashoutable_charge_amount=${USER_WALLET_CASHOUTABLE_AMOUNT}

    @{wallet_setup_list}    Create List
    ...    ${default_wallet}

    ${default_wallet_user}    Get Initialized User With Charged Wallet Based On Configuration
    ...    ${USER_CELL_NUMBER_PREFIX}
    ...    ${wallet_setup_list}

    Set Suite Variable    ${DEFAULT_ONLY_WALLET_PARTIAL_USER_ID}    ${default_wallet_user['user_id']}
    Set Suite Variable    ${DEFAULT_ONLY_WALLET_PARTIAL_CELL_NUMBER}    ${default_wallet_user['user_cell_number']}

    # Create user with non-cashoutable charged wallet for partial refund
    ${non_cashoutable_wallet}    Create Dictionary
    ...    definition=${WALLET_DEFAULT_DEFINITION}
    ...    wallet_charge_amount=${USER_WALLET_NON_CASHOUTABLE_AMOUNT}
    ...    cashoutable_charge_amount=0

    @{non_cashoutable_wallet_setup_list}    Create List
    ...    ${non_cashoutable_wallet}

    ${non_cashoutable_wallet_user}    Get Initialized User With Charged Wallet Based On Configuration
    ...    ${USER_CELL_NUMBER_PREFIX}
    ...    ${non_cashoutable_wallet_setup_list}

    Set Suite Variable    ${NON_CASHOUTABLE_WALLET_PARTIAL_USER_ID}    ${non_cashoutable_wallet_user['user_id']}
    Set Suite Variable
    ...    ${NON_CASHOUTABLE_WALLET_PARTIAL_CELL_NUMBER}
    ...    ${non_cashoutable_wallet_user['user_cell_number']}

    # Create user with gift wallet for partial refund
    ${gift_wallet}    Create Dictionary
    ...    definition=${WALLET_TIME_BOUND_DEFINITION}
    ...    wallet_charge_amount=${USER_WALLET_GIFT_AMOUNT}

    @{gift_wallet_setup_list}    Create List
    ...    ${gift_wallet}

    ${gift_wallet_user}    Get Initialized User With Charged Wallet Based On Configuration
    ...    ${USER_CELL_NUMBER_PREFIX}
    ...    ${gift_wallet_setup_list}

    Set Suite Variable    ${GIFT_WALLET_PARTIAL_USER_ID}    ${gift_wallet_user['user_id']}
    Set Suite Variable    ${GIFT_WALLET_PARTIAL_CELL_NUMBER}    ${gift_wallet_user['user_cell_number']}

    # Create user with cashoutable and non-cashoutable charged wallet for partial refund
    ${cashoutable_plus_non_cashoutable_amount}    Evaluate
    ...    ${USER_WALLET_CASHOUTABLE_AMOUNT} + ${USER_WALLET_NON_CASHOUTABLE_AMOUNT}

    ${default_wallet}    Create Dictionary
    ...    definition=${WALLET_DEFAULT_DEFINITION}
    ...    wallet_charge_amount=${cashoutable_plus_non_cashoutable_amount}
    ...    cashoutable_charge_amount=${USER_WALLET_CASHOUTABLE_AMOUNT}

    @{cashoutable_plus_non_cashoutable_wallet_setup_list}    Create List
    ...    ${default_wallet}

    ${cashoutable_plus_non_cashoutable_wallet_user}    Get Initialized User With Charged Wallet Based On Configuration
    ...    ${USER_CELL_NUMBER_PREFIX}
    ...    ${cashoutable_plus_non_cashoutable_wallet_setup_list}

    Set Suite Variable
    ...    ${CASHOUTABLE_PLUS_NON_CASHOUTABLE_WALLET_PARTIAL_USER_ID}
    ...    ${cashoutable_plus_non_cashoutable_wallet_user['user_id']}
    Set Suite Variable
    ...    ${CASHOUTABLE_PLUS_NON_CASHOUTABLE_WALLET_PARTIAL_CELL_NUMBER}
    ...    ${cashoutable_plus_non_cashoutable_wallet_user['user_cell_number']}
    Set Suite Variable
    ...    ${USER_WALLET_CASHOUTABLE_PLUSE_NON_CASHOUTABLE_AMOUNT}
    ...    ${cashoutable_plus_non_cashoutable_amount}

    # Create user with cashoutable and non-cashoutable and gift charged wallet for partial refund
    ${default_wallet}    Create Dictionary
    ...    definition=${WALLET_DEFAULT_DEFINITION}
    ...    wallet_charge_amount=${cashoutable_plus_non_cashoutable_amount}
    ...    cashoutable_charge_amount=${USER_WALLET_CASHOUTABLE_AMOUNT}

    ${gift_wallet}    Create Dictionary
    ...    definition=${WALLET_TIME_BOUND_DEFINITION}
    ...    wallet_charge_amount=${USER_WALLET_GIFT_AMOUNT}

    @{cashoutable_plus_non_cashoutable_plus_gift_wallet_setup_list}    Create List
    ...    ${default_wallet}
    ...    ${gift_wallet}

    ${cashoutable_plus_non_cashoutable_plus_gift_wallet_user}
    ...    Get Initialized User With Charged Wallet Based On Configuration
    ...    ${USER_CELL_NUMBER_PREFIX}
    ...    ${cashoutable_plus_non_cashoutable_plus_gift_wallet_setup_list}

    ${cashoutable_plus_non_cashoutable_plus_gift_amount}    Evaluate
    ...    ${USER_WALLET_CASHOUTABLE_AMOUNT} + ${USER_WALLET_NON_CASHOUTABLE_AMOUNT} + ${USER_WALLET_GIFT_AMOUNT}

    Set Suite Variable
    ...    ${CASHOUTABLE_PLUS_NON_CASHOUTABLE_PLUS_GIFT_WALLET_PARTIAL_USER_ID}
    ...    ${cashoutable_plus_non_cashoutable_plus_gift_wallet_user['user_id']}
    Set Suite Variable
    ...    ${CASHOUTABLE_PLUS_NON_CASHOUTABLE_PLUS_GIFT_WALLET_PARTIAL_CELL_NUMBER}
    ...    ${cashoutable_plus_non_cashoutable_plus_gift_wallet_user['user_cell_number']}
    Set Suite Variable
    ...    ${USER_WALLET_CASHOUTABLE_PLUSE_NON_CASHOUTABLE_PLUS_GIFT_PARTIAL_AMOUNT}
    ...    ${cashoutable_plus_non_cashoutable_plus_gift_amount}

    # Create business for purchase and refund
    ${spend_wallet_for_business}    Create Dictionary
    ...    definition=${B_WALLET_SPEND_DEFINITION}
    ...    wallet_charge_amount=0
    ...    currency=${CURRENCY_IRR}

    ${refund_wallet_for_business}    Create Dictionary
    ...    definition=${B_WALLET_REFUND_DEFINITION}
    ...    wallet_charge_amount=${BUSINESS_REFUND_WALLET_AMOUNT}
    ...    currency=${CURRENCY_IRR}

    ${refund_wallet_for_business_manual}    Create Dictionary
    ...    definition=${B_WALLET_REFUND_MANUAL_DEFINITION}
    ...    wallet_charge_amount=${BUSINESS_REFUND_MANUAL_WALLET_AMOUNT}
    ...    currency=${CURRENCY_IRR}

    @{wallet_list}    Create List
    ...    ${spend_wallet_for_business}
    ...    ${refund_wallet_for_business}
    ...    ${refund_wallet_for_business_manual}

    @{role_list}    Create List    ${USER_ROLE}    ${REFUND_USER_ROLE}    ${LOGIN_STAFF_ROLE}    ${REFUND_METHOD_ROLE}
    ${refund_business_obj}    Get Initialized Business With Charged Wallet Based On Configuration
    ...    ${wallet_list}
    ...    ${role_list}

    Set Suite Variable    ${REFUND_TEST_BUSINESS_ID}    ${refund_business_obj['business_id']}
    Set Suite Variable    ${REFUND_TEST_BUSINESS_USER_NAME}    ${refund_business_obj['user_name']}
    Set Suite Variable    ${REFUND_TEST_BUSINESS_PASS_WORD}    ${refund_business_obj['password']}

    # Set Wallet Gateway For Business
    @{active_gateways}    Create List    ${WALLET_GATEWAY_METHOD}

    Create Business Purchase And Ticket Setting For Purchase And Refund
    ...    ${REFUND_TEST_BUSINESS_ID}
    ...    @{active_gateways}

    # login by new business and set its access token as test variable for creating a purchase and refund
    Login For Business    ${REFUND_TEST_BUSINESS_USER_NAME}    ${REFUND_TEST_BUSINESS_PASS_WORD}
