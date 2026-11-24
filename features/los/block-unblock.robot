*** Settings ***
Resource    steps/LOS/block-unblock.resource 
Resource    steps/LOS/credit-rule.resource
Resource    steps/LOS/create-rule-journey.resource


*** Test Cases ***
[TC-001] Verify Group Activation Suspend Toggle Using Save API
    [Tags]    severity:medium    api    smoke
    Given Searches Activation Suspend
    And Admin Completes Rule Credit Cheque Creation Process
    When Admin Completes Public Group Creation Process
    And Admin Completes Plan Creation Process
    And Adds Activation Suspend Restriction
    And Verifies Created Group Exists In Activation Suspend Search
    Then Saves Activation Suspend Restriction
    And Admin Cleans Up Created Data

[TC-002] Verify Group Activation Suspend Removal Using Delete API
    [Tags]    severity:medium    api    smoke
    Given Searches Activation Suspend
    And Admin Completes Rule Credit Cheque Creation Process
    When Admin Completes Public Group Creation Process
    And Admin Completes Plan Creation Process
    And Adds Activation Suspend Restriction
    And Verifies Created Group Exists In Activation Suspend Search
    Then Deletes Activation Suspend Restriction
    And Admin Cleans Up Created Data

[TC-003] Verify User Activation Suspend Toggle
    [Tags]    severity:medium    api    smoke
    Given User Completes Pre-Registration Phase
    When Suspends Credit Activation
    And Rebounds Credit Activation Suspend
    Then Archive An Unallocated Credit