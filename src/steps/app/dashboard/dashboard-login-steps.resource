*** Settings ***
Resource        services/frontend/playwright/browser-service.resource
Resource        services/frontend/playwright/front-auth-service.resource
Variables       data/dashboard/dashboard_configs.yaml


*** Keywords ***
Start Browser
    [Arguments]    ${url}=${DASHBOARD_LOGIN_URL}    ${alias}=${HEADLESS_CHROME}
    ${browser_id}    ${page_info}    Start Browser Session    ${url}    ${alias}
    ${page_id}    Get From Dictionary    ${page_info}    page_id
    Set Test Variable    ${browser_id}
    Set Test Variable    ${page_id}

End Browser
    Run Keyword And Ignore Error    Close Page By Id    ${page_id}
    Run Keyword And Ignore Error    Close Browser By Id    ${browser_id}

User Has Access To Authenticated Account
    Set Test Variable    ${test_username}    ${AUTOMATION_DASHBOARD_USERNAME}
    Set Test Variable    ${test_password}    ${AUTOMATION_DASHBOARD_PASSWORD}

User Does Not Have Access To Authenticated Account
    Set Test Variable    ${test_username}    ${AUTOMATION_DASHBOARD_USERNAME}
    Set Test Variable    ${test_password}    ${AUTOMATION_DASHBOARD_WRONG_PASSWORD}

Logins To Dashboard Via API Calls
    ${login_status}    UI Login To Dashboard
    ...    username=${test_username}
    ...    password=${test_password}
    ...    type=${LOGIN_TYPE_API}
    Set Test Variable    ${login_status}

Logins To Dashboard Via APP Processes
    UI Login To Dashboard
    ...    username=${test_username}
    ...    password=${test_password}
    ...    type=${LOGIN_TYPE_APP}

Logins To Dashboard Via API Calls With Invalid Password
    ${login_status}    UI Login To Dashboard
    ...    username=${test_username}
    ...    password=${test_password}
    ...    type=${LOGIN_TYPE_API}
    Set Test Variable    ${login_status}

Logins To Dashboard Via APP Processes With Invalid Password
    UI Login To Dashboard
    ...    username=${test_username}
    ...    password=${test_password}
    ...    type=${LOGIN_TYPE_APP}

Check Home URL
    [Arguments]    ${expects}=True
    ${current_url}    Get Url
    Should Start With
    ...    str1=${current_url}
    ...    str2=${DASHBOARD_HOME_URL}
    ...    msg=Expected the current URL to start with ${DASHBOARD_HOME_URL}, but got ${current_url} after all retries.
Should Be At The Home Page
    Wait Until Keyword Succeeds    60 s    1 s    Check Home URL

Should not Be At The Home Page
    ${status}    Run Keyword And Return Status    Wait Until Keyword Succeeds    60 s    1 s    Check Home URL    False
    IF    ${status}
        Fail    msg=Expected the current URL not to start with ${DASHBOARD_HOME_URL}, but it did after all retries.
    END

Login Returned Status Should Be Failed
    Should Be Equal As Strings
    ...    first=${False}
    ...    second=${login_status}
    ...    msg=Expected The login status to be "${False}", but got "${login_status}".

Login Returned Status Should Be PASSED
    Should Be Equal As Strings
    ...    first=${True}
    ...    second=${login_status}
    ...    msg=Expected The login status to be "${True}", but got "${login_status}".
