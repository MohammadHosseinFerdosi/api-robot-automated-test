*** Settings ***
Library     String
Library     Collections
Library     Browser
Library     library/faker_utils.py    WITH NAME    FakerLibrary
Resource    services/db/mysql-db-service.resource
Resource    apis/uaa/users/users-login.resource


*** Keywords ***
Enter Pin - UI
    [Documentation]    This Keywords, given a ${pin_code}, tries to enter in in an E2E manner. Meaning It will click on the pin password selector and enters the pin
    [Arguments]    ${pin_code}
    ${pin_code}    Convert To List    ${pin_code}
    ${pin}    Evaluate    ''.join(${PIN_CODE})
    Wait For Elements State    css=#password    attached    ${DEFAULT_ELEMENT_TIMEOUT}
    Fill Text    css=#password    ${pin}

Enter Pin - API
    [Documentation]    This Keywords, given a ${pin_code}, tries to enter in in an API call manner. Meaning It will call the API that is responsible for the user login.
    [Arguments]    ${cell_number}    ${pin_code}    ${api_call_side}=${APP_SIDE}

    ${device_id}    Uuid 4
    ${device_info}    Create Dictionary
    ...    deviceId=${device_id}
    ...    deviceModel=WEB_BROWSER
    ...    deviceAPI=WEB_BROWSER
    ...    osName=WEB

    ${db_qury_result}    MySQL Fetch All
    ...    db_name=uaa_db
    ...    query=SELECT * FROM uaa_db.users WHERE cell_number="${cell_number}" AND zone_id="app"
    Should Be Equal As Integers
    ...    ${db_qury_result['status_code']}
    ...    0
    ...    msg=mysql result should be successful but found: ${db_qury_result['body']}

    ${user_id}    Set Variable    ${db_qury_result['body'][0]['user_id']}

    ${user_login_result}    POST Users Login    ${api_call_side}    ${user_id}    ${pin_code}    ${device_info}
    Should Be Equal As Integers
    ...    ${user_login_result['status_code']}
    ...    200
    ...    msg=Activate failed for user with cell number: ${cell_number}, with message: ${user_login_result['body']['result']}

    RETURN    ${user_login_result}
