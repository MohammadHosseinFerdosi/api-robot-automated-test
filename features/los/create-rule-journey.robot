*** Settings ***
Resource        steps/LOS/create-rule-journey.resource

*** Test Cases ***
[TC-001] Create A Complete Credit Cheque Workflow And Clean Up
    [Tags]    severity:high    api    smoke
    [Documentation]    Complete creation of Credit Cheque rule, group, and plan, followed by cleaning up the created data from the databases.
    Given Admin Completes Rule Credit Cheque Creation Process
    When Admin Completes Whitelist Group Creation Process
    Then Admin Completes Plan Creation Process
    And Admin Cleans Up Created Data

[TC-002] Create A Complete Credit E_note Workflow And Clean Up
    [Tags]    severity:high    api    smoke
    [Documentation]    Complete creation of Credit E-note rule, group, and plan, followed by cleaning up the created data from the databases.
    Given Admin Completes Rule Credit E_note Creation Process
    When Admin Completes Public Group Creation Process
    Then Admin Completes Plan Creation Process
    And Admin Cleans Up Created Data

[TC-003] Create A Complete Credit Un_Payble Workflow And Clean Up
    [Tags]    severity:high    api    smoke
    [Documentation]    Complete creation of Credit Un_Payble rule, group, and plan, followed by cleaning up the created data from the databases.
    Given Admin Completes Rule Credit Un_Payble Creation Process
    When Admin Completes Public Group Creation Process
    Then Admin Completes Plan Creation Process
    And Admin Cleans Up Created Data

[TC-004] Create A Complete BNPL Workflow And Clean Up
    [Tags]    severity:high    api    smoke
    [Documentation]    Complete creation of BNPL rule, group, and plan, followed by cleaning up the created data from the databases.
    Given Admin Completes Rule BNPL Creation Process
    When Admin Completes Public Group Creation Process
    Then Admin Completes Plan Creation Process
    And Admin Cleans Up Created Data

[TC-005] Create A Complete Installment_Cheque Workflow And Clean Up
    [Tags]    severity:high    api    smokee
    [Documentation]    Complete creation of Installment_Cheque rule, group, and plan, followed by cleaning up the created data from the databases.
    Given Admin Completes Rule Installment_Cheque Creation Process
    When Admin Completes Public Group Creation Process
    Then Admin Completes Plan Creation Process
    And Admin Cleans Up Created Data

[TC-006] Create A Complete Credit Without_Collateral Workflow And Clean Up
    [Tags]    severity:high    api    smokee
    [Documentation]    Complete creation of Credit Without_Collateral rule, group, and plan, followed by cleaning up the created data from the databases.
    Given Admin Completes Rule Without_Collateral Credit Creation Process  
    When Admin Completes Public Group Creation Process
    Then Admin Completes Plan Creation Process
    And Admin Cleans Up Created Data