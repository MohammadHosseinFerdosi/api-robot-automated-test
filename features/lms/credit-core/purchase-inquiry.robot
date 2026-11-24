*** Settings ***
Resource            steps/LMS/credit-core/purchase-inquiry-steps.resource

Test Setup          Initialize Merchant
Test Teardown       Reproduce Amount


*** Test Cases ***
[TC-001] Purchase Inquiry While The Business Id Does Not Exist
    Given Allocate No Fee 1PAY Account
    And Set channel UPG
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway BPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When Performed A Delivered Online Purchase
    And The Purchase Inquiry Is Called    business_id=UUID4_THIS_BUSINESS_DOES_NOT_EXIST
    Then The Purchase Inquiry Should Have Failed
    And The Purchase Inquiry Error Should Be Inconsistent Purchase
    And Credit Gateway Disable

[TC-002] Purchase Inquiry While The Business Id Does Not Match With The Provider Id
    Given Allocate No Fee 1PAY Account
    And Set channel UPG
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway BPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When Performed A Delivered Online Purchase
    And The Purchase Inquiry Is Called    business_id=${COMPANY_USER_ID}
    Then The Purchase Inquiry Should Have Failed
    And The Purchase Inquiry Error Should Be Inconsistent Purchase
    And Credit Gateway Disable

[TC-003] Purchase Inquiry While The Provider Id Does Not Match With The Tracking Code
    Given Allocate No Fee 1PAY Account
    And Set channel UPG
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway BPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When Performed A Delivered Online Purchase
    And The Purchase Inquiry Is Called    provider_id=THIS_PROVIDER_ID_DOES_NOT_MATCH
    Then The Purchase Inquiry Should Have Failed
    And The Purchase Inquiry Error Should Be Purchase Not Found
    And Credit Gateway Disable

[TC-004] Purchase Inquiry While The Purchase Is Initiated [After Ticket]
    Given Allocate No Fee 1PAY Account
    And Set channel QR
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway BPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When Performed An Initiated Online Purchase
    And The Purchase Inquiry Is Called
    Then The Purchase Inquiry Should Have Succeeded
    And The Purchase Inquiry Status Must Be    expected_status=0
    And The Purchase Inquiry Fields Should Be Consistent
    And Credit Gateway Disable

[TC-005] Purchase Inquiry While The Purchase Is Initiated [After Ticket With Prepayment]
    Given Allocate Fee On Purchase XPAY Account
    And Set channel UPG
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway BPG
    And Credit Gateway Activate
    And Set Amount Over Balance
    When Performed An Initiated Online Purchase
    And The Purchase Inquiry Is Called
    Then The Purchase Inquiry Should Have Succeeded
    And The Purchase Inquiry Status Must Be    expected_status=0
    And The Purchase Inquiry Fields Should Be Consistent
    And Credit Gateway Disable

[TC-006] Purchase Inquiry While The Purchase Is Initiated [After Prepare]
    Given Allocate No Fee 1PAY Account
    And Set channel UPG
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway BPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When Performed A Prepared Online Purchase
    And The Purchase Inquiry Is Called
    Then The Purchase Inquiry Should Have Succeeded
    And The Purchase Inquiry Status Must Be    expected_status=0
    And The Purchase Inquiry Fields Should Be Consistent
    And Credit Gateway Disable

[TC-007] Purchase Inquiry While The Purchase Is Initiated [After Route Info]
    Given Allocate No Fee CCREDIT Account
    And Set channel PAYMENT_LINK
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway CPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When Performed A Routed Online Purchase
    And The Purchase Inquiry Is Called
    Then The Purchase Inquiry Should Have Succeeded
    And The Purchase Inquiry Status Must Be    expected_status=0
    And The Purchase Inquiry Fields Should Be Consistent
    And Credit Gateway Disable

[TC-008] Purchase Inquiry While The Purchase Is Initiated [Offline]
    Given Allocate No Fee INSTALLMENT SALES Account
    And Set channel API
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway ISPG
    And Credit Gateway Activate
    And Set Amount Equal To Balance
    When Performed An Initiated Offline Purchase
    And The Purchase Inquiry Is Called
    Then The Purchase Inquiry Should Have Succeeded
    And The Purchase Inquiry Status Must Be    expected_status=0
    And The Purchase Inquiry Fields Should Be Consistent
    And Credit Gateway Disable

[TC-009] Purchase Inquiry While The Purchase Is Paid [Offline]
    Given Allocate Fee On Purchase CCREDIT Account
    And Set channel SMART_POS
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway CPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When Performed A Paid Offline Purchase
    And The Purchase Inquiry Is Called
    Then The Purchase Inquiry Should Have Succeeded
    And The Purchase Inquiry Status Must Be    expected_status=0
    And The Purchase Inquiry Fields Should Be Consistent
    And Credit Gateway Disable

[TC-010] Purchase Inquiry While The Purchase Is Verified [Online]
    Given Allocate No Fee CCREDIT Account
    And Set channel UPG
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway CPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When Performed A Verified Online Purchase
    And The Purchase Inquiry Is Called
    Then The Purchase Inquiry Should Have Succeeded
    And The Purchase Inquiry Status Must Be    expected_status=1
    And The Purchase Inquiry Fields Should Be Consistent
    And Credit Gateway Disable

[TC-011] Purchase Inquiry While The Purchase Is Delivered [Offline]
    Given Allocate Fee On Purchase XPAY Account
    And Set channel LINUX_POS
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway BPG
    And Credit Gateway Activate
    And Set Amount Over Balance
    When Performed A Delivered Offline Purchase
    And The Purchase Inquiry Is Called
    Then The Purchase Inquiry Should Have Succeeded
    And The Purchase Inquiry Status Must Be    expected_status=2
    And The Purchase Inquiry Fields Should Be Consistent
    And Credit Gateway Disable

[TC-012] Purchase Inquiry While The Purchase Is Expired [After Ticket]
    Given Allocate No Fee 1PAY Account
    And Set channel UPG
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway BPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When Performed An Initiated Online Purchase
    And Expire The Online Purchase
    And The Purchase Inquiry Is Called
    Then The Purchase Inquiry Should Have Succeeded
    And The Purchase Inquiry Status Must Be    expected_status=4
    And The Purchase Inquiry Fields Should Be Consistent
    And Credit Gateway Disable

[TC-013] Purchase Inquiry While The Purchase Is Expired [After Prepare]
    Given Allocate No Fee 1PAY Account
    And Set channel PAYMENT_LINK
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway BPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When Performed A Prepared Online Purchase
    And Expire The Online Purchase
    And The Purchase Inquiry Is Called
    Then The Purchase Inquiry Should Have Succeeded
    And The Purchase Inquiry Status Must Be    expected_status=4
    And The Purchase Inquiry Fields Should Be Consistent
    And Credit Gateway Disable

[TC-014] Purchase Inquiry While The Purchase Is Reverse Initiated [Offline]
    Given Allocate No Fee CCREDIT Account
    And Set channel LINUX_POS
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway CPG
    And Credit Gateway Activate
    And Set Amount Equal To Balance
    When Perform A Reverse Initiated Offline Purchase
    And The Purchase Inquiry Is Called
    Then The Purchase Inquiry Should Have Succeeded
    And The Purchase Inquiry Status Must Be    expected_status=3
    And The Purchase Inquiry Fields Should Be Consistent
    And Credit Gateway Disable

[TC-015] Purchase Inquiry While The Purchase Is Reversed [Offline]
    [Tags]    robot:skip
    Given Allocate No Fee INSTALLMENT SALES Account
    And Set channel LINUX_POS
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway ISPG
    And Credit Gateway Activate
    And Set Amount Equal To Balance
    When Perform A Reverse Initiated Offline Purchase
    And The Purchase Is Reversed
    And The Purchase Inquiry Is Called
    Then The Purchase Inquiry Should Have Succeeded
    And The Purchase Inquiry Status Must Be    expected_status=3
    And The Purchase Inquiry Fields Should Be Consistent
    And Credit Gateway Disable
