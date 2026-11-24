*** Settings ***
Library         Collections
Library         string
Library         JSONLibrary
Library         RequestsLibrary
Variables       data/CONSTANTS.yaml
Resource        services/backend/session-service.resource


*** Keywords ***
POST Wallets Payout Wallet
    [Documentation]    Payout legacy api, transaction agenda field should be filled based on
    ...    business wallet name: SETTLEMENT(0), REWARD_UNLOCKED(10), REWARD(11), REFUND(12),
    ...    REFUND_CUSTOM(13), REFUND_MANUAL(14), CASHBACK(15), DIRECT_DEBIT(16)
    [Arguments]
    ...    ${api_call_side}
    ...    ${amount}
    ...    ${source_business_id}
    ...    ${transaction_agenda}
    ...    ${destination_user_id}
    ...    ${cashoutable_amount}=${EMPTY}
    ...    ${sale_tracking_code}=${EMPTY}
    ...    ${description}=${EMPTY}

    ${api_path}    Set Variable    /wallets/payout/wallet
    IF    '${api_call_side}' == '${MICROSERVICE_SIDE}'
        ${api_path}    Set Variable    ${MS_WALLET_PROVIDER_PATH}${api_path}
    END

    ${tracking_code}    Generate Random String    25
    ${body}    Create Dictionary
    ...    trackingCode=${tracking_code}
    ...    amount=${amount}
    ...    businessId=${source_business_id}
    ...    userId=${destination_user_id}
    ...    transactionAgenda=${transaction_agenda}

    IF    '${cashoutable_amount}' != '${EMPTY}'
        Set To Dictionary    ${body}    cashoutableAmount=${cashoutable_amount}
    END
    IF    '${sale_tracking_code}' != '${EMPTY}'
        Set To Dictionary    ${body}    saleTrackingCode=${sale_tracking_code}
    END
    IF    '${description}' != '${EMPTY}'
        Set To Dictionary    ${body}    description=${description}
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
