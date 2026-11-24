*** Settings ***
Library         String
Library         Collections
Library         library/faker_utils.py    WITH NAME    FakerLibrary
Variables       data/wallet/business-transfer-variables.yaml
Resource        services/backend/auth-service.resource
Resource        apis/uaa/post-admin-businesses.resource
Resource        apis/wallet-provider/admin/admin-wallets-businesses.resource
Resource        apis/nemo/admin/admin-wallets-businesses-cash-in.resource
Resource        apis/nemo/admin/admin-wallets-businesses-transfer.resource
Resource        apis/wallet-provider/admin/admin-wallets-businesses-id-balance.resource
Resource        apis/wallet-provider/admin/admin-transactions-statement-business-id-wallet-name.resource


*** Keywords ***
Initialize Business And Wallets With Amount
    [Documentation]    This keyword login to dashboard, create a business with wallet
    ...    and sets `${INIT_BUSINESS_ID}` as a suite variable.
    Login To Dashboard    ${DASHBOARD_USERNAME}    ${DASHBOARD_PASSWORD}
    Create A Business
    Add Wallet To Business
    Cash-in To Wallets

Create A Business
    ${business_name}    Generate Random String    20
    ${business_user_name}    Generate Random String    20
    ${business_password}    Generate Random String    20
    @{business_roles}    Create List    BUSINESS_ADMIN
    ${response}    POST Admin Businesses
    ...    ${DASHBOARD_SIDE}
    ...    ${business_name}
    ...    ${business_user_name}
    ...    ${business_password}
    ...    ${business_roles}
    Should Be Equal As Integers
    ...    200
    ...    ${response['status_code']}
    ...    msg=Business initialization failed with status code: ${response['status_code']}
    ${INIT_BUSINESS_ID}    Set Variable    ${response['business_id']}
    Set Suite Variable    ${INIT_BUSINESS_ID}

Add Wallet To Business
    FOR    ${wallet}    IN    @{WALLET_LIST}
        ${result}    POST Admin Wallets Businesses    ${DASHBOARD_SIDE}    ${INIT_BUSINESS_ID}    ${wallet}
        Should Be True    ${result}    msg=Failed to add wallet ${wallet} to business. result is: ${result}
    END

Cash-in To Wallets
    [Documentation]    Cash-in to all wallets of a business by random genarated AMOUNT
    ...    between 1500 - 2000 and sets `${ORIGIN_AMOUNT}` with list of dictionaries as a test variable.
    @{ORIGIN_AMOUNT}    Create List
    FOR    ${wallet}    IN    @{WALLET_LIST}
        ${amount}    Random Int    1500    2000
        ${refNumber}    Generate Random String    18    [LOWER]
        ${providerCode}    FakerLibrary.Color Name
        ${response}    POST Admin Wallets Businesses Cash-in
        ...    ${DASHBOARD_SIDE}
        ...    ${INIT_BUSINESS_ID}
        ...    ${wallet}
        ...    ${amount}
        ...    ${refNumber}
        ...    ${providerCode}
        Dictionary Should Contain Key
        ...    ${response['body']}
        ...    trackingCode
        ...    msg=Cash-in result failed and should be contain trackingCode. responseBody: ${response['body']}
        &{walletObject}    Create Dictionary    name=${wallet}    amount=${amount}
        Append To List    ${ORIGIN_AMOUNT}    ${walletObject}
    END
    Set Suite Variable    ${ORIGIN_AMOUNT}

Transfer Between Wallets
    [Documentation]    Transfer amount between two wallet of a business and sets
    ...    `${SOURCE_WALLET}`, `${DESTINATION_WALLET}` as suite vairables and
    ...    `${TRANSFER_AMOUNT}` as test variable. IF `${amount}` is not set, generates by random int.
    ...    IF `${user_id}` or `${agent}` is set, requset addresses to `MICROSERVICE` side.
    [Arguments]
    ...    ${source_wallet_arg}=${EMPTY}
    ...    ${destination_wallet_arg}=${EMPTY}
    ...    ${amount}=${EMPTY}
    ...    ${user_id}=${EMPTY}
    ...    ${agent}=${EMPTY}

    ${api_call_side}    Set Variable    ${DASHBOARD_SIDE}
    ${TRANSFER_AMOUNT}    Set Variable    ${amount}
    ${SOURCE_WALLET}    Set Variable    ${WALLET_LIST}[0]
    ${DESTINATION_WALLET}    Set Variable    ${WALLET_LIST}[1]
    ${TRANSFER_TRACK_CODE}    Set Variable    ${EMPTY}

    IF    '${amount}' == '${EMPTY}'
        ${TRANSFER_AMOUNT}    Random Int    500    1000
    END

    IF    '${user_id}' != '${EMPTY}' or '${agent}' != '${EMPTY}'
        ${api_call_side}    Set Variable    ${MICROSERVICE_SIDE}
    END

    IF    '${source_wallet_arg}' != '${EMPTY}'
        ${SOURCE_WALLET}    Set Variable    ${source_wallet_arg}
    END

    IF    '${destination_wallet_arg}' != '${EMPTY}'
        ${DESTINATION_WALLET}    Set Variable    ${destination_wallet_arg}
    END

    ${response}    POST Admin Wallets Businesses Transfer
    ...    ${api_call_side}
    ...    ${INIT_BUSINESS_ID}
    ...    ${SOURCE_WALLET}
    ...    ${DESTINATION_WALLET}
    ...    ${TRANSFER_AMOUNT}
    ...    ${user_id}
    ...    ${agent}
    # Update origin wallet amount if transfer successfull for perventing test case evaluation conflict.
    IF    ${response['status_code']} == 200
        Set Test Variable    ${TRANSFER_TRACK_CODE}    ${response['body']['trackingCode']}
        IF    '${response['body']['result']['title']}' == 'SUCCESS'
            Update Origin Amount    ${SOURCE_WALLET}    ${DESTINATION_WALLET}    ${TRANSFER_AMOUNT}
        END
    END

    &{TRANSFER_RESULT_BODY}    Create Dictionary
    ${TRANSFER_RESULT_STAUS_CODE}    Set Variable
    Set Test Variable    ${TRANSFER_RESULT_BODY}    ${response['body']['result']}
    Set Test Variable    ${TRANSFER_RESULT_STAUS_CODE}    ${response['status_code']}
    Set Test Variable    ${SOURCE_WALLET}
    Set Test Variable    ${DESTINATION_WALLET}
    Set Test Variable    ${TRANSFER_AMOUNT}

Transfer Should Be Failed With
    [Arguments]    ${failure_content}
    Dictionaries Should Be Equal    ${TRANSFER_RESULT_BODY}    ${failure_content}

Source Wallet Amount Should Be Decreased
    ${current_balance}    Get Business Balance    ${SOURCE_WALLET}
    ${source_wallet_amount}    Get Origin Amount    ${SOURCE_WALLET}
    Should Be Equal As Integers    ${current_balance}    ${source_wallet_amount}

Source Wallet Amount Should Not Be Decreased
    ${current_balance}    Get Business Balance    ${SOURCE_WALLET}
    ${source_wallet_amount}    Get Origin Amount    ${SOURCE_WALLET}
    Should Be Equal As Integers    ${current_balance}    ${source_wallet_amount}

Destination Wallet Amount Should Be Increased
    ${current_balance}    Get Business Balance    ${DESTINATION_WALLET}
    ${destination_wallet_amount}    Get Origin Amount    ${DESTINATION_WALLET}
    Should Be Equal As Integers    ${current_balance}    ${destination_wallet_amount}

Destination Wallet Amount Should Not Be Increased
    ${current_balance}    Get Business Balance    ${DESTINATION_WALLET}
    ${destination_wallet_amount}    Get Origin Amount    ${DESTINATION_WALLET}
    Should Be Equal As Integers    ${current_balance}    ${destination_wallet_amount}

Transfer Transaction Log Should Be Founded In Report Service
    [Arguments]    ${for_source_wallet}=${False}    ${for_destination_wallet}=${False}
    Sleep    5s    reason=Sleep for saving transaction in report service

    IF    ${for_source_wallet} == ${True}
        Get Transfer Transaction    ${SOURCE_WALLET}
    END

    IF    ${for_destination_wallet} == ${True}
        Get Transfer Transaction    ${DESTINATION_WALLET}
    END
    IF    ${for_source_wallet} == ${False} and ${for_destination_wallet} == ${False}
        Fail    msg= A wallet must be selected for get transaction report.
    END

Get Business Balance
    [Arguments]    ${wallet_name}
    ${response}    GET Admin Wallets Businesses Id Balance
    ...    ${MICROSERVICE_SIDE}
    ...    ${INIT_BUSINESS_ID}
    ...    ${wallet_name}
    IF    ${response['status_code']} == 200
        RETURN    ${response['body']['balance']}
    ELSE
        Fail    msg=Fail to get business balance for business id: ${INIT_BUSINESS_ID} with wallet ${wallet_name}
    END

Get Origin Amount
    [Arguments]    ${wallet_name}
    FOR    ${wallet}    IN    @{ORIGIN_AMOUNT}
        IF    '${wallet['name']}' == '${wallet_name}'
            RETURN    ${wallet['amount']}
        END
    END

Update Origin Amount
    [Documentation]    Update origin amount based on successfull transfer.
    [Arguments]    ${src_wallet}    ${dst_wallet}    ${transfer_amount}

    FOR    ${wallet}    IN    @{ORIGIN_AMOUNT}
        IF    '${wallet['name']}' == '${src_wallet}'
            ${result_amount}    Evaluate    ${wallet['amount']} - ${transfer_amount}
            Set To Dictionary    ${wallet}    amount=${result_amount}
        END
        IF    '${wallet['name']}' == '${dst_wallet}'
            ${result_amount}    Evaluate    ${wallet['amount']} + ${transfer_amount}
            Set To Dictionary    ${wallet}    amount=${result_amount}
        END
    END

Get Transfer Transaction
    [Arguments]    ${wallet_name}

    ${response}    POST Admin Transactions Statement Business Id Wallet Name
    ...    ${DASHBOARD_SIDE}
    ...    ${INIT_BUSINESS_ID}
    ...    ${wallet_name}

    FOR    ${transaction}    IN    @{response['body']['transactions']}
        IF    '${TRANSFER_TRACK_CODE}' == '${transaction['trackingCode']}'
            BREAK
        ELSE
            Fail    msg=Transfer tracking code: ${TRANSFER_TRACK_CODE} not found in transaction report.
        END
    END
