*** Settings ***
Library         Collections
Library         string
Library         JSONLibrary
Library         RequestsLibrary
Variables       data/CONSTANTS.yaml
Resource        services/backend/session-service.resource

*** Keywords ***
POST Transactions user-Transfer
    [Documentation]    transfer amount between two user wallet.
    [Arguments]
    ...    ${api_call_side}
    ...    ${tracking_code}
    ...    ${source_user_id}
    ...    ${source_wallet_name}
    ...    ${destination_user_id}
    ...    ${destination_wallet_name}
    ...    ${amount}
    ...    ${cashoutable_amount}
    ...    ${currency}=IRR
    ...    ${description}=${EMPTY}


    ${api_path}    Set Variable    /transactions/transfer
    IF    '${api_call_side}' == '${MICROSERVICE_SIDE}'
        ${api_path}    Set Variable    ${MS_WALLET_PROVIDER_PATH}${api_path}
    END

    ${body}    Create Dictionary
    ...    trackingCode=${tracking_code}
    ...    sourceUserId=${source_user_id}
    ...    sourceWalletName=${source_wallet_name}
    ...    destinationUserId=${destination_user_id}
    ...    destinationWalletName=${destination_wallet_name}
    ...    amount=${amount}
    ...    cashoutableAmount=${cashoutable_amount}
    ...    currency=${currency}

    ${session}    Create A Session    ${api_call_side}
    ${response}    POST On Session
    ...    ${session}
    ...    ${api_path}
    ...    json=${body}
    ...    expected_status=any

    ${result}    Create Dictionary    status_code=${response.status_code}    body=${response.json()}
    RETURN    ${result}

    [Teardown]    Delete A Session    ${session}
