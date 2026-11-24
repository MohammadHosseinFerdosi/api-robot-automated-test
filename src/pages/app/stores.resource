*** Settings ***
Resource        parent.resource



*** Keywords ***
# Keyword to get the Pay page URL
Get Page URL
    RETURN    /stores

# Keyword to get the base URL of the application

Get App Base URL
    RETURN    ${APP_BASE_URL}

# Keyword to retrieve elements on the pay page and store them in a dictionary

Get Page Elements
    &{elements}    Create Dictionary
    ...    stores_label=//div[contains(@class, 'st-8') and contains(@class, 'text-onback-high') and contains(@class, 'title') and text()='فروشگاه‌ها']
    RETURN    ${elements}

# Keyword to verify if the current page is the home page

Should Be In Stores's Page
    ${expected_path}    Get Page URL
    Wait Until Location Contains    ${expected_path}
    ${elements}    Get Page Elements
    Wait Until Page Contains Element    ${elements['stores_label']}
    Page Should Contain Element    ${elements['stores_label']}

# Keyword to navigate to a specified location from the pay page

Navigate To
    [Documentation]    Navigate to the specified location from the home page.
    [Arguments]    ${location}
    ${elements}    Get Page Elements
    ${current_url}    Get Location
    ${stores_url}    Get Page URL
    IF    '${current_url}' != '${stores_url}'    Back To stores
    ${elements}    Get Page Elements

Back To stores
    ${elements}    Get Page Elements
    Click Element    ${elements['home']}
    Should Be In Stores's Page