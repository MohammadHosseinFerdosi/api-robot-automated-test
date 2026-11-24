*** Settings ***
Resource    parent.resource


*** Keywords ***
Get Page URL
    RETURN    /cash-in

Get Page Elements
    &{elements}    Create Dictionary
    ...    total_balance=//span[@class='amount-value']
    ...    back_button=//div[@class='page-layout-header-action-icon']
    RETURN    ${elements}

Should Be In Cash-in Page
    ${expected_path}    Get Page URL
    Wait Until Location Contains    ${expected_path}
    ${elements}    Get Page Elements
    Element Should Be Visible    ${elements['total_balance']}

Click On Back Button
    ${elements}    Get Page Elements
    Wait Until Element Is Visible    ${elements['back_button']}
    Click Element     ${elements['back_button']}