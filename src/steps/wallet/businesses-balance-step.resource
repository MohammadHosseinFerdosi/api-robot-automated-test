*** Settings ***
Library         library/faker_utils.py    WITH NAME    FakerLibrary
Resource        apis/uaa/oauth/oauth-token.resource
Resource        services/backend/auth-service.resource
Resource        apis/uaa/post-admin-businesses.resource
Resource        apis/wallet-provider/admin/admin-wallets-businesses.resource
Resource        apis/nemo/admin/admin-wallets-businesses-cash-in.resource
Resource        apis/nemo/admin/admin-wallets-businesses-balance.resource
Variables       data/wallet/business-balance-variables.yaml


*** Keywords ***
Initialize A Business With Wallet
    [Documentation]    This keyword login to dashboard, create a business with wallet
    ...    and sets `${INIT_BUSINESS_ID}` as a suite variable.
    Login To Dashboard    ${DASHBOARD_USERNAME}    ${DASHBOARD_PASSWORD}
    Create A Business
    Add Wallet To Business

Create A Business
    ${random_color}    FakerLibrary.Color Name
    ${random_name}    FakerLibrary.First Name
    ${name}    Catenate    Test-${random_color}-${random_name}
    ${username}    FakerLibrary.Username
    ${password}    FakerLibrary.Password
    @{role_list}    Create List    BUSINESS_ADMIN
    ${response}    POST Admin Businesses
    ...    ${DASHBOARD_SIDE}
    ...    ${name}
    ...    ${username}
    ...    ${password}
    ...    ${role_list}
    Should Be Equal As Integers
    ...    200
    ...    ${response['status_code']}
    ...    msg=Business initialization failed with status code: ${response['status_code']}
    ${INIT_BUSINESS_ID}    Set Variable    ${response['business_id']}
    Set Suite Variable    ${INIT_BUSINESS_ID}

Add Wallet To Business
    FOR    ${wallet}    IN    @{WALLET_LIST}
        ${is_wallet_added}    POST Admin Wallets Businesses
        ...    ${DASHBOARD_SIDE}
        ...    ${INIT_BUSINESS_ID}
        ...    ${wallet}
        ...    ${CURRENCY_IRR}
        Should Be True    ${is_wallet_added}    msg=Wallet Not Added in Busienss.
    END

Cash-in To All Wallets Of A Business
    [Documentation]    Cash-in to all wallets of a business by random genarated AMOUNT and set `${WALLET AMOUNT}` with
    ...    list of dictionaries type, as a test variable.
    @{CASHIN_AMOUNT}    Create List
    FOR    ${wallet}    IN    @{WALLET_LIST}
        ${amount}    Random Int    1500    2000
        ${ref_number}    Generate Random String    18    [LOWER]
        ${providerCode}    FakerLibrary.Color Name
        ${response}    POST Admin Wallets Businesses Cash-in
        ...    ${DASHBOARD_SIDE}
        ...    ${INIT_BUSINESS_ID}
        ...    ${wallet}
        ...    ${amount}
        ...    ${ref_number}
        ...    ${providerCode}
        Dictionary Should Contain Key
        ...    ${response['body']}
        ...    trackingCode
        ...    msg=Cash-in result failed and should be contain trackingCode. responseBody: ${response['body']}
        &{wallet_object}    Create Dictionary    name=${wallet}    amount=${amount}
        Append To List    ${CASHIN_AMOUNT}    ${wallet_object}
    END
    Set Test Variable    ${CASHIN_AMOUNT}

Get Business Balance
    [Documentation]    Get all wallets balances of a business and set it as
    ...    a test variable with name `${BALANCE_LIST}`. if set `${business_id}` arg,
    ...    default INIT_BUSINESS_ID in suite vaialble override.
    [Arguments]    ${call_side}    ${business_id}=${EMPTY}    ${user_id}=${EMPTY}    ${zone}=${EMPTY}
    IF    '${business_id}' == '${EMPTY}'
        ${business_id}    Set Variable    ${INIT_BUSINESS_ID}
    END

    IF    '${call_side}' == '${MICROSERVICE_SIDE}' and '${user_id}' == '${EMPTY}'
        ${random_user_id}    Generate Random String    15
        ${user_id}    Set Variable    ${random_user_id}
    END

    ${response}    GET Admin Wallets Businesses Balance
    ...    ${call_side}
    ...    ${business_id}
    ...    ${zone}
    ...    ${user_id}

    IF    ${response['status_code']} == 200
        @{BALANCE_LIST}    Create List
        Set Test Variable    ${BALANCE_LIST}    ${response['body']['balances']}
    ELSE
        &{GET_BALANCE_RESULT}    Create Dictionary
        ${GET_BALANCE_STAUS_CODE}    Set Variable
        Set Test Variable    ${GET_BALANCE_RESULT}    ${response['body']['result']}
        Set Test Variable    ${GET_BALANCE_STAUS_CODE}    ${response['status_code']}
    END

Balance Of All Wallets Should Be Increased By Cash-in Amount
    FOR    ${wallet}    IN    @{CASHIN_AMOUNT}
        FOR    ${balance}    IN    @{BALANCE_LIST}
            IF    '${balance['walletName']}' == '${wallet['name']}'
                Should Be Equal As Integers
                ...    ${balance['balance']}
                ...    ${wallet['amount']}
                ...    msg=Cash-in amount:${wallet['amount']} not equal to wallet balance: ${balance['balance']}
            END
        END
    END

Request Should Be Failed With
    [Arguments]    ${failure_content}    ${failure_status_code}
    Should Be Equal As Numbers
    ...    ${GET_BALANCE_STAUS_CODE}
    ...    ${failure_status_code}
    ...    msg=Result should be failed with status: ${failure_status_code} but found: ${GET_BALANCE_STAUS_CODE}
    Dictionaries Should Be Equal    ${GET_BALANCE_RESULT}    ${failure_content}

Balance List Should Be Empty
    ${balance_list_length}    Get Length    ${BALANCE_LIST}
    Should Be Equal As Integers
    ...    ${balance_list_length}
    ...    ${0}
    ...    msg=Balance list should be empty but found a item. ${BALANCE_LIST}
