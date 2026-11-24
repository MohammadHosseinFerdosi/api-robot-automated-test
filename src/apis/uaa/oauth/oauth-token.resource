*** Settings ***
Library         String
Library         Collections
Library         JSONLibrary
Library         RequestsLibrary
Variables       data/CONSTANTS.yaml
Variables       config/session-config.py
Resource        services/backend/session-service.resource


*** Keywords ***
POST Oauth Token
    [Documentation]    Get token based on `${username}` and `${password}`.
    ...    and return dictionary contain `access_token` and `refresh_token`
    ...    with bearer type and `scope`, `zid` and `expire_in` fileds.
    ...    `${client_id}` and `${device_id}` could be random string.
    [Arguments]
    ...    ${api_call_side}
    ...    ${username}
    ...    ${password}
    ...    ${device_id}
    ...    ${basic_auth_param}
    ...    ${client_id}=${EMPTY}
    ...    ${zone}=${EMPTY}

    ${api_path}    Set Variable    oauth/token
    IF    '${api_call_side}' == '${DASHBOARD_SIDE}' 
        ${api_path}    Set Variable    admin/oauth/token
    ELSE IF    '${api_call_side}' == '${MICROSERVICE_SIDE}'
        ${api_path}    Set Variable    ${MS_UAA_PATH}${api_path}
    END

    ${header}    Create Dictionary
    IF    '${zone}' != '${EMPTY}'
        Set To Dictionary    ${header}    Zone=${zone}
    END

    ${body}    Create Dictionary
    ...    username=${username}
    ...    password=${password}
    ...    device_id=${device_id}
    ...    grant_type=password
    IF    '${client_id}' != '${EMPTY}'
        Set To Dictionary    ${body}    client_id=${client_id}
    END

    ${session}    Create A Session    ${api_call_side}    ${basic_auth_param}
    ${response}    POST On Session
    ...    ${session}
    ...    ${api_path}
    ...    headers=${header}
    ...    data=${body}
    ...    expected_status=any

    IF    ${response.status_code} == 200
        ${result}    Create Dictionary
        ...    status_code=${response.status_code}
        ...    body=${response.json()}
        RETURN    ${result}
    ELSE
        ${result}    Create Dictionary
        ...    status_code=${response.status_code}
        ...    body=${response.json().get('result')}
        RETURN    ${result}
    END
    [Teardown]    Delete A Session    ${session}
