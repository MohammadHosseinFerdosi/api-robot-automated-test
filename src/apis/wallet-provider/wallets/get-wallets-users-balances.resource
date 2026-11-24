*** Settings ***
Library         Collections
Library         string
Library         JSONLibrary
Library         RequestsLibrary
Variables       data/CONSTANTS.yaml
Resource        services/backend/session-service.resource


*** Keywords ***
GET Wallets Users Balances
    [Documentation]    Get ALL wallet balances for A user,
    ...    result contain a list of wallet with cash-out and noncash-outable balance.
    [Arguments]
    ...    ${api_call_side}
    ...    ${user_id}=${EMPTY}

    ${api_path}    Set Variable    /wallets/users/balances
    ${header}    Create Dictionary
    IF    '${api_call_side}' == '${MICROSERVICE_SIDE}'
        ${api_path}    Set Variable    ${MS_WALLET_PROVIDER_PATH}${api_path}
        Set To Dictionary    ${header}    User-Id=${user_id}
    END

    ${session}    Create A Session    ${api_call_side}
    ${response}    GET On Session
    ...    ${session}
    ...    ${api_path}
    ...    headers=${header}
    ...    expected_status=any

    ${result}    Create Dictionary    status_code=${response.status_code}    body=${response.json()}
    RETURN    ${result}
    [Teardown]    Delete A Session    ${session}
