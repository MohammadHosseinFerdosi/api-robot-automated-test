*** Settings ***
Resource    steps/LMS/credit-core/fund-provider-step.resource


*** Test Cases ***
[TC-001] Create A Fund Provider with valid data
    When Create Fund Provider With Valid Data
    Then Fund Provider Creation Should Succeed