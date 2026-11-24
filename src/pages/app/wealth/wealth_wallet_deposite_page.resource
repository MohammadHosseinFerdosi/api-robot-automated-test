*** Settings ***
Resource    ../parent.resource


*** Keywords ***
Get Page URL
    RETURN    /mini-app/wealth/wallets/treasury?referrer=wealth

Get Page Elements
    &{elements}    Create Dictionary
    ...    wealth_wallet_balance_txt=//*[contains(concat( " ", @class, " " ), concat( " ", "t-4", " " ))]
    ...    swap_btn=//button[contains(text(),'تبدیل دارایی ')]
    ...    deposite_btn=//*[(@id = "WALLET_BTN_DEPOSIT")]
    ...    back_btn=//*[contains(concat( " ", @class, " " ), concat( " ", "style-neutral-link", " " ))]
    ...    withdraw_btn=//*[(@id = "WALLET_BTN_WITHDRAW")]
    ...    bnpl_request_btn=//*[(@id = "WALLET_BTN_BNPL_REQUEST")]
    ...    transaction_btn=//*[(@id = "WALLET_BTN_TRANSACTIONS")]
    ...    d=//div[@class='page-layout-header-action-icon']
    RETURN    ${elements}

Should Be In wealth wallet page
    ${expected_path}    Get Page URL
    Wait Until Location Contains    ${expected_path}
    ${elements}    Get Page Elements
    Element Should Be Visible    ${elements['deposite_btn']}

Total Balance Should Be
    [Arguments]    ${expected_total_balance}
    ${elements}    Get Page Elements
    ${actual_total_balance}    Get Text    ${elements['wealth_wallet_balance_txt']}
    Should Be Equal As Strings    ${actual_total_balance}    ${expected_total_balance}

Click On Back Button
    ${elements}    Get Page Elements
    Wait Until Element Is Visible    ${elements['back_btn']}
    Click Element     ${elements['back_btn']}
