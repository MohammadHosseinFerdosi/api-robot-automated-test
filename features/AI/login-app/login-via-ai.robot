*** Settings ***
Resource    steps/AI/login.resource
Resource    steps/AI/login-with-ai-initialization.resource

Suite Setup   Login To App With AI    cell_number=09911772110    browser=${FIREFOX}


*** Test Cases ***
Login Via AI
    [Tags]    robot:skip
    Given Empty Captures
    Then In The Home Page