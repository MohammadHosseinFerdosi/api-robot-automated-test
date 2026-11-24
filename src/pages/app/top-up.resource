*** Settings ***
Library    Browser

*** Keywords ***
Get Page URL
    [Documentation]    Returns the URL path for the top-up page.
    ...    Outputs: ${TOP_UP_PAGE_PATH}
    RETURN    ${TOP_UP_PAGE_PATH}

Get Page Elements
    [Documentation]    Creates a dictionary of element locators for the top-up page.
    ...    Inputs: None
    ...    Outputs: &{elements} (dictionary with keys: Top_Up_Lable, cell_number, etc.)
    &{elements}=    Create Dictionary
    ...    Top_Up_Lable=//*[contains(text(),'خرید شارژ سریع')]
    ...    cell_number=//input[@type='tel']
    ...    purchase_btn=//button[*[text()=" خرید شارژ "]]
    ...    sim_type_picker=//common-cellular-operator-sim-type-picker
    ...    postpaid=//*[contains(text(),'دائمی')]
    ...    prepaid=//*[contains(text(),'اعتباری')]
    ...    amount_picker=//top-up-applet-top-up-type-picker
    ...    amount_input=//app-dg-amount//input
    ...    amount_recomendation=//div[contains(@class, 'amounts')]//div[contains(@class, 'amount')][1]
    ...    continue_btn=//button[*[contains(text(),'ادامه')]]
    ...    my_cell_numbers=//*[contains(text(),'شماره‌های من')]
    ...    first_recommendation=(//daily-fintech-recommendation-item)[2]
    ...    wow_radio_btn=//*[contains(@id,'dg-slide-toggle')]
    ...    on_wow_btn=//div[contains(@class, 'amount') and contains(@class, 'text-onback-brand')]
    ...    wow_charge_amount=//div[contains(@class, 'amounts')]//div[contains(@class, 'amount')][2]
    ...    recom_cell_number=//daily-fintech-recommendation-item[2]//span[contains(@class, 'text-onback-low') and contains(@class, 'l-3')]
    ...    popup_close_btn=//ngx-notice//button[.//div[contains(normalize-space(.),'بستن')]]
    ...    popup_overlay=//ngx-notice//div[contains(@class,'overlay')]
    ...    error_message=//span[contains(@class, 'b-2') and contains(@class, 'text-onback-high')]
    RETURN    ${elements}

Should Be On Top Up Page
    [Documentation]    Verifies user is on top-up page by checking for top-up label.
    ...    Preconditions: Browser is open and navigated to top-up page.
    ...    Side effects: Fails if label not visible within timeout.
    ${elements}=    Get Page Elements
    Browser.Wait For Elements State
    ...    ${elements['Top_Up_Lable']}
    ...    visible
    ...    timeout=${DEFAULT_ELEMENT_TIMEOUT}

Enter Cell Number
    [Documentation]    Enters mobile number into cell number input field.
    ...    Inputs: ${cell_number} (string, e.g., "09123456789")
    ...    Preconditions: User is on top-up page and cell number field is visible.
    ...    Side effects: Fills cell number input field.
    [Arguments]    ${cell_number}
    ${elements}=    Get Page Elements
    Browser.Wait For Elements State
    ...    ${elements['cell_number']}
    ...    visible
    ...    timeout=${DEFAULT_ELEMENT_TIMEOUT}
    Browser.Fill Text    ${elements['cell_number']}    ${cell_number}

Select The Type Of Sim Card
    [Documentation]    Selects SIM type (prepaid/postpaid) from picker.
    ...    Inputs: ${sim_type} (string, ${PREPAID} or ${POSTPAID})
    ...    Preconditions: SIM type picker is visible.
    ...    Side effects: Clicks selected SIM type option.
    [Arguments]    ${sim_type}
    ${elements}=    Get Page Elements
    ${sim_picker_exists}=    Run Keyword And Return Status
    ...    Browser.Wait For Elements State
    ...    ${elements['sim_type_picker']}
    ...    visible
    ...    timeout=${DEFAULT_ELEMENT_TIMEOUT}
    IF    ${sim_picker_exists}
        IF    '${sim_type}'=='${PREPAID}'
            Browser.Click    ${elements['prepaid']}
        ELSE IF    '${sim_type}'=='${POSTPAID}'
            Browser.Click    ${elements['postpaid']}
        END
    END

Select The Charge Amount
    [Documentation]    Selects charge amount via input or predefined options.
    ...    This keyword supports two modes:
    ...    - Auto Mode: If ${amount} is None or empty, reads the recommended amount from the page
    ...    - Manual Mode: If ${amount} is provided, enters the amount into the input field  
    ...    Inputs: ${amount} (string, optional - e.g., "10000" or None)
    ...    Outputs: ${amount} (cleaned numeric string containing only digits)
    ...    Preconditions: Top-up amount section is visible.
    [Arguments]    ${amount}=None
    ${elements}=    Get Page Elements
    ${has_picker}=    Run Keyword And Return Status
    ...    Browser.Wait For Elements State
    ...    ${elements['amount_picker']}
    ...    visible
    ...    timeout=${DEFAULT_ELEMENT_TIMEOUT}
    IF    not ${has_picker}
        Fail    Top-up amount section did not appear within 5s.
    END
    IF    '${amount}' == 'None' or '${amount}' == ''
        Browser.Click    ${elements['amount_recomendation']}  
        ${amount_text}=    Browser.Get Text    ${elements['amount_recomendation']}
        ${amount}=    Evaluate    ''.join(ch for ch in """${amount_text}""" if ch.isdigit())
    ELSE
        ${has_input}=    Run Keyword And Return Status
        ...    Browser.Wait For Elements State
        ...    ${elements['amount_input']}
        ...    visible
        ...    timeout=${DEFAULT_ELEMENT_TIMEOUT}
        IF    ${has_input}
            Browser.Click    ${elements['amount_input']}
            Browser.Fill Text    ${elements['amount_input']}    ${amount}
        ELSE
            Browser.Click    ${elements['wow_charge_amount']}
        END
        ${amount}=    Evaluate    ''.join(ch for ch in """${amount}""" if ch.isdigit())
    END
    RETURN    ${amount}

Click Continue BTN
    [Documentation]    Clicks 'Continue' button to proceed to payment.
    ...    Preconditions: Continue button is enabled.
    ...    Side effects: Navigates to payment confirmation page.
    ${elements}=    Get Page Elements
    Browser.Wait For Elements State
    ...    ${elements['continue_btn']}
    ...    enabled
    ...    timeout=${DEFAULT_ELEMENT_TIMEOUT}
    Browser.Click    ${elements['continue_btn']}

Select The Frequent Optin
    [Documentation]    Selects first recommended top-up option.
    ...    Inputs: ${amount}, ${charge_type}
    ...    Outputs: &{top_up_obj} (dictionary with cell_number, amount, charge_type)
    ...    Preconditions: User has saved cell numbers and recommendations are visible.
    ...    Side effects: Clicks first recommendation and sets amount.
    [Arguments]    ${amount}    ${charge_type}
    ${elements}=    Get Page Elements
    ${has_recommendation}=    Run Keyword And Return Status
    ...    Browser.Wait For Elements State
    ...    ${elements['my_cell_numbers']}
    ...    visible
    ...    timeout=${DEFAULT_ELEMENT_TIMEOUT}
    IF    ${has_recommendation}
        Browser.Click    ${elements['first_recommendation']}
        ${amount}=    Select The Charge Amount    ${amount}
    END
    ${cell_number}=    Browser.Get Text    ${elements['recom_cell_number']}
    &{top_up_obj}=    Create Dictionary
    ...    cell_number=${cell_number}
    ...    amount=${amount}
    ...    charge_type=${charge_type}
    RETURN    ${top_up_obj}

Select WOW Top-up
    [Documentation]    Toggles WOW top-up option if enabled.
    ...    Inputs: ${charge_type} (string, e.g., ${WOW_CHARGE})
    ...    Preconditions: WOW radio button is visible.
    ...    Side effects: Clicks WOW radio button if charge_type matches.
    [Arguments]    ${charge_type}
    IF    '${charge_type}'=='${WOW_CHARGE}'
        ${elements}=    Get Page Elements
        Browser.Click    ${elements['wow_radio_btn']}
        Browser.Wait For Elements State
        ...    ${elements['on_wow_btn']}
        ...    visible
        ...    timeout=${DEFAULT_ELEMENT_TIMEOUT}
    END

Verify Error Message
    [Documentation]    Verifies error message content.
    ...    Inputs: ${expected_message} (optional, default empty)
    ...    Preconditions: Error message element is visible.
    ...    Side effects: Fails if actual message doesn't match expected.
    [Arguments]    ${expected_message}=None
    ${elements}=    Get Page Elements
    Browser.Wait For Elements State
    ...    ${elements['error_message']}
    ...    visible
    ...    timeout=${DEFAULT_ELEMENT_TIMEOUT}
    ${actual_message}=    Get Text    ${elements['error_message']}
    IF    '${expected_message}' != ''
        Should Be Equal    ${actual_message}    ${expected_message}
    END