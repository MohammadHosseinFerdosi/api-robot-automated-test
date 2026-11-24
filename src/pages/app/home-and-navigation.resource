*** Settings ***
Library     Browser
*** Keywords ***
Get Page URL
    RETURN    /home

Get App Base URL
    RETURN    ${APP_BASE_URL}

Get Page Elements
    &{elements}    Create Dictionary
    ...    wallet_management=//div[contains(text(),'کیف پول')]
    ...    home=//i[@class='icon icon-home-bold']
    ...    hub=//div[contains(@class, 'bottom-navigation-items-item') and .//i[contains(@class, 'icon-more-bold')] and .//div[text()=' خدمات ']]
    ...    stores=///i[@class='icon icon-bag-linear']
    ...    pay=//div[@class='bottom-navigation-items-item-title l-2 text-onback-medium'][contains(text(),'پرداخت')]
    ...    profile=//i[@class='icon icon-person-linear']
    RETURN    ${elements}

Should Be In Home Page
    ${expected_path}    Get Page URL
    Wait Until Location Contains    ${expected_path}
    ${elements}    Get Page Elements

Navigate To
    [Documentation]    Navigate to the specified location from the home page.
    [Arguments]    ${location}
    ${elements}    Get Page Elements
    ${current_url}    Get Location
    ${home_url}    Get Page URL
    IF    '${current_url}' != '${home_url}'    Back To Home
    ${elements}    Get Page Elements
    IF    '${location}' == '${WALLET_MANAGEMENT_PAGE}'
        Click Element    ${elements['wallet_management']}
    END
    IF    '${location}' == '${HUB_PAGE}'    Click Element    ${elements['hub']}
    IF    '${location}' == '${STORES_PAGE}'
        Click Element    ${elements['stores']}
    END
    IF    '${location}' == '${PAY_PAGE}'    Click Element    ${elements['pay']}
    IF    '${location}' == '${PROFILE_PAGE}'
        Click Element    ${elements['profile']}
    END

Back To Home
    ${elements}    Get Page Elements
    Click Element    ${elements['home']}
    Should Be In Home Page
