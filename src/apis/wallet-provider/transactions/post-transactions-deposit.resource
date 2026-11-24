*** Settings ***
Library         Collections
Library         string
Library         JSONLibrary
Library         RequestsLibrary
Variables       data/CONSTANTS.yaml
Resource        services/backend/session-service.resource

*** Keywords ***
Post Deposit Wallet
    [Documentation]    Deposite from a wallet to platform wallet (this is part of hight level transactions like cash-out).
    [Arguments]
    ...    ${api_call_side}
    ...    ${tracking_code}
    ...    ${userId}
    ...    ${wallet_name}
    ...    ${amount}
    ...    ${currency}=IRR
    ...    ${description}=${EMPTY}


    ${api_path}    Set Variable    /transactions/deposit
    IF    '${api_call_side}' == '${MICROSERVICE_SIDE}'
        ${api_path}    Set Variable    ${MS_WALLET_PROVIDER_PATH}${api_path}
    END

    ${body}    Create Dictionary
    ...    trackingCode=${tracking_code}
    ...    userId=${userId}
    ...    walletName=${wallet_name}
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

