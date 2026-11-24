*** Settings ***
Library         Collections
Library         String
Library         JSONLibrary
Library         RequestsLibrary
Variables       data/CONSTANTS.yaml
Resource        services/backend/session-service.resource


*** Keywords ***
Post admin Purchase setting
    [Documentation]    This API takes a ${business_id} and list @{active_gateways} then return`response status code` and
    ...    all business pay types including gateway type, active status and supported status
    [Arguments]
    ...    ${api_call_side}
    ...    ${business_id}
    ...    @{active_gateways}

    ${api_path}    Set Variable    /admin/purchases/settings
    IF    '${api_call_side}' == '${MICROSERVICE_SIDE}'
        ${api_path}    Set Variable   ${MS_PURCHASE_PATH}${api_path}
    END

    ${api_path}    Set Variable   ${api_path}/${business_id}
    
    ${header}    Create Dictionary

    ${body}    Create Dictionary
    ...    activeGateways=@{active_gateways}
    
    ${session}    Create A Session    ${api_call_side}
    ${response}    POST On Session    ${session}
    ...    ${api_path}
    ...    headers=${header}
    ...    json=${body}
    ...    expected_status=any
    ${result}    Create Dictionary    status_code=${response.status_code}    body=${response.json()}
    RETURN    ${result}

    [Teardown]    Delete A Session    ${session}
