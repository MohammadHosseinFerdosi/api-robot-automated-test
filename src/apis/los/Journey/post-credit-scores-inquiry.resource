*** Settings ***
Resource    services/backend/session-service.resource
Variables   data/los/credit.yaml

*** Keywords ***
POST Credit Scores Inquiry
    [Arguments]
    ...    ${api_call_side}
    ...    ${credit_id}
    ...    ${user_id}
    ${header}=    Create Dictionary
    ...    User-Id=${user_id}
    ...    content-type=${CREDIT_CONTENT_TYPE}
    ${api_path}=    Set Variable    /scores/inquiry/${credit_id}
    IF    '${api_call_side}' == '${MICROSERVICE_SIDE}'
        ${api_path}=    Set Variable    ${MS_CREDIT_ONBOARDING_PATH}/scores/inquiry/${credit_id}
    ELSE
        ${api_path}=    Set Variable    /credit/scores/inquiry/${credit_id}
    END
    ${body}=    Create Dictionary
    ${session}=    Create A Session    ${api_call_side}
    ${response}=    POST On Session
    ...    ${session}
    ...    ${api_path}
    ...    json=${body}
    ...    headers=${header}
    ...    expected_status=any
    &{result}=    Create Dictionary
    ...    status_code=${response.status_code}
    ...    body=${response.json()}
    RETURN    ${result}
    [Teardown]    Delete A Session    ${session}
