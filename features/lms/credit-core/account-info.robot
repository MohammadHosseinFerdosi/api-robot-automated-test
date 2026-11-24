*** Settings ***
Resource            steps/LMS/credit-core/account-info.resource

Test Setup          Initialize Merchant
Test Teardown       Reproduce Amount


*** Test Cases ***
[TC-001] Call Account Info For 1Pay, XPay BNPL With Channel UPG , RepaymentOption 1Pay, XPay
    Given The User Has 1pay And 4pay Accounts
    And The Channel Set To UPG
    And The Type Set To BNPL
    And The Gateway Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And The Amount Is Set To Little Than Credit Balance
    When Get Account Info    ${cell_number}
    Then The Response Should Contain 1pay & 4pay Account And State Is Active
    And The Gateway Is Disabled

[TC-002] Call Account Info for 1Pay BNPL With Channel UPG, RepaymentOption 1Pay
    Given The User Has 1pay Account
    And The Channel Set To UPG
    And The Type Set To BNPL
    And The Gateway Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay
    And The Amount Is Set To Little Than Credit Balance
    When Get Account Info    ${cell_number}
    Then The Response Should Contain Only 1pay Or Xpay Or Credit Accounts
    And The Gateway Is Disabled

[TC-003] Call Account Info For XPay BNPL With Channel UPG, RepaymentOption XPay
    Given The User Has 4pay Account
    And The Channel Set To UPG
    And The Type Set To BNPL
    And The Gateway Set To BPG
    And The Gateway RepaymentOption Is Set To Xpay
    And The Amount Is Set To Little Than Credit Balance
    When Get Account Info    ${cell_number}
    Then The Response Should Contain Only 1pay Or Xpay Or Credit Accounts
    And The Gateway Is Disabled

[TC-004] Call Account Info For XPay BNPL With Channel UPG, RepaymentOption 1Pay
    Given The User Has 4pay Account
    And The Channel Set To UPG
    And The Type Set To BNPL
    And The Gateway Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay
    And The Amount Is Set To Little Than Credit Balance
    When Get Account Info    ${cell_number}
    Then The Response Should Contain The Accounts doesn't Exist
    And The Gateway Is Disabled

[TC-005] Account Info When Xpay Blocked Account And Channel Is UPG
    Given The User Has 1pay And 4pay Accounts
    And The Channel Set To UPG
    And The Type Set To BNPL
    And The Gateway Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And The Amount Is Set To Little Than Credit Balance
    And Account Blocked    credit_id=${credit_ids}[1]
    When Get Account Info    ${cell_number}
    Then The Response Contain One Of BNPL Inactive
    And The Gateway Is Disabled

[TC-006] Account Info When 1pay Blocked Account And Channel Is UPG
    Given The User Has 1pay And 4pay Accounts
    And The Channel Set To UPG
    And The Type Set To BNPL
    And The Gateway Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And The Amount Is Set To Little Than Credit Balance
    And Account Blocked    credit_id=${credit_ids}[0]
    When Get Account Info    ${cell_number}
    Then The Response Contain One Of BNPL Inactive
    And The Gateway Is Disabled

[TC-007] Account Info When Xpay Account And Channel Is UPG
    Given The User Has 4pay Account
    And The Channel Set To UPG
    And The Type Set To BNPL
    And The Gateway Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And The Amount Is Set To Greater Than Credit Balance
    When Get Account Info    ${cell_number}
    Then The Response Should Contain Only 1pay Or Xpay Or Credit Accounts
    And The Gateway Is Disabled

[TC-008] Call Account Info For 1Pay Zero Balance, XPay BNPL With Channel UPG , RepaymentOption 1Pay, XPay
    Given The User Has 1pay And 4pay Accounts
    And The Channel Set To UPG
    And The Type Set To BNPL
    And The Gateway Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And The Amount Is Set To Equal To Credit Balance
    And Empty Balance    credit_id=${credit_ids}[0]
    When Get Account Info    ${cell_number}
    Then The Response Should Contain All Accounts
    And The Gateway Is Disabled

[TC-009] Call Account Info For Credit , XPay BNPL Zero Balance With Channel UPG , RepaymentOption 1Pay, XPay
    Given The User Has 4pay And Credit Accounts
    And The Channel Set To UPG
    And The Type Set To BNPL
    And The Gateway Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And The Amount Is Set To Equal To Credit Balance
    And Empty Balance    ${credit_ids}[0]
    When Get Account Info    ${cell_number}
    Then The Response Should Contain Account And State Is Inactive
    And The Gateway Is Disabled

[TC-010] Account Info For Expired Account
    Given The User Has 1pay Account
    And The Channel Set To UPG
    And The Type Set To BNPL
    And The Gateway Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And Empty Balance    credit_id=${credit_ids}[0]
    And Expire Account    credit_id=${credit_ids}[0]
    When Get Account Info    ${cell_number}
    Then The Response Should Contain Account And State Is Inactive
    And The Gateway Is Disabled

[TC-011] Check the Account Info For BNPL Gateway Doesn't Exist
    Given The User Has 1pay And 4pay Accounts
    And The Channel Set To UPG
    And The Type Set To BNPL
    And The Gateway Set To BPG
    And The Gateway Is Disabled
    When Get Account Info    ${cell_number}
    Then The Response Should Contain The Gateway doesn't Exist

[TC-012] Account Info For User With 1pay And 4pay Account And RepaymentOption Is 1pay And Channel Is UPG
    Given The User Has 1pay And 4pay Accounts
    And The Channel Set To UPG
    And The Type Set To BNPL
    And The Gateway Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay
    When Get Account Info    ${cell_number}
    Then The Response Should Contain Only 1pay Or Xpay Or Credit Accounts
    And The Gateway Is Disabled

[TC-013] Account Info For User With 1pay And 4pay Account And RepaymentOption Is 4pay And Channel Is UPG
    Given The User Has 1pay And 4pay Accounts
    And The Channel Set To UPG
    And The Type Set To BNPL
    And The Gateway Set To BPG
    And The Gateway RepaymentOption Is Set To Xpay
    When Get Account Info    ${cell_number}
    Then The Response Should Contain Only 1pay Or Xpay Or Credit Accounts
    And The Gateway Is Disabled

[TC-014] Account Info For User With 1pay Account And RepaymentOption Is 4pay And Channel Is UPG
    Given The User Has 1pay Account
    And The Channel Set To UPG
    And The Type Set To BNPL
    And The Gateway Set To BPG
    And The Gateway RepaymentOption Is Set To Xpay
    When Get Account Info    ${cell_number}
    Then The Response Should Contain The Accounts doesn't Exist
    And The Gateway Is Disabled

[TC-015] Account Info For Disable CPG Gateway
    Given The User Has 4pay And Credit Accounts
    And The Channel Set To UPG
    And The Type Set To Credit
    And The Gateway Set To CPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And The Gateway Is Disabled
    When Get Account Info    ${cell_number}
    Then The Response Should Contain The Gateway doesn't Exist

[TC-016] Account Info For the Users Didn't Have Credit Account
    Given The User Has 4pay Account
    And The Channel Set To UPG
    And The Type Set To Credit
    And The Gateway Set To CPG
    And The Gateway RepaymentOption Is Set To Xpay
    When Get Account Info    ${cell_number}
    Then The Response Should Contain The Accounts doesn't Exist
    And The Gateway Is Disabled

[TC-017] Account Info for Installment Sale with RepaymentOption Xpay
    Given The User Has Installment Account
    And The Channel Set To UPG
    and The Type Set To Installment Sale
    and The Gateway Set To ISPG
    And The Gateway RepaymentOption Is Set To Xpay
    When Get Account Info    ${cell_number}
    Then The Response Should Contain Only 1pay Or Xpay Or Credit Accounts
    And The Gateway Is Disabled

[TC-018] Account Info for Blocked Installment Sale Account
    Given The User Has Installment Account
    And The Channel Set To UPG
    and The Type Set To Installment Sale
    and The Gateway Set To ISPG
    And The Gateway RepaymentOption Is Set To Xpay
    And Empty Balance    credit_id=${credit_ids}[0]
    And Expire Account    credit_id=${credit_ids}[0]
    When Get Account Info    ${cell_number}
    Then The Response Should Contain Account And State Is Inactive
    And The Gateway Is Disabled

[TC-019] Account Info for Blocked ISPG Gateway
    Given The User Has Installment Account
    And The Channel Set To UPG
    and The Type Set To Installment Sale
    and The Gateway Set To ISPG
    And The Gateway RepaymentOption Is Set To Xpay
    And The Gateway Is Disabled
    When Get Account Info    ${cell_number}
    Then The Response Should Contain The Gateway doesn't Exist

[TC-020] Account Info For User With Credit Card Account And RepaymentOption Is 4pay And Channel Is Barcode
    Given The User Has 4pay And Credit Accounts
    And The Channel Set To UPG
    And The Type Set To Credit Card
    And The Gateway Set To CAPG
    And The Gateway RepaymentOption Is Set To Xpay
    When Get Account Info    ${cell_number}
    Then The Response Should Contain Only 1pay Or Xpay Or Credit Accounts
    And The Gateway Is Disabled

[TC-021] Account Info For User With Schedule Close Credit Account And RepaymentOption Is 4pay And Channel Is UPG
    Given The User Has 1pay Account
    And The Channel Set To UPG
    And The Type Set To BNPL
    And The Gateway Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay
    And Call Schedule Close API
    When Get Account Info    ${cell_number}
    Then The Response Should Contain Account And State Is Inactive
    And The Gateway Is Disabled

[TC-022] Account Info For Disable CAPG Gateway
    Given The User Has 4pay And Credit Accounts
    And The Channel Set To UPG
    And The Type Set To Credit Card
    And The Gateway Set To CAPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And The Gateway Is Disabled
    When Get Account Info    ${cell_number}
    Then The Response Should Contain The Gateway doesn't Exist
