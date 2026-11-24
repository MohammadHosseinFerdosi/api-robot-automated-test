*** Settings ***
Resource    steps/LOS/sms-offer.resource

*** Test Cases ***
[TC-001] Admin Gets Credit Offer Successfully
    [Tags]    severity:low    api    smoke
    [Documentation]    Verify credit offer can be retrieved for configured user and parameters.
    When Admin Gets Credit Offer Successfully