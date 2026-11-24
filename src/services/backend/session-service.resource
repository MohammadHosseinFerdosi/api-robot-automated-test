*** Settings ***
Library         String
Library         Collections
Library         JSONLibrary
Library         RequestsLibrary
Variables       data/CONSTANTS.yaml
Variables       config/session-config.py


*** Keywords ***
Create A Session
    [Documentation]    Create and return a session `${session_name}` with default configuration, base url, authorization
    ...    based on your environmets as `${api_call_side}` argument. by default `${api_call_side}`
    ...    should be set with microservice name based on constant file. if app, dashborad or other
    ...    gateway path needed, set based on constant vairables. for gateway side address `auth service`
    ...    should be call first and session service use auth parameters that saved as suite variables.
    [Arguments]    ${api_call_side}    ${auth_parameter}=${EMPTY}

    ${random_string}    Generate Random String    15
    ${session_name}    Set Variable    ${SUITE NAME}_${random_string}

    Session Header Builder    ${api_call_side}    ${auth_parameter}
    ${url}    Path Builder    ${api_call_side}

    Init    ${session_name}    ${url}
    RETURN    ${session_name}

Init
    [Arguments]    ${session_name}    ${url}

    Create Session
    ...    alias=${session_name}
    ...    url=${url}
    ...    verify=${SESSION_DEFAULT_VERIFY}
    ...    headers=${SESSION_DEFAULT_HEADER}
    ...    cookies=${SESSION_DEFAULT_COOKIES}
    ...    auth=${None}
    ...    timeout=${SESSION_DEFAULT_TIMEOUT}
    ...    proxies=${SESSION_DEFAULT_PROXIES}
    ...    debug=${SESSION_DEFAULT_DEBUG}
    ...    max_retries=${SESSION_DEFAULT_MAX_RETRIES}
    ...    backoff_factor=${SESSION_DEFAULT_BACKOFF_FACTOR}
    ...    disable_warnings=${SESSION_DEFAULT_DISABLE_WARNINGS}
    ...    retry_status_list=${SESSION_DEFAULT_RETRY_STATUS_LIST}
    ...    retry_method_list=${SESSION_DEFAULT_RETRY_METHOD_LIST}

Session Header Builder
    [Arguments]    ${api_call_side}    ${auth_parameter}=${EMPTY}
    # Fresh dict every call — never mutate leftover Agent/Bearer/Platform-Version from prior sides.
    &{headers}=    Create Dictionary

    IF    '${api_call_side}' != '${MICROSERVICE_SIDE}' and '${api_call_side}' != '${WALLET_TRANSFER_SIDE}'
        ${variables}=    Get Variables
        IF    '${auth_parameter}' == '${EMPTY}' and "\&{AUTHENTICATED_USER_PARAMETERS}" in $variables
            Set To Dictionary
            ...    ${headers}
            ...    Authorization=Bearer ${AUTHENTICATED_USER_PARAMETERS['access_token']}
        END
    END
    IF    '${auth_parameter}' != '${EMPTY}'
        Set To Dictionary    ${headers}    Authorization=${auth_parameter}
    END

    IF    '${api_call_side}' == '${NEMO_APP_SIDE}'
        ${variables}=    Get Variables
        IF    "\${PLATFORM_AGENT}" in $variables
            Set To Dictionary    ${headers}    Agent=${PLATFORM_AGENT}
        END
        IF    "\${PLATFORM_VERSION}" in $variables
            Set To Dictionary    ${headers}    Platform-Version=${PLATFORM_VERSION}
        END
        IF    "\${PLATFORM_CLIENT_VERSION}" in $variables
            Set To Dictionary    ${headers}    Client-Version=${PLATFORM_CLIENT_VERSION}
        END
    END

    Set Global Variable    ${SESSION_DEFAULT_HEADER}    ${headers}

Path Builder
    [Arguments]    ${api_call_side}

    IF    '${api_call_side}' == '${APP_SIDE}'
        ${url}    Set Variable    ${APP_BASE_URL}${GATEWAY_PATH}
    ELSE IF    '${api_call_side}' == '${GENERAL_SIDE}'
        ${url}    Set Variable    ${GENERAL_BASE_URL}${GATEWAY_PATH}
    ELSE IF    '${api_call_side}' == '${DASHBOARD_SIDE}'
        ${url}    Set Variable    ${DASHBOARD_BASE_URL}${GATEWAY_PATH}
    ELSE IF    '${api_call_side}' == '${DB_SIDE}'
        ${url}    Set Variable    ${DB_BASE_URL}
    ELSE IF    '${api_call_side}' == '${MICROSERVICE_SIDE}'
        ${url}    Set Variable    ${MICROSERVICE_BASE_URL}
    ELSE IF    '${api_call_side}' == '${WALLET_TRANSFER_SIDE}'
        ${url}    Set Variable    ${MICROSERVICE_BASE_URL}${MS_WALLET_TRANSFER_PATH}
    ELSE IF    '${api_call_side}' == '${NEMO_APP_SIDE}'
        ${url}    Set Variable    ${GENERAL_BASE_URL}${GATEWAY_PATH}
    ELSE IF    '${api_call_side}' == '${WEB_SIDE}'
        ${url}    Set Variable    ${WEB_BASE_URL}${GATEWAY_PATH}
    ELSE IF    '${api_call_side}' == '${MOCKIT_ROUTES_SIDE}'
        ${url}    Set Variable    ${MOCKIT_ROUTES_URL}
    ELSE IF    '${api_call_side}' == '${MOCKIT_SIDE}'
        ${url}    Set Variable    ${MOCKIT_URL}
    ELSE
        Fail    msg=`api_call_side`: ${api_call_side} for session creation not validate.
    END
    RETURN    ${url}

Delete A Session
    [Documentation]    Close session based on `${session_name}`.
    [Arguments]    ${session_name}
    Delete All Sessions
