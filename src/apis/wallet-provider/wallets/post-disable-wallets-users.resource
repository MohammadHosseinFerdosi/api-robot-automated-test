*** Settings ***
Library         Collections
Library         string
Library         JSONLibrary
Library         RequestsLibrary
Variables       data/CONSTANTS.yaml
Resource        services/backend/session-service.resource


*** Keywords ***
Post Disable User Wallet
    [Documentation]    Disable User Wallet by its type to not to able to make transactions on this wallet like transfer... 
    ...    result response of fail or success disable wallet.
    [Arguments]
    ...    ${api_call_side}
    ...    ${user_id}
    ...    ${wallet_name}

    ${api_path}    Set Variable    /wallets/users/disable
    # ${header}    Create Dictionary
    IF    '${api_call_side}' == '${MICROSERVICE_SIDE}'
        ${api_path}    Set Variable    ${MS_WALLET_PROVIDER_PATH}${api_path}
    END

    ${session}    Create A Session    ${api_call_side}
    ${body}    Create Dictionary    userId=${user_id}    walletName=${wallet_name}
    ${response}    POST On Session    ${session}
    ...    ${api_path}
    ...    json=${body}
    ${result}    Create Dictionary    status_code=${response.status_code}    body=${response.json()}

    RETURN    ${result}

    [Teardown]    Delete A Session    ${session}
