*** Settings ***
Library    Browser

*** Variables ***
${DEFAULT_ELEMENT_TIMEOUT}    10s

*** Keywords ***
Click When Visible
    [Arguments]    ${locator}
    Wait For Elements State    ${locator}    visible    ${DEFAULT_ELEMENT_TIMEOUT}
    Wait For Elements State    ${locator}    enabled    ${DEFAULT_ELEMENT_TIMEOUT}
    Click    ${locator}

Wait Until URL Contains
    [Arguments]    ${path}
    Wait For URL    **${path}    ${DEFAULT_ELEMENT_TIMEOUT}

Navigate Using Map
    [Arguments]    ${location}    &{navigation_map}
    ${locator}=    Get From Dictionary    ${navigation_map}    ${location}
    Click When Visible    ${locator}
