*** Settings ***
Library         String
Library         Collections
Library         JSONLibrary
Library         RequestsLibrary
Variables       data/CONSTANTS.yaml
Resource        services/backend/session-service.resource


*** Keywords ***
POST Users Send SMS
    [Documentation]    Create OTP token based on `${cell_number}`. This api return `status code` and
    ...    `result` section with `userId` field in response and otp token should get with redis api.
    [Arguments]    ${api_call_side}    ${cell_number}    ${device_info}=&{EMPTY}    ${basic_auth_param}=${EMPTY}

    IF    '${api_call_side}' == '${MICROSERVICE_SIDE}'
        ${api_path}    Set Variable    ${MS_UAA_PATH}/users/otp/sms
    ELSE
        ${api_path}    Set Variable    /users/send-sms
    END

    &{body}    Create Dictionary    cellNumber=${cell_number}

    IF    ${device_info} != &{EMPTY}
        Set To Dictionary    ${body}    device=${device_info}
    END

    IF    '${basic_auth_param}' == '${EMPTY}'
        ${basic_auth_param}    Set Variable    ${APP_BASIC_AUTH}
    END

    ${session}    Create A Session    ${api_call_side}    ${basic_auth_param}
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

URL Builder
    [Arguments]    ${api_call_side}
    IF    '${api_call_side}' == '${MICROSERVICE_SIDE}'
        ${api_path}    Set Variable    ${MS_UAA_PATH}/users/otp/sms
    ELSE
        ${api_path}    Set Variable    /users/send-sms
    END
    RETURN    ${api_path}

Body Builder
    [Arguments]    ${cell_number}    ${device_info}=${EMPTY}
    IF    '${device_info}'!='${EMPTY}'
        &{device}    Create Dictionary    &{device_info}
        &{body}    Create Dictionary    cellNumber=${cell_number}    device=${device}
        RETURN    ${body}
    ELSE
        &{body}    Create Dictionary    cellNumber=${cell_number}
        RETURN    ${body}
    END
