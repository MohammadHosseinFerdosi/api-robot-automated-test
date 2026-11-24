*** Settings ***
Library     String
Library     collections
Library     RequestsLibrary
Resource    services/backend/session-service.resource


*** Keywords ***
POST Credit Purchase Reverse
    [Documentation]    This API is used to reverse a purchase that was previously initiated,
    ...    but not yet verified or completed, in cases where the transaction needs to be cancelled. The reversal process uses the provided
    ...    Purchase Tracking Code ${tracking_code} and ${provider_id} to identify and process the transaction.
    [Arguments]
    ...    ${api_call_side}
    ...    ${tracking_code}
    ...    ${user_id}
    ...    ${provider_id}

    ${api_path}=    Set Variable    /reverses
    IF    '${api_call_side}' == '${MICROSERVICE_SIDE}'
        ${api_path}=    Set Variable    ${MS_CREDIT_MNG_PATH}${api_path}
        ${headers}=    Create Dictionary    User-Id=${user_id}
    END

    ${body}=    Create Dictionary
    ...    purchaseTrackingCode=${tracking_code}
    ...    providerId=${provider_id}

    ${session}=    Create A Session    ${api_call_side}

    ${response}=    POST On Session
    ...    ${session}
    ...    ${api_path}
    ...    json=${body}
    ...    headers=${headers}
    ...    expected_status=any
    ${result}=    Create Dictionary    status_code=${response.status_code}    body=${response.json()}

    RETURN    ${result}

    [Teardown]    Delete A Session    ${session}
