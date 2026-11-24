*** Settings ***
Library         Collections
Library         string
Library         JSONLibrary
Library         RequestsLibrary
Variables       data/CONSTANTS.yaml
Resource        services/backend/session-service.resource


*** Keywords ***
POST Transactions Business-Transfer
    [Documentation]    transfer amount between two wallets of a business of multi business.
    [Arguments]
    ...    ${api_call_side}
    ...    ${tracking_code}
    ...    ${source_business_id}
    ...    ${source_wallet_name}
    ...    ${destination_business_id}
    ...    ${destination_wallet_name}
    ...    ${amount}
    ...    ${currency}=IRR
    ...    ${description}=${EMPTY}


    ${api_path}    Set Variable    /transactions/business-transfer
    IF    '${api_call_side}' == '${MICROSERVICE_SIDE}'
        ${api_path}    Set Variable    ${MS_WALLET_PROVIDER_PATH}${api_path}
    END

    ${body}    Create Dictionary
    ...    trackingCode=${tracking_code}
    ...    sourceBusinessId=${source_business_id}
    ...    sourceWalletName=${source_wallet_name}
    ...    destinationBusinessId=${destination_business_id}
    ...    destinationWalletName=${destination_wallet_name}
    ...    amount=${amount}
    ...    currency=${currency}
    ...    description=${description}
    
    ${session}    Create A Session    ${api_call_side}
    ${response}    POST On Session
    ...    ${session}
    ...    ${api_path}
    ...    json=${body}
    ...    expected_status=any

    ${result}    Create Dictionary    status_code=${response.status_code}    body=${response.json()}
    RETURN    ${result}

    [Teardown]    Delete A Session    ${session}
