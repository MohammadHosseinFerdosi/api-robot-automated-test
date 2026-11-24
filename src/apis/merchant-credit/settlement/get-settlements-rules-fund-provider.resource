*** Settings ***
Resource    services/backend/session-service.resource
*** Keywords ***
GET Settlements Rules Fund Provider
    [Documentation]    This API will receive tracking code, registration ID and 
    ...    returned a list of user's approved fund provider     
    [Arguments]    ${api_call_side}
    ...            ${registartion_id}
    ...            ${trackingcode}    


    ${api_path}    Set Variable    /credit/merchants/rules/${registartion_id}/fund-providers/${trackingcode}
    ${header}    Create Dictionary    ticket=${SETTLEMENT_TICKET}
    ${session}    Create A Session    ${api_call_side}
    ${result}    GET On Session    
    ...    ${session}
    ...    ${api_path}     
    ...    expected_status=any
    ...    headers=${header}
    ${response}    Create Dictionary    status_code=${result.status_code}    body=${result.json()}
    RETURN    ${response}

    [Teardown]    Delete A Session    ${session}
             