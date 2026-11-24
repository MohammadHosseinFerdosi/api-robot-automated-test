*** Settings ***
Resource            steps/app/pay/cards-step.resource

Suite Setup         Init Browser
Suite Teardown      Close All Browsers

Test Teardown        Back To Pay

*** Test Cases ***
Check The Wallet's Card Functionality
    [Tags]    robot:skip
    Given Navigate To Pay Page
    When Clicks On Wallet Card
    Then Redirects To Wallet Management Page And Turns Back To Pay Page

Check Wallet Card's Buttons Functionality
    [Tags]    robot:skip
    Given Navigate To Pay Page
    When Clicks On Cash-inBtn 
    Then Redirects To Cash-in Page And Turns Back To Pay Page
    When Clicks On Cash-out Btn
    Then Redirects To Cash-out Page And Turns Back To Pay Page
    When Clicks On Add Gift Card Btn
    Then Redirects To Wallet Management Page And Turns Back To Pay Page


Check The Credit Card's Functionality
    [Tags]    robot:skip
    Given Navigate To Pay Page
    When Switch to Credit Card's card
    When Clicks On Credit card
    Then Redirects To Credit Card's Managment Page And Turns Back To Pay Page


Check The Credit Card's buttons Functionality
    [Tags]    robot:skip
    Given Navigate To Pay Page
    Then Switch to Credit Card's card
    When Clicks On Store's Btn
    Then Redirects To Store's Page And Turns Back To Pay Page

Check The BNPL Card's Functionality
    [Tags]    robot:skip
    Given Navigate To Pay Page
    When Switch to bnpl's card
    When Clicks On Bnpl card
    Then User Redirects To Bnpl's Overview Page And Turns Back To Pay Page

Check The BNPL Card's buttons Functionality
    [Tags]    robot:skip
    Given Navigate To Pay Page
    Then Switch to bnpl's card
    When Clicks On Store's Btn
    Then Redirects To Store's Page And Turns Back To Pay Page


Check The Bank Card's Functionality
    [Tags]    robot:skip
    Given Navigate To Pay Page
    Then Switch to Bank Card's card
    When Clicks On Bank Card
    Then User Redirects To C2C Page And Turns Back To Pay Page