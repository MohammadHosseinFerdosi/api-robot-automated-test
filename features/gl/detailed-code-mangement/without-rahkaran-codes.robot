*** Settings ***
Resource    steps/gl/detailed-code-mangement/merchants-without-rahkaran-codes.resource
Suite Teardown    Unsuspend Merchant


*** Test Cases ***
[TC-001] Verify All Merchants Have No Rahkaran Code
    [Tags]  severity:high   api     regression     
    When Get All Merchants Without Rahkaran Codes
    Then No Merchant Record Exists Without A Detailed Code       

[TC-002] Filter Merchants By Name
    [Tags]  severity:medium   api     regression     
    Given Get All Merchants Without Rahkaran Codes
    And Get Random Merchant
    When Filter Merchants By Name
    Then Filtered Merchants Must Contain The Name

[TC-003] Suspend Merchant 
    [Tags]  severity:high   api     regression     
    Given Get All Merchants Without Rahkaran Codes
    And Get Random Merchant
    And Get Id Of Merchant
    When Suspend Merchant
    And Filter Merchants By Name
    Then Suspended Merchant Should Not Be In 'Merchants Without Rahkaran' Menu
    And Filter Suspended Merchants By Name
    And Suspended Merchant Should Be in 'Suspended Merchants' Menu