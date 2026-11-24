*** Settings ***
Resource            steps/kyc/registration-step.resource

Suite Setup         Get Provider Weight
Suite Teardown      Post Provider Weight    ${PROVIDERS_SETTINGS}
Test Setup          Check DataBase And Delete All Record With This National Code


*** Test Cases ***
Call Registration Basic Inquiry With Valid Data And Force Inquiry True And Strong Validation True And Jibit Basic Provider
    Given Set Registration Provider    ${PROVIDERS['basic']['type']}    false    ${PROVIDERS['basic']['enums']['JIBIT_BASIC']}
    When Post User Data For Registration Inquiry    true    true    ${VALID_PERSON['national_code']}    
    ...    ${VALID_PERSON['birth_date']}     ${PROVIDERS['basic']['type']}
    Then We Should See Success Registration With User Identity Data Response
    And We Should See User Identity Data In Database With Fetched From Cache False    ${VALID_PERSON['national_code']}    BASIC    JIBIT_BASIC

Call Registration Basic Inquiry With Valid Data And Force Inquiry False And Strong Validation True And Jibit Basic Provider
    Given Set Registration Provider    ${PROVIDERS['basic']['type']}    false    ${PROVIDERS['basic']['enums']['JIBIT_BASIC']}
    When Post User Data For Registration Inquiry    false    true    ${VALID_PERSON['national_code']}    
    ...    ${VALID_PERSON['birth_date']}     ${PROVIDERS['basic']['type']}
    Then We Should See Success Registration With User Identity Data Response
    And We Should See User Identity Data In Database With Fetched From Cache False    ${VALID_PERSON['national_code']}    BASIC    JIBIT_BASIC

Call Registration Basic Inquiry With Valid Data And Force Inquiry False And Strong Validation False And Jibit Basic Provider From Cache
    Given Set Registration Provider    ${PROVIDERS['basic']['type']}    false    ${PROVIDERS['basic']['enums']['JIBIT_BASIC']}
    When Call Registration Inquiry For Valid User Twice    false    false    ${VALID_PERSON['national_code']}    
    ...    ${VALID_PERSON['birth_date']}     ${PROVIDERS['basic']['type']}
    Then We Should See Success Registration With User Identity Data Response
    And We Should See User Identity Data In Database With Fetched From Cache True    ${VALID_PERSON['national_code']}    BASIC    JIBIT_BASIC

Call Registration Full Inquiry With Valid Data And Force Inquiry True And Strong Validation True And Jibit Full Provider
    Given Set Registration Provider    ${PROVIDERS['full']['type']}    false    ${PROVIDERS['full']['enums']['JIBIT_FULL']}
    When Post User Data For Registration Inquiry    true    true    ${VALID_PERSON['national_code']}    
    ...    ${VALID_PERSON['birth_date']}     ${PROVIDERS['full']['type']}
    Then We Should See Success Registration With User Identity Data With Birth Place Field Response
    And We Should See User Identity Data With Birth Place In Database With Fetched From Cache False    ${VALID_PERSON['national_code']}    FULL    JIBIT_FULL

Call Registration Full Inquiry With Valid Data And Force Inquiry False And Strong Validation True And Jibit Full Provider
    Given Set Registration Provider    ${PROVIDERS['full']['type']}    false    ${PROVIDERS['full']['enums']['JIBIT_FULL']}
    When Post User Data For Registration Inquiry    false    true    ${VALID_PERSON['national_code']}    
    ...    ${VALID_PERSON['birth_date']}     ${PROVIDERS['full']['type']}
    Then We Should See Success Registration With User Identity Data With Birth Place Field Response
    And We Should See User Identity Data With Birth Place In Database With Fetched From Cache False    ${VALID_PERSON['national_code']}    FULL    JIBIT_FULL

Call Registration Full Inquiry With Valid Data And Force Inquiry False And Strong Validation False And Jibit Full Provider From Cache
    Given Set Registration Provider    ${PROVIDERS['full']['type']}    false    ${PROVIDERS['full']['enums']['JIBIT_FULL']}
    When Call Registration Inquiry For Valid User Twice    false    false    ${VALID_PERSON['national_code']}    
    ...    ${VALID_PERSON['birth_date']}     ${PROVIDERS['full']['type']}
    Then We Should See Success Registration With User Identity Data With Birth Place Field Response
    And We Should See User Identity Data With Birth Place In Database With Fetched From Cache True    ${VALID_PERSON['national_code']}    FULL    JIBIT_FULL

Call Registration Full Inquiry With Valid Data And Force Inquiry True And Strong Validation True And Hafezsaman Provider
    Given Set Registration Provider    ${PROVIDERS['full']['type']}    false    ${PROVIDERS['full']['enums']['HAFEZSAMAN']}
    When Post User Data For Registration Inquiry    true    true    ${VALID_PERSON['national_code']}    
    ...    ${VALID_PERSON['birth_date']}     ${PROVIDERS['full']['type']}
    Then We Should See Success Registration With User Identity Data With Birth Place Field Response
    And We Should See User Identity Data With Birth Place In Database With Fetched From Cache False    ${VALID_PERSON['national_code']}    FULL    HAFEZSAMAN

Call Registration Full Inquiry With Valid Data And Force Inquiry False And Strong Validation True And Hafezsaman Provider
    Given Set Registration Provider    ${PROVIDERS['full']['type']}    false    ${PROVIDERS['full']['enums']['HAFEZSAMAN']}
    When Post User Data For Registration Inquiry    false    true    ${VALID_PERSON['national_code']}    
    ...    ${VALID_PERSON['birth_date']}     ${PROVIDERS['full']['type']}
    Then We Should See Success Registration With User Identity Data With Birth Place Field Response
    And We Should See User Identity Data With Birth Place In Database With Fetched From Cache False    ${VALID_PERSON['national_code']}    FULL    HAFEZSAMAN

Call Registration Full Inquiry With Valid Data And Force Inquiry False And Strong Validation False And Hafezsaman Provider From Cache
    Given Set Registration Provider    ${PROVIDERS['full']['type']}    false    ${PROVIDERS['full']['enums']['HAFEZSAMAN']}
    When Call Registration Inquiry For Valid User Twice    false    false    ${VALID_PERSON['national_code']}    
    ...    ${VALID_PERSON['birth_date']}     ${PROVIDERS['full']['type']}
    Then We Should See Success Registration With User Identity Data With Birth Place Field Response
    And We Should See User Identity Data With Birth Place In Database With Fetched From Cache True    ${VALID_PERSON['national_code']}    FULL    HAFEZSAMAN

Call Registration Basic Inquiry With Invalid National Code And Force Inquiry True And Strong Validation True And Jibit Basic Provider
    Given Set Registration Provider    ${PROVIDERS['basic']['type']}    false    ${PROVIDERS['basic']['enums']['JIBIT_BASIC']}
    When Post User Data For Registration Inquiry    true    true    ${INVALID_PERSON['national_code']}    
    ...    ${VALID_PERSON['birth_date']}     ${PROVIDERS['basic']['type']}
    Then We Should See KYC Identity Not Found In Response

Call Registration Basic Inquiry With Invalid Birth Date And Force Inquiry False And Strong Validation True And Jibit Basic Provider
    Given Set Registration Provider    ${PROVIDERS['basic']['type']}    false    ${PROVIDERS['basic']['enums']['JIBIT_BASIC']}
    When Post User Data For Registration Inquiry    true    true    ${VALID_PERSON['national_code']}    
    ...    ${INVALID_PERSON['birth_date']}     ${PROVIDERS['basic']['type']}
    Then We Should See KYC Identity Not Found In Response

Call Registration Basic Inquiry With Wrong National Code And Force Inquiry False And Strong Validation True And Jibit Basic Provider
    Given Set Registration Provider    ${PROVIDERS['basic']['type']}    false    ${PROVIDERS['basic']['enums']['JIBIT_BASIC']}
    When Post User Data For Registration Inquiry    false    true    ${WRONG_NATIONAL_CODE}    
    ...    ${VALID_PERSON['birth_date']}     ${PROVIDERS['basic']['type']}
    Then We Should See Invalid Parameter In Response

Call Registration Full Inquiry With Invalid National Code And Force Inquiry True And Strong Validation True And Jibit Full Provider
    Given Set Registration Provider    ${PROVIDERS['full']['type']}    false    ${PROVIDERS['full']['enums']['JIBIT_FULL']}
    When Post User Data For Registration Inquiry    true    true    ${INVALID_PERSON['national_code']}    
    ...    ${VALID_PERSON['birth_date']}     ${PROVIDERS['full']['type']}
    Then We Should See KYC Identity Not Found In Response

Call Registration Full Inquiry With Invalid Birth Date And Force Inquiry False And Strong Validation True And Jibit Full Provider
    Given Set Registration Provider    ${PROVIDERS['full']['type']}    false    ${PROVIDERS['full']['enums']['JIBIT_FULL']}
    When Post User Data For Registration Inquiry    true    true    ${VALID_PERSON['national_code']}    
    ...    ${INVALID_PERSON['birth_date']}     ${PROVIDERS['full']['type']}
    Then We Should See KYC Identity Not Found In Response

Call Registration Full Inquiry With Wrong National Code And Force Inquiry False And Strong Validation True And Jibit Full Provider
    Given Set Registration Provider    ${PROVIDERS['full']['type']}    false    ${PROVIDERS['full']['enums']['JIBIT_FULL']}
    When Post User Data For Registration Inquiry    false    true    ${WRONG_NATIONAL_CODE}    
    ...    ${VALID_PERSON['birth_date']}     ${PROVIDERS['full']['type']}
    Then We Should See Invalid Parameter In Response

Call Registration Full Inquiry With Invalid National Code And Force Inquiry True And Strong Validation True And Hafezsaman Provider
    Given Set Registration Provider    ${PROVIDERS['full']['type']}    false    ${PROVIDERS['full']['enums']['HAFEZSAMAN']}
    When Post User Data For Registration Inquiry    true    true    ${INVALID_PERSON['national_code']}    
    ...    ${VALID_PERSON['birth_date']}     ${PROVIDERS['full']['type']}
    Then We Should See KYC Identity Not Found In Response

Call Registration Full Inquiry With Invalid Birth Date And Force Inquiry False And Strong Validation True And Hafezsaman Provider
    Given Set Registration Provider    ${PROVIDERS['full']['type']}    false    ${PROVIDERS['full']['enums']['HAFEZSAMAN']}
    When Post User Data For Registration Inquiry    true    true    ${VALID_PERSON['national_code']}    
    ...    ${INVALID_PERSON['birth_date']}     ${PROVIDERS['full']['type']}
    Then We Should See KYC Identity Not Found In Response

Call Registration Full Inquiry With Wrong National Code And Force Inquiry False And Strong Validation True And Hafezsaman Provider
    Given Set Registration Provider    ${PROVIDERS['full']['type']}    false    ${PROVIDERS['full']['enums']['HAFEZSAMAN']}
    When Post User Data For Registration Inquiry    false    true    ${WRONG_NATIONAL_CODE}    
    ...    ${VALID_PERSON['birth_date']}     ${PROVIDERS['full']['type']}
    Then We Should See Invalid Parameter In Response

Call Registration Full Inquiry With Valid Data And Force Inquiry True And Strong Validation True And Jibit Full Provider That Provider Does Not Send Birth Place
    Given Set Registration Provider    ${PROVIDERS['full']['type']}    false    ${PROVIDERS['full']['enums']['JIBIT_FULL']}
    When Post User Data For Registration Inquiry    true    true    ${PERSON_FOR_KYC_BAD_RESPONSE['national_code']}    
    ...    ${PERSON_FOR_KYC_BAD_RESPONSE['birth_date']}     ${PROVIDERS['full']['type']}
    Then We Should See KYC Bad Response In Response

Call Registration Full Inquiry With Valid Data And Force Inquiry False And Strong Validation True And Hafezsaman Provider That Provider Does Not Send Birth Place
    Given Set Registration Provider    ${PROVIDERS['full']['type']}    false    ${PROVIDERS['full']['enums']['HAFEZSAMAN']}
    When Post User Data For Registration Inquiry    false    true    ${PERSON_FOR_KYC_BAD_RESPONSE['national_code']}    
    ...    ${PERSON_FOR_KYC_BAD_RESPONSE['birth_date']}     ${PROVIDERS['full']['type']}
    Then We Should See Success Registration With User Identity Data Without Birth Place Field Response
    And We Should See User Identity Data Without Birth Place In Database With Fetched From Cache False    ${PERSON_FOR_KYC_BAD_RESPONSE['national_code']}    FULL    HAFEZSAMAN


Call Registration Basic Inquiry With Dead Person Data And Force Inquiry True And Strong Validation True And Jibit Basic Provider
    Given Set Registration Provider    ${PROVIDERS['basic']['type']}    false    ${PROVIDERS['basic']['enums']['JIBIT_BASIC']}
    When Post User Data For Registration Inquiry    true    true    ${DEAD_PERSON['national_code']}    
    ...    ${DEAD_PERSON['birth_date']}     ${PROVIDERS['basic']['type']}
    Then We Should See Success Registration With Dead User Identity Data Response
    And We Should See Dead User Identity Data In Database With Fetched From Cache False    ${DEAD_PERSON['national_code']}    BASIC    JIBIT_BASIC

Call Registration Full Inquiry With Dead Data And Force Inquiry True And Strong Validation True And Jibit Full Provider
    Given Set Registration Provider    ${PROVIDERS['full']['type']}    false    ${PROVIDERS['full']['enums']['JIBIT_FULL']}
    When Post User Data For Registration Inquiry    true    true    ${DEAD_PERSON['national_code']}    
    ...    ${DEAD_PERSON['birth_date']}     ${PROVIDERS['full']['type']}
    Then We Should See Success Registration With Dead User Identity Data With Birth Place Field Response
    And We Should See Dead User Identity Data With Birth Place In Database With Fetched From Cache False    ${DEAD_PERSON['national_code']}    FULL    JIBIT_FULL

Call Registration Full Inquiry With Dead Data And Force Inquiry True And Strong Validation True And Hafezsaman Provider
    Given Set Registration Provider    ${PROVIDERS['full']['type']}    false    ${PROVIDERS['full']['enums']['HAFEZSAMAN']}
    When Post User Data For Registration Inquiry    true    true    ${DEAD_PERSON['national_code']}    
    ...    ${DEAD_PERSON['birth_date']}     ${PROVIDERS['full']['type']}
    Then We Should See Success Registration With Dead User Identity Data With Birth Place Field Response
    And We Should See Dead User Identity Data With Birth Place In Database With Fetched From Cache False    ${DEAD_PERSON['national_code']}    FULL    HAFEZSAMAN
Weight Of Provider Should Not More Than 1 With Active Auto Weighting False For Basic Providers
    When Set Provider Weight More than 1    ${PROVIDERS['basic']['type']}    false
    Then We Should See Invalid Parameter In Response For Setting Provider

Weight Of Provider Should Not More Than 1 With Active Auto Weighting False For Full Providers
    When Set Provider Weight More than 1    ${PROVIDERS['full']['type']}    false
    Then We Should See Invalid Parameter In Response For Setting Provider

Weight Of Provider Should Not Less Than 1 With Active Auto Weighting False For Basic Providers
    When Set Provider Weight Less than 1    ${PROVIDERS['basic']['type']}    false
    Then We Should See Exception KYC Setting Validation Error

Weight Of Provider Should Not Less Than 1 With Active Auto Weighting False For Full Providers
    When Set Provider Weight Less than 1    ${PROVIDERS['full']['type']}    false
    Then We Should See Exception KYC Setting Validation Error

Sum Of Providers Weight Should Not Less Than 1 With Active Auto Weighting False For Basic Providers
    When Set Provider Weight That Sum Of Them Is Less Than 1    ${PROVIDERS['basic']['type']}    false
    Then We Should See Exception KYC Setting Validation Error

Sum Of Providers Weight Should Not Less Than 1 With Active Auto Weighting False For Full Providers
    When Set Provider Weight That Sum Of Them Is Less Than 1    ${PROVIDERS['full']['type']}    false
    Then We Should See Exception KYC Setting Validation Error

Sum Of Providers Weight Should Not More Than 1 With Active Auto Weighting False Basic Providers
    When Set Provider Weight That Sum Of Them Is More Than 1    ${PROVIDERS['basic']['type']}    false
    Then We Should See Exception KYC Setting Validation Error

Sum Of Providers Weight Should Not More Than 1 With Active Auto Weighting False Full Providers
    When Set Provider Weight That Sum Of Them Is More Than 1    ${PROVIDERS['full']['type']}    false
    Then We Should See Exception KYC Setting Validation Error

Sum Of Providers Weight Should Not Be 0 With Active Auto Weighting False For Basic Providers
    When Set All Providers Weight To 0    ${PROVIDERS['basic']['type']}    false
    Then We Should See Exception KYC Setting Validation Error

Sum Of Providers Weight Should Not Be 0 With Active Auto Weighting False For Full Providers
    When Set All Providers Weight To 0    ${PROVIDERS['full']['type']}    false
    Then We Should See Exception KYC Setting Validation Error

Post Providers Weight With False Active Field For All Providers With Active Auto Weighting False For Basic Providers
    When Set All Providers Active Field To false    ${PROVIDERS['basic']['type']}    false
    Then We Should See Exception KYC Setting Validation Error

Post Providers Weight With False Active Field For All Providers With Active Auto Weighting False For Full Providers
    When Set All Providers Active Field To false    ${PROVIDERS['full']['type']}    false
    Then We Should See Exception KYC Setting Validation Error

Weight Of Provider Should Not More Than 1 With Active Auto Weighting True For Basic Providers
    When Set Provider Weight More than 1    ${PROVIDERS['basic']['type']}    true
    Then We Should See Invalid Parameter In Response For Setting Provider

Weight Of Provider Should Not More Than 1 With Active Auto Weighting True For Full Providers
    When Set Provider Weight More than 1    ${PROVIDERS['full']['type']}    true
    Then We Should See Invalid Parameter In Response For Setting Provider

Weight Of Provider Should Not Less Than 1 With Active Auto Weighting True For Basic Providers
    When Set Provider Weight Less than 1    ${PROVIDERS['basic']['type']}    true
    Then We Should See Exception KYC Setting Validation Error

Weight Of Provider Should Not Less Than 1 With Active Auto Weighting True For Full Providers
    When Set Provider Weight Less than 1    ${PROVIDERS['full']['type']}    true
    Then We Should See Exception KYC Setting Validation Error

Sum Of Providers Weight Should Not Less Than 1 With Active Auto Weighting True For Basic Providers
    When Set Provider Weight That Sum Of Them Is Less Than 1    ${PROVIDERS['basic']['type']}    true
    Then We Should See Exception KYC Setting Validation Error

Sum Of Providers Weight Should Not Less Than 1 With Active Auto Weighting True For Full Providers
    When Set Provider Weight That Sum Of Them Is Less Than 1    ${PROVIDERS['full']['type']}    true
    Then We Should See Exception KYC Setting Validation Error

Sum Of Providers Weight Should Not More Than 1 With Active Auto Weighting True Basic Providers
    When Set Provider Weight That Sum Of Them Is More Than 1    ${PROVIDERS['basic']['type']}    true
    Then We Should See Exception KYC Setting Validation Error

Sum Of Providers Weight Should Not More Than 1 With Active Auto Weighting True Full Providers
    When Set Provider Weight That Sum Of Them Is More Than 1    ${PROVIDERS['full']['type']}    true
    Then We Should See Exception KYC Setting Validation Error

Sum Of Providers Weight Should Not Be 0 With Active Auto Weighting True For Basic Providers
    When Set All Providers Weight To 0    ${PROVIDERS['basic']['type']}    true
    Then We Should See Exception KYC Setting Validation Error

Sum Of Providers Weight Should Not Be 0 With Active Auto Weighting True For Full Providers
    When Set All Providers Weight To 0    ${PROVIDERS['full']['type']}    true
    Then We Should See Exception KYC Setting Validation Error

Post Providers Weight With False Active Field For All Providers With Active Auto Weighting True For Basic Providers
    When Set All Providers Active Field To false    ${PROVIDERS['basic']['type']}    true
    Then We Should See Exception KYC Setting Validation Error

Post Providers Weight With False Active Field For All Providers With Active Auto Weighting True For Full Providers
    When Set All Providers Active Field To false    ${PROVIDERS['full']['type']}    true
    Then We Should See Exception KYC Setting Validation Error