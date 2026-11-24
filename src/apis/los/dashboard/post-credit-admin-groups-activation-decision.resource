*** Settings ***
Documentation    API Keyword for Credit Group Activation Decision
Resource         services/backend/session-service.resource
Library          RequestsLibrary
Library          Collections
Variables         data/los/credit.yaml
*** Keywords ***
POST Credit Admin Groups Activation Decision
    [Documentation]    Sends POST request for group activation with a dynamic deadline.
    [Arguments]    
    ...    ${api_call_side}
    ...    ${user_id}    
    ...    ${group_id}
    ...    ${deadline_timestamp}
    ...    ${accept_decision}=${True}
    
    ${header}    Create Dictionary    
    ...    User-Id=${user_id}    
    ...    Content-Type=${CREDIT_CONTENT_TYPE} 

    ${api_path}    Set Variable    /admin/groups/activation-decision/${group_id}
    
    IF    '${api_call_side}' == '${MICROSERVICE_SIDE}'
        ${api_path}    Set Variable    ${MS_CREDIT_ONBOARDING_PATH}${api_path}
    END

    ${body}    Create Dictionary
    ...    groupActivationDeadLine=${deadline_timestamp}
    ...    acceptDecision=${accept_decision}

    ${session}    Create A Session    ${api_call_side}
    
    ${response}    POST On Session
    ...    ${session}
    ...    ${api_path}
    ...    headers=${header}
    ...    json=${body}
    ...    expected_status=any

    ${result}    Create Dictionary    status_code=${response.status_code}    body=${response.json()}
    
    RETURN    ${result}
    
    [Teardown]    Delete A Session    ${session}
