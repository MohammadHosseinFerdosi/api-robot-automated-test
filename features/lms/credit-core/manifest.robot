*** Settings ***
Resource            steps/LMS/credit-core/manifest-step.resource

Test Setup          Initialize Merchant
Test Teardown       Reproduce Amount


*** Test Cases ***
#############    BNPL    #############

#############    👇 happy path RepaymentOption Is 1pay And Xpay and Channel is UPG    #############
[TC-001] Manifest Response For User With 1pay BNPL Account RepaymentOption Is 1pay And Xpay And Channel Is UPG And Amount Is Equal To Credit Balance
    Given The User Has 1pay Account
    And The Channel Is Set To UPG
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And The Amount Is Set To Equal To Credit Balance
    When The Manifest API Is Called
    Then The Response Should Contain 1pay BNPL Account And State Is Active
    And The Gateway Is Disabled

[TC-002] Manifest Response For User With Xpay BNPL Account RepaymentOption Is 1pay And Xpay And Channel Is UPG And Amount Is Equal To Credit Balance
    Given The User Has 4pay Account
    And The Channel Is Set To UPG
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And The Amount Is Set To Equal To Credit Balance
    When The Manifest API Is Called
    Then The Response Should Contain Xpay BNPL Account And State Is Active
    And The Gateway Is Disabled

[TC-003] Manifest Response For User With 1pay And Xpay BNPL Account And RepaymentOption Is 1pay And Xpay And Channel Is UPG And Amount Is Equal To Credit Balance
    Given The User Has 1pay And 4pay Accounts
    And The Channel Is Set To UPG
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And The Amount Is Set To Equal To Credit Balance
    When The Manifest API Is Called
    Then The Response Should Contain 1pay BNPL And Xpay BNPL Account And State Is Active
    And The Gateway Is Disabled

[TC-004] Manifest Response For User With 1pay BNPL Account RepaymentOption Is 1pay And Xpay And Channel Is UPG And Amount Is Little Than Credit Balance
    Given The User Has 1pay Account
    And The Channel Is Set To UPG
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And The Amount Is Set To Little Than Credit Balance
    When The Manifest API Is Called
    Then The Response Should Contain 1pay BNPL Account And State Is Active
    And The Gateway Is Disabled

[TC-005] Manifest Response For User With Xpay BNPL Account RepaymentOption Is 1pay And Xpay And Channel Is UPG And Amount Is Little Than Credit Balance
    Given The User Has 4pay Account
    And The Channel Is Set To UPG
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And The Amount Is Set To Little Than Credit Balance
    When The Manifest API Is Called
    Then The Response Should Contain Xpay BNPL Account And State Is Active
    And The Gateway Is Disabled

[TC-006] Manifest Response For User With 1pay And Xpay BNPL Account And RepaymentOption Is 1pay And Xpay And Channel Is UPG And Amount Is Little Than Credit Balance
    Given The User Has 1pay And 4pay Accounts
    And The Channel Is Set To UPG
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And The Amount Is Set To Little Than Credit Balance
    When The Manifest API Is Called
    Then The Response Should Contain 1pay BNPL And Xpay BNPL Account And State Is Active
    And The Gateway Is Disabled

[TC-007] Manifest Response For User With 1pay BNPL Account RepaymentOption Is 1pay And Xpay And Channel Is UPG And Amount Is Greater Than Credit Balance
    Given The User Has 1pay Account
    And The Channel Is Set To UPG
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And The Amount Is Set To Greater Than Credit Balance
    When The Manifest API Is Called
    Then The Response Should Contain 1pay BNPL Account And State Is Active
    And The Gateway Is Disabled

[TC-008] Manifest Response For User With Xpay BNPL Account RepaymentOption Is 1pay And Xpay And Channel Is UPG And Amount Is Greater Than Credit Balance
    Given The User Has 4pay Account
    And The Channel Is Set To UPG
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And The Amount Is Set To Greater Than Credit Balance
    When The Manifest API Is Called
    Then The Response Should Contain Xpay BNPL Account And State Is Active
    And The Gateway Is Disabled

[TC-009] Manifest Response For User With 1pay And Xpay BNPL Account And RepaymentOption Is 1pay And Xpay And Channel Is UPG And Amount Is Greater Than Credit Balance
    Given The User Has 1pay And 4pay Accounts
    And The Channel Is Set To UPG
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And The Amount Is Set To Greater Than Credit Balance
    When The Manifest API Is Called
    Then The Response Should Contain 1pay BNPL And Xpay BNPL Account And State Is Active
    And The Gateway Is Disabled

#############    👆 happy path RepaymentOption Is 1pay And Xpay and Channel is UPG    #############

#############    👇 Zero Credit Balance and RepaymentOption Is 1pay And Xpay and Channel is UPG    #############

[TC-010] Manifest Response For User With 1pay BNPL Account (Zero Credit Balance) And RepaymentOption Is 1pay And Xpay And Channel Is UPG
    Given The User Has 1pay Account
    And The Channel Is Set To UPG
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And The Amount Is Set To Greater Than Credit Balance
    And Empty Balance
    When The Manifest API Is Called
    Then The Response Should Contain 1pay BNPL Account (Zero Credit Balance) And State Is Active
    And The Gateway Is Disabled

[TC-011] Manifest Response For User With Xpay BNPL Account (Zero Credit Balance) And RepaymentOption Is 1pay And Xpay And Channel Is UPG
    Given The User Has 4pay Account
    And The Channel Is Set To UPG
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And The Amount Is Set To Greater Than Credit Balance
    And Empty Balance
    When The Manifest API Is Called
    Then The Response Should Contain Xpay BNPL Account (Zero Credit Balance) And State Is Active
    And The Gateway Is Disabled

[TC-012] Manifest Response For User With 1pay BNPL Account And Xpay BNPL Account (Zero Credit Balance) And RepaymentOption Is 1pay And Xpay And Channel Is UPG
    Given The User Has 1pay And 4pay Accounts
    And The Channel Is Set To UPG
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And The Amount Is Set To Greater Than Credit Balance
    And Empty Balance    credit_id=${credit_ids}[1]
    When The Manifest API Is Called
    Then The Response Should Contain 1pay BNPL And Xpay (Zero Credit Balance) BNPL Account And State Is Active
    And The Gateway Is Disabled

[TC-013] Manifest Response For User With 1pay BNPL Account (Zero Credit Balance) And Xpay BNPL Account And RepaymentOption Is 1pay And Xpay And Channel Is UPG
    Given The User Has 1pay And 4pay Accounts
    And The Channel Is Set To UPG
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And The Amount Is Set To Greater Than Credit Balance
    And Empty Balance    credit_id=${credit_ids}[0]
    When The Manifest API Is Called
    Then The Response Should Contain 1pay BNPL (Zero Credit Balance) And Xpay BNPL Account And State Is Active
    And The Gateway Is Disabled

[TC-014] Manifest Response For User With 1pay BNPL Account (Zero Credit Balance) And Xpay BNPL Account (Zero Credit Balance) And RepaymentOption Is 1pay And Xpay And Channel Is UPG
    Given The User Has 1pay And 4pay Accounts
    And The Channel Is Set To UPG
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And The Amount Is Set To Greater Than Credit Balance
    And Empty Balance    credit_id=${credit_ids}[0]
    And Empty Balance    credit_id=${credit_ids}[1]
    When The Manifest API Is Called
    Then The Response Should Contain 1pay BNPL (Zero Credit Balance) And Xpay BNPL (Zero Credit Balance) Account And State Is Active
    And The Gateway Is Disabled

#############    👆 Zero Credit Balance and RepaymentOption Is 1pay And Xpay and Channel is UPG    #############

#############    👇 Expired and RepaymentOption Is 1pay And Xpay and Channel is UPG    #############

[TC-015] Manifest Response For User With 1pay BNPL Account (Expired) And RepaymentOption Is 1pay And Xpay And Channel Is UPG
    Given The User Has 1pay Account
    And The Channel Is Set To UPG
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And The Amount Is Set To Greater Than Credit Balance
    And Empty Balance
    And Expire Account    credit_id=${credit_ids}[0]
    When The Manifest API Is Called
    Then The Response Should Contain 1pay BNPL Account And State Is Inactive
    And The Gateway Is Disabled

[TC-016] Manifest Response For User With Xpay BNPL Account (Expired) And RepaymentOption Is 1pay And Xpay And Channel Is UPG
    Given The User Has 4pay Account
    And The Channel Is Set To UPG
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And The Amount Is Set To Greater Than Credit Balance
    And Empty Balance
    And Expire Account    credit_id=${credit_ids}[0]
    When The Manifest API Is Called
    Then The Response Should Contain Xpay BNPL Account And State Is Inactive
    And The Gateway Is Disabled

[TC-017] Manifest Response For User With 1pay BNPL Account And Xpay BNPL Account (Expired) And RepaymentOption Is 1pay And Xpay And Channel Is UPG
    Given The User Has 1pay And 4pay Accounts
    And The Channel Is Set To UPG
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And The Amount Is Set To Greater Than Credit Balance
    And Empty Balance    credit_id=${credit_ids}[1]
    And Expire Account    credit_id=${credit_ids}[1]
    When The Manifest API Is Called
    Then The Response Should Contain 1pay BNPL State Is Active And Xpay BNPL Account State Is Inactive
    And The Gateway Is Disabled

[TC-018] Manifest Response For User With 1pay BNPL Account (Expired) And Xpay BNPL Account And RepaymentOption Is 1pay And Xpay And Channel Is UPG
    Given The User Has 1pay And 4pay Accounts
    And The Channel Is Set To UPG
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And The Amount Is Set To Greater Than Credit Balance
    And Empty Balance    credit_id=${credit_ids}[0]
    And Expire Account    credit_id=${credit_ids}[0]
    When The Manifest API Is Called
    Then The Response Should Contain 1pay BNPL State Is Inactive And Xpay BNPL Account State Is Active
    And The Gateway Is Disabled

[TC-019] Manifest Response For User With 1pay BNPL Account (Expired) And Xpay BNPL Account (Expired) And RepaymentOption Is 1pay And Xpay And Channel Is UPG
    Given The User Has 1pay And 4pay Accounts
    And The Channel Is Set To UPG
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And The Amount Is Set To Greater Than Credit Balance
    And Empty Balance    credit_id=${credit_ids}[0]
    And Empty Balance    credit_id=${credit_ids}[1]
    And Expire Account    credit_id=${credit_ids}[0]
    And Expire Account    credit_id=${credit_ids}[1]
    When The Manifest API Is Called
    Then The Response Should Contain 1pay BNPL And Xpay BNPL Account And State Is Inactive
    And The Gateway Is Disabled

#############    👆 Expired and RepaymentOption Is 1pay And Xpay and Channel is UPG    #############

#############    👇 Blocked and RepaymentOption Is 1pay And Xpay and Channel is UPG    #############

[TC-020] Manifest Response For User With Blocked 1pay BNPL Account And RepaymentOption Is 1pay And Xpay And Channel Is UPG
    Given The User Has 1pay Account
    And The Channel Is Set To UPG
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And The Amount Is Set To Greater Than Credit Balance
    And Block credit account
    When The Manifest API Is Called
    Then The Response Should Contain 1pay BNPL Account And State Is Inactive
    And The Gateway Is Disabled

[TC-021] Manifest Response For User With Blocked Xpay BNPL Account And RepaymentOption Is 1pay And Xpay And Channel Is UPG
    Given The User Has 4pay Account
    And The Channel Is Set To UPG
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And The Amount Is Set To Greater Than Credit Balance
    And Block credit account
    When The Manifest API Is Called
    Then The Response Should Contain Xpay BNPL Account And State Is Inactive
    And The Gateway Is Disabled

[TC-022] Manifest Response For User With 1pay BNPL Account And Blocked Xpay BNPL Account And RepaymentOption Is 1pay And Xpay And Channel Is UPG
    Given The User Has 1pay And 4pay Accounts
    And The Channel Is Set To UPG
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And The Amount Is Set To Greater Than Credit Balance
    And Block credit account    credit_id=${credit_ids}[1]
    When The Manifest API Is Called
    Then The Response Should Contain 1pay BNPL State Is Active And Xpay BNPL Account State Is Inactive
    And The Gateway Is Disabled

[TC-023] Manifest Response For User With Blocked 1pay BNPL Account And Xpay BNPL Account And RepaymentOption Is 1pay And Xpay And Channel Is UPG
    Given The User Has 1pay And 4pay Accounts
    And The Channel Is Set To UPG
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And The Amount Is Set To Greater Than Credit Balance
    And Block credit account    credit_id=${credit_ids}[0]
    When The Manifest API Is Called
    Then The Response Should Contain 1pay BNPL State Is Inactive And Xpay BNPL Account State Is Active
    And The Gateway Is Disabled

[TC-024] Manifest Response For User With Blocked 1pay BNPL Account And Blocked Xpay BNPL Account And RepaymentOption Is 1pay And Xpay And Channel Is UPG
    Given The User Has 1pay And 4pay Accounts
    And The Channel Is Set To UPG
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And The Amount Is Set To Greater Than Credit Balance
    And Block credit account    credit_id=${credit_ids}[0]
    And Block credit account    credit_id=${credit_ids}[1]
    When The Manifest API Is Called
    Then The Response Should Contain 1pay BNPL And Xpay BNPL Account And State Is Inactive
    And The Gateway Is Disabled

#############    👆 Blocked and RepaymentOption Is 1pay And Xpay and Channel is UPG    #############

[TC-025] Manifest Response For User With Blocked 1pay BNPL Account And Expired Xpay BNPL Account And RepaymentOption Is 1pay And Xpay And Channel Is UPG
    Given The User Has 1pay And 4pay Accounts
    And The Channel Is Set To UPG
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And The Amount Is Set To Greater Than Credit Balance
    And Empty Balance    credit_id=${credit_ids}[1]
    And Expire Account    credit_id=${credit_ids}[1]
    And Block credit account    credit_id=${credit_ids}[0]
    When The Manifest API Is Called
    Then The Response Should Contain 1pay BNPL And Xpay BNPL Account And State Is Inactive
    And The Gateway Is Disabled

[TC-026] Manifest Response When Gateway Is Disabled And The Payment Gateway Is Set To BPG And Channel Is UPG
    Given The User Has 1pay Account
    And The Channel Is Set To UPG
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway Is Disabled
    And The Amount Is Set To Little Than Credit Balance
    When The Manifest API Is Called
    Then The Response Should Contain No Credit Account And State Is Disable For Payment Gateway BPG

#############    👇 happy path RepaymentOption Is 1pay And Xpay and Channel is QR    #############

[TC-027] Manifest Response For User With 1pay BNPL Account RepaymentOption Is 1pay And Xpay And Channel Is QR And Amount Is Equal To Credit Balance
    Given The User Has 1pay Account
    And The Channel Is Set To QR
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And The Amount Is Set To Equal To Credit Balance
    When The Manifest API Is Called
    Then The Response Should Contain 1pay BNPL Account And State Is Active
    And The Gateway Is Disabled

[TC-028] Manifest Response For User With Xpay BNPL Account RepaymentOption Is 1pay And Xpay And Channel Is QR And Amount Is Equal To Credit Balance
    Given The User Has 4pay Account
    And The Channel Is Set To QR
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And The Amount Is Set To Equal To Credit Balance
    When The Manifest API Is Called
    Then The Response Should Contain Xpay BNPL Account And State Is Active
    And The Gateway Is Disabled

[TC-029] Manifest Response For User With 1pay And Xpay BNPL Account And RepaymentOption Is 1pay And Xpay And Channel Is QR And Amount Is Equal To Credit Balance
    Given The User Has 1pay And 4pay Accounts
    And The Channel Is Set To QR
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And The Amount Is Set To Equal To Credit Balance
    When The Manifest API Is Called
    Then The Response Should Contain 1pay BNPL And Xpay BNPL Account And State Is Active
    And The Gateway Is Disabled

[TC-030] Manifest Response For User With 1pay BNPL Account RepaymentOption Is 1pay And Xpay And Channel Is QR And Amount Is Little Than Credit Balance
    Given The User Has 1pay Account
    And The Channel Is Set To QR
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And The Amount Is Set To Little Than Credit Balance
    When The Manifest API Is Called
    Then The Response Should Contain 1pay BNPL Account And State Is Active
    And The Gateway Is Disabled

[TC-031] Manifest Response For User With Xpay BNPL Account RepaymentOption Is 1pay And Xpay And Channel Is QR And Amount Is Little Than Credit Balance
    Given The User Has 4pay Account
    And The Channel Is Set To QR
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And The Amount Is Set To Little Than Credit Balance
    When The Manifest API Is Called
    Then The Response Should Contain Xpay BNPL Account And State Is Active
    And The Gateway Is Disabled

[TC-032] Manifest Response For User With 1pay And Xpay BNPL Account And RepaymentOption Is 1pay And Xpay And Channel Is QR And Amount Is Little Than Credit Balance
    Given The User Has 1pay And 4pay Accounts
    And The Channel Is Set To QR
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And The Amount Is Set To Little Than Credit Balance
    When The Manifest API Is Called
    Then The Response Should Contain 1pay BNPL And Xpay BNPL Account And State Is Active
    And The Gateway Is Disabled

[TC-033] Manifest Response For User With 1pay BNPL Account RepaymentOption Is 1pay And Xpay And Channel Is QR And Amount Is Greater Than Credit Balance
    Given The User Has 1pay Account
    And The Channel Is Set To QR
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And The Amount Is Set To Greater Than Credit Balance
    When The Manifest API Is Called
    Then The Response Should Contain 1pay BNPL Account And State Is Active
    And The Gateway Is Disabled

[TC-034] Manifest Response For User With Xpay BNPL Account RepaymentOption Is 1pay And Xpay And Channel Is QR And Amount Is Greater Than Credit Balance
    Given The User Has 4pay Account
    And The Channel Is Set To QR
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And The Amount Is Set To Greater Than Credit Balance
    When The Manifest API Is Called
    Then The Response Should Contain Xpay BNPL Account And State Is Active
    And The Gateway Is Disabled

[TC-035] Manifest Response For User With 1pay And Xpay BNPL Account And RepaymentOption Is 1pay And Xpay And Channel Is QR And Amount Is Greater Than Credit Balance
    Given The User Has 1pay And 4pay Accounts
    And The Channel Is Set To QR
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And The Amount Is Set To Greater Than Credit Balance
    When The Manifest API Is Called
    Then The Response Should Contain 1pay BNPL And Xpay BNPL Account And State Is Active
    And The Gateway Is Disabled

#############    👆 happy path RepaymentOption Is 1pay And Xpay and Channel is QR    #############

#############    👇 Zero Credit Balance and RepaymentOption Is 1pay And Xpay and Channel is QR    #############

[TC-036] Manifest Response For User With 1pay BNPL Account (Zero Credit Balance) And RepaymentOption Is 1pay And Xpay And Channel Is QR
    Given The User Has 1pay Account
    And The Channel Is Set To QR
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And The Amount Is Set To Greater Than Credit Balance
    And Empty Balance
    When The Manifest API Is Called
    Then The Response Should Contain 1pay BNPL Account (Zero Credit Balance) And State Is Active
    And The Gateway Is Disabled

[TC-037] Manifest Response For User With Xpay BNPL Account (Zero Credit Balance) And RepaymentOption Is 1pay And Xpay And Channel Is QR
    Given The User Has 4pay Account
    And The Channel Is Set To QR
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And The Amount Is Set To Greater Than Credit Balance
    And Empty Balance
    When The Manifest API Is Called
    Then The Response Should Contain Xpay BNPL Account (Zero Credit Balance) And State Is Active
    And The Gateway Is Disabled

[TC-038] Manifest Response For User With 1pay BNPL Account And Xpay BNPL Account (Zero Credit Balance) And RepaymentOption Is 1pay And Xpay And Channel Is QR
    Given The User Has 1pay And 4pay Accounts
    And The Channel Is Set To QR
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And The Amount Is Set To Greater Than Credit Balance
    And Empty Balance    credit_id=${credit_ids}[1]
    When The Manifest API Is Called
    Then The Response Should Contain 1pay BNPL And Xpay (Zero Credit Balance) BNPL Account And State Is Active
    And The Gateway Is Disabled

[TC-039] Manifest Response For User With 1pay BNPL Account (Zero Credit Balance) And Xpay BNPL Account And RepaymentOption Is 1pay And Xpay And Channel Is QR
    Given The User Has 1pay And 4pay Accounts
    And The Channel Is Set To QR
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And The Amount Is Set To Greater Than Credit Balance
    And Empty Balance    credit_id=${credit_ids}[0]
    When The Manifest API Is Called
    Then The Response Should Contain 1pay BNPL (Zero Credit Balance) And Xpay BNPL Account And State Is Active
    And The Gateway Is Disabled

[TC-040] Manifest Response For User With 1pay BNPL Account (Zero Credit Balance) And Xpay BNPL Account (Zero Credit Balance) And RepaymentOption Is 1pay And Xpay And Channel Is QR
    Given The User Has 1pay And 4pay Accounts
    And The Channel Is Set To QR
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And The Amount Is Set To Greater Than Credit Balance
    And Empty Balance    credit_id=${credit_ids}[0]
    And Empty Balance    credit_id=${credit_ids}[1]
    When The Manifest API Is Called
    Then The Response Should Contain 1pay BNPL (Zero Credit Balance) And Xpay BNPL (Zero Credit Balance) Account And State Is Active
    And The Gateway Is Disabled

#############    👆 Zero Credit Balance and RepaymentOption Is 1pay And Xpay and Channel is QR    #############

#############    👇 Expired and RepaymentOption Is 1pay And Xpay and Channel is QR    #############

[TC-041] Manifest Response For User With 1pay BNPL Account (Expired) And RepaymentOption Is 1pay And Xpay And Channel Is QR
    Given The User Has 1pay Account
    And The Channel Is Set To QR
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And The Amount Is Set To Greater Than Credit Balance
    And Empty Balance
    And Expire Account    credit_id=${credit_ids}[0]
    When The Manifest API Is Called
    Then The Response Should Contain 1pay BNPL Account And State Is Inactive
    And The Gateway Is Disabled

[TC-042] Manifest Response For User With Xpay BNPL Account (Expired) And RepaymentOption Is 1pay And Xpay And Channel Is QR
    Given The User Has 4pay Account
    And The Channel Is Set To QR
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And The Amount Is Set To Greater Than Credit Balance
    And Empty Balance
    And Expire Account    credit_id=${credit_ids}[0]
    When The Manifest API Is Called
    Then The Response Should Contain Xpay BNPL Account And State Is Inactive
    And The Gateway Is Disabled

[TC-043] Manifest Response For User With 1pay BNPL Account And Xpay BNPL Account (Expired) And RepaymentOption Is 1pay And Xpay And Channel Is QR
    Given The User Has 1pay And 4pay Accounts
    And The Channel Is Set To QR
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And The Amount Is Set To Greater Than Credit Balance
    And Empty Balance    credit_id=${credit_ids}[1]
    And Expire Account    credit_id=${credit_ids}[1]
    When The Manifest API Is Called
    Then The Response Should Contain 1pay BNPL State Is Active And Xpay BNPL Account State Is Inactive
    And The Gateway Is Disabled

[TC-044] Manifest Response For User With 1pay BNPL Account (Expired) And Xpay BNPL Account And RepaymentOption Is 1pay And Xpay And Channel Is QR
    Given The User Has 1pay And 4pay Accounts
    And The Channel Is Set To QR
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And The Amount Is Set To Greater Than Credit Balance
    And Empty Balance    credit_id=${credit_ids}[0]
    And Expire Account    credit_id=${credit_ids}[0]
    When The Manifest API Is Called
    Then The Response Should Contain 1pay BNPL State Is Inactive And Xpay BNPL Account State Is Active
    And The Gateway Is Disabled

[TC-045] Manifest Response For User With 1pay BNPL Account (Expired) And Xpay BNPL Account (Expired) And RepaymentOption Is 1pay And Xpay And Channel Is QR
    Given The User Has 1pay And 4pay Accounts
    And The Channel Is Set To QR
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And The Amount Is Set To Greater Than Credit Balance
    And Empty Balance    credit_id=${credit_ids}[0]
    And Empty Balance    credit_id=${credit_ids}[1]
    And Expire Account    credit_id=${credit_ids}[0]
    And Expire Account    credit_id=${credit_ids}[1]
    When The Manifest API Is Called
    Then The Response Should Contain 1pay BNPL And Xpay BNPL Account And State Is Inactive
    And The Gateway Is Disabled

#############    👆 Expired and RepaymentOption Is 1pay And Xpay and Channel is QR    #############

#############    👇 Blocked and RepaymentOption Is 1pay And Xpay and Channel is QR    #############

[TC-046] Manifest Response For User With Blocked 1pay BNPL Account And RepaymentOption Is 1pay And Xpay And Channel Is QR
    Given The User Has 1pay Account
    And The Channel Is Set To QR
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And The Amount Is Set To Greater Than Credit Balance
    And Block credit account
    When The Manifest API Is Called
    Then The Response Should Contain 1pay BNPL Account And State Is Inactive
    And The Gateway Is Disabled

[TC-047] Manifest Response For User With Blocked Xpay BNPL Account And RepaymentOption Is 1pay And Xpay And Channel Is QR
    Given The User Has 4pay Account
    And The Channel Is Set To QR
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And The Amount Is Set To Greater Than Credit Balance
    And Block credit account
    When The Manifest API Is Called
    Then The Response Should Contain Xpay BNPL Account And State Is Inactive
    And The Gateway Is Disabled

[TC-048] Manifest Response For User With 1pay BNPL Account And Blocked Xpay BNPL Account And RepaymentOption Is 1pay And Xpay And Channel Is QR
    Given The User Has 1pay And 4pay Accounts
    And The Channel Is Set To QR
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And The Amount Is Set To Greater Than Credit Balance
    And Block credit account    credit_id=${credit_ids}[1]
    When The Manifest API Is Called
    Then The Response Should Contain 1pay BNPL State Is Active And Xpay BNPL Account State Is Inactive
    And The Gateway Is Disabled

[TC-049] Manifest Response For User With Blocked 1pay BNPL Account And Xpay BNPL Account And RepaymentOption Is 1pay And Xpay And Channel Is QR
    Given The User Has 1pay And 4pay Accounts
    And The Channel Is Set To QR
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And The Amount Is Set To Greater Than Credit Balance
    And Block credit account    credit_id=${credit_ids}[0]
    When The Manifest API Is Called
    Then The Response Should Contain 1pay BNPL State Is Inactive And Xpay BNPL Account State Is Active
    And The Gateway Is Disabled

[TC-050] Manifest Response For User With Blocked 1pay BNPL Account And Blocked Xpay BNPL Account And RepaymentOption Is 1pay And Xpay And Channel Is QR
    Given The User Has 1pay And 4pay Accounts
    And The Channel Is Set To QR
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And The Amount Is Set To Greater Than Credit Balance
    And Block credit account    credit_id=${credit_ids}[0]
    And Block credit account    credit_id=${credit_ids}[1]
    When The Manifest API Is Called
    Then The Response Should Contain 1pay BNPL And Xpay BNPL Account And State Is Inactive
    And The Gateway Is Disabled

#############    👆 Blocked and RepaymentOption Is 1pay And Xpay and Channel is QR    #############

[TC-051] Manifest Response For User With Blocked 1pay BNPL Account And Expired Xpay BNPL Account And RepaymentOption Is 1pay And Xpay And Channel Is QR
    Given The User Has 1pay And 4pay Accounts
    And The Channel Is Set To QR
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And The Amount Is Set To Greater Than Credit Balance
    And Empty Balance    credit_id=${credit_ids}[1]
    And Expire Account    credit_id=${credit_ids}[1]
    And Block credit account    credit_id=${credit_ids}[0]
    When The Manifest API Is Called
    Then The Response Should Contain 1pay BNPL And Xpay BNPL Account And State Is Inactive
    And The Gateway Is Disabled

[TC-052] Manifest Response When Gateway Is Disabled And The Payment Gateway Is Set To BPG And Channel Is QR
    Given The User Has 1pay Account
    And The Channel Is Set To QR
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway Is Disabled
    And The Amount Is Set To Little Than Credit Balance
    When The Manifest API Is Called
    Then The Response Should Contain No Credit Account And State Is Disable For Payment Gateway BPG

#############    👇 happy path RepaymentOption Is 1pay and Channel is UPG    #############

[TC-053] Manifest Response For User With 1pay BNPL Account RepaymentOption Is 1pay And Channel Is UPG And Amount Is Equal To Credit Balance
    Given The User Has 1pay Account
    And The Channel Is Set To UPG
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay
    And The Amount Is Set To Equal To Credit Balance
    When The Manifest API Is Called
    Then The Response Should Contain 1pay BNPL Account And State Is Active
    And The Gateway Is Disabled

[TC-054] Manifest Response For User With Xpay BNPL Account RepaymentOption Is 1pay And Channel Is UPG And Amount Is Equal To Credit Balance
    Given The User Has 4pay Account
    And The Channel Is Set To UPG
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay
    And The Amount Is Set To Equal To Credit Balance
    When The Manifest API Is Called
    Then The Response Should Contain No Accounts
    And The Gateway Is Disabled

[TC-055] Manifest Response For User With 1pay And Xpay BNPL Account And RepaymentOption Is 1pay And Channel Is UPG And Amount Is Equal To Credit Balance
    Given The User Has 1pay And 4pay Accounts
    And The Channel Is Set To UPG
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay
    And The Amount Is Set To Equal To Credit Balance
    When The Manifest API Is Called
    Then The Response Should Contain 1pay BNPL Account And State Is Active
    And The Gateway Is Disabled

[TC-056] Manifest Response For User With 1pay BNPL Account RepaymentOption Is 1pay And Channel Is UPG And Amount Is Little Than Credit Balance
    Given The User Has 1pay Account
    And The Channel Is Set To UPG
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay
    And The Amount Is Set To Little Than Credit Balance
    When The Manifest API Is Called
    Then The Response Should Contain 1pay BNPL Account And State Is Active
    And The Gateway Is Disabled

[TC-057] Manifest Response For User With Xpay BNPL Account RepaymentOption Is 1pay And Channel Is UPG And Amount Is Little Than Credit Balance
    Given The User Has 4pay Account
    And The Channel Is Set To UPG
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay
    And The Amount Is Set To Little Than Credit Balance
    When The Manifest API Is Called
    Then The Response Should Contain No Accounts
    And The Gateway Is Disabled

[TC-058] Manifest Response For User With 1pay And Xpay BNPL Account And RepaymentOption Is 1pay And Channel Is UPG And Amount Is Little Than Credit Balance
    Given The User Has 1pay And 4pay Accounts
    And The Channel Is Set To UPG
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay
    And The Amount Is Set To Little Than Credit Balance
    When The Manifest API Is Called
    Then The Response Should Contain 1pay BNPL Account And State Is Active
    And The Gateway Is Disabled

[TC-059] Manifest Response For User With 1pay BNPL Account RepaymentOption Is 1pay And Channel Is UPG And Amount Is Greater Than Credit Balance
    Given The User Has 1pay Account
    And The Channel Is Set To UPG
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay
    And The Amount Is Set To Greater Than Credit Balance
    When The Manifest API Is Called
    Then The Response Should Contain 1pay BNPL Account And State Is Active
    And The Gateway Is Disabled

[TC-060] Manifest Response For User With Xpay BNPL Account RepaymentOption Is 1pay And Channel Is UPG And Amount Is Greater Than Credit Balance
    Given The User Has 4pay Account
    And The Channel Is Set To UPG
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay
    And The Amount Is Set To Greater Than Credit Balance
    When The Manifest API Is Called
    Then The Response Should Contain No Accounts
    And The Gateway Is Disabled

[TC-061] Manifest Response For User With 1pay And Xpay BNPL Account And RepaymentOption Is 1pay And Channel Is UPG And Amount Is Greater Than Credit Balance
    Given The User Has 1pay And 4pay Accounts
    And The Channel Is Set To UPG
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay
    And The Amount Is Set To Greater Than Credit Balance
    When The Manifest API Is Called
    Then The Response Should Contain 1pay BNPL Account And State Is Active
    And The Gateway Is Disabled

#############    👆 happy path RepaymentOption Is 1pay and Channel is UPG    #############

#############    👇 Zero Credit Balance and RepaymentOption Is 1pay and Channel is UPG    #############

[TC-062] Manifest Response For User With 1pay BNPL Account (Zero Credit Balance) And RepaymentOption Is 1pay And Channel Is UPG
    Given The User Has 1pay Account
    And The Channel Is Set To UPG
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay
    And The Amount Is Set To Greater Than Credit Balance
    And Empty Balance
    When The Manifest API Is Called
    Then The Response Should Contain 1pay BNPL Account (Zero Credit Balance) And State Is Active
    And The Gateway Is Disabled

[TC-063] Manifest Response For User With Xpay BNPL Account (Zero Credit Balance) And RepaymentOption Is 1pay And Channel Is UPG
    Given The User Has 4pay Account
    And The Channel Is Set To UPG
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay
    And The Amount Is Set To Greater Than Credit Balance
    And Empty Balance
    When The Manifest API Is Called
    Then The Response Should Contain No Accounts
    And The Gateway Is Disabled

[TC-064] Manifest Response For User With 1pay BNPL Account And Xpay BNPL Account (Zero Credit Balance) And RepaymentOption Is 1pay And Channel Is UPG
    Given The User Has 1pay And 4pay Accounts
    And The Channel Is Set To UPG
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay
    And The Amount Is Set To Greater Than Credit Balance
    And Empty Balance    credit_id=${credit_ids}[1]
    When The Manifest API Is Called
    Then The Response Should Contain 1pay BNPL Account And State Is Active
    And The Gateway Is Disabled

[TC-065] Manifest Response For User With 1pay BNPL Account (Zero Credit Balance) And Xpay BNPL Account And RepaymentOption Is 1pay And Channel Is UPG
    Given The User Has 1pay And 4pay Accounts
    And The Channel Is Set To UPG
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay
    And The Amount Is Set To Greater Than Credit Balance
    And Empty Balance    credit_id=${credit_ids}[0]
    When The Manifest API Is Called
    Then The Response Should Contain 1pay BNPL Account (Zero Credit Balance) And State Is Active
    And The Gateway Is Disabled

[TC-066] Manifest Response For User With 1pay BNPL Account (Zero Credit Balance) And Xpay BNPL Account (Zero Credit Balance) And RepaymentOption Is 1pay And Channel Is UPG
    Given The User Has 1pay And 4pay Accounts
    And The Channel Is Set To UPG
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay
    And The Amount Is Set To Greater Than Credit Balance
    And Empty Balance    credit_id=${credit_ids}[0]
    And Empty Balance    credit_id=${credit_ids}[1]
    When The Manifest API Is Called
    Then The Response Should Contain 1pay BNPL Account (Zero Credit Balance) And State Is Active
    And The Gateway Is Disabled

#############    👆 Zero Credit Balance and RepaymentOption Is 1pay and Channel is UPG    #############

#############    👇 Expired and RepaymentOption Is 1pay and Channel is UPG    #############

[TC-067] Manifest Response For User With 1pay BNPL Account (Expired) And RepaymentOption Is 1pay And Channel Is UPG
    Given The User Has 1pay Account
    And The Channel Is Set To UPG
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay
    And The Amount Is Set To Greater Than Credit Balance
    And Empty Balance
    And Expire Account    credit_id=${credit_ids}[0]
    When The Manifest API Is Called
    Then The Response Should Contain 1pay BNPL Account And State Is Inactive
    And The Gateway Is Disabled

[TC-068] Manifest Response For User With Xpay BNPL Account (Expired) And RepaymentOption Is 1pay And Channel Is UPG
    Given The User Has 4pay Account
    And The Channel Is Set To UPG
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay
    And The Amount Is Set To Greater Than Credit Balance
    And Empty Balance
    And Expire Account    credit_id=${credit_ids}[0]
    When The Manifest API Is Called
    Then The Response Should Contain No Accounts
    And The Gateway Is Disabled

[TC-069] Manifest Response For User With 1pay BNPL Account And Xpay BNPL Account (Expired) And RepaymentOption Is 1pay And Channel Is UPG
    Given The User Has 1pay And 4pay Accounts
    And The Channel Is Set To UPG
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay
    And The Amount Is Set To Greater Than Credit Balance
    And Empty Balance    credit_id=${credit_ids}[1]
    And Expire Account    credit_id=${credit_ids}[1]
    When The Manifest API Is Called
    Then The Response Should Contain 1pay BNPL Account And State Is Active
    And The Gateway Is Disabled

[TC-070] Manifest Response For User With 1pay BNPL Account (Expired) And Xpay BNPL Account And RepaymentOption Is 1pay And Channel Is UPG
    Given The User Has 1pay And 4pay Accounts
    And The Channel Is Set To UPG
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay
    And The Amount Is Set To Greater Than Credit Balance
    And Empty Balance    credit_id=${credit_ids}[0]
    And Expire Account    credit_id=${credit_ids}[0]
    When The Manifest API Is Called
    Then The Response Should Contain 1pay BNPL Account And State Is Inactive
    And The Gateway Is Disabled

[TC-071] Manifest Response For User With 1pay BNPL Account (Expired) And Xpay BNPL Account (Expired) And RepaymentOption Is 1pay And Channel Is UPG
    Given The User Has 1pay And 4pay Accounts
    And The Channel Is Set To UPG
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay
    And The Amount Is Set To Greater Than Credit Balance
    And Empty Balance    credit_id=${credit_ids}[0]
    And Empty Balance    credit_id=${credit_ids}[1]
    And Expire Account    credit_id=${credit_ids}[0]
    And Expire Account    credit_id=${credit_ids}[1]
    When The Manifest API Is Called
    Then The Response Should Contain 1pay BNPL Account And State Is Inactive
    And The Gateway Is Disabled

#############    👆 Expired and RepaymentOption Is 1pay and Channel is UPG    #############

#############    👇 Blocked and RepaymentOption Is 1pay and Channel is UPG    #############

[TC-072] Manifest Response For User With Blocked 1pay BNPL Account And RepaymentOption Is 1pay And Channel Is UPG
    Given The User Has 1pay Account
    And The Channel Is Set To UPG
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay
    And The Amount Is Set To Greater Than Credit Balance
    And Block credit account
    When The Manifest API Is Called
    Then The Response Should Contain 1pay BNPL Account And State Is Inactive
    And The Gateway Is Disabled

[TC-073] Manifest Response For User With Blocked Xpay BNPL Account And RepaymentOption Is 1pay And Channel Is UPG
    Given The User Has 4pay Account
    And The Channel Is Set To UPG
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay
    And The Amount Is Set To Greater Than Credit Balance
    And Block credit account
    When The Manifest API Is Called
    Then The Response Should Contain No Accounts
    And The Gateway Is Disabled

[TC-074] Manifest Response For User With 1pay BNPL Account And Blocked Xpay BNPL Account And RepaymentOption Is 1pay And Channel Is UPG
    Given The User Has 1pay And 4pay Accounts
    And The Channel Is Set To UPG
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay
    And The Amount Is Set To Greater Than Credit Balance
    And Block credit account    credit_id=${credit_ids}[1]
    When The Manifest API Is Called
    Then The Response Should Contain 1pay BNPL Account And State Is Active
    And The Gateway Is Disabled

[TC-075] Manifest Response For User With Blocked 1pay BNPL Account And Xpay BNPL Account And RepaymentOption Is 1pay And Channel Is UPG
    Given The User Has 1pay And 4pay Accounts
    And The Channel Is Set To UPG
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay
    And The Amount Is Set To Greater Than Credit Balance
    And Block credit account    credit_id=${credit_ids}[0]
    When The Manifest API Is Called
    Then The Response Should Contain 1pay BNPL Account And State Is Inactive
    And The Gateway Is Disabled

[TC-076] Manifest Response For User With Blocked 1pay BNPL Account And Blocked Xpay BNPL Account And RepaymentOption Is 1pay And Channel Is UPG
    Given The User Has 1pay And 4pay Accounts
    And The Channel Is Set To UPG
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay
    And The Amount Is Set To Greater Than Credit Balance
    And Block credit account    credit_id=${credit_ids}[0]
    And Block credit account    credit_id=${credit_ids}[1]
    When The Manifest API Is Called
    Then The Response Should Contain 1pay BNPL Account And State Is Inactive
    And The Gateway Is Disabled

#############    👆 Blocked and RepaymentOption Is 1pay and Channel is UPG    #############

[TC-077] Manifest Response For User With Blocked 1pay BNPL Account And Expired Xpay BNPL Account And RepaymentOption Is 1pay And Channel Is UPG
    Given The User Has 1pay And 4pay Accounts
    And The Channel Is Set To UPG
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay
    And The Amount Is Set To Greater Than Credit Balance
    And Empty Balance    credit_id=${credit_ids}[1]
    And Expire Account    credit_id=${credit_ids}[1]
    And Block credit account    credit_id=${credit_ids}[0]
    When The Manifest API Is Called
    Then The Response Should Contain 1pay BNPL Account And State Is Inactive
    And The Gateway Is Disabled

#############    👇 happy path RepaymentOption Is 1pay and Channel is QR    #############

[TC-078] Manifest Response For User With 1pay BNPL Account RepaymentOption Is 1pay And Channel Is QR And Amount Is Equal To Credit Balance
    Given The User Has 1pay Account
    And The Channel Is Set To QR
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay
    And The Amount Is Set To Equal To Credit Balance
    When The Manifest API Is Called
    Then The Response Should Contain 1pay BNPL Account And State Is Active
    And The Gateway Is Disabled

[TC-079] Manifest Response For User With Xpay BNPL Account RepaymentOption Is 1pay And Channel Is QR And Amount Is Equal To Credit Balance
    Given The User Has 4pay Account
    And The Channel Is Set To QR
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay
    And The Amount Is Set To Equal To Credit Balance
    When The Manifest API Is Called
    Then The Response Should Contain State Is Disable
    And The Gateway Is Disabled

[TC-080] Manifest Response For User With 1pay And Xpay BNPL Account And RepaymentOption Is 1pay And Channel Is QR And Amount Is Equal To Credit Balance
    Given The User Has 1pay And 4pay Accounts
    And The Channel Is Set To QR
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay
    And The Amount Is Set To Equal To Credit Balance
    When The Manifest API Is Called
    Then The Response Should Contain 1pay BNPL Account And State Is Active
    And The Gateway Is Disabled

[TC-081] Manifest Response For User With 1pay BNPL Account RepaymentOption Is 1pay And Channel Is QR And Amount Is Little Than Credit Balance
    Given The User Has 1pay Account
    And The Channel Is Set To QR
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay
    And The Amount Is Set To Little Than Credit Balance
    When The Manifest API Is Called
    Then The Response Should Contain 1pay BNPL Account And State Is Active
    And The Gateway Is Disabled

[TC-082] Manifest Response For User With Xpay BNPL Account RepaymentOption Is 1pay And Channel Is QR And Amount Is Little Than Credit Balance
    Given The User Has 4pay Account
    And The Channel Is Set To QR
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay
    And The Amount Is Set To Little Than Credit Balance
    When The Manifest API Is Called
    Then The Response Should Contain State Is Disable
    And The Gateway Is Disabled

[TC-083] Manifest Response For User With 1pay And Xpay BNPL Account And RepaymentOption Is 1pay And Channel Is QR And Amount Is Little Than Credit Balance
    Given The User Has 1pay And 4pay Accounts
    And The Channel Is Set To QR
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay
    And The Amount Is Set To Little Than Credit Balance
    When The Manifest API Is Called
    Then The Response Should Contain 1pay BNPL Account And State Is Active
    And The Gateway Is Disabled

[TC-084] Manifest Response For User With 1pay BNPL Account RepaymentOption Is 1pay And Channel Is QR And Amount Is Greater Than Credit Balance
    Given The User Has 1pay Account
    And The Channel Is Set To QR
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay
    And The Amount Is Set To Greater Than Credit Balance
    When The Manifest API Is Called
    Then The Response Should Contain 1pay BNPL Account And State Is Active
    And The Gateway Is Disabled

[TC-085] Manifest Response For User With Xpay BNPL Account RepaymentOption Is 1pay And Channel Is QR And Amount Is Greater Than Credit Balance
    Given The User Has 4pay Account
    And The Channel Is Set To QR
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay
    And The Amount Is Set To Greater Than Credit Balance
    When The Manifest API Is Called
    Then The Response Should Contain State Is Disable
    And The Gateway Is Disabled

[TC-086] Manifest Response For User With 1pay And Xpay BNPL Account And RepaymentOption Is 1pay And Channel Is QR And Amount Is Greater Than Credit Balance
    Given The User Has 1pay And 4pay Accounts
    And The Channel Is Set To QR
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay
    And The Amount Is Set To Greater Than Credit Balance
    When The Manifest API Is Called
    Then The Response Should Contain 1pay BNPL Account And State Is Active
    And The Gateway Is Disabled

#############    👆 happy path RepaymentOption Is 1pay and Channel is QR    #############

#############    👇 Zero Credit Balance and RepaymentOption Is 1pay and Channel is QR    #############

[TC-087] Manifest Response For User With 1pay BNPL Account (Zero Credit Balance) And RepaymentOption Is 1pay And Channel Is QR
    Given The User Has 1pay Account
    And The Channel Is Set To QR
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay
    And The Amount Is Set To Greater Than Credit Balance
    And Empty Balance
    When The Manifest API Is Called
    Then The Response Should Contain 1pay BNPL Account (Zero Credit Balance) And State Is Active
    And The Gateway Is Disabled

[TC-088] Manifest Response For User With Xpay BNPL Account (Zero Credit Balance) And RepaymentOption Is 1pay And Channel Is QR
    Given The User Has 4pay Account
    And The Channel Is Set To QR
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay
    And The Amount Is Set To Greater Than Credit Balance
    And Empty Balance
    When The Manifest API Is Called
    Then The Response Should Contain State Is Disable
    And The Gateway Is Disabled

[TC-089] Manifest Response For User With 1pay BNPL Account And Xpay BNPL Account (Zero Credit Balance) And RepaymentOption Is 1pay And Channel Is QR
    Given The User Has 1pay And 4pay Accounts
    And The Channel Is Set To QR
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay
    And The Amount Is Set To Greater Than Credit Balance
    And Empty Balance    credit_id=${credit_ids}[1]
    When The Manifest API Is Called
    Then The Response Should Contain 1pay BNPL Account And State Is Active
    And The Gateway Is Disabled

[TC-090] Manifest Response For User With 1pay BNPL Account (Zero Credit Balance) And Xpay BNPL Account And RepaymentOption Is 1pay And Channel Is QR
    Given The User Has 1pay And 4pay Accounts
    And The Channel Is Set To QR
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay
    And The Amount Is Set To Greater Than Credit Balance
    And Empty Balance    credit_id=${credit_ids}[0]
    When The Manifest API Is Called
    Then The Response Should Contain 1pay BNPL Account (Zero Credit Balance) And State Is Active
    And The Gateway Is Disabled

[TC-091] Manifest Response For User With 1pay BNPL Account (Zero Credit Balance) And Xpay BNPL Account (Zero Credit Balance) And RepaymentOption Is 1pay And Channel Is QR
    Given The User Has 1pay And 4pay Accounts
    And The Channel Is Set To QR
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay
    And The Amount Is Set To Greater Than Credit Balance
    And Empty Balance    credit_id=${credit_ids}[0]
    And Empty Balance    credit_id=${credit_ids}[1]
    When The Manifest API Is Called
    Then The Response Should Contain 1pay BNPL Account (Zero Credit Balance) And State Is Active
    And The Gateway Is Disabled

#############    👆 Zero Credit Balance and RepaymentOption Is 1pay and Channel is QR    #############

#############    👇 Expired and RepaymentOption Is 1pay and Channel is QR    #############

[TC-092] Manifest Response For User With 1pay BNPL Account (Expired) And RepaymentOption Is 1pay And Channel Is QR
    Given The User Has 1pay Account
    And The Channel Is Set To QR
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay
    And The Amount Is Set To Greater Than Credit Balance
    And Empty Balance
    And Expire Account    credit_id=${credit_ids}[0]
    When The Manifest API Is Called
    Then The Response Should Contain 1pay BNPL Account And State Is Inactive
    And The Gateway Is Disabled

[TC-093] Manifest Response For User With Xpay BNPL Account (Expired) And RepaymentOption Is 1pay And Channel Is QR
    Given The User Has 4pay Account
    And The Channel Is Set To QR
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay
    And The Amount Is Set To Greater Than Credit Balance
    And Empty Balance
    And Expire Account    credit_id=${credit_ids}[0]
    When The Manifest API Is Called
    Then The Response Should Contain State Is Disable
    And The Gateway Is Disabled

[TC-094] Manifest Response For User With 1pay BNPL Account And Xpay BNPL Account (Expired) And RepaymentOption Is 1pay And Channel Is QR
    Given The User Has 1pay And 4pay Accounts
    And The Channel Is Set To QR
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay
    And The Amount Is Set To Greater Than Credit Balance
    And Empty Balance    credit_id=${credit_ids}[1]
    And Expire Account    credit_id=${credit_ids}[1]
    When The Manifest API Is Called
    Then The Response Should Contain 1pay BNPL Account And State Is Active
    And The Gateway Is Disabled

[TC-095] Manifest Response For User With 1pay BNPL Account (Expired) And Xpay BNPL Account And RepaymentOption Is 1pay And Channel Is QR
    Given The User Has 1pay And 4pay Accounts
    And The Channel Is Set To QR
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay
    And The Amount Is Set To Greater Than Credit Balance
    And Empty Balance    credit_id=${credit_ids}[0]
    And Expire Account    credit_id=${credit_ids}[0]
    When The Manifest API Is Called
    Then The Response Should Contain 1pay BNPL Account And State Is Inactive
    And The Gateway Is Disabled

[TC-096] Manifest Response For User With 1pay BNPL Account (Expired) And Xpay BNPL Account (Expired) And RepaymentOption Is 1pay And Channel Is QR
    Given The User Has 1pay And 4pay Accounts
    And The Channel Is Set To QR
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay
    And The Amount Is Set To Greater Than Credit Balance
    And Empty Balance    credit_id=${credit_ids}[0]
    And Empty Balance    credit_id=${credit_ids}[1]
    And Expire Account    credit_id=${credit_ids}[0]
    And Expire Account    credit_id=${credit_ids}[1]
    When The Manifest API Is Called
    Then The Response Should Contain 1pay BNPL Account And State Is Inactive
    And The Gateway Is Disabled

#############    👆 Expired and RepaymentOption Is 1pay and Channel is QR    #############

#############    👇 Blocked and RepaymentOption Is 1pay and Channel is QR    #############

[TC-097] Manifest Response For User With Blocked 1pay BNPL Account And RepaymentOption Is 1pay And Channel Is QR
    Given The User Has 1pay Account
    And The Channel Is Set To QR
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay
    And The Amount Is Set To Greater Than Credit Balance
    And Block credit account
    When The Manifest API Is Called
    Then The Response Should Contain 1pay BNPL Account And State Is Inactive
    And The Gateway Is Disabled

[TC-098] Manifest Response For User With Blocked Xpay BNPL Account And RepaymentOption Is 1pay And Channel Is QR
    Given The User Has 4pay Account
    And The Channel Is Set To QR
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay
    And The Amount Is Set To Greater Than Credit Balance
    And Block credit account
    When The Manifest API Is Called
    Then The Response Should Contain State Is Disable
    And The Gateway Is Disabled

[TC-099] Manifest Response For User With 1pay BNPL Account And Blocked Xpay BNPL Account And RepaymentOption Is 1pay And Channel Is QR
    Given The User Has 1pay And 4pay Accounts
    And The Channel Is Set To QR
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay
    And The Amount Is Set To Greater Than Credit Balance
    And Block credit account    credit_id=${credit_ids}[1]
    When The Manifest API Is Called
    Then The Response Should Contain 1pay BNPL Account And State Is Active
    And The Gateway Is Disabled

[TC-100] Manifest Response For User With Blocked 1pay BNPL Account And Xpay BNPL Account And RepaymentOption Is 1pay And Channel Is QR
    Given The User Has 1pay And 4pay Accounts
    And The Channel Is Set To QR
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay
    And The Amount Is Set To Greater Than Credit Balance
    And Block credit account    credit_id=${credit_ids}[0]
    When The Manifest API Is Called
    Then The Response Should Contain 1pay BNPL Account And State Is Inactive
    And The Gateway Is Disabled

[TC-101] Manifest Response For User With Blocked 1pay BNPL Account And Blocked Xpay BNPL Account And RepaymentOption Is 1pay And Channel Is QR
    Given The User Has 1pay And 4pay Accounts
    And The Channel Is Set To QR
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay
    And The Amount Is Set To Greater Than Credit Balance
    And Block credit account    credit_id=${credit_ids}[0]
    And Block credit account    credit_id=${credit_ids}[1]
    When The Manifest API Is Called
    Then The Response Should Contain 1pay BNPL Account And State Is Inactive
    And The Gateway Is Disabled

#############    👆 Blocked and RepaymentOption Is 1pay and Channel is QR    #############

[TC-102] Manifest Response For User With Blocked 1pay BNPL Account And Expired Xpay BNPL Account And RepaymentOption Is 1pay And Channel Is QR
    Given The User Has 1pay And 4pay Accounts
    And The Channel Is Set To QR
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay
    And The Amount Is Set To Greater Than Credit Balance
    And Empty Balance    credit_id=${credit_ids}[1]
    And Expire Account    credit_id=${credit_ids}[1]
    And Block credit account    credit_id=${credit_ids}[0]
    When The Manifest API Is Called
    Then The Response Should Contain 1pay BNPL Account And State Is Inactive
    And The Gateway Is Disabled

#############    👇 happy path RepaymentOption Is Xpay and Channel is UPG    #############

[TC-103] Manifest Response For User With 1pay BNPL Account RepaymentOption Is Xpay And Channel Is UPG And Amount Is Equal To Credit Balance
    Given The User Has 1pay Account
    And The Channel Is Set To UPG
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To Xpay
    And The Amount Is Set To Equal To Credit Balance
    When The Manifest API Is Called
    Then The Response Should Contain No Accounts
    And The Gateway Is Disabled

[TC-104] Manifest Response For User With Xpay BNPL Account RepaymentOption Is Xpay And Channel Is UPG And Amount Is Equal To Credit Balance
    Given The User Has 4pay Account
    And The Channel Is Set To UPG
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To Xpay
    And The Amount Is Set To Equal To Credit Balance
    When The Manifest API Is Called
    Then The Response Should Contain Xpay BNPL Account And State Is Active
    And The Gateway Is Disabled

[TC-105] Manifest Response For User With 1pay And Xpay BNPL Account And RepaymentOption Is Xpay And Channel Is UPG And Amount Is Equal To Credit Balance
    Given The User Has 1pay And 4pay Accounts
    And The Channel Is Set To UPG
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To Xpay
    And The Amount Is Set To Equal To Credit Balance
    When The Manifest API Is Called
    Then The Response Should Contain Xpay BNPL Account And State Is Active
    And The Gateway Is Disabled

[TC-106] Manifest Response For User With 1pay BNPL Account RepaymentOption Is Xpay And Channel Is UPG And Amount Is Little Than Credit Balance
    Given The User Has 1pay Account
    And The Channel Is Set To UPG
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To Xpay
    And The Amount Is Set To Little Than Credit Balance
    When The Manifest API Is Called
    Then The Response Should Contain No Accounts
    And The Gateway Is Disabled

[TC-107] Manifest Response For User With Xpay BNPL Account RepaymentOption Is Xpay And Channel Is UPG And Amount Is Little Than Credit Balance
    Given The User Has 4pay Account
    And The Channel Is Set To UPG
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To Xpay
    And The Amount Is Set To Little Than Credit Balance
    When The Manifest API Is Called
    Then The Response Should Contain Xpay BNPL Account And State Is Active
    And The Gateway Is Disabled

[TC-108] Manifest Response For User With 1pay And Xpay BNPL Account And RepaymentOption Is Xpay And Channel Is UPG And Amount Is Little Than Credit Balance
    Given The User Has 1pay And 4pay Accounts
    And The Channel Is Set To UPG
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To Xpay
    And The Amount Is Set To Little Than Credit Balance
    When The Manifest API Is Called
    Then The Response Should Contain Xpay BNPL Account And State Is Active
    And The Gateway Is Disabled

[TC-109] Manifest Response For User With 1pay BNPL Account RepaymentOption Is Xpay And Channel Is UPG And Amount Is Greater Than Credit Balance
    Given The User Has 1pay Account
    And The Channel Is Set To UPG
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To Xpay
    And The Amount Is Set To Greater Than Credit Balance
    When The Manifest API Is Called
    Then The Response Should Contain No Accounts
    And The Gateway Is Disabled

[TC-110] Manifest Response For User With Xpay BNPL Account RepaymentOption Is Xpay And Channel Is UPG And Amount Is Greater Than Credit Balance
    Given The User Has 4pay Account
    And The Channel Is Set To UPG
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To Xpay
    And The Amount Is Set To Greater Than Credit Balance
    When The Manifest API Is Called
    Then The Response Should Contain Xpay BNPL Account And State Is Active
    And The Gateway Is Disabled

[TC-111] Manifest Response For User With 1pay And Xpay BNPL Account And RepaymentOption Is Xpay And Channel Is UPG And Amount Is Greater Than Credit Balance
    Given The User Has 1pay And 4pay Accounts
    And The Channel Is Set To UPG
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To Xpay
    And The Amount Is Set To Greater Than Credit Balance
    When The Manifest API Is Called
    Then The Response Should Contain Xpay BNPL Account And State Is Active
    And The Gateway Is Disabled

#############    👆 happy path RepaymentOption Is Xpay and Channel is UPG    #############

#############    👇 Zero Credit Balance and RepaymentOption Is Xpay and Channel is UPG    #############

[TC-112] Manifest Response For User With 1pay BNPL Account (Zero Credit Balance) And RepaymentOption Is Xpay And Channel Is UPG
    Given The User Has 1pay Account
    And The Channel Is Set To UPG
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To Xpay
    And The Amount Is Set To Greater Than Credit Balance
    And Empty Balance
    When The Manifest API Is Called
    Then The Response Should Contain No Accounts
    And The Gateway Is Disabled

[TC-113] Manifest Response For User With Xpay BNPL Account (Zero Credit Balance) And RepaymentOption Is Xpay And Channel Is UPG
    Given The User Has 4pay Account
    And The Channel Is Set To UPG
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To Xpay
    And The Amount Is Set To Greater Than Credit Balance
    And Empty Balance
    When The Manifest API Is Called
    Then The Response Should Contain Xpay BNPL Account (Zero Credit Balance) And State Is Active
    And The Gateway Is Disabled

[TC-114] Manifest Response For User With 1pay BNPL Account And Xpay BNPL Account (Zero Credit Balance) And RepaymentOption Is Xpay And Channel Is UPG
    Given The User Has 1pay And 4pay Accounts
    And The Channel Is Set To UPG
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To Xpay
    And The Amount Is Set To Greater Than Credit Balance
    And Empty Balance    credit_id=${credit_ids}[1]
    When The Manifest API Is Called
    Then The Response Should Contain Xpay BNPL Account (Zero Credit Balance) And State Is Active
    And The Gateway Is Disabled

[TC-115] Manifest Response For User With 1pay BNPL Account (Zero Credit Balance) And Xpay BNPL Account And RepaymentOption Is Xpay And Channel Is UPG
    Given The User Has 1pay And 4pay Accounts
    And The Channel Is Set To UPG
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To Xpay
    And The Amount Is Set To Greater Than Credit Balance
    And Empty Balance    credit_id=${credit_ids}[0]
    When The Manifest API Is Called
    Then The Response Should Contain Xpay BNPL Account And State Is Active
    And The Gateway Is Disabled

[TC-116] Manifest Response For User With 1pay BNPL Account (Zero Credit Balance) And Xpay BNPL Account (Zero Credit Balance) And RepaymentOption Is Xpay And Channel Is UPG
    Given The User Has 1pay And 4pay Accounts
    And The Channel Is Set To UPG
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To Xpay
    And The Amount Is Set To Greater Than Credit Balance
    And Empty Balance    credit_id=${credit_ids}[0]
    And Empty Balance    credit_id=${credit_ids}[1]
    When The Manifest API Is Called
    Then The Response Should Contain Xpay BNPL Account (Zero Credit Balance) And State Is Active
    And The Gateway Is Disabled

#############    👆 Zero Credit Balance and RepaymentOption Is Xpay and Channel is UPG    #############

#############    👇 Expired and RepaymentOption Is Xpay and Channel is UPG    #############

[TC-117] Manifest Response For User With 1pay BNPL Account (Expired) And RepaymentOption Is Xpay And Channel Is UPG
    Given The User Has 1pay Account
    And The Channel Is Set To UPG
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To Xpay
    And The Amount Is Set To Greater Than Credit Balance
    And Empty Balance
    And Expire Account    credit_id=${credit_ids}[0]
    When The Manifest API Is Called
    Then The Response Should Contain No Accounts
    And The Gateway Is Disabled

[TC-118] Manifest Response For User With Xpay BNPL Account (Expired) And RepaymentOption Is Xpay And Channel Is UPG
    Given The User Has 4pay Account
    And The Channel Is Set To UPG
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To Xpay
    And The Amount Is Set To Greater Than Credit Balance
    And Empty Balance
    And Expire Account    credit_id=${credit_ids}[0]
    When The Manifest API Is Called
    Then The Response Should Contain Xpay BNPL Account And State Is Inactive
    And The Gateway Is Disabled

[TC-119] Manifest Response For User With 1pay BNPL Account And Xpay BNPL Account (Expired) And RepaymentOption Is Xpay And Channel Is UPG
    Given The User Has 1pay And 4pay Accounts
    And The Channel Is Set To UPG
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To Xpay
    And The Amount Is Set To Greater Than Credit Balance
    And Empty Balance    credit_id=${credit_ids}[1]
    And Expire Account    credit_id=${credit_ids}[1]
    When The Manifest API Is Called
    Then The Response Should Contain Xpay BNPL Account And State Is Inactive
    And The Gateway Is Disabled

[TC-120] Manifest Response For User With 1pay BNPL Account (Expired) And Xpay BNPL Account And RepaymentOption Is Xpay And Channel Is UPG
    Given The User Has 1pay And 4pay Accounts
    And The Channel Is Set To UPG
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To Xpay
    And The Amount Is Set To Greater Than Credit Balance
    And Empty Balance    credit_id=${credit_ids}[0]
    And Expire Account    credit_id=${credit_ids}[0]
    When The Manifest API Is Called
    Then The Response Should Contain Xpay BNPL Account And State Is Active
    And The Gateway Is Disabled

[TC-121] Manifest Response For User With 1pay BNPL Account (Expired) And Xpay BNPL Account (Expired) And RepaymentOption Is Xpay And Channel Is UPG
    Given The User Has 1pay And 4pay Accounts
    And The Channel Is Set To UPG
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To Xpay
    And The Amount Is Set To Greater Than Credit Balance
    And Empty Balance    credit_id=${credit_ids}[0]
    And Empty Balance    credit_id=${credit_ids}[1]
    And Expire Account    credit_id=${credit_ids}[0]
    And Expire Account    credit_id=${credit_ids}[1]
    When The Manifest API Is Called
    Then The Response Should Contain Xpay BNPL Account And State Is Inactive
    And The Gateway Is Disabled

#############    👆 Expired and RepaymentOption Is Xpay and Channel is UPG    #############

#############    👇 Blocked and RepaymentOption Is Xpay and Channel is UPG    #############

[TC-122] Manifest Response For User With Blocked 1pay BNPL Account And RepaymentOption Is Xpay And Channel Is UPG
    Given The User Has 1pay Account
    And The Channel Is Set To UPG
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To Xpay
    And The Amount Is Set To Greater Than Credit Balance
    And Block credit account
    When The Manifest API Is Called
    Then The Response Should Contain No Accounts
    And The Gateway Is Disabled

[TC-123] Manifest Response For User With Blocked Xpay BNPL Account And RepaymentOption Is Xpay And Channel Is UPG
    Given The User Has 4pay Account
    And The Channel Is Set To UPG
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To Xpay
    And The Amount Is Set To Greater Than Credit Balance
    And Block credit account
    When The Manifest API Is Called
    Then The Response Should Contain Xpay BNPL Account And State Is Inactive
    And The Gateway Is Disabled

[TC-124] Manifest Response For User With 1pay BNPL Account And Blocked Xpay BNPL Account And RepaymentOption Is Xpay And Channel Is UPG
    Given The User Has 1pay And 4pay Accounts
    And The Channel Is Set To UPG
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To Xpay
    And The Amount Is Set To Greater Than Credit Balance
    And Block credit account    credit_id=${credit_ids}[1]
    When The Manifest API Is Called
    Then The Response Should Contain Xpay BNPL Account And State Is Inactive
    And The Gateway Is Disabled

[TC-125] Manifest Response For User With Blocked 1pay BNPL Account And Xpay BNPL Account And RepaymentOption Is Xpay And Channel Is UPG
    Given The User Has 1pay And 4pay Accounts
    And The Channel Is Set To UPG
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To Xpay
    And The Amount Is Set To Greater Than Credit Balance
    And Block credit account    credit_id=${credit_ids}[0]
    When The Manifest API Is Called
    Then The Response Should Contain Xpay BNPL Account And State Is Active
    And The Gateway Is Disabled

[TC-126] Manifest Response For User With Blocked 1pay BNPL Account And Blocked Xpay BNPL Account And RepaymentOption Is Xpay And Channel Is UPG
    Given The User Has 1pay And 4pay Accounts
    And The Channel Is Set To UPG
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To Xpay
    And The Amount Is Set To Greater Than Credit Balance
    And Block credit account    credit_id=${credit_ids}[0]
    And Block credit account    credit_id=${credit_ids}[1]
    When The Manifest API Is Called
    Then The Response Should Contain Xpay BNPL Account And State Is Inactive
    And The Gateway Is Disabled

#############    👆 Blocked and RepaymentOption Is Xpay and Channel is UPG    #############

[TC-127] Manifest Response For User With Blocked 1pay BNPL Account And Expired Xpay BNPL Account And RepaymentOption Is Xpay And Channel Is UPG
    Given The User Has 1pay And 4pay Accounts
    And The Channel Is Set To UPG
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To Xpay
    And The Amount Is Set To Greater Than Credit Balance
    And Empty Balance    credit_id=${credit_ids}[1]
    And Expire Account    credit_id=${credit_ids}[1]
    And Block credit account    credit_id=${credit_ids}[0]
    When The Manifest API Is Called
    Then The Response Should Contain Xpay BNPL Account And State Is Inactive
    And The Gateway Is Disabled

#############    👇 happy path RepaymentOption Is Xpay and Channel is QR    #############

[TC-128] Manifest Response For User With 1pay BNPL Account RepaymentOption Is Xpay And Channel Is QR And Amount Is Equal To Credit Balance
    Given The User Has 1pay Account
    And The Channel Is Set To QR
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To Xpay
    And The Amount Is Set To Equal To Credit Balance
    When The Manifest API Is Called
    Then The Response Should Contain State Is Disable
    And The Gateway Is Disabled

[TC-129] Manifest Response For User With Xpay BNPL Account RepaymentOption Is Xpay And Channel Is QR And Amount Is Equal To Credit Balance
    Given The User Has 4pay Account
    And The Channel Is Set To QR
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To Xpay
    And The Amount Is Set To Equal To Credit Balance
    When The Manifest API Is Called
    Then The Response Should Contain Xpay BNPL Account And State Is Active
    And The Gateway Is Disabled

[TC-130] Manifest Response For User With 1pay And Xpay BNPL Account And RepaymentOption Is Xpay And Channel Is QR And Amount Is Equal To Credit Balance
    Given The User Has 1pay And 4pay Accounts
    And The Channel Is Set To QR
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To Xpay
    And The Amount Is Set To Equal To Credit Balance
    When The Manifest API Is Called
    Then The Response Should Contain Xpay BNPL Account And State Is Active
    And The Gateway Is Disabled

[TC-131] Manifest Response For User With 1pay BNPL Account RepaymentOption Is Xpay And Channel Is QR And Amount Is Little Than Credit Balance
    Given The User Has 1pay Account
    And The Channel Is Set To QR
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To Xpay
    And The Amount Is Set To Little Than Credit Balance
    When The Manifest API Is Called
    Then The Response Should Contain State Is Disable
    And The Gateway Is Disabled

[TC-132] Manifest Response For User With Xpay BNPL Account RepaymentOption Is Xpay And Channel Is QR And Amount Is Little Than Credit Balance
    Given The User Has 4pay Account
    And The Channel Is Set To QR
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To Xpay
    And The Amount Is Set To Little Than Credit Balance
    When The Manifest API Is Called
    Then The Response Should Contain Xpay BNPL Account And State Is Active
    And The Gateway Is Disabled

[TC-133] Manifest Response For User With 1pay And Xpay BNPL Account And RepaymentOption Is Xpay And Channel Is QR And Amount Is Little Than Credit Balance
    Given The User Has 1pay And 4pay Accounts
    And The Channel Is Set To QR
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To Xpay
    And The Amount Is Set To Little Than Credit Balance
    When The Manifest API Is Called
    Then The Response Should Contain Xpay BNPL Account And State Is Active
    And The Gateway Is Disabled

[TC-134] Manifest Response For User With 1pay BNPL Account RepaymentOption Is Xpay And Channel Is QR And Amount Is Greater Than Credit Balance
    Given The User Has 1pay Account
    And The Channel Is Set To QR
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To Xpay
    And The Amount Is Set To Greater Than Credit Balance
    When The Manifest API Is Called
    Then The Response Should Contain State Is Disable
    And The Gateway Is Disabled

[TC-135] Manifest Response For User With Xpay BNPL Account RepaymentOption Is Xpay And Channel Is QR And Amount Is Greater Than Credit Balance
    Given The User Has 4pay Account
    And The Channel Is Set To QR
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To Xpay
    And The Amount Is Set To Greater Than Credit Balance
    When The Manifest API Is Called
    Then The Response Should Contain Xpay BNPL Account And State Is Active
    And The Gateway Is Disabled

[TC-136] Manifest Response For User With 1pay And Xpay BNPL Account And RepaymentOption Is Xpay And Channel Is QR And Amount Is Greater Than Credit Balance
    Given The User Has 1pay And 4pay Accounts
    And The Channel Is Set To QR
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To Xpay
    And The Amount Is Set To Greater Than Credit Balance
    When The Manifest API Is Called
    Then The Response Should Contain Xpay BNPL Account And State Is Active
    And The Gateway Is Disabled

#############    👆 happy path RepaymentOption Is Xpay and Channel is QR    #############

#############    👇 Zero Credit Balance and RepaymentOption Is Xpay and Channel is QR    #############

[TC-137] Manifest Response For User With 1pay BNPL Account (Zero Credit Balance) And RepaymentOption Is Xpay And Channel Is QR
    Given The User Has 1pay Account
    And The Channel Is Set To QR
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To Xpay
    And The Amount Is Set To Greater Than Credit Balance
    And Empty Balance
    When The Manifest API Is Called
    Then The Response Should Contain State Is Disable
    And The Gateway Is Disabled

[TC-138] Manifest Response For User With Xpay BNPL Account (Zero Credit Balance) And RepaymentOption Is Xpay And Channel Is QR
    Given The User Has 4pay Account
    And The Channel Is Set To QR
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To Xpay
    And The Amount Is Set To Greater Than Credit Balance
    And Empty Balance
    When The Manifest API Is Called
    Then The Response Should Contain Xpay BNPL Account (Zero Credit Balance) And State Is Active
    And The Gateway Is Disabled

[TC-139] Manifest Response For User With 1pay BNPL Account And Xpay BNPL Account (Zero Credit Balance) And RepaymentOption Is Xpay And Channel Is QR
    Given The User Has 1pay And 4pay Accounts
    And The Channel Is Set To QR
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To Xpay
    And The Amount Is Set To Greater Than Credit Balance
    And Empty Balance    credit_id=${credit_ids}[1]
    When The Manifest API Is Called
    Then The Response Should Contain Xpay BNPL Account (Zero Credit Balance) And State Is Active
    And The Gateway Is Disabled

[TC-140] Manifest Response For User With 1pay BNPL Account (Zero Credit Balance) And Xpay BNPL Account And RepaymentOption Is Xpay And Channel Is QR
    Given The User Has 1pay And 4pay Accounts
    And The Channel Is Set To QR
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To Xpay
    And The Amount Is Set To Greater Than Credit Balance
    And Empty Balance    credit_id=${credit_ids}[0]
    When The Manifest API Is Called
    Then The Response Should Contain Xpay BNPL Account And State Is Active
    And The Gateway Is Disabled

[TC-141] Manifest Response For User With 1pay BNPL Account (Zero Credit Balance) And Xpay BNPL Account (Zero Credit Balance) And RepaymentOption Is Xpay And Channel Is QR
    Given The User Has 1pay And 4pay Accounts
    And The Channel Is Set To QR
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To Xpay
    And The Amount Is Set To Greater Than Credit Balance
    And Empty Balance    credit_id=${credit_ids}[0]
    And Empty Balance    credit_id=${credit_ids}[1]
    When The Manifest API Is Called
    Then The Response Should Contain Xpay BNPL Account (Zero Credit Balance) And State Is Active
    And The Gateway Is Disabled

#############    👆 Zero Credit Balance and RepaymentOption Is Xpay and Channel is QR    #############

#############    👇 Expired and RepaymentOption Is Xpay and Channel is QR    #############

[TC-142] Manifest Response For User With 1pay BNPL Account (Expired) And RepaymentOption Is Xpay And Channel Is QR
    Given The User Has 1pay Account
    And The Channel Is Set To QR
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To Xpay
    And The Amount Is Set To Greater Than Credit Balance
    And Empty Balance
    And Expire Account    credit_id=${credit_ids}[0]
    When The Manifest API Is Called
    Then The Response Should Contain State Is Disable
    And The Gateway Is Disabled

[TC-143] Manifest Response For User With Xpay BNPL Account (Expired) And RepaymentOption Is Xpay And Channel Is QR
    Given The User Has 4pay Account
    And The Channel Is Set To QR
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To Xpay
    And The Amount Is Set To Greater Than Credit Balance
    And Empty Balance
    And Expire Account    credit_id=${credit_ids}[0]
    When The Manifest API Is Called
    Then The Response Should Contain Xpay BNPL Account And State Is Inactive
    And The Gateway Is Disabled

[TC-144] Manifest Response For User With 1pay BNPL Account And Xpay BNPL Account (Expired) And RepaymentOption Is Xpay And Channel Is QR
    Given The User Has 1pay And 4pay Accounts
    And The Channel Is Set To QR
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To Xpay
    And The Amount Is Set To Greater Than Credit Balance
    And Empty Balance    credit_id=${credit_ids}[1]
    And Expire Account    credit_id=${credit_ids}[1]
    When The Manifest API Is Called
    Then The Response Should Contain Xpay BNPL Account And State Is Inactive
    And The Gateway Is Disabled

[TC-145] Manifest Response For User With 1pay BNPL Account (Expired) And Xpay BNPL Account And RepaymentOption Is Xpay And Channel Is QR
    Given The User Has 1pay And 4pay Accounts
    And The Channel Is Set To QR
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To Xpay
    And The Amount Is Set To Greater Than Credit Balance
    And Empty Balance    credit_id=${credit_ids}[0]
    And Expire Account    credit_id=${credit_ids}[0]
    When The Manifest API Is Called
    Then The Response Should Contain Xpay BNPL Account And State Is Active
    And The Gateway Is Disabled

[TC-146] Manifest Response For User With 1pay BNPL Account (Expired) And Xpay BNPL Account (Expired) And RepaymentOption Is Xpay And Channel Is QR
    Given The User Has 1pay And 4pay Accounts
    And The Channel Is Set To QR
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To Xpay
    And The Amount Is Set To Greater Than Credit Balance
    And Empty Balance    credit_id=${credit_ids}[0]
    And Empty Balance    credit_id=${credit_ids}[1]
    And Expire Account    credit_id=${credit_ids}[0]
    And Expire Account    credit_id=${credit_ids}[1]
    When The Manifest API Is Called
    Then The Response Should Contain Xpay BNPL Account And State Is Inactive
    And The Gateway Is Disabled

#############    👆 Expired and RepaymentOption Is Xpay and Channel is QR    #############

#############    👇 Blocked and RepaymentOption Is Xpay and Channel is QR    #############

[TC-147] Manifest Response For User With Blocked 1pay BNPL Account And RepaymentOption Is Xpay And Channel Is QR
    Given The User Has 1pay Account
    And The Channel Is Set To QR
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To Xpay
    And The Amount Is Set To Greater Than Credit Balance
    And Block credit account
    When The Manifest API Is Called
    Then The Response Should Contain State Is Disable
    And The Gateway Is Disabled

[TC-148] Manifest Response For User With Blocked Xpay BNPL Account And RepaymentOption Is Xpay And Channel Is QR
    Given The User Has 4pay Account
    And The Channel Is Set To QR
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To Xpay
    And The Amount Is Set To Greater Than Credit Balance
    And Block credit account
    When The Manifest API Is Called
    Then The Response Should Contain Xpay BNPL Account And State Is Inactive
    And The Gateway Is Disabled

[TC-149] Manifest Response For User With 1pay BNPL Account And Blocked Xpay BNPL Account And RepaymentOption Is Xpay And Channel Is QR
    Given The User Has 1pay And 4pay Accounts
    And The Channel Is Set To QR
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To Xpay
    And The Amount Is Set To Greater Than Credit Balance
    And Block credit account    credit_id=${credit_ids}[1]
    When The Manifest API Is Called
    Then The Response Should Contain Xpay BNPL Account And State Is Inactive
    And The Gateway Is Disabled

[TC-150] Manifest Response For User With Blocked 1pay BNPL Account And Xpay BNPL Account And RepaymentOption Is Xpay And Channel Is QR
    Given The User Has 1pay And 4pay Accounts
    And The Channel Is Set To QR
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To Xpay
    And The Amount Is Set To Greater Than Credit Balance
    And Block credit account    credit_id=${credit_ids}[0]
    When The Manifest API Is Called
    Then The Response Should Contain Xpay BNPL Account And State Is Active
    And The Gateway Is Disabled

[TC-151] Manifest Response For User With Blocked 1pay BNPL Account And Blocked Xpay BNPL Account And RepaymentOption Is Xpay And Channel Is QR
    Given The User Has 1pay And 4pay Accounts
    And The Channel Is Set To QR
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To Xpay
    And The Amount Is Set To Greater Than Credit Balance
    And Block credit account    credit_id=${credit_ids}[0]
    And Block credit account    credit_id=${credit_ids}[1]
    When The Manifest API Is Called
    Then The Response Should Contain Xpay BNPL Account And State Is Inactive
    And The Gateway Is Disabled

#############    👆 Blocked and RepaymentOption Is Xpay and Channel is QR    #############

[TC-152] Manifest Response For User With Blocked 1pay BNPL Account And Expired Xpay BNPL Account And RepaymentOption Is Xpay And Channel Is QR
    Given The User Has 1pay And 4pay Accounts
    And The Channel Is Set To QR
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To Xpay
    And The Amount Is Set To Greater Than Credit Balance
    And Empty Balance    credit_id=${credit_ids}[1]
    And Expire Account    credit_id=${credit_ids}[1]
    And Block credit account    credit_id=${credit_ids}[0]
    When The Manifest API Is Called
    Then The Response Should Contain Xpay BNPL Account And State Is Inactive
    And The Gateway Is Disabled

#############    BNPL    #############

#############    C-Credit    #############

#############    👇 RepaymentOption Is 1pay and Xpay and Channel is UPG    #############

[TC-153] Manifest Response For User With Credit Account RepaymentOption Is 1pay And Xpay And Channel Is UPG And Amount Is Equal To Credit Balance
    Given The User Has Credit Account
    And The Channel Is Set To UPG
    And The Ticket Type Is Set To Credit
    And The Payment Gateway Is Set To CPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And The Amount Is Set To Equal To Credit Balance
    When The Manifest API Is Called
    Then The Response Should Contain Credit Account And State Is Active
    And The Gateway Is Disabled

[TC-154] Manifest Response For User With Credit Account RepaymentOption Is 1pay And Xpay And Channel Is UPG And Amount Is Little Than Credit Balance
    Given The User Has Credit Account
    And The Channel Is Set To UPG
    And The Ticket Type Is Set To Credit
    And The Payment Gateway Is Set To CPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And The Amount Is Set To Little Than Credit Balance
    When The Manifest API Is Called
    Then The Response Should Contain Credit Account And State Is Active
    And The Gateway Is Disabled

[TC-155] Manifest Response For User With Credit Account RepaymentOption Is 1pay And Xpay And Channel Is UPG And Amount Is Greater Than Credit Balance
    Given The User Has Credit Account
    And The Channel Is Set To UPG
    And The Ticket Type Is Set To Credit
    And The Payment Gateway Is Set To CPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And The Amount Is Set To Greater Than Credit Balance
    When The Manifest API Is Called
    Then The Response Should Contain Credit Account And State Is Active
    And The Gateway Is Disabled

[TC-156] Manifest Response For User With Block Credit Account RepaymentOption Is 1pay And Xpay And Channel Is UPG And Amount Is Greater Than Credit Balance
    Given The User Has Credit Account
    And The Channel Is Set To UPG
    And The Ticket Type Is Set To Credit
    And The Payment Gateway Is Set To CPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And The Amount Is Set To Greater Than Credit Balance
    And Block credit account
    When The Manifest API Is Called
    Then The Response Should Contain Credit Account And State Is Inactive
    And The Gateway Is Disabled

[TC-157] Manifest Response For User With Expire Credit Account And RepaymentOption Is 1pay And Xpay And Channel Is UPG And Amount Is Greater Than Credit Balance
    Given The User Has Credit Account
    And The Channel Is Set To UPG
    And The Ticket Type Is Set To Credit
    And The Payment Gateway Is Set To CPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And The Amount Is Set To Greater Than Credit Balance
    And Empty Balance
    And Expire Account
    When The Manifest API Is Called
    Then The Response Should Contain No Credit Account And State Is Disable For Payment Gateway CPG
    And The Gateway Is Disabled

#############    👆 RepaymentOption Is 1pay and Xpay and Channel is UPG    #############

#############    👇 RepaymentOption Is 1pay and Xpay and Channel is QR    #############

[TC-158] Manifest Response For User With Credit Account RepaymentOption Is 1pay And Xpay And Channel Is QR And Amount Is Equal To Credit Balance
    Given The User Has Credit Account
    And The Channel Is Set To QR
    And The Ticket Type Is Set To Credit
    And The Payment Gateway Is Set To CPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And The Amount Is Set To Equal To Credit Balance
    When The Manifest API Is Called
    Then The Response Should Contain Credit Account And State Is Active
    And The Gateway Is Disabled

[TC-159] Manifest Response For User With Credit Account RepaymentOption Is 1pay And Xpay And Channel Is QR And Amount Is Little Than Credit Balance
    Given The User Has Credit Account
    And The Channel Is Set To QR
    And The Ticket Type Is Set To Credit
    And The Payment Gateway Is Set To CPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And The Amount Is Set To Little Than Credit Balance
    When The Manifest API Is Called
    Then The Response Should Contain Credit Account And State Is Active
    And The Gateway Is Disabled

[TC-160] Manifest Response For User With Credit Account RepaymentOption Is 1pay And Xpay And Channel Is QR And Amount Is Greater Than Credit Balance
    Given The User Has Credit Account
    And The Channel Is Set To QR
    And The Ticket Type Is Set To Credit
    And The Payment Gateway Is Set To CPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And The Amount Is Set To Greater Than Credit Balance
    When The Manifest API Is Called
    Then The Response Should Contain Credit Account And State Is Active
    And The Gateway Is Disabled

[TC-161] Manifest Response For User With Block Credit Account RepaymentOption Is 1pay And Xpay And Channel Is QR And Amount Is Greater Than Credit Balance
    Given The User Has Credit Account
    And The Channel Is Set To QR
    And The Ticket Type Is Set To Credit
    And The Payment Gateway Is Set To CPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And The Amount Is Set To Greater Than Credit Balance
    And Block credit account
    When The Manifest API Is Called
    Then The Response Should Contain Credit Account And State Is Inactive
    And The Gateway Is Disabled

[TC-162] Manifest Response For User With Expire Credit Account And RepaymentOption Is 1pay And Xpay And Channel Is QR And Amount Is Greater Than Credit Balance
    Given The User Has Credit Account
    And The Channel Is Set To QR
    And The Ticket Type Is Set To Credit
    And The Payment Gateway Is Set To CPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And The Amount Is Set To Greater Than Credit Balance
    And Empty Balance
    And Expire Account
    When The Manifest API Is Called
    Then The Response Should Contain No Credit Account And State Is Disable For Payment Gateway CPG
    And The Gateway Is Disabled

#############    👆 RepaymentOption Is 1pay and Xpay and Channel is QR    #############

#############    👇 RepaymentOption Is Xpay and Channel is UPG    #############

[TC-163] Manifest Response For User With Credit Account RepaymentOption Is Xpay And Channel Is UPG And Amount Is Equal To Credit Balance
    Given The User Has Credit Account
    And The Channel Is Set To UPG
    And The Ticket Type Is Set To Credit
    And The Payment Gateway Is Set To CPG
    And The Gateway RepaymentOption Is Set To Xpay
    And The Amount Is Set To Equal To Credit Balance
    When The Manifest API Is Called
    Then The Response Should Contain Credit Account And State Is Active
    And The Gateway Is Disabled

[TC-164] Manifest Response For User With Credit Account RepaymentOption Is Xpay And Channel Is UPG And Amount Is Little Than Credit Balance
    Given The User Has Credit Account
    And The Channel Is Set To UPG
    And The Ticket Type Is Set To Credit
    And The Payment Gateway Is Set To CPG
    And The Gateway RepaymentOption Is Set To Xpay
    And The Amount Is Set To Little Than Credit Balance
    When The Manifest API Is Called
    Then The Response Should Contain Credit Account And State Is Active
    And The Gateway Is Disabled

[TC-165] Manifest Response For User With Credit Account RepaymentOption Is Xpay And Channel Is UPG And Amount Is Greater Than Credit Balance
    Given The User Has Credit Account
    And The Channel Is Set To UPG
    And The Ticket Type Is Set To Credit
    And The Payment Gateway Is Set To CPG
    And The Gateway RepaymentOption Is Set To Xpay
    And The Amount Is Set To Greater Than Credit Balance
    When The Manifest API Is Called
    Then The Response Should Contain Credit Account And State Is Active
    And The Gateway Is Disabled

[TC-166] Manifest Response For User With Block Credit Account RepaymentOption Is Xpay And Channel Is UPG And Amount Is Greater Than Credit Balance
    Given The User Has Credit Account
    And The Channel Is Set To UPG
    And The Ticket Type Is Set To Credit
    And The Payment Gateway Is Set To CPG
    And The Gateway RepaymentOption Is Set To Xpay
    And The Amount Is Set To Greater Than Credit Balance
    And Block credit account
    When The Manifest API Is Called
    Then The Response Should Contain Credit Account And State Is Inactive
    And The Gateway Is Disabled

[TC-167] Manifest Response For User With Expire Credit Account And RepaymentOption Is Xpay And Channel Is UPG And Amount Is Greater Than Credit Balance
    Given The User Has Credit Account
    And The Channel Is Set To UPG
    And The Ticket Type Is Set To Credit
    And The Payment Gateway Is Set To CPG
    And The Gateway RepaymentOption Is Set To Xpay
    And The Amount Is Set To Greater Than Credit Balance
    And Empty Balance
    And Expire Account
    When The Manifest API Is Called
    Then The Response Should Contain No Credit Account And State Is Disable For Payment Gateway CPG
    And The Gateway Is Disabled

#############    👆 RepaymentOption Is Xpay and Channel is UPG    #############

#############    👇 RepaymentOption Is Xpay and Channel is QR    #############

[TC-168] Manifest Response For User With Credit Account RepaymentOption Is Xpay And Channel Is QR And Amount Is Equal To Credit Balance
    Given The User Has Credit Account
    And The Channel Is Set To QR
    And The Ticket Type Is Set To Credit
    And The Payment Gateway Is Set To CPG
    And The Gateway RepaymentOption Is Set To Xpay
    And The Amount Is Set To Equal To Credit Balance
    When The Manifest API Is Called
    Then The Response Should Contain Credit Account And State Is Active
    And The Gateway Is Disabled

[TC-169] Manifest Response For User With Credit Account RepaymentOption Is Xpay And Channel Is QR And Amount Is Little Than Credit Balance
    Given The User Has Credit Account
    And The Channel Is Set To QR
    And The Ticket Type Is Set To Credit
    And The Payment Gateway Is Set To CPG
    And The Gateway RepaymentOption Is Set To Xpay
    And The Amount Is Set To Little Than Credit Balance
    When The Manifest API Is Called
    Then The Response Should Contain Credit Account And State Is Active
    And The Gateway Is Disabled

[TC-170] Manifest Response For User With Credit Account RepaymentOption Is Xpay And Channel Is QR And Amount Is Greater Than Credit Balance
    Given The User Has Credit Account
    And The Channel Is Set To QR
    And The Ticket Type Is Set To Credit
    And The Payment Gateway Is Set To CPG
    And The Gateway RepaymentOption Is Set To Xpay
    And The Amount Is Set To Greater Than Credit Balance
    When The Manifest API Is Called
    Then The Response Should Contain Credit Account And State Is Active
    And The Gateway Is Disabled

[TC-171] Manifest Response For User With Block Credit Account RepaymentOption Is Xpay And Channel Is QR And Amount Is Greater Than Credit Balance
    Given The User Has Credit Account
    And The Channel Is Set To QR
    And The Ticket Type Is Set To Credit
    And The Payment Gateway Is Set To CPG
    And The Gateway RepaymentOption Is Set To Xpay
    And The Amount Is Set To Greater Than Credit Balance
    And Block credit account
    When The Manifest API Is Called
    Then The Response Should Contain Credit Account And State Is Inactive
    And The Gateway Is Disabled

[TC-172] Manifest Response For User With Expire Credit Account And RepaymentOption Is Xpay And Channel Is QR And Amount Is Greater Than Credit Balance
    Given The User Has Credit Account
    And The Channel Is Set To QR
    And The Ticket Type Is Set To Credit
    And The Payment Gateway Is Set To CPG
    And The Gateway RepaymentOption Is Set To Xpay
    And The Amount Is Set To Greater Than Credit Balance
    And Empty Balance
    And Expire Account
    When The Manifest API Is Called
    Then The Response Should Contain No Credit Account And State Is Disable For Payment Gateway CPG
    And The Gateway Is Disabled

#############    👆 RepaymentOption Is Xpay and Channel is QR    #############

[TC-173] Manifest Response For User With Credit Account RepaymentOption Is 1pay And Channel Is UPG And Amount Is Equal To Credit Balance
    Given The User Has Credit Account
    And The Channel Is Set To UPG
    And The Ticket Type Is Set To Credit
    And The Payment Gateway Is Set To CPG
    And The Gateway RepaymentOption Is Set To 1pay
    And The Amount Is Set To Equal To Credit Balance
    When The Manifest API Is Called
    Then The Response Should Contain Credit Account And State Is Inactive
    And The Gateway Is Disabled

[TC-174] Manifest Response When Gateway Is Disabled And The Payment Gateway Is Set To CPG And Channel Is UPG
    Given The User Has Credit Account
    And The Channel Is Set To UPG
    And The Ticket Type Is Set To Credit
    And The Payment Gateway Is Set To CPG
    And The Gateway Is Disabled
    And The Amount Is Set To Little Than Credit Balance
    When The Manifest API Is Called
    Then The Response Should Contain No Credit Account And State Is Disable

[TC-175] Manifest Response When Gateway Is Disabled And The Payment Gateway Is Set To CPG And Channel Is QR
    Given The User Has Credit Account
    And The Channel Is Set To QR
    And The Ticket Type Is Set To Credit
    And The Payment Gateway Is Set To CPG
    And The Gateway Is Disabled
    And The Amount Is Set To Little Than Credit Balance
    When The Manifest API Is Called
    Then The Response Should Contain No Credit Account And State Is Disable

#############    C-Credit    #############

#############    Installment Sale    #############

#############    👇 RepaymentOption Is Xpay and Channel is QR    #############

[TC-176] Manifest Response For User With Installment Sale Account RepaymentOption Is Xpay And Channel Is QR And Amount Is Equal To Credit Balance
    Given The User Has Installment Sale Account
    And The Channel Is Set To QR
    And The Ticket Type Is Set To Installment Sale
    And The Payment Gateway Is Set To ISPG
    And The Gateway RepaymentOption Is Set To Xpay
    And The Amount Is Set To Equal To Credit Balance
    When The Manifest API Is Called
    Then The Response Should Contain Installment Sale Account And State Is Active
    And The Gateway Is Disabled

[TC-177] Manifest Response For User With Installment Sale Account RepaymentOption Is Xpay And Channel Is QR And Amount Is Little Than Credit Balance
    Given The User Has Installment Sale Account
    And The Channel Is Set To QR
    And The Ticket Type Is Set To Installment Sale
    And The Payment Gateway Is Set To ISPG
    And The Gateway RepaymentOption Is Set To Xpay
    And The Amount Is Set To Little Than Credit Balance
    When The Manifest API Is Called
    Then The Response Should Contain Installment Sale Account And State Is Inactive And Credit Amount Is Zero
    And The Gateway Is Disabled

[TC-178] Manifest Response For User With Installment Sale Account RepaymentOption Is Xpay And Channel Is QR And Amount Is Greater Than Credit Balance
    Given The User Has Installment Sale Account
    And The Channel Is Set To QR
    And The Ticket Type Is Set To Installment Sale
    And The Payment Gateway Is Set To ISPG
    And The Gateway RepaymentOption Is Set To Xpay
    And The Amount Is Set To Greater Than Credit Balance
    When The Manifest API Is Called
    Then The Response Should Contain Installment Sale Account And State Is Active
    And The Gateway Is Disabled

[TC-179] Manifest Response For User With Block Installment Sale Account RepaymentOption Is Xpay And Channel Is QR And Amount Is Greater Than Credit Balance
    Given The User Has Installment Sale Account
    And The Channel Is Set To QR
    And The Ticket Type Is Set To Installment Sale
    And The Payment Gateway Is Set To ISPG
    And The Gateway RepaymentOption Is Set To Xpay
    And The Amount Is Set To Greater Than Credit Balance
    And Block credit account
    When The Manifest API Is Called
    Then The Response Should Contain Installment Sale Account And State Is Inactive
    And The Gateway Is Disabled

[TC-180] Manifest Response For User With Expire Installment Sale Account And RepaymentOption Is Xpay And Channel Is QR And Amount Is Greater Than Credit Balance
    Given The User Has Installment Sale Account
    And The Channel Is Set To QR
    And The Ticket Type Is Set To Installment Sale
    And The Payment Gateway Is Set To ISPG
    And The Gateway RepaymentOption Is Set To Xpay
    And The Amount Is Set To Greater Than Credit Balance
    And Empty Balance
    And Expire Account
    When The Manifest API Is Called
    Then The Response Should Contain Installment Sale Account And State Is Inactive
    And The Gateway Is Disabled

#############    👆 RepaymentOption Is Xpay and Channel is QR    #############

#############    👇 RepaymentOption Is Xpay and Channel is UPG    #############

[TC-181] Manifest Response For User With Installment Sale Account RepaymentOption Is Xpay And Channel Is UPG And Amount Is Equal To Credit Balance
    Given The User Has Installment Sale Account
    And The Channel Is Set To UPG
    And The Ticket Type Is Set To Installment Sale
    And The Payment Gateway Is Set To ISPG
    And The Gateway RepaymentOption Is Set To Xpay
    And The Amount Is Set To Equal To Credit Balance
    When The Manifest API Is Called
    Then The Response Should Contain Installment Sale Account And State Is Active
    And The Gateway Is Disabled

[TC-182] Manifest Response For User With Installment Sale Account RepaymentOption Is Xpay And Channel Is UPG And Amount Is Little Than Credit Balance
    Given The User Has Installment Sale Account
    And The Channel Is Set To UPG
    And The Ticket Type Is Set To Installment Sale
    And The Payment Gateway Is Set To ISPG
    And The Gateway RepaymentOption Is Set To Xpay
    And The Amount Is Set To Little Than Credit Balance
    When The Manifest API Is Called
    Then The Response Should Contain Installment Sale Account And State Is Inactive And Credit Amount Is Zero
    And The Gateway Is Disabled

[TC-183] Manifest Response For User With Installment Sale Account RepaymentOption Is Xpay And Channel Is UPG And Amount Is Greater Than Credit Balance
    Given The User Has Installment Sale Account
    And The Channel Is Set To UPG
    And The Ticket Type Is Set To Installment Sale
    And The Payment Gateway Is Set To ISPG
    And The Gateway RepaymentOption Is Set To Xpay
    And The Amount Is Set To Greater Than Credit Balance
    When The Manifest API Is Called
    Then The Response Should Contain Installment Sale Account And State Is Active
    And The Gateway Is Disabled

[TC-184] Manifest Response For User With Block Installment Sale Account RepaymentOption Is Xpay And Channel Is UPG And Amount Is Greater Than Credit Balance
    Given The User Has Installment Sale Account
    And The Channel Is Set To UPG
    And The Ticket Type Is Set To Installment Sale
    And The Payment Gateway Is Set To ISPG
    And The Gateway RepaymentOption Is Set To Xpay
    And The Amount Is Set To Greater Than Credit Balance
    And Block credit account
    When The Manifest API Is Called
    Then The Response Should Contain Installment Sale Account And State Is Inactive
    And The Gateway Is Disabled

[TC-185] Manifest Response For User With Expire Installment Sale Account And RepaymentOption Is Xpay And Channel Is UPG And Amount Is Greater Than Credit Balance
    Given The User Has Installment Sale Account
    And The Channel Is Set To UPG
    And The Ticket Type Is Set To Installment Sale
    And The Payment Gateway Is Set To ISPG
    And The Gateway RepaymentOption Is Set To Xpay
    And The Amount Is Set To Greater Than Credit Balance
    And Empty Balance
    And Expire Account
    When The Manifest API Is Called
    Then The Response Should Contain Installment Sale Account And State Is Inactive
    And The Gateway Is Disabled

#############    👆 RepaymentOption Is Xpay and Channel is UPG    #############
#############    👇 RepaymentOption Is 1pay And Xpay and Channel is QR    #############

[TC-186] Manifest Response For User With Installment Sale Account RepaymentOption Is 1pay And Xpay And Channel Is QR And Amount Is Equal To Credit Balance
    Given The User Has Installment Sale Account
    And The Channel Is Set To QR
    And The Ticket Type Is Set To Installment Sale
    And The Payment Gateway Is Set To ISPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And The Amount Is Set To Equal To Credit Balance
    When The Manifest API Is Called
    Then The Response Should Contain Installment Sale Account And State Is Active
    And The Gateway Is Disabled

[TC-187] Manifest Response For User With Installment Sale Account RepaymentOption Is 1pay And Xpay And Channel Is QR And Amount Is Little Than Credit Balance
    Given The User Has Installment Sale Account
    And The Channel Is Set To QR
    And The Ticket Type Is Set To Installment Sale
    And The Payment Gateway Is Set To ISPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And The Amount Is Set To Little Than Credit Balance
    When The Manifest API Is Called
    Then The Response Should Contain Installment Sale Account And State Is Inactive And Credit Amount Is Zero
    And The Gateway Is Disabled

[TC-188] Manifest Response For User With Installment Sale Account RepaymentOption Is 1pay And Xpay And Channel Is QR And Amount Is Greater Than Credit Balance
    Given The User Has Installment Sale Account
    And The Channel Is Set To QR
    And The Ticket Type Is Set To Installment Sale
    And The Payment Gateway Is Set To ISPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And The Amount Is Set To Greater Than Credit Balance
    When The Manifest API Is Called
    Then The Response Should Contain Installment Sale Account And State Is Active
    And The Gateway Is Disabled

[TC-189] Manifest Response For User With Block Installment Sale Account RepaymentOption Is 1pay And Xpay And Channel Is QR And Amount Is Greater Than Credit Balance
    Given The User Has Installment Sale Account
    And The Channel Is Set To QR
    And The Ticket Type Is Set To Installment Sale
    And The Payment Gateway Is Set To ISPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And The Amount Is Set To Greater Than Credit Balance
    And Block credit account
    When The Manifest API Is Called
    Then The Response Should Contain Installment Sale Account And State Is Inactive
    And The Gateway Is Disabled

[TC-190] Manifest Response For User With Expire Installment Sale Account And RepaymentOption Is 1pay And Xpay And Channel Is QR And Amount Is Greater Than Credit Balance
    Given The User Has Installment Sale Account
    And The Channel Is Set To QR
    And The Ticket Type Is Set To Installment Sale
    And The Payment Gateway Is Set To ISPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And The Amount Is Set To Greater Than Credit Balance
    And Empty Balance
    And Expire Account
    When The Manifest API Is Called
    Then The Response Should Contain Installment Sale Account And State Is Inactive
    And The Gateway Is Disabled

#############    👆 RepaymentOption Is 1pay And Xpay and Channel is QR    #############

#############    👇 RepaymentOption Is 1pay And Xpay and Channel is UPG    #############

[TC-191] Manifest Response For User With Installment Sale Account RepaymentOption Is 1pay And Xpay And Channel Is UPG And Amount Is Equal To Credit Balance
    Given The User Has Installment Sale Account
    And The Channel Is Set To UPG
    And The Ticket Type Is Set To Installment Sale
    And The Payment Gateway Is Set To ISPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And The Amount Is Set To Equal To Credit Balance
    When The Manifest API Is Called
    Then The Response Should Contain Installment Sale Account And State Is Active
    And The Gateway Is Disabled

[TC-192] Manifest Response For User With Installment Sale Account RepaymentOption Is 1pay And Xpay And Channel Is UPG And Amount Is Little Than Credit Balance
    Given The User Has Installment Sale Account
    And The Channel Is Set To UPG
    And The Ticket Type Is Set To Installment Sale
    And The Payment Gateway Is Set To ISPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And The Amount Is Set To Little Than Credit Balance
    When The Manifest API Is Called
    Then The Response Should Contain Installment Sale Account And State Is Inactive And Credit Amount Is Zero
    And The Gateway Is Disabled

[TC-193] Manifest Response For User With Installment Sale Account RepaymentOption Is 1pay And Xpay And Channel Is UPG And Amount Is Greater Than Credit Balance
    Given The User Has Installment Sale Account
    And The Channel Is Set To UPG
    And The Ticket Type Is Set To Installment Sale
    And The Payment Gateway Is Set To ISPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And The Amount Is Set To Greater Than Credit Balance
    When The Manifest API Is Called
    Then The Response Should Contain Installment Sale Account And State Is Active
    And The Gateway Is Disabled

[TC-194] Manifest Response For User With Block Installment Sale Account RepaymentOption Is 1pay And Xpay And Channel Is UPG And Amount Is Greater Than Credit Balance
    Given The User Has Installment Sale Account
    And The Channel Is Set To UPG
    And The Ticket Type Is Set To Installment Sale
    And The Payment Gateway Is Set To ISPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And The Amount Is Set To Greater Than Credit Balance
    And Block credit account
    When The Manifest API Is Called
    Then The Response Should Contain Installment Sale Account And State Is Inactive
    And The Gateway Is Disabled

[TC-195] Manifest Response For User With Expire Installment Sale Account And RepaymentOption Is 1pay And Xpay And Channel Is UPG And Amount Is Greater Than Credit Balance
    Given The User Has Installment Sale Account
    And The Channel Is Set To UPG
    And The Ticket Type Is Set To Installment Sale
    And The Payment Gateway Is Set To ISPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And The Amount Is Set To Greater Than Credit Balance
    And Empty Balance
    And Expire Account
    When The Manifest API Is Called
    Then The Response Should Contain Installment Sale Account And State Is Inactive
    And The Gateway Is Disabled

#############    👆 RepaymentOption Is 1pay And Xpay and Channel is UPG    #############

[TC-196] Manifest Response For User With Installment Sale Account RepaymentOption Is 1pay And Channel Is UPG And Amount Is Greater Than Credit Balance
    Given The User Has Installment Sale Account
    And The Channel Is Set To UPG
    And The Ticket Type Is Set To Installment Sale
    And The Payment Gateway Is Set To ISPG
    And The Gateway RepaymentOption Is Set To 1pay
    And The Amount Is Set To Greater Than Credit Balance
    When The Manifest API Is Called
    Then The Response Should Contain No Installment Sale Account And State Is Disable
    And The Gateway Is Disabled

[TC-197] Manifest Response When Gateway Is Disabled For User With Installment Sale And Channel Is QR
    Given The User Has Installment Sale Account
    And The Channel Is Set To QR
    And The Ticket Type Is Set To Installment Sale
    And The Payment Gateway Is Set To ISPG
    And The Gateway Is Disabled
    And The Amount Is Set To Greater Than Credit Balance
    When The Manifest API Is Called
    Then The Response Should Contain No Credit Account And State Is Disable

[TC-198] Manifest Response When Gateway Is Disabled For User With Installment Sale And Channel Is UPG
    Given The User Has Installment Sale Account
    And The Channel Is Set To UPG
    And The Ticket Type Is Set To Installment Sale
    And The Payment Gateway Is Set To ISPG
    And The Gateway Is Disabled
    And The Amount Is Set To Greater Than Credit Balance
    When The Manifest API Is Called
    Then The Response Should Contain No Credit Account And State Is Disable

[TC-199] Manifest Response For User With Schedule Close 1pay BNPL Account And RepaymentOption Is 1pay And Xpay And Channel Is UPG
    Given The User Has 1pay Account
    And The Channel Is Set To UPG
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And The Amount Is Set To Greater Than Credit Balance
    And Call Schedule Close API
    When The Manifest API Is Called
    Then The Response Should Contain 1pay BNPL Account And State Is Inactive
    And The Gateway Is Disabled