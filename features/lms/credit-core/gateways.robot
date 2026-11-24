*** Settings ***
Resource        steps/LMS/credit-core/gateways-step.resource

Test Setup      Initialize Merchant


*** Test Cases ***
[TC-001] Active Gateway On Channel UPG And Repayment Option is 1pay And Xpay
    Given The Channel Is Set To UPG
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    When The Gateway Is Activated
    Then Check Gateways Collection In Credit Merchant Mng
    And Check Gateway Configs Collection In Credit Merchant Mng
    And Status Code Must Be 200
    And The Gateway Is Disabled
