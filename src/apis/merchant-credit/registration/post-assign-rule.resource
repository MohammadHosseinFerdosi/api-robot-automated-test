*** Settings ***
Library         String
Library         Collections
Library         RequestsLibrary
Library         JSONLibrary
Resource        services/backend/session-service.resource

*** Keywords ***

POST Assign Rule
    [Arguments]    
    ...    ${Rticket}    
    ...    ${api_call_side}
    ...    ${rule_id}    
    ...    ${registration_id}    

    ${header}    Create Dictionary  
     ...    ticket=${Rticket}    

    &{rule_body}    Create Dictionary    
    ...    ruleId=${rule_id}

    ${sesion_rule}    Create A Session    ${api_call_side}
    ${result_response}    POST On Session
    ...    ${sesion_rule}
    ...    /credit/merchants/${registration_id}/rule
    ...    json=${rule_body}
    ...    headers=${header}
    ...    expected_status=any
    ${result_rule}    Create Dictionary    status_code=${result_response.status_code}    response_rule=${result_response.json()}
    RETURN    ${result_rule}

    [Teardown]    Delete A Session    ${sesion_rule}