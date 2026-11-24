*** Settings ***
Library     String
Library     Collections
Library     RequestsLibrary
Resource    services/backend/session-service.resource


*** Keywords ***
POST Credit Merchants Payment Methods Customer
    [Documentation]    Payment Methods (PM) inquiry customer.
    [Arguments]
    ...    ${api_call_side}
    ...    ${user_id}
    ...    ${amount}
    ...    ${channel}
    ...    ${business_id}
    ${api_path}    Set Variable    /payment-methods/customers
    ${headers}    Create Dictionary
    IF    '${api_call_side}' == '${MICROSERVICE_SIDE}'
        ${api_path}    Set Variable    ${MS_CREDIT_MNG_MERCHANTS_PATH}${api_path}
        Set To Dictionary    ${headers}    User-Id=${business_id}
    END
    ${body}    Create Dictionary
    ...    userId=${user_id}
    ...    amount=${amount}
    ...    channel=${channel}

    ${session}    Create A Session    ${api_call_side}
    ${response}    POST On Session
    ...    ${session}
    ...    ${api_path}
    ...    json=${body}
    ...    headers=${headers}
    ...    expected_status=any

    ${result}    Create Dictionary    status_code=${response.status_code}    body=${response.json()}
    RETURN    ${result}

    [Teardown]    Delete A Session    ${session}
