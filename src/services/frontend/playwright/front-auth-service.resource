*** Settings ***
Library     Browser
Resource    services/backend/auth-service.resource
Resource    apis/uaa/get-admin-users-permissions.resource
Resource    services/frontend/playwright/pin-service.resource
Resource    services/frontend/playwright/walkthrough.resource
Resource    services/frontend/playwright/Skip-Login-Popup.resource


*** Keywords ***
UI Login To App
    [Documentation]    Logs into the app using the specified method (${type}), with inputs: ${cell_number}, ${pin_code}, ${skip_walk_through};
    ...    delegates to API handler, APP handler or fails if unsupported.
    ...
    ...    If ${type} is ${LOGIN_TYPE_APP}, it will open a page from the ${APP_LOGIN_URL} : Intended for only E2E test scnerios.
    ...    Expects the ${APP_LOGIN_URL} as the current URL.
    [Arguments]
    ...    ${cell_number}
    ...    ${pin_code}=${EMPTY}
    ...    ${skip_walk_through}=${False}
    ...    ${Skip_Login_Popup}=${False}
    ...    ${type}=${LOGIN_TYPE_API}
    ...    ${otp_overwrite}=${EMPTY}

    IF    '${type}'=='${LOGIN_TYPE_API}'
        ${dp}    ${mid}    ${login_status}    API Login To App Handler
        ...    cell_number=${cell_number}
        ...    pin_code=${pin_code}
        ...    skip_walk_through=${skip_walk_through}
        ...    Skip_Login_Popup=${Skip_Login_Popup}
        ...    otp_overwrite=${otp_overwrite}
        RETURN    ${login_status}
    ELSE IF    '${type}'=='${LOGIN_TYPE_APP}'
        APP Login To App Handler
        ...    cell_number=${cell_number}
        ...    pin_code=${pin_code}
        ...    skip_walk_through=${skip_walk_through}
        ...    Skip_Login_Popup=${Skip_Login_Popup}
        ...    otp_overwrite=${otp_overwrite}
    ELSE
        Fail    msg=Unsupported type: ${type} for Login Handler.
    END

UI Login To Dashboard
    [Documentation]    Logs into the dashboard using the specified method (${type}), with inputs: ${user_name}, ${password};
    ...    delegates to API handler, APP handler or fails if unsupported.
    [Arguments]    ${username}    ${password}    ${type}=${LOGIN_TYPE_API}

    IF    '${type}'=='${LOGIN_TYPE_API}'
        ${auth}    ${login_status}    API Login To DASHBOARD Handler    username=${username}    password=${password}
        RETURN    ${login_status}
    ELSE IF    '${type}'=='${LOGIN_TYPE_APP}'
        APP Login To DASHBOARD Handler    username=${username}    password=${password}
    ELSE
        Fail    msg=Unsupported type: ${type} for Login Handler.
    END

API Login To App Handler
    [Documentation]    This handler provides the core utility to log in to the base app via an API call. The procedure is as follows:
    ...
    ...    1. Log in to the app and retrieve relevant information such as device_id, access_token, and refresh_token.
    ...
    ...    2. Clear the local storage.
    ...
    ...    3. Set the retrieved information in local storage.
    ...
    ...    4. Reload the page.
    ...
    ...    Returns: The storage configuration.
    [Tags]    robot:private
    [Arguments]
    ...    ${cell_number}
    ...    ${pin_code}
    ...    ${skip_walk_through}
    ...    ${Skip_Login_Popup}
    ...    ${otp_overwrite}

    ${login_status}    Run Keyword And Return Status
    ...    Login To App
    ...    ${cell_number}
    ...    ${pin_code}
    ...    otp_overwrite=${otp_overwrite}
    IF    '${login_status}'=='${False}'
        RETURN    ${EMPTY}    ${EMPTY}    ${login_status}
    END

    ${auth_params}    Create Dictionary
    ...    access    ${AUTHENTICATED_USER_PARAMETERS['access_token']}
    ...    refresh    ${AUTHENTICATED_USER_PARAMETERS['refresh_token']}
    ...    userId    ${AUTHENTICATED_USER_PARAMETERS['user_id']}
    ...    phoneNumber    ${cell_number}

    ${created_dp_storage}    Create Dictionary
    ...    auth    ${auth_params}

    ${auth_json}    Evaluate    __import__('json').dumps($created_dp_storage)
    ${device_id}    Set Variable    ${AUTHENTICATED_USER_PARAMETERS['device_id']}

    Local Storage Clear
    Local Storage Set Item    __dp_storage    ${auth_json}
    Local Storage Set Item    __dp_machine_id    ${device_id}

    IF    not ${skip_walk_through}    Skip Walkthrough - Local Storage

    Reload

    ${dp}    Local Storage Get Item    __dp_storage
    ${mid}    Local Storage Get Item    __dp_machine_id

    RETURN    ${dp}    ${mid}    ${login_status}

APP Login To App Handler
    [Documentation]    This handler provides the core utility to log in to the base app via an APP intended process. The procedure is as follows:
    ...
    ...    1. Enter the cell number.
    ...
    ...    2. Retrieve the OTP from Redis.
    ...
    ...    3. Enter the OTP.
    ...
    ...    4. Enter The Pin If Required.
    ...
    ...    5. Wait For The Hub Page To Load
    ...
    ...    Returns: The Current URL
    ...
    ...    > Note: This should be an End-To-End process. Meaning your fist step in your automation,
    ...    if you decided to use this method, should be this keyword. You need to login to the app from the start.
    ...    If you want to have the authentication benefits while loading a specific page, use the other method!
    [Tags]    robot:private
    [Arguments]
    ...    ${cell_number}
    ...    ${pin_code}
    ...    ${skip_walk_through}
    ...    ${Skip_Login_Popup}
    ...    ${otp_overwrite}

    ${current_url}    Get Url
    Should Be Equal As Strings
    ...    first=${current_url}
    ...    second=${APP_LOGIN_URL}
    ...    msg=Expected the current URL to be ${APP_LOGIN_URL}, but got ${current_url}.

    Wait For Elements State
    ...    css=ui-form-field[formcontrolname="phoneNumber"] input
    ...    visible
    ...    ${DEFAULT_ELEMENT_TIMEOUT}
    Type Text
    ...    css=ui-form-field[formcontrolname="phoneNumber"] input
    ...    ${cell_number}
    ...    delay=${DEFAULT_KEY_PRESS_DELAY}
    Click    css=.ngx-button-full-width >> button:has-text("قبول شرایط و ادامه")

    ${db_qury_result}    MySQL Fetch All
    ...    db_name=uaa_db
    ...    query=SELECT * FROM uaa_db.users WHERE cell_number="${cell_number}" AND zone_id="app"
    Should Be Equal As Integers
    ...    ${db_qury_result['status_code']}
    ...    0
    ...    msg=mysql result should be successful but found: ${db_qury_result['body']}

    ${user_id}    Set Variable    ${db_qury_result['body'][0]['user_id']}
    ${key}    Set Variable    auth_otp_${user_id}
    ${get_otp_result}    Redis Get Key    key=${key}    master_name=redis-new-master
    ${get_otp_value}    Set Variable    ${get_otp_result['body']['value']}
    ${get_otp_value}    Decode Bytes To String    bytes=${get_otp_value}    encoding=utf-8
    ${get_otp_status_code}    Set Variable    ${get_otp_result['status_code']}

    IF    '${otp_overwrite}'!='${EMPTY}'
        ${otp_overwrite}    Convert To List    ${otp_overwrite}
        ${user_opt}    Set Variable    ${otp_overwrite}
    ELSE IF    '${get_otp_status_code}'=='0' and '${get_otp_value}' !='${null}'
        ${get_otp_value}    Convert String To Json    json_string=${get_otp_value}
        ${otp_list}    Get Value From Json
        ...    ${get_otp_value}
        ...    $.otpCodes[*].[*].value
        ...    fail_on_empty=${True}
        ${user_opt}    Set Variable    ${otp_list[-1]}
    ELSE
        Fail    msg=Get OTP Failed with Status: ${get_otp_result.status_code} and message ${get_otp_result['body']}
    END

    Click    css=input.digit[id^="otp-"] >> nth=0
    Type Text    css=input.digit[id^="otp-"] >> nth=0    ${user_opt}    delay=${DEFAULT_KEY_PRESS_DELAY}
    IF    '${pin_code}'!='${EMPTY}'    Enter Pin - UI    pin_code=${pin_code}
    IF    ${skip_walk_through}    Skip Walkthrough - UI
    IF    ${Skip_Login_Popup}         Skip Login Popup - UI

API Login To DASHBOARD Handler
    [Documentation]    This handler provides the core utility to log in to the dashboard via an API call. The procedure is as follows:
    ...
    ...    1. Log in to the dashboard and retrieve relevant information such as device_id, access_token, and refresh_token.
    ...
    ...    2. Call The permission API and retrieve its results.
    ...
    ...    3. Clear the local storage.
    ...
    ...    4. Set the retrieved information in local storage.
    ...
    ...    5. Reload the page.
    ...
    ...    Returns: The storage configuration.
    [Tags]    robot:private
    [Arguments]    ${username}    ${password}

    ${login_status}    Run Keyword And Return Status    Login To Dashboard    ${username}    ${password}
    IF    '${login_status}'=='${False}'    RETURN    ${EMPTY}    ${login_status}

    ${oauth_params}    Create Dictionary
    ...    access_token    ${AUTHENTICATED_USER_PARAMETERS['access_token']}
    ...    refresh_token    ${AUTHENTICATED_USER_PARAMETERS['refresh_token']}

    ${permission_response}    GET Admin Users Permissions    api_call_side=${MICROSERVICE_SIDE}    username=${username}    zone=${EMPTY}
    Should Be Equal As Strings
    ...    first=${permission_response['status_code']}
    ...    second=200
    ...    msg=Generation of Permission Failed with status ${permission_response['status_code']} while calling the API.
    ${permission_list}    Set Variable    ${permission_response['body']['permissions']}

    ${status_params}    Create Dictionary
    ...    loggedIn=${true}
    ...    userId=${username}
    ...    permissions=${permission_list}
    ...    oAuth=${oauth_params}
    ${status}    Create Dictionary    status=${status_params}

    ${auth_json}    Evaluate    __import__('json').dumps($status)

    Local Storage Clear
    Local Storage Set Item    auth    ${auth_json}

    Reload

    ${auth}    Local Storage Get Item    auth

    RETURN    ${auth}    ${login_status}

APP Login To DASHBOARD Handler
    [Documentation]    This handler provides the core utility to log in to the dashboard via an APP intended process. The procedure is as follows:
    ...
    ...    1. Enter Username And Password
    ...
    ...    2. Click Confirm
    ...
    ...    3. Wait to be at dashboard home page
    ...
    ...    Returns: The current url.
    ...
    ...    > Note: This is intended for End-To-End tests and the current url for this handler must starts with ${DASHBOARD_LOGIN_URL}, otherwise it will fail
    [Tags]    robot:private
    [Arguments]    ${username}    ${password}

    ${current_url}    Get Url
    Should Start With
    ...    str1=${current_url}
    ...    str2=${DASHBOARD_LOGIN_URL}
    ...    msg=Expected the current URL to starts with ${DASHBOARD_LOGIN_URL}, but got ${current_url}

    Wait For Elements State    css=input[formcontrolname="userId"]    visible    ${DEFAULT_ELEMENT_TIMEOUT}
    Type Text    css=input[formcontrolname="userId"]    ${username}    ${DEFAULT_KEY_PRESS_DELAY}

    Wait For Elements State    css=input[formcontrolname="password"]    visible    ${DEFAULT_ELEMENT_TIMEOUT}
    Type Text    css=input[formcontrolname="password"]    ${password}    ${DEFAULT_KEY_PRESS_DELAY}

    Click    css=button.login-form__form-submit:has-text("ورود")
