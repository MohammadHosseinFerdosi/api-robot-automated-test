*** Settings ***
Library         Browser
Resource        steps/app/mini-apps/internet-step.resource
Suite Setup     Run Keywords    Start Browser    AND    Logins To App Via APP Processes    ${USER_CELL_NUMBER}
Suite Teardown    Close Browser

*** Test Cases ***
Purchase MCI Prepaid Monthly Internet Package
    [Tags]    severity:high    e2e    smoke    Internet
    Given Navigate To Internet Package Page
    When Purchase MCI Prepaid Monthly Internet Package
    And Confirm Internet Package Payment
    Then Cancel Payment

Purchase MCI Postpaid Internet Package
    [Tags]    severity:high    e2e    smoke    Internet
    Given Navigate To Internet Package Page
    When Purchase MCI Postpaid Internet Package
    And Confirm Internet Package Payment
    Then Cancel Payment

Purchase MTN Prepaid Monthly Internet Package
    [Tags]    severity:high    e2e    smoke    Internet
    Given Navigate To Internet Package Page
    When Purchase MTN Prepaid Monthly Internet Package
    And Confirm Internet Package Payment
    Then Cancel Payment

Purchase MTN Postpaid Monthly Internet Package
    [Tags]    severity:high    e2e    smoke    Internet
    Given Navigate To Internet Package Page
    When Purchase MTN Postpaid Monthly Internet Package
    And Confirm Internet Package Payment
    Then Cancel Payment

Purchase TD-LTE Internet Package
    [Tags]    severity:high    e2e    Internet
    Given Navigate To Internet Package Page
    When Purchase TD-LTE Internet Package
    And Confirm Internet Package Payment
    Then Cancel Payment

Purchase Rightel Prepaid Monthly Internet Package
    [Tags]    severity:high    e2e    smoke    Internet
    Given Navigate To Internet Package Page
    When Purchase Rightel Prepaid Monthly Internet Package
    And Confirm Internet Package Payment
    Then Cancel Payment

Purchase Shatel Data Internet Package
    [Tags]    severity:high    e2e    smoke    Internet
    Given Navigate To Internet Package Page
    When Purchase Shatel Data Internet Package
    And Confirm Internet Package Payment
    Then Cancel Payment

Purchase Shatel Prepaid Internet Package
    [Tags]    severity:high    e2e    smoke    Internet
    Given Navigate To Internet Package Page
    When Purchase Shatel Prepaid Internet Package
    And Confirm Internet Package Payment
    Then Cancel Payment

Purchase MCI Prepaid Daily Internet Package
    [Tags]    severity:medium    e2e    Internet
    Given Navigate To Internet Package Page
    When Purchase MCI Prepaid Daily Internet Package
    And Confirm Internet Package Payment
    Then Cancel Payment

Purchase MTN Prepaid Weekly Internet Package
    [Tags]    severity:medium    e2e    Internet
    Given Navigate To Internet Package Page
    When Purchase MTN Prepaid Weekly Internet Package
    And Confirm Internet Package Payment
    Then Cancel Payment

Purchase MCI Prepaid Popular Internet Package
    [Tags]    severity:medium    e2e    Internet
    Given Navigate To Internet Package Page
    When Purchase MCI Prepaid Popular Internet Package
    And Confirm Internet Package Payment
    Then Cancel Payment

Purchase MTN Spatial Internet Package
    [Tags]    severity:high    e2e    smoke    Internet
    Given Navigate To Internet Package Page
    When Purchase MTN Spatial Internet Package
    And Confirm Internet Package Payment
    Then Cancel Payment

Purchase Recommended Internet Package
    [Tags]    severity:high    e2e    smoke    Internet
    Given Navigate To Internet Package Page
    When Purchase Recommended Internet Package
    And Confirm Internet Package Payment
    Then Cancel Payment

Change Package After Going Back To Internet Page
    [Tags]    severity:high    e2e    Internet    navigation
    Given Navigate To Internet Package Page
    And Full Flow Of Internet Page
    And Return To Internet Package Page From Bundles
    When Purchase MCI Prepaid Daily Internet Package
    And Confirm Internet Package Payment
    Then Cancel Payment

Return From Bundles Page To Internet Package Page
    [Tags]    severity:medium    e2e    Internet    navigation
    Given Navigate To Internet Package Page
    When Full Flow Of Internet Page  
    Then Return To Internet Package Page From Bundles
    
