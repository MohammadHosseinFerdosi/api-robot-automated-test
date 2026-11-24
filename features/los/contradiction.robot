*** Settings ***
Resource        steps/LOS/contradiction.resource


*** Test Cases ***
[TC-001] Single Inquires Allocation Contradictions
    [Tags]    severity:medium    api    smoke
    [Documentation]    Verify admin can single inquiry allocation contradictions to process reconciliation for one credit.
    When Admin Searches Allocation Contradictions Successfully
    And Admin Searches Allocation Contradiction Journal Successfully

[TC-002] Batch Inquires Allocation Contradictions
    [Tags]    severity:medium    api    smoke
    [Documentation]    Verify admin can batch inquiry allocation contradictions to process reconciliation in bulk and receive tracking code.
    When Admin Batch Inquires Allocation Contradictions Successfully