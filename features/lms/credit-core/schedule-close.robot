*** Settings ***
Resource            steps/LMS/credit-core/schedule-close-step.resource

Test Setup          Initialize Merchant
Test Teardown       Reproduce Amount


*** Test Cases ***
[TC-001] Make A schedule-close 1pay BNPL Account
    [Tags]    bnpl-1pay
    Given Allocate No Fee BNPL Account(1pay)
    And The Channel Is Set To Linux POS
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And The Gateway Is Activated
    And The Amount Is Set To Equal To Credit Balance
    And Complete A Offline Purchase
    When Call Schedule Close API
    And Make Account Closable
    And Expire Account
    Then The Response Schedule Close API Should Be Successful
    And Check Credit Account Mng DB Account Manual Closes
    And Check The Account Should Be Closed
    And The Gateway Is Disabled

[TC-002] Make A schedule-close Xpay BNPL Account
    [Tags]    bnpl-xpay
    Given Allocate No Fee BNPL Account(xpay)
    And The Channel Is Set To Linux POS
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And The Gateway Is Activated
    And The Amount Is Set To Equal To Credit Balance
    And Complete A Offline Purchase
    When Call Schedule Close API
    And Make Account Closable
    And Expire Account
    Then The Response Schedule Close API Should Be Successful
    And Check Credit Account Mng DB Account Manual Closes
    And Check The Account Should Be Closed
    And The Gateway Is Disabled

[TC-003] Make A schedule-close C-Credit Account
    [Tags]    C-Credit
    Given Allocate No Fee CCredit Account
    And The Channel Is Set To Linux POS
    And The Payment Gateway Is Set To CPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And The Gateway Is Activated
    And The Amount Is Set To Equal To Credit Balance
    And Complete A Offline Purchase
    When Call Schedule Close API
    And Make Account Closable
    Then The Response Schedule Close API Should Be Successful
    And Check Credit Account Mng DB Account Manual Closes
    And Check The Account Should Be Closed
    And The Gateway Is Disabled

[TC-004] Make A schedule-close Installment Sale Account
    [Tags]    installment-sale
    Given Allocate No Fee Installment Sale Account
    And The Channel Is Set To Linux POS
    And The Payment Gateway Is Set To ISPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And The Gateway Is Activated
    And The Amount Is Set To Equal To Credit Balance
    And Complete A Offline Purchase
    When Call Schedule Close API
    And Make Account Closable
    Then The Response Schedule Close API Should Be Successful
    And Check Credit Account Mng DB Account Manual Closes
    And Check The Account Should Be Closed
    And The Gateway Is Disabled