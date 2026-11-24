*** Settings ***
Library         String
Library         Collections
Library         RequestsLibrary
Variables       data/CONSTANTS.yaml
Resource        services/backend/session-service.resource


*** Keywords ***
POST Credit Early Settlements Pay Wallet
    [Documentation]    Pays the Early Settlement via wallet
    [Arguments]
    ...    ${api_call_side}
    ...    ${ticket}
    ...    ${type}

    ${api_path}    Set Variable    /early-settlements/pay/wallet
    ${headers}    Create Dictionary
    IF    '${api_call_side}' == '${MICROSERVICE_SIDE}'
        ${api_path}    Set Variable    ${MS_CREDIT_MNG_PATH}${api_path}
    ELSE IF    '${api_call_side}' == '${GENERAL_SIDE}'
        ${api_path}    Set Variable    ${GATEWAY_PATH}/credit${api_path}
    END

    ${body}    Create Dictionary
    ...    ticket=${ticket}
    ...    type=${type}
    
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
