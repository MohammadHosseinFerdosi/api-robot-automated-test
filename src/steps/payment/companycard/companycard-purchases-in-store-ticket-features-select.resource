*** Settings ***
Library     String
Library     Collections
Resource    apis/companycard/post-companycard-purchases-in-store-ticket-features-select.resource
Resource    services/backend/auth-service.resource
Resource    steps/payment/companycard/companycard-purchases-in-store-ticket-step.resource
Resource    services/backend/value-handler.resource


*** Keywords ***
Success Select BPG Feature On In-Store Purchase
    Success Getting Ticket On Pos Terminal
    ${select_faeture}    POST CompanyCard Purchases In Store Ticket Features Select
    ...    ${GENERAL_SIDE}
    ...    ${pos_ticket}
    ...    ${BPG_FEATURE_NAME}
    ...    ${ANDROID_AGENT}
    ...    ${PLATFORM_VERSION_2024}

    Should Be Equal As Integers    ${select_faeture['status_code']}    200
    Should Be Equal As Strings    ${select_faeture['body'].result.title}    ${SUCCESS_TITLE}
    Should Be Equal As Integers    ${select_faeture['body'].result.status}    ${SUCCESS_STATUS_CODE}
    Should Be Equal As Strings    ${select_faeture['body'].result.message}    ${SUCCESS_MESSAGE}
    Should Be Equal As Strings    ${select_faeture['body'].result.level}    ${INFO_LEVEL}

    Dictionary Should Contain Key
    ...    ${select_faeture['body']}
    ...    ticket
    Should Be Equal As Strings    ${select_faeture['body']['payUrl']}    ${BPG_PAY_URL}/${pos_ticket}
    Dictionary Should Contain Key
    ...    ${select_faeture['body']}
    ...    userId
    ${filter_query}    Create Dictionary    ticket=${pos_ticket}
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

Success Select CPG Feature On In-Store Purchase
    Success Getting Ticket On Pos Terminal
    ${select_faeture}    POST CompanyCard Purchases In Store Ticket Features Select
    ...    ${GENERAL_SIDE}
    ...    ${pos_ticket}
    ...    ${CPG_FEATURE_NAME}
    ...    ${ANDROID_AGENT}
    ...    ${PLATFORM_VERSION_2024}

    Should Be Equal As Integers    ${select_faeture['status_code']}    200
    Should Be Equal As Strings    ${select_faeture['body'].result.title}    ${SUCCESS_TITLE}
    Should Be Equal As Integers    ${select_faeture['body'].result.status}    ${SUCCESS_STATUS_CODE}
    Should Be Equal As Strings    ${select_faeture['body'].result.message}    ${SUCCESS_MESSAGE}
    Should Be Equal As Strings    ${select_faeture['body'].result.level}    ${INFO_LEVEL}

    Dictionary Should Contain Key
    ...    ${select_faeture['body']}
    ...    ticket
    Should Be Equal As Strings    ${select_faeture['body']['payUrl']}    ${CPG_PAY_URL}/${pos_ticket}
    Dictionary Should Contain Key
    ...    ${select_faeture['body']}
    ...    userId
    ${filter_query}    Create Dictionary    ticket=${pos_ticket}
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

Select A Non-Existent Feature
    Success Getting Ticket On Pos Terminal
    ${select_faeture}    POST CompanyCard Purchases In Store Ticket Features Select
    ...    ${GENERAL_SIDE}
    ...    ${pos_ticket}
    ...    50
    ...    ${ANDROID_AGENT}
    ...    ${PLATFORM_VERSION_2024}

    Should Be Equal As Integers    ${select_faeture['status_code']}    422
    Should Be Equal As Strings    ${select_faeture['body'].result.title}    ${INTERNAL_ERROR_TITLE}
    Should Be Equal As Integers    ${select_faeture['body'].result.status}    ${INTERNAL_ERROR_STATUS_CODE}
    Should Be Equal As Strings    ${select_faeture['body'].result.message}    ${INTERNAL_ERROR_MESSAGE}
    Should Be Equal As Strings    ${select_faeture['body'].result.level}    ${WARNING_LEVEL}

Change Selected Feature On In-Store Purchase
    Success Getting Ticket On Pos Terminal
    ${select_faeture}    POST CompanyCard Purchases In Store Ticket Features Select
    ...    ${GENERAL_SIDE}
    ...    ${pos_ticket}
    ...    ${BPG_FEATURE_NAME}
    ...    ${ANDROID_AGENT}
    ...    ${PLATFORM_VERSION_2024}

    Should Be Equal As Integers    ${select_faeture['status_code']}    200
    Should Be Equal As Strings    ${select_faeture['body'].result.title}    ${SUCCESS_TITLE}
    Should Be Equal As Integers    ${select_faeture['body'].result.status}    ${SUCCESS_STATUS_CODE}
    Should Be Equal As Strings    ${select_faeture['body'].result.message}    ${SUCCESS_MESSAGE}
    Should Be Equal As Strings    ${select_faeture['body'].result.level}    ${INFO_LEVEL}

    ${next_select_faeture}    POST CompanyCard Purchases In Store Ticket Features Select
    ...    ${GENERAL_SIDE}
    ...    ${pos_ticket}
    ...    ${CPG_FEATURE_NAME}
    ...    ${ANDROID_AGENT}
    ...    ${PLATFORM_VERSION_2024}

    Should Be Equal As Integers    ${next_select_faeture['status_code']}    422
    Should Be Equal As Strings    ${next_select_faeture['body'].result.title}    ${INTERNAL_ERROR_TITLE}
    Should Be Equal As Integers    ${next_select_faeture['body'].result.status}    ${INTERNAL_ERROR_STATUS_CODE}
    Should Be Equal As Strings    ${next_select_faeture['body'].result.message}    ${INTERNAL_ERROR_MESSAGE}
    Should Be Equal As Strings    ${next_select_faeture['body'].result.level}    ${WARNING_LEVEL}
