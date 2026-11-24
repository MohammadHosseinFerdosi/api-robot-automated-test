*** Settings ***
Resource    parent.resource


*** Keywords ***
Get Page URL
    RETURN    /service/bnpl/overview

Get Page Elements
    &{elements}    Create Dictionary
    ...    loans_lable=//span[contains(@class, 'main-title') and contains(text(), 'خرید اعتباری')]
    ...    back_button=//div[@class='page-layout-header-action-icon']
    RETURN    ${elements}

Should Be In Bnpl's Overview's Page
    ${expected_path}    Get Page URL
    Wait Until Location Contains    ${expected_path}
    ${elements}    Get Page Elements
    Element Should Be Visible    ${elements['loans_lable']}
