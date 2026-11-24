*** Settings ***
Resource        services/backend/session-service.resource

*** Keywords ***
POST search merchants without rahkaran code
    [Arguments]
    ...    ${api_call_side}
    ...    ${page}=0
    ...    ${size}=250
    ...    ${payload}=None


    ${headers}=    Create Dictionary
    ...    accept=application/json
    ...    content-type=application/json


    ${api_path}=    Set Variable    /api/gl/admin/profile-mapping-rahkaran-codes/without-rahkaran-codes?page=${page}&size=${size}
    ${api_path}=    Set Variable    ${MICROSERVICE_BASE_URL}${MS_GL_PATH}${api_path}

    
    IF    $payload == 'None'
        ${payload}=    Create Dictionary
    END


    ${session}    Create A Session    ${api_call_side}
    ${response}=    POST On Session
    ...    ${session}
    ...    ${api_path}
    ...    json=${payload}
    ...    expected_status=any


    ${result}    Create Dictionary    status_code=${response.status_code}    body=${response.json()}
    RETURN    ${result}

    [Teardown]    Delete A Session    ${session}    