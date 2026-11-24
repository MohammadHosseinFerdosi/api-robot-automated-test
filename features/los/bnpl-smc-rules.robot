*** Settings ***
Resource        steps/LOS/bnpl-smc-rule-steps.resource

Test Setup      Test Setup For SMC Rules


*** Test Cases ***
[TC-001]A Happy Scenario For User Allocation Using Preregister Entry Point
    [Tags]    BNPL     severity:high    api    smoke
    The User Pre-registers For A BNPL Plan
    ...    group_id=${BNPL_GROUP_ID}
    ...    plan_id=${BNPL_PLAN_ID}
    ...    balance=${BNPL_BALANCE}
    Check BNPL Activation Record
    Activate BNPL Profile In Progress
    Update BNPL User Profile
    Call The SMC Init API
    The Credit Status Should Be Updated To    ACTIVE
    Close all his BNPLs
    

[TC-002]User Rejection in SMC Step
    [Tags]    BNPL     severity:high    api    smoke
    The User Pre-registers For A BNPL Plan
    ...    group_id=${BNPL_SMC_REJECTION_GROUP_ID}
    ...    plan_id=${BNPL_SMC_REJECTION_PLAN_ID}
    ...    balance=${BNPL_SMC_REJECTION_BALANCE}
    Check BNPL Activation Record
    Activate BNPL Profile In Progress
    Update BNPL User Profile
    Call The SMC Init API
    The Credit Status Should Be Updated To    SMC_REJECTED
    Archive the unallocated bnpl successfully
