*** Settings ***
Resource    steps/pcm/collaterals/collaterals-send-to-debt-collection-step.resource

Test Setup     Send To Debt Collection From Treasury
Test Teardown  Update Database to Treasury Flow 
*** Test Cases ***
[TC-001] Succussfully Treasury Output And Accept
    When Requests Accept Treasury
    And Requests Accept Debt Collection
    Then Check In Database From Accept Debt Collection 

[TC-002] Reject Treasury To Output
    When Requests Reject Treasury
    Then Check In Database From Reject Treasury First

[TC-003] Accept Treasury And Reject Debt Collecton And Accept Treasury
    When Requests Accept Treasury
    And Requests Reject Debt Collection
    And Requests Accept Treasury
    Then Check In Database From Accept Treasury And Reject Debt Collection And Accept Treasury

[TC-004] Accept Treasury And Reject Debt Collecton And Reject Treasury
    When Requests Accept Treasury
    And Requests Reject Debt Collection
    And Requests Reject Treasury
    Then Check In Database From Accept Treasury And Reject Debt Collection And Reject Treasury
