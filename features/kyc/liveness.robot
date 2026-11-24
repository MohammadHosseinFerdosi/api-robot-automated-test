*** Settings ***
Resource    steps/kyc/liveness-step.resource

Test Setup    Prepare Clean State


*** Test Cases ***
Register Native Liveness
    [Tags]    severity:high    e2e    sanity
    When Register Native Liveness
    Then We Should See User Data With Status 10 In Liveness DB

Post User Signature After Register Native Liveness
    [Tags]    severity:high    e2e    sanity
    Given Register Native Liveness
    When Post User Signature Picture
    Then We Should See User Data With Status 20 In Liveness DB

Post User Selfie Picture After Post Signature For Native Liveness
    [Tags]    severity:high    e2e    sanity
    Given Register Native Liveness
    And Post User Signature Picture
    When Post User Selfie Picture
    Then We Should See User Data With Status 30 In Liveness DB

Post User Selfie Video After Post Selfie Picture For Native Liveness
    [Tags]    severity:high    e2e    smoke
    Given Register Native Liveness
    And Post User Signature Picture
    And Post User Selfie Picture
    When Post User Selfie Video
    Then We Should See Liveness Status Api Is    ${LIVENESS_STATUS['VERIFY']}
    And We Should See User Data With Status 50 In Liveness DB

Post User Selfie Before Signature For Native Liveness
    [Tags]    severity:high    e2e    regression
    Given Register Native Liveness
    When Post User Selfie Picture Expecting Error
    Then We Should See KYC Liveness Invalid Liveness Status Error In Response

Post User Selfie Video Before Signature For Native Liveness
    [Tags]    severity:high    e2e    regression
    Given Register Native Liveness
    When Post User Selfie Video Expecting Error
    Then We Should See KYC Liveness Invalid Liveness Status Error In Response

Post User Selfie Video Before Selfie For Native Liveness
    [Tags]    severity:high    e2e    regression
    Given Register Native Liveness
    And Post User Signature Picture
    When Post User Selfie Video Expecting Error
    Then We Should See KYC Liveness Invalid Liveness Status Error In Response

Post Empty Signature File For Native Liveness
    [Tags]    severity:medium    e2e    regression
    Given Register Native Liveness
    When Post User Signature Picture Expecting Error    ${EMPTY}
    Then We Should See Invalid Parameter For Signature File Error In Response

Post Empty Selfie File For Native Liveness
    [Tags]    severity:medium    e2e    regression
    Given Register Native Liveness
    And Post User Signature Picture
    When Post User Selfie Picture Expecting Error    ${EMPTY}
    Then We Should See Invalid Parameter For Selfie Image File Error In Response

Post Empty Selfie Video File For Native Liveness
    [Tags]    severity:medium    e2e    regression
    Given Register Native Liveness
    And Post User Signature Picture
    And Post User Selfie Picture
    When Post User Selfie Video Expecting Error    ${EMPTY}
    Then We Should See Invalid Parameter For Selfie Video File Error In Response

Post Wrong Selfie Picture For Native Liveness
    [Tags]    severity:high    e2e    regression
    Given Register Native Liveness
    And Post User Signature Picture
    When Post Wrong Selfie Picture
    Then We Should See KYC Liveness Provider Image Does Not Match Error In Response

Post Wrong Selfie Picture Until Max Retry For Native Liveness
    [Tags]    severity:high    e2e    regression
    Given Register Native Liveness
    And Post User Signature Picture
    When Post 3 Times Wrong Selfie Picture
    Then We Should See KYC Liveness Provider Max Retry Reached Error In Response

Post Wrong Selfie Video First Time For Native Liveness
    [Tags]    severity:high    e2e    regression
    Given Register Native Liveness
    And Post User Signature Picture
    And Post User Selfie Picture
    When Post Wrong Selfie Video    1
    Then We Should See KYC Liveness Provider Process Error For First Time In Response

Post Wrong Selfie Video Second Time For Native Liveness
    [Tags]    severity:high    e2e    regression
    Given Register Native Liveness
    And Post User Signature Picture
    And Post User Selfie Picture
    When Post Wrong Selfie Video    2
    Then We Should See KYC Liveness Provider Process Error For Second Time In Response

Post Wrong Selfie Video Third Time For Native Liveness
    [Tags]    severity:high    e2e    regression
    Given Register Native Liveness
    And Post User Signature Picture
    And Post User Selfie Picture
    When Post Wrong Selfie Video    3
    Then We Should See KYC Liveness Provider Process Error For Third Time In Response

Post Wrong Selfie Video Until Max Retry For Native Liveness
    [Tags]    severity:high    e2e    regression
    Given Register Native Liveness
    And Post User Signature Picture
    And Post User Selfie Picture
    When Post Wrong Selfie Video    4
    Then We Should See KYC Liveness Provider Max Retry Reached Error In Response
