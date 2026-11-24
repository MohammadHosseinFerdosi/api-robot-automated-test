*** Settings ***
Library     RequestsLibrary
Resource    services/backend/session-service.resource


*** Keywords ***
GET Admin Wallets Businesses Id Balance
    [Documentation]    Transfer between `${source_wallet}` and `${destination_wallet}` for a
    ...    `${business_id}` by `${transfer_amount}` and return result as dictionary.
    ...    NOTE: For `MICROSERVICE` call side, `${user_id}` and `${agent}` must be set.
    [Arguments]
    ...    ${api_call_side}
    ...    ${business_id}
    ...    ${wallet_name}
    ...    ${user_id}=${EMPTY}
    ...    ${agent}=${EMPTY}

    ${api_path}    Set Variable    /admin/wallets/businesses/${business_id}/balance
    ${header}    Create Dictionary
    IF    '${api_call_side}' == '${MICROSERVICE_SIDE}'
        ${api_path}    Set Variable    ${MS_WALLET_PROVIDER_PATH}${api_path}
    END
    ${param}    Create Dictionary    walletName=${wallet_name}

    ${session}    Create A Session    ${api_call_side}
    ${response}    GET On Session
    ...    ${session}
    ...    ${api_path}
    ...    headers=${header}
    ...    params=${param}
    ...    expected_status=any
    ${result}    Create Dictionary    status_code=${response.status_code}    body=${response.json()}
    RETURN    ${result}
    [Teardown]    Delete A Session    ${session}
