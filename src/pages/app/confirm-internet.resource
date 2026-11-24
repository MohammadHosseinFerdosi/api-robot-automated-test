***** Settings *****
Library     Browser
Library     String

***** Keywords *****
Get Page URL
    RETURN    ${CONFIRM_PAGE_PATH}

Get Page Elements
    &{elements}    Create Dictionary
    ...    page_title=//p[contains(@class,'st-8')]
    ...    card=//payment-checkout-payment-detail-card
    ...    payment_detail_container=//div[contains(@class,'payment-detail-container')]
    ...    continue_btn=//button[contains(normalize-space(.), 'پرداخت')]
    ...    back_btn=//button[contains(@class,'back-btn')]
    ...    cell_number_label=//*[contains(text(),'شماره همراه')]
    ...    cell_number=//*[contains(text(),'شماره همراه')]/following-sibling::p[1]
    ...    package_desc_label=//*[contains(text(),'جزییات بسته')]
    ...    package_description=//div[contains(text(),'جزییات بسته')]/following-sibling::p[1]
    ...    operator_label=//*[contains(text(),'اپراتور')]
    ...    operator=//*[contains(text(),'اپراتور')]/following-sibling::p[1]
    ...    method_gateway=//div[contains(@class,'title') and contains(., 'درگاه پرداخت اینترنتی')]
    ...    gateway_option=//div[contains(@class,'gateway-option')]
    ...    error_message=//span[contains(@class,'text-onback-high')]
    RETURN    ${elements}

Should Be On Confirm Page
    [Documentation]    Verifies user is on payment confirmation page.
    ${expected_path}    Get Page URL
    Wait Until Keyword Succeeds    20x    1s
    ...    Confirm URL Should Contain    ${expected_path}
    
    ${elements}    Get Page Elements
    Wait For Elements State    ${elements['card']}           visible    ${DEFAULT_ELEMENT_TIMEOUT}
    Wait For Elements State    ${elements['continue_btn']}   visible    ${DEFAULT_ELEMENT_TIMEOUT}

Confirm URL Should Contain
    [Arguments]    ${expected}
    ${current}    Get Url
    Should Contain    ${current}    ${expected}

Select Gateway Payment Method
    [Documentation]    Selects the payment gateway method.
    ${elements}    Get Page Elements
    Wait For Elements State    ${elements['method_gateway']}    visible    ${DEFAULT_ELEMENT_TIMEOUT}
    Click    ${elements['method_gateway']}

Confirm The Service Payment
    [Documentation]    Completes the payment by selecting gateway and clicking continue.
    ${elements}    Get Page Elements
        Wait For Elements State    ${elements['method_gateway']}    visible    ${DEFAULT_ELEMENT_TIMEOUT}
    Click    ${elements['method_gateway']}
        Wait For Elements State    ${elements['continue_btn']}    enabled    ${DEFAULT_ELEMENT_TIMEOUT}
    Click    ${elements['continue_btn']}

Return Internet Package Object
    [Documentation]    Returns internet package details from confirmation page.
    ...    Outputs: &{confirm_package_obj}
    ${elements}    Get Page Elements
        ${cell_number}    Browser.Get Text    ${elements['cell_number']}
    ${cell_number}    Evaluate    ''.join(ch for ch in """${cell_number}""" if ch.isdigit())
    ${package_desc}    Set Variable    ${EMPTY}
    ${has_desc}=    Run Keyword And Return Status
    ...    Browser.Get Text    ${elements['package_description']}
    IF    ${has_desc}
        ${package_desc}    Browser.Get Text    ${elements['package_description']}
    END
    &{confirm_package_obj}    Create Dictionary
    ...    cell_number=${cell_number}
    ...    description=${package_desc}
    RETURN    ${confirm_package_obj}

Validate Internet Package Details
    [Documentation]    Validates internet package details on confirmation page.
    ...    Inputs: ${expected_cell_number}, ${expected_amount}
    [Arguments]    ${expected_cell_number}    ${expected_amount}
    ${confirm_package_obj}=    Return Internet Package Object
    Should Be Equal    ${expected_cell_number}    ${confirm_package_obj['cell_number']}
    
Verify Error Message
    [Documentation]    Verifies error message is displayed.
    [Arguments]    ${expected_message}=${NONE}
    ${elements}    Get Page Elements
    Wait For Elements State    ${elements['error_message']}    visible    ${DEFAULT_ELEMENT_TIMEOUT}
    IF    ${expected_message} != ${NONE}
        ${actual_message}=    Get Text    ${elements['error_message']}
        Should Be Equal    ${actual_message}    ${expected_message}
    END