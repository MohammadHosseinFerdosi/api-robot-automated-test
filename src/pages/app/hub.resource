*** Settings ***
Library    Browser
Variables  config/environment-stage.yaml
*** Keywords ***
Get Page URL
    [Documentation]    The relative Hub URL (e.g., /app/hub)
    RETURN    ${Hub_PAGE_PATH}
Get App Base URL
    [Documentation]    The base application URL (e.g., https://example.com)
    RETURN    ${APP_BASE_URL}
Get Page Elements
    &{elements}    Create Dictionary
    ...    wallet_management=xpath=//div[contains(text(),'کیف پول')]
    ...    welcome_to_new_app=xpath=//button[@class='bt-1 mode-form ngx-button size-large style-fill']
    ...    top_up=xpath=//div[*[contains(text(),'خرید شارژ')]]
    ...    internet_package=xpath=//div[*[contains(text(),'بسته اینترنت')]]
    ...    c2c=xpath=//div[*[contains(text(),'کارت‌به‌کارت')]]
    ...    bill=xpath=//div[*[contains(text(),'پرداخت قبض')]]
    ...    driving_fine=xpath=//div[*[contains(text(),'استعلام جریمه')]]
    ...    toll=xpath=//div[*[contains(text(),'عوارض جاده‌ای')]]
    ...    taxi=xpath=//div[*[contains(text(),'تاکسی')]]
    ...    charity=xpath=//div[*[contains(text(),'خیریه')]]
    ...    qr_scanner=xpath=//div[*[contains(text(),'بارکد‌خوان')]]
    ...    home=xpath=//i[@class='icon icon-home-bold']
    ...    hub=xpath=//div[contains(@class, 'bottom-navigation-items-item') and div[text()='خدمات']]
    ...    stores=xpath=//i[@class='icon icon-bag-linear']
    ...    pay=xpath=//div[contains(@class, 'bottom-navigation-items-item-title') and contains(text(), 'پرداخت')]
    ...    profile=xpath=//i[@class='icon icon-person-linear']
    RETURN    ${elements}

Should Be On Hub Page
    [Documentation]    Verifies that the current URL contains the Hub path
    ${expected_path}=    Get Page URL
    Ensure Location Contains Path    ${expected_path}

Navigate To
    [Documentation]    Navigates to a specific page from the Hub
    [Arguments]    ${location}
    ${elements}=    Get Page Elements
    ${current_url}=    Get Url
    ${hub_url}=        Get Page URL
    ${current_path}=   Evaluate    '${current_url}'.split("example.com")[-1]
    IF    '${current_path}' != '${hub_url}'
        Back To Hub
    END
    &{navigation_map}=    Create Dictionary
    ...    ${WALLET_MANAGEMENT_PAGE}=${elements['wallet_management']}
    ...    ${TOP_UP_PAGE}=${elements['top_up']}
    ...    ${INTERNET_PACKAGE_PAGE}=${elements['internet_package']}
    ...    ${C2C_PAGE}=${elements['c2c']}
    ...    ${BILL_PAGE}=${elements['bill']}
    ...    ${DRIVING_FINE_PAGE}=${elements['driving_fine']}
    ...    ${TOLL_PAGE}=${elements['toll']}
    ...    ${TAXI_PAGE}=${elements['taxi']}
    ...    ${CHARITY_PAGE}=${elements['charity']}
    ...    ${BARCODE_SCANNER_PAGE}=${elements['qr_scanner']}
    ...    ${PAY_PAGE}=${elements['pay']}
    ${locator}=    Set Variable    ${navigation_map}[${location}]
    Wait For Elements State    ${locator}    visible    timeout=10s
    Click    ${locator}

Back To Hub
    [Documentation]    Clicks the 'Services' tab and ensures being on the Hub
    ${elements}=    Get Page Elements
    Wait For Elements State    ${elements['hub']}    visible    timeout=10s
    Click    ${elements['hub']}
    Should Be On Hub Page

Ensure Location Contains Path
    [Arguments]    ${expected_path}
    ${script}=    Set Variable    return window.location.href.includes("${expected_path}")
    ${result}=    Run Keyword And Ignore Error    Wait For Condition    ${script}    10s
    IF    '${result[0]}' == 'FAIL'
        Handle Failed Navigation    ${expected_path}
    END

Handle Failed Navigation
    [Arguments]    ${expected_path}
    Back To Hub
    ${script}=    Set Variable    return window.location.href.includes("${expected_path}")
    Wait For Condition    ${script}    10s

Navigate To Hub By URL
    [Documentation]    Directly navigates to the Hub using the URL
    ${base_url}=    Get App Base URL
    ${hub_path}=    Get Page URL
    Go To    ${base_url}${hub_path}
    ${script}=    Set Variable    return window.location.href.includes("${hub_path}")
    Wait For Condition    ${script}    10s