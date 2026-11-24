*** Settings ***
Library         Collections
Library         string
Library         JSONLibrary
Library         RequestsLibrary
Variables       data/CONSTANTS.yaml
Resource        services/backend/session-service.resource


*** Keywords ***
POST Transactions Spend Verify
    [Documentation]    Verify spend based on `${tracking_code}` and `${confirmation_code}`. 
    ...    NOTE: spend is multi transaction type 1-pay & 2-verify, berfor call this api, 
    ...    `POST Trnsactions Spend Pay` should be called and received tracking code and confirmation code.
    [Arguments]
    ...    ${api_call_side}
    ...    ${tracking_code}
    ...    ${confirmation_code}

    ${api_path}    Set Variable    /transactions/spend/verify
    IF    '${api_call_side}' == '${MICROSERVICE_SIDE}'
        ${api_path}    Set Variable    ${MS_WALLET_PROVIDER_PATH}${api_path}
    END

    ${body}    Create Dictionary
    ...    trackingCode=${tracking_code}
    ...    confirmationCode=${confirmation_code}

    ${session}    Create A Session    ${api_call_side}
    ${response}    POST On Session
    ...    ${session}
    ...    ${api_path}
    ...    json=${body}
    ...    expected_status=any

    ${result}    Create Dictionary    status_code=${response.status_code}    body=${response.json()}
    RETURN    ${result}

    [Teardown]    Delete A Session    ${session}
