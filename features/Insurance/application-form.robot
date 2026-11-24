*** Settings ***
Resource    steps/Insurance/application-form-steps.resource


*** Test Cases ***
Create Application Form With License And National Code
    Given I have license and national code
    And Insurance User Is Logged In
    When I send request to create application form
    Then Application form should be created successfully

Create Application Form Without License And National Code
    Given I don't have license and national code
    And Insurance User Is Logged In
    When I send request to create application form
    Then Application form should be created successfully
