*** Settings ***
Resource            steps/app/mini-apps/c2c-step.resource

Suite Setup         Init Browser
Suite Teardown      Close All Browsers
Test Teardown       Back From C2C To Hub


*** Test Cases ***
Successful C2C Transfer
    [Tags]    robot:skip
    Given User Enters C2C Information
    When Enters Card Credential Data And Pay
    Then The C2C Transfer Should Occur Successfully

Add New Card - Invalid Card Number
    [Tags]    robot:skip
    Given Navigate To C2C Page
    When User Tries To Add Invalid Source Card
    Then Invalid Card Number Message Will Appear
    And Continue Button Will Disable

Add New Card - Incorrect Card Number
    [Tags]    robot:skip
    Given Navigate To C2C Page
    When User Tries To Add Incorrect Source Card
    Then Continue Button Will Disable
