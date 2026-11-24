*** Settings ***
Resource    parent.resource


*** Keywords ***
Get Page URL
    RETURN    /cash-out/transfer

Get Page Elements
    &{elements}    Create Dictionary
    ...    Cash-outable_balance=//span[@class='amount-value']
    ...    back_button=//div[@class='page-layout-header-action-icon']
    RETURN    ${elements}

Should Be In Cash-out Page
    ${expected_path}    Get Page URL
    Wait Until Location Contains    ${expected_path}
    ${elements}    Get Page Elements
    Element Should Be Visible    ${elements['Cash-outable_balance']}


Click On Back Button
    ${elements}    Get Page Elements
    Wait Until Element Is Visible    ${elements['back_button']}
    Click Element     ${elements['back_button']}
