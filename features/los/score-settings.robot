*** Settings ***
Resource        steps/LOS/score-settings.resource

*** Test Cases ***
[TC-001] Updates Score Settings Successfully
    [Tags]    severity:low    api    smoke
    [Documentation]    Admin updates score settings with disabled, limited, and unlimited modes.
    Given Admin Sets Score Settings Disabled
    When Admin Sets Score Settings Enabled Limited
    Then Admin Sets Score Settings Enabled Unlimited