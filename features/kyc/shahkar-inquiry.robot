*** Settings ***
Resource            steps/kyc/shahkar-step.resource

Suite Setup         Get Provider Weight
Suite Teardown      Post Provider Weight
Test Setup          Check DataBase And Delete All Record With This National Code


*** Test Cases ***
Call Shahkar API With Shaparak Provider With Cell Number That Belong To National Code
    [Tags]    severity:high
    Given Set Shahkar Provider    false    ${SHAPARAK_ENUM}
    When Get Inquiry From Shahkar    ${CELL_NUMBERS['validCellNumber']}
    Then Shahkar Response Should Be Verified

Call Shahkar API With Shaparak Provider With Cell Number That Not Belong To National Code
    [Tags]    severity:high
    Given Set Shahkar Provider    false    ${SHAPARAK_ENUM}
    When Get Inquiry From Shahkar    ${CELL_NUMBERS['invalidCellNumber']}
    Then Shahkar Response Should Be Unverified

Call Shahkar API With Jibit Provider With Cell Number That Belong To National Code
    [Tags]    severity:high
    Given Set Shahkar Provider    false    ${JIBIT_ENUM}
    When Get Inquiry From Shahkar    ${CELL_NUMBERS['validCellNumber']}
    Then Shahkar Response Should Be Verified

Call Shahkar API With Jibit Provider With Cell Number That Not Belong To National Code
    [Tags]    severity:high
    Given Set Shahkar Provider    false    ${JIBIT_ENUM}
    When Get Inquiry From Shahkar    ${CELL_NUMBERS['invalidCellNumber']}
    Then Shahkar Response Should Be Unverified

Call Shahkar API And Return Result From Cache
    [Tags]    severity:high
    Given Set Shahkar Provider    false    ${JIBIT_ENUM}
    When Get Inquiry From Shahkar Twice    ${CELL_NUMBERS['validCellNumber']}
    Then Get Inquiry Should Read From Cache    ${CELL_NUMBERS['validCellNumber']}

Weight Of Provider Should Not More Than 1 With Active Auto Weighting False
    When Set Provider Weight More than 1    false
    Then We Should See Exception Invalid Parameters

Weight Of Provider Should Not Less Than 1 With Active Auto Weighting False
    When Set Provider Weight Less than 1    false
    Then We Should See Exception Kyc Setting Validation Error

Sum Of Providers Weight Should Not Less Than 1 With Active Auto Weighting False
    When Set Provider Weight That Sum Of Them Is Less Than 1    false
    Then We Should See Exception Kyc Setting Validation Error

Sum Of Providers Weight Should Not More Than 1 With Active Auto Weighting False
    When Set Provider Weight That Sum Of Them Is More Than 1    false
    Then We Should See Exception Kyc Setting Validation Error

Sum Of Providers Weight Should Not Be 0 With Active Auto Weighting False
    When Set All Providers Weight To 0    false
    Then We Should See Exception Kyc Setting Validation Error

Post Providers Weight With False Active Field For All Providers With Active Auto Weighting False
    When Set All Providers Active Field To false    false
    Then We Should See Exception Kyc Setting Validation Error

Post Providers Weight With False Active Field For All Providers With Active Auto Weighting True
    When Set All Providers Active Field To false    true
    Then We Should See Exception Kyc Setting Validation Error

Weight Of Provider Should Not More Than 1 With Active Auto Weighting True
    When Set Provider Weight More than 1    true
    Then We Should See Exception Invalid Parameters

Weight Of Provider Should Not Less Than 1 With Active Auto Weighting True
    When Set Provider Weight Less than 1    true
    Then We Should See Exception Kyc Setting Validation Error

Sum Of Providers Weight Should Not Less Than 1 With Active Auto Weighting True
    When Set Provider Weight That Sum Of Them Is Less Than 1    true
    Then We Should See Exception Kyc Setting Validation Error

Sum Of Providers Weight Should Not More Than 1 With Active Auto Weighting True
    When Set Provider Weight That Sum Of Them Is More Than 1    true
    Then We Should See Exception Kyc Setting Validation Error

Sum Of Providers Weight Should Not Be 0 With Active Auto Weighting True
    When Set All Providers Weight To 0    true
    Then We Should See Exception Kyc Setting Validation Error
