*** Settings ***
Resource    parent.resource


*** Keywords ***
Get Page URL
    RETURN    /wallet-management

Get Page Elements
    &{elements}    Create Dictionary
    ...    add_gift_card=//button[contains(text(),'افزودن کارت هدیه')]
    ...    total_balance=//div[@class='amount']
    ...    back_button=//div[@class='page-layout-header-action-icon']
    RETURN    ${elements}

Should Be In Wallet Management Page
    ${expected_path}    Get Page URL
    Wait Until Location Contains    ${expected_path}
    ${elements}    Get Page Elements
    Element Should Be Visible    ${elements['total_balance']}

Total Balance Should Be
    [Arguments]    ${expected_total_balance}
    ${elements}    Get Page Elements
    ${actual_total_balance}    Get Text    ${elements['total_balance']}
    Should Be Equal As Strings    ${actual_total_balance}    ${expected_total_balance}

Click On Back Button
    ${elements}    Get Page Elements
    Wait Until Element Is Visible    ${elements['back_button']}
    Click Element     ${elements['back_button']}
