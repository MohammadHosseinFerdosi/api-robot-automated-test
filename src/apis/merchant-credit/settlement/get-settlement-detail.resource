*** Settings ***
Resource    services/backend/session-service.resource
*** Keywords ***
GET Settlements Detail
    [Documentation]
    [Arguments]    ${api_call_side}
    ...            ${TRACKING_CODE_SETTLEMENT}    

    ${api_path}    Set Variable    /credit/merchants/settlements/${TRACKING_CODE_SETTLEMENT}
    ${header}    Create Dictionary    Agent=WEB    ticket=${Rticket}
    ${session}    Create A Session    ${api_call_side}
    ${result}    GET On Session    
    ...    ${session}    
    ...    ${api_path}
    ...    headers=${header}     
    ...    expected_status=any

    ${response}    Create Dictionary    status_code=${result.status_code}    body=${result.json()}
    RETURN    ${response}

    [Teardown]    Delete A Session    ${session}