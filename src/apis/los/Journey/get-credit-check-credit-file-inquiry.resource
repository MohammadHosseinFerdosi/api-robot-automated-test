*** Settings ***
Resource    services/backend/session-service.resource
Variables    data/los/credit.yaml
Variables    data/CONSTANTS.yaml
Variables    config/environment-stage.yaml

*** Keywords ***
GET Credit Check Credit File Inquiry
    [Arguments]    ${api_call_side}    ${api_path}    ${header}    ${body}    ${basic_auth_param}
    
    ${session}    Create A Session    ${api_call_side}    ${basic_auth_param}
    
    ${response}    GET On Session
    ...    ${session}
    ...    ${api_path}
    ...    headers=${header}
    ...    data=${body}
    ...    expected_status=any
    
    &{result}=    Create Dictionary
    ...    status_code=${response.status_code}
    ...    body=${response.json()}
    
    [Teardown]    Delete A Session    ${session}
    
    RETURN    ${result}
