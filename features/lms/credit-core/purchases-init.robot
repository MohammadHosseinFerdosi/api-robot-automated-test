*** Settings ***
Resource            steps/LMS/credit-core/purchases-init-step.resource

Test Setup          Initialize Merchant
Test Teardown       Reproduce Amount


*** Test Cases ***
[TC-001] Initiate Offline Purchase For 1pay Account And RepaymentOption Is 1pay Channel Is Smart POS
    Given The User Has 1pay And 4pay Accounts
    And The Channel Set To Smart POS
    And The Payment Gateway Set To BPG
    And The Gateway RepaymentOption Set To 1pay
    And The Amount Is Set To Little Than Credit Balance
    When Calling The Initiate API    ${user_id}    ${credit_ids}[0]    ${cell_number}
    Then The Response Should Countain TrackingCode
    And The Gateway Is Disabled

[TC-002] Initiate Offline Purchase For 4pay Account And RepaymentOption Is Xpay Channel Is Smart POS
    Given The User Has 1pay And 4pay Accounts
    And The Channel Set To Smart POS
    And The Payment Gateway Set To BPG
    And The Gateway RepaymentOption Set To Xpay
    And The Amount Is Set To Little Than Credit Balance
    When Calling The Initiate API    ${user_id}    ${credit_ids}[1]    ${cell_number}
    Then The Response Should Countain TrackingCode
    And The Gateway Is Disabled

[TC-003] Initiate Offline Purchase For 1pay Account And RepaymentOption Is Xpay Channel Is Smart POS
    Given The User Has 1pay And 4pay Accounts
    And The Channel Set To Smart POS
    And The Payment Gateway Set To BPG
    And The Gateway RepaymentOption Set To Xpay
    And The Amount Is Set To Greater Than Credit Balance
    When Calling The Initiate API    ${user_id}    ${credit_ids}[0]    ${cell_number}
    Then The Response Shouldn't Countain TrackingCode
    And The Gateway Is Disabled

[TC-004] Initiate Offline Purchase For 4pay Account And RepaymentOption Is 1pay Channel Is Smart POS With High Amount
    Given The User Has 1pay And 4pay Accounts
    And The Channel Set To Smart POS
    And The Payment Gateway Set To BPG
    And The Gateway RepaymentOption Set To 1pay
    And The Amount Is Set To Greater Than Credit Balance
    When Calling The Initiate API    ${user_id}    ${credit_ids}[1]    ${cell_number}
    Then The Response Shouldn't Countain TrackingCode
    And The Gateway Is Disabled

[TC-005] Initiate Offline Purchase For 4pay Account And RepaymentOption Are 1pay , Xpay Channel Is Smart POS
    Given The User Has 1pay And 4pay Accounts
    And The Channel Set To Smart POS
    And The Payment Gateway Set To BPG
    And The Gateway RepaymentOption Set To 1pay And Xpay
    And The Amount Is Set To Little Than Credit Balance
    When Calling The Initiate API    ${user_id}    ${credit_ids}[1]    ${cell_number}
    Then The Response Should Countain TrackingCode
    And The Gateway Is Disabled

[TC-006] Initiate Offline Purchase For 1pay Account And RepaymentOption Are 1pay , Xpay Channel Is Smart POS
    Given The User Has 1pay Account
    And The Channel Set To Smart POS
    And The Payment Gateway Set To BPG
    And The Gateway RepaymentOption Set To 1pay And Xpay
    And The Amount Is Set To Little Than Credit Balance
    When Calling The Initiate API    ${user_id}    ${credit_ids}[0]    ${cell_number}
    Then The Response Should Countain TrackingCode
    And The Gateway Is Disabled

[TC-007] Initiate Offline Purchase When BNPL Gateway Disable And Channel Is Smart POS
    Given The User Has 1pay Account
    And The Channel Set To Smart POS
    And The Payment Gateway Set To BPG
    And The Gateway Is Disabled
    And The Amount Is Set To Little Than Credit Balance
    When Calling The Initiate API    ${user_id}    ${credit_ids}[0]    ${cell_number}
    Then The Response Shouldn't Countain TrackingCode

[TC-008] Initiate Offline Purchase When 1pay Expired Account And Channel is Smart POS
    Given The User Has 1pay And 4pay Accounts
    And The Channel Set To Smart POS
    And The Payment Gateway Set To BPG
    And The Gateway RepaymentOption Set To 1pay And Xpay
    And Empty Balance    credit_id=${credit_ids}[0]
    And Expire Account    credit_id=${credit_ids}[0]
    And The Amount Is Set To Little Than Credit Balance
    When Calling The Initiate API    ${user_id}    ${credit_ids}[0]    ${cell_number}
    Then The Response Shouldn't Countain TrackingCode
    And The Gateway Is Disabled

[TC-009] Initiate Offline Purchase When Xpay Blocked Account And Channel is Smart POS
    Given The User Has 1pay And 4pay Accounts
    And The Channel Set To Smart POS
    And The Payment Gateway Set To BPG
    And The Gateway RepaymentOption Set To 1pay And Xpay
    And The Amount Is Set To Little Than Credit Balance
    And Account Blocked    credit_id=${credit_ids}[1]
    When Calling The Initiate API    ${user_id}    ${credit_ids}[1]    ${cell_number}
    Then The Response Shouldn't Countain TrackingCode
    And The Gateway Is Disabled

[TC-010] Initiate Offline Purchase For User With 1pay With Zero Balance Account And Channel Is Smart POS
    Given The User Has 1pay Account
    And The Channel Set To Smart POS
    And The Payment Gateway Set To BPG
    And The Gateway RepaymentOption Set To 1pay And Xpay
    And The Amount Is Set To Little Than Credit Balance
    And Empty Balance
    When Calling The Initiate API    ${user_id}    ${credit_ids}[0]    ${cell_number}
    Then The Response Shouldn't Countain TrackingCode
    And The Gateway Is Disabled

[TC-011] Initiate Offline Purchase For User With Xpay With Zero Balance Account And Channel Is Smart POS
    Given The User Has 1pay And 4pay Accounts
    And The Channel Set To Smart POS
    And The Payment Gateway Set To BPG
    And The Gateway RepaymentOption Set To 1pay And Xpay
    And The Amount Is Set To Little Than Credit Balance
    And Empty Balance    ${credit_ids}[1]
    When Calling The Initiate API    ${user_id}    ${credit_ids}[1]    ${cell_number}
    Then The Response Shouldn't Countain TrackingCode
    And The Gateway Is Disabled

[TC-012] Initiate Offline Purchase For 1pay Account And RepaymentOption Is 1pay Channel Is Linux POS
    Given The User Has 1pay And 4pay Accounts
    And The Channel Set To Linux POS
    And The Payment Gateway Set To BPG
    And The Gateway RepaymentOption Set To 1pay
    And The Amount Is Set To Little Than Credit Balance
    When Calling The Initiate API    ${user_id}    ${credit_ids}[0]    ${cell_number}
    Then The Response Should Countain TrackingCode
    And The Gateway Is Disabled

[TC-013] Initiate Offline Purchase For 4pay Account And RepaymentOption Is Xpay Channel Is Linux POS
    Given The User Has 1pay And 4pay Accounts
    And The Channel Set To Linux POS
    And The Payment Gateway Set To BPG
    And The Gateway RepaymentOption Set To Xpay
    And The Amount Is Set To Little Than Credit Balance
    When Calling The Initiate API    ${user_id}    ${credit_ids}[1]    ${cell_number}
    Then The Response Should Countain TrackingCode
    And The Gateway Is Disabled

[TC-014] Initiate Offline Purchase For 1pay Account And RepaymentOption Is Xpay Channel Is Linux POS
    Given The User Has 1pay And 4pay Accounts
    And The Channel Set To Linux POS
    And The Payment Gateway Set To BPG
    And The Gateway RepaymentOption Set To Xpay
    And The Amount Is Set To Greater Than Credit Balance
    When Calling The Initiate API    ${user_id}    ${credit_ids}[0]    ${cell_number}
    Then The Response Shouldn't Countain TrackingCode
    And The Gateway Is Disabled

[TC-015] Initiate Offline Purchase For 4pay Account And RepaymentOption Are 1pay , Xpay Channel Is Linux POS
    Given The User Has 1pay And 4pay Accounts
    And The Channel Set To Linux POS
    And The Payment Gateway Set To BPG
    And The Gateway RepaymentOption Set To 1pay And Xpay
    And The Amount Is Set To Little Than Credit Balance
    When Calling The Initiate API    ${user_id}    ${credit_ids}[1]    ${cell_number}
    Then The Response Should Countain TrackingCode
    And The Gateway Is Disabled

[TC-016] Initiate Offline Purchase When Xpay Blocked Account And Channel is Linux POS
    Given The User Has 1pay And 4pay Accounts
    And The Channel Set To Linux POS
    And The Payment Gateway Set To BPG
    And The Gateway RepaymentOption Set To 1pay And Xpay
    And The Amount Is Set To Little Than Credit Balance
    And Account Blocked    credit_id=${credit_ids}[1]
    When Calling The Initiate API    ${user_id}    ${credit_ids}[1]    ${cell_number}
    Then The Response Shouldn't Countain TrackingCode
    And The Gateway Is Disabled

[TC-017] Initiate Offline Purchase When BNPL Gateway Disable And Channel Is Linux POS
    Given The User Has 1pay Account
    And The Channel Set To Linux POS
    And The Payment Gateway Set To BPG
    And The Gateway Is Disabled
    And The Amount Is Set To Little Than Credit Balance
    When Calling The Initiate API    ${user_id}    ${credit_ids}[0]    ${cell_number}
    Then The Response Shouldn't Countain TrackingCode

[TC-018] Initiate Offline Purchase For User With Xpay With Zero Balance Account And Channel Is Linux POS
    Given The User Has 1pay And 4pay Accounts
    And The Channel Set To Linux POS
    And The Payment Gateway Set To BPG
    And The Gateway RepaymentOption Set To 1pay And Xpay
    And The Amount Is Set To Greater Than Credit Balance
    And Empty Balance    ${credit_ids}[1]
    When Calling The Initiate API    ${user_id}    ${credit_ids}[1]    ${cell_number}
    Then The Response Shouldn't Countain TrackingCode
    And The Gateway Is Disabled

[TC-019] Initiate Offline Purchase For 4pay Account And RepaymentOption Is Xpay Channel Is Linux POS With High Amount
    Given The User Has 1pay And 4pay Accounts
    And The Channel Set To Linux POS
    And The Payment Gateway Set To BPG
    And The Gateway RepaymentOption Set To Xpay
    And The Amount Is Set To Greater Than Credit Balance
    When Calling The Initiate API    ${user_id}    ${credit_ids}[1]    ${cell_number}
    Then The Response Should Countain TrackingCode
    And The Gateway Is Disabled

[TC-020] Initiate Offline Purchase For 1pay Account And RepaymentOption Is 1pay Channel Is Barcode
    Given The User Has 1pay And 4pay Accounts
    And The Channel Set To Barcode
    And The Payment Gateway Set To BPG
    And The Gateway RepaymentOption Set To 1pay
    And The Amount Is Set To Little Than Credit Balance
    When Calling The Initiate API    ${user_id}    ${credit_ids}[0]    ${cell_number}
    Then The Response Should Countain TrackingCode
    And The Gateway Is Disabled

[TC-021] Initiate Offline Purchase For 4pay Account And RepaymentOption Is Xpay Channel Is Barcode
    Given The User Has 1pay And 4pay Accounts
    And The Channel Set To Barcode
    And The Payment Gateway Set To BPG
    And The Gateway RepaymentOption Set To Xpay
    And The Amount Is Set To Little Than Credit Balance
    When Calling The Initiate API    ${user_id}    ${credit_ids}[1]    ${cell_number}
    Then The Response Should Countain TrackingCode
    And The Gateway Is Disabled

[TC-022] Initiate Offline Purchase For 1pay Account And RepaymentOption Is Xpay Channel Is Barcode
    Given The User Has 1pay And 4pay Accounts
    And The Channel Set To Barcode
    And The Payment Gateway Set To BPG
    And The Gateway RepaymentOption Set To Xpay
    And The Amount Is Set To Greater Than Credit Balance
    When Calling The Initiate API    ${user_id}    ${credit_ids}[0]    ${cell_number}
    Then The Response Shouldn't Countain TrackingCode
    And The Gateway Is Disabled

[TC-023] Initiate Offline Purchase For 4pay Account And RepaymentOption Are 1pay , Xpay Channel Is Barcode
    Given The User Has 1pay And 4pay Accounts
    And The Channel Set To Barcode
    And The Payment Gateway Set To BPG
    And The Gateway RepaymentOption Set To 1pay And Xpay
    And The Amount Is Set To Little Than Credit Balance
    When Calling The Initiate API    ${user_id}    ${credit_ids}[1]    ${cell_number}
    Then The Response Should Countain TrackingCode
    And The Gateway Is Disabled

[TC-024] Initiate Offline Purchase When BNPL Gateway Disable And Channel Is Barcode
    Given The User Has 1pay And 4pay Accounts
    And The Channel Set To Barcode
    And The Payment Gateway Set To BPG
    And The Gateway Is Disabled
    And The Amount Is Set To Little Than Credit Balance
    When Calling The Initiate API    ${user_id}    ${credit_ids}[1]    ${cell_number}
    Then The Response Shouldn't Countain TrackingCode

[TC-025] Initiate Offline Purchase when Xpay Blocked Account And Channel is Barcode
    Given The User Has 1pay And 4pay Accounts
    And The Channel Set To Barcode
    And The Payment Gateway Set To BPG
    And The Gateway RepaymentOption Set To 1pay And Xpay
    And The Amount Is Set To Little Than Credit Balance
    And Account Blocked    credit_id=${credit_ids}[0]
    When Calling The Initiate API    ${user_id}    ${credit_ids}[1]    ${cell_number}
    Then The Response Should Countain TrackingCode
    And The Gateway Is Disabled

[TC-026] Initiate Offline Purchase For User With Xpay With Zero Balance Account And Channel Is Barcode
    Given The User Has 1pay And 4pay Accounts
    And The Channel Set To Barcode
    And The Payment Gateway Set To BPG
    And The Gateway RepaymentOption Set To 1pay And Xpay
    And The Amount Is Set To Equal To Credit Balance
    And Empty Balance    ${credit_ids}[1]
    When Calling The Initiate API    ${user_id}    ${credit_ids}[1]    ${cell_number}
    Then The Response Shouldn't Countain TrackingCode
    And The Gateway Is Disabled

[TC-027] Initiate Offline Purchase For 4pay Account And RepaymentOption Is Xpay Channel Is Barcode With High Amount
    Given The User Has 1pay And 4pay Accounts
    And The Channel Set To Barcode
    And The Payment Gateway Set To BPG
    And The Gateway RepaymentOption Set To Xpay
    And The Amount Is Set To Greater Than Credit Balance
    When Calling The Initiate API    ${user_id}    ${credit_ids}[1]    ${cell_number}
    Then The Response Shouldn't Countain TrackingCode
    And The Gateway Is Disabled

[TC-028] Initiate Offline Purchase For Credit Account And RepaymentOption Is Xpay Channel Is Smart POS
    Given The User Has 1pay , 4pay And Credit Accounts
    And The Channel Set To Smart POS
    And The Payment Gateway Set To CPG
    And The Gateway RepaymentOption Set To Xpay
    And The Amount Is Set To Little Than Credit Balance
    When Calling The Initiate API    ${user_id}    ${credit_ids}[2]    ${cell_number}
    Then The Response Should Countain TrackingCode
    And The Gateway Is Disabled

[TC-029] Initiate Offline Purchase For Credit Account And RepaymentOption Is 1pay Channel Is Smart POS
    Given The User Has 1pay , 4pay And Credit Accounts
    And The Channel Set To Smart POS
    And The Payment Gateway Set To CPG
    And The Gateway RepaymentOption Set To 1pay
    And The Amount Is Set To Little Than Credit Balance
    When Calling The Initiate API    ${user_id}    ${credit_ids}[2]    ${cell_number}
    Then The Response Shouldn't Countain TrackingCode
    And The Gateway Is Disabled

[TC-030] Initiate Offline Purchase For Credit Account With High Amount Channel Is Smart POS
    Given The User Has 1pay , 4pay And Credit Accounts
    And The Channel Set To Smart POS
    And The Payment Gateway Set To CPG
    And The Gateway RepaymentOption Set To Xpay
    And The Amount Is Set To Greater Than Credit Balance
    When Calling The Initiate API    ${user_id}    ${credit_ids}[2]    ${cell_number}
    Then The Response Should Countain TrackingCode
    And The Gateway Is Disabled

[TC-031] Initiate Offline Purchase When CPG Gateway Disable And Channel Is Smart POS
    Given The User Has 1pay , 4pay And Credit Accounts
    And The Channel Set To Smart POS
    And The Payment Gateway Set To CPG
    And The Gateway Is Disabled
    And The Amount Is Set To Little Than Credit Balance
    When Calling The Initiate API    ${user_id}    ${credit_ids}[2]    ${cell_number}
    Then The Response Shouldn't Countain TrackingCode

[TC-032] Initiate Offline Purchase when Credit Expired Account And Channel is Smart POS
    Given The User Has 1pay , 4pay And Credit Accounts
    And The Channel Set To Smart POS
    And The Payment Gateway Set To CPG
    And The Gateway RepaymentOption Set To 1pay And Xpay
    And Empty Balance    credit_id=${credit_ids}[2]
    And Expire Account    credit_id=${credit_ids}[2]
    And The Amount Is Set To Little Than Credit Balance
    When Calling The Initiate API    ${user_id}    ${credit_ids}[2]    ${cell_number}
    Then The Response Shouldn't Countain TrackingCode
    And The Gateway Is Disabled

[TC-033] Initiate Offline Purchase When Credit Blocked Account And Channel is Smart POS
    Given The User Has 1pay , 4pay And Credit Accounts
    And The Channel Set To Smart POS
    And The Payment Gateway Set To CPG
    And The Gateway RepaymentOption Set To 1pay And Xpay
    And The Amount Is Set To Little Than Credit Balance
    And Account Blocked    credit_id=${credit_ids}[2]
    When Calling The Initiate API    ${user_id}    ${credit_ids}[2]    ${cell_number}
    Then The Response Shouldn't Countain TrackingCode
    And The Gateway Is Disabled

[TC-034] Initiate Offline Purchase For User With Credit With Zero Balance Account And Channel Is Smart POS
    Given The User Has 4pay And Credit Accounts
    And The Channel Set To Smart POS
    And The Payment Gateway Set To CPG
    And The Gateway RepaymentOption Set To 1pay And Xpay
    And The Amount Is Set To Little Than Credit Balance
    And Empty Balance    ${credit_ids}[1]
    When Calling The Initiate API    ${user_id}    ${credit_ids}[1]    ${cell_number}
    Then The Response Shouldn't Countain TrackingCode
    And The Gateway Is Disabled

[TC-035] Initiate Offline Purchase For Installment Account And RepaymentOption Is Xpay Channel Is Barcode
    [Tags]    robot:skip
    Given The User Has Installment Account
    And The Channel Set To Barcode
    And The Payment Gateway Set To ISPG
    And The Gateway RepaymentOption Set To Xpay
    And The Amount Is Set To Equal To Credit Balance
    When Calling The Initiate API    ${user_id}    ${credit_ids}[0]    ${cell_number}
    Then The Response Should Countain TrackingCode
    And The Gateway Is Disabled

[TC-036] Initiate Offline Purchase For Installment Account And RepaymentOption Is 1pay Channel Is Barcode
    Given The User Has Installment Account
    And The Channel Set To Barcode
    And The Payment Gateway Set To ISPG
    And The Gateway RepaymentOption Set To 1pay
    And The Amount Is Set To Equal To Credit Balance
    When Calling The Initiate API    ${user_id}    ${credit_ids}[0]    ${cell_number}
    Then The Response Shouldn't Countain TrackingCode
    And The Gateway Is Disabled

[TC-037] Initiate Offline Purchase For Installment Account With High Amount Channel Is Barcode
    [Tags]    robot:skip
    Given The User Has Installment Account
    And The Channel Set To Barcode
    And The Payment Gateway Set To ISPG
    And The Gateway RepaymentOption Set To Xpay
    And The Amount Is Set To Greater Than Credit Balance
    When Calling The Initiate API    ${user_id}    ${credit_ids}[0]    ${cell_number}
    Then The Response Should Countain TrackingCode
    And The Gateway Is Disabled

[TC-038] Initiate Offline Purchase When ISPG Gateway Disable And Channel Is Barcode
    Given The User Has Installment Account
    And The Channel Set To Barcode
    And The Payment Gateway Set To ISPG
    And The Gateway Is Disabled
    And The Amount Is Set To Equal To Credit Balance
    When Calling The Initiate API    ${user_id}    ${credit_ids}[0]    ${cell_number}
    Then The Response Shouldn't Countain TrackingCode

[TC-039] Initiate Offline Purchase When ISPG Gateway Doesn't Exist And Channel Is Barcode
    Given The User Has Installment Account
    And The Channel Set To Barcode
    And The Payment Gateway Set To CPG
    And The Amount Is Set To Equal To Credit Balance
    When Calling The Initiate API    ${user_id}    ${credit_ids}[0]    ${cell_number}
    Then The Response Shouldn't Countain TrackingCode
    And The Gateway Is Disabled

[TC-040] Initiate Offline Purchase in Installment Expired Account And Channel is Barcode
    [Tags]    robot:skip
    Given The User Has Installment Account
    And The Channel Set To Barcode
    And The Payment Gateway Set To ISPG
    And The Gateway RepaymentOption Set To 1pay And Xpay
    And Empty Balance    credit_id=${credit_ids}[0]
    And Expire Account    credit_id=${credit_ids}[0]
    And The Amount Is Set To Equal To Credit Balance
    When Calling The Initiate API    ${user_id}    ${credit_ids}[0]    ${cell_number}
    Then The Response Shouldn't Countain TrackingCode
    And The Gateway Is Disabled

[TC-041] Initiate Offline Purchase When Installment Blocked Account And Channel is Barcode
    Given The User Has Installment Account
    And The Channel Set To Barcode
    And The Payment Gateway Set To ISPG
    And The Gateway RepaymentOption Set To 1pay And Xpay
    And The Amount Is Set To Equal To Credit Balance
    And Account Blocked    credit_id=${credit_ids}[0]
    When Calling The Initiate API    ${user_id}    ${credit_ids}[0]    ${cell_number}
    Then The Response Shouldn't Countain TrackingCode
    And The Gateway Is Disabled

[TC-042] Initiate Offline Purchase For 1pay Account And RepaymentOption Is 1pay Channel Is API
    Given The User Has 1pay And 4pay Accounts
    And The Channel Set To API
    And The Payment Gateway Set To BPG
    And The Gateway RepaymentOption Set To 1pay
    And The Amount Is Set To Little Than Credit Balance
    When Calling The Initiate API    ${user_id}    ${credit_ids}[0]    ${cell_number}    terminal_id=123456789
    Then The Response Should Countain TrackingCode
    And The Gateway Is Disabled

[TC-043] Initiate Offline Purchase For 4pay Account And RepaymentOption Is Xpay Channel Is Linux POS
    Given The User Has 1pay And 4pay Accounts
    And The Channel Set To Linux POS
    And The Payment Gateway Set To BPG
    And The Gateway RepaymentOption Set To Xpay
    And The Amount Is Set To Little Than Credit Balance
    When Calling The Initiate API    ${user_id}    ${credit_ids}[1]    ${cell_number}    terminal_id=123456789
    Then The Response Should Countain TrackingCode
    And The Gateway Is Disabled

[TC-044] Initiate Offline Purchase For User With Credit With Zero Balance Account And Channel Is Smart POS
    Given The User Has 4pay And Credit Accounts
    And The Channel Set To Smart POS
    And The Payment Gateway Set To CPG
    And The Gateway RepaymentOption Set To Xpay
    And The Amount Is Set To Little Than Credit Balance
    When Calling The Initiate API    ${user_id}    ${credit_ids}[1]    ${cell_number}    terminal_id=123456789
    Then The Response Should Countain TrackingCode
    And The Gateway Is Disabled

[TC-045] Initiate Offline Purchase For Installment Account And RepaymentOption Is Xpay Channel Is Barcode
    [Tags]    robot:skip
    Given The User Has Installment Account
    And The Channel Set To Barcode
    And The Payment Gateway Set To ISPG
    And The Gateway RepaymentOption Set To Xpay
    And The Amount Is Set To Equal To Credit Balance
    When Calling The Initiate API    ${user_id}    ${credit_ids}[0]    ${cell_number}    terminal_id=123456789
    Then The Response Should Countain TrackingCode
    And The Gateway Is Disabled
