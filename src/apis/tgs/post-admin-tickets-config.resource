*** Settings ***
Library         Collections
Library         String
Library         JSONLibrary
Library         RequestsLibrary
Variables       data/CONSTANTS.yaml
Resource        services/backend/session-service.resource


*** Keywords ***
Post admin ticket config
    [Documentation]    This API takes bellow arguments and returns all of them if respose status is 200 
    [Arguments]
    ...    @{transaction_types}
    ...    ${api_call_side}
    ...    ${business_id}
    ...    ${landing_url}
    ...    ${ttl}
    ...    ${type}
    ...    ${feature_orders}

    ${api_path}    Set Variable    /admin/tickets/config
    IF    '${api_call_side}' == '${MICROSERVICE_SIDE}'
        ${api_path}    Set Variable   ${MS_TGS_PATH}${api_path}
    END
    
    ${header}    Create Dictionary

    ${body}    Create Dictionary
    ...    businessId=${business_id}
    ...    featureOrders=${feature_orders}
    ...    landingUrl=${landing_url}
    ...    transactionTypes=@{transaction_types}
    ...    ttl=${ttl}
    ...    type=${type}
    
    ${session}    Create A Session    ${api_call_side}
    ${response}    POST On Session    ${session}
    ...    ${api_path}
    ...    headers=${header}
    ...    json=${body}
    ...    expected_status=any
    ${result}    Create Dictionary    status_code=${response.status_code}    body=${response.json()}
    RETURN    ${result}

    [Teardown]    Delete A Session    ${session}
