*** Settings ***
Resource    services/backend/session-service.resource
Variables    data/los/credit.yaml
Variables    data/CONSTANTS.yaml
Variables    config/environment-stage.yaml

*** Keywords ***
POST Allocation Prepayments In Progress
    [Arguments]    ${api_call_side}    ${api_path}    ${header}    ${body}    ${basic_auth_param}
    
    ${session}    Create A Session    ${api_call_side}    ${basic_auth_param}
    
    ${response}    POST On Session
    ...    ${session}
    ...    ${api_path}
    ...    headers=${header}
    ...    json=${body}
    ...    expected_status=any
    
    ${status}    ${json_body}=    Run Keyword And Ignore Error    Call Method    ${response}    json
    ${final_body}=    Set Variable If    '${status}' == 'PASS'    ${json_body}    ${response.text}
    
    &{result}=    Create Dictionary
    ...    status_code=${response.status_code}
    ...    body=${final_body}
    
    [Teardown]    Delete A Session    ${session}
    
    RETURN    ${result}

