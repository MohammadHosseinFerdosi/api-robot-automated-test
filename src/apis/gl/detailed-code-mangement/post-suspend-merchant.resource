*** Settings ***
Resource        services/backend/session-service.resource

*** Keywords ***
POST suspend merchant
    [Arguments]
    ...    ${api_call_side}
    ...    ${id}
    ...    ${isSuspended}= False

    ${headers}=    Create Dictionary
    ...    accept=application/json
    ...    content-type=application/json

    ${api_path}=    Set Variable    /api/gl/admin/profile-mappings/suspend-merchant
    ${api_path}=    Set Variable    ${MICROSERVICE_BASE_URL}${MS_GL_PATH}${api_path}

    ${isSuspended}=    Convert To Boolean    ${isSuspended}
    &{body}=    Create Dictionary
    ...    id=${id}
    ...    isSuspended=${isSuspended}


    ${session}    Create A Session    ${api_call_side}
    ${response}=    POST On Session
    ...    ${session}
    ...    ${api_path}
    ...    json=${body}
    ...    expected_status=any


    ${result}    Create Dictionary    status_code=${response.status_code}    body=${response.json()}
    RETURN    ${result}

    [Teardown]    Delete A Session    ${session}    