*** Settings ***
Library         Collections
Library         string
Library         JSONLibrary
Library         RequestsLibrary
Variables       data/CONSTANTS.yaml
Resource        services/backend/session-service.resource


*** Keywords ***
GET Transactions Payout
    [Arguments]
    ...    ${api_call_side}
    ...    ${tracking_code}

    ${api_path}    Set Variable    /transactions/payout/${tracking_code}
    IF    '${api_call_side}' == '${MICROSERVICE_SIDE}'
        ${api_path}    Set Variable    ${MS_WALLET_PROVIDER_PATH}${api_path}
    END

    ${session}    Create A Session    ${api_call_side}
    ${response}    Get On Session
    ...    ${session}
    ...    ${api_path}
    ...    expected_status=any

    ${result}    Create Dictionary    status_code=${response.status_code}    body=${response.json()}
    RETURN    ${result}

    [Teardown]    Delete A Session    ${session}
