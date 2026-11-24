*** Settings ***
Resource            services/frontend/playwright/browser-service.resource
Resource            steps/wealth/wealth_wallet/wealth_wallet_deposit.resource
Resource            pages/app/wealth/wealth_wallet_deposite_page.resource

Suite Setup         Open Site
Suite Teardown      Close Browser

*** Test Cases ***


[TC-001-FX-In_range-Deposite]
    [Template]    Deposit Should Work For In Range Number
    fx    valid_amount_in_middle
    fx    valid_amount_in_minimum_range
    fx    valid_amount_in_maximum_range

[TC-001-GOLD-In_range-Deposite]
    [Template]    Deposit Should Work For In Range Number
    gold    valid_amount_in_middle
    gold    valid_amount_in_minimum_range
    gold    valid_amount_in_maximum_range 

[TC-002-FX-Out_of_range-Deposite]  
    [Template]    Deposit and Withdraw Shouldnt Work For Out Of Range Number
    fx    over_maximum    ${above_maximum_err_text}
    fx    bellow_minimum    ${bellow_minimum_err_text}

[TC-002-GOLD-Out_of_range-Deposite]  
    [Template]    Deposit and Withdraw Shouldnt Work For Out Of Range Number
    gold    bellow_minimum    ${bellow_minimum_err_text}  


[TC-002-FX-In_range-Withdraw] 
    [Template]    Withdraw Should Work For In Range Number
    fx    valid_amount_in_middle
    fx    valid_amount_in_minimum_range
[TC-002-GOLD-In_range-Withdraw] 
    [Template]    Withdraw Should Work For In Range Number
    gold    valid_amount_in_middle
    gold    valid_amount_in_minimum_range



