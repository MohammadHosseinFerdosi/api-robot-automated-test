*** Settings ***
Library         RequestsLibrary
Variables       data/CONSTANTS.yaml
Resource        services/backend/session-service.resource


*** Keywords ***
GET Purchases Refunds Inquiry Id
    [Documentation]    Get refund inquiry with    *NOTE: for calling microservice side `${user_id}` must be filled.
    [Arguments]
    ...    ${api_call_side}
    ...    ${inquiry_id}
    ...    ${user_id}=${EMPTY}

    ${api_path}    Set Variable    ${MS_PURCHASE_PATH}/purchases/refunds/${inquiry_id}

    ${header}    Create Dictionary    User-Id=${user_id}
    
    IF    '${api_call_side}' != '${MICROSERVICE_SIDE}'
        ${api_path}    Set Variable    refunds/${inquiry_id}?type=0
    END

    ${session}    Create A Session    ${api_call_side}

    ${response}    GET On Session    ${session}    ${api_path}    headers=${header}    expected_status=any

    ${result}    Create Dictionary    status_code=${response.status_code}    body=${response.json()}
    RETURN    ${result}

    [Teardown]    Delete A Session    ${session}
