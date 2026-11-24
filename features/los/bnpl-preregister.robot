*** Settings ***
Resource    steps/LOS/bnpl-volunteers-pre-register-step.resource


*** Test Cases ***
Correct redirect to stepper with credit id generation in pre-register by calling app side
    [Tags]    robot:skip
    [Documentation]    This test checks the correct redirect of the user to the next step after a credit id is created
    Given the user is logged in to the app
    And We Close all his BNPLs
    When the user clicks on the verify information button on the /pre-register/submit page from ${APP_SIDE}
    Then a credit id is generated for that person
    And Archive The All Unallocated Credit
