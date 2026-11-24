*** Settings ***
Library         library/faker_utils.py    WITH NAME    FakerLibrary
Library         Collections
Resource        apis/wallet-provider/transactions/post-transactions-spend-payex.resource
Resource        apis/wallet-provider/transactions/post-transactions-spend-verify.resource
Resource        apis/wallet-provider/wallets/get-wallets-users-balances.resource
Resource        apis/wallet-provider/wallets/get-wallets-users-balance.resource
Resource        apis/wallet-provider/wallets/get-wallets-businesses-balance.resource
Variables       data/wallet/transactions/transactions-spend-custom-source-variables.yaml


*** Keywords ***
Custom Source Spend From Default Wallet Of Multi Types Wallet User
    # Calculating spend amount based on source wallet
    FOR    ${created_wallet}    IN    @{DEFAULT_WALLET_AS_SOURCE_USER['wallets']}
        IF    '${created_wallet['type']}' == '${WALLET_DEFAULT_DEFINITION}'
            ${spend_amount}    Set Variable    ${created_wallet['initial_amount']}
            ${source_wallet_name}    Set Variable    ${created_wallet['name']}
            BREAK
        END
    END

    ${source}    Create Dictionary
    ...    userId=${DEFAULT_WALLET_AS_SOURCE_USER['user_id']}
    ...    walletName=${source_wallet_name}
    ...    amount=${spend_amount}
    ${source_list}    Create List    ${source}

    ${destination}    Create Dictionary
    ...    businessId=${INIT_BUSINESS_ID}
    ...    walletName=${B_WALLET_SPEND_DEFINITION}
    ...    amount=${spend_amount}
    ${destination_list}    Create List    ${destination}

    Pay And Verify
    ...    ${spend_amount}
    ...    ${source_list}
    ...    ${destination_list}

    ${CURRENT_USER_OBJECT}    Set Variable    ${DEFAULT_WALLET_AS_SOURCE_USER}
    Set Test Variable    ${CURRENT_USER_OBJECT}

Custom Source Spend From Unexpired Gift Wallet Of Multi Types Wallet User
    # Calculating spend amount based on source wallet
    FOR    ${created_wallet}    IN    @{UNEXPIRED_WALLET_AS_SOURCE_USER['wallets']}
        IF    ('${created_wallet['type']}' == '${WALLET_TIME_BOUND_DEFINITION}') and ('expired' not in ${created_wallet}) and (${created_wallet['initial_amount']} > 0)
            ${spend_amount}    Set Variable    ${created_wallet['initial_amount']}
            ${source_wallet_name}    Set Variable    ${created_wallet['name']}
            BREAK
        END
    END

    ${source}    Create Dictionary
    ...    userId=${UNEXPIRED_WALLET_AS_SOURCE_USER['user_id']}
    ...    walletName=${source_wallet_name}
    ...    amount=${spend_amount}
    ${source_list}    Create List    ${source}

    ${destination}    Create Dictionary
    ...    businessId=${INIT_BUSINESS_ID}
    ...    walletName=${B_WALLET_SPEND_DEFINITION}
    ...    amount=${spend_amount}
    ${destination_list}    Create List    ${destination}

    Pay And Verify
    ...    ${spend_amount}
    ...    ${source_list}
    ...    ${destination_list}

    ${CURRENT_USER_OBJECT}    Set Variable    ${UNEXPIRED_WALLET_AS_SOURCE_USER}
    Set Test Variable    ${CURRENT_USER_OBJECT}

Custom Source Spend From Expired Gift Wallet Of Multi Types Wallet User
    # Calculating spend amount based on source wallet
    FOR    ${created_wallet}    IN    @{INVALID_SCENARIO_SOURCE_USER['wallets']}
        IF    'expired' in ${created_wallet}
            ${spend_amount}    Set Variable    ${created_wallet['initial_amount']}
            ${source_wallet_name}    Set Variable    ${created_wallet['name']}
            BREAK
        END
    END

    ${source}    Create Dictionary
    ...    userId=${INVALID_SCENARIO_SOURCE_USER['user_id']}
    ...    walletName=${source_wallet_name}
    ...    amount=${spend_amount}
    ${source_list}    Create List    ${source}

    ${destination}    Create Dictionary
    ...    businessId=${INIT_BUSINESS_ID}
    ...    walletName=${B_WALLET_SPEND_DEFINITION}
    ...    amount=${spend_amount}
    ${destination_list}    Create List    ${destination}

    Pay And Verify
    ...    ${spend_amount}
    ...    ${source_list}
    ...    ${destination_list}

    ${CURRENT_USER_OBJECT}    Set Variable    ${INVALID_SCENARIO_SOURCE_USER}
    Set Test Variable    ${CURRENT_USER_OBJECT}

Custom Source Spend From Zero Amount Gift Wallet Of Multi Types Wallet User
    ${spend_amount}    Set Variable    20
    # Find wallet name for creating source list
    FOR    ${created_wallet}    IN    @{INVALID_SCENARIO_SOURCE_USER['wallets']}
        IF    ('${created_wallet['type']}' == '${WALLET_TIME_BOUND_DEFINITION}') and ('expired' not in ${created_wallet}) and (${created_wallet['initial_amount']} == 0)
            ${source_wallet_name}    Set Variable    ${created_wallet['name']}
            ${source}    Create Dictionary
            ...    userId=${INVALID_SCENARIO_SOURCE_USER['user_id']}
            ...    walletName=${source_wallet_name}
            ...    amount=${spend_amount}
            ${source_list}    Create List    ${source}
            BREAK
        END
    END

    ${destination}    Create Dictionary
    ...    businessId=${INIT_BUSINESS_ID}
    ...    walletName=${B_WALLET_SPEND_DEFINITION}
    ...    amount=${spend_amount}
    ${destination_list}    Create List    ${destination}

    Pay And Verify
    ...    ${spend_amount}
    ...    ${source_list}
    ...    ${destination_list}

    ${CURRENT_USER_OBJECT}    Set Variable    ${INVALID_SCENARIO_SOURCE_USER}
    Set Test Variable    ${CURRENT_USER_OBJECT}

Custom Source Spend From Default Wallet And Expired Gift Wallet Of Multi Types Wallet User
    # Find wallet name
    FOR    ${created_wallet}    IN    @{INVALID_SCENARIO_SOURCE_USER['wallets']}
        IF    'expired' in ${created_wallet}
            ${expired_wallet_name}    Set Variable    ${created_wallet['name']}
            BREAK
        END
    END

    ${spend_amount}    Set Variable    100
    ${default_source}    Create Dictionary
    ...    userId=${INVALID_SCENARIO_SOURCE_USER['user_id']}
    ...    walletName=${WALLET_DEFAULT_DEFINITION}
    ...    amount=50
    ${expired_source}    Create Dictionary
    ...    userId=${INVALID_SCENARIO_SOURCE_USER['user_id']}
    ...    walletName=${expired_wallet_name}
    ...    amount=50
    ${source_list}    Create List    ${default_source}    ${expired_source}

    ${destination}    Create Dictionary
    ...    businessId=${INIT_BUSINESS_ID}
    ...    walletName=${B_WALLET_SPEND_DEFINITION}
    ...    amount=${spend_amount}
    ${destination_list}    Create List    ${destination}

    Pay And Verify
    ...    ${spend_amount}
    ...    ${source_list}
    ...    ${destination_list}

    ${CURRENT_USER_OBJECT}    Set Variable    ${INVALID_SCENARIO_SOURCE_USER}
    Set Test Variable    ${CURRENT_USER_OBJECT}

Custom Source Spend From Default Wallet And Unexpired Gift Wallet Of Multi Types Wallet User
    # Calculating spend amount based on default and unexpired wallet amount
    FOR    ${created_wallet}    IN    @{DEFAULT_AND_UNEXPIRED_WALLET_AS_SOURCE_USER['wallets']}
        IF    ('${created_wallet['type']}' == '${WALLET_TIME_BOUND_DEFINITION}' and 'expired' not in ${created_wallet} and ${created_wallet['initial_amount']} > 0)
            ${unexpired_wallet_init_amount}    Set Variable    ${created_wallet['initial_amount']}
            ${unexpired_wallet_name}    Set Variable    ${created_wallet['name']}
        END
        IF    '${created_wallet['type']}' == '${WALLET_DEFAULT_DEFINITION}'
            ${default_wallet_init_amount}    Set Variable    ${created_wallet['initial_amount']}
        END
    END

    ${expected_remaining_amount}    Set Variable    10
    ${spend_amount}    Evaluate
    ...    (${default_wallet_init_amount} + ${unexpired_wallet_init_amount}) - ${expected_remaining_amount}
    ${unexpired_wallet_spend_amount}    Evaluate    ${unexpired_wallet_init_amount} - ${expected_remaining_amount}
    ${unexpired_source}    Create Dictionary
    ...    userId=${DEFAULT_AND_UNEXPIRED_WALLET_AS_SOURCE_USER['user_id']}
    ...    walletName=${unexpired_wallet_name}
    ...    amount=${unexpired_wallet_spend_amount}
    ${default_source}    Create Dictionary
    ...    userId=${DEFAULT_AND_UNEXPIRED_WALLET_AS_SOURCE_USER['user_id']}
    ...    walletName=${WALLET_DEFAULT_DEFINITION}
    ...    amount=${default_wallet_init_amount}
    ${source_list}    Create List    ${unexpired_source}    ${default_source}

    ${destination}    Create Dictionary
    ...    businessId=${INIT_BUSINESS_ID}
    ...    walletName=${B_WALLET_SPEND_DEFINITION}
    ...    amount=${spend_amount}
    ${destination_list}    Create List    ${destination}

    # Based on order this variable should be remained in gift wallet, set as test var for assertion section
    Set Test Variable    ${EXPECTED_REMAINING_AMOUNT}
    Pay And Verify
    ...    ${spend_amount}
    ...    ${source_list}
    ...    ${destination_list}

    ${CURRENT_USER_OBJECT}    Set Variable    ${DEFAULT_AND_UNEXPIRED_WALLET_AS_SOURCE_USER}
    Set Test Variable    ${CURRENT_USER_OBJECT}

Custom Source Spend From Default Wallet
# Calculating spend amount based on default wallet amount
    ${spend_amount}    Set Variable    ${DEFAULT_ONLY_WALLET_USER['wallets'][0]['initial_amount']}

    ${source}    Create Dictionary
    ...    userId=${DEFAULT_ONLY_WALLET_USER['user_id']}
    ...    walletName=${WALLET_DEFAULT_DEFINITION}
    ...    amount=${spend_amount}
    ${source_list}    Create List    ${source}

    ${destination}    Create Dictionary
    ...    businessId=${INIT_BUSINESS_ID}
    ...    walletName=${B_WALLET_SPEND_DEFINITION}
    ...    amount=${spend_amount}
    ${destination_list}    Create List    ${destination}

    Pay And Verify
    ...    ${spend_amount}
    ...    ${source_list}
    ...    ${destination_list}

    ${CURRENT_USER_OBJECT}    Set Variable    ${DEFAULT_ONLY_WALLET_USER}
    Set Test Variable    ${CURRENT_USER_OBJECT}

Custom Source Spend From Unexpired Gift Wallet
    FOR    ${created_wallet}    IN    @{GIFT_ONLY_WALLET_USER['wallets']}
        IF    'expired' not in ${created_wallet}
            ${spend_amount}    Set Variable    ${created_wallet['initial_amount']}
            ${source_wallet_name}    Set Variable    ${created_wallet['name']}
            BREAK
        END
    END

    ${source}    Create Dictionary
    ...    userId=${GIFT_ONLY_WALLET_USER['user_id']}
    ...    walletName=${source_wallet_name}
    ...    amount=${spend_amount}
    ${source_list}    Create List    ${source}

    ${destination}    Create Dictionary
    ...    businessId=${INIT_BUSINESS_ID}
    ...    walletName=${B_WALLET_SPEND_DEFINITION}
    ...    amount=${spend_amount}
    ${destination_list}    Create List    ${destination}

    Pay And Verify
    ...    ${spend_amount}
    ...    ${source_list}
    ...    ${destination_list}

    ${CURRENT_USER_OBJECT}    Set Variable    ${GIFT_ONLY_WALLET_USER}
    Set Test Variable    ${CURRENT_USER_OBJECT}

Custom Source Spend From Default Wallet And Unexpired Gift Wallet With Upper Spend Amount
    # Calculating spend amount based on default and unexpired wallet amount
    FOR    ${created_wallet}    IN    @{INVALID_SCENARIO_SOURCE_USER['wallets']}
        IF    ('${created_wallet['type']}' == '${WALLET_TIME_BOUND_DEFINITION}' and 'expired' not in ${created_wallet} and ${created_wallet['initial_amount']} > 0)
            ${unexpired_wallet_init_amount}    Set Variable    ${created_wallet['initial_amount']}
            ${unexpired_wallet_name}    Set Variable    ${created_wallet['name']}
        END
        IF    '${created_wallet['type']}' == '${WALLET_DEFAULT_DEFINITION}'
            ${default_wallet_init_amount}    Set Variable    ${created_wallet['initial_amount']}
        END
    END

    ${default_wallet_spend_amount}    Evaluate    ${default_wallet_init_amount} + 10
    ${spend_amount}    Evaluate    ${default_wallet_spend_amount} + ${unexpired_wallet_init_amount}

    ${unexpired_source}    Create Dictionary
    ...    userId=${INVALID_SCENARIO_SOURCE_USER['user_id']}
    ...    walletName=${unexpired_wallet_name}
    ...    amount=${unexpired_wallet_init_amount}
    ${default_source}    Create Dictionary
    ...    userId=${INVALID_SCENARIO_SOURCE_USER['user_id']}
    ...    walletName=${WALLET_DEFAULT_DEFINITION}
    ...    amount=${default_wallet_spend_amount}
    ${source_list}    Create List    ${unexpired_source}    ${default_source}

    ${destination}    Create Dictionary
    ...    businessId=${INIT_BUSINESS_ID}
    ...    walletName=${B_WALLET_SPEND_DEFINITION}
    ...    amount=${spend_amount}
    ${destination_list}    Create List    ${destination}

    Pay And Verify
    ...    ${spend_amount}
    ...    ${source_list}
    ...    ${destination_list}

    ${CURRENT_USER_OBJECT}    Set Variable    ${INVALID_SCENARIO_SOURCE_USER}
    Set Test Variable    ${CURRENT_USER_OBJECT}

Custom Source Spend From Default Wallet And Unexpired Gift Wallet With Unmatched Spend Amount
    # Calculating spend amount
    FOR    ${created_wallet}    IN    @{INVALID_SCENARIO_SOURCE_USER['wallets']}
        IF    ('${created_wallet['type']}' == '${WALLET_TIME_BOUND_DEFINITION}' and 'expired' not in ${created_wallet} and ${created_wallet['initial_amount']} > 0)
            ${unexpired_wallet_init_amount}    Set Variable    ${created_wallet['initial_amount']}
            ${unexpired_wallet_name}    Set Variable    ${created_wallet['name']}
        END
        IF    '${created_wallet['type']}' == '${WALLET_DEFAULT_DEFINITION}'
            ${default_wallet_init_amount}    Set Variable    ${created_wallet['initial_amount']}
        END
    END

    # Default spend amount unmatched with main spend amount
    ${default_wallet_spend_amount}    Evaluate    ${default_wallet_init_amount} - 10
    ${spend_amount}    Evaluate    ${default_wallet_init_amount} + ${unexpired_wallet_init_amount}

    ${unexpired_source}    Create Dictionary
    ...    userId=${INVALID_SCENARIO_SOURCE_USER['user_id']}
    ...    walletName=${unexpired_wallet_name}
    ...    amount=${unexpired_wallet_init_amount}
    ${default_source}    Create Dictionary
    ...    userId=${INVALID_SCENARIO_SOURCE_USER['user_id']}
    ...    walletName=${WALLET_DEFAULT_DEFINITION}
    ...    amount=${default_wallet_spend_amount}
    ${source_list}    Create List    ${unexpired_source}    ${default_source}

    ${destination}    Create Dictionary
    ...    businessId=${INIT_BUSINESS_ID}
    ...    walletName=${B_WALLET_SPEND_DEFINITION}
    ...    amount=${spend_amount}
    ${destination_list}    Create List    ${destination}

    Pay And Verify
    ...    ${spend_amount}
    ...    ${source_list}
    ...    ${destination_list}

    ${CURRENT_USER_OBJECT}    Set Variable    ${INVALID_SCENARIO_SOURCE_USER}
    Set Test Variable    ${CURRENT_USER_OBJECT}

Custom Source Spend From Default Wallet Of Without Wallet User
    ${spend_amount}    Set Variable    100
    ${source}    Create Dictionary
    ...    userId=${WITHOUT_WALLET_USER['user_id']}
    ...    walletName=${WALLET_DEFAULT_DEFINITION}
    ...    amount=${spend_amount}
    ${source_list}    Create List    ${source}

    ${destination}    Create Dictionary
    ...    businessId=${INIT_BUSINESS_ID}
    ...    walletName=${B_WALLET_SPEND_DEFINITION}
    ...    amount=${spend_amount}
    ${destination_list}    Create List    ${destination}

    Pay And Verify
    ...    ${spend_amount}
    ...    ${source_list}
    ...    ${destination_list}

    ${CURRENT_USER_OBJECT}    Set Variable    ${WITHOUT_WALLET_USER}
    Set Test Variable    ${CURRENT_USER_OBJECT}

Spend With Empty Custom Source Spend
    ${spend_amount}    Set Variable    50
    ${source_list}    Create List    @{EMPTY}

    ${destination}    Create Dictionary
    ...    businessId=${INIT_BUSINESS_ID}
    ...    walletName=${B_WALLET_SPEND_DEFINITION}
    ...    amount=${spend_amount}
    ${destination_list}    Create List    ${destination}

    Pay And Verify
    ...    ${spend_amount}
    ...    ${source_list}
    ...    ${destination_list}

    ${CURRENT_USER_OBJECT}    Set Variable    ${INVALID_SCENARIO_SOURCE_USER}
    Set Test Variable    ${CURRENT_USER_OBJECT}

Pay And Verify
    [Documentation]    Spend Pay And Verify it, set spend data as test variable for other keywords.
    [Tags]    robot:private
    [Arguments]    ${spend_amount}    ${source_list}    ${destination_list}

    ${pay_result}    POST Transactions Spend Payex
    ...    ${MICROSERVICE_SIDE}
    ...    ${source_list}
    ...    ${destination_list}
    ...    ${CURRENCY_IRR}

    IF    ${pay_result['status_code']} == 200
        ${verify_result}    POST Transactions Spend Verify
        ...    ${MICROSERVICE_SIDE}
        ...    ${pay_result['body']['trackingCode']}
        ...    ${pay_result['body']['confirmationCode']}
        Should Be Equal As Integers
        ...    ${verify_result['status_code']}
        ...    200
        ...    msg=Failed to verify spend with error: ${verify_result}
        # Business wallet for destination spend is shared between all test cases and
        # after successfull spend, expected balance should be updated based on spend amount.
        ${B_WALLET_SPEND_DEFINITION_EXPECTED_BALANCE}    Evaluate
        ...    ${B_WALLET_SPEND_DEFINITION_EXPECTED_BALANCE} + ${spend_amount}
        Set Suite Variable    ${B_WALLET_SPEND_DEFINITION_EXPECTED_BALANCE}

        ${EXPECTED_WALLET_SPEND_AMOUNT}    Set Variable    ${spend_amount}
        Set Test Variable    ${EXPECTED_WALLET_SPEND_AMOUNT}

        ${SPEND_PAY_TRACKING_CODE}    Set Variable    ${pay_result['body']['trackingCode']}
        Set Test Variable    ${SPEND_PAY_TRACKING_CODE}

        ${SPEND_PAY_CONFIRMATION_CODE}    Set Variable    ${pay_result['body']['confirmationCode']}
        Set Test Variable    ${SPEND_PAY_CONFIRMATION_CODE}
    ELSE
        ${SPEND_FAILURE_CONTENT}    Set Variable    ${pay_result['body']}
        Set Test Variable    ${SPEND_FAILURE_CONTENT}
    END

Give User All Wallets Balance List
    [Tags]    robot:private
    [Arguments]    ${wallet_user_id}
    ${response}    GET Wallets Users Balances    ${MICROSERVICE_SIDE}    ${wallet_user_id}
    Should Be Equal As Integers
    ...    ${response['status_code']}
    ...    200
    ...    msg=Failed to get user total balances, error: ${response['body']['result']}
    RETURN    ${response['body']['balances']}

Give A Wallet User Balance
    [Tags]    robot:private
    [Arguments]    ${wallet_user_id}    ${wallet_name}

    ${response}    GET Wallets Users Balance    ${MICROSERVICE_SIDE}    ${wallet_user_id}    ${wallet_name}
    Should Be Equal As Integers
    ...    ${response['status_code']}
    ...    200
    ...    msg=Failed to get user wallet balance, error: ${response['body']['result']}
    RETURN    ${response['body']}

Only Default Wallet Should Be Decreased Based on Spend Amount
    FOR    ${expected_wallet}    IN    @{CURRENT_USER_OBJECT['wallets']}
        ${actual_wallet}    Give A Wallet User Balance
        ...    ${CURRENT_USER_OBJECT['user_id']}
        ...    ${expected_wallet['name']}
        IF    '${expected_wallet['name']}' == '${WALLET_DEFAULT_DEFINITION}'
            ${expected_balance}    Evaluate
            ...    ${expected_wallet['initial_amount']} - ${EXPECTED_WALLET_SPEND_AMOUNT}
            Should Be Equal As Integers
            ...    ${expected_balance}
            ...    ${actual_wallet['balance']}
            ...    msg=Default balance should be: ${expected_balance}, but found: ${actual_wallet['balance']}
        ELSE
            Should Be Equal As Integers
            ...    ${expected_wallet['initial_amount']}
            ...    ${actual_wallet['balance']}
            ...    msg=Current balance of wallet: ${expected_wallet['name']} not equals to expected balance: ${actual_wallet['balance']}}
        END
    END

Only Unexpired Gift Wallet Should Be Decreased Based on Spend Amount
    FOR    ${expected_wallet}    IN    @{CURRENT_USER_OBJECT['wallets']}
        ${actual_wallet}    Give A Wallet User Balance
        ...    ${CURRENT_USER_OBJECT['user_id']}
        ...    ${expected_wallet['name']}
        IF    ('${expected_wallet['type']}' == '${WALLET_TIME_BOUND_DEFINITION}') and ('expired' not in ${expected_wallet}) and (${expected_wallet['initial_amount']} > 0)
            ${expected_balance}    Evaluate
            ...    ${expected_wallet['initial_amount']} - ${EXPECTED_WALLET_SPEND_AMOUNT}
            Should Be Equal As Integers
            ...    ${expected_balance}
            ...    ${actual_wallet['balance']}
            ...    msg=Unexpired gift balance should be: ${expected_balance}, but found: ${actual_wallet['balance']}
        ELSE
            Should Be Equal As Integers
            ...    ${expected_wallet['initial_amount']}
            ...    ${actual_wallet['balance']}
            ...    msg=Current balance of wallet: ${expected_wallet['name']} not equals to expected balance: ${actual_wallet['balance']}}
        END
    END

Default Wallet Amount Before Unexpired Gift Wallet Amount Should Be Decreased
    FOR    ${expected_wallet}    IN    @{CURRENT_USER_OBJECT['wallets']}
        ${actual_wallet}    Give A Wallet User Balance
        ...    ${CURRENT_USER_OBJECT['user_id']}
        ...    ${expected_wallet['name']}
        # for default wallet current balance should be zero
        IF    '${expected_wallet['name']}' == '${WALLET_DEFAULT_DEFINITION}'
            Should Be Equal As Integers
            ...    ${actual_wallet['balance']}
            ...    0
            ...    msg=Default wallet balance should be zero but found: ${actual_wallet['balance']}
            # remainig amount should be in unexpired wallet and remaining amount set in when section keyword
        ELSE IF    ('${expected_wallet['type']}' == '${WALLET_TIME_BOUND_DEFINITION}') and ('expired' not in ${expected_wallet}) and (${expected_wallet['initial_amount']} > 0)
            Should Be Equal As Integers
            ...    ${EXPECTED_REMAINING_AMOUNT}
            ...    ${actual_wallet['balance']}
            ...    msg=Unexpired gift balance should be: ${EXPECTED_REMAINING_AMOUNT}, but found: ${actual_wallet['balance']}
        ELSE
            Should Be Equal As Integers
            ...    ${expected_wallet['initial_amount']}
            ...    ${actual_wallet['balance']}
            ...    msg=Current balance of wallet: ${expected_wallet['name']} not equals to expected balance: ${actual_wallet['balance']}}
        END
    END

All User Wallet Should Not Be Decreased
    FOR    ${expected_wallet}    IN    @{CURRENT_USER_OBJECT['wallets']}
        ${actual_wallet}    Give A Wallet User Balance
        ...    ${CURRENT_USER_OBJECT['user_id']}
        ...    ${expected_wallet['name']}

        Should Be Equal As Integers
        ...    ${expected_wallet['initial_amount']}
        ...    ${actual_wallet['balance']}
        ...    msg=Current balance of wallet: ${expected_wallet['name']} not equals to expected balance: ${actual_wallet['balance']}}
    END

Destination Business Wallet Should Be Increased Based on Spend Amount
    Check Business Balance Based On Expected Balance

Destination Business Wallet Should Not Be Increased Based on Spend Amount
    Check Business Balance Based On Expected Balance

Check Business Balance Based On Expected Balance
    [Documentation]    The expected balance updated In `Pay And Verify` keyword and
    ...    compare with spend destination that share with all test cases.
    [Tags]    robot:private
    ${result}    GET Wallets Businesses Balance
    ...    ${MICROSERVICE_SIDE}
    ...    ${INIT_BUSINESS_ID}
    ...    ${B_WALLET_SPEND_DEFINITION}
    Should Be Equal As Integers    ${result['status_code']}    200    msg=Fail to get business balance.
    Should Be Equal As Integers
    ...    ${result['body']['balance']}
    ...    ${B_WALLET_SPEND_DEFINITION_EXPECTED_BALANCE}
    ...    msg=Recevied business balance ${result['body']['balance']} not equals to expected amount ${B_WALLET_SPEND_DEFINITION_EXPECTED_BALANCE}

Spend Should Be Failed With
    [Arguments]    ${failure_content}
    Dictionaries Should Be Equal
    ...    ${SPEND_FAILURE_CONTENT['result']}
    ...    ${failure_content}
    ...    msg=Spend Result Should be match with expected content.
