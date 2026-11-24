*** Settings ***
Library     RequestsLibrary
Library     Collections
Resource    services/backend/session-service.resource


*** Keywords ***
User Health Check Status
    [Arguments]    ${api_call_side}

    ${api_path}=    Set Variable    /payments/gateway/status/0

    ${session}=    Create A Session    ${api_call_side}

    ${response}=    GET On Session
    ...    ${session}
    ...    ${api_path}
    ...    expected_status=any

    ${result}=    Create Dictionary
    ...    status_code=${response.status_code}
    ...    body=${response.json()}
    RETURN    ${result}

    [Teardown]    Delete A Session    ${session}



Business Health Check Status
    [Arguments]    ${api_call_side}
    ...            ${business_id}

    ${api_path}=    Set Variable    /payments/gateway/status/0/${business_id}

    ${session}=    Create A Session    ${api_call_side}

    ${response}=    GET On Session
    ...    ${session}
    ...    ${api_path}
    ...    expected_status=any

    ${result}=    Create Dictionary
    ...    status_code=${response.status_code}
    ...    body=${response.json()}
    RETURN    ${result}

    [Teardown]    Delete A Session    ${session}