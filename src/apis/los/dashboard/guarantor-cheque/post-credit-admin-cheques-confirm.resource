*** Settings ***
Resource    services/backend/session-service.resource
Variables   data/los/credit.yaml

*** Keywords ***
POST Credit Cheques Confirm API
    [Arguments]    ${api_path}    ${headers}    ${body}
    
    ${session}    Create A Session    ${MICROSERVICE_SIDE}    ${EMPTY}
    
    ${response}    POST On Session
    ...    ${session}
    ...    ${api_path}
    ...    headers=${headers}
    ...    json=${body}
    ...    expected_status=any
    
    &{result}=    Create Dictionary
    ...    status_code=${response.status_code}
    ...    body=${response.json()}
    
    [Teardown]    Delete A Session    ${session}
    
    RETURN    ${result}
