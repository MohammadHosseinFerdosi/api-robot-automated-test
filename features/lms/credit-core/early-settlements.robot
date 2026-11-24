*** Settings ***
Resource            steps/LMS/credit-core/early-settlements-steps.resource

Test Setup          Initialize Merchant
Test Teardown       Reproduce Amount


*** Test Cases ***
[TC-001] BNPL 1PAY Early Settlement Pay Via Wallet
    Given Allocate No Fee 1PAY Account
    And Set Repayment Option 1PAY And XPAY
    And Set channel SMART_POS
    And Set Payment Gateway BPG
    And Activate All Gateways
    And Set Amount Less Than Balance
    And Perform An Offline Purchase
    When Fully Pay The Early Settlement
    Then Early Settlement Status Must Be Confirmed
    And Early Settlement Amount Must Have Been Revolved
    And Credit Gateway Disable

[TC-002] BNPL XPAY Early Settlement Pay Via Wallet
    Given Allocate No Fee XPAY Account
    And Set Repayment Option 1PAY And XPAY
    And Set channel SMART_POS
    And Set Payment Gateway BPG
    And Activate All Gateways
    And Set Amount Less Than Balance
    And Perform An Offline Purchase
    When Fully Pay The Early Settlement
    Then Early Settlement Status Must Be Confirmed
    And Early Settlement Amount Must Have Been Revolved
    And Credit Gateway Disable
