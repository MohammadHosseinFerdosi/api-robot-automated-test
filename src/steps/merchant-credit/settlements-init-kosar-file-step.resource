*** Settings ***
Library     String
Resource    steps/merchant-credit/utilities/get-merchant-credit-db-data.resource
Resource    steps/merchant-credit/utilities/settlement-utilities.resource
Resource    services/db/mongo-db-service.resource


*** Keywords ***
Upload Kosar File With Negative Amount And Zero Amount
    [Documentation]    we simulate The import of kosar file by company operation in db
    [Arguments]    ${amount}

    ${get_Current_Date}    Get Time    epoch

    ${find_query}    Create Dictionary    nationalCode=${NATIONAL_CODE_LEGAL}    businessId=${BUSINESS_ID}
    ${update_value}    Create Dictionary    balances.0.date=${get_Current_Date}    balances.0.amount=${amount}
    ${update_query}    Create Dictionary    $set=${update_value}

    Mongo Db Update One
    ...    db_name=merchant_credit_db
    ...    collection_name=merchant_ticket_infos
    ...    filter_query=${find_query}
    ...    update_data=${update_query}

The User Requests Early Settlement
    ${result_kosar_file}    Create Settlement    ${REGISTRATION_ID}    7    10000000

    Set Test Variable    ${result_kosar_file}    ${result_kosar_file}[response][result]

Receive "The user's credit limit has been reached" Message
    Should Be Equal As Strings    ${result_kosar_file}[message]    سقف اعتبار کاربر به اتمام رسیده است.
    Should Be Equal As Integers    ${result_kosar_file}[status]    15612
    Should Be Equal As Strings    ${result_kosar_file}[title]    MERCHANT_CREDIT_MERCHANT_MAX_CREDIT_AMOUNT_EXCEEDED
