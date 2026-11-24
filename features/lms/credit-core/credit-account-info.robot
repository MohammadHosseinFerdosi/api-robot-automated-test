*** Settings ***
Resource            steps/LMS/credit-core/accounts-step.resource

Test Teardown       Reproduce Amount


*** Test Cases ***
[TC-001] Get Account Info For Blocked Credit
    Given Credit Allocation    types=${{['${LMS_Account_Type_1PAY}']}}
    And Set Block Reason    reason=${LMS_BLOCK_REASON.ORGANIZATION_REQUEST}
    when Block credit account
    and Account Information    creditId=${credit_ids}[0]
    Then Checking BlockingDetail On Account Info

[TC-002] Get Account Info For Active Credit
    Given Credit Allocation    types=${{['${LMS_Account_Type_1PAY}']}}
    And Set Block Reason    reason=${LMS_BLOCK_REASON.ORGANIZATION_REQUEST}
    when Block credit account
    And Unblock Credit Account
    and Account Information    creditId=${credit_ids}[0]
    Then Checking BlockingDetail On Account Info

[TC-003] Get Account Info For Blocked User With No Reason
    Given Credit Allocation    types=${{['${LMS_Account_Type_XPAY}']}}
    And Set Block Reason    reason=${LMS_BLOCK_REASON.No_Reason}
    when Block credit account
    and Account Information    creditId=${credit_ids}[0]
    Then Checking BlockingDetail On Account Info without Reason

[TC-004] Get Account Info For Active User With RemainingBalance
    Given Credit Allocation    types=${{['${LMS_Account_Type_XPAY}']}}
    when Account Information    creditId=${credit_ids}[0]
    Then Return the Credit RemainingBalance

[TC-005] Get Account Info For Blocked User With RemainingBalance
    Given Credit Allocation    types=${{['${LMS_Account_Type_CREDIT}']}}
    And Set Block Reason    reason=${LMS_BLOCK_REASON.USER_VIOLATION}
    when Block credit account
    And Account Information    creditId=${credit_ids}[0]
    And Checking BlockingDetail On Account Info
    Then Return the Credit RemainingBalance

[TC-006] Check The ORGANIZATION_REQUEST Reason Of Blocked Account
    Given Credit Allocation    types=${{['${LMS_Account_Type_1PAY}']}}
    And Set Block Reason    reason=${LMS_BLOCK_REASON.ORGANIZATION_REQUEST}
    when Block credit account
    and Account Information    creditId=${credit_ids}[0]
    Then Checking The ORGANIZATION_REQUEST For Response

[TC-007] Check The USER_VIOLATION Reason Of Blocked Account
    Given Credit Allocation    types=${{['${LMS_Account_Type_1PAY}']}}
    And Set Block Reason    reason=${LMS_BLOCK_REASON.USER_VIOLATION}
    when Block credit account
    and Account Information    creditId=${credit_ids}[0]
    Then Checking The USER_VIOLATION For Response

[TC-008] Check The BAD_USER Reason Of Blocked Account
    Given Credit Allocation    types=${{['${LMS_Account_Type_1PAY}']}}
    And Set Block Reason    reason=${LMS_BLOCK_REASON.BAD_USER}
    when Block credit account
    and Account Information    creditId=${credit_ids}[0]
    Then Checking The BAD_USER For Response

[TC-009] Get Account Info For Schedule Close User With RemainingBalance
    Given Credit Allocation    types=${{['${LMS_Account_Type_CREDIT}']}}
    And Set Block Reason    reason=${LMS_BLOCK_REASON.USER_VIOLATION}
    when Call Schedule Close API
    And Account Information    creditId=${credit_ids}[0]
    And Checking BlockingDetail On Account Info
    Then Return the Credit RemainingBalance