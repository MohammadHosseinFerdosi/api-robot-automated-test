*** Settings ***
Documentation    API Keyword For Credit Tac General
Resource    services/backend/session-service.resource
Variables   config/environment-stage.yaml
Variables   data/los/credit.yaml

*** Keywords ***
POST Credit Tac General
    [Arguments]    ${user_id}
    
    ${session}=    Create A Session    ${MICROSERVICE_SIDE}  
    
    ${header}=    Create Dictionary    
    ...    User-Id=${user_id}    
    ...    Content-Type=${CREDIT_CONTENT_TYPE}

    ${body}=    Create Dictionary

    ${api_path}=    Set Variable    ${MS_CREDIT_ONBOARDING_PATH}/tac/general
    
    ${response}    POST On Session
    ...    ${session}
    ...    ${api_path}
    ...    headers=${header}
    ...    data=${body}
    ...    expected_status=any
    
    [Teardown]    Delete A Session    ${session}
    
    RETURN    ${response}