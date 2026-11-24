*** Settings ***
Library     String
Library     Collections
Resource    apis/companycard/post-companycard-purchases-in-store-reports-search.resource
Resource    steps/payment/companycard/companycard-purchases-in-store-ticket-step.resource
Resource    steps/payment/companycard/companycard-purchases-in-store-ticket-features-select.resource
Resource    services/backend/value-handler.resource


*** Keywords ***
Get Last Transaction on CompanyCard
    Success Select BPG Feature On In-Store Purchase
    ${current_time}    Get Time    epoch
    ${min_time}    Evaluate    ((${current_time} - 2592000) * 1000 )
    ${max_time}    Evaluate    (${current_time} * 1000)
    ${creation_date}    Create Dictionary
    ...    type=range
    ...    field=creationDate
    ...    minValue=${min_time}
    ...    maxValue=${max_time}

    @{restrictions}    Create List
    ...    ${creation_date}

    ${sort_by}    Create Dictionary    field=creationDate    order=desc
    @{orders}    Create List    ${sort_by}
    ${result}    POST Platform Purchases In-Store Reports Search
    ...    ${GENERAL_SIDE}
    ...    ${restrictions}
    ...    ${orders}
    ...    0
    ...    1
    Should Be Equal As Integers    ${result['status_code']}    200    msg=Report Result Failed. ${result['body']}
    ${filter_query}    Create Dictionary    trackingCode=${trackingCode}
    ${data_response}    Mongo Db Find
    ...    ${COMPANYCARD_DB_NAME}
    ...    ${COMPANYCARD_PLATFORM_PURCHASES_COLLECTION}
    ...    ${filter_query}
    Should Be Equal As Integers    ${data_response['status_code']}    0
    Should Not Be Empty    ${data_response['body']}
    ${body}    Set Variable    ${data_response['body']}[0]
    Should Be Equal As Strings    ${body['status']}    ASSIGNED
    ${data_response_amount}    Value Handler    ${body['amount']}
    Should Be Equal As Integers    ${data_response_amount}    ${POS_TEST_AMOUNT}
    Should Be Equal As Strings    ${body['channel']}    ${COMPANYCARD_POS_CHANNEL}
    Should Be Equal As Strings    ${body['terminalId']}    ${POS_TERMINAL_ID}
    Should Not Be Empty    ${body['trackingCode']}
    Set Test Variable    ${trackingCode}    ${body['trackingCode']}

Get Transactions on CompanyCard In More Than 60 Days
    Success Select BPG Feature On In-Store Purchase
    ${current_time}    Get Time    epoch
    ${min_time}    Evaluate    1719761108000
    ${max_time}    Evaluate    (${current_time} * 1000)
    ${creation_date}    Create Dictionary
    ...    type=range
    ...    field=creationDate
    ...    minValue=${min_time}
    ...    maxValue=${max_time}

    @{restrictions}    Create List
    ...    ${creation_date}

    ${sort_by}    Create Dictionary    field=creationDate    order=desc
    @{orders}    Create List    ${sort_by}
    ${result}    POST Platform Purchases In-Store Reports Search
    ...    ${GENERAL_SIDE}
    ...    ${restrictions}
    ...    ${orders}
    ...    0
    ...    1
    Should Be Equal As Integers    ${result['status_code']}    422
    Should Be Equal As Strings    ${result['body']['result']['title']}    INVALID_ACTIVITY_QUERY_DATE_RANGE
    Should Be Equal As Strings    ${result['body']['result']['message']}    بازه زمانی بیش‌تر از ۲ ماه نامعتبر است.
    Should Be Equal As Integers    ${result['body']['result']['status']}    11002
    Should Be Equal As Strings    ${result['body']['result']['level']}    WARN
