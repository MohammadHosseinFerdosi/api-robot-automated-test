*** Settings ***
Resource            steps/LMS/credit-core/credit-account-block-step.resource

Test Teardown       Reproduce Amount


*** Test Cases ***
[TC-001] Block BNPL account
    Given Credit Allocation    types=${{['${LMS_Account_Type_1PAY}']}}
    And Set Block Reason    reason=${LMS_BLOCK_REASON.ORGANIZATION_REQUEST}
    And Block Credit Account
    And Block Status Should Be 200
    When Block Credit Account
    And Block Status Should Be 422
    Then Account Status Must Be Blocked
    And Blocking Detail Must Be Saved

[TC-002] Block C-Credit account
    Given Credit Allocation    types=${{['${LMS_Account_Type_CREDIT}']}}
    And Set Block Reason    reason=${LMS_BLOCK_REASON.USER_VIOLATION}
    When Block Credit Account
    And Block Status Should Be 200
    Then Account Status Must Be Blocked
    And Blocking Detail Must Be Saved

[TC-003] Block Installment Sale account
    Given Credit Allocation    types=${{['${LMS_Account_Type_INSTALLMENT_SALE}']}}
    And Set Block Reason    reason=${LMS_BLOCK_REASON.BAD_USER}
    When Block Credit Account
    And Block Status Should Be 200
    Then Account Status Must Be Blocked
    And Blocking Detail Must Be Saved

[TC-004] Block Xpay account
    [Tags]    closable
    Given Credit Allocation    types=${{['${LMS_Account_Type_XPAY}']}}
    And Set Block Reason    reason=${LMS_BLOCK_REASON.ORGANIZATION_REQUEST}
    When Block Credit Account
    And Block Status Should Be 200
    Then Account Status Must Be Blocked
    And Blocking Detail Must Be Saved
