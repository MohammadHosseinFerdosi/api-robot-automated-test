*** Settings ***
Documentation    API Keyword for Triggering/Updating Credit Group State (No Auth)
Resource         services/backend/session-service.resource
Library          RequestsLibrary
Library          Collections
Variables         data/los/credit.yaml


*** Keywords ***
POST Credit Admin Groups State
    [Documentation]    Sends POST request to update state without Authorization header.
    [Arguments]    
    ...    ${api_call_side}
    ...    ${user_id}    
    ...    ${group_id}
    
    ${header}    Create Dictionary    
    ...    User-Id=${user_id}    
    ...    Content-Type=${CREDIT_CONTENT_TYPE}
    ...    Authorization=${None} 

    ${api_path}    Set Variable    /admin/groups/state/${group_id}
    
    IF    '${api_call_side}' == '${MICROSERVICE_SIDE}'
        ${api_path}    Set Variable    ${MS_CREDIT_ONBOARDING_PATH}${api_path}
    END

    ${body}    Create Dictionary

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
