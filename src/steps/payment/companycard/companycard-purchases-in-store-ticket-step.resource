*** Settings ***
Library         String
Library         Collections
Resource        apis/companycard/post-platform-purchases-in-store-ticket.resource
Resource        services/backend/auth-service.resource
Resource        services/db/mongo-db-service.resource
Variables       data/backend/payment/companycard/companycard.yaml
Resource        services/backend/value-handler.resource


*** Keywords ***
Success Getting Ticket On Pos Terminal
    ${get_ticket}    POST CompanyCard Purchases In Store Ticket
    ...    ${GENERAL_SIDE}
    ...    ${POS_TERMINAL_ID}
    ...    ${VALID_HASHED_PAN}
    ...    ${POS_TEST_AMOUNT}
    ...    ${IRANKISH_PSP_CODE}
    ...    ${ANDROID_AGENT}
    ...    ${PLATFORM_VERSION_2024}

    Should Be Equal As Integers    ${get_ticket['status_code']}    200
    Should Be Equal As Strings    ${get_ticket['body'].result.title}    ${SUCCESS_TITLE}
    Should Be Equal As Integers    ${get_ticket['body'].result.status}    ${SUCCESS_STATUS_CODE}
    Should Be Equal As Strings    ${get_ticket['body'].result.message}    ${SUCCESS_MESSAGE}
    Should Be Equal As Strings    ${get_ticket['body'].result.level}    ${INFO_LEVEL}

    Dictionary Should Contain Key
    ...    ${get_ticket['body']}
    ...    ticket
    Set Test Variable    ${pos_ticket}    ${get_ticket['body']['ticket']}
    Dictionary Should Contain Key
    ...    ${get_ticket['body']}
    ...    providerId

    Should Be Equal As Strings    ${get_ticket['body']['fallbackUrl']}    ${FALLBACK_URL}
    Dictionary Should Contain Key
    ...    ${get_ticket['body']}
    ...    type
    Should Be Equal As Integers    ${get_ticket['body']['type']}    ${UPG_TICKET_TYPE}

    Should Be Equal As Strings    ${get_ticket['body']['amount']}    ${POS_TEST_AMOUNT}
    Dictionary Should Contain Key
    ...    ${get_ticket['body']}
    ...    ttl
    Dictionary Should Contain Key
    ...    ${get_ticket['body']}
    ...    features
    ${payment_method_length}    Get Length    ${get_ticket['body'].features}
    ${features_list}    Create List    ${get_ticket['body'].features[0].name}

    FOR    ${index}    IN RANGE    1    ${payment_method_length}
        Append To List    ${features_list}    ${get_ticket['body'].features[${index}].name}
        ${features_list_length}    Get Length    ${features_list}
    END
    Sort List    ${features_list}
    Should Be Equal    ${features_list}    ${POS_PAYMENT_METHODS}
    Dictionary Should Contain Key
    ...    ${get_ticket['body']}
    ...    userDetail
    Dictionary Should Contain Key
    ...    ${get_ticket['body']['userDetail']}
    ...    userId
    Dictionary Should Contain Key
    ...    ${get_ticket['body']['userDetail']}
    ...    cellNumber
    ${filter_query}    Create Dictionary    ticket=${pos_ticket}
    ${data_response}    Mongo Db Find
    ...    ${COMPANYCARD_DB_NAME}
    ...    ${COMPANYCARD_PLATFORM_PURCHASES_COLLECTION}
    ...    ${filter_query}
    Should Be Equal As Integers    ${data_response['status_code']}    0
    Should Not Be Empty    ${data_response['body']}
    ${body}    Set Variable    ${data_response['body']}[0]
    Should Be Equal As Strings    ${body['status']}    TICKET
    ${data_response_amount}    Value Handler    ${body['amount']}
    Should Be Equal As Integers    ${data_response_amount}    ${POS_TEST_AMOUNT}
    Should Be Equal As Strings    ${body['channel']}    ${COMPANYCARD_POS_CHANNEL}
    Should Be Equal As Strings    ${body['terminalId']}    ${POS_TERMINAL_ID}

Get In-Store Ticket With A TerminalId Not Related To Merchant
    Login For Business    ${OFFLINE_PAYMENT_USERID}    ${OFFLINE_PAYMENT_PASSWORD}
    ${get_ticket}    POST CompanyCard Purchases In Store Ticket
    ...    ${GENERAL_SIDE}
    ...    ${NOT_RELATED_TERMINAL_ID}
    ...    ${VALID_HASHED_PAN}
    ...    ${POS_TEST_AMOUNT}
    ...    ${IRANKISH_PSP_CODE}
    ...    ${ANDROID_AGENT}
    ...    ${PLATFORM_VERSION_2024}

    Should Be Equal As Integers    ${get_ticket['status_code']}    422
    Should Be Equal As Strings    ${get_ticket['body'].result.title}    ${NOT_RELATED_TITLE}
    Should Be Equal As Integers    ${get_ticket['body'].result.status}    ${NOT_RELATED_STATUS_CODE}
    Should Be Equal As Strings    ${get_ticket['body'].result.message}    ${NOT_RELATED_MESSAGE}
    Should Be Equal As Strings    ${get_ticket['body'].result.level}    ${WARNING_LEVEL}

Get In-Store Ticket With An Invalid Hashed Pan
    Login For Business    ${OFFLINE_PAYMENT_USERID}    ${OFFLINE_PAYMENT_PASSWORD}
    ${get_ticket}    POST CompanyCard Purchases In Store Ticket
    ...    ${GENERAL_SIDE}
    ...    ${POS_TERMINAL_ID}
    ...    ${INVALID_HASHED_PAN}
    ...    ${POS_TEST_AMOUNT}
    ...    ${IRANKISH_PSP_CODE}
    ...    ${ANDROID_AGENT}
    ...    ${PLATFORM_VERSION_2024}

    Should Be Equal As Integers    ${get_ticket['status_code']}    422
    Should Be Equal As Strings    ${get_ticket['body'].result.title}    ${INVALID_CARD_TITLE}
    Should Be Equal As Integers    ${get_ticket['body'].result.status}    ${INVALID_CARD_STATUS_CODE}
    Should Be Equal As Strings    ${get_ticket['body'].result.message}    ${INVALID_CARD_MESSAGE}
    Should Be Equal As Strings    ${get_ticket['body'].result.level}    ${WARNING_LEVEL}

Get In-Store Ticket With An Invalid PSP Code
    Login For Business    ${OFFLINE_PAYMENT_USERID}    ${OFFLINE_PAYMENT_PASSWORD}
    ${get_ticket}    POST CompanyCard Purchases In Store Ticket
    ...    ${GENERAL_SIDE}
    ...    ${POS_TERMINAL_ID}
    ...    ${VALID_HASHED_PAN}
    ...    ${POS_TEST_AMOUNT}
    ...    ${INVALID_PSP_CODE}
    ...    ${ANDROID_AGENT}
    ...    ${PLATFORM_VERSION_2024}

    Should Be Equal As Integers    ${get_ticket['status_code']}    422
    Should Be Equal As Strings    ${get_ticket['body'].result.title}    ${PSP_NOT_FOUND_TITLE}
    Should Be Equal As Integers    ${get_ticket['body'].result.status}    ${PSP_NOT_FOUND_STATUS_CODE}
    Should Be Equal As Strings    ${get_ticket['body'].result.message}    ${PSP_NOT_FOUND_MESSAGE}
    Should Be Equal As Strings    ${get_ticket['body'].result.level}    ${WARNING_LEVEL}
