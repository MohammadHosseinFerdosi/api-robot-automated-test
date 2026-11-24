*** Settings ***
Resource    services/backend/session-service.resource
Variables    data/los/credit.yaml
Variables    data/CONSTANTS.yaml
Variables    config/environment-stage.yaml

*** Keywords ***
POST Credit Admin Cheques Accept
    [Arguments]    ${api_call_side}    ${user_id}    ${body}    ${basic_auth_param}=${EMPTY}
    
    ${header}    Create Dictionary
    ...    Content-Type=${CREDIT_CONTENT_TYPE}
    ...    Origin=${DASHBOARD_BASE_URL}
    ...    User-id=${user_id}
    
    ${api_path}    Set Variable    /admin/cheques/accept
    IF    '${api_call_side}' == '${MICROSERVICE_SIDE}'
        ${api_path}    Set Variable    ${MS_CREDIT_ONBOARDING_PATH}${api_path}
    ELSE
        ${api_path}    Set Variable    /credit${api_path}
    END

    ${session}    Create A Session    ${api_call_side}    ${basic_auth_param}
    ${response}    POST On Session
    ...    ${session}
    ...    ${api_path}
    ...    headers=${header}
    ...    json=${body}
    ...    expected_status=any

    &{result}    Create Dictionary
    ...    status_code=${response.status_code}
    ...    body=${response.json()}
    RETURN    ${result}
    
    [Teardown]    Delete A Session    ${session}
