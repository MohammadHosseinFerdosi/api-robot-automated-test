*** Settings ***
Library         Collections
Library         string
Library         JSONLibrary
Library         RequestsLibrary
Variables       data/CONSTANTS.yaml
Resource        services/backend/session-service.resource


*** Keywords ***
POST Transactions Spend Pay
    [Documentation]    Spend From User Wallets to one or multi business, for split multi businesses
    ...    `${destinations_list}` should be contain list of buseienss id, business wallet name and amount
    ...    for example: `[{"businessId": "aaa", "walletName": "settlement","amount": 20000}]`.

    [Arguments]
    ...    ${api_call_side}
    ...    ${source_user_id}
    ...    ${destinations_list}
    ...    ${currency}
    ...    ${description}=${EMPTY}

    ${api_path}    Set Variable    /transactions/spend/pay
    IF    '${api_call_side}' == '${MICROSERVICE_SIDE}'
        ${api_path}    Set Variable    ${MS_WALLET_PROVIDER_PATH}${api_path}
    END

    ${tracking_code}    Generate Random String    30    [LOWER]
    ${body}    Create Dictionary
    ...    sourceUserId=${source_user_id}
    ...    destinations=${destinations_list}
    ...    trackingCode=${tracking_code}
    ...    currency=${currency}


    IF    '${description}' == '${EMPTY}'
        Set To Dictionary
        ...    ${body}
        ...    description=Spend for api automation test.
    ELSE
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
