*** Settings ***
Library         Collections
Library         RequestsLibrary
Variables       data/CONSTANTS.yaml
Resource        services/backend/session-service.resource


*** Keywords ***
POST Purchases Reverse
    [Documentation]    This API Gets A ${trackingCode} Related To A Purchase And A ${providerId} As Mandatory Data In Body And Will Reverse A Purchase If Status Is Correct.
    [Arguments]
    ...    ${api_call_side}
    ...    ${trackingCode}
    ...    ${provider-id}
    ...    ${user-id}=${EMPTY}
    

    ${api_path}    Set Variable    /purchases/reverse
    IF    '${api_call_side}' == '${MICROSERVICE_SIDE}'
        ${api_path}    Set Variable   ${MS_PURCHASE_PATH}${api_path}
    END
    
    ${body}    Create Dictionary    providerId=${provider-id}    purchaseTrackingCode=${trackingCode}
    ${headers}    Create Dictionary    User-Id=${user-id}
    ${session}    Create A Session    ${api_call_side}
    ${result}    POST On Session
    ...    ${session}
    ...    ${api_path}
    ...    headers=${headers}
    ...    json=${body} 
    ...    expected_status=any

    ${response}    Create Dictionary    status_code=${result.status_code}    body=${result.json()}
    RETURN    ${response}
    [Teardown]    Delete A Session    ${session}
