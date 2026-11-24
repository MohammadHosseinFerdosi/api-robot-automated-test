*** Settings ***
Resource    parent.resource


*** Keywords ***
Get Page URL
    RETURN    /service/credit/overview

Get Page Elements
    &{elements}    Create Dictionary
    ...    loans_lable=//span[contains(@class, 'main-title') and contains(text(), 'وام‌ها')]
    ...    back_button=//div[@class='page-layout-header-action-icon']
    RETURN    ${elements}

Should Be In Credit Card's Managment Page
    ${expected_path}    Get Page URL
    Wait Until Location Contains    ${expected_path}
    ${elements}    Get Page Elements
    Element Should Be Visible    ${elements['loans_lable']}

Click On Back Button
    ${elements}   Get Page Elements
    Wait Until Element Is Visible    ${elements['back_button']}
    Click Element     ${elements['back_button']}
