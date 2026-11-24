*** Settings ***
Resource            steps/LMS/credit-core/credit-features-step.resource

Test Setup          Initialize Merchant
Test Teardown       Reproduce Amount


*** Test Cases ***
#############    BNPL    #############

#############    👇 happy path RepaymentOption Is 1pay And Xpay and Channel is UPG    #############
[TC-001] Features Response For User With 1pay BNPL Account RepaymentOption Is 1pay And Xpay And Channel Is UPG And Amount Is Equal To Credit Balance
    Given The User Has 1pay Account
    And The Channel Is Set To UPG
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And The Amount Is Set To Equal To Credit Balance
    When The Features API Is Called
    Then The Response Should Contain 1pay BNPL Account And Status Is Active
    And The Gateway Is Disabled

[TC-002] Features Response For User With Xpay BNPL Account RepaymentOption Is 1pay And Xpay And Channel Is UPG And Amount Is Equal To Credit Balance
    Given The User Has 4pay Account
    And The Channel Is Set To UPG
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And The Amount Is Set To Equal To Credit Balance
    When The Features API Is Called
    Then The Response Should Contain Xpay BNPL Account And Status Is Active
    And The Gateway Is Disabled

[TC-003] Features Response For User With 1pay And Xpay BNPL Account And RepaymentOption Is 1pay And Xpay And Channel Is UPG And Amount Is Equal To Credit Balance
    Given The User Has 1pay And 4pay Accounts
    And The Channel Is Set To UPG
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And The Amount Is Set To Equal To Credit Balance
    When The Features API Is Called
    Then The Response Should Contain Xpay BNPL Account And Status Is Active
    And The Gateway Is Disabled

[TC-004] Features Response For User With 1pay BNPL Account RepaymentOption Is 1pay And Xpay And Channel Is UPG And Amount Is Little Than Credit Balance
    Given The User Has 1pay Account
    And The Channel Is Set To UPG
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And The Amount Is Set To Little Than Credit Balance
    When The Features API Is Called
    Then The Response Should Contain 1pay BNPL Account And Status Is Active
    And The Gateway Is Disabled

[TC-005] Features Response For User With Xpay BNPL Account RepaymentOption Is 1pay And Xpay And Channel Is UPG And Amount Is Little Than Credit Balance
    Given The User Has 4pay Account
    And The Channel Is Set To UPG
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And The Amount Is Set To Little Than Credit Balance
    When The Features API Is Called
    Then The Response Should Contain Xpay BNPL Account And Status Is Active
    And The Gateway Is Disabled

[TC-006] Features Response For User With 1pay And Xpay BNPL Account And RepaymentOption Is 1pay And Xpay And Channel Is UPG And Amount Is Little Than Credit Balance
    Given The User Has 1pay And 4pay Accounts
    And The Channel Is Set To UPG
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And The Amount Is Set To Little Than Credit Balance
    When The Features API Is Called
    Then The Response Should Contain Xpay BNPL Account And Status Is Active
    And The Gateway Is Disabled

[TC-007] Features Response For User With 1pay BNPL Account RepaymentOption Is 1pay And Xpay And Channel Is UPG And Amount Is Greater Than Credit Balance
    Given The User Has 1pay Account
    And The Channel Is Set To UPG
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And The Amount Is Set To Greater Than Credit Balance
    When The Features API Is Called
    Then The Response Should Contain 1pay BNPL Account And Status Is Active
    And The Gateway Is Disabled

[TC-008] Features Response For User With Xpay BNPL Account RepaymentOption Is 1pay And Xpay And Channel Is UPG And Amount Is Greater Than Credit Balance
    Given The User Has 4pay Account
    And The Channel Is Set To UPG
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And The Amount Is Set To Greater Than Credit Balance
    When The Features API Is Called
    Then The Response Should Contain Xpay BNPL Account And Status Is Active
    And The Gateway Is Disabled

[TC-009] Features Response For User With 1pay And Xpay BNPL Account And RepaymentOption Is 1pay And Xpay And Channel Is UPG And Amount Is Greater Than Credit Balance
    Given The User Has 1pay And 4pay Accounts
    And The Channel Is Set To UPG
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And The Amount Is Set To Greater Than Credit Balance
    When The Features API Is Called
    Then The Response Should Contain Xpay BNPL Account And Status Is Active
    And The Gateway Is Disabled

#############    👆 happy path RepaymentOption Is 1pay And Xpay and Channel is UPG    #############

#############    👇 Zero Credit Balance and RepaymentOption Is 1pay And Xpay and Channel is UPG    #############

[TC-010] Features Response For User With 1pay BNPL Account (Zero Credit Balance) And RepaymentOption Is 1pay And Xpay And Channel Is UPG
    Given The User Has 1pay Account
    And The Channel Is Set To UPG
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And The Amount Is Set To Greater Than Credit Balance
    And Empty Balance
    When The Features API Is Called
    Then The Response Should Contain 1pay BNPL Account (Zero Credit Balance) And Status Is Active
    And The Gateway Is Disabled

[TC-011] Features Response For User With Xpay BNPL Account (Zero Credit Balance) And RepaymentOption Is 1pay And Xpay And Channel Is UPG
    Given The User Has 4pay Account
    And The Channel Is Set To UPG
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And The Amount Is Set To Greater Than Credit Balance
    And Empty Balance
    When The Features API Is Called
    Then The Response Should Contain Xpay BNPL Account (Zero Credit Balance) And Status Is Active
    And The Gateway Is Disabled

[TC-012] Features Response For User With 1pay BNPL Account And Xpay BNPL Account (Zero Credit Balance) And RepaymentOption Is 1pay And Xpay And Channel Is UPG
    Given The User Has 1pay And 4pay Accounts
    And The Channel Is Set To UPG
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And The Amount Is Set To Greater Than Credit Balance
    And Empty Balance    credit_id=${credit_ids}[1]
    When The Features API Is Called
    Then The Response Should Contain 1pay BNPL Account And Status Is Active
    And The Gateway Is Disabled

[TC-013] Features Response For User With 1pay BNPL Account (Zero Credit Balance) And Xpay BNPL Account And RepaymentOption Is 1pay And Xpay And Channel Is UPG
    Given The User Has 1pay And 4pay Accounts
    And The Channel Is Set To UPG
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And The Amount Is Set To Greater Than Credit Balance
    And Empty Balance    credit_id=${credit_ids}[0]
    When The Features API Is Called
    Then The Response Should Contain Xpay BNPL Account And Status Is Active
    And The Gateway Is Disabled

[TC-014] Features Response For User With 1pay BNPL Account (Zero Credit Balance) And Xpay BNPL Account (Zero Credit Balance) And RepaymentOption Is 1pay And Xpay And Channel Is UPG
    Given The User Has 1pay And 4pay Accounts
    And The Channel Is Set To UPG
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And The Amount Is Set To Greater Than Credit Balance
    And Empty Balance    credit_id=${credit_ids}[0]
    And Empty Balance    credit_id=${credit_ids}[1]
    When The Features API Is Called
    Then The Response Should Contain Xpay BNPL Account (Zero Credit Balance) And Status Is Active
    And The Gateway Is Disabled

#############    👆 Zero Credit Balance and RepaymentOption Is 1pay And Xpay and Channel is UPG    #############

#############    👇 Expired and RepaymentOption Is 1pay And Xpay and Channel is UPG    #############

[TC-015] Features Response For User With 1pay BNPL Account (Expired) And RepaymentOption Is 1pay And Xpay And Channel Is UPG
    Given The User Has 1pay Account
    And The Channel Is Set To UPG
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And The Amount Is Set To Greater Than Credit Balance
    And Empty Balance
    And Expire Account    credit_id=${credit_ids}[0]
    When The Features API Is Called
    Then The Response Should Contain 1pay BNPL Account And Status Is Inactive
    And The Gateway Is Disabled

[TC-016] Features Response For User With Xpay BNPL Account (Expired) And RepaymentOption Is 1pay And Xpay And Channel Is UPG
    Given The User Has 4pay Account
    And The Channel Is Set To UPG
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And The Amount Is Set To Greater Than Credit Balance
    And Empty Balance
    And Expire Account    credit_id=${credit_ids}[0]
    When The Features API Is Called
    Then The Response Should Contain Xpay BNPL Account And Status Is Inactive
    And The Gateway Is Disabled

[TC-017] Features Response For User With 1pay BNPL Account And Xpay BNPL Account (Expired) And RepaymentOption Is 1pay And Xpay And Channel Is UPG
    Given The User Has 1pay And 4pay Accounts
    And The Channel Is Set To UPG
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And The Amount Is Set To Greater Than Credit Balance
    And Empty Balance    credit_id=${credit_ids}[1]
    And Expire Account    credit_id=${credit_ids}[1]
    When The Features API Is Called
    Then The Response Should Contain 1pay BNPL Account And Status Is Active
    And The Gateway Is Disabled

[TC-018] Features Response For User With 1pay BNPL Account (Expired) And Xpay BNPL Account And RepaymentOption Is 1pay And Xpay And Channel Is UPG
    Given The User Has 1pay And 4pay Accounts
    And The Channel Is Set To UPG
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And The Amount Is Set To Greater Than Credit Balance
    And Empty Balance    credit_id=${credit_ids}[0]
    And Expire Account    credit_id=${credit_ids}[0]
    When The Features API Is Called
    Then The Response Should Contain Xpay BNPL Account And Status Is Active
    And The Gateway Is Disabled

[TC-019] Features Response For User With 1pay BNPL Account (Expired) And Xpay BNPL Account (Expired) And RepaymentOption Is 1pay And Xpay And Channel Is UPG
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
    When The Features API Is Called
    Then The Response Should Contain Xpay BNPL Account And Status Is Inactive
    And The Gateway Is Disabled

#############    👆 Expired and RepaymentOption Is 1pay And Xpay and Channel is UPG    #############

#############    👇 Blocked and RepaymentOption Is 1pay And Xpay and Channel is UPG    #############

[TC-020] Features Response For User With Blocked 1pay BNPL Account And RepaymentOption Is 1pay And Xpay And Channel Is UPG
    Given The User Has 1pay Account
    And The Channel Is Set To UPG
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And The Amount Is Set To Greater Than Credit Balance
    And Block credit account
    When The Features API Is Called
    Then The Response Should Contain 1pay BNPL Account And Status Is Inactive
    And The Gateway Is Disabled

[TC-021] Features Response For User With Blocked Xpay BNPL Account And RepaymentOption Is 1pay And Xpay And Channel Is UPG
    Given The User Has 4pay Account
    And The Channel Is Set To UPG
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And The Amount Is Set To Greater Than Credit Balance
    And Block credit account
    When The Features API Is Called
    Then The Response Should Contain Xpay BNPL Account And Status Is Inactive
    And The Gateway Is Disabled

[TC-022] Features Response For User With 1pay BNPL Account And Blocked Xpay BNPL Account And RepaymentOption Is 1pay And Xpay And Channel Is UPG
    Given The User Has 1pay And 4pay Accounts
    And The Channel Is Set To UPG
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And The Amount Is Set To Greater Than Credit Balance
    And Block credit account    credit_id=${credit_ids}[1]
    When The Features API Is Called
    Then The Response Should Contain 1pay BNPL Account And Status Is Active
    And The Gateway Is Disabled

[TC-023] Features Response For User With Blocked 1pay BNPL Account And Xpay BNPL Account And RepaymentOption Is 1pay And Xpay And Channel Is UPG
    Given The User Has 1pay And 4pay Accounts
    And The Channel Is Set To UPG
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And The Amount Is Set To Greater Than Credit Balance
    And Block credit account    credit_id=${credit_ids}[0]
    When The Features API Is Called
    Then The Response Should Contain Xpay BNPL Account And Status Is Active
    And The Gateway Is Disabled

[TC-024] Features Response For User With Blocked 1pay BNPL Account And Blocked Xpay BNPL Account And RepaymentOption Is 1pay And Xpay And Channel Is UPG
    Given The User Has 1pay And 4pay Accounts
    And The Channel Is Set To UPG
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And The Amount Is Set To Greater Than Credit Balance
    And Block credit account    credit_id=${credit_ids}[0]
    And Block credit account    credit_id=${credit_ids}[1]
    When The Features API Is Called
    Then The Response Should Contain Xpay BNPL Account And Status Is Inactive
    And The Gateway Is Disabled

#############    👆 Blocked and RepaymentOption Is 1pay And Xpay and Channel is UPG    #############

[TC-025] Features Response For User With Blocked 1pay BNPL Account And Expired Xpay BNPL Account And RepaymentOption Is 1pay And Xpay And Channel Is UPG
    Given The User Has 1pay And 4pay Accounts
    And The Channel Is Set To UPG
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And The Amount Is Set To Greater Than Credit Balance
    And Empty Balance    credit_id=${credit_ids}[1]
    And Expire Account    credit_id=${credit_ids}[1]
    And Block credit account    credit_id=${credit_ids}[0]
    When The Features API Is Called
    Then The Response Should Contain 1pay BNPL Account And Status Is Inactive
    And The Gateway Is Disabled

[TC-026] Features Response When Gateway Is Disabled And Channel Is UPG
    Given The User Has 1pay Account
    And The Channel Is Set To UPG
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway Is Disabled
    And The Amount Is Set To Little Than Credit Balance
    When The Features API Is Called
    Then The Response Should Contain Empty List Of Features

#############    👇 happy path RepaymentOption Is 1pay And Xpay and Channel is QR    #############

[TC-027] Features Response For User With 1pay BNPL Account RepaymentOption Is 1pay And Xpay And Channel Is QR And Amount Is Equal To Credit Balance
    Given The User Has 1pay Account
    And The Channel Is Set To QR
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And The Amount Is Set To Equal To Credit Balance
    When The Features API Is Called
    Then The Response Should Contain 1pay BNPL Account And Status Is Active
    And The Gateway Is Disabled

[TC-028] Features Response For User With Xpay BNPL Account RepaymentOption Is 1pay And Xpay And Channel Is QR And Amount Is Equal To Credit Balance
    Given The User Has 4pay Account
    And The Channel Is Set To QR
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And The Amount Is Set To Equal To Credit Balance
    When The Features API Is Called
    Then The Response Should Contain Xpay BNPL Account And Status Is Active
    And The Gateway Is Disabled

[TC-029] Features Response For User With 1pay And Xpay BNPL Account And RepaymentOption Is 1pay And Xpay And Channel Is QR And Amount Is Equal To Credit Balance
    Given The User Has 1pay And 4pay Accounts
    And The Channel Is Set To QR
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And The Amount Is Set To Equal To Credit Balance
    When The Features API Is Called
    Then The Response Should Contain Xpay BNPL Account And Status Is Active
    And The Gateway Is Disabled

[TC-030] Features Response For User With 1pay BNPL Account RepaymentOption Is 1pay And Xpay And Channel Is QR And Amount Is Little Than Credit Balance
    Given The User Has 1pay Account
    And The Channel Is Set To QR
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And The Amount Is Set To Little Than Credit Balance
    When The Features API Is Called
    Then The Response Should Contain 1pay BNPL Account And Status Is Active
    And The Gateway Is Disabled

[TC-031] Features Response For User With Xpay BNPL Account RepaymentOption Is 1pay And Xpay And Channel Is QR And Amount Is Little Than Credit Balance
    Given The User Has 4pay Account
    And The Channel Is Set To QR
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And The Amount Is Set To Little Than Credit Balance
    When The Features API Is Called
    Then The Response Should Contain Xpay BNPL Account And Status Is Active
    And The Gateway Is Disabled

[TC-032] Features Response For User With 1pay And Xpay BNPL Account And RepaymentOption Is 1pay And Xpay And Channel Is QR And Amount Is Little Than Credit Balance
    Given The User Has 1pay And 4pay Accounts
    And The Channel Is Set To QR
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And The Amount Is Set To Little Than Credit Balance
    When The Features API Is Called
    Then The Response Should Contain Xpay BNPL Account And Status Is Active
    And The Gateway Is Disabled

[TC-033] Features Response For User With 1pay BNPL Account RepaymentOption Is 1pay And Xpay And Channel Is QR And Amount Is Greater Than Credit Balance
    Given The User Has 1pay Account
    And The Channel Is Set To QR
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And The Amount Is Set To Greater Than Credit Balance
    When The Features API Is Called
    Then The Response Should Contain 1pay BNPL Account And Status Is Active
    And The Gateway Is Disabled

[TC-034] Features Response For User With Xpay BNPL Account RepaymentOption Is 1pay And Xpay And Channel Is QR And Amount Is Greater Than Credit Balance
    Given The User Has 4pay Account
    And The Channel Is Set To QR
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And The Amount Is Set To Greater Than Credit Balance
    When The Features API Is Called
    Then The Response Should Contain Xpay BNPL Account And Status Is Active
    And The Gateway Is Disabled

[TC-035] Features Response For User With 1pay And Xpay BNPL Account And RepaymentOption Is 1pay And Xpay And Channel Is QR And Amount Is Greater Than Credit Balance
    Given The User Has 1pay And 4pay Accounts
    And The Channel Is Set To QR
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And The Amount Is Set To Greater Than Credit Balance
    When The Features API Is Called
    Then The Response Should Contain Xpay BNPL Account And Status Is Active
    And The Gateway Is Disabled

#############    👆 happy path RepaymentOption Is 1pay And Xpay and Channel is QR    #############

#############    👇 Zero Credit Balance and RepaymentOption Is 1pay And Xpay and Channel is QR    #############

[TC-036] Features Response For User With 1pay BNPL Account (Zero Credit Balance) And RepaymentOption Is 1pay And Xpay And Channel Is QR
    Given The User Has 1pay Account
    And The Channel Is Set To QR
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And The Amount Is Set To Greater Than Credit Balance
    And Empty Balance
    When The Features API Is Called
    Then The Response Should Contain 1pay BNPL Account (Zero Credit Balance) And Status Is Active
    And The Gateway Is Disabled

[TC-037] Features Response For User With Xpay BNPL Account (Zero Credit Balance) And RepaymentOption Is 1pay And Xpay And Channel Is QR
    Given The User Has 4pay Account
    And The Channel Is Set To QR
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And The Amount Is Set To Greater Than Credit Balance
    And Empty Balance
    When The Features API Is Called
    Then The Response Should Contain Xpay BNPL Account (Zero Credit Balance) And Status Is Active
    And The Gateway Is Disabled

[TC-038] Features Response For User With 1pay BNPL Account And Xpay BNPL Account (Zero Credit Balance) And RepaymentOption Is 1pay And Xpay And Channel Is QR
    Given The User Has 1pay And 4pay Accounts
    And The Channel Is Set To QR
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And The Amount Is Set To Greater Than Credit Balance
    And Empty Balance    credit_id=${credit_ids}[1]
    When The Features API Is Called
    Then The Response Should Contain 1pay BNPL Account And Status Is Active
    And The Gateway Is Disabled

[TC-039] Features Response For User With 1pay BNPL Account (Zero Credit Balance) And Xpay BNPL Account And RepaymentOption Is 1pay And Xpay And Channel Is QR
    Given The User Has 1pay And 4pay Accounts
    And The Channel Is Set To QR
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And The Amount Is Set To Greater Than Credit Balance
    And Empty Balance    credit_id=${credit_ids}[0]
    When The Features API Is Called
    Then The Response Should Contain Xpay BNPL Account And Status Is Active
    And The Gateway Is Disabled

[TC-040] Features Response For User With 1pay BNPL Account (Zero Credit Balance) And Xpay BNPL Account (Zero Credit Balance) And RepaymentOption Is 1pay And Xpay And Channel Is QR
    Given The User Has 1pay And 4pay Accounts
    And The Channel Is Set To QR
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And The Amount Is Set To Greater Than Credit Balance
    And Empty Balance    credit_id=${credit_ids}[0]
    And Empty Balance    credit_id=${credit_ids}[1]
    When The Features API Is Called
    Then The Response Should Contain Xpay BNPL Account (Zero Credit Balance) And Status Is Active
    And The Gateway Is Disabled

#############    👆 Zero Credit Balance and RepaymentOption Is 1pay And Xpay and Channel is QR    #############

#############    👇 Expired and RepaymentOption Is 1pay And Xpay and Channel is QR    #############

[TC-041] Features Response For User With 1pay BNPL Account (Expired) And RepaymentOption Is 1pay And Xpay And Channel Is QR
    Given The User Has 1pay Account
    And The Channel Is Set To QR
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And The Amount Is Set To Greater Than Credit Balance
    And Empty Balance
    And Expire Account    credit_id=${credit_ids}[0]
    When The Features API Is Called
    Then The Response Should Contain 1pay BNPL Account And Status Is Inactive
    And The Gateway Is Disabled

[TC-042] Features Response For User With Xpay BNPL Account (Expired) And RepaymentOption Is 1pay And Xpay And Channel Is QR
    Given The User Has 4pay Account
    And The Channel Is Set To QR
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And The Amount Is Set To Greater Than Credit Balance
    And Empty Balance
    And Expire Account    credit_id=${credit_ids}[0]
    When The Features API Is Called
    Then The Response Should Contain Xpay BNPL Account And Status Is Inactive
    And The Gateway Is Disabled

[TC-043] Features Response For User With 1pay BNPL Account And Xpay BNPL Account (Expired) And RepaymentOption Is 1pay And Xpay And Channel Is QR
    Given The User Has 1pay And 4pay Accounts
    And The Channel Is Set To QR
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And The Amount Is Set To Greater Than Credit Balance
    And Empty Balance    credit_id=${credit_ids}[1]
    And Expire Account    credit_id=${credit_ids}[1]
    When The Features API Is Called
    Then The Response Should Contain 1pay BNPL Account And Status Is Active
    And The Gateway Is Disabled

[TC-044] Features Response For User With 1pay BNPL Account (Expired) And Xpay BNPL Account And RepaymentOption Is 1pay And Xpay And Channel Is QR
    Given The User Has 1pay And 4pay Accounts
    And The Channel Is Set To QR
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And The Amount Is Set To Greater Than Credit Balance
    And Empty Balance    credit_id=${credit_ids}[0]
    And Expire Account    credit_id=${credit_ids}[0]
    When The Features API Is Called
    Then The Response Should Contain Xpay BNPL Account And Status Is Active
    And The Gateway Is Disabled

[TC-045] Features Response For User With 1pay BNPL Account (Expired) And Xpay BNPL Account (Expired) And RepaymentOption Is 1pay And Xpay And Channel Is QR
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
    When The Features API Is Called
    Then The Response Should Contain Xpay BNPL Account And Status Is Inactive
    And The Gateway Is Disabled

#############    👆 Expired and RepaymentOption Is 1pay And Xpay and Channel is QR    #############

#############    👇 Blocked and RepaymentOption Is 1pay And Xpay and Channel is QR    #############

[TC-046] Features Response For User With Blocked 1pay BNPL Account And RepaymentOption Is 1pay And Xpay And Channel Is QR
    Given The User Has 1pay Account
    And The Channel Is Set To QR
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And The Amount Is Set To Greater Than Credit Balance
    And Block credit account
    When The Features API Is Called
    Then The Response Should Contain 1pay BNPL Account And Status Is Inactive
    And The Gateway Is Disabled

[TC-047] Features Response For User With Blocked Xpay BNPL Account And RepaymentOption Is 1pay And Xpay And Channel Is QR
    Given The User Has 4pay Account
    And The Channel Is Set To QR
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And The Amount Is Set To Greater Than Credit Balance
    And Block credit account
    When The Features API Is Called
    Then The Response Should Contain Xpay BNPL Account And Status Is Inactive
    And The Gateway Is Disabled

[TC-048] Features Response For User With 1pay BNPL Account And Blocked Xpay BNPL Account And RepaymentOption Is 1pay And Xpay And Channel Is QR
    Given The User Has 1pay And 4pay Accounts
    And The Channel Is Set To QR
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And The Amount Is Set To Greater Than Credit Balance
    And Block credit account    credit_id=${credit_ids}[1]
    When The Features API Is Called
    Then The Response Should Contain 1pay BNPL Account And Status Is Active
    And The Gateway Is Disabled

[TC-049] Features Response For User With Blocked 1pay BNPL Account And Xpay BNPL Account And RepaymentOption Is 1pay And Xpay And Channel Is QR
    Given The User Has 1pay And 4pay Accounts
    And The Channel Is Set To QR
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And The Amount Is Set To Greater Than Credit Balance
    And Block credit account    credit_id=${credit_ids}[0]
    When The Features API Is Called
    Then The Response Should Contain Xpay BNPL Account And Status Is Active
    And The Gateway Is Disabled

[TC-050] Features Response For User With Blocked 1pay BNPL Account And Blocked Xpay BNPL Account And RepaymentOption Is 1pay And Xpay And Channel Is QR
    Given The User Has 1pay And 4pay Accounts
    And The Channel Is Set To QR
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And The Amount Is Set To Greater Than Credit Balance
    And Block credit account    credit_id=${credit_ids}[0]
    And Block credit account    credit_id=${credit_ids}[1]
    When The Features API Is Called
    Then The Response Should Contain Xpay BNPL Account And Status Is Inactive
    And The Gateway Is Disabled

#############    👆 Blocked and RepaymentOption Is 1pay And Xpay and Channel is QR    #############

[TC-051] Features Response For User With Blocked 1pay BNPL Account And Expired Xpay BNPL Account And RepaymentOption Is 1pay And Xpay And Channel Is QR
    Given The User Has 1pay And 4pay Accounts
    And The Channel Is Set To QR
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And The Amount Is Set To Greater Than Credit Balance
    And Empty Balance    credit_id=${credit_ids}[1]
    And Expire Account    credit_id=${credit_ids}[1]
    And Block credit account    credit_id=${credit_ids}[0]
    When The Features API Is Called
    Then The Response Should Contain 1pay BNPL Account And Status Is Inactive
    And The Gateway Is Disabled

[TC-052] Features Response When Gateway Is Disabled And Channel Is QR
    Given The User Has 1pay Account
    And The Channel Is Set To QR
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway Is Disabled
    And The Amount Is Set To Little Than Credit Balance
    When The Features API Is Called
    Then The Response Should Contain Empty List Of Features

#############    👇 happy path RepaymentOption Is 1pay and Channel is UPG    #############

[TC-053] Features Response For User With 1pay BNPL Account RepaymentOption Is 1pay And Channel Is UPG And Amount Is Equal To Credit Balance
    Given The User Has 1pay Account
    And The Channel Is Set To UPG
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay
    And The Amount Is Set To Equal To Credit Balance
    When The Features API Is Called
    Then The Response Should Contain 1pay BNPL Account And Status Is Active
    And The Gateway Is Disabled

[TC-054] Features Response For User With Xpay BNPL Account RepaymentOption Is 1pay And Channel Is UPG And Amount Is Equal To Credit Balance
    Given The User Has 4pay Account
    And The Channel Is Set To UPG
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay
    And The Amount Is Set To Equal To Credit Balance
    When The Features API Is Called
    Then The Response Should Contain No Accounts
    And The Gateway Is Disabled

[TC-055] Features Response For User With 1pay And Xpay BNPL Account And RepaymentOption Is 1pay And Channel Is UPG And Amount Is Equal To Credit Balance
    Given The User Has 1pay And 4pay Accounts
    And The Channel Is Set To UPG
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay
    And The Amount Is Set To Equal To Credit Balance
    When The Features API Is Called
    Then The Response Should Contain 1pay BNPL Account And Status Is Active
    And The Gateway Is Disabled

[TC-056] Features Response For User With 1pay BNPL Account RepaymentOption Is 1pay And Channel Is UPG And Amount Is Little Than Credit Balance
    Given The User Has 1pay Account
    And The Channel Is Set To UPG
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay
    And The Amount Is Set To Little Than Credit Balance
    When The Features API Is Called
    Then The Response Should Contain 1pay BNPL Account And Status Is Active
    And The Gateway Is Disabled

[TC-057] Features Response For User With Xpay BNPL Account RepaymentOption Is 1pay And Channel Is UPG And Amount Is Little Than Credit Balance
    Given The User Has 4pay Account
    And The Channel Is Set To UPG
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay
    And The Amount Is Set To Little Than Credit Balance
    When The Features API Is Called
    Then The Response Should Contain No Accounts
    And The Gateway Is Disabled

[TC-058] Features Response For User With 1pay And Xpay BNPL Account And RepaymentOption Is 1pay And Channel Is UPG And Amount Is Little Than Credit Balance
    Given The User Has 1pay And 4pay Accounts
    And The Channel Is Set To UPG
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay
    And The Amount Is Set To Little Than Credit Balance
    When The Features API Is Called
    Then The Response Should Contain 1pay BNPL Account And Status Is Active
    And The Gateway Is Disabled

[TC-059] Features Response For User With 1pay BNPL Account RepaymentOption Is 1pay And Channel Is UPG And Amount Is Greater Than Credit Balance
    Given The User Has 1pay Account
    And The Channel Is Set To UPG
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay
    And The Amount Is Set To Greater Than Credit Balance
    When The Features API Is Called
    Then The Response Should Contain 1pay BNPL Account And Status Is Active
    And The Gateway Is Disabled

[TC-060] Features Response For User With Xpay BNPL Account RepaymentOption Is 1pay And Channel Is UPG And Amount Is Greater Than Credit Balance
    Given The User Has 4pay Account
    And The Channel Is Set To UPG
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay
    And The Amount Is Set To Greater Than Credit Balance
    When The Features API Is Called
    Then The Response Should Contain No Accounts
    And The Gateway Is Disabled

[TC-061] Features Response For User With 1pay And Xpay BNPL Account And RepaymentOption Is 1pay And Channel Is UPG And Amount Is Greater Than Credit Balance
    Given The User Has 1pay And 4pay Accounts
    And The Channel Is Set To UPG
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay
    And The Amount Is Set To Greater Than Credit Balance
    When The Features API Is Called
    Then The Response Should Contain 1pay BNPL Account And Status Is Active
    And The Gateway Is Disabled

#############    👆 happy path RepaymentOption Is 1pay and Channel is UPG    #############

#############    👇 Zero Credit Balance and RepaymentOption Is 1pay and Channel is UPG    #############

[TC-062] Features Response For User With 1pay BNPL Account (Zero Credit Balance) And RepaymentOption Is 1pay And Channel Is UPG
    Given The User Has 1pay Account
    And The Channel Is Set To UPG
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay
    And The Amount Is Set To Greater Than Credit Balance
    And Empty Balance
    When The Features API Is Called
    Then The Response Should Contain 1pay BNPL Account (Zero Credit Balance) And Status Is Active
    And The Gateway Is Disabled

[TC-063] Features Response For User With Xpay BNPL Account (Zero Credit Balance) And RepaymentOption Is 1pay And Channel Is UPG
    Given The User Has 4pay Account
    And The Channel Is Set To UPG
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay
    And The Amount Is Set To Greater Than Credit Balance
    And Empty Balance
    When The Features API Is Called
    Then The Response Should Contain No Accounts
    And The Gateway Is Disabled

[TC-064] Features Response For User With 1pay BNPL Account And Xpay BNPL Account (Zero Credit Balance) And RepaymentOption Is 1pay And Channel Is UPG
    Given The User Has 1pay And 4pay Accounts
    And The Channel Is Set To UPG
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay
    And The Amount Is Set To Greater Than Credit Balance
    And Empty Balance    credit_id=${credit_ids}[1]
    When The Features API Is Called
    Then The Response Should Contain 1pay BNPL Account And Status Is Active
    And The Gateway Is Disabled

[TC-065] Features Response For User With 1pay BNPL Account (Zero Credit Balance) And Xpay BNPL Account And RepaymentOption Is 1pay And Channel Is UPG
    Given The User Has 1pay And 4pay Accounts
    And The Channel Is Set To UPG
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay
    And The Amount Is Set To Greater Than Credit Balance
    And Empty Balance    credit_id=${credit_ids}[0]
    When The Features API Is Called
    Then The Response Should Contain 1pay BNPL Account (Zero Credit Balance) And Status Is Active
    And The Gateway Is Disabled

[TC-066] Features Response For User With 1pay BNPL Account (Zero Credit Balance) And Xpay BNPL Account (Zero Credit Balance) And RepaymentOption Is 1pay And Channel Is UPG
    Given The User Has 1pay And 4pay Accounts
    And The Channel Is Set To UPG
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay
    And The Amount Is Set To Greater Than Credit Balance
    And Empty Balance    credit_id=${credit_ids}[0]
    And Empty Balance    credit_id=${credit_ids}[1]
    When The Features API Is Called
    Then The Response Should Contain 1pay BNPL Account (Zero Credit Balance) And Status Is Active
    And The Gateway Is Disabled

#############    👆 Zero Credit Balance and RepaymentOption Is 1pay and Channel is UPG    #############

#############    👇 Expired and RepaymentOption Is 1pay and Channel is UPG    #############

[TC-067] Features Response For User With 1pay BNPL Account (Expired) And RepaymentOption Is 1pay And Channel Is UPG
    Given The User Has 1pay Account
    And The Channel Is Set To UPG
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay
    And The Amount Is Set To Greater Than Credit Balance
    And Empty Balance
    And Expire Account    credit_id=${credit_ids}[0]
    When The Features API Is Called
    Then The Response Should Contain 1pay BNPL Account And Status Is Inactive
    And The Gateway Is Disabled

[TC-068] Features Response For User With Xpay BNPL Account (Expired) And RepaymentOption Is 1pay And Channel Is UPG
    Given The User Has 4pay Account
    And The Channel Is Set To UPG
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay
    And The Amount Is Set To Greater Than Credit Balance
    And Empty Balance
    And Expire Account    credit_id=${credit_ids}[0]
    When The Features API Is Called
    Then The Response Should Contain No Accounts
    And The Gateway Is Disabled

[TC-069] Features Response For User With 1pay BNPL Account And Xpay BNPL Account (Expired) And RepaymentOption Is 1pay And Channel Is UPG
    Given The User Has 1pay And 4pay Accounts
    And The Channel Is Set To UPG
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay
    And The Amount Is Set To Greater Than Credit Balance
    And Empty Balance    credit_id=${credit_ids}[1]
    And Expire Account    credit_id=${credit_ids}[1]
    When The Features API Is Called
    Then The Response Should Contain 1pay BNPL Account And Status Is Active
    And The Gateway Is Disabled

[TC-070] Features Response For User With 1pay BNPL Account (Expired) And Xpay BNPL Account And RepaymentOption Is 1pay And Channel Is UPG
    Given The User Has 1pay And 4pay Accounts
    And The Channel Is Set To UPG
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay
    And The Amount Is Set To Greater Than Credit Balance
    And Empty Balance    credit_id=${credit_ids}[0]
    And Expire Account    credit_id=${credit_ids}[0]
    When The Features API Is Called
    Then The Response Should Contain 1pay BNPL Account And Status Is Inactive
    And The Gateway Is Disabled

[TC-071] Features Response For User With 1pay BNPL Account (Expired) And Xpay BNPL Account (Expired) And RepaymentOption Is 1pay And Channel Is UPG
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
    When The Features API Is Called
    Then The Response Should Contain 1pay BNPL Account And Status Is Inactive
    And The Gateway Is Disabled

#############    👆 Expired and RepaymentOption Is 1pay and Channel is UPG    #############

#############    👇 Blocked and RepaymentOption Is 1pay and Channel is UPG    #############

[TC-072] Features Response For User With Blocked 1pay BNPL Account And RepaymentOption Is 1pay And Channel Is UPG
    Given The User Has 1pay Account
    And The Channel Is Set To UPG
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay
    And The Amount Is Set To Greater Than Credit Balance
    And Block credit account
    When The Features API Is Called
    Then The Response Should Contain 1pay BNPL Account And Status Is Inactive
    And The Gateway Is Disabled

[TC-073] Features Response For User With Blocked Xpay BNPL Account And RepaymentOption Is 1pay And Channel Is UPG
    Given The User Has 4pay Account
    And The Channel Is Set To UPG
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay
    And The Amount Is Set To Greater Than Credit Balance
    And Block credit account
    When The Features API Is Called
    Then The Response Should Contain No Accounts
    And The Gateway Is Disabled

[TC-074] Features Response For User With 1pay BNPL Account And Blocked Xpay BNPL Account And RepaymentOption Is 1pay And Channel Is UPG
    Given The User Has 1pay And 4pay Accounts
    And The Channel Is Set To UPG
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay
    And The Amount Is Set To Greater Than Credit Balance
    And Block credit account    credit_id=${credit_ids}[1]
    When The Features API Is Called
    Then The Response Should Contain 1pay BNPL Account And Status Is Active
    And The Gateway Is Disabled

[TC-075] Features Response For User With Blocked 1pay BNPL Account And Xpay BNPL Account And RepaymentOption Is 1pay And Channel Is UPG
    Given The User Has 1pay And 4pay Accounts
    And The Channel Is Set To UPG
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay
    And The Amount Is Set To Greater Than Credit Balance
    And Block credit account    credit_id=${credit_ids}[0]
    When The Features API Is Called
    Then The Response Should Contain 1pay BNPL Account And Status Is Inactive
    And The Gateway Is Disabled

[TC-076] Features Response For User With Blocked 1pay BNPL Account And Blocked Xpay BNPL Account And RepaymentOption Is 1pay And Channel Is UPG
    Given The User Has 1pay And 4pay Accounts
    And The Channel Is Set To UPG
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay
    And The Amount Is Set To Greater Than Credit Balance
    And Block credit account    credit_id=${credit_ids}[0]
    And Block credit account    credit_id=${credit_ids}[1]
    When The Features API Is Called
    Then The Response Should Contain Blocked Account
    And The Gateway Is Disabled

#############    👆 Blocked and RepaymentOption Is 1pay and Channel is UPG    #############

[TC-077] Features Response For User With Blocked 1pay BNPL Account And Expired Xpay BNPL Account And RepaymentOption Is 1pay And Channel Is UPG
    Given The User Has 1pay And 4pay Accounts
    And The Channel Is Set To UPG
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay
    And The Amount Is Set To Greater Than Credit Balance
    And Empty Balance    credit_id=${credit_ids}[1]
    And Expire Account    credit_id=${credit_ids}[1]
    And Block credit account    credit_id=${credit_ids}[0]
    When The Features API Is Called
    Then The Response Should Contain 1pay BNPL Account And Status Is Inactive
    And The Gateway Is Disabled

#############    👇 happy path RepaymentOption Is 1pay and Channel is QR    #############

[TC-078] Features Response For User With 1pay BNPL Account RepaymentOption Is 1pay And Channel Is QR And Amount Is Equal To Credit Balance
    Given The User Has 1pay Account
    And The Channel Is Set To QR
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay
    And The Amount Is Set To Equal To Credit Balance
    When The Features API Is Called
    Then The Response Should Contain 1pay BNPL Account And Status Is Active
    And The Gateway Is Disabled

[TC-079] Features Response For User With Xpay BNPL Account RepaymentOption Is 1pay And Channel Is QR And Amount Is Equal To Credit Balance
    Given The User Has 4pay Account
    And The Channel Is Set To QR
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay
    And The Amount Is Set To Equal To Credit Balance
    When The Features API Is Called
    Then The Response Should Contain Empty List Of Features
    And The Gateway Is Disabled

[TC-080] Features Response For User With 1pay And Xpay BNPL Account And RepaymentOption Is 1pay And Channel Is QR And Amount Is Equal To Credit Balance
    Given The User Has 1pay And 4pay Accounts
    And The Channel Is Set To QR
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay
    And The Amount Is Set To Equal To Credit Balance
    When The Features API Is Called
    Then The Response Should Contain 1pay BNPL Account And Status Is Active
    And The Gateway Is Disabled

[TC-081] Features Response For User With 1pay BNPL Account RepaymentOption Is 1pay And Channel Is QR And Amount Is Little Than Credit Balance
    Given The User Has 1pay Account
    And The Channel Is Set To QR
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay
    And The Amount Is Set To Little Than Credit Balance
    When The Features API Is Called
    Then The Response Should Contain 1pay BNPL Account And Status Is Active
    And The Gateway Is Disabled

[TC-082] Features Response For User With Xpay BNPL Account RepaymentOption Is 1pay And Channel Is QR And Amount Is Little Than Credit Balance
    Given The User Has 4pay Account
    And The Channel Is Set To QR
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay
    And The Amount Is Set To Little Than Credit Balance
    When The Features API Is Called
    Then The Response Should Contain Empty List Of Features
    And The Gateway Is Disabled

[TC-083] Features Response For User With 1pay And Xpay BNPL Account And RepaymentOption Is 1pay And Channel Is QR And Amount Is Little Than Credit Balance
    Given The User Has 1pay And 4pay Accounts
    And The Channel Is Set To QR
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay
    And The Amount Is Set To Little Than Credit Balance
    When The Features API Is Called
    Then The Response Should Contain 1pay BNPL Account And Status Is Active
    And The Gateway Is Disabled

[TC-084] Features Response For User With 1pay BNPL Account RepaymentOption Is 1pay And Channel Is QR And Amount Is Greater Than Credit Balance
    Given The User Has 1pay Account
    And The Channel Is Set To QR
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay
    And The Amount Is Set To Greater Than Credit Balance
    When The Features API Is Called
    Then The Response Should Contain 1pay BNPL Account And Status Is Active
    And The Gateway Is Disabled

[TC-085] Features Response For User With Xpay BNPL Account RepaymentOption Is 1pay And Channel Is QR And Amount Is Greater Than Credit Balance
    Given The User Has 4pay Account
    And The Channel Is Set To QR
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay
    And The Amount Is Set To Greater Than Credit Balance
    When The Features API Is Called
    Then The Response Should Contain Empty List Of Features
    And The Gateway Is Disabled

[TC-086] Features Response For User With 1pay And Xpay BNPL Account And RepaymentOption Is 1pay And Channel Is QR And Amount Is Greater Than Credit Balance
    Given The User Has 1pay And 4pay Accounts
    And The Channel Is Set To QR
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay
    And The Amount Is Set To Greater Than Credit Balance
    When The Features API Is Called
    Then The Response Should Contain 1pay BNPL Account And Status Is Active
    And The Gateway Is Disabled

#############    👆 happy path RepaymentOption Is 1pay and Channel is QR    #############

#############    👇 Zero Credit Balance and RepaymentOption Is 1pay and Channel is QR    #############

[TC-087] Features Response For User With 1pay BNPL Account (Zero Credit Balance) And RepaymentOption Is 1pay And Channel Is QR
    Given The User Has 1pay Account
    And The Channel Is Set To QR
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay
    And The Amount Is Set To Greater Than Credit Balance
    And Empty Balance
    When The Features API Is Called
    Then The Response Should Contain 1pay BNPL Account (Zero Credit Balance) And Status Is Active
    And The Gateway Is Disabled

[TC-088] Features Response For User With Xpay BNPL Account (Zero Credit Balance) And RepaymentOption Is 1pay And Channel Is QR
    Given The User Has 4pay Account
    And The Channel Is Set To QR
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay
    And The Amount Is Set To Greater Than Credit Balance
    And Empty Balance
    When The Features API Is Called
    Then The Response Should Contain Empty List Of Features
    And The Gateway Is Disabled

[TC-089] Features Response For User With 1pay BNPL Account And Xpay BNPL Account (Zero Credit Balance) And RepaymentOption Is 1pay And Channel Is QR
    Given The User Has 1pay And 4pay Accounts
    And The Channel Is Set To QR
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay
    And The Amount Is Set To Greater Than Credit Balance
    And Empty Balance    credit_id=${credit_ids}[1]
    When The Features API Is Called
    Then The Response Should Contain 1pay BNPL Account And Status Is Active
    And The Gateway Is Disabled

[TC-090] Features Response For User With 1pay BNPL Account (Zero Credit Balance) And Xpay BNPL Account And RepaymentOption Is 1pay And Channel Is QR
    Given The User Has 1pay And 4pay Accounts
    And The Channel Is Set To QR
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay
    And The Amount Is Set To Greater Than Credit Balance
    And Empty Balance    credit_id=${credit_ids}[0]
    When The Features API Is Called
    Then The Response Should Contain 1pay BNPL Account (Zero Credit Balance) And Status Is Active
    And The Gateway Is Disabled

[TC-091] Features Response For User With 1pay BNPL Account (Zero Credit Balance) And Xpay BNPL Account (Zero Credit Balance) And RepaymentOption Is 1pay And Channel Is QR
    Given The User Has 1pay And 4pay Accounts
    And The Channel Is Set To QR
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay
    And The Amount Is Set To Greater Than Credit Balance
    And Empty Balance    credit_id=${credit_ids}[0]
    And Empty Balance    credit_id=${credit_ids}[1]
    When The Features API Is Called
    Then The Response Should Contain 1pay BNPL Account (Zero Credit Balance) And Status Is Active
    And The Gateway Is Disabled

#############    👆 Zero Credit Balance and RepaymentOption Is 1pay and Channel is QR    #############

#############    👇 Expired and RepaymentOption Is 1pay and Channel is QR    #############

[TC-092] Features Response For User With 1pay BNPL Account (Expired) And RepaymentOption Is 1pay And Channel Is QR
    Given The User Has 1pay Account
    And The Channel Is Set To QR
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay
    And The Amount Is Set To Greater Than Credit Balance
    And Empty Balance
    And Expire Account    credit_id=${credit_ids}[0]
    When The Features API Is Called
    Then The Response Should Contain 1pay BNPL Account And Status Is Inactive
    And The Gateway Is Disabled

[TC-093] Features Response For User With Xpay BNPL Account (Expired) And RepaymentOption Is 1pay And Channel Is QR
    Given The User Has 4pay Account
    And The Channel Is Set To QR
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay
    And The Amount Is Set To Greater Than Credit Balance
    And Empty Balance
    And Expire Account    credit_id=${credit_ids}[0]
    When The Features API Is Called
    Then The Response Should Contain Empty List Of Features
    And The Gateway Is Disabled

[TC-094] Features Response For User With 1pay BNPL Account And Xpay BNPL Account (Expired) And RepaymentOption Is 1pay And Channel Is QR
    Given The User Has 1pay And 4pay Accounts
    And The Channel Is Set To QR
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay
    And The Amount Is Set To Greater Than Credit Balance
    And Empty Balance    credit_id=${credit_ids}[1]
    And Expire Account    credit_id=${credit_ids}[1]
    When The Features API Is Called
    Then The Response Should Contain 1pay BNPL Account And Status Is Active
    And The Gateway Is Disabled

[TC-095] Features Response For User With 1pay BNPL Account (Expired) And Xpay BNPL Account And RepaymentOption Is 1pay And Channel Is QR
    Given The User Has 1pay And 4pay Accounts
    And The Channel Is Set To QR
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay
    And The Amount Is Set To Greater Than Credit Balance
    And Empty Balance    credit_id=${credit_ids}[0]
    And Expire Account    credit_id=${credit_ids}[0]
    When The Features API Is Called
    Then The Response Should Contain 1pay BNPL Account And Status Is Inactive
    And The Gateway Is Disabled

[TC-096] Features Response For User With 1pay BNPL Account (Expired) And Xpay BNPL Account (Expired) And RepaymentOption Is 1pay And Channel Is QR
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
    When The Features API Is Called
    Then The Response Should Contain 1pay BNPL Account And Status Is Inactive
    And The Gateway Is Disabled

#############    👆 Expired and RepaymentOption Is 1pay and Channel is QR    #############

#############    👇 Blocked and RepaymentOption Is 1pay and Channel is QR    #############

[TC-097] Features Response For User With Blocked 1pay BNPL Account And RepaymentOption Is 1pay And Channel Is QR
    Given The User Has 1pay Account
    And The Channel Is Set To QR
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay
    And The Amount Is Set To Greater Than Credit Balance
    And Block credit account
    When The Features API Is Called
    Then The Response Should Contain 1pay BNPL Account And Status Is Inactive
    And The Gateway Is Disabled

[TC-098] Features Response For User With Blocked Xpay BNPL Account And RepaymentOption Is 1pay And Channel Is QR
    Given The User Has 4pay Account
    And The Channel Is Set To QR
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay
    And The Amount Is Set To Greater Than Credit Balance
    And Block credit account
    When The Features API Is Called
    Then The Response Should Contain Empty List Of Features
    And The Gateway Is Disabled

[TC-099] Features Response For User With 1pay BNPL Account And Blocked Xpay BNPL Account And RepaymentOption Is 1pay And Channel Is QR
    Given The User Has 1pay And 4pay Accounts
    And The Channel Is Set To QR
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay
    And The Amount Is Set To Greater Than Credit Balance
    And Block credit account    credit_id=${credit_ids}[1]
    When The Features API Is Called
    Then The Response Should Contain 1pay BNPL Account And Status Is Active
    And The Gateway Is Disabled

[TC-100] Features Response For User With Blocked 1pay BNPL Account And Xpay BNPL Account And RepaymentOption Is 1pay And Channel Is QR
    Given The User Has 1pay And 4pay Accounts
    And The Channel Is Set To QR
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay
    And The Amount Is Set To Greater Than Credit Balance
    And Block credit account    credit_id=${credit_ids}[0]
    When The Features API Is Called
    Then The Response Should Contain 1pay BNPL Account And Status Is Inactive
    And The Gateway Is Disabled

[TC-101] Features Response For User With Blocked 1pay BNPL Account And Blocked Xpay BNPL Account And RepaymentOption Is 1pay And Channel Is QR
    Given The User Has 1pay And 4pay Accounts
    And The Channel Is Set To QR
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay
    And The Amount Is Set To Greater Than Credit Balance
    And Block credit account    credit_id=${credit_ids}[0]
    And Block credit account    credit_id=${credit_ids}[1]
    When The Features API Is Called
    Then The Response Should Contain Blocked Account
    And The Gateway Is Disabled

#############    👆 Blocked and RepaymentOption Is 1pay and Channel is QR    #############

[TC-102] Features Response For User With Blocked 1pay BNPL Account And Expired Xpay BNPL Account And RepaymentOption Is 1pay And Channel Is QR
    Given The User Has 1pay And 4pay Accounts
    And The Channel Is Set To QR
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay
    And The Amount Is Set To Greater Than Credit Balance
    And Empty Balance    credit_id=${credit_ids}[1]
    And Expire Account    credit_id=${credit_ids}[1]
    And Block credit account    credit_id=${credit_ids}[0]
    When The Features API Is Called
    Then The Response Should Contain 1pay BNPL Account And Status Is Inactive
    And The Gateway Is Disabled

#############    👇 happy path RepaymentOption Is Xpay and Channel is UPG    #############

[TC-103] Features Response For User With 1pay BNPL Account RepaymentOption Is Xpay And Channel Is UPG And Amount Is Equal To Credit Balance
    Given The User Has 1pay Account
    And The Channel Is Set To UPG
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To Xpay
    And The Amount Is Set To Equal To Credit Balance
    When The Features API Is Called
    Then The Response Should Contain No Accounts
    And The Gateway Is Disabled

[TC-104] Features Response For User With Xpay BNPL Account RepaymentOption Is Xpay And Channel Is UPG And Amount Is Equal To Credit Balance
    Given The User Has 4pay Account
    And The Channel Is Set To UPG
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To Xpay
    And The Amount Is Set To Equal To Credit Balance
    When The Features API Is Called
    Then The Response Should Contain Xpay BNPL Account And Status Is Active
    And The Gateway Is Disabled

[TC-105] Features Response For User With 1pay And Xpay BNPL Account And RepaymentOption Is Xpay And Channel Is UPG And Amount Is Equal To Credit Balance
    Given The User Has 1pay And 4pay Accounts
    And The Channel Is Set To UPG
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To Xpay
    And The Amount Is Set To Equal To Credit Balance
    When The Features API Is Called
    Then The Response Should Contain Xpay BNPL Account And Status Is Active
    And The Gateway Is Disabled

[TC-106] Features Response For User With 1pay BNPL Account RepaymentOption Is Xpay And Channel Is UPG And Amount Is Little Than Credit Balance
    Given The User Has 1pay Account
    And The Channel Is Set To UPG
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To Xpay
    And The Amount Is Set To Little Than Credit Balance
    When The Features API Is Called
    Then The Response Should Contain No Accounts
    And The Gateway Is Disabled

[TC-107] Features Response For User With Xpay BNPL Account RepaymentOption Is Xpay And Channel Is UPG And Amount Is Little Than Credit Balance
    Given The User Has 4pay Account
    And The Channel Is Set To UPG
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To Xpay
    And The Amount Is Set To Little Than Credit Balance
    When The Features API Is Called
    Then The Response Should Contain Xpay BNPL Account And Status Is Active
    And The Gateway Is Disabled

[TC-108] Features Response For User With 1pay And Xpay BNPL Account And RepaymentOption Is Xpay And Channel Is UPG And Amount Is Little Than Credit Balance
    Given The User Has 1pay And 4pay Accounts
    And The Channel Is Set To UPG
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To Xpay
    And The Amount Is Set To Little Than Credit Balance
    When The Features API Is Called
    Then The Response Should Contain Xpay BNPL Account And Status Is Active
    And The Gateway Is Disabled

[TC-109] Features Response For User With 1pay BNPL Account RepaymentOption Is Xpay And Channel Is UPG And Amount Is Greater Than Credit Balance
    Given The User Has 1pay Account
    And The Channel Is Set To UPG
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To Xpay
    And The Amount Is Set To Greater Than Credit Balance
    When The Features API Is Called
    Then The Response Should Contain No Accounts
    And The Gateway Is Disabled

[TC-110] Features Response For User With Xpay BNPL Account RepaymentOption Is Xpay And Channel Is UPG And Amount Is Greater Than Credit Balance
    Given The User Has 4pay Account
    And The Channel Is Set To UPG
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To Xpay
    And The Amount Is Set To Greater Than Credit Balance
    When The Features API Is Called
    Then The Response Should Contain Xpay BNPL Account And Status Is Active
    And The Gateway Is Disabled

[TC-111] Features Response For User With 1pay And Xpay BNPL Account And RepaymentOption Is Xpay And Channel Is UPG And Amount Is Greater Than Credit Balance
    Given The User Has 1pay And 4pay Accounts
    And The Channel Is Set To UPG
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To Xpay
    And The Amount Is Set To Greater Than Credit Balance
    When The Features API Is Called
    Then The Response Should Contain Xpay BNPL Account And Status Is Active
    And The Gateway Is Disabled

#############    👆 happy path RepaymentOption Is Xpay and Channel is UPG    #############

#############    👇 Zero Credit Balance and RepaymentOption Is Xpay and Channel is UPG    #############

[TC-112] Features Response For User With 1pay BNPL Account (Zero Credit Balance) And RepaymentOption Is Xpay And Channel Is UPG
    Given The User Has 1pay Account
    And The Channel Is Set To UPG
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To Xpay
    And The Amount Is Set To Greater Than Credit Balance
    And Empty Balance
    When The Features API Is Called
    Then The Response Should Contain No Accounts
    And The Gateway Is Disabled

[TC-113] Features Response For User With Xpay BNPL Account (Zero Credit Balance) And RepaymentOption Is Xpay And Channel Is UPG
    Given The User Has 4pay Account
    And The Channel Is Set To UPG
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To Xpay
    And The Amount Is Set To Greater Than Credit Balance
    And Empty Balance
    When The Features API Is Called
    Then The Response Should Contain Xpay BNPL Account (Zero Credit Balance) And Status Is Active
    And The Gateway Is Disabled

[TC-114] Features Response For User With 1pay BNPL Account And Xpay BNPL Account (Zero Credit Balance) And RepaymentOption Is Xpay And Channel Is UPG
    Given The User Has 1pay And 4pay Accounts
    And The Channel Is Set To UPG
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To Xpay
    And The Amount Is Set To Greater Than Credit Balance
    And Empty Balance    credit_id=${credit_ids}[1]
    When The Features API Is Called
    Then The Response Should Contain Xpay BNPL Account (Zero Credit Balance) And Status Is Active
    And The Gateway Is Disabled

[TC-115] Features Response For User With 1pay BNPL Account (Zero Credit Balance) And Xpay BNPL Account And RepaymentOption Is Xpay And Channel Is UPG
    Given The User Has 1pay And 4pay Accounts
    And The Channel Is Set To UPG
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To Xpay
    And The Amount Is Set To Greater Than Credit Balance
    And Empty Balance    credit_id=${credit_ids}[0]
    When The Features API Is Called
    Then The Response Should Contain Xpay BNPL Account And Status Is Active
    And The Gateway Is Disabled

[TC-116] Features Response For User With 1pay BNPL Account (Zero Credit Balance) And Xpay BNPL Account (Zero Credit Balance) And RepaymentOption Is Xpay And Channel Is UPG
    Given The User Has 1pay And 4pay Accounts
    And The Channel Is Set To UPG
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To Xpay
    And The Amount Is Set To Greater Than Credit Balance
    And Empty Balance    credit_id=${credit_ids}[0]
    And Empty Balance    credit_id=${credit_ids}[1]
    When The Features API Is Called
    Then The Response Should Contain Xpay BNPL Account (Zero Credit Balance) And Status Is Active
    And The Gateway Is Disabled

#############    👆 Zero Credit Balance and RepaymentOption Is Xpay and Channel is UPG    #############

#############    👇 Expired and RepaymentOption Is Xpay and Channel is UPG    #############

[TC-117] Features Response For User With 1pay BNPL Account (Expired) And RepaymentOption Is Xpay And Channel Is UPG
    Given The User Has 1pay Account
    And The Channel Is Set To UPG
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To Xpay
    And The Amount Is Set To Greater Than Credit Balance
    And Empty Balance
    And Expire Account    credit_id=${credit_ids}[0]
    When The Features API Is Called
    Then The Response Should Contain No Accounts
    And The Gateway Is Disabled

[TC-118] Features Response For User With Xpay BNPL Account (Expired) And RepaymentOption Is Xpay And Channel Is UPG
    Given The User Has 4pay Account
    And The Channel Is Set To UPG
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To Xpay
    And The Amount Is Set To Greater Than Credit Balance
    And Empty Balance
    And Expire Account    credit_id=${credit_ids}[0]
    When The Features API Is Called
    Then The Response Should Contain 1pay BNPL Account And Status Is Inactive
    And The Gateway Is Disabled

[TC-119] Features Response For User With 1pay BNPL Account And Xpay BNPL Account (Expired) And RepaymentOption Is Xpay And Channel Is UPG
    Given The User Has 1pay And 4pay Accounts
    And The Channel Is Set To UPG
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To Xpay
    And The Amount Is Set To Greater Than Credit Balance
    And Empty Balance    credit_id=${credit_ids}[1]
    And Expire Account    credit_id=${credit_ids}[1]
    When The Features API Is Called
    Then The Response Should Contain Xpay BNPL Account And Status Is Inactive
    And The Gateway Is Disabled

[TC-120] Features Response For User With 1pay BNPL Account (Expired) And Xpay BNPL Account And RepaymentOption Is Xpay And Channel Is UPG
    Given The User Has 1pay And 4pay Accounts
    And The Channel Is Set To UPG
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To Xpay
    And The Amount Is Set To Greater Than Credit Balance
    And Empty Balance    credit_id=${credit_ids}[0]
    And Expire Account    credit_id=${credit_ids}[0]
    When The Features API Is Called
    Then The Response Should Contain Xpay BNPL Account And Status Is Active
    And The Gateway Is Disabled

[TC-121] Features Response For User With 1pay BNPL Account (Expired) And Xpay BNPL Account (Expired) And RepaymentOption Is Xpay And Channel Is UPG
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
    When The Features API Is Called
    Then The Response Should Contain Xpay BNPL Account And Status Is Inactive
    And The Gateway Is Disabled

#############    👆 Expired and RepaymentOption Is Xpay and Channel is UPG    #############

#############    👇 Blocked and RepaymentOption Is Xpay and Channel is UPG    #############

[TC-122] Features Response For User With Blocked 1pay BNPL Account And RepaymentOption Is Xpay And Channel Is UPG
    Given The User Has 1pay Account
    And The Channel Is Set To UPG
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To Xpay
    And The Amount Is Set To Greater Than Credit Balance
    And Block credit account
    When The Features API Is Called
    Then The Response Should Contain No Accounts
    And The Gateway Is Disabled

[TC-123] Features Response For User With Blocked Xpay BNPL Account And RepaymentOption Is Xpay And Channel Is UPG
    Given The User Has 4pay Account
    And The Channel Is Set To UPG
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To Xpay
    And The Amount Is Set To Greater Than Credit Balance
    And Block credit account
    When The Features API Is Called
    Then The Response Should Contain Xpay BNPL Account And Status Is Inactive
    And The Gateway Is Disabled

[TC-124] Features Response For User With 1pay BNPL Account And Blocked Xpay BNPL Account And RepaymentOption Is Xpay And Channel Is UPG
    Given The User Has 1pay And 4pay Accounts
    And The Channel Is Set To UPG
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To Xpay
    And The Amount Is Set To Greater Than Credit Balance
    And Block credit account    credit_id=${credit_ids}[1]
    When The Features API Is Called
    Then The Response Should Contain Xpay BNPL Account And Status Is Inactive
    And The Gateway Is Disabled

[TC-125] Features Response For User With Blocked 1pay BNPL Account And Xpay BNPL Account And RepaymentOption Is Xpay And Channel Is UPG
    Given The User Has 1pay And 4pay Accounts
    And The Channel Is Set To UPG
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To Xpay
    And The Amount Is Set To Greater Than Credit Balance
    And Block credit account    credit_id=${credit_ids}[0]
    When The Features API Is Called
    Then The Response Should Contain Xpay BNPL Account And Status Is Active
    And The Gateway Is Disabled

[TC-126] Features Response For User With Blocked 1pay BNPL Account And Blocked Xpay BNPL Account And RepaymentOption Is Xpay And Channel Is UPG
    Given The User Has 1pay And 4pay Accounts
    And The Channel Is Set To UPG
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To Xpay
    And The Amount Is Set To Greater Than Credit Balance
    And Block credit account    credit_id=${credit_ids}[0]
    And Block credit account    credit_id=${credit_ids}[1]
    When The Features API Is Called
    Then The Response Should Contain Xpay BNPL Account And Status Is Inactive
    And The Gateway Is Disabled

#############    👆 Blocked and RepaymentOption Is Xpay and Channel is UPG    #############

[TC-127] Features Response For User With Blocked 1pay BNPL Account And Expired Xpay BNPL Account And RepaymentOption Is Xpay And Channel Is UPG
    Given The User Has 1pay And 4pay Accounts
    And The Channel Is Set To UPG
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To Xpay
    And The Amount Is Set To Greater Than Credit Balance
    And Empty Balance    credit_id=${credit_ids}[1]
    And Expire Account    credit_id=${credit_ids}[1]
    And Block credit account    credit_id=${credit_ids}[0]
    When The Features API Is Called
    Then The Response Should Contain Blocked Account
    And The Gateway Is Disabled

#############    👇 happy path RepaymentOption Is Xpay and Channel is QR    #############

[TC-128] Features Response For User With 1pay BNPL Account RepaymentOption Is Xpay And Channel Is QR And Amount Is Equal To Credit Balance
    Given The User Has 1pay Account
    And The Channel Is Set To QR
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To Xpay
    And The Amount Is Set To Equal To Credit Balance
    When The Features API Is Called
    Then The Response Should Contain Empty List Of Features
    And The Gateway Is Disabled

[TC-129] Features Response For User With Xpay BNPL Account RepaymentOption Is Xpay And Channel Is QR And Amount Is Equal To Credit Balance
    Given The User Has 4pay Account
    And The Channel Is Set To QR
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To Xpay
    And The Amount Is Set To Equal To Credit Balance
    When The Features API Is Called
    Then The Response Should Contain Xpay BNPL Account And Status Is Active
    And The Gateway Is Disabled

[TC-130] Features Response For User With 1pay And Xpay BNPL Account And RepaymentOption Is Xpay And Channel Is QR And Amount Is Equal To Credit Balance
    Given The User Has 1pay And 4pay Accounts
    And The Channel Is Set To QR
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To Xpay
    And The Amount Is Set To Equal To Credit Balance
    When The Features API Is Called
    Then The Response Should Contain Xpay BNPL Account And Status Is Active
    And The Gateway Is Disabled

[TC-131] Features Response For User With 1pay BNPL Account RepaymentOption Is Xpay And Channel Is QR And Amount Is Little Than Credit Balance
    Given The User Has 1pay Account
    And The Channel Is Set To QR
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To Xpay
    And The Amount Is Set To Little Than Credit Balance
    When The Features API Is Called
    Then The Response Should Contain Empty List Of Features
    And The Gateway Is Disabled

[TC-132] Features Response For User With Xpay BNPL Account RepaymentOption Is Xpay And Channel Is QR And Amount Is Little Than Credit Balance
    Given The User Has 4pay Account
    And The Channel Is Set To QR
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To Xpay
    And The Amount Is Set To Little Than Credit Balance
    When The Features API Is Called
    Then The Response Should Contain Xpay BNPL Account And Status Is Active
    And The Gateway Is Disabled

[TC-133] Features Response For User With 1pay And Xpay BNPL Account And RepaymentOption Is Xpay And Channel Is QR And Amount Is Little Than Credit Balance
    Given The User Has 1pay And 4pay Accounts
    And The Channel Is Set To QR
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To Xpay
    And The Amount Is Set To Little Than Credit Balance
    When The Features API Is Called
    Then The Response Should Contain Xpay BNPL Account And Status Is Active
    And The Gateway Is Disabled

[TC-134] Features Response For User With 1pay BNPL Account RepaymentOption Is Xpay And Channel Is QR And Amount Is Greater Than Credit Balance
    Given The User Has 1pay Account
    And The Channel Is Set To QR
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To Xpay
    And The Amount Is Set To Greater Than Credit Balance
    When The Features API Is Called
    Then The Response Should Contain Empty List Of Features
    And The Gateway Is Disabled

[TC-135] Features Response For User With Xpay BNPL Account RepaymentOption Is Xpay And Channel Is QR And Amount Is Greater Than Credit Balance
    Given The User Has 4pay Account
    And The Channel Is Set To QR
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To Xpay
    And The Amount Is Set To Greater Than Credit Balance
    When The Features API Is Called
    Then The Response Should Contain Xpay BNPL Account And Status Is Active
    And The Gateway Is Disabled

[TC-136] Features Response For User With 1pay And Xpay BNPL Account And RepaymentOption Is Xpay And Channel Is QR And Amount Is Greater Than Credit Balance
    Given The User Has 1pay And 4pay Accounts
    And The Channel Is Set To QR
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To Xpay
    And The Amount Is Set To Greater Than Credit Balance
    When The Features API Is Called
    Then The Response Should Contain Xpay BNPL Account And Status Is Active
    And The Gateway Is Disabled

#############    👆 happy path RepaymentOption Is Xpay and Channel is QR    #############

#############    👇 Zero Credit Balance and RepaymentOption Is Xpay and Channel is QR    #############

[TC-137] Features Response For User With 1pay BNPL Account (Zero Credit Balance) And RepaymentOption Is Xpay And Channel Is QR
    Given The User Has 1pay Account
    And The Channel Is Set To QR
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To Xpay
    And The Amount Is Set To Greater Than Credit Balance
    And Empty Balance
    When The Features API Is Called
    Then The Response Should Contain Empty List Of Features
    And The Gateway Is Disabled

[TC-138] Features Response For User With Xpay BNPL Account (Zero Credit Balance) And RepaymentOption Is Xpay And Channel Is QR
    Given The User Has 4pay Account
    And The Channel Is Set To QR
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To Xpay
    And The Amount Is Set To Greater Than Credit Balance
    And Empty Balance
    When The Features API Is Called
    Then The Response Should Contain Xpay BNPL Account (Zero Credit Balance) And Status Is Active
    And The Gateway Is Disabled

[TC-139] Features Response For User With 1pay BNPL Account And Xpay BNPL Account (Zero Credit Balance) And RepaymentOption Is Xpay And Channel Is QR
    Given The User Has 1pay And 4pay Accounts
    And The Channel Is Set To QR
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To Xpay
    And The Amount Is Set To Greater Than Credit Balance
    And Empty Balance    credit_id=${credit_ids}[1]
    When The Features API Is Called
    Then The Response Should Contain Xpay BNPL Account (Zero Credit Balance) And Status Is Active
    And The Gateway Is Disabled

[TC-140] Features Response For User With 1pay BNPL Account (Zero Credit Balance) And Xpay BNPL Account And RepaymentOption Is Xpay And Channel Is QR
    Given The User Has 1pay And 4pay Accounts
    And The Channel Is Set To QR
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To Xpay
    And The Amount Is Set To Greater Than Credit Balance
    And Empty Balance    credit_id=${credit_ids}[0]
    When The Features API Is Called
    Then The Response Should Contain Xpay BNPL Account And Status Is Active
    And The Gateway Is Disabled

[TC-141] Features Response For User With 1pay BNPL Account (Zero Credit Balance) And Xpay BNPL Account (Zero Credit Balance) And RepaymentOption Is Xpay And Channel Is QR
    Given The User Has 1pay And 4pay Accounts
    And The Channel Is Set To QR
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To Xpay
    And The Amount Is Set To Greater Than Credit Balance
    And Empty Balance    credit_id=${credit_ids}[0]
    And Empty Balance    credit_id=${credit_ids}[1]
    When The Features API Is Called
    Then The Response Should Contain Xpay BNPL Account (Zero Credit Balance) And Status Is Active
    And The Gateway Is Disabled

#############    👆 Zero Credit Balance and RepaymentOption Is Xpay and Channel is QR    #############

#############    👇 Expired and RepaymentOption Is Xpay and Channel is QR    #############

[TC-142] Features Response For User With 1pay BNPL Account (Expired) And RepaymentOption Is Xpay And Channel Is QR
    Given The User Has 1pay Account
    And The Channel Is Set To QR
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To Xpay
    And The Amount Is Set To Greater Than Credit Balance
    And Empty Balance
    And Expire Account    credit_id=${credit_ids}[0]
    When The Features API Is Called
    Then The Response Should Contain Empty List Of Features
    And The Gateway Is Disabled

[TC-143] Features Response For User With Xpay BNPL Account (Expired) And RepaymentOption Is Xpay And Channel Is QR
    Given The User Has 4pay Account
    And The Channel Is Set To QR
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To Xpay
    And The Amount Is Set To Greater Than Credit Balance
    And Empty Balance
    And Expire Account    credit_id=${credit_ids}[0]
    When The Features API Is Called
    Then The Response Should Contain 1pay BNPL Account And Status Is Inactive
    And The Gateway Is Disabled

[TC-144] Features Response For User With 1pay BNPL Account And Xpay BNPL Account (Expired) And RepaymentOption Is Xpay And Channel Is QR
    Given The User Has 1pay And 4pay Accounts
    And The Channel Is Set To QR
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To Xpay
    And The Amount Is Set To Greater Than Credit Balance
    And Empty Balance    credit_id=${credit_ids}[1]
    And Expire Account    credit_id=${credit_ids}[1]
    When The Features API Is Called
    Then The Response Should Contain 1pay BNPL Account And Status Is Inactive
    And The Gateway Is Disabled

[TC-145] Features Response For User With 1pay BNPL Account (Expired) And Xpay BNPL Account And RepaymentOption Is Xpay And Channel Is QR
    Given The User Has 1pay And 4pay Accounts
    And The Channel Is Set To QR
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To Xpay
    And The Amount Is Set To Greater Than Credit Balance
    And Empty Balance    credit_id=${credit_ids}[0]
    And Expire Account    credit_id=${credit_ids}[0]
    When The Features API Is Called
    Then The Response Should Contain Xpay BNPL Account And Status Is Active
    And The Gateway Is Disabled

[TC-146] Features Response For User With 1pay BNPL Account (Expired) And Xpay BNPL Account (Expired) And RepaymentOption Is Xpay And Channel Is QR
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
    When The Features API Is Called
    Then The Response Should Contain Xpay BNPL Account And Status Is Inactive
    And The Gateway Is Disabled

#############    👆 Expired and RepaymentOption Is Xpay and Channel is QR    #############

#############    👇 Blocked and RepaymentOption Is Xpay and Channel is QR    #############

[TC-147] Features Response For User With Blocked 1pay BNPL Account And RepaymentOption Is Xpay And Channel Is QR
    Given The User Has 1pay Account
    And The Channel Is Set To QR
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To Xpay
    And The Amount Is Set To Greater Than Credit Balance
    And Block credit account
    When The Features API Is Called
    Then The Response Should Contain Empty List Of Features
    And The Gateway Is Disabled

[TC-148] Features Response For User With Blocked Xpay BNPL Account And RepaymentOption Is Xpay And Channel Is QR
    Given The User Has 4pay Account
    And The Channel Is Set To QR
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To Xpay
    And The Amount Is Set To Greater Than Credit Balance
    And Block credit account
    When The Features API Is Called
    Then The Response Should Contain Xpay BNPL Account And Status Is Inactive
    And The Gateway Is Disabled

[TC-149] Features Response For User With 1pay BNPL Account And Blocked Xpay BNPL Account And RepaymentOption Is Xpay And Channel Is QR
    Given The User Has 1pay And 4pay Accounts
    And The Channel Is Set To QR
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To Xpay
    And The Amount Is Set To Greater Than Credit Balance
    And Block credit account    credit_id=${credit_ids}[1]
    When The Features API Is Called
    Then The Response Should Contain Xpay BNPL Account And Status Is Inactive
    And The Gateway Is Disabled

[TC-150] Features Response For User With Blocked 1pay BNPL Account And Xpay BNPL Account And RepaymentOption Is Xpay And Channel Is QR
    Given The User Has 1pay And 4pay Accounts
    And The Channel Is Set To QR
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To Xpay
    And The Amount Is Set To Greater Than Credit Balance
    And Block credit account    credit_id=${credit_ids}[0]
    When The Features API Is Called
    Then The Response Should Contain Xpay BNPL Account And Status Is Active
    And The Gateway Is Disabled

[TC-151] Features Response For User With Blocked 1pay BNPL Account And Blocked Xpay BNPL Account And RepaymentOption Is Xpay And Channel Is QR
    Given The User Has 1pay And 4pay Accounts
    And The Channel Is Set To QR
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To Xpay
    And The Amount Is Set To Greater Than Credit Balance
    And Block credit account    credit_id=${credit_ids}[0]
    And Block credit account    credit_id=${credit_ids}[1]
    When The Features API Is Called
    Then The Response Should Contain Xpay BNPL Account And Status Is Inactive
    And The Gateway Is Disabled

#############    👆 Blocked and RepaymentOption Is Xpay and Channel is QR    #############

[TC-152] Features Response For User With Blocked 1pay BNPL Account And Expired Xpay BNPL Account And RepaymentOption Is Xpay And Channel Is QR
    Given The User Has 1pay And 4pay Accounts
    And The Channel Is Set To QR
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To Xpay
    And The Amount Is Set To Greater Than Credit Balance
    And Empty Balance    credit_id=${credit_ids}[1]
    And Expire Account    credit_id=${credit_ids}[1]
    And Block credit account    credit_id=${credit_ids}[0]
    When The Features API Is Called
    Then The Response Should Contain Xpay BNPL Account And Status Is Inactive
    And The Gateway Is Disabled

#############    BNPL    #############

#############    C-Credit    #############

#############    👇 RepaymentOption Is Xpay and Channel is QR    #############

[TC-153] Features Response For User With Credit Account And RepaymentOption Is Xpay And Channel Is QR And Amount Is Equal To Credit Balance
    Given The User Has Credit Account
    And The Channel Is Set To QR
    And The Ticket Type Is Set To Credit
    And The Payment Gateway Is Set To CPG
    And The Gateway RepaymentOption Is Set To Xpay
    And The Amount Is Set To Equal To Credit Balance
    When The Features API Is Called
    Then The Response Should Contain Credit Account And Status Is Active
    And The Gateway Is Disabled

[TC-154] Features Response For User With Credit Account And RepaymentOption Is Xpay And Channel Is QR And Amount Is Greater Than Credit Balance
    Given The User Has Credit Account
    And The Channel Is Set To QR
    And The Ticket Type Is Set To Credit
    And The Payment Gateway Is Set To CPG
    And The Gateway RepaymentOption Is Set To Xpay
    And The Amount Is Set To Greater Than Credit Balance
    When The Features API Is Called
    Then The Response Should Contain Credit Account And Status Is Active
    And The Gateway Is Disabled

[TC-155] Features Response For User With Credit Account And RepaymentOption Is Xpay And Channel Is QR And Amount Is Little Than Credit Balance
    Given The User Has Credit Account
    And The Channel Is Set To QR
    And The Ticket Type Is Set To Credit
    And The Payment Gateway Is Set To CPG
    And The Gateway RepaymentOption Is Set To Xpay
    And The Amount Is Set To Little Than Credit Balance
    When The Features API Is Called
    Then The Response Should Contain Credit Account And Status Is Active
    And The Gateway Is Disabled

[TC-156] Features Response For User With Credit Account (Zero Credit Balance) And RepaymentOption Is Xpay And Channel Is QR
    Given The User Has Credit Account
    And The Channel Is Set To QR
    And The Ticket Type Is Set To Credit
    And The Payment Gateway Is Set To CPG
    And The Gateway RepaymentOption Is Set To Xpay
    And The Amount Is Set To Greater Than Credit Balance
    And Empty Balance
    When The Features API Is Called
    Then The Response Should Contain Blocked Or Expired Credit Account
    And The Gateway Is Disabled

[TC-157] Features Response For User With Credit Account (Expired) And Xpay Credit Account And RepaymentOption Is Xpay And Channel Is QR
    Given The User Has Credit Account
    And The Channel Is Set To QR
    And The Ticket Type Is Set To Credit
    And The Payment Gateway Is Set To CPG
    And The Gateway RepaymentOption Is Set To Xpay
    And The Amount Is Set To Greater Than Credit Balance
    And Empty Balance
    And Expire Account
    When The Features API Is Called
    Then The Response Should Contain Empty List Of Features
    And The Gateway Is Disabled

[TC-158] Features Response For User With Blocked Credit Account And Blocked Xpay Credit Account And RepaymentOption Is Xpay And Channel Is QR
    Given The User Has Credit Account
    And The Channel Is Set To QR
    And The Ticket Type Is Set To Credit
    And The Payment Gateway Is Set To CPG
    And The Gateway RepaymentOption Is Set To Xpay
    And The Amount Is Set To Greater Than Credit Balance
    And Block credit account
    When The Features API Is Called
    Then The Response Should Contain Blocked Or Expired Credit Account
    And The Gateway Is Disabled

#############    👆 RepaymentOption Is Xpay and Channel is QR    #############

#############    👇 RepaymentOption Is Xpay and Channel is UPG    #############

[TC-159] Features Response For User With Credit Account And RepaymentOption Is Xpay And Channel Is UPG And Amount Is Equal To Credit Balance
    Given The User Has Credit Account
    And The Channel Is Set To UPG
    And The Ticket Type Is Set To Credit
    And The Payment Gateway Is Set To CPG
    And The Gateway RepaymentOption Is Set To Xpay
    And The Amount Is Set To Equal To Credit Balance
    When The Features API Is Called
    Then The Response Should Contain Credit Account And Status Is Active
    And The Gateway Is Disabled

[TC-160] Features Response For User With Credit Account And RepaymentOption Is Xpay And Channel Is UPG And Amount Is Greater Than Credit Balance
    Given The User Has Credit Account
    And The Channel Is Set To UPG
    And The Ticket Type Is Set To Credit
    And The Payment Gateway Is Set To CPG
    And The Gateway RepaymentOption Is Set To Xpay
    And The Amount Is Set To Greater Than Credit Balance
    When The Features API Is Called
    Then The Response Should Contain Credit Account And Status Is Active
    And The Gateway Is Disabled

[TC-161] Features Response For User With Credit Account And RepaymentOption Is Xpay And Channel Is UPG And Amount Is Little Than Credit Balance
    Given The User Has Credit Account
    And The Channel Is Set To UPG
    And The Ticket Type Is Set To Credit
    And The Payment Gateway Is Set To CPG
    And The Gateway RepaymentOption Is Set To Xpay
    And The Amount Is Set To Little Than Credit Balance
    When The Features API Is Called
    Then The Response Should Contain Credit Account And Status Is Active
    And The Gateway Is Disabled

[TC-162] Features Response For User With Credit Account (Zero Credit Balance) And RepaymentOption Is Xpay And Channel Is UPG
    Given The User Has Credit Account
    And The Channel Is Set To UPG
    And The Ticket Type Is Set To Credit
    And The Payment Gateway Is Set To CPG
    And The Gateway RepaymentOption Is Set To Xpay
    And The Amount Is Set To Greater Than Credit Balance
    And Empty Balance
    When The Features API Is Called
    Then The Response Should Contain Blocked Or Expired Credit Account
    And The Gateway Is Disabled

[TC-163] Features Response For User With Credit Account (Expired) And Xpay Credit Account And RepaymentOption Is Xpay And Channel Is UPG
    Given The User Has Credit Account
    And The Channel Is Set To UPG
    And The Ticket Type Is Set To Credit
    And The Payment Gateway Is Set To CPG
    And The Gateway RepaymentOption Is Set To Xpay
    And The Amount Is Set To Greater Than Credit Balance
    And Empty Balance
    And Expire Account
    When The Features API Is Called
    Then The Response Should Contain Empty List Of Features
    And The Gateway Is Disabled

[TC-164] Features Response For User With Blocked Credit Account And Blocked Xpay Credit Account And RepaymentOption Is Xpay And Channel Is UPG
    Given The User Has Credit Account
    And The Channel Is Set To UPG
    And The Ticket Type Is Set To Credit
    And The Payment Gateway Is Set To CPG
    And The Gateway RepaymentOption Is Set To Xpay
    And The Amount Is Set To Greater Than Credit Balance
    And Block credit account
    When The Features API Is Called
    Then The Response Should Contain Blocked Or Expired Credit Account
    And The Gateway Is Disabled

#############    👆 RepaymentOption Is Xpay and Channel is UPG    #############

#############    👇 RepaymentOption Is 1pay and Xpay and Channel is QR    #############

[TC-165] Features Response For User With Credit Account And RepaymentOption Is 1pay and Xpay And Channel Is QR And Amount Is Equal To Credit Balance
    Given The User Has Credit Account
    And The Channel Is Set To QR
    And The Ticket Type Is Set To Credit
    And The Payment Gateway Is Set To CPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And The Amount Is Set To Equal To Credit Balance
    When The Features API Is Called
    Then The Response Should Contain Credit Account And Status Is Active
    And The Gateway Is Disabled

[TC-166] Features Response For User With Credit Account And RepaymentOption Is 1pay and Xpay And Channel Is QR And Amount Is Greater Than Credit Balance
    Given The User Has Credit Account
    And The Channel Is Set To QR
    And The Ticket Type Is Set To Credit
    And The Payment Gateway Is Set To CPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And The Amount Is Set To Greater Than Credit Balance
    When The Features API Is Called
    Then The Response Should Contain Credit Account And Status Is Active
    And The Gateway Is Disabled

[TC-167] Features Response For User With Credit Account And RepaymentOption Is 1pay and Xpay And Channel Is QR And Amount Is Little Than Credit Balance
    Given The User Has Credit Account
    And The Channel Is Set To QR
    And The Ticket Type Is Set To Credit
    And The Payment Gateway Is Set To CPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And The Amount Is Set To Little Than Credit Balance
    When The Features API Is Called
    Then The Response Should Contain Credit Account And Status Is Active
    And The Gateway Is Disabled

[TC-168] Features Response For User With Credit Account (Zero Credit Balance) And RepaymentOption Is 1pay and Xpay And Channel Is QR
    Given The User Has Credit Account
    And The Channel Is Set To QR
    And The Ticket Type Is Set To Credit
    And The Payment Gateway Is Set To CPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And The Amount Is Set To Greater Than Credit Balance
    And Empty Balance
    When The Features API Is Called
    Then The Response Should Contain Blocked Or Expired Credit Account
    And The Gateway Is Disabled

[TC-169] Features Response For User With Credit Account (Expired) And Xpay Credit Account And RepaymentOption Is 1pay and Xpay And Channel Is QR
    Given The User Has Credit Account
    And The Channel Is Set To QR
    And The Ticket Type Is Set To Credit
    And The Payment Gateway Is Set To CPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And The Amount Is Set To Greater Than Credit Balance
    And Empty Balance
    And Expire Account
    When The Features API Is Called
    Then The Response Should Contain Empty List Of Features
    And The Gateway Is Disabled

[TC-170] Features Response For User With Blocked Credit Account And Blocked Xpay Credit Account And RepaymentOption Is 1pay and Xpay And Channel Is QR
    Given The User Has Credit Account
    And The Channel Is Set To QR
    And The Ticket Type Is Set To Credit
    And The Payment Gateway Is Set To CPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And The Amount Is Set To Greater Than Credit Balance
    And Block credit account
    When The Features API Is Called
    Then The Response Should Contain Blocked Or Expired Credit Account
    And The Gateway Is Disabled

#############    👆 RepaymentOption Is 1pay and Xpay and Channel is QR    #############

#############    👇 RepaymentOption Is 1pay and Xpay and Channel is UPG    #############

[TC-171] Features Response For User With Credit Account And RepaymentOption Is 1pay and Xpay And Channel Is UPG And Amount Is Equal To Credit Balance
    Given The User Has Credit Account
    And The Channel Is Set To UPG
    And The Ticket Type Is Set To Credit
    And The Payment Gateway Is Set To CPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And The Amount Is Set To Equal To Credit Balance
    When The Features API Is Called
    Then The Response Should Contain Credit Account And Status Is Active
    And The Gateway Is Disabled

[TC-172] Features Response For User With Credit Account And RepaymentOption Is 1pay and Xpay And Channel Is UPG And Amount Is Greater Than Credit Balance
    Given The User Has Credit Account
    And The Channel Is Set To UPG
    And The Ticket Type Is Set To Credit
    And The Payment Gateway Is Set To CPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And The Amount Is Set To Greater Than Credit Balance
    When The Features API Is Called
    Then The Response Should Contain Credit Account And Status Is Active
    And The Gateway Is Disabled

[TC-173] Features Response For User With Credit Account And RepaymentOption Is 1pay and Xpay And Channel Is UPG And Amount Is Little Than Credit Balance
    Given The User Has Credit Account
    And The Channel Is Set To UPG
    And The Ticket Type Is Set To Credit
    And The Payment Gateway Is Set To CPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And The Amount Is Set To Little Than Credit Balance
    When The Features API Is Called
    Then The Response Should Contain Credit Account And Status Is Active
    And The Gateway Is Disabled

[TC-174] Features Response For User With Credit Account (Zero Credit Balance) And RepaymentOption Is 1pay and Xpay And Channel Is UPG
    Given The User Has Credit Account
    And The Channel Is Set To UPG
    And The Ticket Type Is Set To Credit
    And The Payment Gateway Is Set To CPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And The Amount Is Set To Greater Than Credit Balance
    And Empty Balance
    When The Features API Is Called
    Then The Response Should Contain Blocked Or Expired Credit Account
    And The Gateway Is Disabled

[TC-175] Features Response For User With Credit Account (Expired) And Xpay Credit Account And RepaymentOption Is 1pay and Xpay And Channel Is UPG
    Given The User Has Credit Account
    And The Channel Is Set To UPG
    And The Ticket Type Is Set To Credit
    And The Payment Gateway Is Set To CPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And The Amount Is Set To Greater Than Credit Balance
    And Empty Balance
    And Expire Account
    When The Features API Is Called
    Then The Response Should Contain Empty List Of Features
    And The Gateway Is Disabled

[TC-176] Features Response For User With Blocked Credit Account And Blocked Xpay Credit Account And RepaymentOption Is 1pay and Xpay And Channel Is UPG
    Given The User Has Credit Account
    And The Channel Is Set To UPG
    And The Ticket Type Is Set To Credit
    And The Payment Gateway Is Set To CPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And The Amount Is Set To Greater Than Credit Balance
    And Block credit account
    When The Features API Is Called
    Then The Response Should Contain Blocked Or Expired Credit Account
    And The Gateway Is Disabled

#############    👆 RepaymentOption Is 1pay and Xpay and Channel is UPG    #############

#############    👇 RepaymentOption Is 1pay and Channel is UPG    #############

[TC-177] Features Response For User With Credit Account And RepaymentOption Is 1pay And Channel Is UPG
    Given The User Has Credit Account
    And The Channel Is Set To UPG
    And The Ticket Type Is Set To Credit
    And The Payment Gateway Is Set To CPG
    And The Amount Is Set To Little Than Credit Balance
    When The Features API Is Called
    Then The Response Should Contain Empty List Of Features
    And The Gateway Is Disabled

[TC-178] Features Response For User With Credit Account And RepaymentOption Is 1pay And Channel Is QR
    Given The User Has Credit Account
    And The Channel Is Set To QR
    And The Ticket Type Is Set To Credit
    And The Payment Gateway Is Set To CPG
    And The Amount Is Set To Little Than Credit Balance
    When The Features API Is Called
    Then The Response Should Contain Empty List Of Features
    And The Gateway Is Disabled

#############    👆 RepaymentOption Is 1pay and Channel is UPG    #############

#############    C-Credit    #############

#############    BNPL 1pay Balance Is Greater Than 4pay BNPL Balance    #############

[TC-179] Features Response For User With BNPL 1pay Balance Is Greater Than 4pay BNPL Balance And RepaymentOption Is 1pay And Xpay And Channel Is UPG And Amount Is Equal To Credit Balance
    Given The User Has BNPL 1pay Balance Is Greater Than 4pay BNPL Balance
    And The Channel Is Set To UPG
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And The Amount Is Set To Equal To Credit Balance
    When The Features API Is Called
    Then The Response Should Contain 1pay BNPL Account And Status Is Active
    And The Gateway Is Disabled

[TC-180] Features Response For User With Schedule Close 1pay BNPL Account And RepaymentOption Is 1pay And Xpay And Channel Is UPG
    Given The User Has 1pay Account
    And The Channel Is Set To UPG
    And The Ticket Type Is Set To BNPL
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And The Amount Is Set To Greater Than Credit Balance
    And Call Schedule Close API
    When The Features API Is Called
    Then The Response Should Contain 1pay BNPL Account And Status Is Inactive
    And The Gateway Is Disabled