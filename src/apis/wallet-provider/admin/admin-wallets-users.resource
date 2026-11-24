*** Settings ***
Library         Collections
Library         string
Library         JSONLibrary
Library         RequestsLibrary
Variables       data/CONSTANTS.yaml
Resource        services/backend/session-service.resource


*** Keywords ***
GET Admin Wallets Users
    [Documentation]    This API gets user wallets balances seprated by currency
    [Arguments]
    ...    ${api_call_side}
    ...    ${user-id}
    ...    ${currency}

    ${api_path}    Set Variable    /admin/wallets/users/${user-id}/balances?currency=${currency}
    IF    '${api_call_side}' == '${MICROSERVICE_SIDE}'
        ${api_path}    Set Variable    ${MS_WALLET_PROVIDER_PATH}${api_path}
    END


    ${session}    Create A Session    ${api_call_side}
    ${response}    GET On Session
    ...    ${session}
    ...    ${api_path}
    ...    expected_status=any


    ${result}    Create Dictionary
    ...    response_status_code=${response.status_code}
    ...    response_body=${response.json()}
    RETURN    ${result}

    [Teardown]    Delete A Session    ${session}
