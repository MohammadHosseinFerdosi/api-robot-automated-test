*** Settings ***
Library         Browser
Resource        steps/app/mini-apps/top-up-step.resource
Suite Setup       Run Keywords    Start Browser    AND    Logins To App Via APP Processes    ${USER_CELL_NUMBER}
Suite Teardown    Close Browser

*** Test Cases ***
Purchase MCI Prepaid Top-Up
    [Tags]    severity:high    e2e    smoke    Top-Up    
    Given Navigate To Top Up Page
    When Purchase MCI Prepaid Top-Up
    And Confirm Top-Up Payment
    Then Cancel Payment
Purchase MTNI Prepaid Top-Up
    [Tags]    severity:high    e2e    smoke    Top-Up
    Given Navigate To Top Up Page
    When Purchase MTNI Prepaid Top-Up
    And Confirm Top-Up Payment
    Then Cancel Payment
Purchase Rightel Prepaid Top-Up
    [Tags]    severity:high    e2e    smoke    Top-Up
    Given Navigate To Top Up Page
    When Purchase Rightel Prepaid Top-Up
    And Confirm Top-Up Payment
    Then Cancel Payment
Purchase Shatel Prepaid Top-Up
    [Tags]    severity:high    e2e    smoke    Top-Up
    Given Navigate To Top Up Page
    When Purchase Shatel Prepaid Top-Up
    And Confirm Top-Up Payment
    Then Cancel Payment
Purchase MCI Prepaid Top-Up By Entering Charge Amount
    [Tags]    severity:high    e2e    smoke    Top-Up
    Given Navigate To Top Up Page
    When Purchase MCI Prepaid Top-Up By Entering Charge Amount
    And Confirm Top-Up Payment
    Then Cancel Payment
Purchase Recommended Top-Up
    [Tags]    severity:high    e2e    smoke    Top-Up
    Given Navigate To Top Up Page
    When Purchase For Recommended Number
    And Confirm Top-Up Payment
    Then Cancel Payment
Purchase MTNI WOW Prepaid Top-Up
    [Tags]    severity:high    e2e    smoke    Top-Up
    Given Navigate To Top Up Page
    When Purchase MTNI WOW Prepaid Top-Up
    And Confirm Top-Up Payment
    Then Cancel Payment
Purchase Rightel WOW Prepaid Top-Up
    [Tags]    severity:high    e2e    smoke    Top-Up
    Given Navigate To Top Up Page
    When Purchase Rightel WOW Prepaid Top-Up
    And Confirm Top-Up Payment
    Then Cancel Payment
Purchase MCI Postpaid Top-Up
    [Tags]    severity:high    e2e    smoke    Top-Up
    Given Navigate To Top Up Page
    Then Purchase MCI Postpaid Top-Up