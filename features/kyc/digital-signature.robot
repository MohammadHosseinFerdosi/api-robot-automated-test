*** Settings ***
Resource    steps/kyc/digital-signature-step.resource

Test Setup    Prepare Clean State


*** Test Cases ***
Initiate Basic After Native Liveness
    [Tags]    severity:high    e2e    smoke
    Given Complete Liveness Steps
    When Initiate A Digital Signature Basic
    Then We Should See User Data With Status 0 In DSP DB

Generate Certificate After Initiate Basic For Native Digital Signature
    [Tags]    severity:high    e2e    smoke
    Given Complete Liveness Steps
    And Initiate A Digital Signature Basic
    When Generate Certificate For Native Digital Signature
    Then We Should See Success Response For Generate
    And We Should See User Data With Status 1 In DSP DB

Generate Certificate After Register Initiate And Liveness For Native Digital Signature
    [Tags]    severity:high    e2e    sanity
    Given Register Native Liveness
    And Initiate A Digital Signature Basic
    And Post User Signature Picture
    And Post User Selfie Picture
    And Post User Selfie Video
    And We Should See Liveness Status Api Is    ${LIVENESS_STATUS['VERIFY']}
    When Generate Certificate For Native Digital Signature
    Then We Should See Success Response For Generate
    And We Should See User Data With Status 1 In DSP DB

Revoke Digital Signature After Generate
    [Tags]    severity:high    e2e    sanity
    Given Initiate And Generate New Digital Signature
    When Call Revoke Digital Signature API
    Then We Should See Revoke Success Response

Validate Password After Generate For Native Digital Signature
    [Tags]    severity:high    e2e    sanity
    Given Initiate And Generate New Digital Signature
    When Validate Password For Digital Signature API    ${USER_PASSWORD_DATA['password']}
    Then We Should See Validate Password Success Response

Generate Certificate Without Liveness For Native Digital Signature
    [Tags]    severity:high    e2e    regression
    Given Register Native Liveness
    And Initiate A Digital Signature Basic
    When Generate Certificate Expecting Error
    Then We Should See Digital Signature Incomplete Liveness Error In Response

Generate Certificate After Signature Only For Native Digital Signature
    [Tags]    severity:high    e2e    regression
    Given Register And Post Signature
    And Initiate A Digital Signature Basic
    When Generate Certificate Expecting Error
    Then We Should See Digital Signature Incomplete Liveness Error In Response

Generate Certificate After Selfie Without Video For Native Digital Signature
    [Tags]    severity:high    e2e    regression
    Given Register Signature And Selfie
    And Initiate A Digital Signature Basic
    When Generate Certificate Expecting Error
    Then We Should See Digital Signature Incomplete Liveness Error In Response

Initiate Basic Without Password After Native Liveness
    [Tags]    severity:high    e2e    regression
    Given Complete Liveness Steps
    When Initiate A Digital Signature Basic Without Password
    Then We Should See Bad Request Error In Response

Validate Password Without Generated Signature For Native Digital Signature
    [Tags]    severity:high    e2e    regression
    Given Complete Liveness Steps
    And Initiate A Digital Signature Basic
    When Validate Password For Digital Signature API    ${USER_PASSWORD_DATA['password']}
    Then We Should See Digital Signature Not Found Error In Response

Validate Password Mismatch After Generate For Native Digital Signature
    [Tags]    severity:high    e2e    regression
    Given Initiate And Generate New Digital Signature
    When Validate Password For Digital Signature API
    Then We Should See Digital Signature Password Mismatch Error In Response
