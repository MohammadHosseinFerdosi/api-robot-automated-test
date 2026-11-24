*** Settings ***
Library         Collections
Library         string
Library         JSONLibrary
Library         RequestsLibrary
Variables       data/CONSTANTS.yaml
Resource        services/backend/session-service.resource


*** Keywords ***
POST Transactions Collect
    [Documentation]    Collect ALL AMOUNT TYPES of a user wallet and send them to a business wallet.
    ...    NOTE: source_user_wallet should be expired.
    [Arguments]
    ...    ${api_call_side}
    ...    ${source_user_id}
    ...    ${source_user_wallet_name}
    ...    ${destination_business_id}
    ...    ${destination_business_wallet_name}

    ${api_path}    Set Variable    /transactions/collect
    IF    '${api_call_side}' == '${MICROSERVICE_SIDE}'
        ${api_path}    Set Variable    ${MS_WALLET_PROVIDER_PATH}${api_path}
    END

    ${tracking_code}    Generate Random String    25
    ${body}    Create Dictionary
    ...    sourceUserId=${source_user_id}
    ...    sourceWalletName=${source_user_wallet_name}
    ...    destinationBusinessId=${destination_business_id}
    ...    destinationWalletName=${destination_business_wallet_name}
    ...    trackingCode=${tracking_code}
    ...    currency=IRR

    ${session}    Create A Session    ${api_call_side}
    ${response}    POST On Session
    ...    ${session}
    ...    ${api_path}
    ...    json=${body}
    ...    expected_status=any

    ${result}    Create Dictionary    status_code=${response.status_code}    body=${response.json()}
    RETURN    ${result}

    [Teardown]    Delete A Session    ${session}
