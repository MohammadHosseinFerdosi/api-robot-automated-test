*** Settings ***
Resource        steps/LOS/underwriter.resource

*** Test Cases ***
[TC-001] Admin Searches Underwriters And Receives Results
    [Tags]    severity:medium    api    smoke
    [Documentation]    Verify admin can search underwriters using creation-time sorting.
    Given Clean Data From Database   
    and Admin Searches Underwriters Successfully
    and Admin Validates Underwriter
    When Admin Creates Underwriter
    and Admin Creates Commitments
    Then Clean Data From Database