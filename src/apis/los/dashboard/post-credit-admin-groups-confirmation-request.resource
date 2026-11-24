*** Settings ***
Documentation    API Keyword for Requesting Confirmation for a Credit Group
Resource         services/backend/session-service.resource
Library          RequestsLibrary
Library          Collections
Variables        data/los/credit.yaml

*** Keywords ***
POST Credit Admin Groups Confirmation Request
    [Documentation]    Sends POST request to initiate the confirmation process for a credit group.
    [Arguments]    
    ...    ${api_call_side}
    ...    ${user_id}    
    ...    ${group_id}
    
    ${header}    Create Dictionary     
    ...    User-Id=${user_id}    
    ...    Content-Type=${CREDIT_CONTENT_TYPE}

    ${api_path}    Set Variable    /admin/groups/confirmation-request/${group_id}
    
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
