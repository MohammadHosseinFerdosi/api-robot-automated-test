*** Settings ***
Resource    steps/gl/detailed-code-mangement/merchants-with-rahkaran-codes.resource


*** Test Cases ***

[TC-001] Verify All Rahkaran Codes Must Consist Of Exactly Six Digits
    [Tags]  severity:high   api     regression     
    When Get All Merchants With Rahkaran Codes
    Then All Rahkaran Codes Must Consist Of Exactly Six Digits

[TC-002] Verify That Merchants Have The Same National Code Must Have Identical Rahkaran Codes
    [Tags]  severity:high   api     regression     
    When Get All Merchants With Rahkaran Codes
    Then Merchants With The Same National Code Must Have The Same Rahkaran Code

[TC-003] Filter Merchants By Name
    [Tags]  severity:medium   api     regression     
    Given Get All Merchants With Rahkaran Codes
    When Filter Merchants By Desired Field      businessName
    Then Filtered Merchants Must Contain The Desired Field    

[TC-004] Filter Merchants By Rahkaran Code
    [Tags]  severity:medium   api     regression     
    Given Get All Merchants With Rahkaran Codes
    When Filter Merchants By Desired Field      rahkaranCode
    Then Filtered Merchants Must Contain The Desired Field  

[TC-005] Filter Merchants By Account Number
    [Tags]  severity:medium   api     regression     
    Given Get All Merchants With Rahkaran Codes
    When Filter Merchants By Desired Field     accountNumber
    Then Filtered Merchants Must Contain The Desired Field    

[TC-006] All Merchants Must Have A National Code
    [Tags]  severity:high   api     regression     
    When Get All Merchants With Rahkaran Codes
    Then All Merchants Must Have A National Code
