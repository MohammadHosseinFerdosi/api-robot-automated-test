*** Settings ***
Library         String
Library         Collections
Library         library/faker_utils.py    WITH NAME    FakerLibrary
Resource        apis/nemo/user-wallet-transfer/post-wallet-transfer.resource
Resource        apis/nemo/user-wallet-transfer/post-wallets-transfer-pay-wallet.resource
Resource        services/backend/auth-service.resource
Resource        apis/uaa/businesses.resource
Resource        apis/wallet-provider/admin/admin-wallets-businesses.resource
Resource        apis/nemo/admin/admin-wallets-businesses-cash-in.resource
Resource        apis/wallet-provider/wallets/get-wallets-users-balance.resource
Resource        apis/report-mng/post-user-activities-search.resource
Resource        apis/nemo/user-wallet-transfer/get-wallets-transfer.resource
Resource        apis/report-mng/post-admin-activities-dashboard-search.resource
Variables       data/wallet/business-transfer-variables.yaml


*** Keywords ***
Transfer Occurs Between Wallets
    [Documentation]    Transfers an amount from source which is "${user_id}" to destination
    ...    which is "${dest_cellnumber}".
    ...    The "user_ip" And "type" by Default Are "192.188.0.0" And "wallet", Respectively.
    [Arguments]
    ...    ${user-id}=${EMPTY}
    ...    ${user-ip}=${EMPTY}
    ...    ${type}=${EMPTY}
    ...    ${agent}=${EMPTY}
    ...    ${amount}=${EMPTY}
    ...    ${dest_cellnumber}=${EMPTY}
    ...    ${msg}=${EMPTY}

    ${api-call-side}    Set Variable    ${APP_SIDE}
    ${USER_IP}    Set Variable    ${USER_IP_VALUE}
    ${ْTRANSFER_TYPE}    Set Variable    ${TYPE_VALUE}
    ${DESTINATION_WALLET}    Set Variable    ${DESTINATION_CELLNUMBER}
    Set Test Variable    ${TRANSFER_AMOUNT}    ${amount}
    Set Test Variable    ${SOURCE_WALLET}    ${USER_ID}

    IF    '${user-id}' != '${EMPTY}'
        ${SOURCE_WALLET}    Set Variable    ${user-id}
    END

    IF    '${agent}' == '${EMPTY}'
        ${AGENT}    Set Variable    ${AGENT_VALUE}
    END

    IF    '${dest_cellnumber}' != '${EMPTY}'
        ${DESTINATION_WALLET}    Set Variable    ${dest_cellnumber}
    END

    IF    '${amount}' == '${EMPTY}'
        ${TRANSFER_AMOUNT}    Random Int    2000    9000
        Set Test Variable    ${TRANSFER_AMOUNT}
    END

    IF    '${user-ip}' != '${EMPTY}'
        ${USER_IP}    Set Variable    ${user-ip}
    END

    IF    '${type}' != '${EMPTY}'
        ${ْTRANSFER_TYPE}    Set Variable    ${type}
    END

    ${ticket_response}    Get Transfer Ticket
    ...    ${api-call-side}
    ...    ${SOURCE_WALLET}
    ...    ${AGENT}
    ...    ${TRANSFER_AMOUNT}
    ...    ${DESTINATION_WALLET}
    Set Test Variable    ${ticket}    ${ticket_response['ticket']}

    ${transfer_response}    Pay Wallet Between Wallets By Ticket
    ...    ${api-call-side}
    ...    ${ticket}
    ...    ${USER_IP}
    ...    ${ْTRANSFER_TYPE}
    ...    ${AGENT}

Get Transfer Ticket
    [Arguments]
    ...    ${api-call-side}
    ...    ${SOURCE_WALLET}
    ...    ${AGENT}
    ...    ${TRANSFER_AMOUNT}
    ...    ${DESTINATION_WALLET}
    ${response}    POST Wallets Transfer
    ...    ${api-call-side}
    ...    ${SOURCE_WALLET}
    ...    ${AGENT}
    ...    ${TRANSFER_AMOUNT}
    ...    ${DESTINATION_WALLET}
    IF    ${response['status_code']} == 200
        Should Not Be Empty    ${response['ticket']}
        ${result}    Create Dictionary    status=${response['status_code']}    ticket=${response['ticket']}
        RETURN    ${result}
    ELSE
        ${result}    Create Dictionary    status=${response['status_code']}    result=${response['result']}
        RETURN    ${result}
    END

Pay Wallet Between Wallets By Ticket
    [Arguments]
    ...    ${api-call-side}
    ...    ${ticket}
    ...    ${USER_IP}
    ...    ${ْTRANSFER_TYPE}
    ...    ${AGENT}
    ${response}    POST Wallets Transfer Pay Wallet
    ...    ${api-call-side}
    ...    ${ticket}
    ...    ${USER_IP}
    ...    ${ْTRANSFER_TYPE}
    ...    ${AGENT}
    IF    ${response['status_code']} == 200
        Set Test Variable    ${TRANSFER_TRACK_CODE}    ${response['body']['trackingCode']}
        RETURN    ${response}
    ELSE
        ${result}    Create Dictionary    status=${response['status_code']}    result=${response['result']}
        RETURN    ${result}
    END

Source Wallet Ballance Should Be Decreased
    ${new_balance}    Get User Current Balance    ${USER_WALLET_NAME}    ${SOURCE_WALLET}
    ${decreased_amount}    Evaluate    ${INIT_USER_BALANCE} - ${new_balance}
    Should Be Equal As Integers    ${TRANSFER_AMOUNT}    ${decreased_amount}

Destination Wallet Ballance Should Be Increased
    ${new_balance}    Get User Current Balance    ${USER_WALLET_NAME}    ${DEST_USER_ID}
    ${increased_amount}    Evaluate    ${new_balance} - ${INIT_DEST_USER_BALANCE}
    Should Be Equal As Integers    ${TRANSFER_AMOUNT}    ${increased_amount}

Get User Transaction Report
    [Tags]    robot:private
    @{restrictions}    Create List

    ${sort_by}    Create Dictionary    field=exerciseDate    order=desc
    @{orders}    Create List    ${sort_by}
    ${result}    POST User Activities Search    ${APP_SIDE}    ${restrictions}    ${orders}
    Should Be Equal As Integers    ${result['status_code']}    200    msg=Report Result Failed. ${result['body']}
    RETURN    ${result['body']}

Get Dashboard Transaction Report
    [Tags]    robot:private

    ${current_time}    Get Time    epoch
    ${min_time}    Evaluate    (${current_time} * 1000) - 600000
    ${max_time}    Evaluate    (${current_time} * 1000) + 600000
    ${creation_date}    Create Dictionary
    ...    type=range
    ...    field=creationDate
    ...    minValue=${min_time}
    ...    maxValue=${max_time}

    ${transaction_type}    Create Dictionary
    ...    type=simple
    ...    field=trackingCode
    ...    value=${TRANSFER_TRACK_CODE}
    ...    operation=eq

    @{restrictions}    Create List
    # ...    ${creation_date}
    ...    ${transaction_type}

    ${sort_by}    Create Dictionary    field=creationDate    order=desc
    @{orders}    Create List    ${sort_by}
    ${result}    POST Admin Activities Dashboard Search    ${DASHBOARD_SIDE}    ${restrictions}    ${orders}
    Should Be Equal As Integers    ${result['status_code']}    200    msg=Report Result Failed. ${result['body']}
    RETURN    ${result['body']}

User Activity Should Be Found
    Sleep    3    # This sleep is used to ensure that the user transaction is recorded.
    ${report_result}    Get User Transaction Report
    Set Local Variable    ${activity}    ${report_result['activities']}[0]
    IF    ${activity['amount']} == ${TRANSFER_AMOUNT}
        Should Be Equal As Strings
        ...    ${activity['trackingCode']}
        ...    ${TRANSFER_TRACK_CODE}
        ...    msg=Transfer tracking code with expected did'nt match.
    ELSE
        Fail    msg=Transfer report with expected amount not found.
    END

Dashboard Activity Should Be Found
    Login To Dashboard    ${DASHBOARD_USERNAME}    ${DASHBOARD_PASSWORD}
    ${report_result}    Get Dashboard Transaction Report
    ${activity}    Set Variable    ${report_result['activities'][0]}
    Should Be Equal As Strings
    ...    ${activity['source']['user']['userId']}
    ...    ${SOURCE_WALLET}
    ...    msg=Transfer with valid amount founded but source user id did'nt match with expected user id.
    Should Be Equal As Strings
    ...    ${activity['trackingCode']}
    ...    ${TRANSFER_TRACK_CODE}
    ...    msg=Transfer tracking code with expected did'nt match.

Transfer Occures From Invalid Source
    [Documentation]    Transfers an amount from invalid source to valid destination.
    ...    To use this keyword you should enter an invalid user as a '${user-id}' for invalid source wallet scenario and
    ...    enter an invalid '${dest_cellnumber}'.
    [Arguments]
    ...    ${user-id}=${EMPTY}
    ...    ${agent}=${EMPTY}
    ...    ${amount}=${EMPTY}
    ...    ${dest_cellnumber}=${EMPTY}
    ...    ${msg}=${EMPTY}

    ${RESPONSE_INVALID}    Try To Get Ticket For Different Scenarios    user-id=${INVALID_SOURCE_USER_ID}
    Set Test Variable    ${RESPONSE_INVALID}

Try To Get Ticket For Different Scenarios
    [Documentation]    Transfers an amount from invalid source to valid destination or valid source to invalid destination.
    [Tags]    robot:private
    [Arguments]
    ...    ${user-id}=${EMPTY}
    ...    ${agent}=${EMPTY}
    ...    ${amount}=${EMPTY}
    ...    ${dest_cellnumber}=${EMPTY}
    ...    ${msg}=${EMPTY}

    ${api-call-side}    Set Variable    ${MICROSERVICE_SIDE}
    Set Test Variable    ${TRANSFER_AMOUNT}    ${amount}
    Set Test Variable    ${SOURCE_USER_ID}    ${user-id}
    Set Test Variable    ${DESTINATION_WALLET}    ${dest_cellnumber}

    IF    '${user-id}' == '${EMPTY}'
        Set Test Variable    ${SOURCE_USER_ID}    ${USER_ID}
    END

    IF    '${agent}' == '${EMPTY}'
        ${AGENT}    Set Variable    ${AGENT_VALUE}
    END

    IF    '${dest_cellnumber}' == '${EMPTY}'
        ${DESTINATION_WALLET}    Set Variable    ${DESTINATION_CELLNUMBER}
    END

    IF    '${amount}' == '${EMPTY}'
        ${TRANSFER_AMOUNT}    Random Int    2000    9000
        Set Test Variable    ${TRANSFER_AMOUNT}
    END

    ${DESTINATION_WALLET}    Convert To String    ${DESTINATION_WALLET}
    ${TRANSFER_AMOUNT}    Convert To String    ${TRANSFER_AMOUNT}

    ${response}    Get Transfer Ticket
    ...    ${api-call-side}
    ...    ${SOURCE_USER_ID}
    ...    ${AGENT}
    ...    ${TRANSFER_AMOUNT}
    ...    ${DESTINATION_WALLET}

    RETURN    ${response}

Transfer Occures From Valid Source To Invalid Destination
    [Documentation]    Transfers an amount from valid source to invalid destination.
    ...    To use this keyword you should enter an valid user as a '${user-id}' and
    ...    enter an invalid '${dest_cellnumber}'.
    [Arguments]
    ...    ${user-id}=${EMPTY}
    ...    ${agent}=${EMPTY}
    ...    ${amount}=${EMPTY}
    ...    ${dest_cellnumber}=${EMPTY}
    ...    ${msg}=${EMPTY}

    ${RESPONSE_INVALID}    Try To Get Ticket For Different Scenarios    dest_cellnumber=${INVALID_DEST_CELLNUM}
    Set Test Variable    ${RESPONSE_INVALID}

Input Data Error Should Be Returned
    IF    '${RESPONSE_INVALID['status']}' == '422'
        Should Be Equal As Strings
        ...    ${RESPONSE_INVALID['result']['message']}
        ...    ${INCORRECT_INPUT_DATA_MSG}
    END

Incorrect Cell Number Error Should Be Returned
    IF    '${RESPONSE_INVALID['status']}' == '422'
        Should Be Equal As Strings
        ...    ${RESPONSE_INVALID['result']['message']}
        ...    ${INCORRECT_CELLNUM_MSG}
    END

Out Of Limit Error Should Be Returned
    IF    '${RESPONSE_INVALID['status']}' == '422'
        Should Be Equal As Strings
        ...    ${RESPONSE_INVALID['result']['message']}
        ...    ${OUT_LIMIT_ERROR_MSG}
    END

Insufficient Balance Error Should Be Returned
    IF    '${RESPONSE_INVALID['status']}' == '422'
        Should Be Equal As Strings
        ...    ${RESPONSE_INVALID['result']['message']}
        ...    ${INSUFFICIENT_AMOUNT_MSG}
    END

Transfer Occurs Between Wallets With Under Minimum Limit Amount
    [Documentation]    Transfers under minumum limit amount from valid source which is "${user_id}" to valid destination
    ...    which is "${dest_cellnumber}".
    [Arguments]
    ...    ${user-id}=${EMPTY}
    ...    ${agent}=${EMPTY}
    ...    ${amount}=${EMPTY}
    ...    ${dest_cellnumber}=${EMPTY}
    ...    ${msg}=${EMPTY}

    ${RESPONSE_INVALID}    Try To Get Ticket For Different Scenarios    amount=${UNDER_LIMIT_AMOUNT}
    Set Test Variable    ${RESPONSE_INVALID}

Transfer Occurs Between Wallets With Over Maximum Limit Amount
    [Documentation]    Transfers over maximum limit amount from valid source which is "${user_id}" to valid destination
    ...    which is "${dest_cellnumber}".
    [Arguments]
    ...    ${user-id}=${EMPTY}
    ...    ${agent}=${EMPTY}
    ...    ${amount}=${EMPTY}
    ...    ${dest_cellnumber}=${EMPTY}
    ...    ${msg}=${EMPTY}

    ${RESPONSE_INVALID}    Try To Get Ticket For Different Scenarios    amount=${OVER_LIMIT_AMOUNT}
    Set Test Variable    ${RESPONSE_INVALID}

Transfer Occurs Between Wallets With Invalid Amount
    [Documentation]    Transfers an invalid amount from valid source which is "${user_id}" to valid destination
    ...    which is "${dest_cellnumber}".
    [Arguments]
    ...    ${user-id}=${EMPTY}
    ...    ${agent}=${EMPTY}
    ...    ${amount}=${EMPTY}
    ...    ${dest_cellnumber}=${EMPTY}
    ...    ${msg}=${EMPTY}

    ${RESPONSE_INVALID}    Try To Get Ticket For Different Scenarios    amount=${INVALID_AMOUNT}
    Set Test Variable    ${RESPONSE_INVALID}

Transfer Occures Between Same Wallets
    [Documentation]    Transfers Same Wallet Wich Source And Destination Wallet is "${SOURCE_CELLNUMBER}".
    [Arguments]
    ...    ${user-id}=${EMPTY}
    ...    ${agent}=${EMPTY}
    ...    ${amount}=${EMPTY}
    ...    ${dest_cellnumber}=${EMPTY}
    ...    ${msg}=${EMPTY}

    ${db_query_result}    MySQL Fetch All    db_name=uaa_db
    ...    query=SELECT * FROM uaa_db.users WHERE user_id="${USER_ID}"
    Should Be Equal As Integers
    ...    ${db_query_result['status_code']}
    ...    0
    ...    msg=mysql result should be successful but found: ${db_query_result['body']}

    ${dst_user_cell_number}    Set Variable    ${db_query_result['body'][0]['cell_number']}

    ${RESPONSE_INVALID}    Try To Get Ticket For Different Scenarios
    ...    user-id=${USER_ID}
    ...    dest_cellnumber=${dst_user_cell_number}
    Set Test Variable    ${RESPONSE_INVALID}

Same Wallet Error Should Be Returned
    IF    '${RESPONSE_INVALID['status']}' == '422'
        Should Be Equal As Strings
        ...    ${RESPONSE_INVALID['result']['message']}
        ...    ${SAME_WALLET_ERROR_MSG}
    END

Transfer Occurs Between Wallets With Non Cashoutable Amount
    [Documentation]    Transfers an amount wich is added by non cashout able amount from source which is "${user_id}" to destination
    ...    which is "${dest_cellnumber}".
    [Arguments]
    ...    ${user-id}=${EMPTY}
    ...    ${agent}=${EMPTY}
    ...    ${amount}=${EMPTY}
    ...    ${dest_cellnumber}=${EMPTY}
    ...    ${msg}=${EMPTY}

    ${api-call-side}    Set Variable    ${MICROSERVICE_SIDE}
    Set Test Variable    ${SOURCE_WALLET}    ${USER_ID}

    ${wallet_response}    GET Wallets Transfer
    ...    ${api-call-side}
    ...    ${SOURCE_WALLET}
    ...    agent=${AGENT_VALUE}

    ${cashoutalbe}    Set Variable    ${wallet_response['body']['remainingCap']}
    ${total_balance}    Set Variable    ${wallet_response['body']['walletBalance']}
    ${non_cashoutable}    Evaluate    ${total_balance} - ${cashoutalbe}
    ${added_amount}    Random Int    1    ${non_cashoutable}
    ${TRANSFER_AMOUNT}    Evaluate    ${cashoutalbe} + ${added_amount}
    Set Test Variable    ${TRANSFER_AMOUNT}

    ${RESPONSE_INVALID}    Try To Get Ticket For Different Scenarios
    ...    user-id=${SOURCE_WALLET}
    ...    dest_cellnumber=${DESTINATION_CELLNUMBER}
    ...    amount=${TRANSFER_AMOUNT}
    Set Test Variable    ${RESPONSE_INVALID}

Ticket Error Should Be Returned
    Should Be Equal As Strings
    ...    ${RESPONSE_INVALID['status']}
    ...    422

Get User Current Balance
    [Arguments]    ${wallet_name}    ${wallet_user_id}
    ${result}    GET Wallets Users Balance    ${MICROSERVICE_SIDE}    ${wallet_user_id}    ${wallet_name}
    ${balance}    Set Variable    ${result['body']['balance']}
    Convert To Integer    ${balance}
    RETURN    ${balance}
