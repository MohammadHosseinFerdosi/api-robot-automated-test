*** Settings ***
Resource    steps/smc/bankscore.resource


*** Test Cases ***
Get DP Score User Check StatusCode SUCCESS
    [Tags]    severity:high
    When Enter The information Valid Values And call Api BANK Score
    Then Response To The Status Code Should Be SUCCESS

Get DP Score User Check Parameters SUCCESS
    [Tags]    severity:medium
    When Enter The information Valid Values And call Api BANK Score
    Then Response To The Parameters Should Be SUCCESS

Get DP Score User With "NationalCode Invalid" Check StatusCode "INVALID_PARAMETER"
    [Tags]    severity:high
    When Enter The information NationalCode Invalid And call Api BANK Score
    Then Response To The Status Code Should Be "INVALID_PARAMETER"

Get DP Score User With "NationalCode Invalid" Check Parameters "INVALID_PARAMETER"
    [Tags]    severity:medium
    When Enter The information NationalCode Invalid And call Api BANK Score
    Then Response To The Parameters Should Be "INVALID_NATIONALCODE"

Get DP Score User With "NationalCode Null" Check StatusCode "INVALID_PARAMETER"
    [Tags]    severity:high
    When Enter The Information With National Code Null And Call Api BANK Score
    Then Response To The Parameters Should Be "INVALID_NATIONALCODE"

Get DP Score User With "NationalCode Null" Check Parameters "INVALID_PARAMETER"
    [Tags]    severity:medium
    When Enter The Information With National Code Null And Call Api BANK Score
    Then Response To The Parameters Should Be "INVALID_NATIONALCODE"

Get DP Score User With "Cellnumber Invalid" Check StatusCode "INVALID_PARAMETER"
    [Tags]    severity:high
    When Enter The Information With NationalCode Null And Call Api BANK Score
    Then Response To The Status Code Should Be "INVALID_PARAMETER"

Get DP Score User With "Cellnumber Invalid" Check Parameters "INVALID_PARAMETER"
    [Tags]    severity:medium
    When Enter The Information With Cellnumber Null And Call Api BANK Score
    Then Response To The Parameters Should Be "INVALID_PARAMETER"

Get DP Score User With "Cellnumber Null" Check StatusCode "INVALID_PARAMETER"
    [Tags]    severity:high
    When Enter The Information With Cellnumber Null And Call Api BANK Score
    Then Response To The Status Code Should Be "INVALID_PARAMETER"

Get DP Score User With "Cellnumber Null" Check Parameters "INVALID_PARAMETER"
    [Tags]    severity:medium
    When Enter The Information With Cellnumber Null And Call Api BANK Score
    Then Response To The Parameters Should Be "INVALID_PARAMETER"

Get DP Score User With "ServiceType Invalid" Check StatusCode "FAILURE"
    [Tags]    severity:high
    When Enter The Information With ServiceType Invalid And Call Api BANK Score
    Then Response To The Status Code Should Be "FAILURE"

Get DP Score User With "ServiceType Invalid" Check Parameters "FAILURE"
    [Tags]    severity:medium
    When Enter The Information With ServiceType Invalid And Call Api BANK Score
    Then Response To The Parameters Should Be "FAILURE"

Get DP Score User With "ServiceType Null" Check StatusCode "FAILURE"
    [Tags]    severity:high
    When Enter The Information With ServiceType Null And Call Api BANK Score
    Then Response To The Status Code Should Be "FAILURE"

Get DP Score User With "ServiceType Null" Check Parameters "FAILURE"
    [Tags]    severity:medium
    When Enter The Information With ServiceType Null And Call Api BANK Score
    Then Response To The Parameters Should Be "FAILURE"

Get DP Score User With "scoreType Invalid" Check StatusCode "FAILURE"
    [Tags]    severity:high
    When Enter The Information With scoreType Invalid And Call Api BANK Score
    Then Response To The Status Code Should Be "FAILURE"

Get DP Score User With "scoreType Invalid" Check Parameters "FAILURE"
    [Tags]    severity:medium
    When Enter The Information With scoreType Invalid And Call Api BANK Score
    Then Response To The Parameters Should Be "FAILURE"

Get DP Score User With "scoreType Null" Check StatusCode "FAILURE"
    [Tags]    severity:high
    When Enter The Information With scoreType Null And Call Api BANK Score
    Then Response To The Status Code Should Be "FAILURE"

Get DP Score User With "scoreType Null" Check Parameters "FAILURE"
    [Tags]    severity:medium
    When Enter The Information With scoreType Null And Call Api BANK Score
    Then Response To The Parameters Should Be "FAILURE"

Get DP Score User With "TrackingCode Invalid" Check StatusCode "INVALID_PARAMETER"
    [Tags]    severity:high
    When Enter The Information With TrackingCode Invalid And Call Api BANK Score
    Then Response To The Status Code Should Be "INVALID_PARAMETER"

Get DP Score User With "TrackingCode Invalid" Check Parameters "INVALID_PARAMETER"
    [Tags]    severity:medium
    When Enter The Information With TrackingCode Invalid And Call Api BANK Score
    Then Response To The Parameters Should Be "INVALID_PARAMETER"

Get DP Score User With "TrackingCode Null" Check StatusCode "INVALID_PARAMETER"
    [Tags]    severity:high
    When Enter The Information With TrackingCode Null And Call Api BANK Score
    Then Response To The Status Code Should Be "INVALID_PARAMETER"

Get DP Score User With "TrackingCode Null" Check Parameters "INVALID_PARAMETER"
    [Tags]    severity:medium
    When Enter The Information With TrackingCode Null And Call Api BANK Score
    Then Response To The Parameters Should Be "INVALID_PARAMETER"

Get DP Score two User With "Duplicate TrackingCode" Check StatusCode "INVALID_PARAMETER"
    [Tags]    severity:high
    When Enter Info Different User With Duplicate TrackingCode And Call Api BANK Score
    Then Response To The Status Code Should Be "INVALID_PARAMETER"

Get DP Score two User With "Duplicate TrackingCode" Check Parameters "INVALID_PARAMETER"
    [Tags]    severity:high
    When Enter Info Different User With Duplicate TrackingCode And Call Api BANK Score
    Then Response To The Parameters Should Be "DUPLICATE TRACKINGCODE"

 Get DP Score user block Check StatusCode SUCCESS
    [Tags]    severity:high
    When Enter The information user block And call Api BANK Score
    Then Response To The Status Code Should Be SUCCESS

Get DP Score user block Check Parameters SUCCESS
    [Tags]    severity:medium
    When Enter The information user block And call Api BANK Score
    Then Response To The Parameters Should Be SUCCESS

Get DP Score user block Check Deatails Data in DataBase SUCCESS
    [Tags]    severity:high
    Given Enter The information user block And call Api BANK Score
    When Enter Data for find information user in DataBase "score_journals" Mango
    Then Check Vulue Params Respone API with DataBase Mango for user Block

Get DP Score User Check Deatails Data in DataBase "score_journals"
    [Tags]    severity:high
    Given Enter The information Valid Values And call Api BANK Score
    When Enter Data for find information user in DataBase "score_journals" Mango
    Then Check Vulue Params Respone API with DataBase Mango
