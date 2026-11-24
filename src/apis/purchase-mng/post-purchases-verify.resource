*** Settings ***
Library         Collections
Library         RequestsLibrary
Variables       data/CONSTANTS.yaml
Resource        services/backend/session-service.resource


*** Keywords ***
POST Purchases Verify
    [Documentation]    This API Gets ${trackingCode} Related To A Purchase As Mandatory Data In URL And Will Verify Purchase If Status Is Correct.
    [Arguments]
    ...    ${api_call_side}
    ...    ${trackingCode}
    ...    ${user-id}=${EMPTY}
    

    ${api_path}    Set Variable    /purchases/verify/${trackingCode}
    IF    '${api_call_side}' == '${MICROSERVICE_SIDE}'
        ${api_path}    Set Variable   ${MS_PURCHASE_PATH}${api_path}

    END
    
    ${headers}    Create Dictionary    User-Id=${user-id}
    ${session}    Create A Session    ${api_call_side}
    ${result}    POST On Session
    ...    ${session}
    ...    ${api_path}
    ...    headers=${headers}
    ...    expected_status=any

    ${response}    Create Dictionary    status_code=${result.status_code}    body=${result.json()}
    RETURN    ${response}
    [Teardown]    Delete A Session    ${session}
