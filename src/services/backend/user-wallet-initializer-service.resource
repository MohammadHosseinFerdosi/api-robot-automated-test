*** Settings ***
Library     Collections
Library     library/faker_utils.py    WITH NAME    FakerLibrary
Resource    services/backend/auth-service.resource
Resource    services/db/mongo-db-service.resource
Resource    apis/wallet-provider/admin/admin-wallets-businesses.resource
Resource    apis/nemo/admin/admin-wallets-businesses-cash-in.resource
Resource    apis/wallet-provider/transactions/post-transactions-business-transfer.resource
Resource    apis/wallet-provider/wallets/get-wallets-businesses-balance.resource
Resource    apis/wallet-provider/wallets/post-wallets-users.resource
Resource    apis/wallet-provider/transactions/post-transactions-payout.resource
Resource    apis/wallet-provider/wallets/get-wallets-users-balances.resource
Resource    apis/wallet-provider/wallets/get-wallets-businesses-balances.resource
Resource    apis/wallet-provider/wallets/get-wallets-users-balance.resource
Resource    apis/wallet-provider/wallets/get-wallets-users-total-balance.resource
Resource    apis/wallet-provider/transactions/post-transactions-spend-pay.resource
Resource    apis/wallet-provider/transactions/post-transactions-spend-verify.resource
Resource    apis/nemo/admin/post-admin-wallets-businesses-config-search.resource
Resource    apis/wallet-provider/admin/admin-wallets-users.resource
Resource    apis/wallet-provider/transactions/post-transactions-spend-payex.resource
Resource    services/backend/fresh-user-initializer-service.resource
Resource    services/backend/fresh-business-initializer-service.resource


*** Variables ***
@{CREATED_USER_LIST_IN_INITIAL_SECTION}     @{EMPTY}


*** Keywords ***
Get Initialized User With Charged Wallet Based On Configuration
    [Documentation]    Create user based on `${user_cell_number_prefix}`, wallet and payout to wallet based on `${wallets_config_list}`.
    ...    wallets config list should be list    of wallet object as dictionary. for exp:
    ...    a expired time-bound wallet: `definition=${WALLET_TIME_BOUND_DEFINITION}    should_be_expired=${True}    wallet_charge_amount=154`.
    ...    a unexpired time-bound wallet: `definition=${WALLET_TIME_BOUND_DEFINITION}    wallet_charge_amount=154`.
    ...    a default wallet: `definition=${WALLET_DEFAULT_DEFINITION}    wallet_charge_amount=154    cashoutable_charge_amount=20`.
    ...    --- NOTE: Only CONSTANT variables: `${WALLET_TIME_BOUND_DEFINITION}` & `${WALLET_DEFAULT_DEFINITION}` should be used as definition.
    [Arguments]
    ...    ${user_cell_number_prefix}
    ...    ${wallets_config_list}

    # Create user and assign id & cell number
    ${created_user_object}    Get A Fresh User    user_cell_number_prefix=${user_cell_number_prefix}

    ${created_user_with_wallet}    User Wallet Factory
    ...    ${created_user_object}
    ...    ${wallets_config_list}

    # Payout to created wallets based on wallet_cahrge_amount and set total_initial_amount
    ${created_user_with_charged_wallet}    Payout To User Wallet    ${created_user_with_wallet}

    RETURN    ${created_user_with_charged_wallet}

Create And Charge User Wallet Based On Configuration
    [Documentation]    create wallet and charge it for a `${user_id}`.
    ...    `${user_cell_number_prefix}` length must be 4 digit for example `0945` or `0911`.
    ...    wallets config list should be list of wallet object as dictionary. for exp:
    ...    a expired time-bound wallet: `definition=${WALLET_TIME_BOUND_DEFINITION}    should_be_expired=${True}    wallet_charge_amount=154`.
    ...    a unexpired time-bound wallet: `definition=${WALLET_TIME_BOUND_DEFINITION}    wallet_charge_amount=154`.
    ...    a default wallet: `definition=${WALLET_DEFAULT_DEFINITION}    wallet_charge_amount=154    cashoutable_charge_amount=20`.
    ...    --- NOTE: Only CONSTANT variables: `${WALLET_TIME_BOUND_DEFINITION}` & `${WALLET_DEFAULT_DEFINITION}` should be used as definition.
    [Arguments]    ${user_id}    ${wallets_config_list}

    # check existance of user in uaa db and extract cell number
    ${sql_query_result}    MySQL Fetch All
    ...    db_name=uaa_db
    ...    query=SELECT * FROM uaa_db.users WHERE user_id='${user_id}'
    Length Should Be    ${sql_query_result['body']}    length=1    msg=user with id: ${user_id} not found.
    ${user_cell_number}    Set Variable    ${sql_query_result['body'][0]['cell_number']}
    ${user_obj}    Create Dictionary    user_id=${user_id}    user_cell_number=${user_cell_number}

    ${user_with_wallet}    User Wallet Factory    ${user_obj}    ${wallets_config_list}

    # Payout to created wallets based on wallet_cahrge_amount and set total_initial_amount
    ${created_user_with_charged_wallet}    Payout To User Wallet    ${user_with_wallet}

    RETURN    ${created_user_with_charged_wallet}

User Wallet Factory
    [Tags]    robot:private
    [Arguments]    ${created_user_object}    ${wallets_config_list}

    ${wallet_expiration_delay_second}    Set Variable    40

    @{user_wallets}    Create List
    Set To Dictionary    ${created_user_object}    wallets=${user_wallets}
    # Create wallet based on definition and payout to wallet
    FOR    ${wallets_config}    IN    @{wallets_config_list}
        IF    'wallet_charge_amount' in ${wallets_config}
            ${wallet_charge_amount}    Set Variable    ${0}
            ${wallet_charge_amount}    Convert To Integer    ${wallets_config['wallet_charge_amount']}
        END

        IF    '${wallets_config['definition']}' == '${WALLET_TIME_BOUND_DEFINITION}'
            IF    'should_be_expired' in ${wallets_config}
                # set variable to true for enabling wait keyword for expiration wallet.
                ${is_expired_wallet_in_config}    Set Variable    ${True}
                # Create wallet definition
                ${wallet_name}    Generate Random String    8    [LOWER]
                ${current_time}    Get Time    epoch
                ${expiration_date}    Evaluate    (${current_time} + ${wallet_expiration_delay_second}) * 1000

                # Create user wallet based on definition
                ${created_wallet_name}    Create A Wallet For User
                ...    ${WALLET_TIME_BOUND_DEFINITION}
                ...    ${wallet_name}
                ...    ${created_user_object['user_id']}
                ...    expiration_date=${expiration_date}

                # Set created wallet details in result wallet list
                ${created_wallet}    Create Dictionary
                ...    name=${created_wallet_name}
                ...    type=${WALLET_TIME_BOUND_DEFINITION}
                ...    expired=${True}
                ...    initial_amount=${wallet_charge_amount}
                Append To List    ${user_wallets}    ${created_wallet}

                # if should_be_expired not in wallet
            ELSE
                ${wallet_name}    Generate Random String    8    [LOWER]
                ${current_time}    Get Time    epoch
                ${expiration_date}    Evaluate    (${current_time} * 1000) + 100000000

                # Create user wallet based on definition
                ${created_wallet_name}    Create A Wallet For User
                ...    ${WALLET_TIME_BOUND_DEFINITION}
                ...    ${wallet_name}
                ...    ${created_user_object['user_id']}
                ...    expiration_date=${expiration_date}
                # Set created wallet details in result wallet list
                ${created_wallet}    Create Dictionary
                ...    name=${created_wallet_name}
                ...    type=${WALLET_TIME_BOUND_DEFINITION}
                ...    initial_amount=${wallet_charge_amount}
                Append To List    ${user_wallets}    ${created_wallet}
            END
        ELSE IF    '${wallets_config['definition']}' == '${WALLET_DEFAULT_DEFINITION}'
            ${cashoutable_amount}    Set Variable If
            ...    "cashoutable_charge_amount" in ${wallets_config}
            ...    ${wallets_config['cashoutable_charge_amount']}
            ...    ${0}

            ${created_wallet}    Create Dictionary
            ...    name=${WALLET_DEFAULT_DEFINITION}
            ...    type=${WALLET_DEFAULT_DEFINITION}
            ...    initial_amount=${wallet_charge_amount}
            ...    cashoutable_amount=${cashoutable_amount}
            Append To List    ${user_wallets}    ${created_wallet}
        ELSE
            Fail    msg=Wallet definition undefined in wallet list: ${wallets_config}
        END
    END

    RETURN    ${created_user_object}

Get A Fresh User
    [Documentation]    Return a fresh user like this dictionary: {user_id: abcd, user_cell_number: 09452333333}.
    ...    NOTE: `${user_cell_number_prefix}` length must be equal 4 for example `0945` or `0911`.
    [Arguments]    ${user_cell_number_prefix}

    ${cell_number_prefix_length}    Get Length    ${user_cell_number_prefix}
    IF    ${cell_number_prefix_length} != 4
        Fail    msg=Cell Number Prefix Length Must Be Equal 4 but Found: ${user_cell_number_prefix}.
    END

    ${result}    Generate A Fresh User    predefined_cell_number_prefix=${user_cell_number_prefix}

    Set To User Charge List    ${result['user_id']}    ${CUSTOMER_TYPE}
    RETURN    ${result}

Create A Wallet For User
    [Tags]    robot:private
    [Arguments]    ${definition_name}    ${wallet_name}    ${user_id}    ${expiration_date}

    ${wallet_based_on_definition}    Set Variable    ${definition_name}_${wallet_name}
    ${result}    POST Wallets Users
    ...    ${MICROSERVICE_SIDE}
    ...    ${user_id}
    ...    ${wallet_based_on_definition}
    ...    ${expiration_date}

    Should Be Equal As Integers
    ...    ${result['status_code']}
    ...    200
    ...    msg=Failed to create wallet: ${wallet_name} for user: ${user_id}. result: ${result['body']}
    RETURN    ${wallet_based_on_definition}

Payout To User Wallet
    [Tags]    robot:private
    [Arguments]    ${initialized_user_object}

    ${total_initial_amount}    Set Variable    ${0}
    ${description}    Set Variable
    ...    Payout from test business for test: ${SUITE NAME}
    FOR    ${wallet}    IN    @{initialized_user_object['wallets']}
        IF    'initial_amount' in ${wallet} and ${wallet['initial_amount']} > ${0}
            ${cashoutable_amount}    Set Variable If
            ...    "cashoutable_amount" in ${wallet}
            ...    ${wallet['cashoutable_amount']}
            ...    ${0}

            ${sale_tracking_code}    Generate Random String    16
            ${result}    POST Transactions Payout
            ...    ${MICROSERVICE_SIDE}
            ...    ${wallet['initial_amount']}
            ...    ${BUSINESS_ID_FOR_CHARGE_TEST_WALLETS}
            ...    ${BUSINESS_WALLET_FOR_CHARGE_TEST_WALLETS}
            ...    ${initialized_user_object['user_id']}
            ...    ${wallet['name']}
            ...    ${cashoutable_amount}
            ...    ${sale_tracking_code}
            ...    ${description}

            Should Be Equal As Integers
            ...    ${result['status_code']}
            ...    200
            ...    msg=Failed to payout. result: ${result['body']}

            ${total_initial_amount}    Evaluate    ${total_initial_amount} + ${wallet['initial_amount']}
        END
    END

    Set To Dictionary    ${initialized_user_object}    total_initial_amount=${total_initial_amount}

    RETURN    ${initialized_user_object}

Give User Wallet Balance
    [Tags]    robot:private
    [Arguments]    ${wallet_user_id}    ${wallet_name}

    ${response}    GET Wallets Users Balance    ${MICROSERVICE_SIDE}    ${wallet_user_id}    ${wallet_name}
    RETURN    ${response['body']}

Wait For Expirable Wallet End Time
    [Tags]    robot:private
    # TODO: User another way to stop test execution
    # https://github.com/robotframework/HowToWriteGoodTestCases/blob/master/HowToWriteGoodTestCases.rst#avoid-sleeping
    [Arguments]    ${expire_delay_second}
    ${expire_delay_second}    Catenate    ${expire_delay_second}    s
    Sleep    ${expire_delay_second}    reason=wait for wallet expiration time.

Get Initialized Business With Charged Wallet Based On Configuration
    [Documentation]    Create business, wallet and charge it based on `${wallets_config_list}`.
    ...    wallets config list could be ${EMPTY} for only createing a business without any wallet.
    ...    wallet confilg exp: [{ `definition=${B_WALLET_REFUND_DEFINITION}    wallet_charge_amount=154].
    ...    *** NOTE: FOR DEFITNITION JUST USE BUSINESS WALLET DEFINITION IN CONSTANT FILE. ***
    [Arguments]
    ...    ${wallets_config_list}=@{EMPTY}
    ...    ${role_list}=@{EMPTY}
    ...    ${zone}=${EMPTY}

    # Create business and get business object
    ${created_business_object}    Create Business For Initialize    ${role_list}    ${zone}
    @{business_wallets}    Create List
    Set To Dictionary    ${created_business_object}    wallets=${business_wallets}

    # If wallet config list was empty, just return created business object
    ${wallets_config_list_length}    Get Length    ${wallets_config_list}
    IF    ${wallets_config_list} == @{EMPTY}
        RETURN    ${created_business_object}
    ELSE
        FOR    ${wallets_config}    IN    @{wallets_config_list}
            Create Business Wallet For Initialize
            ...    ${created_business_object['business_id']}
            ...    ${wallets_config['definition']}

            ${created_business_wallet}    Create Dictionary    name=${wallets_config['definition']}

            IF    'wallet_charge_amount' in ${wallets_config} and ${wallets_config['wallet_charge_amount']} > ${0}
                Charge Business Wallet For Initialize
                ...    ${created_business_object['business_id']}
                ...    ${wallets_config['definition']}
                ...    ${wallets_config['wallet_charge_amount']}
                ...    ${wallets_config['currency']}

                Set To Dictionary
                ...    ${created_business_wallet}
                ...    initial_amount=${wallets_config['wallet_charge_amount']}
            ELSE
                Set To Dictionary    ${created_business_wallet}    initial_amount=${0}
            END

            Append To List    ${business_wallets}    ${created_business_wallet}
        END
    END

    RETURN    ${created_business_object}

Create Business For Initialize
    [Arguments]    ${role_list}=${EMPTY}    ${zone}=${EMPTY}

    ${business_object}    Generate A Fresh Business    role_list=${role_list}    zone=${zone}

    # For teardown section, created business should be set as user charge list
    Set To User Charge List    ${business_object['business_id']}    ${BUSINESS_TYPE}
    RETURN    ${business_object}

Create Business Wallet For Initialize
    [Tags]    robot:private
    [Arguments]    ${business_id}    ${wallet_name}

    ${is_wallet_added}    POST Admin Wallets Businesses
    ...    ${MICROSERVICE_SIDE}
    ...    ${business_id}
    ...    ${wallet_name}

    Should Be True    ${is_wallet_added}    msg=Wallet Not Added in Busienss.

Charge Business Wallet For Initialize
    [Tags]    robot:private
    [Arguments]    ${destination_business_id}    ${destination_wallet_name}    ${amount}    ${currency}
    ${source_business_wallet}    Find Charge Business Wallet Based on Currency    ${currency}
    ${tracking_code}    Generate Random String    18    [LOWER]
    ${transfer_result}    POST Transactions Business-Transfer
    ...    ${MICROSERVICE_SIDE}
    ...    ${tracking_code}
    ...    ${BUSINESS_ID_FOR_CHARGE_TEST_WALLETS}
    ...    ${source_business_wallet}
    ...    ${destination_business_id}
    ...    ${destination_wallet_name}
    ...    ${amount}
    ...    ${currency}

    Should Be Equal As Integers
    ...    ${transfer_result['status_code']}
    ...    200
    ...    msg=Failed to charge business wallet. result: ${transfer_result['body']}

Set To User Charge List
    [Documentation]    Create a user list for gathering all wallet balances. `${user_type}` should be `${CUSTOMER_TYPE}` or `${BUSINESS_TYPE}`
    [Tags]    robot:private
    [Arguments]    ${user_id}    ${user_type}

    &{user_data}    Create Dictionary    user_id=${user_id}    type=${user_type}
    Append To List    ${CREATED_USER_LIST_IN_INITIAL_SECTION}    ${user_data}

Collect Handler
    [Documentation]    This handler collects all the wallets for each user inside the ${user_list} based on the users.type and the ${currency}
    [Tags]    robot:private
    [Arguments]    ${user_list}    ${currency}

    FOR    ${user}    IN    @{user_list}
        IF    '${user['type']}' == '${CUSTOMER_TYPE}'
            ${user_wallet_balance_result}    GET Admin Wallets Users
            ...    ${MICROSERVICE_SIDE}
            ...    ${user['user_id']}
            ...    ${currency}
            ${user_wallet_balance}    Set Variable    ${user_wallet_balance_result['response_body']}
            ${balance_list}    Get From Dictionary    ${user_wallet_balance}    balances
            ${balance_length}    Get Length    ${balance_list}
            IF    ${balance_length}>0
                FOR    ${items}    IN RANGE    ${0}    ${balance_length}    ${1}
                    IF    ${user_wallet_balance['balances'][${items}]['balance']} > ${0}
                        Spend To Business Wallet For Tear Down
                        ...    ${user['user_id']}
                        ...    ${user_wallet_balance['balances'][${items}]['balance']}
                        ...    ${user_wallet_balance['balances'][${items}]['walletName']}
                        ...    ${currency}
                    END
                END
            END
        ELSE IF    '${user['type']}' == '${BUSINESS_TYPE}'
            Transfer To Business Wallet For Tear Down    ${user['user_id']}
        END
    END

Collect All Amount For Tear Down
    [Documentation]    Based on `${USER_CHARGE_LIST}`, get total balance and payback to
    ...    automation test business wallet.
    ...    The collect can be called on users, build outside this service as well.
    ...    They should however follow the instruction for the @{CREATED_USER_LIST_IN_INITIAL_SECTION} List.
    ...    It is a List similar to [dic1, dic2, ...] where each dic1 is a dictionary such as:
    ...    {'user_id' : 'user_type'} or {'user_id', ${CUSTOMER_TYPE}} , ...
    [Arguments]    ${additional_user_lists}=${EMPTY}
    # TODO: Expired gift wallet amount should be collected
    Collect Handler    user_list=${CREATED_USER_LIST_IN_INITIAL_SECTION}    currency=${CURRENCY_IRR}
    Collect Handler    user_list=${CREATED_USER_LIST_IN_INITIAL_SECTION}    currency=${CURRENCY_CRR}
    ${length_additional_list}    Get Length    ${additional_user_lists}
    IF    '${length_additional_list}'!='0'
        Collect Handler    user_list=${additional_user_lists}    currency=${CURRENCY_IRR}
        Collect Handler    user_list=${additional_user_lists}    currency=${CURRENCY_CRR}
    END

Spend To Business Wallet For Tear Down
    [Tags]    robot:private
    [Arguments]    ${user_id}    ${user_amount}    ${wallet_name}    ${currency}

    # Create user list for spend transaction
    @{source_user_list}    Create List
    ${user_source}    Create Dictionary
    ...    userId=${user_id}
    ...    walletName=${wallet_name}
    ...    amount=${user_amount}
    Append To List    ${source_user_list}    ${user_source}
    # Create business list for spend transaction
    @{spend_businesses_list}    Create List
    IF    '${currency}' == '${CURRENCY_IRR}'
        ${main_business}    Create Dictionary
        ...    businessId=${BUSINESS_ID_FOR_CHARGE_TEST_WALLETS}
        ...    walletName=${BUSINESS_WALLET_FOR_CHARGE_TEST_WALLETS}
        ...    amount=${user_amount}
        Append To List    ${spend_businesses_list}    ${main_business}
    ELSE IF    '${currency}' == '${CURRENCY_CRR}'
        ${main_business}    Create Dictionary
        ...    businessId=${BUSINESS_ID_FOR_CHARGE_TEST_WALLETS}
        ...    walletName=${BUSINESS_WALLET_FOR_CHARGE_CREDIT_TEST_WALLETS}
        ...    amount=${user_amount}
        Append To List    ${spend_businesses_list}    ${main_business}
    END

    ${pay_result}    POST Transactions Spend Payex
    ...    ${MICROSERVICE_SIDE}
    ...    ${source_user_list}
    ...    ${spend_businesses_list}
    ...    ${currency}

    Should Be Equal As Integers
    ...    ${pay_result['status_code']}
    ...    200
    ...    msg=Failed to spend pay. result: ${pay_result['body']}

    ${verify_result}    POST Transactions Spend Verify
    ...    ${MICROSERVICE_SIDE}
    ...    ${pay_result['body']['trackingCode']}
    ...    ${pay_result['body']['confirmationCode']}

    Should Be Equal As Integers
    ...    ${verify_result['status_code']}
    ...    200
    ...    msg=Failed to spend verify. result: ${verify_result['body']}

Transfer To Business Wallet For Tear Down
    [Documentation]    Get all wallets of a business and transfer to origin business wallet
    [Arguments]    ${business_id}
    ${value_list}    Create List    ${business_id}
    ${restriction}    Create Dictionary    type=collection    field=businessIds    values=${value_list}
    ${restriction_list}    Create List    ${restriction}
    ${order_list}    Create List
    ${business_wallet_list}    POST Admin Wallets businesses config Search
    ...    ${MICROSERVICE_SIDE}
    ...    ${restriction_list}
    ...    ${order_list}
    ...    user_id=test-staff-user

    FOR    ${business_wallet}    IN    @{business_wallet_list['body']['wallets']}
        ${business_balance_result}    GET Wallets Businesses Balance
        ...    ${MICROSERVICE_SIDE}
        ...    ${business_id}
        ...    ${business_wallet['walletName']}

        IF    ${business_balance_result['body']['balance']} > 0
            ${destination_wallet_name}    Find Charge Business Wallet Based on Currency
            ...    ${business_balance_result['body']['currency']}

            ${transfer_tracking_code}    Generate Random String    12
            ${transfer_result}    POST Transactions Business-Transfer
            ...    ${MICROSERVICE_SIDE}
            ...    ${transfer_tracking_code}
            ...    ${business_id}
            ...    ${business_wallet['walletName']}
            ...    ${BUSINESS_ID_FOR_CHARGE_TEST_WALLETS}
            ...    ${destination_wallet_name}
            ...    ${business_balance_result['body']['balance']}
            ...    ${business_balance_result['body']['currency']}

            Should Be Equal As Integers
            ...    ${transfer_result['status_code']}
            ...    200
            ...    msg=Failed to collect business wallet amount. result: ${transfer_result['body']}
        END
    END

Get Wallet Count For A User
    [Arguments]    ${user_id}
    &{query_find}    Create Dictionary    ownerId=${user_id}
    ${result}    Mongo Db Count Documents    wallet_provider_db    wallets    ${query_find}
    RETURN    ${result['body']['count']}

Find Charge Business Wallet Based on Currency
    [Arguments]    ${currency}
    IF    '${currency}' == '${CURRENCY_IRR}'
        ${business_wallet_name}    Set Variable    ${BUSINESS_WALLET_FOR_CHARGE_TEST_WALLETS}
    ELSE IF    '${currency}' == '${CURRENCY_CRR}'
        ${business_wallet_name}    Set Variable    ${BUSINESS_WALLET_FOR_CHARGE_CREDIT_TEST_WALLETS}
    END

    RETURN    ${business_wallet_name}
