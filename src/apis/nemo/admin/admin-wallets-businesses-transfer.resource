*** Settings ***
Library     RequestsLibrary
Resource    services/backend/session-service.resource


*** Keywords ***
POST Admin Wallets Businesses Transfer
    [Documentation]    Transfer between `${source_wallet}` and `${destination_wallet}` for a
    ...    `${business_id}` by `${transfer_amount}` and return result as dictionary.
    ...    NOTE: For `MICROSERVICE` call side, `${user_id}` and `${agent}` must be set.
    [Arguments]
    ...    ${api_call_side}
    ...    ${business_id}
    ...    ${source_wallet}
    ...    ${destination_wallet}
    ...    ${transfer_amount}
    ...    ${user_id}=${EMPTY}
    ...    ${agent}=${EMPTY}

    ${api_path}    Set Variable    /admin/wallets/businesses/transfer
    ${header}    Create Dictionary
    IF    '${api_call_side}' == '${MICROSERVICE_SIDE}'
        Should Not Be Empty    ${user_id}
        Should Not Be Empty    ${agent}
        Set To Dictionary    ${header}    User-Id=${user_id}    Agent=${agent}
        ${api_path}    Set Variable    ${MS_NEMO_PATH}${api_path}
    END

    ${body}    Create Dictionary
    ...    businessId=${business_id}
    ...    sourceWalletName=${source_wallet}
    ...    destinationWalletName=${destination_wallet}
    ...    amount=${transfer_amount}

    ${session}    Create A Session    ${api_call_side}
    ${response}    POST On Session
    ...    ${session}
    ...    ${api_path}
    ...    headers=${header}
    ...    json=${body}
    ...    expected_status=any
    ${result}    Create Dictionary    status_code=${response.status_code}    body=${response.json()}
    RETURN    ${result}
    [Teardown]    Delete A Session    ${session}
