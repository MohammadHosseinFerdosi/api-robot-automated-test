*** Settings ***
Resource            steps/LMS/credit-core/online-purchase-step.resource

Test Setup          Initialize Merchant
Test Teardown       Reproduce Amount And Credit Gateway Disable


*** Test Cases ***
[TC-001] Online [BNPL] Purchase with [No Cash, No Fee] On [UPG] and [Active Account] and [Active Gateway]
    Given Allocate No Fee 1PAY Account
    And Set channel UPG
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway BPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When Performed An Online Purchase
    Then The Purchase Should have Been Successful
    And Record Must Exist In Report
    And Assert Purchase Data In Credit Management, Credit Merchant Management And Report Management Is Correct

[TC-002] Online [BNPL] Purchase with [No Cash, No Fee] On [UPG] and [Blocked Account] and [Active Gateway]
    Given Allocate No Fee 1PAY Account
    And Set channel UPG
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway BPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    And Block Credit Account
    When Performed An Online Purchase
    Then The Purchase Should Not have Been Successful

[TC-003] Online [BNPL] Purchase with [No Cash, No Fee] On [UPG] and [Blocked Account Before Prepare] and [Active Gateway]
    Given Allocate No Fee 1PAY Account
    And Set channel UPG
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway BPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When Performed An Initiated Online Purchase
    And Block Credit Account
    And Prepare The Credit Purchase
    And Route Info The Credit Purchase
    And Pay The Credit Purchase
    And Verify The Credit Purchase
    And Deliver The Credit Purchase
    Then The Purchase Should have Been Successful
    And Should Not Have Been Able To Prepare
    And Should Not Have Been Able To Route Info
    And Should Not Have Been Able To Pay
    And Should Not Have Been Able To Verify
    And Should Not Have Been Able To Deliver

[TC-004] Online [BNPL] Purchase with [No Cash, No Fee] On [UPG] and [Blocked Account Before Route Info] and [Active Gateway]
    [Tags]    robot:skip
    Given Allocate No Fee 1PAY Account
    And Set channel UPG
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway BPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When Performed A Prepared Online Purchase
    And Block Credit Account
    And Route Info The Credit Purchase
    And Pay The Credit Purchase
    And Verify The Credit Purchase
    And Deliver The Credit Purchase
    Then The Purchase Should have Been Successful
    And Should Not Have Been Able To Route Info
    And Should Not Have Been Able To Pay
    And Should Not Have Been Able To Verify
    And Should Not Have Been Able To Deliver

[TC-005] Online [BNPL] Purchase with [No Cash, No Fee] On [UPG] and [Blocked Account Before Credit Pay] and [Active Gateway]
    [Tags]    robot:skip
    Given Allocate No Fee 1PAY Account
    And Set channel UPG
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway BPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When Performed A Routed Online Purchase
    And Block Credit Account
    And Pay The Credit Purchase
    And Verify The Credit Purchase
    And Deliver The Credit Purchase
    Then The Purchase Should have Been Successful
    And Should Not Have Been Able To Pay
    And Should Not Have Been Able To Verify
    And Should Not Have Been Able To Deliver

[TC-006] Online [BNPL] Purchase with [No Cash, No Fee] On [UPG] and [Blocked Account Before Verification] and [Active Gateway]
    [Tags]    robot:skip
    Given Allocate No Fee 1PAY Account
    And Set channel UPG
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway BPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When Performed A Paid Online Purchase
    And Block Credit Account
    And Verify The Credit Purchase
    And Deliver The Credit Purchase
    Then The Purchase Should have Been Successful
    And Should Not Have Been Able To Verify
    And Should Not Have Been Able To Deliver

[TC-007] Online [BNPL] Purchase with [No Cash, No Fee] On [UPG] and [Blocked Account Before Delivery] and [Active Gateway]
    Given Allocate No Fee 1PAY Account
    And Set channel UPG
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway BPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When Performed A Verified Online Purchase
    And Block Credit Account
    And Deliver The Credit Purchase
    Then The Purchase Should have Been Successful
    And Should Have Been Able To Deliver
    And Purchase Status Must Be DELIVERED
    And Assert Purchase Data In Credit Management, Credit Merchant Management And Report Management Is Correct

[TC-008] Online [BNPL] Purchase with [No Cash, No Fee] On [UPG] and [Expired Account] and [Active Gateway]
    Given Allocate No Fee 1PAY Account
    And Set channel UPG
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway BPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    And Empty Balance
    And Expire Account
    When Performed An Online Purchase
    Then The Purchase Should Not have Been Successful

[TC-009] Online [BNPL] Purchase with [No Cash, No Fee] On [UPG] and [Expired Account Before Prepare] and [Active Gateway]
    Given Allocate No Fee 1PAY Account
    And Set channel UPG
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway BPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When Performed An Initiated Online Purchase
    And Empty Balance
    And Expire Account
    And Prepare The Credit Purchase
    And Route Info The Credit Purchase
    And Pay The Credit Purchase
    And Verify The Credit Purchase
    And Deliver The Credit Purchase
    Then The Purchase Should have Been Successful
    And Should Not Have Been Able To Prepare
    And Should Not Have Been Able To Route Info
    And Should Not Have Been Able To Pay
    And Should Not Have Been Able To Verify
    And Should Not Have Been Able To Deliver

[TC-010] Online [BNPL] Purchase with [No Cash, No Fee] On [UPG] and [Expired Account Before Route Info] and [Active Gateway]
    Given Allocate No Fee 1PAY Account
    And Set channel UPG
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway BPG
    And Credit Gateway Activate
    And Set Amount Equal To Balance
    When Performed A Prepared Online Purchase
    And Expire Account
    And Route Info The Credit Purchase
    And Pay The Credit Purchase
    And Verify The Credit Purchase
    And Deliver The Credit Purchase
    Then The Purchase Should have Been Successful
    And Should Have Been Able To Route Info
    And Should Have Been Able To Pay
    And Should Have Been Able To Verify
    And Should Have Been Able To Deliver
    And Assert Purchase Data In Credit Management, Credit Merchant Management And Report Management Is Correct

[TC-011] Online [BNPL] Purchase with [No Cash, No Fee] On [UPG] and [Expired Account Before Credit Pay] and [Active Gateway]
    Given Allocate No Fee 1PAY Account
    And Set channel UPG
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway BPG
    And Credit Gateway Activate
    And Set Amount Equal To Balance
    When Performed A Routed Online Purchase
    And Expire Account
    And Pay The Credit Purchase
    And Verify The Credit Purchase
    And Deliver The Credit Purchase
    Then The Purchase Should have Been Successful
    And Should Have Been Able To Pay
    And Should Have Been Able To Verify
    And Should Have Been Able To Deliver
    And Assert Purchase Data In Credit Management, Credit Merchant Management And Report Management Is Correct

[TC-012] Online [BNPL] Purchase with [No Cash, No Fee] On [UPG] and [Expired Account Before Verification] and [Active Gateway]
    Given Allocate No Fee 1PAY Account
    And Set channel UPG
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway BPG
    And Credit Gateway Activate
    And Set Amount Equal To Balance
    When Performed A Paid Online Purchase
    And Expire Account
    And Verify The Credit Purchase
    And Deliver The Credit Purchase
    Then The Purchase Should have Been Successful
    And Should Have Been Able To Verify
    And Should Have Been Able To Deliver
    And Assert Purchase Data In Credit Management, Credit Merchant Management And Report Management Is Correct

[TC-013] Online [BNPL] Purchase with [No Cash, No Fee] On [UPG] and [Expired Account Before Delivery] and [Active Gateway]
    Given Allocate No Fee 1PAY Account
    And Set channel UPG
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway BPG
    And Credit Gateway Activate
    And Set Amount Equal To Balance
    When Performed A Verified Online Purchase
    And Expire Account
    And Deliver The Credit Purchase
    Then The Purchase Should have Been Successful
    And Should Have Been Able To Deliver
    And Purchase Status Must Be DELIVERED
    And Assert Purchase Data In Credit Management, Credit Merchant Management And Report Management Is Correct

[TC-014] Online [BNPL] Purchase with [No Cash, No Fee] On [UPG] and [Expired Account Before Billing Cycle Assign] and [Active Gateway]
    Given Allocate No Fee 1PAY Account
    And Set channel UPG
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway BPG
    And Credit Gateway Activate
    And Set Amount Equal To Balance
    When Performed An Online Purchase
    And Expire Account
    And Wait For The Purchase To Be Assigned To The Billing Cycle
    Then The Purchase Should have Been Successful
    And Purchase Should Be Assigned To The Billing Cycle
    And Assert Purchase Data In Credit Management, Credit Merchant Management And Report Management Is Correct

[TC-015] Online [BNPL] Purchase with [No Cash, No Fee] On [UPG] and [Zero Balance Account] and [Active Gateway]
    Given Allocate No Fee 1PAY Account
    And Set channel UPG
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway BPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    And Empty Balance
    When Performed An Online Purchase
    Then The Purchase Should Not have Been Successful

[TC-016] Online [BNPL] Purchase with [No Cash, No Fee] On [UPG] and [Zero Balance Account Before Prepare] and [Active Gateway]
    Given Allocate No Fee 1PAY Account
    And Set channel UPG
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway BPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When Performed An Initiated Online Purchase
    And Empty Balance
    And Prepare The Credit Purchase
    And Route Info The Credit Purchase
    And Pay The Credit Purchase
    And Verify The Credit Purchase
    And Deliver The Credit Purchase
    Then The Purchase Should have Been Successful
    And Should Not Have Been Able To Prepare
    And Should Not Have Been Able To Route Info
    And Should Not Have Been Able To Pay
    And Should Not Have Been Able To Verify
    And Should Not Have Been Able To Deliver

[TC-017] Online [BNPL] Purchase with [No Cash, No Fee] On [UPG] and [Zero Balance Account Before Route Info] and [Active Gateway]
    Given Allocate No Fee 1PAY Account
    And Set channel UPG
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway BPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When Performed A Prepared Online Purchase
    And Empty Balance
    And Route Info The Credit Purchase
    And Pay The Credit Purchase
    And Verify The Credit Purchase
    And Deliver The Credit Purchase
    Then The Purchase Should have Been Successful
    And Should Have Been Able To Route Info
    And Should Not Have Been Able To Pay
    And Should Not Have Been Able To Verify
    And Should Not Have Been Able To Deliver

[TC-018] Online [BNPL] Purchase with [No Cash, No Fee] On [UPG] and [Zero Balance Account Before Credit Pay] and [Active Gateway]
    Given Allocate No Fee 1PAY Account
    And Set channel UPG
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway BPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When Performed A Routed Online Purchase
    And Empty Balance
    And Pay The Credit Purchase
    And Verify The Credit Purchase
    And Deliver The Credit Purchase
    Then The Purchase Should have Been Successful
    And Should Not Have Been Able To Pay
    And Should Not Have Been Able To Verify
    And Should Not Have Been Able To Deliver

[TC-019] Online [BNPL] Purchase with [No Cash, No Fee] On [UPG] and [Zero Balance Account Before Verification] and [Active Gateway]
    Given Allocate No Fee 1PAY Account
    And Set channel UPG
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway BPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When Performed A Paid Online Purchase
    And Empty Balance
    And Verify The Credit Purchase
    And Deliver The Credit Purchase
    Then The Purchase Should have Been Successful
    And Should Have Been Able To Verify
    And Should Have Been Able To Deliver
    And Assert Purchase Data In Credit Management, Credit Merchant Management And Report Management Is Correct

[TC-020] Online [BNPL] Purchase with [No Cash, No Fee] On [UPG] and [Zero Balance Account Before Delivery] and [Active Gateway]
    Given Allocate No Fee 1PAY Account
    And Set channel UPG
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway BPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When Performed A Verified Online Purchase
    And Empty Balance
    And Deliver The Credit Purchase
    Then The Purchase Should have Been Successful
    And Should Have Been Able To Deliver
    And Purchase Status Must Be DELIVERED
    And Assert Purchase Data In Credit Management, Credit Merchant Management And Report Management Is Correct

[TC-021] Online [BNPL] Purchase with [No Cash, No Fee] On [UPG] and [Active Account] and [Disabled Gateway]
    Given Allocate No Fee 1PAY Account
    And Set channel UPG
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway BPG
    And Set Amount Less Than Balance
    And Credit Gateway Activate
    And Credit Gateway Disable
    When Performed An Online Purchase
    Then The Purchase Should Not have Been Successful

[TC-022] Online [BNPL] Purchase with [No Cash, No Fee] On [UPG] and [Blocked Account] and [Disabled Gateway]
    Given Allocate No Fee 1PAY Account
    And Set channel UPG
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway BPG
    And Set Amount Less Than Balance
    And Block Credit Account
    And Credit Gateway Activate

    When Performed An Online Purchase
    Then The Purchase Should Not have Been Successful

[TC-023] Online [BNPL] Purchase with [No Cash, No Fee] On [UPG] and [Expired Account] and [Disabled Gateway]
    Given Allocate No Fee 1PAY Account
    And Set channel UPG
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway BPG
    And Set Amount Less Than Balance
    And Empty Balance
    And Expire Account
    And Credit Gateway Activate

    When Performed An Online Purchase
    Then The Purchase Should Not have Been Successful

[TC-024] Online [BNPL] Purchase with [No Cash, No Fee] On [UPG] and [Zero Balance Account] and [Disabled Gateway]
    Given Allocate No Fee 1PAY Account
    And Set channel UPG
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway BPG
    And Set Amount Less Than Balance
    And Empty Balance
    And Credit Gateway Activate

    When Performed An Online Purchase
    Then The Purchase Should Not have Been Successful

[TC-025] Online [BNPL] Purchase with [No Cash, No Fee] On [UPG] and [Active Account] and [Disabled Gateway Before Prepare]
    [Tags]    robot:skip
    Given Allocate No Fee 1PAY Account
    And Set channel UPG
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway BPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When Performed An Initiated Online Purchase

    And Prepare The Credit Purchase
    And Route Info The Credit Purchase
    And Pay The Credit Purchase
    And Verify The Credit Purchase
    And Deliver The Credit Purchase
    Then The Purchase Should have Been Successful
    And Should Have Been Able To Prepare
    And Should Have Been Able To Route Info
    And Should Have Been Able To Pay
    And Should Have Been Able To Verify
    And Should Have Been Able To Deliver
    And Assert Purchase Data In Credit Management, Credit Merchant Management And Report Management Is Correct

[TC-026] Online [BNPL] Purchase with [No Cash, No Fee] On [UPG] and [Active Account] and [Disabled Gateway Before Route Info]
    [Tags]    robot:skip
    Given Allocate No Fee 1PAY Account
    And Set channel UPG
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway BPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When Performed A Prepared Online Purchase
    And Route Info The Credit Purchase

    And Pay The Credit Purchase
    And Verify The Credit Purchase
    And Deliver The Credit Purchase
    Then The Purchase Should have Been Successful
    And Should Have Been Able To Route Info
    And Should Have Been Able To Pay
    And Should Have Been Able To Verify
    And Should Have Been Able To Deliver
    And Assert Purchase Data In Credit Management, Credit Merchant Management And Report Management Is Correct

[TC-027] Online [BNPL] Purchase with [No Cash, No Fee] On [UPG] and [Active Account] and [Disabled Gateway Before Credit Pay]
    [Tags]    robot:skip
    Given Allocate No Fee 1PAY Account
    And Set channel UPG
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway BPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When Performed A Routed Online Purchase

    And Pay The Credit Purchase
    And Verify The Credit Purchase
    And Deliver The Credit Purchase
    Then The Purchase Should have Been Successful
    And Should Have Been Able To Pay
    And Should Have Been Able To Verify
    And Should Have Been Able To Deliver
    And Assert Purchase Data In Credit Management, Credit Merchant Management And Report Management Is Correct

[TC-028] Online [BNPL] Purchase with [No Cash, No Fee] On [UPG] and [Active Account] and [Disabled Gateway Before Verification]
    [Tags]    robot:skip
    Given Allocate No Fee 1PAY Account
    And Set channel UPG
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway BPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When Performed A Paid Online Purchase

    And Verify The Credit Purchase
    And Deliver The Credit Purchase
    Then The Purchase Should have Been Successful
    And Should Have Been Able To Verify
    And Should Have Been Able To Deliver
    And Assert Purchase Data In Credit Management, Credit Merchant Management And Report Management Is Correct

[TC-029] Online [BNPL] Purchase with [No Cash, No Fee] On [UPG] and [Active Account] and [Disabled Gateway Before Delivery]
    Given Allocate No Fee 1PAY Account
    And Set channel UPG
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway BPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When Performed A Verified Online Purchase

    And Deliver The Credit Purchase
    Then The Purchase Should have Been Successful
    And Should Have Been Able To Deliver
    And Purchase Status Must Be DELIVERED
    And Assert Purchase Data In Credit Management, Credit Merchant Management And Report Management Is Correct

[TC-030] Online [BNPL] Purchase with [No Cash, No Fee] On [QR] and [Active Account] and [Active Gateway]
    Given Allocate No Fee 1PAY Account
    And Set channel QR
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway BPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When Performed An Online Purchase
    Then The Purchase Should have Been Successful
    And Record Must Exist In Report
    And Assert Purchase Data In Credit Management, Credit Merchant Management And Report Management Is Correct

[TC-031] Online [BNPL] Purchase with [No Cash, No Fee] On [QR] and [Blocked Account] and [Active Gateway]
    Given Allocate No Fee 1PAY Account
    And Set channel QR
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway BPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    And Block Credit Account
    When Performed An Online Purchase
    Then The Purchase Should Not have Been Successful

[TC-032] Online [BNPL] Purchase with [No Cash, No Fee] On [QR] and [Blocked Account Before Prepare] and [Active Gateway]
    Given Allocate No Fee 1PAY Account
    And Set channel QR
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway BPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When Performed An Initiated Online Purchase
    And Block Credit Account
    And Prepare The Credit Purchase
    And Route Info The Credit Purchase
    And Pay The Credit Purchase
    And Verify The Credit Purchase
    And Deliver The Credit Purchase
    Then The Purchase Should have Been Successful
    And Should Not Have Been Able To Prepare
    And Should Not Have Been Able To Route Info
    And Should Not Have Been Able To Pay
    And Should Not Have Been Able To Verify
    And Should Not Have Been Able To Deliver

[TC-033] Online [BNPL] Purchase with [No Cash, No Fee] On [QR] and [Blocked Account Before Route Info] and [Active Gateway]
    [Tags]    robot:skip
    Given Allocate No Fee 1PAY Account
    And Set channel QR
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway BPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When Performed A Prepared Online Purchase
    And Block Credit Account
    And Route Info The Credit Purchase
    And Pay The Credit Purchase
    And Verify The Credit Purchase
    And Deliver The Credit Purchase
    Then The Purchase Should have Been Successful
    And Should Not Have Been Able To Route Info
    And Should Not Have Been Able To Pay
    And Should Not Have Been Able To Verify
    And Should Not Have Been Able To Deliver

[TC-034] Online [BNPL] Purchase with [No Cash, No Fee] On [QR] and [Blocked Account Before Credit Pay] and [Active Gateway]
    [Tags]    robot:skip
    Given Allocate No Fee 1PAY Account
    And Set channel QR
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway BPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When Performed A Routed Online Purchase
    And Block Credit Account
    And Pay The Credit Purchase
    And Verify The Credit Purchase
    And Deliver The Credit Purchase
    Then The Purchase Should have Been Successful
    And Should Not Have Been Able To Pay
    And Should Not Have Been Able To Verify
    And Should Not Have Been Able To Deliver

[TC-035] Online [BNPL] Purchase with [No Cash, No Fee] On [QR] and [Blocked Account Before Verification] and [Active Gateway]
    [Tags]    robot:skip
    Given Allocate No Fee 1PAY Account
    And Set channel QR
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway BPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When Performed A Paid Online Purchase
    And Block Credit Account
    And Verify The Credit Purchase
    And Deliver The Credit Purchase
    Then The Purchase Should have Been Successful
    And Should Not Have Been Able To Verify
    And Should Not Have Been Able To Deliver

[TC-036] Online [BNPL] Purchase with [No Cash, No Fee] On [QR] and [Blocked Account Before Delivery] and [Active Gateway]
    Given Allocate No Fee 1PAY Account
    And Set channel QR
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway BPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When Performed A Verified Online Purchase
    And Block Credit Account
    And Deliver The Credit Purchase
    Then The Purchase Should have Been Successful
    And Should Have Been Able To Deliver
    And Purchase Status Must Be DELIVERED
    And Assert Purchase Data In Credit Management, Credit Merchant Management And Report Management Is Correct

[TC-037] Online [BNPL] Purchase with [No Cash, No Fee] On [QR] and [Expired Account] and [Active Gateway]
    Given Allocate No Fee 1PAY Account
    And Set channel QR
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway BPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    And Empty Balance
    And Expire Account
    When Performed An Online Purchase
    Then The Purchase Should Not have Been Successful

[TC-038] Online [BNPL] Purchase with [No Cash, No Fee] On [QR] and [Expired Account Before Prepare] and [Active Gateway]
    Given Allocate No Fee 1PAY Account
    And Set channel QR
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway BPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When Performed An Initiated Online Purchase
    And Empty Balance
    And Expire Account
    And Prepare The Credit Purchase
    And Route Info The Credit Purchase
    And Pay The Credit Purchase
    And Verify The Credit Purchase
    And Deliver The Credit Purchase
    Then The Purchase Should have Been Successful
    And Should Not Have Been Able To Prepare
    And Should Not Have Been Able To Route Info
    And Should Not Have Been Able To Pay
    And Should Not Have Been Able To Verify
    And Should Not Have Been Able To Deliver

[TC-039] Online [BNPL] Purchase with [No Cash, No Fee] On [QR] and [Expired Account Before Route Info] and [Active Gateway]
    Given Allocate No Fee 1PAY Account
    And Set channel QR
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway BPG
    And Credit Gateway Activate
    And Set Amount Equal To Balance
    When Performed A Prepared Online Purchase
    And Expire Account
    And Route Info The Credit Purchase
    And Pay The Credit Purchase
    And Verify The Credit Purchase
    And Deliver The Credit Purchase
    Then The Purchase Should have Been Successful
    And Should Have Been Able To Route Info
    And Should Have Been Able To Pay
    And Should Have Been Able To Verify
    And Should Have Been Able To Deliver
    And Assert Purchase Data In Credit Management, Credit Merchant Management And Report Management Is Correct

[TC-040] Online [BNPL] Purchase with [No Cash, No Fee] On [QR] and [Expired Account Before Credit Pay] and [Active Gateway]
    Given Allocate No Fee 1PAY Account
    And Set channel QR
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway BPG
    And Credit Gateway Activate
    And Set Amount Equal To Balance
    When Performed A Routed Online Purchase
    And Expire Account
    And Pay The Credit Purchase
    And Verify The Credit Purchase
    And Deliver The Credit Purchase
    Then The Purchase Should have Been Successful
    And Should Have Been Able To Pay
    And Should Have Been Able To Verify
    And Should Have Been Able To Deliver
    And Assert Purchase Data In Credit Management, Credit Merchant Management And Report Management Is Correct

[TC-041] Online [BNPL] Purchase with [No Cash, No Fee] On [QR] and [Expired Account Before Verification] and [Active Gateway]
    Given Allocate No Fee 1PAY Account
    And Set channel QR
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway BPG
    And Credit Gateway Activate
    And Set Amount Equal To Balance
    When Performed A Paid Online Purchase
    And Expire Account
    And Verify The Credit Purchase
    And Deliver The Credit Purchase
    Then The Purchase Should have Been Successful
    And Should Have Been Able To Verify
    And Should Have Been Able To Deliver
    And Assert Purchase Data In Credit Management, Credit Merchant Management And Report Management Is Correct

[TC-042] Online [BNPL] Purchase with [No Cash, No Fee] On [QR] and [Expired Account Before Delivery] and [Active Gateway]
    Given Allocate No Fee 1PAY Account
    And Set channel QR
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway BPG
    And Credit Gateway Activate
    And Set Amount Equal To Balance
    When Performed A Verified Online Purchase
    And Expire Account
    And Deliver The Credit Purchase
    Then The Purchase Should have Been Successful
    And Should Have Been Able To Deliver
    And Purchase Status Must Be DELIVERED
    And Assert Purchase Data In Credit Management, Credit Merchant Management And Report Management Is Correct

[TC-043] Online [BNPL] Purchase with [No Cash, No Fee] On [QR] and [Expired Account Before Billing Cycle Assign] and [Active Gateway]
    Given Allocate No Fee 1PAY Account
    And Set channel QR
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway BPG
    And Credit Gateway Activate
    And Set Amount Equal To Balance
    When Performed An Online Purchase
    And Expire Account
    And Wait For The Purchase To Be Assigned To The Billing Cycle
    Then The Purchase Should have Been Successful
    And Purchase Should Be Assigned To The Billing Cycle
    And Assert Purchase Data In Credit Management, Credit Merchant Management And Report Management Is Correct

[TC-044] Online [BNPL] Purchase with [No Cash, No Fee] On [QR] and [Zero Balance Account] and [Active Gateway]
    Given Allocate No Fee 1PAY Account
    And Set channel QR
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway BPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    And Empty Balance
    When Performed An Online Purchase
    Then The Purchase Should Not have Been Successful

[TC-045] Online [BNPL] Purchase with [No Cash, No Fee] On [QR] and [Zero Balance Account Before Prepare] and [Active Gateway]
    Given Allocate No Fee 1PAY Account
    And Set channel QR
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway BPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When Performed An Initiated Online Purchase
    And Empty Balance
    And Prepare The Credit Purchase
    And Route Info The Credit Purchase
    And Pay The Credit Purchase
    And Verify The Credit Purchase
    And Deliver The Credit Purchase
    Then The Purchase Should have Been Successful
    And Should Not Have Been Able To Prepare
    And Should Not Have Been Able To Route Info
    And Should Not Have Been Able To Pay
    And Should Not Have Been Able To Verify
    And Should Not Have Been Able To Deliver

[TC-046] Online [BNPL] Purchase with [No Cash, No Fee] On [QR] and [Zero Balance Account Before Route Info] and [Active Gateway]
    Given Allocate No Fee 1PAY Account
    And Set channel QR
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway BPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When Performed A Prepared Online Purchase
    And Empty Balance
    And Route Info The Credit Purchase
    And Pay The Credit Purchase
    And Verify The Credit Purchase
    And Deliver The Credit Purchase
    Then The Purchase Should have Been Successful
    And Should Have Been Able To Route Info
    And Should Not Have Been Able To Pay
    And Should Not Have Been Able To Verify
    And Should Not Have Been Able To Deliver

[TC-047] Online [BNPL] Purchase with [No Cash, No Fee] On [QR] and [Zero Balance Account Before Credit Pay] and [Active Gateway]
    Given Allocate No Fee 1PAY Account
    And Set channel QR
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway BPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When Performed A Routed Online Purchase
    And Empty Balance
    And Pay The Credit Purchase
    And Verify The Credit Purchase
    And Deliver The Credit Purchase
    Then The Purchase Should have Been Successful
    And Should Not Have Been Able To Pay
    And Should Not Have Been Able To Verify
    And Should Not Have Been Able To Deliver

[TC-048] Online [BNPL] Purchase with [No Cash, No Fee] On [QR] and [Zero Balance Account Before Verification] and [Active Gateway]
    Given Allocate No Fee 1PAY Account
    And Set channel QR
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway BPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When Performed A Paid Online Purchase
    And Empty Balance
    And Verify The Credit Purchase
    And Deliver The Credit Purchase
    Then The Purchase Should have Been Successful
    And Should Have Been Able To Verify
    And Should Have Been Able To Deliver
    And Assert Purchase Data In Credit Management, Credit Merchant Management And Report Management Is Correct

[TC-049] Online [BNPL] Purchase with [No Cash, No Fee] On [QR] and [Zero Balance Account Before Delivery] and [Active Gateway]
    Given Allocate No Fee 1PAY Account
    And Set channel QR
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway BPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When Performed A Verified Online Purchase
    And Empty Balance
    And Deliver The Credit Purchase
    Then The Purchase Should have Been Successful
    And Should Have Been Able To Deliver
    And Purchase Status Must Be DELIVERED
    And Assert Purchase Data In Credit Management, Credit Merchant Management And Report Management Is Correct

[TC-050] Online [BNPL] Purchase with [No Cash, No Fee] On [QR] and [Active Account] and [Disabled Gateway]
    Given Allocate No Fee 1PAY Account
    And Set channel QR
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway BPG
    And Set Amount Less Than Balance
    And Credit Gateway Activate
    And Credit Gateway Disable
    When Performed An Online Purchase
    Then The Purchase Should Not have Been Successful

[TC-051] Online [BNPL] Purchase with [No Cash, No Fee] On [QR] and [Blocked Account] and [Disabled Gateway]
    Given Allocate No Fee 1PAY Account
    And Set channel QR
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway BPG
    And Set Amount Less Than Balance
    And Block Credit Account
    And Credit Gateway Activate

    When Performed An Online Purchase
    Then The Purchase Should Not have Been Successful

[TC-052] Online [BNPL] Purchase with [No Cash, No Fee] On [QR] and [Expired Account] and [Disabled Gateway]
    Given Allocate No Fee 1PAY Account
    And Set channel QR
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway BPG
    And Set Amount Less Than Balance
    And Empty Balance
    And Expire Account
    And Credit Gateway Activate

    When Performed An Online Purchase
    Then The Purchase Should Not have Been Successful

[TC-053] Online [BNPL] Purchase with [No Cash, No Fee] On [QR] and [Zero Balance Account] and [Disabled Gateway]
    Given Allocate No Fee 1PAY Account
    And Set channel QR
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway BPG
    And Set Amount Less Than Balance
    And Empty Balance
    And Credit Gateway Activate

    When Performed An Online Purchase
    Then The Purchase Should Not have Been Successful

[TC-054] Online [BNPL] Purchase with [No Cash, No Fee] On [QR] and [Active Account] and [Disabled Gateway Before Prepare]
    [Tags]    robot:skip
    Given Allocate No Fee 1PAY Account
    And Set channel QR
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway BPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When Performed An Initiated Online Purchase

    And Prepare The Credit Purchase
    And Route Info The Credit Purchase
    And Pay The Credit Purchase
    And Verify The Credit Purchase
    And Deliver The Credit Purchase
    Then The Purchase Should have Been Successful
    And Should Have Been Able To Prepare
    And Should Have Been Able To Route Info
    And Should Have Been Able To Pay
    And Should Have Been Able To Verify
    And Should Have Been Able To Deliver
    And Assert Purchase Data In Credit Management, Credit Merchant Management And Report Management Is Correct

[TC-055] Online [BNPL] Purchase with [No Cash, No Fee] On [QR] and [Active Account] and [Disabled Gateway Before Route Info]
    [Tags]    robot:skip
    Given Allocate No Fee 1PAY Account
    And Set channel QR
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway BPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When Performed A Prepared Online Purchase
    And Route Info The Credit Purchase

    And Pay The Credit Purchase
    And Verify The Credit Purchase
    And Deliver The Credit Purchase
    Then The Purchase Should have Been Successful
    And Should Have Been Able To Route Info
    And Should Have Been Able To Pay
    And Should Have Been Able To Verify
    And Should Have Been Able To Deliver
    And Assert Purchase Data In Credit Management, Credit Merchant Management And Report Management Is Correct

[TC-056] Online [BNPL] Purchase with [No Cash, No Fee] On [QR] and [Active Account] and [Disabled Gateway Before Credit Pay]
    [Tags]    robot:skip
    Given Allocate No Fee 1PAY Account
    And Set channel QR
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway BPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When Performed A Routed Online Purchase

    And Pay The Credit Purchase
    And Verify The Credit Purchase
    And Deliver The Credit Purchase
    Then The Purchase Should have Been Successful
    And Should Have Been Able To Pay
    And Should Have Been Able To Verify
    And Should Have Been Able To Deliver
    And Assert Purchase Data In Credit Management, Credit Merchant Management And Report Management Is Correct

[TC-057] Online [BNPL] Purchase with [No Cash, No Fee] On [QR] and [Active Account] and [Disabled Gateway Before Verification]
    [Tags]    robot:skip
    Given Allocate No Fee 1PAY Account
    And Set channel QR
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway BPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When Performed A Paid Online Purchase

    And Verify The Credit Purchase
    And Deliver The Credit Purchase
    Then The Purchase Should have Been Successful
    And Should Have Been Able To Verify
    And Should Have Been Able To Deliver
    And Assert Purchase Data In Credit Management, Credit Merchant Management And Report Management Is Correct

[TC-058] Online [BNPL] Purchase with [No Cash, No Fee] On [QR] and [Active Account] and [Disabled Gateway Before Delivery]
    Given Allocate No Fee 1PAY Account
    And Set channel QR
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway BPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When Performed A Verified Online Purchase

    And Deliver The Credit Purchase
    Then The Purchase Should have Been Successful
    And Should Have Been Able To Deliver
    And Purchase Status Must Be DELIVERED
    And Assert Purchase Data In Credit Management, Credit Merchant Management And Report Management Is Correct

[TC-059] Online [BNPL] Purchase with [No Cash, No Fee] On [PAYMENT_LINK] and [Active Account] and [Active Gateway]
    Given Allocate No Fee 1PAY Account
    And Set channel PAYMENT_LINK
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway BPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When Performed An Online Purchase
    Then The Purchase Should have Been Successful
    And Record Must Exist In Report
    And Assert Purchase Data In Credit Management, Credit Merchant Management And Report Management Is Correct

[TC-060] Online [BNPL] Purchase with [No Cash, No Fee] On [PAYMENT_LINK] and [Blocked Account] and [Active Gateway]
    Given Allocate No Fee 1PAY Account
    And Set channel PAYMENT_LINK
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway BPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    And Block Credit Account
    When Performed An Online Purchase
    Then The Purchase Should Not have Been Successful

[TC-061] Online [BNPL] Purchase with [No Cash, No Fee] On [PAYMENT_LINK] and [Blocked Account Before Prepare] and [Active Gateway]
    Given Allocate No Fee 1PAY Account
    And Set channel PAYMENT_LINK
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway BPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When Performed An Initiated Online Purchase
    And Block Credit Account
    And Prepare The Credit Purchase
    And Route Info The Credit Purchase
    And Pay The Credit Purchase
    And Verify The Credit Purchase
    And Deliver The Credit Purchase
    Then The Purchase Should have Been Successful
    And Should Not Have Been Able To Prepare
    And Should Not Have Been Able To Route Info
    And Should Not Have Been Able To Pay
    And Should Not Have Been Able To Verify
    And Should Not Have Been Able To Deliver

[TC-062] Online [BNPL] Purchase with [No Cash, No Fee] On [PAYMENT_LINK] and [Blocked Account Before Route Info] and [Active Gateway]
    [Tags]    robot:skip
    Given Allocate No Fee 1PAY Account
    And Set channel PAYMENT_LINK
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway BPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When Performed A Prepared Online Purchase
    And Block Credit Account
    And Route Info The Credit Purchase
    And Pay The Credit Purchase
    And Verify The Credit Purchase
    And Deliver The Credit Purchase
    Then The Purchase Should have Been Successful
    And Should Not Have Been Able To Route Info
    And Should Not Have Been Able To Pay
    And Should Not Have Been Able To Verify
    And Should Not Have Been Able To Deliver

[TC-063] Online [BNPL] Purchase with [No Cash, No Fee] On [PAYMENT_LINK] and [Blocked Account Before Credit Pay] and [Active Gateway]
    [Tags]    robot:skip
    Given Allocate No Fee 1PAY Account
    And Set channel PAYMENT_LINK
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway BPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When Performed A Routed Online Purchase
    And Block Credit Account
    And Pay The Credit Purchase
    And Verify The Credit Purchase
    And Deliver The Credit Purchase
    Then The Purchase Should have Been Successful
    And Should Not Have Been Able To Pay
    And Should Not Have Been Able To Verify
    And Should Not Have Been Able To Deliver

[TC-064] Online [BNPL] Purchase with [No Cash, No Fee] On [PAYMENT_LINK] and [Blocked Account Before Verification] and [Active Gateway]
    [Tags]    robot:skip
    Given Allocate No Fee 1PAY Account
    And Set channel PAYMENT_LINK
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway BPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When Performed A Paid Online Purchase
    And Block Credit Account
    And Verify The Credit Purchase
    And Deliver The Credit Purchase
    Then The Purchase Should have Been Successful
    And Should Not Have Been Able To Verify
    And Should Not Have Been Able To Deliver

[TC-065] Online [BNPL] Purchase with [No Cash, No Fee] On [PAYMENT_LINK] and [Blocked Account Before Delivery] and [Active Gateway]
    Given Allocate No Fee 1PAY Account
    And Set channel PAYMENT_LINK
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway BPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When Performed A Verified Online Purchase
    And Block Credit Account
    And Deliver The Credit Purchase
    Then The Purchase Should have Been Successful
    And Should Have Been Able To Deliver
    And Purchase Status Must Be DELIVERED
    And Assert Purchase Data In Credit Management, Credit Merchant Management And Report Management Is Correct

[TC-066] Online [BNPL] Purchase with [No Cash, No Fee] On [PAYMENT_LINK] and [Expired Account] and [Active Gateway]
    Given Allocate No Fee 1PAY Account
    And Set channel PAYMENT_LINK
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway BPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    And Empty Balance
    And Expire Account
    When Performed An Online Purchase
    Then The Purchase Should Not have Been Successful

[TC-067] Online [BNPL] Purchase with [No Cash, No Fee] On [PAYMENT_LINK] and [Expired Account Before Prepare] and [Active Gateway]
    Given Allocate No Fee 1PAY Account
    And Set channel PAYMENT_LINK
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway BPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When Performed An Initiated Online Purchase
    And Empty Balance
    And Expire Account
    And Prepare The Credit Purchase
    And Route Info The Credit Purchase
    And Pay The Credit Purchase
    And Verify The Credit Purchase
    And Deliver The Credit Purchase
    Then The Purchase Should have Been Successful
    And Should Not Have Been Able To Prepare
    And Should Not Have Been Able To Route Info
    And Should Not Have Been Able To Pay
    And Should Not Have Been Able To Verify
    And Should Not Have Been Able To Deliver

[TC-068] Online [BNPL] Purchase with [No Cash, No Fee] On [PAYMENT_LINK] and [Expired Account Before Route Info] and [Active Gateway]
    Given Allocate No Fee 1PAY Account
    And Set channel PAYMENT_LINK
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway BPG
    And Credit Gateway Activate
    And Set Amount Equal To Balance
    When Performed A Prepared Online Purchase
    And Expire Account
    And Route Info The Credit Purchase
    And Pay The Credit Purchase
    And Verify The Credit Purchase
    And Deliver The Credit Purchase
    Then The Purchase Should have Been Successful
    And Should Have Been Able To Route Info
    And Should Have Been Able To Pay
    And Should Have Been Able To Verify
    And Should Have Been Able To Deliver
    And Assert Purchase Data In Credit Management, Credit Merchant Management And Report Management Is Correct

[TC-069] Online [BNPL] Purchase with [No Cash, No Fee] On [PAYMENT_LINK] and [Expired Account Before Credit Pay] and [Active Gateway]
    Given Allocate No Fee 1PAY Account
    And Set channel PAYMENT_LINK
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway BPG
    And Credit Gateway Activate
    And Set Amount Equal To Balance
    When Performed A Routed Online Purchase
    And Expire Account
    And Pay The Credit Purchase
    And Verify The Credit Purchase
    And Deliver The Credit Purchase
    Then The Purchase Should have Been Successful
    And Should Have Been Able To Pay
    And Should Have Been Able To Verify
    And Should Have Been Able To Deliver
    And Assert Purchase Data In Credit Management, Credit Merchant Management And Report Management Is Correct

[TC-070] Online [BNPL] Purchase with [No Cash, No Fee] On [PAYMENT_LINK] and [Expired Account Before Verification] and [Active Gateway]
    Given Allocate No Fee 1PAY Account
    And Set channel PAYMENT_LINK
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway BPG
    And Credit Gateway Activate
    And Set Amount Equal To Balance
    When Performed A Paid Online Purchase
    And Expire Account
    And Verify The Credit Purchase
    And Deliver The Credit Purchase
    Then The Purchase Should have Been Successful
    And Should Have Been Able To Verify
    And Should Have Been Able To Deliver
    And Assert Purchase Data In Credit Management, Credit Merchant Management And Report Management Is Correct

[TC-071] Online [BNPL] Purchase with [No Cash, No Fee] On [PAYMENT_LINK] and [Expired Account Before Delivery] and [Active Gateway]
    Given Allocate No Fee 1PAY Account
    And Set channel PAYMENT_LINK
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway BPG
    And Credit Gateway Activate
    And Set Amount Equal To Balance
    When Performed A Verified Online Purchase
    And Expire Account
    And Deliver The Credit Purchase
    Then The Purchase Should have Been Successful
    And Should Have Been Able To Deliver
    And Purchase Status Must Be DELIVERED
    And Assert Purchase Data In Credit Management, Credit Merchant Management And Report Management Is Correct

[TC-072] Online [BNPL] Purchase with [No Cash, No Fee] On [PAYMENT_LINK] and [Expired Account Before Billing Cycle Assign] and [Active Gateway]
    Given Allocate No Fee 1PAY Account
    And Set channel PAYMENT_LINK
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway BPG
    And Credit Gateway Activate
    And Set Amount Equal To Balance
    When Performed An Online Purchase
    And Expire Account
    And Wait For The Purchase To Be Assigned To The Billing Cycle
    Then The Purchase Should have Been Successful
    And Purchase Should Be Assigned To The Billing Cycle
    And Assert Purchase Data In Credit Management, Credit Merchant Management And Report Management Is Correct

[TC-073] Online [BNPL] Purchase with [No Cash, No Fee] On [PAYMENT_LINK] and [Zero Balance Account] and [Active Gateway]
    Given Allocate No Fee 1PAY Account
    And Set channel PAYMENT_LINK
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway BPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    And Empty Balance
    When Performed An Online Purchase
    Then The Purchase Should Not have Been Successful

[TC-074] Online [BNPL] Purchase with [No Cash, No Fee] On [PAYMENT_LINK] and [Zero Balance Account Before Prepare] and [Active Gateway]
    Given Allocate No Fee 1PAY Account
    And Set channel PAYMENT_LINK
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway BPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When Performed An Initiated Online Purchase
    And Empty Balance
    And Prepare The Credit Purchase
    And Route Info The Credit Purchase
    And Pay The Credit Purchase
    And Verify The Credit Purchase
    And Deliver The Credit Purchase
    Then The Purchase Should have Been Successful
    And Should Not Have Been Able To Prepare
    And Should Not Have Been Able To Route Info
    And Should Not Have Been Able To Pay
    And Should Not Have Been Able To Verify
    And Should Not Have Been Able To Deliver

[TC-075] Online [BNPL] Purchase with [No Cash, No Fee] On [PAYMENT_LINK] and [Zero Balance Account Before Route Info] and [Active Gateway]
    Given Allocate No Fee 1PAY Account
    And Set channel PAYMENT_LINK
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway BPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When Performed A Prepared Online Purchase
    And Empty Balance
    And Route Info The Credit Purchase
    And Pay The Credit Purchase
    And Verify The Credit Purchase
    And Deliver The Credit Purchase
    Then The Purchase Should have Been Successful
    And Should Have Been Able To Route Info
    And Should Not Have Been Able To Pay
    And Should Not Have Been Able To Verify
    And Should Not Have Been Able To Deliver

[TC-076] Online [BNPL] Purchase with [No Cash, No Fee] On [PAYMENT_LINK] and [Zero Balance Account Before Credit Pay] and [Active Gateway]
    Given Allocate No Fee 1PAY Account
    And Set channel PAYMENT_LINK
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway BPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When Performed A Routed Online Purchase
    And Empty Balance
    And Pay The Credit Purchase
    And Verify The Credit Purchase
    And Deliver The Credit Purchase
    Then The Purchase Should have Been Successful
    And Should Not Have Been Able To Pay
    And Should Not Have Been Able To Verify
    And Should Not Have Been Able To Deliver

[TC-077] Online [BNPL] Purchase with [No Cash, No Fee] On [PAYMENT_LINK] and [Zero Balance Account Before Verification] and [Active Gateway]
    Given Allocate No Fee 1PAY Account
    And Set channel PAYMENT_LINK
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway BPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When Performed A Paid Online Purchase
    And Empty Balance
    And Verify The Credit Purchase
    And Deliver The Credit Purchase
    Then The Purchase Should have Been Successful
    And Should Have Been Able To Verify
    And Should Have Been Able To Deliver
    And Assert Purchase Data In Credit Management, Credit Merchant Management And Report Management Is Correct

[TC-078] Online [BNPL] Purchase with [No Cash, No Fee] On [PAYMENT_LINK] and [Zero Balance Account Before Delivery] and [Active Gateway]
    Given Allocate No Fee 1PAY Account
    And Set channel PAYMENT_LINK
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway BPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When Performed A Verified Online Purchase
    And Empty Balance
    And Deliver The Credit Purchase
    Then The Purchase Should have Been Successful
    And Should Have Been Able To Deliver
    And Purchase Status Must Be DELIVERED
    And Assert Purchase Data In Credit Management, Credit Merchant Management And Report Management Is Correct

[TC-079] Online [BNPL] Purchase with [No Cash, No Fee] On [PAYMENT_LINK] and [Active Account] and [Disabled Gateway]
    Given Allocate No Fee 1PAY Account
    And Set channel PAYMENT_LINK
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway BPG
    And Set Amount Less Than Balance
    And Credit Gateway Activate
    And Credit Gateway Disable
    When Performed An Online Purchase
    Then The Purchase Should Not have Been Successful

[TC-080] Online [BNPL] Purchase with [No Cash, No Fee] On [PAYMENT_LINK] and [Blocked Account] and [Disabled Gateway]
    Given Allocate No Fee 1PAY Account
    And Set channel PAYMENT_LINK
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway BPG
    And Set Amount Less Than Balance
    And Block Credit Account
    And Credit Gateway Activate

    When Performed An Online Purchase
    Then The Purchase Should Not have Been Successful

[TC-081] Online [BNPL] Purchase with [No Cash, No Fee] On [PAYMENT_LINK] and [Expired Account] and [Disabled Gateway]
    Given Allocate No Fee 1PAY Account
    And Set channel PAYMENT_LINK
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway BPG
    And Set Amount Less Than Balance
    And Empty Balance
    And Expire Account
    And Credit Gateway Activate

    When Performed An Online Purchase
    Then The Purchase Should Not have Been Successful

[TC-082] Online [BNPL] Purchase with [No Cash, No Fee] On [PAYMENT_LINK] and [Zero Balance Account] and [Disabled Gateway]
    Given Allocate No Fee 1PAY Account
    And Set channel PAYMENT_LINK
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway BPG
    And Set Amount Less Than Balance
    And Empty Balance
    And Credit Gateway Activate

    When Performed An Online Purchase
    Then The Purchase Should Not have Been Successful

[TC-083] Online [BNPL] Purchase with [No Cash, No Fee] On [PAYMENT_LINK] and [Active Account] and [Disabled Gateway Before Prepare]
    [Tags]    robot:skip
    Given Allocate No Fee 1PAY Account
    And Set channel PAYMENT_LINK
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway BPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When Performed An Initiated Online Purchase

    And Prepare The Credit Purchase
    And Route Info The Credit Purchase
    And Pay The Credit Purchase
    And Verify The Credit Purchase
    And Deliver The Credit Purchase
    Then The Purchase Should have Been Successful
    And Should Have Been Able To Prepare
    And Should Have Been Able To Route Info
    And Should Have Been Able To Pay
    And Should Have Been Able To Verify
    And Should Have Been Able To Deliver
    And Assert Purchase Data In Credit Management, Credit Merchant Management And Report Management Is Correct

[TC-084] Online [BNPL] Purchase with [No Cash, No Fee] On [PAYMENT_LINK] and [Active Account] and [Disabled Gateway Before Route Info]
    [Tags]    robot:skip
    Given Allocate No Fee 1PAY Account
    And Set channel PAYMENT_LINK
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway BPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When Performed A Prepared Online Purchase
    And Route Info The Credit Purchase

    And Pay The Credit Purchase
    And Verify The Credit Purchase
    And Deliver The Credit Purchase
    Then The Purchase Should have Been Successful
    And Should Have Been Able To Route Info
    And Should Have Been Able To Pay
    And Should Have Been Able To Verify
    And Should Have Been Able To Deliver
    And Assert Purchase Data In Credit Management, Credit Merchant Management And Report Management Is Correct

[TC-085] Online [BNPL] Purchase with [No Cash, No Fee] On [PAYMENT_LINK] and [Active Account] and [Disabled Gateway Before Credit Pay]
    [Tags]    robot:skip
    Given Allocate No Fee 1PAY Account
    And Set channel PAYMENT_LINK
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway BPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When Performed A Routed Online Purchase

    And Pay The Credit Purchase
    And Verify The Credit Purchase
    And Deliver The Credit Purchase
    Then The Purchase Should have Been Successful
    And Should Have Been Able To Pay
    And Should Have Been Able To Verify
    And Should Have Been Able To Deliver
    And Assert Purchase Data In Credit Management, Credit Merchant Management And Report Management Is Correct

[TC-086] Online [BNPL] Purchase with [No Cash, No Fee] On [PAYMENT_LINK] and [Active Account] and [Disabled Gateway Before Verification]
    [Tags]    robot:skip
    Given Allocate No Fee 1PAY Account
    And Set channel PAYMENT_LINK
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway BPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When Performed A Paid Online Purchase

    And Verify The Credit Purchase
    And Deliver The Credit Purchase
    Then The Purchase Should have Been Successful
    And Should Have Been Able To Verify
    And Should Have Been Able To Deliver
    And Assert Purchase Data In Credit Management, Credit Merchant Management And Report Management Is Correct

[TC-087] Online [BNPL] Purchase with [No Cash, No Fee] On [PAYMENT_LINK] and [Active Account] and [Disabled Gateway Before Delivery]
    Given Allocate No Fee 1PAY Account
    And Set channel PAYMENT_LINK
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway BPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When Performed A Verified Online Purchase

    And Deliver The Credit Purchase
    Then The Purchase Should have Been Successful
    And Should Have Been Able To Deliver
    And Purchase Status Must Be DELIVERED
    And Assert Purchase Data In Credit Management, Credit Merchant Management And Report Management Is Correct

[TC-088] Online [CCREDIT] Purchase with [No Cash, No Fee] On [UPG] and [Active Account] and [Active Gateway]
    Given Allocate No Fee CCREDIT Account
    And Set channel UPG
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway CPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When Performed An Online Purchase
    Then The Purchase Should have Been Successful
    And Record Must Exist In Report
    And Assert Purchase Data In Credit Management, Credit Merchant Management And Report Management Is Correct

[TC-089] Online [CCREDIT] Purchase with [No Cash, No Fee] On [UPG] and [Blocked Account] and [Active Gateway]
    Given Allocate No Fee CCREDIT Account
    And Set channel UPG
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway CPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    And Block Credit Account
    When Performed An Online Purchase
    Then The Purchase Should Not have Been Successful

[TC-090] Online [CCREDIT] Purchase with [No Cash, No Fee] On [UPG] and [Blocked Account Before Prepare] and [Active Gateway]
    Given Allocate No Fee CCREDIT Account
    And Set channel UPG
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway CPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When Performed An Initiated Online Purchase
    And Block Credit Account
    And Prepare The Credit Purchase
    And Route Info The Credit Purchase
    And Pay The Credit Purchase
    And Verify The Credit Purchase
    And Deliver The Credit Purchase
    Then The Purchase Should have Been Successful
    And Should Not Have Been Able To Prepare
    And Should Not Have Been Able To Route Info
    And Should Not Have Been Able To Pay
    And Should Not Have Been Able To Verify
    And Should Not Have Been Able To Deliver

[TC-091] Online [CCREDIT] Purchase with [No Cash, No Fee] On [UPG] and [Blocked Account Before Route Info] and [Active Gateway]
    [Tags]    robot:skip
    Given Allocate No Fee CCREDIT Account
    And Set channel UPG
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway CPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When Performed A Prepared Online Purchase
    And Block Credit Account
    And Route Info The Credit Purchase
    And Pay The Credit Purchase
    And Verify The Credit Purchase
    And Deliver The Credit Purchase
    Then The Purchase Should have Been Successful
    And Should Not Have Been Able To Route Info
    And Should Not Have Been Able To Pay
    And Should Not Have Been Able To Verify
    And Should Not Have Been Able To Deliver

[TC-092] Online [CCREDIT] Purchase with [No Cash, No Fee] On [UPG] and [Blocked Account Before Credit Pay] and [Active Gateway]
    [Tags]    robot:skip
    Given Allocate No Fee CCREDIT Account
    And Set channel UPG
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway CPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When Performed A Routed Online Purchase
    And Block Credit Account
    And Pay The Credit Purchase
    And Verify The Credit Purchase
    And Deliver The Credit Purchase
    Then The Purchase Should have Been Successful
    And Should Not Have Been Able To Pay
    And Should Not Have Been Able To Verify
    And Should Not Have Been Able To Deliver

[TC-093] Online [CCREDIT] Purchase with [No Cash, No Fee] On [UPG] and [Blocked Account Before Verification] and [Active Gateway]
    [Tags]    robot:skip
    Given Allocate No Fee CCREDIT Account
    And Set channel UPG
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway CPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When Performed A Paid Online Purchase
    And Block Credit Account
    And Verify The Credit Purchase
    And Deliver The Credit Purchase
    Then The Purchase Should have Been Successful
    And Should Not Have Been Able To Verify
    And Should Not Have Been Able To Deliver

[TC-094] Online [CCREDIT] Purchase with [No Cash, No Fee] On [UPG] and [Blocked Account Before Delivery] and [Active Gateway]
    Given Allocate No Fee CCREDIT Account
    And Set channel UPG
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway CPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When Performed A Verified Online Purchase
    And Block Credit Account
    And Deliver The Credit Purchase
    Then The Purchase Should have Been Successful
    And Should Have Been Able To Deliver
    And Purchase Status Must Be DELIVERED
    And Assert Purchase Data In Credit Management, Credit Merchant Management And Report Management Is Correct

[TC-095] Online [CCREDIT] Purchase with [No Cash, No Fee] On [UPG] and [Expired Account] and [Active Gateway]
    Given Allocate No Fee CCREDIT Account
    And Set channel UPG
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway CPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    And Empty Balance
    And Expire Account
    When Performed An Online Purchase
    Then The Purchase Should Not have Been Successful

[TC-096] Online [CCREDIT] Purchase with [No Cash, No Fee] On [UPG] and [Expired Account Before Prepare] and [Active Gateway]
    Given Allocate No Fee CCREDIT Account
    And Set channel UPG
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway CPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When Performed An Initiated Online Purchase
    And Empty Balance
    And Expire Account
    And Prepare The Credit Purchase
    And Route Info The Credit Purchase
    And Pay The Credit Purchase
    And Verify The Credit Purchase
    And Deliver The Credit Purchase
    Then The Purchase Should have Been Successful
    And Should Not Have Been Able To Prepare
    And Should Not Have Been Able To Route Info
    And Should Not Have Been Able To Pay
    And Should Not Have Been Able To Verify
    And Should Not Have Been Able To Deliver

[TC-097] Online [CCREDIT] Purchase with [No Cash, No Fee] On [UPG] and [Expired Account Before Route Info] and [Active Gateway]
    Given Allocate No Fee CCREDIT Account
    And Set channel UPG
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway CPG
    And Credit Gateway Activate
    And Set Amount Equal To Balance
    When Performed A Prepared Online Purchase
    And Expire Account
    And Route Info The Credit Purchase
    And Pay The Credit Purchase
    And Verify The Credit Purchase
    And Deliver The Credit Purchase
    Then The Purchase Should have Been Successful
    And Should Have Been Able To Route Info
    And Should Have Been Able To Pay
    And Should Have Been Able To Verify
    And Should Have Been Able To Deliver
    And Assert Purchase Data In Credit Management, Credit Merchant Management And Report Management Is Correct

[TC-098] Online [CCREDIT] Purchase with [No Cash, No Fee] On [UPG] and [Expired Account Before Credit Pay] and [Active Gateway]
    Given Allocate No Fee CCREDIT Account
    And Set channel UPG
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway CPG
    And Credit Gateway Activate
    And Set Amount Equal To Balance
    When Performed A Routed Online Purchase
    And Expire Account
    And Pay The Credit Purchase
    And Verify The Credit Purchase
    And Deliver The Credit Purchase
    Then The Purchase Should have Been Successful
    And Should Have Been Able To Pay
    And Should Have Been Able To Verify
    And Should Have Been Able To Deliver
    And Assert Purchase Data In Credit Management, Credit Merchant Management And Report Management Is Correct

[TC-099] Online [CCREDIT] Purchase with [No Cash, No Fee] On [UPG] and [Expired Account Before Verification] and [Active Gateway]
    Given Allocate No Fee CCREDIT Account
    And Set channel UPG
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway CPG
    And Credit Gateway Activate
    And Set Amount Equal To Balance
    When Performed A Paid Online Purchase
    And Expire Account
    And Verify The Credit Purchase
    And Deliver The Credit Purchase
    Then The Purchase Should have Been Successful
    And Should Have Been Able To Verify
    And Should Have Been Able To Deliver
    And Assert Purchase Data In Credit Management, Credit Merchant Management And Report Management Is Correct

[TC-100] Online [CCREDIT] Purchase with [No Cash, No Fee] On [UPG] and [Expired Account Before Delivery] and [Active Gateway]
    Given Allocate No Fee CCREDIT Account
    And Set channel UPG
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway CPG
    And Credit Gateway Activate
    And Set Amount Equal To Balance
    When Performed A Verified Online Purchase
    And Expire Account
    And Deliver The Credit Purchase
    Then The Purchase Should have Been Successful
    And Should Have Been Able To Deliver
    And Purchase Status Must Be DELIVERED
    And Assert Purchase Data In Credit Management, Credit Merchant Management And Report Management Is Correct

[TC-101] Online [CCREDIT] Purchase with [No Cash, No Fee] On [UPG] and [Expired Account Before Billing Cycle Assign] and [Active Gateway]
    Given Allocate No Fee CCREDIT Account
    And Set channel UPG
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway CPG
    And Credit Gateway Activate
    And Set Amount Equal To Balance
    When Performed An Online Purchase
    And Expire Account
    And Wait For The Purchase To Be Assigned To The Billing Cycle
    Then The Purchase Should have Been Successful
    And Purchase Should Be Assigned To The Billing Cycle
    And Assert Purchase Data In Credit Management, Credit Merchant Management And Report Management Is Correct

[TC-102] Online [CCREDIT] Purchase with [No Cash, No Fee] On [UPG] and [Zero Balance Account] and [Active Gateway]
    Given Allocate No Fee CCREDIT Account
    And Set channel UPG
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway CPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    And Empty Balance
    When Performed An Online Purchase
    Then The Purchase Should Not have Been Successful

[TC-103] Online [CCREDIT] Purchase with [No Cash, No Fee] On [UPG] and [Zero Balance Account Before Prepare] and [Active Gateway]
    Given Allocate No Fee CCREDIT Account
    And Set channel UPG
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway CPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When Performed An Initiated Online Purchase
    And Empty Balance
    And Prepare The Credit Purchase
    And Route Info The Credit Purchase
    And Pay The Credit Purchase
    And Verify The Credit Purchase
    And Deliver The Credit Purchase
    Then The Purchase Should have Been Successful
    And Should Not Have Been Able To Prepare
    And Should Not Have Been Able To Route Info
    And Should Not Have Been Able To Pay
    And Should Not Have Been Able To Verify
    And Should Not Have Been Able To Deliver

[TC-104] Online [CCREDIT] Purchase with [No Cash, No Fee] On [UPG] and [Zero Balance Account Before Route Info] and [Active Gateway]
    Given Allocate No Fee CCREDIT Account
    And Set channel UPG
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway CPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When Performed A Prepared Online Purchase
    And Empty Balance
    And Route Info The Credit Purchase
    And Pay The Credit Purchase
    And Verify The Credit Purchase
    And Deliver The Credit Purchase
    Then The Purchase Should have Been Successful
    And Should Have Been Able To Route Info
    And Should Not Have Been Able To Pay
    And Should Not Have Been Able To Verify
    And Should Not Have Been Able To Deliver

[TC-105] Online [CCREDIT] Purchase with [No Cash, No Fee] On [UPG] and [Zero Balance Account Before Credit Pay] and [Active Gateway]
    Given Allocate No Fee CCREDIT Account
    And Set channel UPG
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway CPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When Performed A Routed Online Purchase
    And Empty Balance
    And Pay The Credit Purchase
    And Verify The Credit Purchase
    And Deliver The Credit Purchase
    Then The Purchase Should have Been Successful
    And Should Not Have Been Able To Pay
    And Should Not Have Been Able To Verify
    And Should Not Have Been Able To Deliver

[TC-106] Online [CCREDIT] Purchase with [No Cash, No Fee] On [UPG] and [Zero Balance Account Before Verification] and [Active Gateway]
    Given Allocate No Fee CCREDIT Account
    And Set channel UPG
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway CPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When Performed A Paid Online Purchase
    And Empty Balance
    And Verify The Credit Purchase
    And Deliver The Credit Purchase
    Then The Purchase Should have Been Successful
    And Should Have Been Able To Verify
    And Should Have Been Able To Deliver
    And Assert Purchase Data In Credit Management, Credit Merchant Management And Report Management Is Correct

[TC-107] Online [CCREDIT] Purchase with [No Cash, No Fee] On [UPG] and [Zero Balance Account Before Delivery] and [Active Gateway]
    Given Allocate No Fee CCREDIT Account
    And Set channel UPG
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway CPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When Performed A Verified Online Purchase
    And Empty Balance
    And Deliver The Credit Purchase
    Then The Purchase Should have Been Successful
    And Should Have Been Able To Deliver
    And Purchase Status Must Be DELIVERED
    And Assert Purchase Data In Credit Management, Credit Merchant Management And Report Management Is Correct

[TC-108] Online [CCREDIT] Purchase with [No Cash, No Fee] On [UPG] and [Active Account] and [Disabled Gateway]
    Given Allocate No Fee CCREDIT Account
    And Set channel UPG
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway CPG
    And Set Amount Less Than Balance
    And Credit Gateway Activate
    And Credit Gateway Disable
    When Performed An Online Purchase
    Then The Purchase Should Not have Been Successful

[TC-109] Online [CCREDIT] Purchase with [No Cash, No Fee] On [UPG] and [Blocked Account] and [Disabled Gateway]
    Given Allocate No Fee CCREDIT Account
    And Set channel UPG
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway CPG
    And Set Amount Less Than Balance
    And Block Credit Account
    And Credit Gateway Activate

    When Performed An Online Purchase
    Then The Purchase Should Not have Been Successful

[TC-110] Online [CCREDIT] Purchase with [No Cash, No Fee] On [UPG] and [Expired Account] and [Disabled Gateway]
    Given Allocate No Fee CCREDIT Account
    And Set channel UPG
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway CPG
    And Set Amount Less Than Balance
    And Empty Balance
    And Expire Account
    And Credit Gateway Activate

    When Performed An Online Purchase
    Then The Purchase Should Not have Been Successful

[TC-111] Online [CCREDIT] Purchase with [No Cash, No Fee] On [UPG] and [Zero Balance Account] and [Disabled Gateway]
    Given Allocate No Fee CCREDIT Account
    And Set channel UPG
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway CPG
    And Set Amount Less Than Balance
    And Empty Balance
    And Credit Gateway Activate

    When Performed An Online Purchase
    Then The Purchase Should Not have Been Successful

[TC-112] Online [CCREDIT] Purchase with [No Cash, No Fee] On [UPG] and [Active Account] and [Disabled Gateway Before Prepare]
    [Tags]    robot:skip
    Given Allocate No Fee CCREDIT Account
    And Set channel UPG
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway CPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When Performed An Initiated Online Purchase

    And Prepare The Credit Purchase
    And Route Info The Credit Purchase
    And Pay The Credit Purchase
    And Verify The Credit Purchase
    And Deliver The Credit Purchase
    Then The Purchase Should have Been Successful
    And Should Have Been Able To Prepare
    And Should Have Been Able To Route Info
    And Should Have Been Able To Pay
    And Should Have Been Able To Verify
    And Should Have Been Able To Deliver
    And Assert Purchase Data In Credit Management, Credit Merchant Management And Report Management Is Correct

[TC-113] Online [CCREDIT] Purchase with [No Cash, No Fee] On [UPG] and [Active Account] and [Disabled Gateway Before Route Info]
    [Tags]    robot:skip
    Given Allocate No Fee CCREDIT Account
    And Set channel UPG
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway CPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When Performed A Prepared Online Purchase
    And Route Info The Credit Purchase

    And Pay The Credit Purchase
    And Verify The Credit Purchase
    And Deliver The Credit Purchase
    Then The Purchase Should have Been Successful
    And Should Have Been Able To Route Info
    And Should Have Been Able To Pay
    And Should Have Been Able To Verify
    And Should Have Been Able To Deliver
    And Assert Purchase Data In Credit Management, Credit Merchant Management And Report Management Is Correct

[TC-114] Online [CCREDIT] Purchase with [No Cash, No Fee] On [UPG] and [Active Account] and [Disabled Gateway Before Credit Pay]
    [Tags]    robot:skip
    Given Allocate No Fee CCREDIT Account
    And Set channel UPG
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway CPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When Performed A Routed Online Purchase

    And Pay The Credit Purchase
    And Verify The Credit Purchase
    And Deliver The Credit Purchase
    Then The Purchase Should have Been Successful
    And Should Have Been Able To Pay
    And Should Have Been Able To Verify
    And Should Have Been Able To Deliver
    And Assert Purchase Data In Credit Management, Credit Merchant Management And Report Management Is Correct

[TC-115] Online [CCREDIT] Purchase with [No Cash, No Fee] On [UPG] and [Active Account] and [Disabled Gateway Before Verification]
    [Tags]    robot:skip
    Given Allocate No Fee CCREDIT Account
    And Set channel UPG
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway CPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When Performed A Paid Online Purchase

    And Verify The Credit Purchase
    And Deliver The Credit Purchase
    Then The Purchase Should have Been Successful
    And Should Have Been Able To Verify
    And Should Have Been Able To Deliver
    And Assert Purchase Data In Credit Management, Credit Merchant Management And Report Management Is Correct

[TC-116] Online [CCREDIT] Purchase with [No Cash, No Fee] On [UPG] and [Active Account] and [Disabled Gateway Before Delivery]
    Given Allocate No Fee CCREDIT Account
    And Set channel UPG
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway CPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When Performed A Verified Online Purchase

    And Deliver The Credit Purchase
    Then The Purchase Should have Been Successful
    And Should Have Been Able To Deliver
    And Purchase Status Must Be DELIVERED
    And Assert Purchase Data In Credit Management, Credit Merchant Management And Report Management Is Correct

[TC-117] Online [CCREDIT] Purchase with [No Cash, No Fee] On [QR] and [Active Account] and [Active Gateway]
    Given Allocate No Fee CCREDIT Account
    And Set channel QR
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway CPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When Performed An Online Purchase
    Then The Purchase Should have Been Successful
    And Record Must Exist In Report
    And Assert Purchase Data In Credit Management, Credit Merchant Management And Report Management Is Correct

[TC-118] Online [CCREDIT] Purchase with [No Cash, No Fee] On [QR] and [Blocked Account] and [Active Gateway]
    Given Allocate No Fee CCREDIT Account
    And Set channel QR
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway CPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    And Block Credit Account
    When Performed An Online Purchase
    Then The Purchase Should Not have Been Successful

[TC-119] Online [CCREDIT] Purchase with [No Cash, No Fee] On [QR] and [Blocked Account Before Prepare] and [Active Gateway]
    Given Allocate No Fee CCREDIT Account
    And Set channel QR
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway CPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When Performed An Initiated Online Purchase
    And Block Credit Account
    And Prepare The Credit Purchase
    And Route Info The Credit Purchase
    And Pay The Credit Purchase
    And Verify The Credit Purchase
    And Deliver The Credit Purchase
    Then The Purchase Should have Been Successful
    And Should Not Have Been Able To Prepare
    And Should Not Have Been Able To Route Info
    And Should Not Have Been Able To Pay
    And Should Not Have Been Able To Verify
    And Should Not Have Been Able To Deliver

[TC-120] Online [CCREDIT] Purchase with [No Cash, No Fee] On [QR] and [Blocked Account Before Route Info] and [Active Gateway]
    [Tags]    robot:skip
    Given Allocate No Fee CCREDIT Account
    And Set channel QR
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway CPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When Performed A Prepared Online Purchase
    And Block Credit Account
    And Route Info The Credit Purchase
    And Pay The Credit Purchase
    And Verify The Credit Purchase
    And Deliver The Credit Purchase
    Then The Purchase Should have Been Successful
    And Should Not Have Been Able To Route Info
    And Should Not Have Been Able To Pay
    And Should Not Have Been Able To Verify
    And Should Not Have Been Able To Deliver

[TC-121] Online [CCREDIT] Purchase with [No Cash, No Fee] On [QR] and [Blocked Account Before Credit Pay] and [Active Gateway]
    [Tags]    robot:skip
    Given Allocate No Fee CCREDIT Account
    And Set channel QR
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway CPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When Performed A Routed Online Purchase
    And Block Credit Account
    And Pay The Credit Purchase
    And Verify The Credit Purchase
    And Deliver The Credit Purchase
    Then The Purchase Should have Been Successful
    And Should Not Have Been Able To Pay
    And Should Not Have Been Able To Verify
    And Should Not Have Been Able To Deliver

[TC-122] Online [CCREDIT] Purchase with [No Cash, No Fee] On [QR] and [Blocked Account Before Verification] and [Active Gateway]
    [Tags]    robot:skip
    Given Allocate No Fee CCREDIT Account
    And Set channel QR
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway CPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When Performed A Paid Online Purchase
    And Block Credit Account
    And Verify The Credit Purchase
    And Deliver The Credit Purchase
    Then The Purchase Should have Been Successful
    And Should Not Have Been Able To Verify
    And Should Not Have Been Able To Deliver

[TC-123] Online [CCREDIT] Purchase with [No Cash, No Fee] On [QR] and [Blocked Account Before Delivery] and [Active Gateway]
    Given Allocate No Fee CCREDIT Account
    And Set channel QR
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway CPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When Performed A Verified Online Purchase
    And Block Credit Account
    And Deliver The Credit Purchase
    Then The Purchase Should have Been Successful
    And Should Have Been Able To Deliver
    And Purchase Status Must Be DELIVERED
    And Assert Purchase Data In Credit Management, Credit Merchant Management And Report Management Is Correct

[TC-124] Online [CCREDIT] Purchase with [No Cash, No Fee] On [QR] and [Expired Account] and [Active Gateway]
    Given Allocate No Fee CCREDIT Account
    And Set channel QR
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway CPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    And Empty Balance
    And Expire Account
    When Performed An Online Purchase
    Then The Purchase Should Not have Been Successful

[TC-125] Online [CCREDIT] Purchase with [No Cash, No Fee] On [QR] and [Expired Account Before Prepare] and [Active Gateway]
    Given Allocate No Fee CCREDIT Account
    And Set channel QR
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway CPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When Performed An Initiated Online Purchase
    And Empty Balance
    And Expire Account
    And Prepare The Credit Purchase
    And Route Info The Credit Purchase
    And Pay The Credit Purchase
    And Verify The Credit Purchase
    And Deliver The Credit Purchase
    Then The Purchase Should have Been Successful
    And Should Not Have Been Able To Prepare
    And Should Not Have Been Able To Route Info
    And Should Not Have Been Able To Pay
    And Should Not Have Been Able To Verify
    And Should Not Have Been Able To Deliver

[TC-126] Online [CCREDIT] Purchase with [No Cash, No Fee] On [QR] and [Expired Account Before Route Info] and [Active Gateway]
    Given Allocate No Fee CCREDIT Account
    And Set channel QR
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway CPG
    And Credit Gateway Activate
    And Set Amount Equal To Balance
    When Performed A Prepared Online Purchase
    And Expire Account
    And Route Info The Credit Purchase
    And Pay The Credit Purchase
    And Verify The Credit Purchase
    And Deliver The Credit Purchase
    Then The Purchase Should have Been Successful
    And Should Have Been Able To Route Info
    And Should Have Been Able To Pay
    And Should Have Been Able To Verify
    And Should Have Been Able To Deliver
    And Assert Purchase Data In Credit Management, Credit Merchant Management And Report Management Is Correct

[TC-127] Online [CCREDIT] Purchase with [No Cash, No Fee] On [QR] and [Expired Account Before Credit Pay] and [Active Gateway]
    Given Allocate No Fee CCREDIT Account
    And Set channel QR
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway CPG
    And Credit Gateway Activate
    And Set Amount Equal To Balance
    When Performed A Routed Online Purchase
    And Expire Account
    And Pay The Credit Purchase
    And Verify The Credit Purchase
    And Deliver The Credit Purchase
    Then The Purchase Should have Been Successful
    And Should Have Been Able To Pay
    And Should Have Been Able To Verify
    And Should Have Been Able To Deliver
    And Assert Purchase Data In Credit Management, Credit Merchant Management And Report Management Is Correct

[TC-128] Online [CCREDIT] Purchase with [No Cash, No Fee] On [QR] and [Expired Account Before Verification] and [Active Gateway]
    Given Allocate No Fee CCREDIT Account
    And Set channel QR
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway CPG
    And Credit Gateway Activate
    And Set Amount Equal To Balance
    When Performed A Paid Online Purchase
    And Expire Account
    And Verify The Credit Purchase
    And Deliver The Credit Purchase
    Then The Purchase Should have Been Successful
    And Should Have Been Able To Verify
    And Should Have Been Able To Deliver
    And Assert Purchase Data In Credit Management, Credit Merchant Management And Report Management Is Correct

[TC-129] Online [CCREDIT] Purchase with [No Cash, No Fee] On [QR] and [Expired Account Before Delivery] and [Active Gateway]
    Given Allocate No Fee CCREDIT Account
    And Set channel QR
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway CPG
    And Credit Gateway Activate
    And Set Amount Equal To Balance
    When Performed A Verified Online Purchase
    And Expire Account
    And Deliver The Credit Purchase
    Then The Purchase Should have Been Successful
    And Should Have Been Able To Deliver
    And Purchase Status Must Be DELIVERED
    And Assert Purchase Data In Credit Management, Credit Merchant Management And Report Management Is Correct

[TC-130] Online [CCREDIT] Purchase with [No Cash, No Fee] On [QR] and [Expired Account Before Billing Cycle Assign] and [Active Gateway]
    Given Allocate No Fee CCREDIT Account
    And Set channel QR
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway CPG
    And Credit Gateway Activate
    And Set Amount Equal To Balance
    When Performed An Online Purchase
    And Expire Account
    And Wait For The Purchase To Be Assigned To The Billing Cycle
    Then The Purchase Should have Been Successful
    And Purchase Should Be Assigned To The Billing Cycle
    And Assert Purchase Data In Credit Management, Credit Merchant Management And Report Management Is Correct

[TC-131] Online [CCREDIT] Purchase with [No Cash, No Fee] On [QR] and [Zero Balance Account] and [Active Gateway]
    Given Allocate No Fee CCREDIT Account
    And Set channel QR
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway CPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    And Empty Balance
    When Performed An Online Purchase
    Then The Purchase Should Not have Been Successful

[TC-132] Online [CCREDIT] Purchase with [No Cash, No Fee] On [QR] and [Zero Balance Account Before Prepare] and [Active Gateway]
    Given Allocate No Fee CCREDIT Account
    And Set channel QR
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway CPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When Performed An Initiated Online Purchase
    And Empty Balance
    And Prepare The Credit Purchase
    And Route Info The Credit Purchase
    And Pay The Credit Purchase
    And Verify The Credit Purchase
    And Deliver The Credit Purchase
    Then The Purchase Should have Been Successful
    And Should Not Have Been Able To Prepare
    And Should Not Have Been Able To Route Info
    And Should Not Have Been Able To Pay
    And Should Not Have Been Able To Verify
    And Should Not Have Been Able To Deliver

[TC-133] Online [CCREDIT] Purchase with [No Cash, No Fee] On [QR] and [Zero Balance Account Before Route Info] and [Active Gateway]
    Given Allocate No Fee CCREDIT Account
    And Set channel QR
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway CPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When Performed A Prepared Online Purchase
    And Empty Balance
    And Route Info The Credit Purchase
    And Pay The Credit Purchase
    And Verify The Credit Purchase
    And Deliver The Credit Purchase
    Then The Purchase Should have Been Successful
    And Should Have Been Able To Route Info
    And Should Not Have Been Able To Pay
    And Should Not Have Been Able To Verify
    And Should Not Have Been Able To Deliver

[TC-134] Online [CCREDIT] Purchase with [No Cash, No Fee] On [QR] and [Zero Balance Account Before Credit Pay] and [Active Gateway]
    Given Allocate No Fee CCREDIT Account
    And Set channel QR
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway CPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When Performed A Routed Online Purchase
    And Empty Balance
    And Pay The Credit Purchase
    And Verify The Credit Purchase
    And Deliver The Credit Purchase
    Then The Purchase Should have Been Successful
    And Should Not Have Been Able To Pay
    And Should Not Have Been Able To Verify
    And Should Not Have Been Able To Deliver

[TC-135] Online [CCREDIT] Purchase with [No Cash, No Fee] On [QR] and [Zero Balance Account Before Verification] and [Active Gateway]
    Given Allocate No Fee CCREDIT Account
    And Set channel QR
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway CPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When Performed A Paid Online Purchase
    And Empty Balance
    And Verify The Credit Purchase
    And Deliver The Credit Purchase
    Then The Purchase Should have Been Successful
    And Should Have Been Able To Verify
    And Should Have Been Able To Deliver
    And Assert Purchase Data In Credit Management, Credit Merchant Management And Report Management Is Correct

[TC-136] Online [CCREDIT] Purchase with [No Cash, No Fee] On [QR] and [Zero Balance Account Before Delivery] and [Active Gateway]
    Given Allocate No Fee CCREDIT Account
    And Set channel QR
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway CPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When Performed A Verified Online Purchase
    And Empty Balance
    And Deliver The Credit Purchase
    Then The Purchase Should have Been Successful
    And Should Have Been Able To Deliver
    And Purchase Status Must Be DELIVERED
    And Assert Purchase Data In Credit Management, Credit Merchant Management And Report Management Is Correct

[TC-137] Online [CCREDIT] Purchase with [No Cash, No Fee] On [QR] and [Active Account] and [Disabled Gateway]
    Given Allocate No Fee CCREDIT Account
    And Set channel QR
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway CPG
    And Set Amount Less Than Balance
    And Credit Gateway Activate
    And Credit Gateway Disable
    When Performed An Online Purchase
    Then The Purchase Should Not have Been Successful

[TC-138] Online [CCREDIT] Purchase with [No Cash, No Fee] On [QR] and [Blocked Account] and [Disabled Gateway]
    Given Allocate No Fee CCREDIT Account
    And Set channel QR
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway CPG
    And Set Amount Less Than Balance
    And Block Credit Account
    And Credit Gateway Activate

    When Performed An Online Purchase
    Then The Purchase Should Not have Been Successful

[TC-139] Online [CCREDIT] Purchase with [No Cash, No Fee] On [QR] and [Expired Account] and [Disabled Gateway]
    Given Allocate No Fee CCREDIT Account
    And Set channel QR
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway CPG
    And Set Amount Less Than Balance
    And Empty Balance
    And Expire Account
    And Credit Gateway Activate

    When Performed An Online Purchase
    Then The Purchase Should Not have Been Successful

[TC-140] Online [CCREDIT] Purchase with [No Cash, No Fee] On [QR] and [Zero Balance Account] and [Disabled Gateway]
    Given Allocate No Fee CCREDIT Account
    And Set channel QR
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway CPG
    And Set Amount Less Than Balance
    And Empty Balance
    And Credit Gateway Activate

    When Performed An Online Purchase
    Then The Purchase Should Not have Been Successful

[TC-141] Online [CCREDIT] Purchase with [No Cash, No Fee] On [QR] and [Active Account] and [Disabled Gateway Before Prepare]
    [Tags]    robot:skip
    Given Allocate No Fee CCREDIT Account
    And Set channel QR
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway CPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When Performed An Initiated Online Purchase

    And Prepare The Credit Purchase
    And Route Info The Credit Purchase
    And Pay The Credit Purchase
    And Verify The Credit Purchase
    And Deliver The Credit Purchase
    Then The Purchase Should have Been Successful
    And Should Have Been Able To Prepare
    And Should Have Been Able To Route Info
    And Should Have Been Able To Pay
    And Should Have Been Able To Verify
    And Should Have Been Able To Deliver
    And Assert Purchase Data In Credit Management, Credit Merchant Management And Report Management Is Correct

[TC-142] Online [CCREDIT] Purchase with [No Cash, No Fee] On [QR] and [Active Account] and [Disabled Gateway Before Route Info]
    [Tags]    robot:skip
    Given Allocate No Fee CCREDIT Account
    And Set channel QR
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway CPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When Performed A Prepared Online Purchase
    And Route Info The Credit Purchase

    And Pay The Credit Purchase
    And Verify The Credit Purchase
    And Deliver The Credit Purchase
    Then The Purchase Should have Been Successful
    And Should Have Been Able To Route Info
    And Should Have Been Able To Pay
    And Should Have Been Able To Verify
    And Should Have Been Able To Deliver
    And Assert Purchase Data In Credit Management, Credit Merchant Management And Report Management Is Correct

[TC-143] Online [CCREDIT] Purchase with [No Cash, No Fee] On [QR] and [Active Account] and [Disabled Gateway Before Credit Pay]
    [Tags]    robot:skip
    Given Allocate No Fee CCREDIT Account
    And Set channel QR
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway CPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When Performed A Routed Online Purchase

    And Pay The Credit Purchase
    And Verify The Credit Purchase
    And Deliver The Credit Purchase
    Then The Purchase Should have Been Successful
    And Should Have Been Able To Pay
    And Should Have Been Able To Verify
    And Should Have Been Able To Deliver
    And Assert Purchase Data In Credit Management, Credit Merchant Management And Report Management Is Correct

[TC-144] Online [CCREDIT] Purchase with [No Cash, No Fee] On [QR] and [Active Account] and [Disabled Gateway Before Verification]
    [Tags]    robot:skip
    Given Allocate No Fee CCREDIT Account
    And Set channel QR
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway CPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When Performed A Paid Online Purchase

    And Verify The Credit Purchase
    And Deliver The Credit Purchase
    Then The Purchase Should have Been Successful
    And Should Have Been Able To Verify
    And Should Have Been Able To Deliver
    And Assert Purchase Data In Credit Management, Credit Merchant Management And Report Management Is Correct

[TC-145] Online [CCREDIT] Purchase with [No Cash, No Fee] On [QR] and [Active Account] and [Disabled Gateway Before Delivery]
    Given Allocate No Fee CCREDIT Account
    And Set channel QR
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway CPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When Performed A Verified Online Purchase

    And Deliver The Credit Purchase
    Then The Purchase Should have Been Successful
    And Should Have Been Able To Deliver
    And Purchase Status Must Be DELIVERED
    And Assert Purchase Data In Credit Management, Credit Merchant Management And Report Management Is Correct

[TC-146] Online [CCREDIT] Purchase with [No Cash, No Fee] On [PAYMENT_LINK] and [Active Account] and [Active Gateway]
    Given Allocate No Fee CCREDIT Account
    And Set channel PAYMENT_LINK
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway CPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When Performed An Online Purchase
    Then The Purchase Should have Been Successful
    And Record Must Exist In Report
    And Assert Purchase Data In Credit Management, Credit Merchant Management And Report Management Is Correct

[TC-147] Online [CCREDIT] Purchase with [No Cash, No Fee] On [PAYMENT_LINK] and [Blocked Account] and [Active Gateway]
    Given Allocate No Fee CCREDIT Account
    And Set channel PAYMENT_LINK
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway CPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    And Block Credit Account
    When Performed An Online Purchase
    Then The Purchase Should Not have Been Successful

[TC-148] Online [CCREDIT] Purchase with [No Cash, No Fee] On [PAYMENT_LINK] and [Blocked Account Before Prepare] and [Active Gateway]
    Given Allocate No Fee CCREDIT Account
    And Set channel PAYMENT_LINK
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway CPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When Performed An Initiated Online Purchase
    And Block Credit Account
    And Prepare The Credit Purchase
    And Route Info The Credit Purchase
    And Pay The Credit Purchase
    And Verify The Credit Purchase
    And Deliver The Credit Purchase
    Then The Purchase Should have Been Successful
    And Should Not Have Been Able To Prepare
    And Should Not Have Been Able To Route Info
    And Should Not Have Been Able To Pay
    And Should Not Have Been Able To Verify
    And Should Not Have Been Able To Deliver

[TC-149] Online [CCREDIT] Purchase with [No Cash, No Fee] On [PAYMENT_LINK] and [Blocked Account Before Route Info] and [Active Gateway]
    [Tags]    robot:skip
    Given Allocate No Fee CCREDIT Account
    And Set channel PAYMENT_LINK
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway CPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When Performed A Prepared Online Purchase
    And Block Credit Account
    And Route Info The Credit Purchase
    And Pay The Credit Purchase
    And Verify The Credit Purchase
    And Deliver The Credit Purchase
    Then The Purchase Should have Been Successful
    And Should Not Have Been Able To Route Info
    And Should Not Have Been Able To Pay
    And Should Not Have Been Able To Verify
    And Should Not Have Been Able To Deliver

[TC-150] Online [CCREDIT] Purchase with [No Cash, No Fee] On [PAYMENT_LINK] and [Blocked Account Before Credit Pay] and [Active Gateway]
    [Tags]    robot:skip
    Given Allocate No Fee CCREDIT Account
    And Set channel PAYMENT_LINK
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway CPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When Performed A Routed Online Purchase
    And Block Credit Account
    And Pay The Credit Purchase
    And Verify The Credit Purchase
    And Deliver The Credit Purchase
    Then The Purchase Should have Been Successful
    And Should Not Have Been Able To Pay
    And Should Not Have Been Able To Verify
    And Should Not Have Been Able To Deliver

[TC-151] Online [CCREDIT] Purchase with [No Cash, No Fee] On [PAYMENT_LINK] and [Blocked Account Before Verification] and [Active Gateway]
    [Tags]    robot:skip
    Given Allocate No Fee CCREDIT Account
    And Set channel PAYMENT_LINK
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway CPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When Performed A Paid Online Purchase
    And Block Credit Account
    And Verify The Credit Purchase
    And Deliver The Credit Purchase
    Then The Purchase Should have Been Successful
    And Should Not Have Been Able To Verify
    And Should Not Have Been Able To Deliver

[TC-152] Online [CCREDIT] Purchase with [No Cash, No Fee] On [PAYMENT_LINK] and [Blocked Account Before Delivery] and [Active Gateway]
    Given Allocate No Fee CCREDIT Account
    And Set channel PAYMENT_LINK
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway CPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When Performed A Verified Online Purchase
    And Block Credit Account
    And Deliver The Credit Purchase
    Then The Purchase Should have Been Successful
    And Should Have Been Able To Deliver
    And Purchase Status Must Be DELIVERED
    And Assert Purchase Data In Credit Management, Credit Merchant Management And Report Management Is Correct

[TC-153] Online [CCREDIT] Purchase with [No Cash, No Fee] On [PAYMENT_LINK] and [Expired Account] and [Active Gateway]
    Given Allocate No Fee CCREDIT Account
    And Set channel PAYMENT_LINK
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway CPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    And Empty Balance
    And Expire Account
    When Performed An Online Purchase
    Then The Purchase Should Not have Been Successful

[TC-154] Online [CCREDIT] Purchase with [No Cash, No Fee] On [PAYMENT_LINK] and [Expired Account Before Prepare] and [Active Gateway]
    Given Allocate No Fee CCREDIT Account
    And Set channel PAYMENT_LINK
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway CPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When Performed An Initiated Online Purchase
    And Empty Balance
    And Expire Account
    And Prepare The Credit Purchase
    And Route Info The Credit Purchase
    And Pay The Credit Purchase
    And Verify The Credit Purchase
    And Deliver The Credit Purchase
    Then The Purchase Should have Been Successful
    And Should Not Have Been Able To Prepare
    And Should Not Have Been Able To Route Info
    And Should Not Have Been Able To Pay
    And Should Not Have Been Able To Verify
    And Should Not Have Been Able To Deliver

[TC-155] Online [CCREDIT] Purchase with [No Cash, No Fee] On [PAYMENT_LINK] and [Expired Account Before Route Info] and [Active Gateway]
    Given Allocate No Fee CCREDIT Account
    And Set channel PAYMENT_LINK
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway CPG
    And Credit Gateway Activate
    And Set Amount Equal To Balance
    When Performed A Prepared Online Purchase
    And Expire Account
    And Route Info The Credit Purchase
    And Pay The Credit Purchase
    And Verify The Credit Purchase
    And Deliver The Credit Purchase
    Then The Purchase Should have Been Successful
    And Should Have Been Able To Route Info
    And Should Have Been Able To Pay
    And Should Have Been Able To Verify
    And Should Have Been Able To Deliver
    And Assert Purchase Data In Credit Management, Credit Merchant Management And Report Management Is Correct

[TC-156] Online [CCREDIT] Purchase with [No Cash, No Fee] On [PAYMENT_LINK] and [Expired Account Before Credit Pay] and [Active Gateway]
    Given Allocate No Fee CCREDIT Account
    And Set channel PAYMENT_LINK
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway CPG
    And Credit Gateway Activate
    And Set Amount Equal To Balance
    When Performed A Routed Online Purchase
    And Expire Account
    And Pay The Credit Purchase
    And Verify The Credit Purchase
    And Deliver The Credit Purchase
    Then The Purchase Should have Been Successful
    And Should Have Been Able To Pay
    And Should Have Been Able To Verify
    And Should Have Been Able To Deliver
    And Assert Purchase Data In Credit Management, Credit Merchant Management And Report Management Is Correct

[TC-157] Online [CCREDIT] Purchase with [No Cash, No Fee] On [PAYMENT_LINK] and [Expired Account Before Verification] and [Active Gateway]
    Given Allocate No Fee CCREDIT Account
    And Set channel PAYMENT_LINK
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway CPG
    And Credit Gateway Activate
    And Set Amount Equal To Balance
    When Performed A Paid Online Purchase
    And Expire Account
    And Verify The Credit Purchase
    And Deliver The Credit Purchase
    Then The Purchase Should have Been Successful
    And Should Have Been Able To Verify
    And Should Have Been Able To Deliver
    And Assert Purchase Data In Credit Management, Credit Merchant Management And Report Management Is Correct

[TC-158] Online [CCREDIT] Purchase with [No Cash, No Fee] On [PAYMENT_LINK] and [Expired Account Before Delivery] and [Active Gateway]
    Given Allocate No Fee CCREDIT Account
    And Set channel PAYMENT_LINK
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway CPG
    And Credit Gateway Activate
    And Set Amount Equal To Balance
    When Performed A Verified Online Purchase
    And Expire Account
    And Deliver The Credit Purchase
    Then The Purchase Should have Been Successful
    And Should Have Been Able To Deliver
    And Purchase Status Must Be DELIVERED
    And Assert Purchase Data In Credit Management, Credit Merchant Management And Report Management Is Correct

[TC-159] Online [CCREDIT] Purchase with [No Cash, No Fee] On [PAYMENT_LINK] and [Expired Account Before Billing Cycle Assign] and [Active Gateway]
    Given Allocate No Fee CCREDIT Account
    And Set channel PAYMENT_LINK
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway CPG
    And Credit Gateway Activate
    And Set Amount Equal To Balance
    When Performed An Online Purchase
    And Expire Account
    And Wait For The Purchase To Be Assigned To The Billing Cycle
    Then The Purchase Should have Been Successful
    And Purchase Should Be Assigned To The Billing Cycle
    And Assert Purchase Data In Credit Management, Credit Merchant Management And Report Management Is Correct

[TC-160] Online [CCREDIT] Purchase with [No Cash, No Fee] On [PAYMENT_LINK] and [Zero Balance Account] and [Active Gateway]
    Given Allocate No Fee CCREDIT Account
    And Set channel PAYMENT_LINK
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway CPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    And Empty Balance
    When Performed An Online Purchase
    Then The Purchase Should Not have Been Successful

[TC-161] Online [CCREDIT] Purchase with [No Cash, No Fee] On [PAYMENT_LINK] and [Zero Balance Account Before Prepare] and [Active Gateway]
    Given Allocate No Fee CCREDIT Account
    And Set channel PAYMENT_LINK
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway CPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When Performed An Initiated Online Purchase
    And Empty Balance
    And Prepare The Credit Purchase
    And Route Info The Credit Purchase
    And Pay The Credit Purchase
    And Verify The Credit Purchase
    And Deliver The Credit Purchase
    Then The Purchase Should have Been Successful
    And Should Not Have Been Able To Prepare
    And Should Not Have Been Able To Route Info
    And Should Not Have Been Able To Pay
    And Should Not Have Been Able To Verify
    And Should Not Have Been Able To Deliver

[TC-162] Online [CCREDIT] Purchase with [No Cash, No Fee] On [PAYMENT_LINK] and [Zero Balance Account Before Route Info] and [Active Gateway]
    Given Allocate No Fee CCREDIT Account
    And Set channel PAYMENT_LINK
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway CPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When Performed A Prepared Online Purchase
    And Empty Balance
    And Route Info The Credit Purchase
    And Pay The Credit Purchase
    And Verify The Credit Purchase
    And Deliver The Credit Purchase
    Then The Purchase Should have Been Successful
    And Should Have Been Able To Route Info
    And Should Not Have Been Able To Pay
    And Should Not Have Been Able To Verify
    And Should Not Have Been Able To Deliver

[TC-163] Online [CCREDIT] Purchase with [No Cash, No Fee] On [PAYMENT_LINK] and [Zero Balance Account Before Credit Pay] and [Active Gateway]
    Given Allocate No Fee CCREDIT Account
    And Set channel PAYMENT_LINK
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway CPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When Performed A Routed Online Purchase
    And Empty Balance
    And Pay The Credit Purchase
    And Verify The Credit Purchase
    And Deliver The Credit Purchase
    Then The Purchase Should have Been Successful
    And Should Not Have Been Able To Pay
    And Should Not Have Been Able To Verify
    And Should Not Have Been Able To Deliver

[TC-164] Online [CCREDIT] Purchase with [No Cash, No Fee] On [PAYMENT_LINK] and [Zero Balance Account Before Verification] and [Active Gateway]
    Given Allocate No Fee CCREDIT Account
    And Set channel PAYMENT_LINK
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway CPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When Performed A Paid Online Purchase
    And Empty Balance
    And Verify The Credit Purchase
    And Deliver The Credit Purchase
    Then The Purchase Should have Been Successful
    And Should Have Been Able To Verify
    And Should Have Been Able To Deliver
    And Assert Purchase Data In Credit Management, Credit Merchant Management And Report Management Is Correct

[TC-165] Online [CCREDIT] Purchase with [No Cash, No Fee] On [PAYMENT_LINK] and [Zero Balance Account Before Delivery] and [Active Gateway]
    Given Allocate No Fee CCREDIT Account
    And Set channel PAYMENT_LINK
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway CPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When Performed A Verified Online Purchase
    And Empty Balance
    And Deliver The Credit Purchase
    Then The Purchase Should have Been Successful
    And Should Have Been Able To Deliver
    And Purchase Status Must Be DELIVERED
    And Assert Purchase Data In Credit Management, Credit Merchant Management And Report Management Is Correct

[TC-166] Online [CCREDIT] Purchase with [No Cash, No Fee] On [PAYMENT_LINK] and [Active Account] and [Disabled Gateway]
    Given Allocate No Fee CCREDIT Account
    And Set channel PAYMENT_LINK
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway CPG
    And Set Amount Less Than Balance
    And Credit Gateway Activate
    And Credit Gateway Disable
    When Performed An Online Purchase
    Then The Purchase Should Not have Been Successful

[TC-167] Online [CCREDIT] Purchase with [No Cash, No Fee] On [PAYMENT_LINK] and [Blocked Account] and [Disabled Gateway]
    Given Allocate No Fee CCREDIT Account
    And Set channel PAYMENT_LINK
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway CPG
    And Set Amount Less Than Balance
    And Block Credit Account
    And Credit Gateway Activate

    When Performed An Online Purchase
    Then The Purchase Should Not have Been Successful

[TC-168] Online [CCREDIT] Purchase with [No Cash, No Fee] On [PAYMENT_LINK] and [Expired Account] and [Disabled Gateway]
    Given Allocate No Fee CCREDIT Account
    And Set channel PAYMENT_LINK
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway CPG
    And Set Amount Less Than Balance
    And Empty Balance
    And Expire Account
    And Credit Gateway Activate

    When Performed An Online Purchase
    Then The Purchase Should Not have Been Successful

[TC-169] Online [CCREDIT] Purchase with [No Cash, No Fee] On [PAYMENT_LINK] and [Zero Balance Account] and [Disabled Gateway]
    Given Allocate No Fee CCREDIT Account
    And Set channel PAYMENT_LINK
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway CPG
    And Set Amount Less Than Balance
    And Empty Balance
    And Credit Gateway Activate

    When Performed An Online Purchase
    Then The Purchase Should Not have Been Successful

[TC-170] Online [CCREDIT] Purchase with [No Cash, No Fee] On [PAYMENT_LINK] and [Active Account] and [Disabled Gateway Before Prepare]
    [Tags]    robot:skip
    Given Allocate No Fee CCREDIT Account
    And Set channel PAYMENT_LINK
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway CPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When Performed An Initiated Online Purchase

    And Prepare The Credit Purchase
    And Route Info The Credit Purchase
    And Pay The Credit Purchase
    And Verify The Credit Purchase
    And Deliver The Credit Purchase
    Then The Purchase Should have Been Successful
    And Should Have Been Able To Prepare
    And Should Have Been Able To Route Info
    And Should Have Been Able To Pay
    And Should Have Been Able To Verify
    And Should Have Been Able To Deliver
    And Assert Purchase Data In Credit Management, Credit Merchant Management And Report Management Is Correct

[TC-171] Online [CCREDIT] Purchase with [No Cash, No Fee] On [PAYMENT_LINK] and [Active Account] and [Disabled Gateway Before Route Info]
    [Tags]    robot:skip
    Given Allocate No Fee CCREDIT Account
    And Set channel PAYMENT_LINK
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway CPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When Performed A Prepared Online Purchase
    And Route Info The Credit Purchase

    And Pay The Credit Purchase
    And Verify The Credit Purchase
    And Deliver The Credit Purchase
    Then The Purchase Should have Been Successful
    And Should Have Been Able To Route Info
    And Should Have Been Able To Pay
    And Should Have Been Able To Verify
    And Should Have Been Able To Deliver
    And Assert Purchase Data In Credit Management, Credit Merchant Management And Report Management Is Correct

[TC-172] Online [CCREDIT] Purchase with [No Cash, No Fee] On [PAYMENT_LINK] and [Active Account] and [Disabled Gateway Before Credit Pay]
    [Tags]    robot:skip
    Given Allocate No Fee CCREDIT Account
    And Set channel PAYMENT_LINK
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway CPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When Performed A Routed Online Purchase

    And Pay The Credit Purchase
    And Verify The Credit Purchase
    And Deliver The Credit Purchase
    Then The Purchase Should have Been Successful
    And Should Have Been Able To Pay
    And Should Have Been Able To Verify
    And Should Have Been Able To Deliver
    And Assert Purchase Data In Credit Management, Credit Merchant Management And Report Management Is Correct

[TC-173] Online [CCREDIT] Purchase with [No Cash, No Fee] On [PAYMENT_LINK] and [Active Account] and [Disabled Gateway Before Verification]
    [Tags]    robot:skip
    Given Allocate No Fee CCREDIT Account
    And Set channel PAYMENT_LINK
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway CPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When Performed A Paid Online Purchase

    And Verify The Credit Purchase
    And Deliver The Credit Purchase
    Then The Purchase Should have Been Successful
    And Should Have Been Able To Verify
    And Should Have Been Able To Deliver
    And Assert Purchase Data In Credit Management, Credit Merchant Management And Report Management Is Correct

[TC-174] Online [CCREDIT] Purchase with [No Cash, No Fee] On [PAYMENT_LINK] and [Active Account] and [Disabled Gateway Before Delivery]
    Given Allocate No Fee CCREDIT Account
    And Set channel PAYMENT_LINK
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway CPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When Performed A Verified Online Purchase

    And Deliver The Credit Purchase
    Then The Purchase Should have Been Successful
    And Should Have Been Able To Deliver
    And Purchase Status Must Be DELIVERED
    And Assert Purchase Data In Credit Management, Credit Merchant Management And Report Management Is Correct

[TC-175] Online [INSTALLMENT_SALES] Purchase with [No Cash, No Fee] On [UPG] and [Active Account] and [Active Gateway]
    Given Allocate No Fee INSTALLMENT SALES Account
    And Set channel UPG
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway ISPG
    And Credit Gateway Activate
    And Set Amount Equal To Balance
    When Performed An Online Purchase
    Then The Purchase Should have Been Successful
    And Record Must Exist In Report
    And Assert Purchase Data In Credit Management, Credit Merchant Management And Report Management Is Correct

[TC-176] Online [INSTALLMENT_SALES] Purchase with [No Cash, No Fee] On [UPG] and [Blocked Account] and [Active Gateway]
    Given Allocate No Fee INSTALLMENT SALES Account
    And Set channel UPG
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway ISPG
    And Credit Gateway Activate
    And Set Amount Equal To Balance
    And Block Credit Account
    When Performed An Online Purchase
    Then The Purchase Should Not have Been Successful

[TC-177] Online [INSTALLMENT_SALES] Purchase with [No Cash, No Fee] On [UPG] and [Blocked Account Before Prepare] and [Active Gateway]
    Given Allocate No Fee INSTALLMENT SALES Account
    And Set channel UPG
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway ISPG
    And Credit Gateway Activate
    And Set Amount Equal To Balance
    When Performed An Initiated Online Purchase
    And Block Credit Account
    And Prepare The Credit Purchase
    And Route Info The Credit Purchase
    And Pay The Credit Purchase
    And Verify The Credit Purchase
    And Deliver The Credit Purchase
    Then The Purchase Should have Been Successful
    And Should Not Have Been Able To Prepare
    And Should Not Have Been Able To Route Info
    And Should Not Have Been Able To Pay
    And Should Not Have Been Able To Verify
    And Should Not Have Been Able To Deliver

[TC-178] Online [INSTALLMENT_SALES] Purchase with [No Cash, No Fee] On [UPG] and [Blocked Account Before Route Info] and [Active Gateway]
    [Tags]    robot:skip
    Given Allocate No Fee INSTALLMENT SALES Account
    And Set channel UPG
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway ISPG
    And Credit Gateway Activate
    And Set Amount Equal To Balance
    When Performed A Prepared Online Purchase
    And Block Credit Account
    And Route Info The Credit Purchase
    And Pay The Credit Purchase
    And Verify The Credit Purchase
    And Deliver The Credit Purchase
    Then The Purchase Should have Been Successful
    And Should Not Have Been Able To Route Info
    And Should Not Have Been Able To Pay
    And Should Not Have Been Able To Verify
    And Should Not Have Been Able To Deliver

[TC-179] Online [INSTALLMENT_SALES] Purchase with [No Cash, No Fee] On [UPG] and [Blocked Account Before Credit Pay] and [Active Gateway]
    [Tags]    robot:skip
    Given Allocate No Fee INSTALLMENT SALES Account
    And Set channel UPG
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway ISPG
    And Credit Gateway Activate
    And Set Amount Equal To Balance
    When Performed A Routed Online Purchase
    And Block Credit Account
    And Pay The Credit Purchase
    And Verify The Credit Purchase
    And Deliver The Credit Purchase
    Then The Purchase Should have Been Successful
    And Should Not Have Been Able To Pay
    And Should Not Have Been Able To Verify
    And Should Not Have Been Able To Deliver

[TC-180] Online [INSTALLMENT_SALES] Purchase with [No Cash, No Fee] On [UPG] and [Blocked Account Before Verification] and [Active Gateway]
    [Tags]    robot:skip
    Given Allocate No Fee INSTALLMENT SALES Account
    And Set channel UPG
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway ISPG
    And Credit Gateway Activate
    And Set Amount Equal To Balance
    When Performed A Paid Online Purchase
    And Block Credit Account
    And Verify The Credit Purchase
    And Deliver The Credit Purchase
    Then The Purchase Should have Been Successful
    And Should Not Have Been Able To Verify
    And Should Not Have Been Able To Deliver

[TC-181] Online [INSTALLMENT_SALES] Purchase with [No Cash, No Fee] On [UPG] and [Blocked Account Before Delivery] and [Active Gateway]
    Given Allocate No Fee INSTALLMENT SALES Account
    And Set channel UPG
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway ISPG
    And Credit Gateway Activate
    And Set Amount Equal To Balance
    When Performed A Verified Online Purchase
    And Block Credit Account
    And Deliver The Credit Purchase
    Then The Purchase Should have Been Successful
    And Should Have Been Able To Deliver
    And Purchase Status Must Be DELIVERED
    And Assert Purchase Data In Credit Management, Credit Merchant Management And Report Management Is Correct

[TC-182] Online [INSTALLMENT_SALES] Purchase with [No Cash, No Fee] On [UPG] and [Expired Account] and [Active Gateway]
    Given Allocate No Fee INSTALLMENT SALES Account
    And Set channel UPG
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway ISPG
    And Credit Gateway Activate
    And Set Amount Equal To Balance
    And Empty Balance
    And Expire Account
    When Performed An Online Purchase
    Then The Purchase Should Not have Been Successful

[TC-183] Online [INSTALLMENT_SALES] Purchase with [No Cash, No Fee] On [UPG] and [Expired Account Before Prepare] and [Active Gateway]
    Given Allocate No Fee INSTALLMENT SALES Account
    And Set channel UPG
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway ISPG
    And Credit Gateway Activate
    And Set Amount Equal To Balance
    When Performed An Initiated Online Purchase
    And Empty Balance
    And Expire Account
    And Prepare The Credit Purchase
    And Route Info The Credit Purchase
    And Pay The Credit Purchase
    And Verify The Credit Purchase
    And Deliver The Credit Purchase
    Then The Purchase Should have Been Successful
    And Should Not Have Been Able To Prepare
    And Should Not Have Been Able To Route Info
    And Should Not Have Been Able To Pay
    And Should Not Have Been Able To Verify
    And Should Not Have Been Able To Deliver

[TC-184] Online [INSTALLMENT_SALES] Purchase with [No Cash, No Fee] On [UPG] and [Expired Account Before Route Info] and [Active Gateway]
    Given Allocate No Fee INSTALLMENT SALES Account
    And Set channel UPG
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway ISPG
    And Credit Gateway Activate
    And Set Amount Equal To Balance
    When Performed A Prepared Online Purchase
    And Expire Account
    And Route Info The Credit Purchase
    And Pay The Credit Purchase
    And Verify The Credit Purchase
    And Deliver The Credit Purchase
    Then The Purchase Should have Been Successful
    And Should Have Been Able To Route Info
    And Should Have Been Able To Pay
    And Should Have Been Able To Verify
    And Should Have Been Able To Deliver
    And Assert Purchase Data In Credit Management, Credit Merchant Management And Report Management Is Correct

[TC-185] Online [INSTALLMENT_SALES] Purchase with [No Cash, No Fee] On [UPG] and [Expired Account Before Credit Pay] and [Active Gateway]
    Given Allocate No Fee INSTALLMENT SALES Account
    And Set channel UPG
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway ISPG
    And Credit Gateway Activate
    And Set Amount Equal To Balance
    When Performed A Routed Online Purchase
    And Expire Account
    And Pay The Credit Purchase
    And Verify The Credit Purchase
    And Deliver The Credit Purchase
    Then The Purchase Should have Been Successful
    And Should Have Been Able To Pay
    And Should Have Been Able To Verify
    And Should Have Been Able To Deliver
    And Assert Purchase Data In Credit Management, Credit Merchant Management And Report Management Is Correct

[TC-186] Online [INSTALLMENT_SALES] Purchase with [No Cash, No Fee] On [UPG] and [Expired Account Before Verification] and [Active Gateway]
    Given Allocate No Fee INSTALLMENT SALES Account
    And Set channel UPG
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway ISPG
    And Credit Gateway Activate
    And Set Amount Equal To Balance
    When Performed A Paid Online Purchase
    And Expire Account
    And Verify The Credit Purchase
    And Deliver The Credit Purchase
    Then The Purchase Should have Been Successful
    And Should Have Been Able To Verify
    And Should Have Been Able To Deliver
    And Assert Purchase Data In Credit Management, Credit Merchant Management And Report Management Is Correct

[TC-187] Online [INSTALLMENT_SALES] Purchase with [No Cash, No Fee] On [UPG] and [Expired Account Before Delivery] and [Active Gateway]
    Given Allocate No Fee INSTALLMENT SALES Account
    And Set channel UPG
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway ISPG
    And Credit Gateway Activate
    And Set Amount Equal To Balance
    When Performed A Verified Online Purchase
    And Expire Account
    And Deliver The Credit Purchase
    Then The Purchase Should have Been Successful
    And Should Have Been Able To Deliver
    And Purchase Status Must Be DELIVERED
    And Assert Purchase Data In Credit Management, Credit Merchant Management And Report Management Is Correct

[TC-188] Online [INSTALLMENT_SALES] Purchase with [No Cash, No Fee] On [UPG] and [Expired Account Before Billing Cycle Assign] and [Active Gateway]
    Given Allocate No Fee INSTALLMENT SALES Account
    And Set channel UPG
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway ISPG
    And Credit Gateway Activate
    And Set Amount Equal To Balance
    When Performed An Online Purchase
    And Expire Account
    And Wait For The Purchase To Be Assigned To The Billing Cycle
    Then The Purchase Should have Been Successful
    And Purchase Should Be Assigned To The Billing Cycle
    And Assert Purchase Data In Credit Management, Credit Merchant Management And Report Management Is Correct

[TC-189] Online [INSTALLMENT_SALES] Purchase with [No Cash, No Fee] On [UPG] and [Zero Balance Account] and [Active Gateway]
    Given Allocate No Fee INSTALLMENT SALES Account
    And Set channel UPG
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway ISPG
    And Credit Gateway Activate
    And Set Amount Equal To Balance
    And Empty Balance
    When Performed An Online Purchase
    Then The Purchase Should Not have Been Successful

[TC-190] Online [INSTALLMENT_SALES] Purchase with [No Cash, No Fee] On [UPG] and [Zero Balance Account Before Prepare] and [Active Gateway]
    Given Allocate No Fee INSTALLMENT SALES Account
    And Set channel UPG
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway ISPG
    And Credit Gateway Activate
    And Set Amount Equal To Balance
    When Performed An Initiated Online Purchase
    And Empty Balance
    And Prepare The Credit Purchase
    And Route Info The Credit Purchase
    And Pay The Credit Purchase
    And Verify The Credit Purchase
    And Deliver The Credit Purchase
    Then The Purchase Should have Been Successful
    And Should Not Have Been Able To Prepare
    And Should Not Have Been Able To Route Info
    And Should Not Have Been Able To Pay
    And Should Not Have Been Able To Verify
    And Should Not Have Been Able To Deliver

[TC-191] Online [INSTALLMENT_SALES] Purchase with [No Cash, No Fee] On [UPG] and [Zero Balance Account Before Route Info] and [Active Gateway]
    Given Allocate No Fee INSTALLMENT SALES Account
    And Set channel UPG
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway ISPG
    And Credit Gateway Activate
    And Set Amount Equal To Balance
    When Performed A Prepared Online Purchase
    And Empty Balance
    And Route Info The Credit Purchase
    And Pay The Credit Purchase
    And Verify The Credit Purchase
    And Deliver The Credit Purchase
    Then The Purchase Should have Been Successful
    And Should Have Been Able To Route Info
    And Should Not Have Been Able To Pay
    And Should Not Have Been Able To Verify
    And Should Not Have Been Able To Deliver

[TC-192] Online [INSTALLMENT_SALES] Purchase with [No Cash, No Fee] On [UPG] and [Zero Balance Account Before Credit Pay] and [Active Gateway]
    Given Allocate No Fee INSTALLMENT SALES Account
    And Set channel UPG
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway ISPG
    And Credit Gateway Activate
    And Set Amount Equal To Balance
    When Performed A Routed Online Purchase
    And Empty Balance
    And Pay The Credit Purchase
    And Verify The Credit Purchase
    And Deliver The Credit Purchase
    Then The Purchase Should have Been Successful
    And Should Not Have Been Able To Pay
    And Should Not Have Been Able To Verify
    And Should Not Have Been Able To Deliver

[TC-193] Online [INSTALLMENT_SALES] Purchase with [No Cash, No Fee] On [UPG] and [Active Account] and [Disabled Gateway]
    Given Allocate No Fee INSTALLMENT SALES Account
    And Set channel UPG
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway ISPG
    And Set Amount Equal To Balance
    And Credit Gateway Activate
    And Credit Gateway Disable
    When Performed An Online Purchase
    Then The Purchase Should Not have Been Successful

[TC-194] Online [INSTALLMENT_SALES] Purchase with [No Cash, No Fee] On [UPG] and [Blocked Account] and [Disabled Gateway]
    Given Allocate No Fee INSTALLMENT SALES Account
    And Set channel UPG
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway ISPG
    And Set Amount Equal To Balance
    And Block Credit Account
    And Credit Gateway Activate

    When Performed An Online Purchase
    Then The Purchase Should Not have Been Successful

[TC-195] Online [INSTALLMENT_SALES] Purchase with [No Cash, No Fee] On [UPG] and [Expired Account] and [Disabled Gateway]
    Given Allocate No Fee INSTALLMENT SALES Account
    And Set channel UPG
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway ISPG
    And Set Amount Equal To Balance
    And Empty Balance
    And Expire Account
    And Credit Gateway Activate

    When Performed An Online Purchase
    Then The Purchase Should Not have Been Successful

[TC-196] Online [INSTALLMENT_SALES] Purchase with [No Cash, No Fee] On [UPG] and [Zero Balance Account] and [Disabled Gateway]
    Given Allocate No Fee INSTALLMENT SALES Account
    And Set channel UPG
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway ISPG
    And Set Amount Equal To Balance
    And Empty Balance
    And Credit Gateway Activate

    When Performed An Online Purchase
    Then The Purchase Should Not have Been Successful

[TC-197] Online [INSTALLMENT_SALES] Purchase with [No Cash, No Fee] On [UPG] and [Active Account] and [Disabled Gateway Before Prepare]
    [Tags]    robot:skip
    Given Allocate No Fee INSTALLMENT SALES Account
    And Set channel UPG
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway ISPG
    And Credit Gateway Activate
    And Set Amount Equal To Balance
    When Performed An Initiated Online Purchase

    And Prepare The Credit Purchase
    And Route Info The Credit Purchase
    And Pay The Credit Purchase
    And Verify The Credit Purchase
    And Deliver The Credit Purchase
    Then The Purchase Should have Been Successful
    And Should Have Been Able To Prepare
    And Should Have Been Able To Route Info
    And Should Have Been Able To Pay
    And Should Have Been Able To Verify
    And Should Have Been Able To Deliver
    And Assert Purchase Data In Credit Management, Credit Merchant Management And Report Management Is Correct

[TC-198] Online [INSTALLMENT_SALES] Purchase with [No Cash, No Fee] On [UPG] and [Active Account] and [Disabled Gateway Before Route Info]
    [Tags]    robot:skip
    Given Allocate No Fee INSTALLMENT SALES Account
    And Set channel UPG
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway ISPG
    And Credit Gateway Activate
    And Set Amount Equal To Balance
    When Performed A Prepared Online Purchase
    And Route Info The Credit Purchase

    And Pay The Credit Purchase
    And Verify The Credit Purchase
    And Deliver The Credit Purchase
    Then The Purchase Should have Been Successful
    And Should Have Been Able To Route Info
    And Should Have Been Able To Pay
    And Should Have Been Able To Verify
    And Should Have Been Able To Deliver
    And Assert Purchase Data In Credit Management, Credit Merchant Management And Report Management Is Correct

[TC-199] Online [INSTALLMENT_SALES] Purchase with [No Cash, No Fee] On [UPG] and [Active Account] and [Disabled Gateway Before Credit Pay]
    [Tags]    robot:skip
    Given Allocate No Fee INSTALLMENT SALES Account
    And Set channel UPG
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway ISPG
    And Credit Gateway Activate
    And Set Amount Equal To Balance
    When Performed A Routed Online Purchase

    And Pay The Credit Purchase
    And Verify The Credit Purchase
    And Deliver The Credit Purchase
    Then The Purchase Should have Been Successful
    And Should Have Been Able To Pay
    And Should Have Been Able To Verify
    And Should Have Been Able To Deliver
    And Assert Purchase Data In Credit Management, Credit Merchant Management And Report Management Is Correct

[TC-200] Online [INSTALLMENT_SALES] Purchase with [No Cash, No Fee] On [UPG] and [Active Account] and [Disabled Gateway Before Verification]
    [Tags]    robot:skip
    Given Allocate No Fee INSTALLMENT SALES Account
    And Set channel UPG
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway ISPG
    And Credit Gateway Activate
    And Set Amount Equal To Balance
    When Performed A Paid Online Purchase

    And Verify The Credit Purchase
    And Deliver The Credit Purchase
    Then The Purchase Should have Been Successful
    And Should Have Been Able To Verify
    And Should Have Been Able To Deliver
    And Assert Purchase Data In Credit Management, Credit Merchant Management And Report Management Is Correct

[TC-201] Online [INSTALLMENT_SALES] Purchase with [No Cash, No Fee] On [UPG] and [Active Account] and [Disabled Gateway Before Delivery]
    Given Allocate No Fee INSTALLMENT SALES Account
    And Set channel UPG
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway ISPG
    And Credit Gateway Activate
    And Set Amount Equal To Balance
    When Performed A Verified Online Purchase

    And Deliver The Credit Purchase
    Then The Purchase Should have Been Successful
    And Should Have Been Able To Deliver
    And Purchase Status Must Be DELIVERED
    And Assert Purchase Data In Credit Management, Credit Merchant Management And Report Management Is Correct

[TC-202] Online [INSTALLMENT_SALES] Purchase with [No Cash, No Fee] On [QR] and [Active Account] and [Active Gateway]
    Given Allocate No Fee INSTALLMENT SALES Account
    And Set channel QR
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway ISPG
    And Credit Gateway Activate
    And Set Amount Equal To Balance
    When Performed An Online Purchase
    Then The Purchase Should have Been Successful
    And Record Must Exist In Report
    And Assert Purchase Data In Credit Management, Credit Merchant Management And Report Management Is Correct

[TC-203] Online [INSTALLMENT_SALES] Purchase with [No Cash, No Fee] On [QR] and [Blocked Account] and [Active Gateway]
    Given Allocate No Fee INSTALLMENT SALES Account
    And Set channel QR
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway ISPG
    And Credit Gateway Activate
    And Set Amount Equal To Balance
    And Block Credit Account
    When Performed An Online Purchase
    Then The Purchase Should Not have Been Successful

[TC-204] Online [INSTALLMENT_SALES] Purchase with [No Cash, No Fee] On [QR] and [Blocked Account Before Prepare] and [Active Gateway]
    Given Allocate No Fee INSTALLMENT SALES Account
    And Set channel QR
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway ISPG
    And Credit Gateway Activate
    And Set Amount Equal To Balance
    When Performed An Initiated Online Purchase
    And Block Credit Account
    And Prepare The Credit Purchase
    And Route Info The Credit Purchase
    And Pay The Credit Purchase
    And Verify The Credit Purchase
    And Deliver The Credit Purchase
    Then The Purchase Should have Been Successful
    And Should Not Have Been Able To Prepare
    And Should Not Have Been Able To Route Info
    And Should Not Have Been Able To Pay
    And Should Not Have Been Able To Verify
    And Should Not Have Been Able To Deliver

[TC-205] Online [INSTALLMENT_SALES] Purchase with [No Cash, No Fee] On [QR] and [Blocked Account Before Route Info] and [Active Gateway]
    [Tags]    robot:skip
    Given Allocate No Fee INSTALLMENT SALES Account
    And Set channel QR
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway ISPG
    And Credit Gateway Activate
    And Set Amount Equal To Balance
    When Performed A Prepared Online Purchase
    And Block Credit Account
    And Route Info The Credit Purchase
    And Pay The Credit Purchase
    And Verify The Credit Purchase
    And Deliver The Credit Purchase
    Then The Purchase Should have Been Successful
    And Should Not Have Been Able To Route Info
    And Should Not Have Been Able To Pay
    And Should Not Have Been Able To Verify
    And Should Not Have Been Able To Deliver

[TC-206] Online [INSTALLMENT_SALES] Purchase with [No Cash, No Fee] On [QR] and [Blocked Account Before Credit Pay] and [Active Gateway]
    [Tags]    robot:skip
    Given Allocate No Fee INSTALLMENT SALES Account
    And Set channel QR
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway ISPG
    And Credit Gateway Activate
    And Set Amount Equal To Balance
    When Performed A Routed Online Purchase
    And Block Credit Account
    And Pay The Credit Purchase
    And Verify The Credit Purchase
    And Deliver The Credit Purchase
    Then The Purchase Should have Been Successful
    And Should Not Have Been Able To Pay
    And Should Not Have Been Able To Verify
    And Should Not Have Been Able To Deliver

[TC-207] Online [INSTALLMENT_SALES] Purchase with [No Cash, No Fee] On [QR] and [Blocked Account Before Verification] and [Active Gateway]
    [Tags]    robot:skip
    Given Allocate No Fee INSTALLMENT SALES Account
    And Set channel QR
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway ISPG
    And Credit Gateway Activate
    And Set Amount Equal To Balance
    When Performed A Paid Online Purchase
    And Block Credit Account
    And Verify The Credit Purchase
    And Deliver The Credit Purchase
    Then The Purchase Should have Been Successful
    And Should Not Have Been Able To Verify
    And Should Not Have Been Able To Deliver

[TC-208] Online [INSTALLMENT_SALES] Purchase with [No Cash, No Fee] On [QR] and [Blocked Account Before Delivery] and [Active Gateway]
    Given Allocate No Fee INSTALLMENT SALES Account
    And Set channel QR
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway ISPG
    And Credit Gateway Activate
    And Set Amount Equal To Balance
    When Performed A Verified Online Purchase
    And Block Credit Account
    And Deliver The Credit Purchase
    Then The Purchase Should have Been Successful
    And Should Have Been Able To Deliver
    And Purchase Status Must Be DELIVERED
    And Assert Purchase Data In Credit Management, Credit Merchant Management And Report Management Is Correct

[TC-209] Online [INSTALLMENT_SALES] Purchase with [No Cash, No Fee] On [QR] and [Expired Account] and [Active Gateway]
    Given Allocate No Fee INSTALLMENT SALES Account
    And Set channel QR
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway ISPG
    And Credit Gateway Activate
    And Set Amount Equal To Balance
    And Empty Balance
    And Expire Account
    When Performed An Online Purchase
    Then The Purchase Should Not have Been Successful

[TC-210] Online [INSTALLMENT_SALES] Purchase with [No Cash, No Fee] On [QR] and [Expired Account Before Prepare] and [Active Gateway]
    Given Allocate No Fee INSTALLMENT SALES Account
    And Set channel QR
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway ISPG
    And Credit Gateway Activate
    And Set Amount Equal To Balance
    When Performed An Initiated Online Purchase
    And Empty Balance
    And Expire Account
    And Prepare The Credit Purchase
    And Route Info The Credit Purchase
    And Pay The Credit Purchase
    And Verify The Credit Purchase
    And Deliver The Credit Purchase
    Then The Purchase Should have Been Successful
    And Should Not Have Been Able To Prepare
    And Should Not Have Been Able To Route Info
    And Should Not Have Been Able To Pay
    And Should Not Have Been Able To Verify
    And Should Not Have Been Able To Deliver

[TC-211] Online [INSTALLMENT_SALES] Purchase with [No Cash, No Fee] On [QR] and [Expired Account Before Route Info] and [Active Gateway]
    Given Allocate No Fee INSTALLMENT SALES Account
    And Set channel QR
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway ISPG
    And Credit Gateway Activate
    And Set Amount Equal To Balance
    When Performed A Prepared Online Purchase
    And Expire Account
    And Route Info The Credit Purchase
    And Pay The Credit Purchase
    And Verify The Credit Purchase
    And Deliver The Credit Purchase
    Then The Purchase Should have Been Successful
    And Should Have Been Able To Route Info
    And Should Have Been Able To Pay
    And Should Have Been Able To Verify
    And Should Have Been Able To Deliver
    And Assert Purchase Data In Credit Management, Credit Merchant Management And Report Management Is Correct

[TC-212] Online [INSTALLMENT_SALES] Purchase with [No Cash, No Fee] On [QR] and [Expired Account Before Credit Pay] and [Active Gateway]
    Given Allocate No Fee INSTALLMENT SALES Account
    And Set channel QR
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway ISPG
    And Credit Gateway Activate
    And Set Amount Equal To Balance
    When Performed A Routed Online Purchase
    And Expire Account
    And Pay The Credit Purchase
    And Verify The Credit Purchase
    And Deliver The Credit Purchase
    Then The Purchase Should have Been Successful
    And Should Have Been Able To Pay
    And Should Have Been Able To Verify
    And Should Have Been Able To Deliver
    And Assert Purchase Data In Credit Management, Credit Merchant Management And Report Management Is Correct

[TC-213] Online [INSTALLMENT_SALES] Purchase with [No Cash, No Fee] On [QR] and [Expired Account Before Verification] and [Active Gateway]
    Given Allocate No Fee INSTALLMENT SALES Account
    And Set channel QR
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway ISPG
    And Credit Gateway Activate
    And Set Amount Equal To Balance
    When Performed A Paid Online Purchase
    And Expire Account
    And Verify The Credit Purchase
    And Deliver The Credit Purchase
    Then The Purchase Should have Been Successful
    And Should Have Been Able To Verify
    And Should Have Been Able To Deliver
    And Assert Purchase Data In Credit Management, Credit Merchant Management And Report Management Is Correct

[TC-214] Online [INSTALLMENT_SALES] Purchase with [No Cash, No Fee] On [QR] and [Expired Account Before Delivery] and [Active Gateway]
    Given Allocate No Fee INSTALLMENT SALES Account
    And Set channel QR
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway ISPG
    And Credit Gateway Activate
    And Set Amount Equal To Balance
    When Performed A Verified Online Purchase
    And Expire Account
    And Deliver The Credit Purchase
    Then The Purchase Should have Been Successful
    And Should Have Been Able To Deliver
    And Purchase Status Must Be DELIVERED
    And Assert Purchase Data In Credit Management, Credit Merchant Management And Report Management Is Correct

[TC-215] Online [INSTALLMENT_SALES] Purchase with [No Cash, No Fee] On [QR] and [Expired Account Before Billing Cycle Assign] and [Active Gateway]
    Given Allocate No Fee INSTALLMENT SALES Account
    And Set channel QR
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway ISPG
    And Credit Gateway Activate
    And Set Amount Equal To Balance
    When Performed An Online Purchase
    And Expire Account
    And Wait For The Purchase To Be Assigned To The Billing Cycle
    Then The Purchase Should have Been Successful
    And Purchase Should Be Assigned To The Billing Cycle
    And Assert Purchase Data In Credit Management, Credit Merchant Management And Report Management Is Correct

[TC-216] Online [INSTALLMENT_SALES] Purchase with [No Cash, No Fee] On [QR] and [Zero Balance Account] and [Active Gateway]
    Given Allocate No Fee INSTALLMENT SALES Account
    And Set channel QR
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway ISPG
    And Credit Gateway Activate
    And Set Amount Equal To Balance
    And Empty Balance
    When Performed An Online Purchase
    Then The Purchase Should Not have Been Successful

[TC-217] Online [INSTALLMENT_SALES] Purchase with [No Cash, No Fee] On [QR] and [Zero Balance Account Before Prepare] and [Active Gateway]
    Given Allocate No Fee INSTALLMENT SALES Account
    And Set channel QR
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway ISPG
    And Credit Gateway Activate
    And Set Amount Equal To Balance
    When Performed An Initiated Online Purchase
    And Empty Balance
    And Prepare The Credit Purchase
    And Route Info The Credit Purchase
    And Pay The Credit Purchase
    And Verify The Credit Purchase
    And Deliver The Credit Purchase
    Then The Purchase Should have Been Successful
    And Should Not Have Been Able To Prepare
    And Should Not Have Been Able To Route Info
    And Should Not Have Been Able To Pay
    And Should Not Have Been Able To Verify
    And Should Not Have Been Able To Deliver

[TC-218] Online [INSTALLMENT_SALES] Purchase with [No Cash, No Fee] On [QR] and [Zero Balance Account Before Route Info] and [Active Gateway]
    Given Allocate No Fee INSTALLMENT SALES Account
    And Set channel QR
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway ISPG
    And Credit Gateway Activate
    And Set Amount Equal To Balance
    When Performed A Prepared Online Purchase
    And Empty Balance
    And Route Info The Credit Purchase
    And Pay The Credit Purchase
    And Verify The Credit Purchase
    And Deliver The Credit Purchase
    Then The Purchase Should have Been Successful
    And Should Have Been Able To Route Info
    And Should Not Have Been Able To Pay
    And Should Not Have Been Able To Verify
    And Should Not Have Been Able To Deliver

[TC-219] Online [INSTALLMENT_SALES] Purchase with [No Cash, No Fee] On [QR] and [Zero Balance Account Before Credit Pay] and [Active Gateway]
    Given Allocate No Fee INSTALLMENT SALES Account
    And Set channel QR
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway ISPG
    And Credit Gateway Activate
    And Set Amount Equal To Balance
    When Performed A Routed Online Purchase
    And Empty Balance
    And Pay The Credit Purchase
    And Verify The Credit Purchase
    And Deliver The Credit Purchase
    Then The Purchase Should have Been Successful
    And Should Not Have Been Able To Pay
    And Should Not Have Been Able To Verify
    And Should Not Have Been Able To Deliver

[TC-220] Online [INSTALLMENT_SALES] Purchase with [No Cash, No Fee] On [QR] and [Active Account] and [Disabled Gateway]
    Given Allocate No Fee INSTALLMENT SALES Account
    And Set channel QR
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway ISPG
    And Set Amount Equal To Balance
    And Credit Gateway Activate
    And Credit Gateway Disable
    When Performed An Online Purchase
    Then The Purchase Should Not have Been Successful

[TC-221] Online [INSTALLMENT_SALES] Purchase with [No Cash, No Fee] On [QR] and [Blocked Account] and [Disabled Gateway]
    Given Allocate No Fee INSTALLMENT SALES Account
    And Set channel QR
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway ISPG
    And Set Amount Equal To Balance
    And Block Credit Account
    And Credit Gateway Activate

    When Performed An Online Purchase
    Then The Purchase Should Not have Been Successful

[TC-222] Online [INSTALLMENT_SALES] Purchase with [No Cash, No Fee] On [QR] and [Expired Account] and [Disabled Gateway]
    Given Allocate No Fee INSTALLMENT SALES Account
    And Set channel QR
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway ISPG
    And Set Amount Equal To Balance
    And Empty Balance
    And Expire Account
    And Credit Gateway Activate

    When Performed An Online Purchase
    Then The Purchase Should Not have Been Successful

[TC-223] Online [INSTALLMENT_SALES] Purchase with [No Cash, No Fee] On [QR] and [Zero Balance Account] and [Disabled Gateway]
    Given Allocate No Fee INSTALLMENT SALES Account
    And Set channel QR
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway ISPG
    And Set Amount Equal To Balance
    And Empty Balance
    And Credit Gateway Activate

    When Performed An Online Purchase
    Then The Purchase Should Not have Been Successful

[TC-224] Online [INSTALLMENT_SALES] Purchase with [No Cash, No Fee] On [QR] and [Active Account] and [Disabled Gateway Before Prepare]
    [Tags]    robot:skip
    Given Allocate No Fee INSTALLMENT SALES Account
    And Set channel QR
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway ISPG
    And Credit Gateway Activate
    And Set Amount Equal To Balance
    When Performed An Initiated Online Purchase

    And Prepare The Credit Purchase
    And Route Info The Credit Purchase
    And Pay The Credit Purchase
    And Verify The Credit Purchase
    And Deliver The Credit Purchase
    Then The Purchase Should have Been Successful
    And Should Have Been Able To Prepare
    And Should Have Been Able To Route Info
    And Should Have Been Able To Pay
    And Should Have Been Able To Verify
    And Should Have Been Able To Deliver
    And Assert Purchase Data In Credit Management, Credit Merchant Management And Report Management Is Correct

[TC-225] Online [INSTALLMENT_SALES] Purchase with [No Cash, No Fee] On [QR] and [Active Account] and [Disabled Gateway Before Route Info]
    [Tags]    robot:skip
    Given Allocate No Fee INSTALLMENT SALES Account
    And Set channel QR
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway ISPG
    And Credit Gateway Activate
    And Set Amount Equal To Balance
    When Performed A Prepared Online Purchase
    And Route Info The Credit Purchase

    And Pay The Credit Purchase
    And Verify The Credit Purchase
    And Deliver The Credit Purchase
    Then The Purchase Should have Been Successful
    And Should Have Been Able To Route Info
    And Should Have Been Able To Pay
    And Should Have Been Able To Verify
    And Should Have Been Able To Deliver
    And Assert Purchase Data In Credit Management, Credit Merchant Management And Report Management Is Correct

[TC-226] Online [INSTALLMENT_SALES] Purchase with [No Cash, No Fee] On [QR] and [Active Account] and [Disabled Gateway Before Credit Pay]
    [Tags]    robot:skip
    Given Allocate No Fee INSTALLMENT SALES Account
    And Set channel QR
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway ISPG
    And Credit Gateway Activate
    And Set Amount Equal To Balance
    When Performed A Routed Online Purchase

    And Pay The Credit Purchase
    And Verify The Credit Purchase
    And Deliver The Credit Purchase
    Then The Purchase Should have Been Successful
    And Should Have Been Able To Pay
    And Should Have Been Able To Verify
    And Should Have Been Able To Deliver
    And Assert Purchase Data In Credit Management, Credit Merchant Management And Report Management Is Correct

[TC-227] Online [INSTALLMENT_SALES] Purchase with [No Cash, No Fee] On [QR] and [Active Account] and [Disabled Gateway Before Verification]
    [Tags]    robot:skip
    Given Allocate No Fee INSTALLMENT SALES Account
    And Set channel QR
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway ISPG
    And Credit Gateway Activate
    And Set Amount Equal To Balance
    When Performed A Paid Online Purchase

    And Verify The Credit Purchase
    And Deliver The Credit Purchase
    Then The Purchase Should have Been Successful
    And Should Have Been Able To Verify
    And Should Have Been Able To Deliver
    And Assert Purchase Data In Credit Management, Credit Merchant Management And Report Management Is Correct

[TC-228] Online [INSTALLMENT_SALES] Purchase with [No Cash, No Fee] On [QR] and [Active Account] and [Disabled Gateway Before Delivery]
    Given Allocate No Fee INSTALLMENT SALES Account
    And Set channel QR
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway ISPG
    And Credit Gateway Activate
    And Set Amount Equal To Balance
    When Performed A Verified Online Purchase

    And Deliver The Credit Purchase
    Then The Purchase Should have Been Successful
    And Should Have Been Able To Deliver
    And Purchase Status Must Be DELIVERED
    And Assert Purchase Data In Credit Management, Credit Merchant Management And Report Management Is Correct

[TC-229] Online [INSTALLMENT_SALES] Purchase with [No Cash, No Fee] On [PAYMENT_LINK] and [Active Account] and [Active Gateway]
    Given Allocate No Fee INSTALLMENT SALES Account
    And Set channel PAYMENT_LINK
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway ISPG
    And Credit Gateway Activate
    And Set Amount Equal To Balance
    When Performed An Online Purchase
    Then The Purchase Should have Been Successful
    And Record Must Exist In Report
    And Assert Purchase Data In Credit Management, Credit Merchant Management And Report Management Is Correct

[TC-230] Online [INSTALLMENT_SALES] Purchase with [No Cash, No Fee] On [PAYMENT_LINK] and [Blocked Account] and [Active Gateway]
    Given Allocate No Fee INSTALLMENT SALES Account
    And Set channel PAYMENT_LINK
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway ISPG
    And Credit Gateway Activate
    And Set Amount Equal To Balance
    And Block Credit Account
    When Performed An Online Purchase
    Then The Purchase Should Not have Been Successful

[TC-231] Online [INSTALLMENT_SALES] Purchase with [No Cash, No Fee] On [PAYMENT_LINK] and [Blocked Account Before Prepare] and [Active Gateway]
    Given Allocate No Fee INSTALLMENT SALES Account
    And Set channel PAYMENT_LINK
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway ISPG
    And Credit Gateway Activate
    And Set Amount Equal To Balance
    When Performed An Initiated Online Purchase
    And Block Credit Account
    And Prepare The Credit Purchase
    And Route Info The Credit Purchase
    And Pay The Credit Purchase
    And Verify The Credit Purchase
    And Deliver The Credit Purchase
    Then The Purchase Should have Been Successful
    And Should Not Have Been Able To Prepare
    And Should Not Have Been Able To Route Info
    And Should Not Have Been Able To Pay
    And Should Not Have Been Able To Verify
    And Should Not Have Been Able To Deliver

[TC-232] Online [INSTALLMENT_SALES] Purchase with [No Cash, No Fee] On [PAYMENT_LINK] and [Blocked Account Before Route Info] and [Active Gateway]
    [Tags]    robot:skip
    Given Allocate No Fee INSTALLMENT SALES Account
    And Set channel PAYMENT_LINK
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway ISPG
    And Credit Gateway Activate
    And Set Amount Equal To Balance
    When Performed A Prepared Online Purchase
    And Block Credit Account
    And Route Info The Credit Purchase
    And Pay The Credit Purchase
    And Verify The Credit Purchase
    And Deliver The Credit Purchase
    Then The Purchase Should have Been Successful
    And Should Not Have Been Able To Route Info
    And Should Not Have Been Able To Pay
    And Should Not Have Been Able To Verify
    And Should Not Have Been Able To Deliver

[TC-233] Online [INSTALLMENT_SALES] Purchase with [No Cash, No Fee] On [PAYMENT_LINK] and [Blocked Account Before Credit Pay] and [Active Gateway]
    [Tags]    robot:skip
    Given Allocate No Fee INSTALLMENT SALES Account
    And Set channel PAYMENT_LINK
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway ISPG
    And Credit Gateway Activate
    And Set Amount Equal To Balance
    When Performed A Routed Online Purchase
    And Block Credit Account
    And Pay The Credit Purchase
    And Verify The Credit Purchase
    And Deliver The Credit Purchase
    Then The Purchase Should have Been Successful
    And Should Not Have Been Able To Pay
    And Should Not Have Been Able To Verify
    And Should Not Have Been Able To Deliver

[TC-234] Online [INSTALLMENT_SALES] Purchase with [No Cash, No Fee] On [PAYMENT_LINK] and [Blocked Account Before Verification] and [Active Gateway]
    [Tags]    robot:skip
    Given Allocate No Fee INSTALLMENT SALES Account
    And Set channel PAYMENT_LINK
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway ISPG
    And Credit Gateway Activate
    And Set Amount Equal To Balance
    When Performed A Paid Online Purchase
    And Block Credit Account
    And Verify The Credit Purchase
    And Deliver The Credit Purchase
    Then The Purchase Should have Been Successful
    And Should Not Have Been Able To Verify
    And Should Not Have Been Able To Deliver

[TC-235] Online [INSTALLMENT_SALES] Purchase with [No Cash, No Fee] On [PAYMENT_LINK] and [Blocked Account Before Delivery] and [Active Gateway]
    Given Allocate No Fee INSTALLMENT SALES Account
    And Set channel PAYMENT_LINK
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway ISPG
    And Credit Gateway Activate
    And Set Amount Equal To Balance
    When Performed A Verified Online Purchase
    And Block Credit Account
    And Deliver The Credit Purchase
    Then The Purchase Should have Been Successful
    And Should Have Been Able To Deliver
    And Purchase Status Must Be DELIVERED
    And Assert Purchase Data In Credit Management, Credit Merchant Management And Report Management Is Correct

[TC-236] Online [INSTALLMENT_SALES] Purchase with [No Cash, No Fee] On [PAYMENT_LINK] and [Expired Account] and [Active Gateway]
    Given Allocate No Fee INSTALLMENT SALES Account
    And Set channel PAYMENT_LINK
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway ISPG
    And Credit Gateway Activate
    And Set Amount Equal To Balance
    And Empty Balance
    And Expire Account
    When Performed An Online Purchase
    Then The Purchase Should Not have Been Successful

[TC-237] Online [INSTALLMENT_SALES] Purchase with [No Cash, No Fee] On [PAYMENT_LINK] and [Expired Account Before Prepare] and [Active Gateway]
    Given Allocate No Fee INSTALLMENT SALES Account
    And Set channel PAYMENT_LINK
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway ISPG
    And Credit Gateway Activate
    And Set Amount Equal To Balance
    When Performed An Initiated Online Purchase
    And Empty Balance
    And Expire Account
    And Prepare The Credit Purchase
    And Route Info The Credit Purchase
    And Pay The Credit Purchase
    And Verify The Credit Purchase
    And Deliver The Credit Purchase
    Then The Purchase Should have Been Successful
    And Should Not Have Been Able To Prepare
    And Should Not Have Been Able To Route Info
    And Should Not Have Been Able To Pay
    And Should Not Have Been Able To Verify
    And Should Not Have Been Able To Deliver

[TC-238] Online [INSTALLMENT_SALES] Purchase with [No Cash, No Fee] On [PAYMENT_LINK] and [Expired Account Before Route Info] and [Active Gateway]
    Given Allocate No Fee INSTALLMENT SALES Account
    And Set channel PAYMENT_LINK
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway ISPG
    And Credit Gateway Activate
    And Set Amount Equal To Balance
    When Performed A Prepared Online Purchase
    And Expire Account
    And Route Info The Credit Purchase
    And Pay The Credit Purchase
    And Verify The Credit Purchase
    And Deliver The Credit Purchase
    Then The Purchase Should have Been Successful
    And Should Have Been Able To Route Info
    And Should Have Been Able To Pay
    And Should Have Been Able To Verify
    And Should Have Been Able To Deliver
    And Assert Purchase Data In Credit Management, Credit Merchant Management And Report Management Is Correct

[TC-239] Online [INSTALLMENT_SALES] Purchase with [No Cash, No Fee] On [PAYMENT_LINK] and [Expired Account Before Credit Pay] and [Active Gateway]
    Given Allocate No Fee INSTALLMENT SALES Account
    And Set channel PAYMENT_LINK
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway ISPG
    And Credit Gateway Activate
    And Set Amount Equal To Balance
    When Performed A Routed Online Purchase
    And Expire Account
    And Pay The Credit Purchase
    And Verify The Credit Purchase
    And Deliver The Credit Purchase
    Then The Purchase Should have Been Successful
    And Should Have Been Able To Pay
    And Should Have Been Able To Verify
    And Should Have Been Able To Deliver
    And Assert Purchase Data In Credit Management, Credit Merchant Management And Report Management Is Correct

[TC-240] Online [INSTALLMENT_SALES] Purchase with [No Cash, No Fee] On [PAYMENT_LINK] and [Expired Account Before Verification] and [Active Gateway]
    Given Allocate No Fee INSTALLMENT SALES Account
    And Set channel PAYMENT_LINK
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway ISPG
    And Credit Gateway Activate
    And Set Amount Equal To Balance
    When Performed A Paid Online Purchase
    And Expire Account
    And Verify The Credit Purchase
    And Deliver The Credit Purchase
    Then The Purchase Should have Been Successful
    And Should Have Been Able To Verify
    And Should Have Been Able To Deliver
    And Assert Purchase Data In Credit Management, Credit Merchant Management And Report Management Is Correct

[TC-241] Online [INSTALLMENT_SALES] Purchase with [No Cash, No Fee] On [PAYMENT_LINK] and [Expired Account Before Delivery] and [Active Gateway]
    Given Allocate No Fee INSTALLMENT SALES Account
    And Set channel PAYMENT_LINK
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway ISPG
    And Credit Gateway Activate
    And Set Amount Equal To Balance
    When Performed A Verified Online Purchase
    And Expire Account
    And Deliver The Credit Purchase
    Then The Purchase Should have Been Successful
    And Should Have Been Able To Deliver
    And Purchase Status Must Be DELIVERED
    And Assert Purchase Data In Credit Management, Credit Merchant Management And Report Management Is Correct

[TC-242] Online [INSTALLMENT_SALES] Purchase with [No Cash, No Fee] On [PAYMENT_LINK] and [Expired Account Before Billing Cycle Assign] and [Active Gateway]
    Given Allocate No Fee INSTALLMENT SALES Account
    And Set channel PAYMENT_LINK
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway ISPG
    And Credit Gateway Activate
    And Set Amount Equal To Balance
    When Performed An Online Purchase
    And Expire Account
    And Wait For The Purchase To Be Assigned To The Billing Cycle
    Then The Purchase Should have Been Successful
    And Purchase Should Be Assigned To The Billing Cycle
    And Assert Purchase Data In Credit Management, Credit Merchant Management And Report Management Is Correct

[TC-243] Online [INSTALLMENT_SALES] Purchase with [No Cash, No Fee] On [PAYMENT_LINK] and [Zero Balance Account] and [Active Gateway]
    Given Allocate No Fee INSTALLMENT SALES Account
    And Set channel PAYMENT_LINK
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway ISPG
    And Credit Gateway Activate
    And Set Amount Equal To Balance
    And Empty Balance
    When Performed An Online Purchase
    Then The Purchase Should Not have Been Successful

[TC-244] Online [INSTALLMENT_SALES] Purchase with [No Cash, No Fee] On [PAYMENT_LINK] and [Zero Balance Account Before Prepare] and [Active Gateway]
    Given Allocate No Fee INSTALLMENT SALES Account
    And Set channel PAYMENT_LINK
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway ISPG
    And Credit Gateway Activate
    And Set Amount Equal To Balance
    When Performed An Initiated Online Purchase
    And Empty Balance
    And Prepare The Credit Purchase
    And Route Info The Credit Purchase
    And Pay The Credit Purchase
    And Verify The Credit Purchase
    And Deliver The Credit Purchase
    Then The Purchase Should have Been Successful
    And Should Not Have Been Able To Prepare
    And Should Not Have Been Able To Route Info
    And Should Not Have Been Able To Pay
    And Should Not Have Been Able To Verify
    And Should Not Have Been Able To Deliver

[TC-245] Online [INSTALLMENT_SALES] Purchase with [No Cash, No Fee] On [PAYMENT_LINK] and [Zero Balance Account Before Route Info] and [Active Gateway]
    Given Allocate No Fee INSTALLMENT SALES Account
    And Set channel PAYMENT_LINK
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway ISPG
    And Credit Gateway Activate
    And Set Amount Equal To Balance
    When Performed A Prepared Online Purchase
    And Empty Balance
    And Route Info The Credit Purchase
    And Pay The Credit Purchase
    And Verify The Credit Purchase
    And Deliver The Credit Purchase
    Then The Purchase Should have Been Successful
    And Should Have Been Able To Route Info
    And Should Not Have Been Able To Pay
    And Should Not Have Been Able To Verify
    And Should Not Have Been Able To Deliver

[TC-246] Online [INSTALLMENT_SALES] Purchase with [No Cash, No Fee] On [PAYMENT_LINK] and [Zero Balance Account Before Credit Pay] and [Active Gateway]
    Given Allocate No Fee INSTALLMENT SALES Account
    And Set channel PAYMENT_LINK
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway ISPG
    And Credit Gateway Activate
    And Set Amount Equal To Balance
    When Performed A Routed Online Purchase
    And Empty Balance
    And Pay The Credit Purchase
    And Verify The Credit Purchase
    And Deliver The Credit Purchase
    Then The Purchase Should have Been Successful
    And Should Not Have Been Able To Pay
    And Should Not Have Been Able To Verify
    And Should Not Have Been Able To Deliver

[TC-247] Online [INSTALLMENT_SALES] Purchase with [No Cash, No Fee] On [PAYMENT_LINK] and [Active Account] and [Disabled Gateway]
    Given Allocate No Fee INSTALLMENT SALES Account
    And Set channel PAYMENT_LINK
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway ISPG
    And Set Amount Equal To Balance
    And Credit Gateway Activate
    And Credit Gateway Disable
    When Performed An Online Purchase
    Then The Purchase Should Not have Been Successful

[TC-248] Online [INSTALLMENT_SALES] Purchase with [No Cash, No Fee] On [PAYMENT_LINK] and [Blocked Account] and [Disabled Gateway]
    Given Allocate No Fee INSTALLMENT SALES Account
    And Set channel PAYMENT_LINK
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway ISPG
    And Set Amount Equal To Balance
    And Block Credit Account
    And Credit Gateway Activate

    When Performed An Online Purchase
    Then The Purchase Should Not have Been Successful

[TC-249] Online [INSTALLMENT_SALES] Purchase with [No Cash, No Fee] On [PAYMENT_LINK] and [Expired Account] and [Disabled Gateway]
    Given Allocate No Fee INSTALLMENT SALES Account
    And Set channel PAYMENT_LINK
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway ISPG
    And Set Amount Equal To Balance
    And Empty Balance
    And Expire Account
    And Credit Gateway Activate

    When Performed An Online Purchase
    Then The Purchase Should Not have Been Successful

[TC-250] Online [INSTALLMENT_SALES] Purchase with [No Cash, No Fee] On [PAYMENT_LINK] and [Zero Balance Account] and [Disabled Gateway]
    Given Allocate No Fee INSTALLMENT SALES Account
    And Set channel PAYMENT_LINK
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway ISPG
    And Set Amount Equal To Balance
    And Empty Balance
    And Credit Gateway Activate

    When Performed An Online Purchase
    Then The Purchase Should Not have Been Successful

[TC-251] Online [INSTALLMENT_SALES] Purchase with [No Cash, No Fee] On [PAYMENT_LINK] and [Active Account] and [Disabled Gateway Before Prepare]
    [Tags]    robot:skip
    Given Allocate No Fee INSTALLMENT SALES Account
    And Set channel PAYMENT_LINK
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway ISPG
    And Credit Gateway Activate
    And Set Amount Equal To Balance
    When Performed An Initiated Online Purchase

    And Prepare The Credit Purchase
    And Route Info The Credit Purchase
    And Pay The Credit Purchase
    And Verify The Credit Purchase
    And Deliver The Credit Purchase
    Then The Purchase Should have Been Successful
    And Should Have Been Able To Prepare
    And Should Have Been Able To Route Info
    And Should Have Been Able To Pay
    And Should Have Been Able To Verify
    And Should Have Been Able To Deliver
    And Assert Purchase Data In Credit Management, Credit Merchant Management And Report Management Is Correct

[TC-252] Online [INSTALLMENT_SALES] Purchase with [No Cash, No Fee] On [PAYMENT_LINK] and [Active Account] and [Disabled Gateway Before Route Info]
    [Tags]    robot:skip
    Given Allocate No Fee INSTALLMENT SALES Account
    And Set channel PAYMENT_LINK
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway ISPG
    And Credit Gateway Activate
    And Set Amount Equal To Balance
    When Performed A Prepared Online Purchase
    And Route Info The Credit Purchase

    And Pay The Credit Purchase
    And Verify The Credit Purchase
    And Deliver The Credit Purchase
    Then The Purchase Should have Been Successful
    And Should Have Been Able To Route Info
    And Should Have Been Able To Pay
    And Should Have Been Able To Verify
    And Should Have Been Able To Deliver
    And Assert Purchase Data In Credit Management, Credit Merchant Management And Report Management Is Correct

[TC-253] Online [INSTALLMENT_SALES] Purchase with [No Cash, No Fee] On [PAYMENT_LINK] and [Active Account] and [Disabled Gateway Before Credit Pay]
    [Tags]    robot:skip
    Given Allocate No Fee INSTALLMENT SALES Account
    And Set channel PAYMENT_LINK
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway ISPG
    And Credit Gateway Activate
    And Set Amount Equal To Balance
    When Performed A Routed Online Purchase

    And Pay The Credit Purchase
    And Verify The Credit Purchase
    And Deliver The Credit Purchase
    Then The Purchase Should have Been Successful
    And Should Have Been Able To Pay
    And Should Have Been Able To Verify
    And Should Have Been Able To Deliver
    And Assert Purchase Data In Credit Management, Credit Merchant Management And Report Management Is Correct

[TC-254] Online [INSTALLMENT_SALES] Purchase with [No Cash, No Fee] On [PAYMENT_LINK] and [Active Account] and [Disabled Gateway Before Verification]
    [Tags]    robot:skip
    Given Allocate No Fee INSTALLMENT SALES Account
    And Set channel PAYMENT_LINK
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway ISPG
    And Credit Gateway Activate
    And Set Amount Equal To Balance
    When Performed A Paid Online Purchase

    And Verify The Credit Purchase
    And Deliver The Credit Purchase
    Then The Purchase Should have Been Successful
    And Should Have Been Able To Verify
    And Should Have Been Able To Deliver
    And Assert Purchase Data In Credit Management, Credit Merchant Management And Report Management Is Correct

[TC-255] Online [INSTALLMENT_SALES] Purchase with [No Cash, No Fee] On [PAYMENT_LINK] and [Active Account] and [Disabled Gateway Before Delivery]
    Given Allocate No Fee INSTALLMENT SALES Account
    And Set channel PAYMENT_LINK
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway ISPG
    And Credit Gateway Activate
    And Set Amount Equal To Balance
    When Performed A Verified Online Purchase

    And Deliver The Credit Purchase
    Then The Purchase Should have Been Successful
    And Should Have Been Able To Deliver
    And Purchase Status Must Be DELIVERED
    And Assert Purchase Data In Credit Management, Credit Merchant Management And Report Management Is Correct

[TC-256] Online [BNPL] Purchase with [No Cash, No Fee] On [UPG] and [Schedule Close Account] and [Active Gateway]
    Given Allocate No Fee 1PAY Account
    And Set channel UPG
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway BPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    And Call Schedule Close API
    When Performed An Online Purchase
    Then The Purchase Should Not have Been Successful

[TC-257] Online Xpay BNPL Purchase with [No Cash, No Fee] On [UPG] and [Active Account] and [Active Gateway]
    Given Allocate No Fee XPAY Account
    And Set channel UPG
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway BPG
    And Credit Gateway Activate
    And Set Amount Equal To Balance
    When Performed An Online Purchase    has_cash_pay=True
    Then The Purchase Should have Been Successful
    And Record Must Exist In Report
    And Assert Purchase Data In Credit Management, Credit Merchant Management And Report Management Is Correct
