*** Settings ***
Resource        services/AI/find-and-click-utility.resource
Resource        services/frontend/browser-service.resource
Variables       data/icons/icon-paths.yaml


*** Variables ***
${browser}              ${FIREFOX}
${has_onboarding}       False
${debug}                False
${URL}                  https://example.com/auth/login


*** Keywords ***
Login To App With AI
    [Documentation]    Automates the login process for the Platform application using AI-based icon detection.
    ...
    ...    *Inputs:*
    ...    - `${cell_number}`: (Optional) The cell phone number to use for login. Defaults to `09911772110`.
    ...    - `${has_onboarding}`: (Optional) Whether the login process includes an onboarding step. Defaults to `False`.
    ...    - `${debug}`: (Optional) Whether to enable debugging features (e.g., displaying red dots for clicks). Defaults to `True`.
    ...    - `${URL}`: (Optional) The URL of the login page. Defaults to `https://example.com/auth/login`.
    ...    - `${browser}`: (Optional) The browser to use for the test. Defaults to `${FIREFOX}`.
    ...
    ...    *Behavior:*
    ...    - Connects to the browser and navigates to the login page.
    ...    - Uses AI-based icon detection to interact with the login form.
    ...    - Fetches an OTP from a secondary URL and enters it into the login form.
    ...    - Completes the login process, skipping onboarding if not implemented.
    [Arguments]
    ...    ${cell_number}=09911772110
    ...    ${has_onboarding}=${has_onboarding}
    ...    ${debug}=${debug}
    ...    ${URL}=${URL}
    ...    ${browser}=${browser}

    IF    '${has_onboarding}'=='True'
        Fail    msg=Not Implemented, The onboarding has been removed from the app!
    END

    ## Stage 1: Login Page
    VAR    ${option}    add_argument("--disable-notifications")
    Connect To Browser    ${URL}    browser=${browser}    option=${option}    is_remote=${False}
    Maximize Browser Window

    Sleep    3sec

    Press Keys    None    TAB

    Press Keys    None    ${cell_number}

    Sleep    2sec

    Find And Click    icon_path=${ICON_LOGIN_STEP_1}    debug=${debug}    version=vanilla

    ## Stage 2: OTP Catcher
    ${otp_url}    Set Variable    https://example.com/otp-catcher
    Execute Javascript    window.open('${otp_url}', '_blank')

    ${handles}    Get Window Handles
    Switch Window    ${handles}[1]

    Sleep    3sec

    Input Text    //*[@id="phoneNumber"]    ${cell_number}
    Click Button    xpath=//input[@value='Fetch OTP']

    Sleep    1sec

    ${otp}    Get Text    xpath=//div[@class='result']/div[1]/span

    Close Window
    Switch Window    ${handles}[0]

    Sleep    3sec

    ## Stage 3: Continue Login
    Press Keys    None    TAB
    Sleep    1sec
    Press Keys    None    ${otp}[0]
    Sleep    1sec
    Press Keys    None    ${otp}[1]
    Sleep    1sec
    Press Keys    None    ${otp}[2]
    Sleep    1sec
    Press Keys    None    ${otp}[3]
    Sleep    1sec
    Press Keys    None    ${otp}[4]
    Sleep    1sec
    Press Keys    None    ${otp}[5]
    Sleep    1sec

    IF    ${has_onboarding}==True    Fail    msg=Not Implemented!

    Sleep    1sec
