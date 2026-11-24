*** Settings ***
Library    RequestsLibrary
Library    Collections
Resource   services/backend/session-service.resource

*** Keywords ***
Put Settlements Fee Init
    [Arguments]    ${api_call_side}   
            ...    ${amount}    
            ...    ${rule_id}

    ${body}  Create Dictionary     
    ...    updatedAmount=${amount}    
    ...    ruleId=${rule_id} 
    ${header}    Create Dictionary    ticket=${SETTLEMENT_TICKET}
    ${sesion}    Create A Session    ${api_call_side}
    ${response}  PUT On Session
    ...    ${sesion}
    ...    /credit/merchants/settlements/${TRACKING_CODE_SETTLEMENT}/fee/init
    ...    headers=${header}
    ...    json=${body}    
    ...    expected_status=any
        ${result}    Create Dictionary    status_code=${response.status_code}    response=${response.json()}
        RETURN    ${result}
    [Teardown]    Delete A Session    ${sesion}