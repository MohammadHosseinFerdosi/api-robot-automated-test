*** Settings ***
Library         String
Library         Collections
Library         JSONLibrary
Library         RequestsLibrary
Variables       data/CONSTANTS.yaml
Resource        services/backend/session-service.resource
Resource        services/backend/auth-service.resource



*** Keywords ***
POST Businesses User Ticket
    [Documentation]    This API Gets    `${user_cellNumber}` for user, if api call form gateway side, `${access_token}`
    ...    required or if api call from microservice, `${user_id} required.
    [Arguments]
    ...    ${api_call_side}
    ...    ${user_cellNumber}
    ...    ${redirect_url}
    ...    ${user_id}=${EMPTY}
    ${activation_gateway_url}    Set Variable    /businesses/ticket?type=6
    ${activation_microservice_url}    Set Variable    ${MS_UAA_PATH}/businesses/user/ticket
    ${api_path}    Set Variable    ${activation_microservice_url}

    IF    '${api_call_side}' != '${MICROSERVICE_SIDE}'
        ${api_path}    Set Variable    ${activation_gateway_url}
    END

    ${header}    Create Dictionary    User-Id=${user_id}
    ${body}    Create Dictionary    cellNumber=${user_cellNumber}    redirectUrl=${redirect_url}

    ${session}    Create A Session    ${api_call_side}
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
