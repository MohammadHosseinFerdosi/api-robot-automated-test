*** Settings ***
Documentation    API Keyword for Reviewing a Credit Group
Resource         services/backend/session-service.resource
Library          RequestsLibrary
Library          Collections

*** Keywords ***
POST Credit Admin Groups Review
    [Documentation]    Sends POST request to review a created credit group.
    [Arguments]    
    ...    ${api_call_side}
    ...    ${user_id}    
    ...    ${group_id}    
    ...    ${comment}
    
    ${header}    Create Dictionary    
    ...    User-Id=${user_id}    
    ...    Content-Type=application/json

    ${api_path}    Set Variable    /admin/groups/review
    IF    '${api_call_side}' == '${MICROSERVICE_SIDE}'
        ${api_path}    Set Variable    ${MS_CREDIT_ONBOARDING_PATH}${api_path}
    END

    ${body}    Create Dictionary    
    ...    groupId=${group_id}    
    ...    comment=${comment}

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
