*** Settings ***
Library     Browser


*** Keywords ***
Skip Walkthrough - UI
    [Documentation]    This keywords aims to skip the walkthrough process in an E2E manner, meaning *Given the element existence*,
    ...    It will click on the [x] button to skip its process.
    ...
    ...    Additionally It will try to skip the hub onboarding as well.
    [Arguments]    ${skip_hub_onboarding}=${False}
    Wait For Elements State    css=ngx-button.close-btn button    enabled    ${DEFAULT_ELEMENT_TIMEOUT}
    Click    css=ngx-button.close-btn button

    IF    ${skip_hub_onboarding}
        Click    css=button:has-text("ادامه")
        Click    css=button:has-text("ادامه")
        Click    css=button:has-text("متوجه شدم")
    END

Skip Walkthrough - Local Storage
    [Documentation]    This keywords aims to skip the walkthrough process via local storage manipulation, meaning it will set their values to their final state.
    ...
    ...    Additionally It will try to skip the hub onboarding as well.
    [Arguments]    ${skip_hub_onboarding}=${False}

    Local Storage Set Item    walk-through-dpx    {"step":"done"}
    Local Storage Set Item    hub-walk-through    {"step":"done"}
    Local Storage Set Item    profile-walk-through    {"step":"done"}
    Local Storage Set Item    stores-walk-through    {"step":"done"}
    Local Storage Set Item    transaction-walk-through    {"step":"done"}

    IF    ${skip_hub_onboarding}
        LocalStorage Set Item    checkHubOnboarding    true
    END
