*** Settings ***
Library         String
Library         Collections
Library         RequestsLibrary
Variables       data/CONSTANTS.yaml
Resource        services/backend/session-service.resource
Resource        services/backend/auth-service.resource


*** Keywords ***
GET Credit Purchases Pay
    [Documentation]    Sends a request to the Credit Purchases Ticket API with the specified parameters.
    [Arguments]
    ...    ${api_call_side}
    ...    ${ticket}
    ${api_path}=    Set Variable    /credit/purchases/pay/${ticket}
    IF    '${api_call_side}' == '${MICROSERVICE_SIDE}'
        ${api_path}=    Set Variable    ${MS_CREDIT_MNG_PATH}/purchases/pay/${ticket}
    END
    ${session}=    Create A Session    ${api_call_side}
    ${response}=    GET On Session
    ...    ${session}
    ...    ${api_path}
    ...    expected_status=any

    ${result}=    Create Dictionary    status_code=${response.status_code}    body=${response.json()}
    RETURN    ${result}

    [Teardown]    Delete A Session    ${session}
