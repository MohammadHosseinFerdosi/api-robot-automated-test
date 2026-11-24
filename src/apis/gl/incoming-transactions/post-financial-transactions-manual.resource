*** Settings ***
Resource        services/backend/session-service.resource
Library         DateTime


*** Keywords ***
POST create Financial Transaction
    [Arguments]
    ...    ${api_call_side}
    ...    ${event_code} 
    ...    ${inner_json}
    ...    ${transaction_request_id}
    ...    ${PARENT_EVENT_CODE}
    ...    ${AMOUNT}
    ...    ${CLIENT_ID}
    ...    ${USER_ID}
    ...    ${COOKIE}


    ${headers}=    Create Dictionary
    ...    user-id=${USER_ID}
    ...    Cookie=${COOKIE}


    ${api_path}=    Set Variable    /api/gl/admin/financial/transactions/manual
    ${api_path}=    Set Variable    ${MICROSERVICE_BASE_URL}${MS_GL_PATH}${api_path}

    ${now}=    Get Current Date    result_format=%Y-%m-%dT%H:%M:%S+03:30

    &{body}=    Create Dictionary
    ...    requestId=${transaction_request_id}
    ...    eventCode=${event_code}
    ...    parentEventCode=${PARENT_EVENT_CODE}
    ...    amount=${AMOUNT}
    ...    clientId=${CLIENT_ID}
    ...    effectiveDate=${now}
    ...    json=${inner_json}


    ${session}    Create A Session    ${api_call_side}
    ${response}=    POST On Session
    ...    ${session}
    ...    ${api_path}
    ...    json=${body}
    ...    headers=${headers}
    ...    expected_status=any


    ${result}    Create Dictionary    status_code=${response.status_code}    body=${response.json()}
    RETURN    ${result}

    [Teardown]    Delete A Session    ${session}