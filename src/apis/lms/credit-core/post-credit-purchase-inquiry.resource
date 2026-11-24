*** Settings ***
Library         String
Library         Collections
Library         RequestsLibrary
Variables       data/CONSTANTS.yaml
Resource        services/backend/session-service.resource


*** Keywords ***
Post Credit Purchase Inquiry
    [Documentation]    Inquiry the purchase status
    [Arguments]
    ...    ${api_call_side}
    ...    ${user_id}
    ...    ${provider_id}
    ...    ${tracking_code}

    ${api_path}    Set Variable    /purchases/inquiry
    ${headers}    Create Dictionary
    IF    '${api_call_side}' == '${MICROSERVICE_SIDE}'
        ${api_path}    Set Variable    ${MS_CREDIT_MNG_PATH}${api_path}
        Set To Dictionary    ${headers}    User-Id=${user_id}
    END

    ${body}    Create Dictionary
    ...    providerId=${providerId}
    ...    trackingCode=${tracking_CODE}

    ${session}    Create A Session    ${api_call_side}

    ${response}    POST On Session
    ...    ${session}
    ...    ${api_path}
    ...    headers=${headers}
    ...    json=${body}
    ...    expected_status=any

    ${result}    Create Dictionary    status_code=${response.status_code}    body=${response.json()}
    RETURN    ${result}

    [Teardown]    Delete A Session    ${session}
