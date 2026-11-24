*** Settings ***
Resource            steps/LMS/credit-core/refund-step.resource

Test Setup          Initialize Merchants
Test Teardown       Reproduce Amount


*** Test Cases ***
[TC-001] Partial Refund On No Fee BNPL Account On Channel UPG
    Given Allocate No Fee BNPL Account
    And The Payment Gateway Is Set To BPG
    And Set Channel To UPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And Set Settlement Method To BNPL 1pay
    When A Full Purchase    amount=3000    type=13
    And Perform A Partial Refund    amount=2000    type=13
    Then Refund Type Must Include Credit
    And Refund Pay Gateway Must Include BPG
    And Check Refund Settlement Method Must Include BNPL 1PAY Method
    And Check Refund Type        partial_refund_flag=${True}
    And Check SMS For Refund To Credit
    And Assert Refund Data In Credit Management, Credit Merchant Management And Report Management Is Correct        partial_refund_flag=${True}
    And The Gateway Is Disabled

[TC-002] Partial Refund On No Fee CCREDIT Account On Channel UPG
    Given Allocate No Fee CCredit Account
    And The Payment Gateway Is Set To CPG
    And Set Channel To UPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And Set Settlement Method To CCREDIT
    When A Full Purchase    amount=3000    type=5
    And Perform A Partial Refund    amount=2000    type=5
    Then Refund Type Must Include Credit
    And Refund Pay Gateway Must Include CPG
    And Check Refund Settlement Method Must Include CCREDIT Method
    And Check Refund Type    partial_refund_flag=${True}
    And Check SMS For Refund To Credit
    And Assert Refund Data In Credit Management, Credit Merchant Management And Report Management Is Correct    partial_refund_flag=${True}
    And The Gateway Is Disabled

[TC-003] Full Refund On No Fee BNPL Account On Channel UPG
    Given Allocate No Fee BNPL Account
    And The Payment Gateway Is Set To BPG
    And Set Channel To UPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And Set Settlement Method To BNPL 1pay
    When A Full Purchase    amount=3000    type=13
    And Perform A Full Refund    type=13
    Then Refund Type Must Include Credit
    And Refund Pay Gateway Must Include BPG
    And Check Refund Settlement Method Must Include BNPL 1PAY Method
    And Check Refund Type
    And Check SMS For Refund To Credit
    And Assert Refund Data In Credit Management, Credit Merchant Management And Report Management Is Correct
    And The Gateway Is Disabled

[TC-004] Full Refund On No Fee CCREDIT Account On Channel UPG
    Given Allocate No Fee CCredit Account
    And The Payment Gateway Is Set To CPG
    And Set Channel To UPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And Set Settlement Method To CCREDIT
    When A Full Purchase    amount=3000    type=5
    And Perform A Full Refund    type=5
    Then Refund Type Must Include Credit
    And Refund Pay Gateway Must Include CPG
    And Check Refund Settlement Method Must Include CCREDIT Method
    And Check Refund Type
    And Check SMS For Refund To Credit
    And Assert Refund Data In Credit Management, Credit Merchant Management And Report Management Is Correct
    And The Gateway Is Disabled

[TC-005] Full Refund On No Fee Installment Sale Account On Channel UPG
    Given Allocate No Fee Installment Sale Account
    And The Payment Gateway Is Set To ISPG
    And Set Channel To UPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And Set Settlement Method To CREDITCHECK
    When A Full Purchase    amount=3000    type=26
    And Perform A Full Refund    type=26
    Then Refund Type Must Include Credit
    And Refund Pay Gateway Must Include ISPG
    And Check Refund Settlement Method Must Include CREDITCHECK Method
    And Check Refund Type
    And Check SMS For Refund To Credit
    And Assert Refund Data In Credit Management, Credit Merchant Management And Report Management Is Correct
    And The Gateway Is Disabled

[TC-006] Make A Refund after Closing Billing Cycle On Channel UPG
    Given Allocate No Fee BNPL Account
    And The Payment Gateway Is Set To BPG
    And Set Channel To UPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And Set Settlement Method To BNPL 1pay
    When A Full Purchase    amount=3000    type=13
    And Close billing cycle    credit_id=${credit_ids}[0]
    And Perform A Full Refund    type=13
    And Refund API Should Be Successful
    And Check Refund Type    billing_cycle_closed=True
    And Check SMS For Refund To Non-Cashoutable Wallet
    And Assert Refund Data In Credit Management, Credit Merchant Management And Report Management Is Correct
    ...    billing_cycle_closed=True
    And The Gateway Is Disabled

[TC-007] Make A Refund After Paid The Early Settlement On Channel UPG
    Given Allocate No Fee BNPL Account
    And The Payment Gateway Is Set To BPG
    And Set Channel To UPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And Set Settlement Method To BNPL 1pay
    When A Full Purchase    amount=2000    type=13
    And Pay The Early Settlement    amount=2000
    And Perform A Full Refund    type=13
    Then Early Settlement Status Must Be Confirmed
    And Refund API Should Be Successful
    And Check Refund Type    debt_paid=True
    And Check SMS For Refund To Cashoutable Wallet
    And Assert Refund Data In Credit Management, Credit Merchant Management And Report Management Is Correct
    And The Gateway Is Disabled

[TC-008] Make A Refund For The Blocked Credit Account On Channel UPG
    Given Allocate No Fee BNPL Account
    And The Payment Gateway Is Set To BPG
    And Set Channel To UPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And Set Settlement Method To BNPL 1pay
    When A Full Purchase    amount=3000    type=13
    And Block The Credit Account    credit_id=${credit_ids}[0]
    And Perform A Full Refund    type=13
    Then Refund API Should Be Successful
    And Check Refund Type
    And Check SMS For Refund To Credit
    And Assert Refund Data In Credit Management, Credit Merchant Management And Report Management Is Correct
    And The Gateway Is Disabled

[TC-009] Partial Refund On No Fee BNPL Account On Channel Payment Link
    Given Allocate No Fee BNPL Account
    And The Payment Gateway Is Set To BPG
    And Set Channel To Payment Link
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And Set Settlement Method To BNPL 1pay
    When A Full Purchase    amount=3000    type=13
    And Perform A Partial Refund    amount=2000    type=13
    Then Refund Type Must Include Credit
    And Refund Pay Gateway Must Include BPG
    And Check Refund Settlement Method Must Include BNPL 1PAY Method
    And Check Refund Type    partial_refund_flag=${True}
    And Check SMS For Refund To Credit
    And Assert Refund Data In Credit Management, Credit Merchant Management And Report Management Is Correct    partial_refund_flag=${True}
    And The Gateway Is Disabled

[TC-010] Partial Refund On No Fee CCREDIT Account On Channel Payment Link
    Given Allocate No Fee CCredit Account
    And The Payment Gateway Is Set To CPG
    And Set Channel To Payment Link
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And Set Settlement Method To CCREDIT
    When A Full Purchase    amount=3000    type=5
    And Perform A Partial Refund    amount=2000    type=5
    Then Refund Type Must Include Credit
    And Refund Pay Gateway Must Include CPG
    And Check Refund Settlement Method Must Include CCREDIT Method
    And Check Refund Type    partial_refund_flag=${True}
    And Check SMS For Refund To Credit
    And Assert Refund Data In Credit Management, Credit Merchant Management And Report Management Is Correct    partial_refund_flag=${True}
    And The Gateway Is Disabled

[TC-011] Full Refund On No Fee BNPL Account On Channel Payment Link
    Given Allocate No Fee BNPL Account
    And The Payment Gateway Is Set To BPG
    And Set Channel To Payment Link
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And Set Settlement Method To BNPL 1pay
    When A Full Purchase    amount=3000    type=13
    And Perform A Full Refund    type=13
    Then Refund Type Must Include Credit
    And Refund Pay Gateway Must Include BPG
    And Check Refund Settlement Method Must Include BNPL 1PAY Method
    And Check Refund Type
    And Check SMS For Refund To Credit
    And Assert Refund Data In Credit Management, Credit Merchant Management And Report Management Is Correct
    And The Gateway Is Disabled

[TC-012] Full Refund On No Fee CCREDIT Account On Channel Payment Link
    Given Allocate No Fee CCredit Account
    And The Payment Gateway Is Set To CPG
    And Set Channel To Payment Link
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And Set Settlement Method To CCREDIT
    When A Full Purchase    amount=3000    type=5
    And Perform A Full Refund    type=5
    Then Refund Type Must Include Credit
    And Refund Pay Gateway Must Include CPG
    And Check Refund Settlement Method Must Include CCREDIT Method
    And Check Refund Type
    And Check SMS For Refund To Credit
    And Assert Refund Data In Credit Management, Credit Merchant Management And Report Management Is Correct
    And The Gateway Is Disabled

[TC-013] Full Refund On No Fee Installment Sale Account On Channel Payment Link
    Given Allocate No Fee Installment Sale Account
    And The Payment Gateway Is Set To ISPG
    And Set Channel To Payment Link
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And Set Settlement Method To CREDITCHECK
    When A Full Purchase    amount=3000    type=26
    And Perform A Full Refund    type=26
    Then Refund Type Must Include Credit
    And Refund Pay Gateway Must Include ISPG
    And Check Refund Settlement Method Must Include CREDITCHECK Method
    And Check Refund Type
    And Check SMS For Refund To Credit
    And Assert Refund Data In Credit Management, Credit Merchant Management And Report Management Is Correct
    And The Gateway Is Disabled

[TC-014] Make A Refund after Closing Billing Cycle On Channel Payment Link
    Given Allocate No Fee BNPL Account
    And The Payment Gateway Is Set To BPG
    And Set Channel To Payment Link
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And Set Settlement Method To BNPL 1pay
    When A Full Purchase    amount=3000    type=13
    And Close billing cycle    credit_id=${credit_ids}[0]
    And Perform A Full Refund    type=13
    And Refund API Should Be Successful
    And Check Refund Type    billing_cycle_closed=True
    And Check SMS For Refund To Non-Cashoutable Wallet
    And Assert Refund Data In Credit Management, Credit Merchant Management And Report Management Is Correct
    ...    billing_cycle_closed=True
    And The Gateway Is Disabled

[TC-015] Make A Refund After Paid The Early Settlement On Channel Payment Link
    Given Allocate No Fee BNPL Account
    And The Payment Gateway Is Set To BPG
    And Set Channel To Payment Link
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And Set Settlement Method To BNPL 1pay
    When A Full Purchase    amount=2000    type=13
    And Pay The Early Settlement    amount=2000
    And Perform A Full Refund    type=13
    Then Early Settlement Status Must Be Confirmed
    And Refund API Should Be Successful
    And Check Refund Type    debt_paid=True
    And Check SMS For Refund To Cashoutable Wallet
    And Assert Refund Data In Credit Management, Credit Merchant Management And Report Management Is Correct
    And The Gateway Is Disabled

[TC-016] Make A Refund For The Blocked Credit Account On Channel Payment Link
    Given Allocate No Fee BNPL Account
    And The Payment Gateway Is Set To BPG
    And Set Channel To Payment Link
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And Set Settlement Method To BNPL 1pay
    When A Full Purchase    amount=3000    type=13
    And Block The Credit Account    credit_id=${credit_ids}[0]
    And Perform A Full Refund    type=13
    Then Refund API Should Be Successful
    And Check Refund Type
    And Check SMS For Refund To Credit
    And Assert Refund Data In Credit Management, Credit Merchant Management And Report Management Is Correct
    And The Gateway Is Disabled

[TC-017] Make A Refund After Delete The Billing Cycle On Channel Payment Link
    Given Allocate No Fee BNPL Account
    And The Payment Gateway Is Set To BPG
    And Set Channel To Payment Link
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And Set Settlement Method To BNPL 1pay
    When A Full Purchase    amount=3000    type=13
    And Delete Billing Cycles    credit_id=${credit_ids}[0]
    And Perform A Full Refund    type=13
    And Refund API Should Be Successful
    And Check Refund Type    billing_cycle_removed=True
    And Check SMS For Refund To Non-Cashoutable Wallet
    And Assert Refund Data In Credit Management, Credit Merchant Management And Report Management Is Correct
    ...    billing_cycle_removed=True
    And The Gateway Is Disabled

[TC-018] Make A Refund After Delete The Billing Cycle On Channel UPG
    Given Allocate No Fee BNPL Account
    And The Payment Gateway Is Set To BPG
    And Set Channel To UPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And Set Settlement Method To BNPL 1pay
    When A Full Purchase    amount=3000    type=13
    And Delete Billing Cycles    credit_id=${credit_ids}[0]
    And Perform A Full Refund    type=13
    And Refund API Should Be Successful
    And Check Refund Type    billing_cycle_removed=True
    And Check SMS For Refund To Non-Cashoutable Wallet
    And Assert Refund Data In Credit Management, Credit Merchant Management And Report Management Is Correct
    ...    billing_cycle_removed=True
    And The Gateway Is Disabled

[TC-019] Partial Refund On No Fee BNPL Account On Channel API
    Given Allocate No Fee BNPL Account
    And The Payment Gateway Is Set To BPG
    And Set Channel To API
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And Set Settlement Method To BNPL 1pay
    When Perform A Complete Purchase    amount=3000
    And Perform A Partial Refund    amount=2000    type=13
    Then Refund Type Must Include Credit
    And Refund Pay Gateway Must Include BPG
    And Check Refund Settlement Method Must Include BNPL 1PAY Method
    And Check Refund Type    partial_refund_flag=${True}
    And Check SMS For Refund To Credit
    And Assert Refund Data In Credit Management, Credit Merchant Management And Report Management Is Correct    partial_refund_flag=${True}
    And The Gateway Is Disabled

[TC-020] Partial Refund On No Fee CCREDIT Account On Channel API
    Given Allocate No Fee CCredit Account
    And The Payment Gateway Is Set To CPG
    And Set Channel To API
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And Set Settlement Method To CCREDIT
    When Perform A Complete Purchase    amount=3000
    And Perform A Partial Refund    amount=2000    type=5
    Then Refund Type Must Include Credit
    And Refund Pay Gateway Must Include CPG
    And Check Refund Settlement Method Must Include CCREDIT Method
    And Check Refund Type    partial_refund_flag=${True}
    And Check SMS For Refund To Credit
    And Assert Refund Data In Credit Management, Credit Merchant Management And Report Management Is Correct    partial_refund_flag=${True}
    And The Gateway Is Disabled

[TC-021] Full Refund On No Fee BNPL Account On Channel API
    Given Allocate No Fee BNPL Account
    And The Payment Gateway Is Set To BPG
    And Set Channel To API
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And Set Settlement Method To BNPL 1pay
    When Perform A Complete Purchase    amount=3000
    And Perform A Full Refund    type=13
    Then Refund Type Must Include Credit
    And Refund Pay Gateway Must Include BPG
    And Check Refund Settlement Method Must Include BNPL 1PAY Method
    And Check Refund Type
    And Check SMS For Refund To Credit
    And Assert Refund Data In Credit Management, Credit Merchant Management And Report Management Is Correct
    And The Gateway Is Disabled

[TC-022] Full Refund On No Fee CCREDIT Account On Channel API
    Given Allocate No Fee CCredit Account
    And The Payment Gateway Is Set To CPG
    And Set Channel To API
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And Set Settlement Method To CCREDIT
    When Perform A Complete Purchase    amount=3000
    And Perform A Full Refund    type=5
    Then Refund Type Must Include Credit
    And Refund Pay Gateway Must Include CPG
    And Check Refund Settlement Method Must Include CCREDIT Method
    And Check Refund Type
    And Check SMS For Refund To Credit
    And Assert Refund Data In Credit Management, Credit Merchant Management And Report Management Is Correct
    And The Gateway Is Disabled

[TC-023] Full Refund On No Fee Installment Sale Account On Channel API
    Given Allocate No Fee Installment Sale Account
    And The Payment Gateway Is Set To ISPG
    And Set Channel To API
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And Set Settlement Method To CREDITCHECK
    When Perform A Complete Purchase    amount=3000
    And Perform A Full Refund    type=26
    Then Refund Type Must Include Credit
    And Refund Pay Gateway Must Include ISPG
    And Check Refund Settlement Method Must Include CREDITCHECK Method
    And Check Refund Type
    And Check SMS For Refund To Credit
    And Assert Refund Data In Credit Management, Credit Merchant Management And Report Management Is Correct
    And The Gateway Is Disabled

[TC-024] Make A Refund after Closing Billing Cycle On Channel API
    Given Allocate No Fee BNPL Account
    And The Payment Gateway Is Set To BPG
    And Set Channel To API
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And Set Settlement Method To BNPL 1pay
    When Perform A Complete Purchase    amount=3000
    And Close billing cycle    credit_id=${credit_ids}[0]
    And Perform A Full Refund    type=13
    And Refund API Should Be Successful
    And Check Refund Type    billing_cycle_closed=True
    And Check SMS For Refund To Non-Cashoutable Wallet
    And Assert Refund Data In Credit Management, Credit Merchant Management And Report Management Is Correct
    ...    billing_cycle_closed=True
    And The Gateway Is Disabled

[TC-025] Make A Refund After Paid The Early Settlement On Channel API
    Given Allocate No Fee BNPL Account
    And The Payment Gateway Is Set To BPG
    And Set Channel To API
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And Set Settlement Method To BNPL 1pay
    When Perform A Complete Purchase    amount=2000
    And Pay The Early Settlement    amount=2000
    And Perform A Full Refund    type=13
    Then Early Settlement Status Must Be Confirmed
    And Refund API Should Be Successful
    And Check Refund Type    debt_paid=True
    And Check SMS For Refund To Cashoutable Wallet
    And Assert Refund Data In Credit Management, Credit Merchant Management And Report Management Is Correct
    And The Gateway Is Disabled

[TC-026] Make A Refund For The Blocked Credit Account On Channel API
    Given Allocate No Fee BNPL Account
    And The Payment Gateway Is Set To BPG
    And Set Channel To API
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And Set Settlement Method To BNPL 1pay
    When Perform A Complete Purchase    amount=3000
    And Block The Credit Account    credit_id=${credit_ids}[0]
    And Perform A Full Refund    type=13
    Then Refund API Should Be Successful
    And Check Refund Type
    And Check SMS For Refund To Credit
    And Assert Refund Data In Credit Management, Credit Merchant Management And Report Management Is Correct
    And The Gateway Is Disabled

[TC-027] Make A Refund After Delete The Billing Cycle On Channel API
    Given Allocate No Fee BNPL Account
    And The Payment Gateway Is Set To BPG
    And Set Channel To API
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And Set Settlement Method To BNPL 1pay
    When Perform A Complete Purchase    amount=3000
    And Delete Billing Cycles    credit_id=${credit_ids}[0]
    And Perform A Full Refund    type=13
    And Refund API Should Be Successful
    And Check Refund Type    billing_cycle_removed=True
    And Check SMS For Refund To Non-Cashoutable Wallet
    And Assert Refund Data In Credit Management, Credit Merchant Management And Report Management Is Correct
    ...    billing_cycle_removed=True
    And The Gateway Is Disabled

[TC-028] Make A Refund For The Schedule Close Credit Account On Channel API
    Given Allocate No Fee BNPL Account
    And The Payment Gateway Is Set To BPG
    And Set Channel To API
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And Set Settlement Method To BNPL 1pay
    When Perform A Complete Purchase    amount=3000
    And Call Schedule Close API    credit_id=${credit_ids}[0]
    And Perform A Full Refund    type=13
    Then Refund API Should Be Successful
    And Check Refund Type
    And Check SMS For Refund To Credit
    And Assert Refund Data In Credit Management, Credit Merchant Management And Report Management Is Correct
    And The Gateway Is Disabled

[TC-029] Partial Refund On No Fee CCREDIT Account On Channel UPG When Remaining Amount Is More Than Refund Min Remaining Amount
    Given Allocate No Fee CCredit Account
    And The Payment Gateway Is Set To CPG
    And Set Channel To UPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And Set Settlement Method To CCREDIT
    When A Full Purchase    amount=3000    type=5
    And Perform A Partial Refund When Remaining Amount Is More Than Refund Min Remaining Amount
    ...    amount=3500
    ...    type=5
    Then Refund API Should Not Be Successful
    And The Error Code Should Be    status=9022    title=PURMG_REFUND_EXCEEDED_PURCHASE_AMOUNT
    And The Gateway Is Disabled

[TC-030] Partial Refund On No Fee Xpay BNPL Account On Channel UPG
    Given Allocate No Fee Xpay BNPL Account
    And The Payment Gateway Is Set To BPG
    And Set Channel To UPG
    And Set Settlement Method To BNPL Xpay
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    When Performed An Online Purchase    has_cash_pay=${True}
    And Perform A Full Refund    type=13
    Then Refund Pay Gateway Must Include BPG
    And Check Refund Settlement Method Must Include BNPL XPAY Method
    And Check Refund Type
    And Check SMS For Refund To Credit
    And Assert Refund Data In Credit Management, Credit Merchant Management And Report Management Is Correct    has_cash_pay=${True}
    And The Gateway Is Disabled

[TC-031] Partial Refund With Coupon, Credit And Cash Parts
    Given Allocate No Fee Xpay BNPL Account
    And The Payment Gateway Is Set To BPG
    And Set Channel To UPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And Set Settlement Method To BNPL 1pay
    And Set LMS_AUTOMATION_BUSINESS_ID To    BUSINESS_ID=company-user-id
    When A Full Purchase    amount=5000    type=13    has_cash_pay=${True}    coupon_code=test
    And Perform A Partial Refund    amount=3000    type=13
    And Perform A Partial Refund    amount=1999     type=13
    Then Refund Type Must Include Credit
    And Refund Type Must Include Prepayment
    And Refund Type Must Include Coupon
    And Refund Pay Gateway Must Include BPG
    And Check Refund Settlement Method Must Include BNPL XPAY Method
    And Check Refund Type    partial_refund_flag=${True}

[TC-032] Boundary Value Test For Refund With Coupon, Credit And Cash Parts
    Given Allocate No Fee Xpay BNPL Account
    And The Payment Gateway Is Set To BPG
    And Set Channel To UPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And Set Settlement Method To BNPL 1pay
    And Set LMS_AUTOMATION_BUSINESS_ID To    BUSINESS_ID=company-user-id
    When A Full Purchase    amount=4963    type=13    has_cash_pay=${True}    coupon_code=test
    And Perform A Partial Refund    amount=4962    type=13
    Then Refund Type Must Include Credit
    And Refund Type Must Include Prepayment
    And Refund Type Must Include Coupon
    And Refund Pay Gateway Must Include BPG
    And Check Refund Settlement Method Must Include BNPL XPAY Method
    And Check Refund Type    partial_refund_flag=${True}

[TC-033] Minimum Value For Refund With Coupon, Credit And Cash Parts
    Given Allocate No Fee Xpay BNPL Account
    And The Payment Gateway Is Set To BPG
    And Set Channel To UPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And Set Settlement Method To BNPL 1pay
    And Set LMS_AUTOMATION_BUSINESS_ID To    BUSINESS_ID=company-user-id
    When A Full Purchase    amount=49603    type=13    has_cash_pay=${True}    coupon_code=test
    And Perform A Partial Refund    amount=1    type=13
    Then Refund Type Must Include Credit
    And Refund Type Must Include Prepayment
    And Refund Type Must Include Coupon
    And Refund Pay Gateway Must Include BPG
    And Check Refund Settlement Method Must Include BNPL XPAY Method
    And Check Refund Type    partial_refund_flag=${True}

[TC-034] Long Value For Refund With Coupon, Credit And Cash Parts
    Given Allocate No Fee Xpay BNPL Account
    And The Payment Gateway Is Set To BPG
    And Set Channel To UPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And Set Settlement Method To BNPL 1pay
    And Set LMS_AUTOMATION_BUSINESS_ID To    BUSINESS_ID=company-user-id
    When A Full Purchase    amount=49603    type=13    has_cash_pay=${True}    coupon_code=test
    And Perform A Partial Refund    amount=99999999999    type=13
    Then Refund Type Must Include Credit
    And Refund Type Must Include Prepayment
    And Refund Type Must Include Coupon
    And Refund Pay Gateway Must Include BPG
    And Check Refund Settlement Method Must Include BNPL XPAY Method
    And Check Refund Type    partial_refund_flag=${True}

[TC-035] Zero Value For Refund With Coupon, Credit And Cash Parts
    Given Allocate No Fee Xpay BNPL Account
    And The Payment Gateway Is Set To BPG
    And Set Channel To UPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And Set Settlement Method To BNPL 1pay
    And Set LMS_AUTOMATION_BUSINESS_ID To    BUSINESS_ID=company-user-id
    When A Full Purchase    amount=49603    type=13    has_cash_pay=${True}    coupon_code=test
    And Perform A Partial Refund    amount=0    type=13
    Then Refund Type Must Include Credit
    And Refund Type Must Include Prepayment
    And Refund Type Must Include Coupon
    And Refund Pay Gateway Must Include BPG
    And Check Refund Settlement Method Must Include BNPL XPAY Method
    And Check Refund Type    partial_refund_flag=${True}

[TC-036] Negative Value For Refund With Coupon, Credit And Cash Parts
    Given Allocate No Fee Xpay BNPL Account
    And The Payment Gateway Is Set To BPG
    And Set Channel To UPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And Set Settlement Method To BNPL 1pay
    And Set LMS_AUTOMATION_BUSINESS_ID To    BUSINESS_ID=company-user-id
    When A Full Purchase    amount=49603    type=13    has_cash_pay=${True}    coupon_code=test
    And Perform A Partial Refund    amount=-1    type=13
    Then Refund Type Must Include Credit
    And Refund Type Must Include Prepayment
    And Refund Type Must Include Coupon
    And Refund Pay Gateway Must Include BPG
    And Check Refund Settlement Method Must Include BNPL XPAY Method
    And Check Refund Type    partial_refund_flag=${True}

[TC-037] Minimum Coupon Value For Refund With Coupon, Credit And Cash Parts
    Given Allocate No Fee Xpay BNPL Account
    And The Payment Gateway Is Set To BPG
    And Set Channel To UPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And Set Settlement Method To BNPL 1pay
    And Set LMS_AUTOMATION_BUSINESS_ID To    BUSINESS_ID=company-user-id
    When A Full Purchase    amount=49603    type=13    has_cash_pay=${True}    coupon_code=1percent
    And Perform A Partial Refund    amount=49602    type=13
    Then Refund Type Must Include Credit
    Then Refund Type Must Include Prepayment
    And Refund Type Must Include Coupon
    And Refund Pay Gateway Must Include BPG
    And Check Refund Settlement Method Must Include BNPL XPAY Method
    And Check Refund Type    partial_refund_flag=${True}

[TC-038] Use 99 percent Coupon Value For Refund With Coupon, Credit And Cash Parts
    Given Allocate No Fee Xpay BNPL Account
    And The Payment Gateway Is Set To BPG
    And Set Channel To UPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And Set Settlement Method To BNPL 1pay
    And Set LMS_AUTOMATION_BUSINESS_ID To    BUSINESS_ID=company-user-id
    When A Full Purchase    amount=49603    type=13    has_cash_pay=${True}    coupon_code=99percent
    And Perform A Partial Refund    amount=49602    type=13
    Then Refund Type Must Include Credit
    And Refund Type Must Include Prepayment
    And Refund Type Must Include Coupon
    And Refund Pay Gateway Must Include BPG
    And Check Refund Settlement Method Must Include BNPL XPAY Method
    And Check Refund Type    partial_refund_flag=${True}

