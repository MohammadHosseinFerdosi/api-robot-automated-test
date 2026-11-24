*** Settings ***
Library         Collections
Library         string
Library         JSONLibrary
Library         RequestsLibrary
Variables       data/CONSTANTS.yaml
Resource        services/backend/session-service.resource


*** Keywords ***
POST Wallets Definitions Users
    [Documentation]    Create user wallet definitions, if ${expiration_date} to be set,
    ...    a timebound wallet created. NOTE: ${expiration_date} must be set to future
    ...    time and in UNIX time mili second formant. NOTE: `${definition_name}` 
    ...    should not have under_line character in name and max 14 characters.
    [Arguments]
    ...    ${api_call_side}
    ...    ${definition_name}
    ...    ${description}

    ${api_path}    Set Variable    /wallets/definitions/users
    ${body}    Create Dictionary    walletName=${definition_name}    description=${description}    currency=IRR

    IF    '${api_call_side}' == '${MICROSERVICE_SIDE}'
        ${api_path}    Set Variable    ${MS_WALLET_PROVIDER_PATH}${api_path}
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
