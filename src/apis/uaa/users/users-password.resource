*** Settings ***
Library         String
Library         Collections
Library         JSONLibrary
Library         RequestsLibrary
Variables       data/CONSTANTS.yaml
Resource        services/backend/session-service.resource


*** Keywords ***
POST Users Password
    [Documentation]    Set given `${password}` for user, if api call form gateway side, `${access_token}`
    ...    required or if api call from microservice, `${user_id} required.
    [Arguments]    ${api_call_side}    ${user_id}    ${password}
    # Only microservice call side implemented.
    ${api_path}    Set Variable    ${MS_UAA_PATH}/users/password
    ${header}    Create Dictionary    User-Id=${user_id}
    ${body}    Create Dictionary    password=${password}

    ${session}    Create A Session    ${MICROSERVICE_SIDE}
    ${response}    POST On Session
    ...    ${session}
    ...    ${api_path}
    ...    headers=${header}
    ...    json=${body}
    ...    expected_status=any
    ${result}    Create Dictionary
    ...    status_code=${response.status_code}
    ...    body=${response.json()}
    RETURN    ${result}
    [Teardown]    Delete A Session    ${session}
