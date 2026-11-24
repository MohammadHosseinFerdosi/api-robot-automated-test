*** Settings ***
Resource        steps/LOS/user_tac.resource

*** Test Cases ***
[TC-001] User Accepts General Tac
    [Tags]    severity:low    api    smoke
    [Documentation]    Verify user can accept general tac.
     Given Clean Data From Database 
     When Accepts General Tac