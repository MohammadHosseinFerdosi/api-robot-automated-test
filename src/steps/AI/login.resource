*** Settings ***
Resource        services/AI/find-and-click-utility.resource
Resource        services/frontend/browser-service.resource


*** Keywords ***
URL Is Valid
    [Documentation]    An intermediary step to check if we are in a valid url
    [Arguments]    ${contains}
    ${current_url}    Get Location
    ${is_home_page}    Evaluate    '${contains}' in '${current_url}'
    IF    '${is_home_page}'!='True'
        Fail    msg=We are not in the homepage yet! Got ${current_url}, expected to contain ${contains}.
    END

In The Home Page
    [Documentation]    An Assertion to simply test if the login was successful
    [Arguments]    ${contains}=https://example.com/hub

    Wait Until Keyword Succeeds    1 minute    2 s    URL Is Valid    contains=${contains}
