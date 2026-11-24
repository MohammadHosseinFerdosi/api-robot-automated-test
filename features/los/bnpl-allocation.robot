*** Settings ***
Resource    steps/LOS/bnpl-allocation.resource


*** Test Cases ***
Allocation API - Duplicate Tracking Code
    Given all parameters are correctly set for the allocation API except the tracking code (duplicate)
    When we call the allocation API
    Then the response should not be successful related to duplicated tracking code

Allocation API - Shahkar Validation Check
    Given all parameters are correctly set for the allocation API, but the phone number does not match the national code
    When we call the allocation API
    Then the response should not be successful related to Shahkar validation

Allocation API - Sabte Ahval Validation (User is Deceased)
    Given all parameters are correctly set for the allocation API, but the user is marked as deceased
    When we call the allocation API
    Then the response should not be successful related to death validation

Allocation API - Sabte Ahval Validation (Birthdate is not correct)
    Given all parameters are correctly set for the allocation API, but birthdate not correct
    When we call the allocation API
    Then the response should not be successful related to birthdate validation

Allocation API - Happy Scenario
    Given all parameters are correctly set for the allocation API
    And close the user accounts
    When we call the allocation API
    Then the response should be successful
    And close the user accounts
