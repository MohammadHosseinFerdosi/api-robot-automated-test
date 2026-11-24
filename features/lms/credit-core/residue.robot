*** Settings ***
Resource            steps/LMS/credit-core/residue-steps.resource

Test Teardown       Reproduce Amount


*** Test Cases ***
[TC-001] Residue Check Up BNPL
    [Tags]    severity:high
    Given Allocate No Fee BNPL Account
    When Expire Account And Retrieve Balance On Expiration
    Then Check Residue Profiles Credibility By Credit Id
    And Check Residue Credit Credibility By Credit Id

[TC-002] Residue Check Up CREDIT No Fee
    [Tags]    severity:high
    Given Allocate No Fee CCREDIT Account
    When Expire Account And Retrieve Balance On Expiration
    Then Check Residue Profiles Credibility By Credit Id
    And Check Residue Credit Credibility By Credit Id

[TC-003] Residue Check Up CREDIT Installment Fee
    [Tags]    severity:high
    Given Allocate Fee On Installment CCREDIT Account
    When Expire Account And Retrieve Balance On Expiration
    Then Check Residue Profiles Credibility By Credit Id
    And Check Residue Credit Credibility By Credit Id

[TC-004] Residue Check Up CREDIT Purchase Fee
    [Tags]    severity:high
    Given Allocate Fee On Purchase CCREDIT Account
    When Expire Account And Retrieve Balance On Expiration
    Then Check Residue Profiles Credibility By Credit Id
    And Check Residue Credit Credibility By Credit Id

[TC-005] Residue Check Up CREDIT Allocation Fee
    [Tags]    severity:high
    Given Allocate Fee On Allocation CCREDIT Account
    When Expire Account And Retrieve Balance On Expiration
    Then Check Residue Profiles Credibility By Credit Id
    And Check Residue Credit Credibility By Credit Id

[TC-006] Residue Check Up INSTALLMENT SALE No Fee
    [Tags]    severity:high
    Given Allocate No Fee INSTALLMENT SALE Account
    When Expire Account And Retrieve Balance On Expiration
    Then Check Residue Profiles Credibility By Credit Id
    And Check Residue Credit Credibility By Credit Id

[TC-007] Residue Check Up INSTALLMENT SALE Installment Fee
    [Tags]    severity:high
    Given Allocate Fee On Installment INSTALLMENT SALE Account
    When Expire Account And Retrieve Balance On Expiration
    Then Check Residue Profiles Credibility By Credit Id
    And Check Residue Credit Credibility By Credit Id

[TC-008] Residue Check Up INSTALLMENT SALE Purchase Fee
    [Tags]    severity:high
    Given Allocate Fee On Purchase INSTALLMENT SALE Account
    When Expire Account And Retrieve Balance On Expiration
    Then Check Residue Profiles Credibility By Credit Id
    And Check Residue Credit Credibility By Credit Id

[TC-009] Residue Check Up INSTALLMENT SALE Allocation Fee
    [Tags]    severity:high
    Given Allocate Fee On Allocation INSTALLMENT SALE Account
    When Expire Account And Retrieve Balance On Expiration
    Then Check Residue Profiles Credibility By Credit Id
    And Check Residue Credit Credibility By Credit Id

[TC-010] Residue Check Up CREDIT No Fee USED
    [Tags]    severity:high
    Given Allocate No Fee CCREDIT Account
    When A Full Offline Purchase    has_cash=False    type=5    amount=30000
    And Expire Account And Retrieve Balance On Expiration
    Then Check Residue Profiles Credibility By Credit Id
    And Check Residue Credit Credibility By Credit Id

[TC-011] Residue Check Up CREDIT Installment Fee USED
    [Tags]    severity:high
    Given Allocate Fee On Installment CCREDIT Account
    When A Full Offline Purchase    has_cash=False    type=5    amount=30000
    And Expire Account And Retrieve Balance On Expiration
    Then Check Residue Profiles Credibility By Credit Id
    And Check Residue Credit Credibility By Credit Id

[TC-012] Residue Check Up CREDIT Purchase Fee USED
    [Tags]    severity:high
    Given Allocate Fee On Purchase CCREDIT Account
    When A Full Offline Purchase    has_cash=True    type=5    amount=30000
    And Expire Account And Retrieve Balance On Expiration
    Then Check Residue Profiles Credibility By Credit Id
    And Check Residue Credit Credibility By Credit Id

[TC-013] Residue Check Up CREDIT Purchase Fee Completely USED
    [Tags]    severity:high
    Given Allocate Fee On Purchase CCREDIT Account
    When A Full Offline Purchase    has_cash=True    type=5    amount=60000
    And Expire Account And Retrieve Balance On Expiration
    Then Check Residue Profiles Credibility By Credit Id
    And Check Residue Credit Credibility By Credit Id

[TC-014] Residue Check Up CREDIT Allocation Fee USED
    [Tags]    severity:high
    Given Allocate Fee On Allocation CCREDIT Account
    When A Full Offline Purchase    has_cash=False    type=5    amount=30000
    And Expire Account And Retrieve Balance On Expiration
    Then Check Residue Profiles Credibility By Credit Id
    And Check Residue Credit Credibility By Credit Id

[TC-015] Residue Check Up INSTALLMENT SALE No Fee USED
    [Tags]    severity:high
    Given Allocate No Fee INSTALLMENT SALE Account
    When A Full Online Purchase    type=26    amount=60000
    And Perform A Partial Refund    amount=2000    type=26
    And Expire Account And Retrieve Balance On Expiration
    Then Check Residue Profiles Credibility By Credit Id
    And Check Residue Credit Credibility By Credit Id

[TC-016] Residue Check Up INSTALLMENT SALE Installment Fee USED
    [Tags]    severity:high
    Given Allocate Fee On Installment INSTALLMENT SALE Account
    When A Full Online Purchase    type=26    amount=60000
    And Perform A Partial Refund    amount=2000    type=26
    And Expire Account And Retrieve Balance On Expiration
    Then Check Residue Profiles Credibility By Credit Id
    And Check Residue Credit Credibility By Credit Id

[TC-017] Residue Check Up INSTALLMENT SALE Purchase Fee USED
    [Tags]    robot:exclude
    Given Allocate Fee On Purchase INSTALLMENT SALE Account
    When A Full Offline Purchase    has_cash=True    type=26    amount=60000
    And Perform A Partial Refund    amount=20000    type=26
    And Expire Account And Retrieve Balance On Expiration
    Then Check Residue Profiles Credibility By Credit Id
    And Check Residue Credit Credibility By Credit Id

[TC-018] Residue Check Up INSTALLMENT SALE Purchase Fee Completely USED
    [Tags]    severity:high
    Given Allocate Fee On Purchase INSTALLMENT SALE Account
    When A Full Offline Purchase    has_cash=True    type=26    amount=60000
    And Expire Account And Retrieve Balance On Expiration
    Then Check Residue Profiles Credibility By Credit Id
    And Check Residue Credit Credibility By Credit Id

[TC-019] Residue Check Up INSTALLMENT SALE Allocation Fee USED
    [Tags]    severity:high
    Given Allocate Fee On Allocation INSTALLMENT SALE Account
    When A Full Online Purchase    type=26    amount=60000
    And Perform A Partial Refund    amount=20000    type=26
    And Expire Account And Retrieve Balance On Expiration
    Then Check Residue Profiles Credibility By Credit Id
    And Check Residue Credit Credibility By Credit Id
