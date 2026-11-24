*** Settings ***
Resource    steps/LMS/credit-core/create-profile-step.resource


*** Test Cases ***
[TC-001] Create a profile with valid data
    When Create Profile With Valid Data
    Then Profile Creation Should Succeed
