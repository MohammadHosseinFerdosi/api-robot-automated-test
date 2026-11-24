*** Settings ***
Library         Collections
Library         String
Library         JSONLibrary
Library         library/faker_utils.py    WITH NAME    FakerLibrary
Resource        apis/nemo/admin/admin-wallets-businesses-cash-in.resource
Resource        apis/nemo/admin/admin-wallets-businesses-balance.resource
Resource        apis/wallet-provider/admin/admin-wallets-businesses.resource
Resource        apis/uaa/post-admin-businesses.resource
Resource        services/backend/auth-service.resource
Variables       data/wallet/business-cash-in-variables.yaml


*** Keywords ***
Initilaize A Business
    [Documentation]    Initiazize a business, create a wallet for it and
    ...    save current balance to `${BALANCE_LIST}` as suite variable.
    ...    also sets `${INIT_BUSINESS_ID}` as suite variable.
    Login To Dashboard    ${ADMIN_USER}    ${ADMIN_PASS}
    Create A Business
    Add Wallet To Business
    @{BALANCE_LIST}    Create List
    Set Test Variable    @{BALANCE_LIST}
    Get Currnet Balance    ${WALLET_NAME_DATA}
    ${CASH_IN_REF_NUMBER}    Generate Random String    20    [NUMBERS]
    Set Test Variable    ${CASH_IN_REF_NUMBER}
    ${CASH_IN_PROVIDER_CODE}    Generate Random String    12    [NUMBERS]
    Set Test Variable    ${CASH_IN_PROVIDER_CODE}

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
    ${is_wallet_added}    POST Admin Wallets Businesses
    ...    ${DASHBOARD_SIDE}
    ...    ${INIT_BUSINESS_ID}
    ...    ${WALLET_NAME_DATA}
    ...    ${CURRENCY_IRR}
    Should Be True    ${is_wallet_added}    msg=Wallet Not Added in Busienss.

Business Cash-in
    [Documentation]    Cash-in to a business and set result as test variable `${CASH_IN_RESULT}`
    [Arguments]    ${wallet_name_arg}    ${business_id}=${None}    ${amount}=${None}
    IF    '${business_id}' == '${None}'
        ${business_id}    Set Variable    ${INIT_BUSINESS_ID}
    END
    IF    '${amount}' == '${None}'
        ${amount}    FakerLibrary.Random Number    digits=3    fix_len=${True}
    END
    ${CASHIN_AMOUNT}    Set Variable    ${None}
    Set Test Variable    ${CASHIN_AMOUNT}    ${amount}

    ${response}    POST Admin Wallets Businesses Cash-in
    ...    ${DASHBOARD_SIDE}
    ...    ${business_id}
    ...    ${wallet_name_arg}
    ...    ${amount}
    ...    ${CASH_IN_REF_NUMBER}
    ...    ${CASH_IN_PROVIDER_CODE}

    IF    ${response['status_code']} == 200
        Dictionary Should Contain Key
        ...    ${response['body']}
        ...    trackingCode
        ...    msg=Cash-in Result Should Be Dictionary contain `trackingCode` key.
    ELSE
        Dictionary Should Contain Key
        ...    ${response['body']['result']}
        ...    level
        ...    msg=Cash-in Result Should Be Dictionary contain `level` key.
    END
    &{CASH_IN_RESULT}    Set Variable    ${None}
    Set Test Variable    ${CASH_IN_RESULT}    ${response['body']}

Get Currnet Balance
    [Documentation]    Get balance of a business wallet and append it to test list varaible `${BALANCE_LIST}`
    [Arguments]    ${wallet_name_arg}
    ${response}    GET Admin Wallets Businesses Balance
    ...    ${DASHBOARD_SIDE}
    ...    ${INIT_BUSINESS_ID}
    IF    ${response['status_code']} == 200
        Dictionary Should Contain Key
        ...    ${response['body']['balances']}[0]
        ...    walletName
        ...    msg=Wallet Balance List Should Not Be Empty.
        FOR    ${wallet}    IN    @{response['body']['balances']}
            IF    '${wallet['walletName']}' == '${wallet_name_arg}'
                ${current_balance}    Set Variable    ${null}
                ${current_balance}    Convert To Integer    ${wallet['balance']}
                Append To List    ${BALANCE_LIST}    ${current_balance}
            END
        END
    ELSE
        Fail    msg=Current Balance for Business ${INIT_BUSINESS_ID} Not Found.
    END

Wallet Amount Should Be Increased By Input Amount
    ${balance_diff}    Evaluate    ${BALANCE_LIST}[-1] - ${BALANCE_LIST}[-2]
    Should Be Equal As Integers    ${balance_diff}    ${CASHIN_AMOUNT}

Wallet Amount Should Not Be Increased
    Should Be Equal As Integers    ${BALANCE_LIST}[-2]    ${BALANCE_LIST}[-1]

Cash-in Should Be Failed With
    [Arguments]    ${failure_content}
    Dictionaries Should Be Equal    ${CASH_IN_RESULT['result']}    ${failure_content}
