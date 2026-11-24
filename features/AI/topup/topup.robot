*** Settings ***
Resource        steps/AI/login-with-ai-initialization.resource
Resource        steps/AI/topup.resource

Suite Setup     Login To App With AI    cell_number=09911772110    browser=${FIREFOX}


*** Test Cases ***
Buy Topup Via AI
    [Tags]    robot:skip
    Given Empty Captures
    Then Buy Top Up With a Predefined User and Predefined Amount    cell_number=09911772110    debug=False
