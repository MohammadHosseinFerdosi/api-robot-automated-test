*** Settings ***
Resource            steps/settlement/agrregation-initiallization.resource
Resource            steps/settlement/aggregation-step.resource

Test Setup          Initialize Merchant, contracts, settle-items
Test Teardown       Collect All Amount , Delete Aggregation, Delete Settlement Item, Transactions, Business Config



*** Test Cases ***
All type aggregation & Transfer Normal Path
    [Tags]    severity:high
    When Aggregate Settlement items
    And Type 3 assertion
    And Type 0 assertion
    And Add Businesses To The Business Config For Transactions 
    And Finalize Type 2 Aggregation
    And Trigger Transactions & Transfer
    Then All Expected Transaction Must be Transferred To Platform or Merchant Wallet
