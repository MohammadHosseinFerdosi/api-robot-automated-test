*** Settings ***
Library         Collections
Library         string
Library         JSONLibrary
Library         RequestsLibrary
Variables       data/CONSTANTS.yaml
Resource        services/backend/session-service.resource


*** Keywords ***
POST Transactions Payout
    [Documentation]    Transfer from a business wallet to user wallet for example like 
    ...    Giving gifts to employees by the company

    [Arguments]
    ...    ${api_call_side}
    ...    ${amount}
    ...    ${source_business_id}
    ...    ${source_business_wallet_name}
    ...    ${destination_user_id}
    ...    ${destination_user_wallet_name}=${EMPTY}
    ...    ${cashoutable_amount}=${EMPTY}
    ...    ${sale_tracking_code}=${EMPTY}
    ...    ${description}=${EMPTY}

    ${api_path}    Set Variable    /transactions/payout
    IF    '${api_call_side}' == '${MICROSERVICE_SIDE}'
        ${api_path}    Set Variable    ${MS_WALLET_PROVIDER_PATH}${api_path}
    END

    ${tracking_code}    Generate Random String    25
    ${body}    Create Dictionary
    ...    amount=${amount}
    ...    trackingCode=${tracking_code}
    ...    sourceBusinessId=${source_business_id}
    ...    sourceWalletName=${source_business_wallet_name}
    ...    destinationUserId=${destination_user_id}
    ...    currency=IRR

    IF    '${cashoutable_amount}' != '${EMPTY}'
        Set To Dictionary    ${body}    cashoutableAmount=${cashoutable_amount}
    END
    IF    '${sale_tracking_code}' != '${EMPTY}'
        Set To Dictionary    ${body}    saleTrackingCode=${sale_tracking_code}
    END
    IF    '${destination_user_wallet_name}' != '${EMPTY}'
        Set To Dictionary    ${body}    destinationWalletName=${destination_user_wallet_name}
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
