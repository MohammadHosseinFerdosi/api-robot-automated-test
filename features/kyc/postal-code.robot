*** Settings ***
Resource            steps/kyc/postal-code-step.resource

Suite Setup         Get Provider Weight
Suite Teardown      Post Provider Weight
Test Setup          Check DataBase And Delete All Record With This Postal Code


*** Test Cases ***
Get Postal Code Data With Jibit Provider
    Given Set Address Provider    ${JIBIT}
    When Get Inquiry From Address    ${POSTAL_CODE}
    Then We Should See Success Result In Response
    And We Should See Address Detail Of Postal Code In Response For Jibit Provider
    And We Should See Address Detail In Database For Jibit Provider

Get Postal Code Data With Sitaad Provider
    [Tags]    robot:skip
    Given Set Address Provider    ${SITAAD}
    When Get Inquiry From Address    ${POSTAL_CODE}
    Then We Should See Success Result In Response
    And We Should See Address Detail Of Postal Code In Response For Sitaad Provider
    And We Should See Address Detail In Database For Sitaad Provider

Get Postal Code Data With Wrong Postal Code And Jibit Provider
    Given Set Address Provider    ${JIBIT}
    When Get Inquiry From Address    ${WRONG_POSTAL_CODE}
    Then We Should See KYC Identity Not Found Result In Response
    And We Should See Address Failure Result For Jibit In Database

Get Postal Code Data With Wrong Postal Code And Sitaad Provider
    [Tags]    robot:skip
    Given Set Address Provider    ${SITAAD}
    When Get Inquiry From Address    ${WRONG_POSTAL_CODE}
    Then We Should See KYC Identity Not Found Result In Response
    And We Should See Address Failure Result For Sitaad In Database

Get Postal Code Data With Invalid Postal Code And Jibit Provider
    Given Set Address Provider    ${JIBIT}
    When Get Inquiry From Address    ${INVALID_POSTAL_CODE}
    Then We Should See Invalid Parameter Result In Response

Get Postal Code Data With Invalid Postal Code And Sitaad Provider
    Given Set Address Provider    ${SITAAD}
    When Get Inquiry From Address    ${INVALID_POSTAL_CODE}
    Then We Should See Invalid Parameter Result In Response

Get Postal Code Data From Cache For Jibit Provider
    Given Get Inquiry From Address AFter Set Jibit Provider    ${POSTAL_CODE}
    When Get Inquiry From Address    ${POSTAL_CODE}
    Then We Should See Success Result In Response
    And We Should See Address Detail Of Postal Code In Response For Jibit Provider
    And We Should See Address Detail In Database For Jibit Provider With Fetched From Cache True

Weight Of Provider Should Not More Than 1
    When Set Provider Weight More than 1
    Then We Should See Exception Invalid Parameters

Weight Of Provider Should Not Less Than 1
    When Set Provider Weight Less than 1
    Then We Should See Exception Kyc Setting Validation Error

Sum Of Providers Weight Should Not Less Than 1
    When Set Provider Weight That Sum Of Them Is Less Than 1
    Then We Should See Exception Kyc Setting Validation Error

Sum Of Providers Weight Should Not More Than 1
    When Set Provider Weight That Sum Of Them Is More Than 1
    Then We Should See Exception Kyc Setting Validation Error

Sum Of Providers Weight Should Not Be 0
    When Set All Providers Weight To 0
    THen We Should See Exception Kyc Setting Validation Error
