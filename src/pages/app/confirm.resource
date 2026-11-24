*** Settings ***
Library     Browser
*** Keywords ***
Get Page URL
    RETURN    ${CONFIRM_PAGE_PATH}

Get Page Elements
    &{elements}    Create Dictionary
    ...    continue_btn=xpath=//button[contains(normalize-space(.), 'پرداخت')]
    ...    card=xpath=//payment-checkout-payment-detail-card//div[contains(@class,'payment-detail-container')]
    ...    title=xpath=//payment-checkout-payment-detail-card//p[contains(@class,'st-8')]
    ...    amount=xpath=//*[contains(text(),'مبلغ شارژ')]/following-sibling::p[1]
    ...    charge_type=xpath=//*[contains(text(),'نوع شارژ')]/following-sibling::p[1]
    ...    cell_number=xpath=//*[contains(text(),'شماره همراه')]/following-sibling::p[1]
    ...    method_gateway=xpath=//div[contains(@class,'title') and contains(., 'درگاه پرداخت اینترنتی')]
    RETURN    ${elements}

Should Be On Confirm Page
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
    ${elements}    Get Page Elements
    Wait For Elements State    ${elements['method_gateway']}    visible    ${DEFAULT_ELEMENT_TIMEOUT}
    Click    ${elements['method_gateway']}

Confirm The Service Payment
    ${elements}    Get Page Elements
    Wait For Elements State    ${elements['method_gateway']}    visible    ${DEFAULT_ELEMENT_TIMEOUT}
    Click    ${elements['method_gateway']}
    Wait For Elements State    ${elements['continue_btn']}    enabled    ${DEFAULT_ELEMENT_TIMEOUT}
    Click    ${elements['continue_btn']}

Return Top-Up Object
    ${elements}    Get Page Elements
    ${cell_number}    Browser.Get Text    ${elements['cell_number']}
    ${cell_number}    Evaluate    ''.join(ch for ch in """${cell_number}""" if ch.isdigit())
    ${amount}         Browser.Get Text    ${elements['amount']}
    ${amount}         Evaluate    '${amount}'.split(" ریال")[0]
    ${amount}         Evaluate    ''.join(ch for ch in """${amount}""" if ch.isdigit())
    ${charge_type}    Browser.Get Text    ${elements['charge_type']}
    &{confirm_top_up_obj}    Create Dictionary
    ...    cell_number=${cell_number}
    ...    amount=${amount}
    ...    charge_type=${charge_type}
    RETURN    ${confirm_top_up_obj}
