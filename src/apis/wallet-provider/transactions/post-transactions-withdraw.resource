*** Settings ***
Library         Collections
Library         string
Library         JSONLibrary
Library         RequestsLibrary
Variables       data/CONSTANTS.yaml
Resource        services/backend/session-service.resource

# TODO: CHANGE THE DOCUMENTATION

*** Keywords ***
POST Transactions Withdraw
    [Documentation]    withdraw api.
    [Arguments]
    ...    ${api_call_side}
    ...    ${tracking_code}
    ...    ${user_id}
    ...    ${wallet_name}
    ...    ${amount}
    ...    ${fee}
    ...    ${feePayerBusinessId}
    ...    ${feePayerWalletName}
    ...    ${currency}
    ...    ${description}

    ${api_path}    Set Variable    /transactions/withdraw
    IF    '${api_call_side}' == '${MICROSERVICE_SIDE}'
        ${api_path}    Set Variable    ${MS_WALLET_PROVIDER_PATH}${api_path}
    END

    ${session}    Create A Session    ${api_call_side}    
    ${body}    Create Dictionary    trackingCode=${tracking_code}    userId=${user_id}    walletName=${wallet_name}    amount=${amount}    fee=${fee}    feePayerBusinessId=${feePayerBusinessId}    feePayerWalletName=${feePayerWalletName}    currency=${currency}    description=${description}
    ${response}    POST On Session    ${session}
    ...    ${api_path}
    ...    json=${body}
    ...    expected_status=any
    ${result}    Create Dictionary    status_code=${response.status_code}    body=${response.json()}

    RETURN    ${result}

    [Teardown]    Delete A Session    ${session}
