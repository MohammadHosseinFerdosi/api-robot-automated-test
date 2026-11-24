***** Settings *****
Library    Browser
Library    String

***** Keywords *****
Get Page URL
    [Documentation]    Returns the URL path for the internet package page.
    RETURN    ${INTERNET_PACKAGE_PAGE_PATH}

Get Page Elements
    &{elements}=    Create Dictionary
    ...    Internet_Package_Label=//*[contains(text(),'بسته اینترنت')]
    ...    cell_number=//input[@type='tel']
    ...    purchase_btn=//button[*[text()=" خرید اینترنت "]]
    ...    sim_type_picker=//common-cellular-operator-sim-type-picker
    ...    postpaid=//*[contains(text(),'دائمی')]
    ...    prepaid=//*[contains(text(),'اعتباری')]
    ...    td_lte=//*[contains(text(),'TD-LTE')]
    ...    data=//*[contains(text(),'دیتا')]
    ...    my_cell_numbers=//*[contains(text(),'شماره‌های من')]
    ...    first_recommendation=(//daily-fintech-recommendation-item)[2]
    ...    recom_cell_number=//daily-fintech-recommendation-item[2]//span[contains(@class, 'text-onback-low') and contains(@class, 'l-3')]
    ...    error_message=//span[contains(@class,'text-onback-high')]
    RETURN    ${elements}

Should Be On Internet Package Page
    ${elements}=    Get Page Elements
    Browser.Wait For Elements State
    ...    ${elements['Internet_Package_Label']}
    ...    visible
    ...    timeout=${DEFAULT_ELEMENT_TIMEOUT}

Enter Cell Number
    [Arguments]    ${cell_number}
    ${elements}=    Get Page Elements
    Browser.Wait For Elements State
    ...    ${elements['cell_number']}
    ...    visible
    ...    timeout=${DEFAULT_ELEMENT_TIMEOUT}
    Browser.Fill Text    ${elements['cell_number']}    ${cell_number}

Click Purchase Internet Button
    ${elements}=    Get Page Elements
    Browser.Wait For Elements State
    ...    ${elements['purchase_btn']}
    ...    visible
    ...    timeout=${DEFAULT_ELEMENT_TIMEOUT}
    Browser.Click    ${elements['purchase_btn']}

Select The Type Of Sim Card
    [Documentation]    Selects SIM type from bottom sheet picker.
    ...    Inputs: ${sim_type} (PREPAID, POSTPAID, TD_LTE, DATA)
    [Arguments]    ${sim_type}
    ${elements}=    Get Page Elements
    
    ${sim_picker_exists}=    Run Keyword And Return Status
    ...    Browser.Wait For Elements State
    ...    ${elements['sim_type_picker']}
    ...    visible
    ...    timeout=${DEFAULT_ELEMENT_TIMEOUT}
    
    IF    ${sim_picker_exists}
        IF    '${sim_type}' == '${PREPAID}'
            Browser.Click    ${elements['prepaid']}
        ELSE IF    '${sim_type}' == '${POSTPAID}'
            Browser.Click    ${elements['postpaid']}
        ELSE IF    '${sim_type}' == '${TD_LTE}'
            Browser.Click    ${elements['td_lte']}
        ELSE IF    '${sim_type}' == '${DATA}'
            Browser.Click    ${elements['data']}
        END
    END

Verify Error Message
    [Arguments]    ${expected_message}=${NONE}
    ${elements}=    Get Page Elements
    Browser.Wait For Elements State
    ...    ${elements['error_message']}
    ...    visible
    ...    timeout=${DEFAULT_ELEMENT_TIMEOUT}
    IF    ${expected_message} != ${NONE}
        ${actual_message}=    Get Text    ${elements['error_message']}
        Should Be Equal    ${actual_message}    ${expected_message}
    END

Select The Frequent Option
    [Documentation]    Selects first recommended top-up option.
    ...    Inputs: ${amount}, ${charge_type}
    ...    Outputs: &{top_up_obj} (dictionary with cell_number, amount, charge_type)
    ...    Preconditions: User has saved cell numbers and recommendations are visible.
    ...    Side effects: Clicks first recommendation and sets amount.
    ${elements}=    Get Page Elements
    ${has_recommendation}=    Run Keyword And Return Status
    ...    Browser.Wait For Elements State
    ...    ${elements['my_cell_numbers']}
    ...    visible
    ...    timeout=${DEFAULT_ELEMENT_TIMEOUT}
    IF    ${has_recommendation}
        Browser.Click    ${elements['first_recommendation']}
    END
    ${cell_number}=    Browser.Get Text    ${elements['recom_cell_number']}
    RETURN    ${cell_number}