*** Settings ***
Library         String
Library         Collections
Library         JSONLibrary
Library         RequestsLibrary
Variables       data/CONSTANTS.yaml
Resource        services/backend/session-service.resource


*** Keywords ***
POST Users Activate
    [Documentation]    Activate user and if user `hasPassword` response not contain access token and
    ...    should be received by login apis. otherwise access token should be find in response.
    [Arguments]    ${api_call_side}    ${user_id}    ${sms_token}    ${basic_auth_param}=${EMPTY}
    # Microservice call side not implemented yet.
    ${api_path}    Set Variable    /users/activate
    ${body}    Create Dictionary    smsToken=${sms_token}    userId=${user_id}

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
