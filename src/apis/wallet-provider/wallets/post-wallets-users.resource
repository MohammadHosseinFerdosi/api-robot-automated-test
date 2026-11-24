*** Settings ***
Library         Collections
Library         string
Library         JSONLibrary
Library         RequestsLibrary
Variables       data/CONSTANTS.yaml
Resource        services/backend/session-service.resource


*** Keywords ***
POST Wallets Users
    [Documentation]    Create a wallet for user based on definition, `${wallet_name}` must be
    ...    created based on wallet definition (definition name as prefix of wallet name and spreates with _),
    ...    exp: if wallet definition = my-def then wallet name is: my-def_my-wallet-name.
    [Arguments]
    ...    ${api_call_side}
    ...    ${user_id}
    ...    ${wallet_name}
    ...    ${expiration_date}=${EMPTY}

    ${api_path}    Set Variable    /wallets/users
    ${body}    Create Dictionary    walletName=${wallet_name}    userId=${user_id}

    IF    '${api_call_side}' == '${MICROSERVICE_SIDE}'
        ${api_path}    Set Variable    ${MS_WALLET_PROVIDER_PATH}${api_path}
    END

    IF    '${expiration_date}' != '${EMPTY}'
        Set To Dictionary    ${body}    expirationDate=${expiration_date}
    END

    ${session}    Create A Session    ${api_call_side}
    ${response}    POST On Session
    ...    ${session}
    ...    ${api_path}
    ...    json=${body}
    ...    expected_status=any

    ${result}    Create Dictionary    status_code=${response.status_code}    body=${response.json()}
    RETURN    ${result}
    [Teardown]    Delete A Session    ${session}
