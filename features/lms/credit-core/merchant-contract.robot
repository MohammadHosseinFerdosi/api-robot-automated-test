*** Settings ***
Resource    steps/LMS/credit-core/merchant-contract-activate-step.resource


*** Test Cases ***
[TC-001] Call credit gateway activate for merchant on channel Linux POS and C-Credit payment gateway
    Given Disable Credit Gateway For Merchant On Channel UPG And C-Credit Payment Gateway
    When Credit Gateway Activate For Merchant On Channel UPG And C-Credit Payment Gateway
    Then Credit Gateway Should Be Activated For Merchant On Channel UPG And C-Credit Payment Gateway
    And Disable Credit Gateway For Merchant On Channel UPG And C-Credit Payment Gateway
