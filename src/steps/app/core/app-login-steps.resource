*** Settings ***
Resource        services/frontend/playwright/browser-service.resource
Resource        services/frontend/playwright/front-auth-service.resource
Resource        services/backend/import-allocation.resource
Resource        services/backend/user-wallet-initializer-service.resource
Variables       data/app/hub/hub.yaml


*** Keywords ***
Start Browser
    [Arguments]    ${url}=${APP_LOGIN_URL}    ${alias}=${HEADLESS_CHROME}
    ${browser_id}    ${page_info}    Start Browser Session    ${url}    ${alias}
    ${page_id}    Get From Dictionary    ${page_info}    page_id
    Set Test Variable    ${browser_id}
    Set Test Variable    ${page_id}

End Browser
    Run Keyword And Ignore Error    Close Page By Id    ${page_id}
    Run Keyword And Ignore Error    Close Browser By Id    ${browser_id}

Reproduce Amount
    [Arguments]    ${additional_user_lists}=${ALLOCATION_USER_LIST}

    Collect All Amount For Tear Down    additional_user_lists=${additional_user_lists}

Close Browser And Reproduce Amounts And Clear The Redis For The User
    End Browser
    Reproduce Amount
    ${key}    Set Variable    auth_otp_${user_id}
    ${clear_otp_result}    Redis Delete Key    key=${key}    master_name=redis-new-master
    ${clear_otp_status_code}    Set Variable    ${clear_otp_result['status_code']}
    Should Be Equal As Strings
    ...    ${clear_otp_status_code}
    ...    0
    ...    msg=Expected to clear otp from redis with status code 0, but got ${clear_otp_status_code}

Credit Allocation
    [Arguments]    ${types}    &{optional_arguments}

    ${user_object}    Activate Account
    ...    types=${types}
    ...    &{optional_arguments}

    ${cell_number}    Set Variable    ${user_object['user_cell_number']}
    ${user_id}    Set Variable    ${user_object['user_id']}
    ${credit_ids}    Set Variable    ${user_object['user_credit_ids']}
    &{user_data}    Create Dictionary    user_id=${user_id}    type=${CUSTOMER_TYPE}
    ${ALLOCATION_USER_LIST}    Create List    ${user_data}

    Set Test Variable    ${cell_number}
    Set Test Variable    ${user_id}
    Set Test Variable    ${credit_ids}
    Set Test Variable    ${user_object}
    Set Test Variable    ${ALLOCATION_USER_LIST}

A Random User Is Generated
    Credit Allocation
    ...    types=${{['${LMS_Account_Type_1PAY}']}}

A Predefined User With Pin Is Prepared
    ${ALLOCATION_USER_LIST}    Create List
    Set Test Variable    ${user_id}    ${USER_ID_WITH_PIN}
    Set Test Variable    ${ALLOCATION_USER_LIST}

Logins To App Via API Calls
    ${login_status}    UI Login To App
    ...    cell_number=${cell_number}
    ...    type=${LOGIN_TYPE_API}    
    Set Test Variable    ${login_status}

Logins To App Via APP Processes
    [Arguments]    ${skip_walkthrough}=${False}
    UI Login To App
    ...    cell_number=${cell_number}
    ...    type=${LOGIN_TYPE_APP}    
    ...    skip_walk_through=${skip_walkthrough}

Logins To App Via API Calls With Wrong OTP
    ${login_status}    UI Login To App
    ...    cell_number=${cell_number}
    ...    type=${LOGIN_TYPE_API}
    ...    otp_overwrite=${WRONG_OTP}
    ...    skip_walk_through=${True}
    Set Test Variable    ${login_status}

Logins To App Via APP Processes With Wrong OTP
    UI Login To App
    ...    cell_number=${cell_number}
    ...    type=${LOGIN_TYPE_APP}
    ...    otp_overwrite=${WRONG_OTP}
    ...    skip_walk_through=${True}

Logins To App Via API Calls With Pin
    ${login_status}    UI Login To App
    ...    cell_number=${USER_CELL_NUMBER_WITH_PIN}
    ...    type=${LOGIN_TYPE_API}
    ...    pin_code=${CORRECT_PIN}
    Set Test Variable    ${login_status}

Logins To App Via APP Processes With Pin
    [Arguments]    ${skip_walk_through}=${False}
    UI Login To App
    ...    cell_number=${USER_CELL_NUMBER_WITH_PIN}
    ...    type=${LOGIN_TYPE_APP}
    ...    pin_code=${CORRECT_PIN}    
    ...    skip_walk_through=${skip_walk_through}

Logins To App Via API Calls With Wrong PIN
    ${login_status}    UI Login To App
    ...    cell_number=${USER_CELL_NUMBER_WITH_PIN}
    ...    type=${LOGIN_TYPE_API}
    ...    pin_code=${WRONG_PIN}
    ...    skip_walk_through=${True}
    Set Test Variable    ${login_status}

Logins To App Via APP Processes With Wrong PIN
    UI Login To App
    ...    cell_number=${USER_CELL_NUMBER_WITH_PIN}
    ...    type=${LOGIN_TYPE_APP}
    ...    pin_code=${WRONG_PIN}
    ...    skip_walk_through=${True}

Check Home URL
    [Arguments]    ${expects}=True
    ${current_url}    Get Url
    Should Start With
    ...    str1=${current_url}
    ...    str2=${APP_HUB_URL}
    ...    msg=Expected the current URL to start with ${APP_HUB_URL}, but got ${current_url}

Should Be At The HUB Page
    Wait Until Keyword Succeeds    60 s    1 s    Check Home URL

Should Not Be At The HUB Page
    ${status}    Run Keyword And Return Status    Wait Until Keyword Succeeds    60 s    1 s    Check Home URL    False
    IF    ${status}
        Fail    msg=Expected the current URL not to start with ${APP_HUB_URL}, but it did after all retries.
    END

Login Returned Status Should Be Failed
    Should Be Equal As Strings
    ...    first=${False}
    ...    second=${login_status}
    ...    msg=Expected The login status to be "${False}", but got ${login_status}.

Login Returned Status Should Be PASSED
    Should Be Equal As Strings
    ...    first=${True}
    ...    second=${login_status}
    ...    msg=Expected The login status to be "${True}", but got ${login_status}.
