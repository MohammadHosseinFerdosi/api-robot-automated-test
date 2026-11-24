*** Settings ***
Resource    steps/pcm/collaterals/collaterals-send-to-finance-from-treasury-step.resource

Test Setup   Send To Finance From Treasury
Test Teardown  Update Database to Treasury Flow 
*** Test Cases ***
[TC-001] Succussfully Treasury Output And Accept Finance
    when Requests Accept Treasury
    And Requests Accept Finance
    Then Check In Database From Accept Finance

[TC-002] Reject Treasury To Output
    When Requests Reject Treasury
    Then Check In Database From Reject Treasury First

[TC-003] Accept Treasury And Reject Finance And Accept Treasury
    When Requests Accept Treasury
    And Requests Reject Finance
    And Requests Accept Treasury
    Then Check In Database From Accept Treasury And Reject Finance And Accept Treasury

[TC-004] Accept Treasury And Reject Finance And Reject Treasury
    When Requests Accept Treasury
    And Requests Reject Finance
    And Requests Reject Treasury
    Then Check In Database From Accept Treasury And Reject Finance And Reject Treasury
