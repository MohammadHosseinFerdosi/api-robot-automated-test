*** Settings ***
Resource    services/backend/session-service.resource

*** Keywords ***
POST Credit Users Admin Upload
    [Arguments]
    ...    ${api_call_side}
    ...    ${group_id}
    ...    ${file}
    ...    ${user_id}
    ${files}    Create Dictionary    file    ${file}
    ${api_path}    Set Variable    /users/upload
    ${header}    Create Dictionary    group-Id=${group_id}
    IF    '${api_call_side}' == '${MICROSERVICE_SIDE}'
        ${api_path}    Set Variable    ${MS_CREDIT_ONBOARDING_PATH}/admin${api_path}
        Set To Dictionary    ${header}    User-Id=${DASHBOARD_USERNAME}
    END
    ${session}    Create A Session    ${api_call_side}
    ${response}    POST On Session
    ...    ${session}
    ...    ${api_path}
    ...    files=${files}
    ...    headers=${header}
    ${result}    Create Dictionary    status_code=${response.status_code}    response_rule=${response.json()}
    RETURN    ${result}
    [Teardown]    Delete A Session    ${session}
