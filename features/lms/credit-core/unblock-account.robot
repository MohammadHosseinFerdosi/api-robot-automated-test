*** Settings ***
Resource            steps/LMS/credit-core/credit-account-unblock-step.resource

Test Teardown       Reproduce Amount


*** Test Cases ***
[TC-001] Unblock BNPL account
    Given Credit Allocation    types=${{['${LMS_Account_Type_1PAY}']}}
    And Block Credit Account
    When Unblock Credit Account
    Then Account Status Must Not Be Blocked
    And Blocking Detail Must Be Removed

[TC-002] Unblock C-Credit account
    Given Credit Allocation    types=${{['${LMS_Account_Type_CREDIT}']}}
    And Block Credit Account
    When Unblock Credit Account
    Then Account Status Must Not Be Blocked
    And Blocking Detail Must Be Removed

[TC-003] Unblock Installment Sale account
    Given Credit Allocation    types=${{['${LMS_Account_Type_INSTALLMENT_SALE}']}}
    And Block Credit Account
    When Unblock Credit Account
    Then Account Status Must Not Be Blocked
    And Blocking Detail Must Be Removed
