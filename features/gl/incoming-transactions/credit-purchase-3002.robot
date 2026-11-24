*** Settings ***
Resource    steps/gl/incoming-transactions/transaction-step.resource


*** Test Cases ***
[TC-001] Succussfully Create A Transaction
    [Tags]  severity:high   api     regression     
    When Create A Transaction   ${CREDIT_PREPAYMENT_EVENT_CODE}  ${INNER_JSON_3002}   
    Then Transaction Should Be Present In The Transaction Table
    And Transaction Should Be Present In The Voucher Table
    And Transaction Should Be Present In The Article Table

[TC-002] Validate Transaction Data
    [Tags]  severity:high   api     regression     
    When Create A Transaction   ${CREDIT_PREPAYMENT_EVENT_CODE}  ${INNER_JSON_3002}
    Then Amount Should Be Correct   