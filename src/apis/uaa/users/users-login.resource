*** Settings ***
Library         String
Library         Collections
Library         JSONLibrary
Library         RequestsLibrary
Variables       data/CONSTANTS.yaml
Resource        services/backend/session-service.resource


*** Keywords ***
POST Users Login
    [Documentation]    Get token based on `${user_id}` and `${password}`.
    ...    and return dictionary contain `access_token` and `refresh_token`
    ...    with bearer type and `userId` and `expire_in` fileds. `NOTE:` Befor
    ...    call this api, password should set with /users/password api.
    [Arguments]
    ...    ${api_call_side}
    ...    ${user_id}
    ...    ${password}
    ...    ${device_info}=&{EMPTY}
    ...    ${basic_auth_param}=${EMPTY}
    # Microservice call side not implemented.
    ${api_path}    Set Variable    /users/login
    &{body}    Create Dictionary
    ...    username=${user_id}
    ...    password=${password}

    IF    ${device_info} != &{EMPTY}
        Set To Dictionary    ${body}    device=${device_info}
    END

    IF    '${basic_auth_param}' == '${EMPTY}'
        ${basic_auth_param}    Set Variable    ${APP_BASIC_AUTH}
    END

    ${session}    Create A Session    ${APP_SIDE}    ${basic_auth_param}
    ${response}    POST On Session
    ...    ${session}
    ...    ${api_path}
    ...    json=${body}
    ...    expected_status=any

    ${result}    Create Dictionary
    ...    status_code=${response.status_code}
    ...    body=${response.json()}
    RETURN    ${result}

    [Teardown]    Delete A Session    ${session}
