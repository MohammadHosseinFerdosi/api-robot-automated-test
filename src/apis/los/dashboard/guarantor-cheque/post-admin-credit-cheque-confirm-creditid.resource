*** Settings ***
Resource    services/backend/session-service.resource
Variables   data/los/credit.yaml

*** Keywords ***
POST Admin Credit Cheques Accept Activation Status
    [Arguments]
    ...    ${api_call_side}
    ...    ${credit_id}
    ${header}    Create Dictionary    User-id=${ADMIN_USER_ID}
    ${api_path}    Set Variable    /admin/cheques/confirm/${credit_id}
    IF    '${api_call_side}' == '${MICROSERVICE_SIDE}'
        ${api_path}    Set Variable    ${MS_CREDIT_ONBOARDING_PATH}${api_path}
    END
    ${body}    Create Dictionary
    ${session}    Create A Session    ${api_call_side}
    ${response}    POST On Session
    ...    ${session}
    ...    ${api_path}
    ...    json=${body}
    ...    headers=${header}
    ...    expected_status=any
    ${result}    Create Dictionary    status_code=${response.status_code}    body=${response.json()}
    RETURN    ${result}
    [Teardown]    Delete A Session    ${session}
