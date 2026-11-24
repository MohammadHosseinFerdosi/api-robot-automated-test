*** Settings ***
Library     RequestsLibrary
Resource    services/backend/session-service.resource
Variables   config/environment-stage.yaml
Variables   data/los/credit.yaml

*** Keywords ***
POST Credit Admin Organizations Search
    [Arguments]    ${api_call_side}    ${user_id}    ${page}    ${size}    ${restrictions}    ${orders}
    [Documentation]    Sends POST request to search admin organizations
    
    ${session}=    Create A Session    ${api_call_side}
    
    ${headers}=    Create Dictionary    
    ...    User-Id=${user_id}    
    ...    Content-Type=${CREDIT_CONTENT_TYPE}

    ${body}=    Create Dictionary
    ...    restrictions=${restrictions}
    ...    orders=${orders}

    ${api_path}=    Set Variable    ${MS_CREDIT_ONBOARDING_PATH}/admin/organizations/search?page=${page}&size=${size}
    
    ${response}=    POST On Session
    ...    ${session}
    ...    ${api_path}
    ...    headers=${headers}
    ...    json=${body}
    ...    expected_status=any
    
    [Teardown]    Run Keyword If    $session is not None    Delete A Session    ${session}
    
    RETURN    ${response}