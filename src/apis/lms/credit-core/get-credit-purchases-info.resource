*** Settings ***
Library         String
Library         Collections
Library         RequestsLibrary
Variables       data/CONSTANTS.yaml
Resource        services/backend/session-service.resource
Resource        services/backend/auth-service.resource


*** Keywords ***
GET Credit Purchases Info
    [Documentation]    Sends a request to the Credit Purchases Ticket API with the specified parameters.
    [Arguments]
    ...    ${api_call_side}
    ...    ${ticket}
    ...    ${credit_amount}

    ${api_path}=    Set Variable    /credit/purchases/info/${ticket}
    IF    '${api_call_side}' == '${MICROSERVICE_SIDE}'
        ${api_path}=    Set Variable    ${MS_CREDIT_MNG_PATH}/purchases/info/${ticket}
    END
    ${params}=    Create Dictionary    creditAmount=${credit_amount}
    
    ${session}=    Create A Session    ${api_call_side}

    ${response}=    GET On Session
    ...    ${session}
    ...    ${api_path}
    ...    params=${params}
    ...    expected_status=any

    ${result}=    Create Dictionary    status_code=${response.status_code}    body=${response.json()}
    RETURN    ${result}

    [Teardown]    Delete A Session    ${session}