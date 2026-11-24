*** Settings ***
Library         String
Library         Collections
Library         JSONLibrary
Library         RequestsLibrary
Library         library/faker_utils.py    WITH NAME    FakerLibrary
Variables       data/CONSTANTS.yaml
Resource        apis/uaa/oauth/oauth-token.resource
Resource        apis/uaa/users/users-send-sms.resource
Resource        apis/uaa/users/users-login.resource
Resource        apis/uaa/users/users-password.resource
Resource        apis/user-mng/users-activate.resource
Resource        services/db/mysql-db-service.resource
Resource        services/db/redis-db-service.resource


*** Keywords ***
Login To Dashboard
    [Documentation]    Login to dashboard based on `${username}` and `${password}`, if login successful,
    ...    `${ACCESS_TOKEN_SERVICE}` sets as suite variable, otherwise test will be failed.
    [Arguments]    ${username}    ${password}
    ${device_id}    Generate Random String    15
    ${result}    POST Oauth Token
    ...    ${DASHBOARD_SIDE}
    ...    ${username}
    ...    ${password}
    ...    ${device_id}
    ...    ${DASHBOARD_BASIC_AUTH}
    ...    zone=dashboard
    Should Be Equal As Integers    ${result['status_code']}    200    msg=Login to dashboard failed
    Set Access Token To Suite
    ...    ${result['body']['access_token']}
    ...    ${result['body']['refresh_token']}
    ...    ${username}
    ...    ${device_id}

Login For Business
    [Documentation]    Login with business account like company, based on '${username}' and `${password}`,
    ...    if login successful, `${ACCESS_TOKEN_SERVICE}` sets as suite variable, otherwise test will be failed.
    [Arguments]    ${username}    ${password}
    ${device_id}    Generate Random String    15
    ${result}    POST Oauth Token
    ...    ${GENERAL_SIDE}
    ...    ${username}
    ...    ${password}
    ...    ${device_id}
    ...    ${BUSINESS_BASIC_AUTH}
    Should Be Equal As Integers    ${result['status_code']}    200    msg=Login to business failed
    Set Access Token To Suite
    ...    ${result['body']['access_token']}
    ...    ${result['body']['refresh_token']}
    ...    ${username}
    ...    ${device_id}

Login To App
    [Documentation]    Login to app based on '${cell_number}', if login successful,
    ...    `${ACCESS_TOKEN_SERVICE}` sets as suite variable, otherwise test will be failed.
    ...    NOTE: if `${pin_code}` sets, after user activate with pin_code. ${otp_overwrite} is used for
    ...    negative test cases and overwrites the otp received.
    [Arguments]    ${cell_number}    ${pin_code}=${EMPTY}    ${otp_overwrite}=${EMPTY}

    ${device_id}    Uuid 4
    ${device_info}    Create Dictionary
    ...    deviceId=${device_id}
    ...    deviceModel=WEB_BROWSER
    ...    deviceAPI=WEB_BROWSER
    ...    osName=WEB

    ${send_sms_response}    POST Users Send SMS    ${APP_SIDE}    ${cell_number}    ${device_info}

    IF    ${send_sms_response['status_code']} == 200
        ${user_id}    Set Variable    ${send_sms_response['body']['userId']}

        # Extract user id from mysql db, if otp token alredy sent.
    ELSE IF    '${send_sms_response['body']['result']['title']}' == 'UAA_OTP_ALREADY_SENT'
        ${db_qury_result}    MySQL Fetch All
        ...    db_name=uaa_db
        ...    query=SELECT * FROM uaa_db.users WHERE cell_number="${cell_number}" AND zone_id="app"
        Should Be Equal As Integers
        ...    ${db_qury_result['status_code']}
        ...    0
        ...    msg=mysql result should be successful but found: ${db_qury_result['body']}

        ${user_id}    Set Variable    ${db_qury_result['body'][0]['user_id']}
    ELSE
        Fail    msg=Send sms opt failed for cell number: ${cell_number} with error: ${send_sms_response['body']}
    END
    ${key}    Set Variable    auth_otp_${user_id}
    ${get_otp_result}    Redis Get Key    key=${key}    master_name=redis-new-master
    ${get_otp_value}    Set Variable    ${get_otp_result['body']['value']}
    ${get_otp_value}    Decode Bytes To String    bytes=${get_otp_value}    encoding=utf-8
    ${get_otp_status_code}    Set Variable    ${get_otp_result['status_code']}
    IF    '${otp_overwrite}'!='${EMPTY}'
        ${otp_overwrite}    Convert To List    ${otp_overwrite}
        ${get_otp_value}    Set Variable    ${otp_overwrite}
    ELSE IF    '${get_otp_status_code}'=='0' and '${get_otp_value}' !='${null}'
        ${get_otp_value}    Convert String To Json    json_string=${get_otp_value}
        ${otp_list}    Get Value From Json
        ...    ${get_otp_value}
        ...    $.otpCodes[*].[*].value
        ...    fail_on_empty=${True}
        ${user_opt}    Set Variable    ${otp_list[-1]}
        # if otp token alredy sent, device id must be update based on last otp
        ${device_id_in_otp}    Get Value From Json
        ...    ${get_otp_value}
        ...    $.device.deviceId
        ...    fail_on_empty=${True}
        Set to Dictionary    ${device_info}    deviceId=${device_id_in_otp[-1]}
    ELSE
        Fail    msg=Get OTP Failed with Status: ${get_otp_result.status_code} and message ${get_otp_result['body']}
    END

    ${user_activate_result}    POST Users Activate    ${APP_SIDE}    ${user_id}    ${user_opt}
    Should Be Equal As Integers
    ...    ${user_activate_result['status_code']}
    ...    200
    ...    msg=Activate for user failed with cell number: ${cell_number}

    IF    ${user_activate_result['body']['hasPassword']} == ${True}
        ${user_login_result}    POST Users Login    ${APP_SIDE}    ${user_id}    ${pin_code}    ${device_info}
        Should Be Equal As Integers
        ...    ${user_login_result['status_code']}
        ...    200
        ...    msg=Activate failed for user with cell number: ${cell_number}, with message: ${user_login_result['body']['result']}
        Set Access Token To Suite
        ...    ${user_login_result['body']['accessToken']}
        ...    ${user_login_result['body']['refreshToken']}
        ...    ${user_id}
        ...    ${device_id}
    ELSE
        Set Access Token To Suite
        ...    ${user_activate_result['body']['accessToken']}
        ...    ${user_activate_result['body']['refreshToken']}
        ...    ${user_id}
        ...    ${device_id}
    END
    RETURN    ${user_id}

Set Access Token To Suite
    [Documentation]    Set `${access_token}` as `Authorization=Bearer`
    ...    key for using session service for set it to header.
    [Tags]    robot:private
    [Arguments]    ${access_token}    ${refresh_token}    ${user_id}    ${device_id}
    ${AUTHENTICATED_USER_PARAMETERS}    Create Dictionary
    ...    user_id=${user_id}
    ...    access_token=${access_token}
    ...    refresh_token=${refresh_token}
    ...    device_id=${device_id}
    Set Suite Variable    ${AUTHENTICATED_USER_PARAMETERS}
