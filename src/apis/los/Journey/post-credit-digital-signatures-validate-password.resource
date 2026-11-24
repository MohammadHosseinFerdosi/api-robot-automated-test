*** Settings ***
Resource    services/backend/session-service.resource
Variables    data/los/credit.yaml

*** Keywords ***
POST Credit Digital Signatures Validate Password
    [Arguments]    ${api_call_side}    ${api_path}    ${header}    ${body}    ${basic_auth_param}
    
    ${session}=    Create A Session    ${api_call_side}    ${basic_auth_param}
    
    ${response}=    POST On Session
    ...    ${session}
    ...    ${api_path}
    ...    headers=${header}
    ...    json=${body}
    ...    expected_status=any
    
    &{result}=    Create Dictionary
    ...    status_code=${response.status_code}
    ...    body=${response.json()}
    
    [Teardown]    Delete A Session    ${session}
    RETURN    ${result}
