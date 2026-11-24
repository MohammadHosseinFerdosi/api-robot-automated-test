*** Settings ***
Resource    steps/LOS/extend.resource 
Resource    steps/LOS/credit-rule.resource

*** Test Cases ***
[TC-001] Admin Extends Credit Activation Registration Time And Verifies Result
    [Tags]    severity:medium    api    smoke
    Given User Completes Pre-Registration Phase
    And Update Activation Due Date
    When Bulk Extend Call Api
    And Update Activation Due Date
    And Single Extend Call Api
    Then Archive An Unallocated Credit