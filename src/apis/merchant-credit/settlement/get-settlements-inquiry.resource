*** Settings ***
Resource    services/backend/session-service.resource

*** Keywords ***
GET Settlements Inquiry
    [Documentation]    This Api is called with the business side like company to query the settlement status 
    [Arguments]    
    ...    ${api_call_side}    
    ...    ${TRACKING_CODE_SETTLEMENT}

    ${api_path}    Set Variable    /credit/merchants/settlements/${TRACKING_CODE_SETTLEMENT}/inquiry
    
    ${session}    Create A Session    ${api_call_side}
    ${result}    GET On Session    
    ...    ${session}
    ...    ${api_path}     
    ...    expected_status=any

    ${response}    Create Dictionary    status_code=${result.status_code}    body=${result.json()}
    RETURN    ${response}

    [Teardown]    Delete A Session    ${session}