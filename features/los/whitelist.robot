*** Settings ***
Resource        steps/LOS/create-rule-journey.resource
Resource        steps/LOS/whitelist.resource

*** Test Cases ***
[TC-001] Admin Imports Whitelist Successfully And Single Remove
    [Tags]    severity:high    api    smoke
    [Documentation]    Verify admin can import whitelist using created group id and configured cell number.
    Given Admin Completes Rule Credit Cheque Creation Process
    And Admin Completes Whitelist Group Creation Process
    When Admin Imports Whitelist Successfully
    And Admin Searches Whitelist Successfully
    And Admin Single Removes Whitelist Successfully
    Then Admin Cleans Up Created Data

[TC-002] Admin Imports Whitelist Successfully And All Remove
    [Tags]    severity:high    api    smoke
    [Documentation]    Verify admin can import whitelist using created group id and configured cell number.
    Given Admin Completes Rule Credit Cheque Creation Process
    And Admin Completes Whitelist Group Creation Process
    When Admin Imports Whitelist Successfully
    And Admin Searches Whitelist Successfully
    And Admin All Removes Whitelist Successfully
    Then Admin Cleans Up Created Data