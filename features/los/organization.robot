*** Settings ***
Resource        steps/LOS/organization.resource

*** Test Cases ***
[TC-001] Admin Searches For Organizations And Verifies Results
    [Tags]    severity:high    api    smoke
    [Documentation]    Admin performs a search on organizations using specific filters and ordering.
    Given Clean Data From Database   
    and Admin Searches Organizations Successfully
    and Admin Validates Organizations
    When Admin Creates Organizations
    Then Clean Data From Database
