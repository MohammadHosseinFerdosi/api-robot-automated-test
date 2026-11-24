*** Settings ***
Resource            steps/LMS/credit-core/purchase-info-step.resource

Test Setup          Initialize Merchant
Test Teardown       Reproduce Amount


*** Test Cases ***
[TC-001] Purchase Info For User With Credit Account RepaymentOption Is 1pay And Xpay And Channel Is UPG And Amount Is less Than Credit Balance
    Given The User Has 1pay, 4pay, And Credit Accounts
    And The Channel Is Set To UPG
    And The Ticket Type Is Set To Credit
    And The Payment Gateway Is Set To CPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And The Amount Is Set To Little Than Credit Balance
    And Get a Ticket And Initiate Purchase    credit_id=${credit_ids}[2]
    when The Purchase Info Api Called
    Then The Response Of Credit With RepaymentOption Xpay Should Contain Account
    And The Gateway Is Disabled

[TC-002] Purchase Info For User With Credit Account RepaymentOption Is 1pay And Channel Is UPG And Amount Is less Than Credit Balance
    Given The User Has 1pay, 4pay, And Credit Accounts
    And The Channel Is Set To UPG
    And The Ticket Type Is Set To Credit
    And The Payment Gateway Is Set To CPG
    And The Gateway RepaymentOption Is Set To 1pay
    And The Amount Is Set To Little Than Credit Balance
    And Get a Ticket And Initiate Purchase    credit_id=${credit_ids}[2]
    When The Purchase Info Api Called
    Then The Response Shouldn't Contain CreditDetails
    And The Gateway Is Disabled

[TC-003] Purchase Info For User Credit Account RepaymentOption Is Xpay And Channel Is UPG And Amount Is Greater Than Credit Balance
    Given The User Has 4pay And Credit Accounts
    And The Channel Is Set To UPG
    And The Ticket Type Is Set To Credit
    And The Payment Gateway Is Set To CPG
    And The Gateway RepaymentOption Is Set To Xpay
    And The Amount Is Set To Greater Than Credit Balance
    And Get a Ticket And Initiate Purchase    credit_id=${credit_ids}[1]
    When The Purchase Info Api Called
    Then The Response Of Credit With RepaymentOption Xpay Should Contain Account
    And The Gateway Is Disabled

[TC-004] Purchase Info For User Has Credit Account Gateway Disable And Channel Is UPG
    Given The User Has 4pay And Credit Accounts
    And The Channel Is Set To UPG
    And The Ticket Type Is Set To Credit
    And The Payment Gateway Is Set To CPG
    And The Gateway RepaymentOption Is Set To Xpay
    And The Amount Is Set To Greater Than Credit Balance
    And Get a Ticket And Initiate Purchase    credit_id=${credit_ids}[1]
    And The Gateway Is Disabled
    When The Purchase Info Api Called
    Then The Response Shouldn't Contain CreditDetails

[TC-005] Purchase Info For User Has Expired Credit Account And Channel Is UPG
    Given The User Has 4pay And Credit Accounts
    And The Channel Is Set To UPG
    And The Ticket Type Is Set To Credit
    And The Payment Gateway Is Set To CPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And The Amount Is Set To Little Than Credit Balance
    And Get a Ticket And Initiate Purchase    credit_id=${credit_ids}[1]
    And Empty Balance    credit_id=${credit_ids}[1]
    And Expire Account    credit_id=${credit_ids}[1]
    When The Purchase Info Api Called
    Then The Response Shouldn't Contain CreditDetails
    And The Gateway Is Disabled

[TC-006] Purchase Info For User Has Blocked Credit Account And Channel Is UPG
    Given The User Has 4pay And Credit Accounts
    And The Channel Is Set To UPG
    And The Ticket Type Is Set To Credit
    And The Payment Gateway Is Set To CPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And The Amount Is Set To Little Than Credit Balance
    And Get a Ticket And Initiate Purchase    credit_id=${credit_ids}[1]
    And Block credit account    credit_id=${credit_ids}[1]
    When The Purchase Info Api Called
    Then The Response Should Contain Disabled Account
    And The Gateway Is Disabled

[TC-007] Purchase Info For User With Credit Zero Balance And Channel is UPG
    Given The User Has 4pay And Credit Accounts
    And The Channel Is Set To UPG
    And The Ticket Type Is Set To Credit
    And The Payment Gateway Is Set To CPG
    And The Gateway RepaymentOption Is Set To Xpay
    And The Amount Is Set To Greater Than Credit Balance
    And Empty Balance    credit_id=${credit_ids}[1]
    And Get a Ticket And Initiate Purchase    credit_id=${credit_ids}[1]
    When The Purchase Info Api Called
    Then The Response For Account With Zero Balance
    And The Gateway Is Disabled

[TC-008] Purchase Info For User With Credit Account RepaymentOption Is 1pay And Xpay And Channel Is Smart Pos And Amount Is less Than Credit Balance
    Given The User Has 1pay, 4pay, And Credit Accounts
    And The Channel Is Set To Smart POS
    And The Ticket Type Is Set To Credit
    And The Payment Gateway Is Set To CPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And The Amount Is Set To Little Than Credit Balance
    When Get a Ticket And Initiate Purchase    credit_id=${credit_ids}[2]
    Then The Ticket Generation Must Have Failed
    And The Gateway Is Disabled

[TC-009] Purchase Info For User With Credit Account RepaymentOption Is 1pay And Channel Is Smart Pos And Amount Is less Than Credit Balance
    Given The User Has 1pay, 4pay, And Credit Accounts
    And The Channel Is Set To Smart POS
    And The Ticket Type Is Set To Credit
    And The Payment Gateway Is Set To CPG
    And The Gateway RepaymentOption Is Set To 1pay
    And The Amount Is Set To Little Than Credit Balance
    When Get a Ticket And Initiate Purchase    credit_id=${credit_ids}[2]
    Then The Ticket Generation Must Have Failed
    And The Gateway Is Disabled

[TC-010] Purchase Info For User Credit Account RepaymentOption Is Xpay And Channel Is Smart Pos And Amount Is Greater Than Credit Balance
    Given The User Has 4pay And Credit Accounts
    And The Channel Is Set To Smart POS
    And The Ticket Type Is Set To Credit
    And The Payment Gateway Is Set To CPG
    And The Gateway RepaymentOption Is Set To Xpay
    And The Amount Is Set To Greater Than Credit Balance
    When Get a Ticket And Initiate Purchase    credit_id=${credit_ids}[1]
    Then The Ticket Generation Must Have Failed
    And The Gateway Is Disabled

[TC-011] Purchase Info For User Has Credit Account Gateway Disable And Channel Is Smart Pos
    Given The User Has 4pay And Credit Accounts
    And The Channel Is Set To Smart POS
    And The Ticket Type Is Set To Credit
    And The Payment Gateway Is Set To CPG
    And The Gateway RepaymentOption Is Set To Xpay
    And The Amount Is Set To Greater Than Credit Balance
    When Get a Ticket And Initiate Purchase    credit_id=${credit_ids}[1]
    And The Gateway Is Disabled
    Then The Ticket Generation Must Have Failed

[TC-012] Purchase Info For User Has Expired Credit Account And Channel Is Smart Pos
    Given The User Has 4pay And Credit Accounts
    And The Channel Is Set To Smart POS
    And The Ticket Type Is Set To Credit
    And The Payment Gateway Is Set To CPG
    And The Gateway RepaymentOption Is Set To Xpay
    And Empty Balance    credit_id=${credit_ids}[1]
    And Expire Account    credit_id=${credit_ids}[1]
    And The Amount Is Set To Greater Than Credit Balance
    When Get a Ticket And Initiate Purchase    credit_id=${credit_ids}[1]
    Then The Ticket Generation Must Have Failed
    And The Gateway Is Disabled

[TC-013] Purchase Info For User Has Bloked Credit Account And Channel Is Smart Pos
    Given The User Has 4pay And Credit Accounts
    And The Channel Is Set To Smart POS
    And The Ticket Type Is Set To Credit
    And The Payment Gateway Is Set To CPG
    And The Gateway RepaymentOption Is Set To Xpay
    And The Amount Is Set To Greater Than Credit Balance
    When Get a Ticket And Initiate Purchase    credit_id=${credit_ids}[1]
    And Block credit account    credit_id=${credit_ids}[1]
    Then The Ticket Generation Must Have Failed
    And The Gateway Is Disabled

[TC-014] Purchase Info For User With Credit Zero Balance And Channel is Smart Pos
    Given The User Has 4pay And Credit Accounts
    And The Channel Is Set To Smart POS
    And The Ticket Type Is Set To Credit
    And The Payment Gateway Is Set To CPG
    And The Gateway RepaymentOption Is Set To Xpay
    And The Amount Is Set To Greater Than Credit Balance
    And Empty Balance    credit_id=${credit_ids}[1]
    When Get a Ticket And Initiate Purchase    credit_id=${credit_ids}[1]
    Then The Ticket Generation Must Have Failed
    And The Gateway Is Disabled

[TC-015] Purchase Info For User With Credit Account RepaymentOption Is 1pay And Xpay And Channel Is API And Amount Is less Than Credit Balance
    Given The User Has 1pay, 4pay, And Credit Accounts
    And The Channel Is Set To API
    And The Ticket Type Is Set To Credit
    And The Payment Gateway Is Set To CPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And The Amount Is Set To Little Than Credit Balance
    When Get a Ticket And Initiate Purchase    credit_id=${credit_ids}[2]
    Then The Ticket Generation Must Have Failed
    And The Gateway Is Disabled

[TC-016] Purchase Info For User With Credit Account RepaymentOption Is 1pay And Channel Is API And Amount Is less Than Credit Balance
    Given The User Has 1pay, 4pay, And Credit Accounts
    And The Channel Is Set To API
    And The Ticket Type Is Set To Credit
    And The Payment Gateway Is Set To CPG
    And The Gateway RepaymentOption Is Set To 1pay
    And The Amount Is Set To Little Than Credit Balance
    When Get a Ticket And Initiate Purchase    credit_id=${credit_ids}[2]
    Then The Ticket Generation Must Have Failed
    And The Gateway Is Disabled

[TC-017] Purchase Info For User Credit Account RepaymentOption Is Xpay And Channel Is API And Amount Is Greater Than Credit Balance
    Given The User Has 4pay And Credit Accounts
    And The Channel Is Set To API
    And The Ticket Type Is Set To Credit
    And The Payment Gateway Is Set To CPG
    And The Gateway RepaymentOption Is Set To Xpay
    And The Amount Is Set To Greater Than Credit Balance
    When Get a Ticket And Initiate Purchase    credit_id=${credit_ids}[1]
    Then The Ticket Generation Must Have Failed
    And The Gateway Is Disabled

[TC-018] Purchase Info For User Has Credit Account Gateway Disable And Channel Is API
    Given The User Has 4pay And Credit Accounts
    And The Channel Is Set To API
    And The Ticket Type Is Set To Credit
    And The Payment Gateway Is Set To CPG
    And The Gateway RepaymentOption Is Set To Xpay
    And The Amount Is Set To Greater Than Credit Balance
    When Get a Ticket And Initiate Purchase    credit_id=${credit_ids}[1]
    And The Gateway Is Disabled
    Then The Ticket Generation Must Have Failed

[TC-019] Purchase Info For User Has Expired Credit Account And Channel Is API
    Given The User Has 4pay And Credit Accounts
    And The Channel Is Set To API
    And The Ticket Type Is Set To Credit
    And The Payment Gateway Is Set To CPG
    And The Gateway RepaymentOption Is Set To Xpay
    And The Amount Is Set To Greater Than Credit Balance
    When Get a Ticket And Initiate Purchase    credit_id=${credit_ids}[1]
    And Empty Balance    credit_id=${credit_ids}[1]
    And Expire Account    credit_id=${credit_ids}[1]
    Then The Ticket Generation Must Have Failed
    And The Gateway Is Disabled

[TC-020] Purchase Info For User Has Blocked Credit Account And Channel Is API
    Given The User Has 4pay And Credit Accounts
    And The Channel Is Set To API
    And The Ticket Type Is Set To Credit
    And The Payment Gateway Is Set To CPG
    And The Gateway RepaymentOption Is Set To Xpay
    And The Amount Is Set To Greater Than Credit Balance
    When Get a Ticket And Initiate Purchase    credit_id=${credit_ids}[1]
    And Block credit account    credit_id=${credit_ids}[1]
    Then The Ticket Generation Must Have Failed
    And The Gateway Is Disabled

[TC-021] Purchase Info For User With Credit Zero Balance And Channel is API
    Given The User Has 4pay And Credit Accounts
    And The Channel Is Set To API
    And The Ticket Type Is Set To Credit
    And The Payment Gateway Is Set To CPG
    And The Gateway RepaymentOption Is Set To Xpay
    And The Amount Is Set To Greater Than Credit Balance
    And Empty Balance    credit_id=${credit_ids}[1]
    When Get a Ticket And Initiate Purchase    credit_id=${credit_ids}[1]
    Then The Ticket Generation Must Have Failed
    And The Gateway Is Disabled

[TC-022] Purchase Info For User With Credit Account RepaymentOption Is 1pay And Xpay And Channel Is Escrow And Amount Is less Than Credit Balance
    Given The User Has 1pay, 4pay, And Credit Accounts
    And The Channel Is Set To Escrow
    And The Ticket Type Is Set To Credit
    And The Payment Gateway Is Set To CPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And The Amount Is Set To Little Than Credit Balance
    And Get a Ticket And Initiate Purchase    credit_id=${credit_ids}[2]
    when The Purchase Info Api Called
    Then The Response Of Credit With RepaymentOption Xpay Should Contain Account
    And The Gateway Is Disabled

[TC-023] Purchase Info For User With Credit Account RepaymentOption Is 1pay And Channel Is Escrow And Amount Is less Than Credit Balance
    Given The User Has 1pay, 4pay, And Credit Accounts
    And The Channel Is Set To Escrow
    And The Ticket Type Is Set To Credit
    And The Payment Gateway Is Set To CPG
    And The Gateway RepaymentOption Is Set To 1pay
    And The Amount Is Set To Little Than Credit Balance
    And Get a Ticket And Initiate Purchase    credit_id=${credit_ids}[2]
    When The Purchase Info Api Called
    Then The Response Shouldn't Contain CreditDetails
    And The Gateway Is Disabled

[TC-024] Purchase Info For User Credit Account RepaymentOption Is Xpay And Channel Is Escrow And Amount Is Greater Than Credit Balance
    Given The User Has 4pay And Credit Accounts
    And The Channel Is Set To Escrow
    And The Ticket Type Is Set To Credit
    And The Payment Gateway Is Set To CPG
    And The Gateway RepaymentOption Is Set To Xpay
    And The Amount Is Set To Greater Than Credit Balance
    And Get a Ticket And Initiate Purchase    credit_id=${credit_ids}[1]
    When The Purchase Info Api Called
    Then The Response Of Credit With RepaymentOption Xpay Should Contain Account
    And The Gateway Is Disabled

[TC-025] Purchase Info For User Has Credit Account Gateway Disable And Channel Is Escrow
    Given The User Has 4pay And Credit Accounts
    And The Channel Is Set To Escrow
    And The Ticket Type Is Set To Credit
    And The Payment Gateway Is Set To CPG
    And The Gateway RepaymentOption Is Set To Xpay
    And The Amount Is Set To Greater Than Credit Balance
    And Get a Ticket And Initiate Purchase    credit_id=${credit_ids}[1]
    And The Gateway Is Disabled
    When The Purchase Info Api Called
    Then The Response Shouldn't Contain CreditDetails

[TC-026] Purchase Info For User Has Expired Credit Account And Channel Is Escrow
    Given The User Has 4pay And Credit Accounts
    And The Channel Is Set To Escrow
    And The Ticket Type Is Set To Credit
    And The Payment Gateway Is Set To CPG
    And The Gateway RepaymentOption Is Set To Xpay
    And Empty Balance    credit_id=${credit_ids}[1]
    And Expire Account    credit_id=${credit_ids}[1]
    And The Amount Is Set To Greater Than Credit Balance
    And Get a Ticket And Initiate Purchase    credit_id=${credit_ids}[1]
    When The Purchase Info Api Called
    Then The Response Shouldn't Contain CreditDetails
    And The Gateway Is Disabled

[TC-027] Purchase Info For User Has Blocked Credit Account And Channel Is Escrow
    Given The User Has 4pay And Credit Accounts
    And The Channel Is Set To Escrow
    And The Ticket Type Is Set To Credit
    And The Payment Gateway Is Set To CPG
    And The Gateway RepaymentOption Is Set To Xpay
    And Block credit account    credit_id=${credit_ids}[1]
    And The Amount Is Set To Greater Than Credit Balance
    And Get a Ticket And Initiate Purchase    credit_id=${credit_ids}[1]
    When The Purchase Info Api Called
    Then The Response Should Contain Disabled Account
    And The Gateway Is Disabled

[TC-028] Purchase Info For User With Credit Zero Balance And Channel is Escrow
    Given The User Has 4pay And Credit Accounts
    And The Channel Is Set To Escrow
    And The Ticket Type Is Set To Credit
    And The Payment Gateway Is Set To CPG
    And The Gateway RepaymentOption Is Set To Xpay
    And The Amount Is Set To Greater Than Credit Balance
    And Empty Balance    credit_id=${credit_ids}[1]
    And Get a Ticket And Initiate Purchase    credit_id=${credit_ids}[1]
    When The Purchase Info Api Called
    Then The Response For Account With Zero Balance
    And The Gateway Is Disabled

[TC-029] Purchase Info For User With Credit Account RepaymentOption Is 1pay And Xpay And Channel Is Barcode And Amount Is less Than Credit Balance
    Given The User Has 1pay, 4pay, And Credit Accounts
    And The Channel Is Set To Barcode
    And The Ticket Type Is Set To Credit
    And The Payment Gateway Is Set To CPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And The Amount Is Set To Little Than Credit Balance
    When Get a Ticket And Initiate Purchase    credit_id=${credit_ids}[2]
    Then The Ticket Generation Must Have Failed
    And The Gateway Is Disabled

[TC-030] Purchase Info For User With Credit Account RepaymentOption Is 1pay And Channel Is Barcode And Amount Is less Than Credit Balance
    Given The User Has 1pay, 4pay, And Credit Accounts
    And The Channel Is Set To Barcode
    And The Ticket Type Is Set To Credit
    And The Payment Gateway Is Set To CPG
    And The Gateway RepaymentOption Is Set To 1pay
    And The Amount Is Set To Little Than Credit Balance
    When Get a Ticket And Initiate Purchase    credit_id=${credit_ids}[2]
    Then The Ticket Generation Must Have Failed
    And The Gateway Is Disabled

[TC-031] Purchase Info For User Credit Account RepaymentOption Is Xpay And Channel Is Barcode And Amount Is Greater Than Credit Balance
    Given The User Has 4pay And Credit Accounts
    And The Channel Is Set To Barcode
    And The Ticket Type Is Set To Credit
    And The Payment Gateway Is Set To CPG
    And The Gateway RepaymentOption Is Set To Xpay
    And The Amount Is Set To Greater Than Credit Balance
    When Get a Ticket And Initiate Purchase    credit_id=${credit_ids}[1]
    Then The Ticket Generation Must Have Failed
    And The Gateway Is Disabled

[TC-032] Purchase Info For User Has Credit Account Gateway Disable And Channel Is Barcode
    Given The User Has 4pay And Credit Accounts
    And The Channel Is Set To Barcode
    And The Ticket Type Is Set To Credit
    And The Payment Gateway Is Set To CPG
    And The Gateway RepaymentOption Is Set To Xpay
    And The Amount Is Set To Greater Than Credit Balance
    When Get a Ticket And Initiate Purchase    credit_id=${credit_ids}[1]
    And The Gateway Is Disabled
    Then The Ticket Generation Must Have Failed

[TC-033] Purchase Info For User Has Expired Credit Account And Channel Is Barcode
    Given The User Has 4pay And Credit Accounts
    And The Channel Is Set To Barcode
    And The Ticket Type Is Set To Credit
    And The Payment Gateway Is Set To CPG
    And The Gateway RepaymentOption Is Set To Xpay
    And Empty Balance    credit_id=${credit_ids}[1]
    And Expire Account    credit_id=${credit_ids}[1]
    And The Amount Is Set To Equal To Credit Balance
    When Get a Ticket And Initiate Purchase    credit_id=${credit_ids}[1]
    Then The Ticket Generation Must Have Failed
    And The Gateway Is Disabled

[TC-034] Purchase Info For User Has Blocked Credit Account And Channel Is Barcode
    Given The User Has 4pay And Credit Accounts
    And The Channel Is Set To Barcode
    And The Ticket Type Is Set To Credit
    And The Payment Gateway Is Set To CPG
    And The Gateway RepaymentOption Is Set To Xpay
    And Block credit account    credit_id=${credit_ids}[1]
    And The Amount Is Set To Equal To Credit Balance
    When Get a Ticket And Initiate Purchase    credit_id=${credit_ids}[1]
    Then The Ticket Generation Must Have Failed
    And The Gateway Is Disabled

[TC-035] Purchase Info For User With Credit Zero Balance And Channel is Barcode
    Given The User Has 4pay And Credit Accounts
    And The Channel Is Set To Barcode
    And The Ticket Type Is Set To Credit
    And The Payment Gateway Is Set To CPG
    And The Gateway RepaymentOption Is Set To Xpay
    And The Amount Is Set To Greater Than Credit Balance
    And Empty Balance    credit_id=${credit_ids}[1]
    When Get a Ticket And Initiate Purchase    credit_id=${credit_ids}[1]
    Then The Ticket Generation Must Have Failed
    And The Gateway Is Disabled

[TC-036] Purchase Info For User With 4Pay Account RepaymentOption Is 1pay And Xpay And Channel Is UPG And Amount Is less Than Credit Balance
    Given The User Has 4pay And Credit Accounts
    And The Channel Is Set To UPG
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And The Amount Is Set To Little Than Credit Balance
    And Get a Ticket And Initiate Purchase    credit_id=${credit_ids}[0]
    when The Purchase Info Api Called
    Then The Response Of BNPL With RepaymentOption Xpay Should Contain Account
    And The Gateway Is Disabled

[TC-037] Purchase Info For User With 4Pay Account RepaymentOption Is 1pay And Channel Is UPG And Amount Is less Than Credit Balance
    Given The User Has 1pay, 4pay, And Credit Accounts
    And The Channel Is Set To UPG
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay
    And The Amount Is Set To Little Than Credit Balance
    And Get a Ticket And Initiate Purchase    credit_id=${credit_ids}[1]
    When The Purchase Info Api Called
    Then The Response Shouldn't Contain CreditDetails
    And The Gateway Is Disabled

[TC-038] Purchase Info For User 4Pay Account RepaymentOption Is Xpay And Channel Is UPG And Amount Is Greater Than Credit Balance
    Given The User Has 4pay And Credit Accounts
    And The Channel Is Set To UPG
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To Xpay
    And The Amount Is Set To Greater Than Credit Balance
    And Get a Ticket And Initiate Purchase    credit_id=${credit_ids}[0]
    When The Purchase Info Api Called
    Then The Response Of BNPL With RepaymentOption Xpay Should Contain Account
    And The Gateway Is Disabled

[TC-039] Purchase Info For User Has 4Pay Account Gateway Disable And Channel Is UPG
    Given The User Has 4pay And Credit Accounts
    And The Channel Is Set To UPG
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To Xpay
    And The Amount Is Set To Greater Than Credit Balance
    And Get a Ticket And Initiate Purchase    credit_id=${credit_ids}[0]
    And The Gateway Is Disabled
    When The Purchase Info Api Called
    Then The Response Shouldn't Contain CreditDetails

[TC-040] Purchase Info For User Has Expired 4Pay Account And Channel Is UPG
    Given The User Has 4pay And Credit Accounts
    And The Channel Is Set To UPG
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To Xpay
    And Empty Balance    credit_id=${credit_ids}[0]
    And Expire Account    credit_id=${credit_ids}[0]
    And The Amount Is Set To Equal To Credit Balance
    And Get a Ticket And Initiate Purchase    credit_id=${credit_ids}[0]
    When The Purchase Info Api Called
    Then The Response Shouldn't Contain CreditDetails
    And The Gateway Is Disabled

[TC-041] Purchase Info For User Has Blocked 4Pay Account And Channel Is UPG
    Given The User Has 4pay And Credit Accounts
    And The Channel Is Set To UPG
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To Xpay
    And Block credit account    credit_id=${credit_ids}[0]
    And The Amount Is Set To Equal To Credit Balance
    And Get a Ticket And Initiate Purchase    credit_id=${credit_ids}[0]
    When The Purchase Info Api Called
    Then The Response Should Contain Disabled Account
    And The Gateway Is Disabled

[TC-042] Purchase Info For User With 4Pay Zero Balance And Channel is UPG
    Given The User Has 4pay And Credit Accounts
    And The Channel Is Set To UPG
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To Xpay
    And The Amount Is Set To Greater Than Credit Balance
    And Empty Balance
    And Get a Ticket And Initiate Purchase    credit_id=${credit_ids}[0]
    When The Purchase Info Api Called
    Then The Response For Account With Zero Balance
    And The Gateway Is Disabled

[TC-043] Purchase Info For User With 1Pay Account RepaymentOption Is 1pay And Xpay And Channel Is UPG And Amount Is less Than Credit Balance
    Given The User Has 1pay, 4pay, And Credit Accounts
    And The Channel Is Set To UPG
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And The Amount Is Set To Little Than Credit Balance
    And Get a Ticket And Initiate Purchase    credit_id=${credit_ids}[0]
    when The Purchase Info Api Called
    Then The Response Of BNPL With RepaymentOption 1pay Should Contain Account
    And The Gateway Is Disabled

[TC-044] Purchase Info For User With 1Pay Account RepaymentOption Is Xpay And Channel Is UPG And Amount Is less Than Credit Balance
    Given The User Has 1pay, 4pay, And Credit Accounts
    And The Channel Is Set To UPG
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To Xpay
    And The Amount Is Set To Little Than Credit Balance
    And Get a Ticket And Initiate Purchase    credit_id=${credit_ids}[0]
    When The Purchase Info Api Called
    Then The Response Shouldn't Contain CreditDetails
    And The Gateway Is Disabled

[TC-045] Purchase Info For User 1Pay Account RepaymentOption Is 1pay And Channel Is UPG And Amount Is Greater Than Credit Balance
    Given The User Has 1pay Account
    And The Channel Is Set To UPG
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay
    And The Amount Is Set To Greater Than Credit Balance
    And Get a Ticket And Initiate Purchase    credit_id=${credit_ids}[0]
    When The Purchase Info Api Called
    Then The Response Of BNPL With RepaymentOption 1pay Should Contain Account
    And The Gateway Is Disabled

[TC-046] Purchase Info For User Has 1Pay Account Gateway Disable And Channel Is UPG
    Given The User Has 1pay And 4pay Accounts
    And The Channel Is Set To UPG
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay
    And The Amount Is Set To Greater Than Credit Balance
    And Get a Ticket And Initiate Purchase    credit_id=${credit_ids}[0]
    And The Gateway Is Disabled
    When The Purchase Info Api Called
    Then The Response Shouldn't Contain CreditDetails

[TC-047] Purchase Info For User Has Expired 1Pay Account And Channel Is UPG
    Given The User Has 1pay And 4pay Accounts
    And The Channel Is Set To UPG
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay
    And Empty Balance    credit_id=${credit_ids}[0]
    And Expire Account    credit_id=${credit_ids}[0]
    And The Amount Is Set To Equal To Credit Balance
    And Get a Ticket And Initiate Purchase    credit_id=${credit_ids}[0]
    When The Purchase Info Api Called
    Then The Response Shouldn't Contain CreditDetails
    And The Gateway Is Disabled

[TC-048] Purchase Info For User Has Blocked 1Pay Account And Channel Is UPG
    Given The User Has 1pay And 4pay Accounts
    And The Channel Is Set To UPG
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay
    And Block credit account    credit_id=${credit_ids}[0]
    And The Amount Is Set To Equal To Credit Balance
    And Get a Ticket And Initiate Purchase    credit_id=${credit_ids}[0]
    When The Purchase Info Api Called
    Then The Response Should Contain Disabled Account
    And The Gateway Is Disabled

[TC-049] Purchase Info For User With 1Pay Zero Balance And Channel is UPG
    Given The User Has 1pay And 4pay Accounts
    And The Channel Is Set To UPG
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay
    And The Amount Is Set To Greater Than Credit Balance
    And Empty Balance
    And Get a Ticket And Initiate Purchase    credit_id=${credit_ids}[0]
    When The Purchase Info Api Called
    Then The Response For Account With Zero Balance
    And The Gateway Is Disabled

[TC-050] Purchase Info For User With 1Pay Zero Balance And And Xpay BNPL Account (Zero Credit Balance) And RepaymentOption Is 1pay And Xpay And Channel Is UPG
    Given The User Has 1pay And 4pay Accounts
    And The Channel Is Set To UPG
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And The Amount Is Set To Greater Than Credit Balance
    And Empty Balance    credit_id=${credit_ids}[0]
    And Empty Balance    credit_id=${credit_ids}[1]
    And Get a Ticket And Initiate Purchase    credit_id=${credit_ids}[0]
    When The Purchase Info Api Called
    Then The Response For Account With Zero Balance
    And The Gateway Is Disabled

[TC-051] Purchase Info For User With 4Pay Account RepaymentOption Is 1pay And Xpay And Channel Is Smart Pos And Amount Is less Than Credit Balance
    Given The User Has 1pay, 4pay, And Credit Accounts
    And The Channel Is Set To Smart POS
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And The Amount Is Set To Little Than Credit Balance
    When Get a Ticket And Initiate Purchase    credit_id=${credit_ids}[1]
    Then The Ticket Generation Must Have Failed
    And The Gateway Is Disabled

[TC-052] Purchase Info For User With 4Pay Account RepaymentOption Is 1pay And Channel Is Smart POS And Amount Is less Than Credit Balance
    Given The User Has 1pay, 4pay, And Credit Accounts
    And The Channel Is Set To Smart POS
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay
    And The Amount Is Set To Little Than Credit Balance
    When Get a Ticket And Initiate Purchase    credit_id=${credit_ids}[1]
    Then The Ticket Generation Must Have Failed
    And The Gateway Is Disabled

[TC-053] Purchase Info For User 4Pay Account RepaymentOption Is Xpay And Channel Is Smart POS And Amount Is Greater Than Credit Balance
    Given The User Has 4pay And Credit Accounts
    And The Channel Is Set To Smart POS
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To Xpay
    And The Amount Is Set To Greater Than Credit Balance
    When Get a Ticket And Initiate Purchase    credit_id=${credit_ids}[0]
    Then The Ticket Generation Must Have Failed
    And The Gateway Is Disabled

[TC-054] Purchase Info For User Has 4Pay Account Gateway Disable And Channel Is Smart POS
    Given The User Has 4pay And Credit Accounts
    And The Channel Is Set To Smart POS
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To Xpay
    And The Amount Is Set To Greater Than Credit Balance
    When Get a Ticket And Initiate Purchase    credit_id=${credit_ids}[0]
    And The Gateway Is Disabled
    Then The Ticket Generation Must Have Failed

[TC-055] Purchase Info For User Has Expired 4Pay Account And Channel Is Smart POS
    Given The User Has 4pay And Credit Accounts
    And The Channel Is Set To Smart POS
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To Xpay
    And Empty Balance    credit_id=${credit_ids}[0]
    And Expire Account    credit_id=${credit_ids}[0]
    And The Amount Is Set To Equal To Credit Balance
    When Get a Ticket And Initiate Purchase    credit_id=${credit_ids}[0]
    Then The Ticket Generation Must Have Failed
    And The Gateway Is Disabled

[TC-056] Purchase Info For User Has Blocked 4Pay Account And Channel Is Smart POS
    Given The User Has 4pay And Credit Accounts
    And The Channel Is Set To Smart POS
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To Xpay
    And The Amount Is Set To Equal To Credit Balance
    When Get a Ticket And Initiate Purchase    credit_id=${credit_ids}[0]
    And Block credit account    credit_id=${credit_ids}[0]
    Then The Ticket Generation Must Have Failed
    And The Gateway Is Disabled

[TC-057] Purchase Info For User With 4Pay Zero Balance And Channel is Smart POS
    Given The User Has 4pay And Credit Accounts
    And The Channel Is Set To Smart POS
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To Xpay
    And The Amount Is Set To Greater Than Credit Balance
    And Empty Balance
    When Get a Ticket And Initiate Purchase    credit_id=${credit_ids}[0]
    Then The Ticket Generation Must Have Failed
    And The Gateway Is Disabled

[TC-058] Purchase Info For User With 1Pay Account RepaymentOption Is 1pay And Xpay And Channel Is Smart POS And Amount Is less Than Credit Balance
    Given The User Has 1pay, 4pay, And Credit Accounts
    And The Channel Is Set To Smart POS
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And The Amount Is Set To Little Than Credit Balance
    When Get a Ticket And Initiate Purchase    credit_id=${credit_ids}[0]
    Then The Ticket Generation Must Have Failed
    And The Gateway Is Disabled

[TC-059] Purchase Info For User With 1Pay Account RepaymentOption Is Xpay And Channel Is Smart POS And Amount Is less Than Credit Balance
    Given The User Has 1pay, 4pay, And Credit Accounts
    And The Channel Is Set To Smart POS
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To Xpay
    And The Amount Is Set To Little Than Credit Balance
    When Get a Ticket And Initiate Purchase    credit_id=${credit_ids}[0]
    Then The Ticket Generation Must Have Failed
    And The Gateway Is Disabled

[TC-060] Purchase Info For User 1Pay Account RepaymentOption Is 1pay And Channel Is Smart POS And Amount Is Greater Than Credit Balance
    Given The User Has 1pay Account
    And The Channel Is Set To Smart POS
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay
    And The Amount Is Set To Greater Than Credit Balance
    When Get a Ticket And Initiate Purchase    credit_id=${credit_ids}[0]
    Then The Ticket Generation Must Have Failed
    And The Gateway Is Disabled

[TC-061] Purchase Info For User Has 1Pay Account Gateway Disable And Channel Is Smart POS
    Given The User Has 1pay And 4pay Accounts
    And The Channel Is Set To Smart POS
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay
    And The Amount Is Set To Greater Than Credit Balance
    When Get a Ticket And Initiate Purchase    credit_id=${credit_ids}[0]
    And The Gateway Is Disabled
    Then The Ticket Generation Must Have Failed

[TC-062] Purchase Info For User Has Expired 1Pay Account And Channel Is Smart POS
    Given The User Has 1pay And 4pay Accounts
    And The Channel Is Set To Smart POS
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay
    And Empty Balance    credit_id=${credit_ids}[0]
    And Expire Account    credit_id=${credit_ids}[0]
    And The Amount Is Set To Equal To Credit Balance
    When Get a Ticket And Initiate Purchase    credit_id=${credit_ids}[0]
    Then The Ticket Generation Must Have Failed
    And The Gateway Is Disabled

[TC-063] Purchase Info For User Has Blocked 1Pay Account And Channel Is Smart POS
    Given The User Has 1pay And 4pay Accounts
    And The Channel Is Set To Smart POS
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay
    And Block credit account    credit_id=${credit_ids}[0]
    And The Amount Is Set To Equal To Credit Balance
    When Get a Ticket And Initiate Purchase    credit_id=${credit_ids}[0]
    Then The Ticket Generation Must Have Failed
    And The Gateway Is Disabled

[TC-064] Purchase Info For User With 1Pay Zero Balance And Channel is Smart POS
    Given The User Has 1pay And 4pay Accounts
    And The Channel Is Set To Smart POS
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay
    And The Amount Is Set To Greater Than Credit Balance
    And Empty Balance
    When Get a Ticket And Initiate Purchase    credit_id=${credit_ids}[0]
    Then The Ticket Generation Must Have Failed
    And The Gateway Is Disabled

[TC-065] Purchase Info For User With 4Pay Account RepaymentOption Is 1pay And Xpay And Channel Is QR And Amount Is less Than Credit Balance
    Given The User Has 1pay, 4pay, And Credit Accounts
    And The Channel Is Set To QR
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And The Amount Is Set To Little Than Credit Balance
    And Get a Ticket And Initiate Purchase    credit_id=${credit_ids}[1]
    when The Purchase Info Api Called
    Then The Response Of BNPL With RepaymentOption Xpay Should Contain Account
    And The Gateway Is Disabled

[TC-066] Purchase Info For User With 4Pay Account RepaymentOption Is 1pay And Channel Is QR And Amount Is less Than Credit Balance
    Given The User Has 1pay, 4pay, And Credit Accounts
    And The Channel Is Set To QR
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay
    And The Amount Is Set To Little Than Credit Balance
    And Get a Ticket And Initiate Purchase    credit_id=${credit_ids}[1]
    When The Purchase Info Api Called
    Then The Response Shouldn't Contain CreditDetails
    And The Gateway Is Disabled

[TC-067] Purchase Info For User 4Pay Account RepaymentOption Is Xpay And Channel Is QR And Amount Is Greater Than Credit Balance
    Given The User Has 4pay And Credit Accounts
    And The Channel Is Set To QR
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To Xpay
    And The Amount Is Set To Greater Than Credit Balance
    And Get a Ticket And Initiate Purchase    credit_id=${credit_ids}[0]
    When The Purchase Info Api Called
    Then The Response Of BNPL With RepaymentOption Xpay Should Contain Account
    And The Gateway Is Disabled

[TC-068] Purchase Info For User Has 4Pay Account Gateway Disable And Channel Is QR
    Given The User Has 4pay And Credit Accounts
    And The Channel Is Set To QR
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To Xpay
    And The Amount Is Set To Greater Than Credit Balance
    And Get a Ticket And Initiate Purchase    credit_id=${credit_ids}[0]
    And The Gateway Is Disabled
    When The Purchase Info Api Called
    Then The Response Shouldn't Contain CreditDetails

[TC-069] Purchase Info For User Has Expired 4Pay Account And Channel Is QR
    Given The User Has 4pay And Credit Accounts
    And The Channel Is Set To QR
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To Xpay
    And Empty Balance    credit_id=${credit_ids}[0]
    And Expire Account    credit_id=${credit_ids}[0]
    And The Amount Is Set To Equal To Credit Balance
    And Get a Ticket And Initiate Purchase    credit_id=${credit_ids}[0]
    When The Purchase Info Api Called
    Then The Response Shouldn't Contain CreditDetails
    And The Gateway Is Disabled

[TC-070] Purchase Info For User Has Blocked 4Pay Account And Channel Is QR
    Given The User Has 4pay And Credit Accounts
    And The Channel Is Set To QR
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To Xpay
    And Block credit account    credit_id=${credit_ids}[0]
    And The Amount Is Set To Equal To Credit Balance
    And Get a Ticket And Initiate Purchase    credit_id=${credit_ids}[0]
    When The Purchase Info Api Called
    Then The Response Should Contain Disabled Account
    And The Gateway Is Disabled

[TC-071] Purchase Info For User With 4Pay Zero Balance And Channel is QR
    Given The User Has 4pay And Credit Accounts
    And The Channel Is Set To QR
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To Xpay
    And The Amount Is Set To Greater Than Credit Balance
    And Empty Balance
    And Get a Ticket And Initiate Purchase    credit_id=${credit_ids}[0]
    When The Purchase Info Api Called
    Then The Response For Account With Zero Balance
    And The Gateway Is Disabled

[TC-072] Purchase Info For User With 1Pay Account RepaymentOption Is 1pay And Xpay And Channel Is QR And Amount Is less Than Credit Balance
    Given The User Has 1pay, 4pay, And Credit Accounts
    And The Channel Is Set To QR
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And The Amount Is Set To Little Than Credit Balance
    And Get a Ticket And Initiate Purchase    credit_id=${credit_ids}[0]
    when The Purchase Info Api Called
    Then The Response Of BNPL With RepaymentOption 1pay Should Contain Account
    And The Gateway Is Disabled

[TC-073] Purchase Info For User With 1Pay Account RepaymentOption Is Xpay And Channel Is QR And Amount Is less Than Credit Balance
    Given The User Has 1pay, 4pay, And Credit Accounts
    And The Channel Is Set To QR
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To Xpay
    And The Amount Is Set To Little Than Credit Balance
    And Get a Ticket And Initiate Purchase    credit_id=${credit_ids}[0]
    When The Purchase Info Api Called
    Then The Response Shouldn't Contain CreditDetails
    And The Gateway Is Disabled

[TC-074] Purchase Info For User 1Pay Account RepaymentOption Is 1pay And Channel Is QR And Amount Is Greater Than Credit Balance
    Given The User Has 1pay Account
    And The Channel Is Set To QR
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay
    And The Amount Is Set To Greater Than Credit Balance
    And Get a Ticket And Initiate Purchase    credit_id=${credit_ids}[0]
    When The Purchase Info Api Called
    Then The Response Of BNPL With RepaymentOption 1pay Should Contain Account
    And The Gateway Is Disabled

[TC-075] Purchase Info For User Has 1Pay Account Gateway Disable And Channel Is QR
    Given The User Has 1pay And 4pay Accounts
    And The Channel Is Set To QR
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay
    And The Amount Is Set To Greater Than Credit Balance
    And Get a Ticket And Initiate Purchase    credit_id=${credit_ids}[0]
    And The Gateway Is Disabled
    When The Purchase Info Api Called
    Then The Response Shouldn't Contain CreditDetails

[TC-076] Purchase Info For User Has Expired 1Pay Account And Channel Is QR
    Given The User Has 1pay And 4pay Accounts
    And The Channel Is Set To QR
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay
    And Empty Balance    credit_id=${credit_ids}[0]
    And Expire Account    credit_id=${credit_ids}[0]
    And The Amount Is Set To Equal To Credit Balance
    And Get a Ticket And Initiate Purchase    credit_id=${credit_ids}[0]
    When The Purchase Info Api Called
    Then The Response Shouldn't Contain CreditDetails
    And The Gateway Is Disabled

[TC-077] Purchase Info For User Has Blocked 1Pay Account And Channel Is QR
    Given The User Has 1pay And 4pay Accounts
    And The Channel Is Set To QR
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay
    And The Amount Is Set To Equal To Credit Balance
    And Get a Ticket And Initiate Purchase    credit_id=${credit_ids}[0]
    And Block credit account    credit_id=${credit_ids}[0]
    When The Purchase Info Api Called
    Then The Response Should Contain Disabled Account
    And The Gateway Is Disabled

[TC-078] Purchase Info For User With 1Pay Zero Balance And Channel is QR
    Given The User Has 1pay And 4pay Accounts
    And The Channel Is Set To QR
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay
    And The Amount Is Set To Greater Than Credit Balance
    And Empty Balance
    And Get a Ticket And Initiate Purchase    credit_id=${credit_ids}[0]
    When The Purchase Info Api Called
    Then The Response For Account With Zero Balance
    And The Gateway Is Disabled

[TC-079] Purchase Info For User With 4Pay Account RepaymentOption Is 1pay And Xpay And Channel Is Linux POS And Amount Is less Than Credit Balance
    Given The User Has 1pay, 4pay, And Credit Accounts
    And The Channel Is Set To Linux POS
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And The Amount Is Set To Little Than Credit Balance
    When Get a Ticket And Initiate Purchase    credit_id=${credit_ids}[1]
    Then The Ticket Generation Must Have Failed
    And The Gateway Is Disabled

[TC-080] Purchase Info For User With 4Pay Account RepaymentOption Is 1pay And Channel Is Linux POS And Amount Is less Than Credit Balance
    Given The User Has 1pay, 4pay, And Credit Accounts
    And The Channel Is Set To Linux POS
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay
    And The Amount Is Set To Little Than Credit Balance
    When Get a Ticket And Initiate Purchase    credit_id=${credit_ids}[1]
    Then The Ticket Generation Must Have Failed
    And The Gateway Is Disabled

[TC-081] Purchase Info For User 4Pay Account RepaymentOption Is Xpay And Channel Is Linux POS And Amount Is Greater Than Credit Balance
    Given The User Has 4pay And Credit Accounts
    And The Channel Is Set To Linux POS
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To Xpay
    And The Amount Is Set To Greater Than Credit Balance
    When Get a Ticket And Initiate Purchase    credit_id=${credit_ids}[0]
    Then The Ticket Generation Must Have Failed
    And The Gateway Is Disabled

[TC-082] Purchase Info For User Has 4Pay Account Gateway Disable And Channel Is Linux POS
    Given The User Has 4pay And Credit Accounts
    And The Channel Is Set To Linux POS
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To Xpay
    And The Amount Is Set To Greater Than Credit Balance
    When Get a Ticket And Initiate Purchase    credit_id=${credit_ids}[0]
    And The Gateway Is Disabled
    Then The Ticket Generation Must Have Failed

[TC-083] Purchase Info For User Has Expired 4Pay Account And Channel Is Linux POS
    Given The User Has 4pay And Credit Accounts
    And The Channel Is Set To Linux POS
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To Xpay
    And Empty Balance    credit_id=${credit_ids}[0]
    And Expire Account    credit_id=${credit_ids}[0]
    And The Amount Is Set To Equal To Credit Balance
    When Get a Ticket And Initiate Purchase    credit_id=${credit_ids}[0]
    Then The Ticket Generation Must Have Failed
    And The Gateway Is Disabled

[TC-084] Purchase Info For User Has Blocked 4Pay Account And Channel Is Linux POS
    Given The User Has 4pay And Credit Accounts
    And The Channel Is Set To Linux POS
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To Xpay
    And Block credit account    credit_id=${credit_ids}[0]
    And The Amount Is Set To Equal To Credit Balance
    When Get a Ticket And Initiate Purchase    credit_id=${credit_ids}[0]
    Then The Ticket Generation Must Have Failed
    And The Gateway Is Disabled

[TC-085] Purchase Info For User With 4Pay Zero Balance And Channel is Linux POS
    Given The User Has 4pay And Credit Accounts
    And The Channel Is Set To Linux POS
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To Xpay
    And The Amount Is Set To Greater Than Credit Balance
    And Empty Balance
    When Get a Ticket And Initiate Purchase    credit_id=${credit_ids}[0]
    Then The Ticket Generation Must Have Failed
    And The Gateway Is Disabled

[TC-086] Purchase Info For User With 1Pay Account RepaymentOption Is 1pay And Xpay And Channel Is Linux POS And Amount Is less Than Credit Balance
    Given The User Has 1pay, 4pay, And Credit Accounts
    And The Channel Is Set To Linux POS
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And The Amount Is Set To Little Than Credit Balance
    When Get a Ticket And Initiate Purchase    credit_id=${credit_ids}[0]
    Then The Ticket Generation Must Have Failed
    And The Gateway Is Disabled

[TC-087] Purchase Info For User With 1Pay Account RepaymentOption Is Xpay And Channel Is Linux POS And Amount Is less Than Credit Balance
    Given The User Has 1pay, 4pay, And Credit Accounts
    And The Channel Is Set To Linux POS
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To Xpay
    And The Amount Is Set To Little Than Credit Balance
    When Get a Ticket And Initiate Purchase    credit_id=${credit_ids}[0]
    Then The Ticket Generation Must Have Failed
    And The Gateway Is Disabled

[TC-088] Purchase Info For User 1Pay Account RepaymentOption Is 1pay And Channel Is Linux POS And Amount Is Greater Than Credit Balance
    Given The User Has 1pay Account
    And The Channel Is Set To Linux POS
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay
    And The Amount Is Set To Greater Than Credit Balance
    When Get a Ticket And Initiate Purchase    credit_id=${credit_ids}[0]
    Then The Ticket Generation Must Have Failed
    And The Gateway Is Disabled

[TC-089] Purchase Info For User Has 1Pay Account Gateway Disable And Channel Is Linux POS
    Given The User Has 1pay And 4pay Accounts
    And The Channel Is Set To Linux POS
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay
    And The Amount Is Set To Greater Than Credit Balance
    When Get a Ticket And Initiate Purchase    credit_id=${credit_ids}[0]
    And The Gateway Is Disabled
    Then The Ticket Generation Must Have Failed

[TC-090] Purchase Info For User Has Expired 1Pay Account And Channel Is Linux POS
    Given The User Has 1pay And 4pay Accounts
    And The Channel Is Set To Linux POS
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay
    And Empty Balance    credit_id=${credit_ids}[0]
    And Expire Account    credit_id=${credit_ids}[0]
    And The Amount Is Set To Equal To Credit Balance
    When Get a Ticket And Initiate Purchase    credit_id=${credit_ids}[0]
    Then The Ticket Generation Must Have Failed
    And The Gateway Is Disabled

[TC-091] Purchase Info For User Has Blocked 1Pay Account And Channel Is Linux POS
    Given The User Has 1pay And 4pay Accounts
    And The Channel Is Set To Linux POS
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay
    And Block credit account    credit_id=${credit_ids}[0]
    And The Amount Is Set To Equal To Credit Balance
    When Get a Ticket And Initiate Purchase    credit_id=${credit_ids}[0]
    Then The Ticket Generation Must Have Failed
    And The Gateway Is Disabled

[TC-092] Purchase Info For User With 1Pay Zero Balance And Channel is Linux POS
    Given The User Has 1pay And 4pay Accounts
    And The Channel Is Set To Linux POS
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay
    And The Amount Is Set To Greater Than Credit Balance
    And Empty Balance    credit_id=${credit_ids}[0]
    When Get a Ticket And Initiate Purchase    credit_id=${credit_ids}[0]
    Then The Ticket Generation Must Have Failed
    And The Gateway Is Disabled

[TC-093] Purchase Info For User Installment Sale Account RepaymentOption Is 1pay And Channel Is UPG And Amount Is Equal To Credit Balance
    Given The User Has Installment Sale Account
    And The Channel Is Set To UPG
    And The Ticket Type Is Set To Installment Sale
    And The Payment Gateway Is Set To ISPG
    And The Gateway RepaymentOption Is Set To 1pay
    And The Amount Is Set To Equal To Credit Balance
    And Get a Ticket And Initiate Purchase
    when The Purchase Info Api Called
    Then The Response Shouldn't Contain CreditDetails
    And The Gateway Is Disabled

[TC-094] Purchase Info For User With Installment Sale Account RepaymentOption Is Xpay And Channel Is UPG And Amount Equal To Credit Balance
    Given The User Has Installment Sale Account
    And The Channel Is Set To UPG
    And The Ticket Type Is Set To Installment Sale
    And The Payment Gateway Is Set To ISPG
    And The Gateway RepaymentOption Is Set To Xpay
    And The Amount Is Set To Equal To Credit Balance
    And Get a Ticket And Initiate Purchase
    when The Purchase Info Api Called
    Then The Response Should Contain CreditInfo
    And The Gateway Is Disabled

[TC-095] Purchase Info For User Installment Sale Account RepaymentOption Is Xpay And Channel Is UPG And Amount Is Greater Than Credit Balance
    Given The User Has Installment Sale Account
    And The Channel Is Set To UPG
    And The Ticket Type Is Set To Installment Sale
    And The Payment Gateway Is Set To ISPG
    And The Gateway RepaymentOption Is Set To Xpay
    And The Amount Is Set To Greater Than Credit Balance
    And Get a Ticket And Initiate Purchase    credit_id=${credit_ids}[0]
    When The Purchase Info Api Called
    Then The Response Should Contain CreditInfo
    And The Gateway Is Disabled

[TC-096] Purchase Info For User Has Installment Sale Account Gateway Disable And Channel Is UPG
    Given The User Has Installment Sale Account
    And The Channel Is Set To UPG
    And The Ticket Type Is Set To Installment Sale
    And The Payment Gateway Is Set To ISPG
    And The Gateway RepaymentOption Is Set To Xpay
    And The Amount Is Set To Greater Than Credit Balance
    And Get a Ticket And Initiate Purchase    credit_id=${credit_ids}[0]
    And The Gateway Is Disabled
    When The Purchase Info Api Called
    Then The Response Shouldn't Contain CreditDetails

[TC-097] Purchase Info For User Has Expired Installment Sale Account And Channel Is UPG
    Given The User Has Installment Sale Account
    And The Channel Is Set To UPG
    And The Ticket Type Is Set To Installment Sale
    And The Payment Gateway Is Set To ISPG
    And The Gateway RepaymentOption Is Set To Xpay
    And Empty Balance    credit_id=${credit_ids}[0]
    And Expire Account    credit_id=${credit_ids}[0]
    And The Amount Is Set To Equal To Credit Balance
    And Get a Ticket And Initiate Purchase    credit_id=${credit_ids}[0]
    When The Purchase Info Api Called
    Then The Response Shouldn't Contain CreditDetails
    And The Gateway Is Disabled

[TC-098] Purchase Info For User Has Blocked Installment Sale Account And Channel Is UPG
    Given The User Has Installment Sale Account
    And The Channel Is Set To UPG
    And The Ticket Type Is Set To Installment Sale
    And The Payment Gateway Is Set To ISPG
    And The Gateway RepaymentOption Is Set To Xpay
    And Block credit account    credit_id=${credit_ids}[0]
    And The Amount Is Set To Equal To Credit Balance
    And Get a Ticket And Initiate Purchase    credit_id=${credit_ids}[0]
    When The Purchase Info Api Called
    Then The Response Should Contain Disabled Account
    And The Gateway Is Disabled

[TC-099] Purchase Info For User With Installment Sale Zero Balance And Channel is UPG
    Given The User Has Installment Sale Account
    And The Channel Is Set To UPG
    And The Ticket Type Is Set To Installment Sale
    And The Payment Gateway Is Set To ISPG
    And The Gateway RepaymentOption Is Set To Xpay
    And The Amount Is Set To Greater Than Credit Balance
    And Empty Balance    credit_id=${credit_ids}[0]
    And Get a Ticket And Initiate Purchase    credit_id=${credit_ids}[0]
    When The Purchase Info Api Called
    Then The Response For Account With Zero Balance
    And The Gateway Is Disabled

[TC-100] Purchase Info Pay With 1pay BNPL
    [Tags]    ui    robot:exclude
    Given The User Has 1pay And 4pay Accounts
    And The Channel Is Set To UPG
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And The Amount Is Set To Equal To Credit Balance
    And Get a Ticket And Initiate Purchase
    When Pay With Platform BNPL    type=1pay
    And The Gateway Is Disabled
