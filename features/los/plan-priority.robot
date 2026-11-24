*** Settings ***
Resource    steps/LOS/plan-priority.resource

*** Test Cases ***
[TC-001] Update Credit Plans Priority And Verify Successfully
    [Tags]    severity:high    api    smoke
    [Documentation]    Admin retrieves current credit plans priority, updates the priorities, and verifies that the update is successful and persisted in the database.
    Given Gets Credit Plans Priority
    When Updates Credit Plans Priority
    Then Plans Priority Update Should Be Successful