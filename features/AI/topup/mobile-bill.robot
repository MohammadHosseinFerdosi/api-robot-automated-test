*** Settings ***
Resource        steps/AI/login-with-ai-initialization.resource
Resource        steps/AI/mobile-bill.resource

Suite Setup     Login To App With AI    cell_number=09911772110    browser=${FIREFOX}


*** Test Cases ***
Pay Mobile Bill Via AI
    [Tags]    robot:skip
    Given Empty Captures
    Then Pay Top Up Mobile Bill With a Predefined User   cell_number=09121072110    debug=False
