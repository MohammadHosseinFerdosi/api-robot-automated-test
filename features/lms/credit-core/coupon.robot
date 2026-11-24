*** Settings ***
Resource            steps/LMS/credit-core/coupon-step.resource

*** Test Cases ***

[TC-001] Create Campaign, Coupon And Coupon Codes
    [Tags]    severity:high    e2e   regression    sanity
    Given Create Campaign With Valid Data
    When Create Coupon With Valid Data
    Then Create Coupon Codes Successfully