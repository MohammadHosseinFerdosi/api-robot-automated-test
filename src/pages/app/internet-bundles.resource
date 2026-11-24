*** Settings ***
Library    Browser
Library    String
Library    Collections

*** Keywords ***
Get Page URL
    [Documentation]    Returns the URL path for the internet bundles page.
    RETURN    ${INTERNET_BUNDLES_PAGE_PATH}

Get Page Elements
    &{elements}=    Create Dictionary
    ...    page_title=//*[contains(text(),'انتخاب بسته اینترنت')]
    ...    packages_container=//div[contains(@class,'packages-container')]
    ...    package_category=//p[contains(@class,'packages-title')]
    ...    all_tab=//internet-applet-badge-component//div[contains(text(),'همه')]
    ...    daily_tab=//internet-applet-badge-component//div[contains(text(),'روزانه')]
    ...    weekly_tab=//internet-applet-badge-component//div[contains(text(),'هفتگی')]
    ...    monthly_tab=//internet-applet-badge-component//div[contains(text(),'ماهانه')]
    ...    yearly_tab=//internet-applet-badge-component//div[contains(text(),'سالانه')]
    ...    popular_tab=//internet-applet-badge-component//div[contains(text(),'پرطرفدار')]
    ...    mix_tab=//internet-applet-badge-component//div[contains(text(),'ترکیبی')]
    ...    package_card=//div[contains(@class,'card') and contains(@class,'mb-medium')]
    ...    first_package=(//div[contains(@class,'card') and contains(@class,'mb-medium')])[1]
    ...    package_description=//p[contains(@class,'card-desc')]
    ...    package_amount=//span[contains(@class,'amount-value')]
    ...    continue_btn=//button[contains(text(),'ادامه')]
    ...    back_btn=//button[contains(@class,'mode-icon-only')]
    ...    error_message=//span[contains(@class,'text-onback-high')]
    ...    package_details_bottom_sheet=//div[contains(@class,'bottom-sheet-content') and contains(@class,'open')]
    ...    package_details_confirm_btn=//div[contains(@class,'button-label') and contains(.,'تایید و ادامه')]
    ...    package_details_cancel_btn=//div[contains(@class,'button-label') and contains(.,'فعلا نه')]
    RETURN    ${elements}

Should Be On Internet Bundles Page
    ${elements}=    Get Page Elements
    Browser.Wait For Elements State    ${elements['page_title']}    visible    timeout=${DEFAULT_ELEMENT_TIMEOUT}

Select Bundle Tab
    [Arguments]    ${tab_key}
    ${elements}=    Get Page Elements
    ${tab_locator}=    Set Variable If
    ...    '${tab_key}' == 'ALL'       ${elements['all_tab']}
    ...    '${tab_key}' == 'DAILY'    ${elements['daily_tab']}
    ...    '${tab_key}' == 'WEEKLY'   ${elements['weekly_tab']}
    ...    '${tab_key}' == 'MONTHLY'  ${elements['monthly_tab']}
    ...    '${tab_key}' == 'YEARLY'   ${elements['yearly_tab']}
    ...    '${tab_key}' == 'POPULAR'  ${elements['popular_tab']}
    ...    '${tab_key}' == 'MIX'      ${elements['mix_tab']}
    Browser.Wait For Elements State    ${tab_locator}    visible    timeout=${DEFAULT_ELEMENT_TIMEOUT}
    Browser.Click    ${tab_locator}

Select Bundle Package
    [Arguments]    ${package_index}=1
    ${elements}=    Get Page Elements
    Browser.Wait For Elements State    ${elements['packages_container']}    visible    timeout=${DEFAULT_ELEMENT_TIMEOUT}
    ${package_card}=    Set Variable    (${elements['package_card']})[${package_index}]
    Browser.Wait For Elements State    ${package_card}    visible    timeout=${DEFAULT_ELEMENT_TIMEOUT}
    ${bundle_desc}=    Browser.Get Text    ${package_card}${elements['package_description']}
    ${amount_text}=    Browser.Get Text    ${package_card}${elements['package_amount']}
    ${amount}=    Evaluate    ''.join(ch for ch in """${amount_text}""" if ch.isdigit())
    Browser.Click    ${package_card}
    &{package_info}=    Create Dictionary
    ...    description=${bundle_desc}
    ...    amount=${amount}
    ...    amount_raw=${amount_text}
    RETURN    ${package_info}

Handle Package Details Bottom Sheet
    [Arguments]    ${action}=CONFIRM
    ${elements}=    Get Page Elements
    ${bottom_sheet_exists}=    Run Keyword And Return Status
    ...    Browser.Wait For Elements State    ${elements['package_details_bottom_sheet']}    visible    timeout=${DEFAULT_ELEMENT_TIMEOUT}
    IF    ${bottom_sheet_exists}
        IF    '${action}' == 'CONFIRM'
            Browser.Click    ${elements['package_details_confirm_btn']}
        ELSE
            Browser.Click    ${elements['package_details_cancel_btn']}
            Browser.Wait For Elements State    ${elements['package_details_bottom_sheet']}    hidden    timeout=${DEFAULT_ELEMENT_TIMEOUT}
        END
    END

Click Continue Button
    ${elements}=    Get Page Elements
    Browser.Wait For Elements State    ${elements['continue_btn']}    enabled    timeout=${DEFAULT_ELEMENT_TIMEOUT}
    Browser.Click    ${elements['continue_btn']}

Verify Error Message
    [Arguments]    ${expected_message}=${NONE}
    ${elements}=    Get Page Elements
    Browser.Wait For Elements State    ${elements['error_message']}    visible    timeout=${DEFAULT_ELEMENT_TIMEOUT}
    IF    ${expected_message} != ${NONE}
        ${actual_message}=    Get Text    ${elements['error_message']}
        ${actual_message}=    Strip String    ${actual_message}
        ${expected_message}=    Strip String    ${expected_message}
        Should Be Equal As Strings    ${actual_message}    ${expected_message}
    END

Click Back Button
    ${elements}=    Get Page Elements
    ${back_btn_exists}=    Run Keyword And Return Status
    ...    Browser.Wait For Elements State    ${elements['back_btn']}    visible    timeout=${DEFAULT_ELEMENT_TIMEOUT}
    IF    ${back_btn_exists}
        Browser.Click    ${elements['back_btn']}
        Browser.Wait For Elements State    ${elements['page_title']}    hidden    timeout=${DEFAULT_ELEMENT_TIMEOUT}
        RETURN    ${TRUE}
    ELSE
        RETURN    ${FALSE}
    END