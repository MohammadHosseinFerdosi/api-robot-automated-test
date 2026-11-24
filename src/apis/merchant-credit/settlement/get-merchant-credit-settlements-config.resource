*** Settings ***
Resource    services/backend/session-service.resource
*** Keywords ***
GET Merchant Credit Settlements Config
    [Documentation]    This API will receive tracking code of settlement, Rule ID and 
    ...    return maximum and minimum of CreditAmount and also about Fee amount.
    [Arguments]    ${api_call_side}
    ...            ${tracking_code}  
    ...            ${rule_id}
  
    ${api_path}    Set Variable    /credit/merchants/settlements/config/${tracking_code}/${rule_id}

    ${session}    Create A Session    ${api_call_side}
    ${result}    GET On Session    
    ...    ${session}
    ...    ${api_path}     
    ...    expected_status=any

    ${response}    Create Dictionary    status_code=${result.status_code}    body=${result.json()}
    RETURN    ${response}

    [Teardown]    Delete A Session    ${session}
