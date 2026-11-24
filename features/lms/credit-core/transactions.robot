*** Settings ***
Resource            steps/LMS/credit-core/transactions-step.resource

Test Setup          Initialize Merchant
Test Teardown       Reproduce Amount


*** Test Cases ***
[TC-001] Get 1pay BNPL Transactions With Credit ID
    Given The User Has 1pay Account
    And The Payment Gateway Is Set To BPG
    And Perform a complete purchase
    When The user requests the transactions
    And The user requests the transaction receipt
    Then The response should contain transactions list
    And The response status should be 200 for transaction receipt
    And The Gateway Is Disabled

[TC-002] Get 4pay BNPL Transactions With Credit ID
    Given The User Has 4pay Account
    And The Payment Gateway Is Set To BPG
    And Perform a complete purchase
    When The user requests the transactions
    And The user requests the transaction receipt
    Then The response should contain transactions list
    And The response status should be 200 for transaction receipt
    And The Gateway Is Disabled

[TC-003] Get Credit Transactions With Credit ID
    Given The User Has Credit Account
    And The Payment Gateway Is Set To CPG
    And Perform a complete purchase
    When The user requests the transactions
    And The user requests the transaction receipt
    Then The response should contain transactions list
    And The response status should be 200 for transaction receipt
    And The Gateway Is Disabled

[TC-004] Get Installment Sale Transactions With Credit ID
    Given The User Has Installment Sale Account
    And The Payment Gateway Is Set To ISPG
    And Perform a complete purchase
    When The user requests the transactions
    And The user requests the transaction receipt
    Then The response should contain transactions list
    And The response status should be 200 for transaction receipt
    And The Gateway Is Disabled

[TC-005] Get 1pay BNPL Transactions With Credit ID When Gateway Is Disabled
    Given The User Has 1pay Account
    And The Payment Gateway Is Set To BPG
    And Perform a complete purchase
    And The Gateway Is Disabled
    When The user requests the transactions
    And The user requests the transaction receipt
    Then The response should contain transactions list
    And The response status should be 200 for transaction receipt
    And The Gateway Is Disabled

[TC-006] Get 4pay BNPL Transactions With Credit ID When Gateway Is Disabled
    Given The User Has 4pay Account
    And The Payment Gateway Is Set To BPG
    And Perform a complete purchase
    And The Gateway Is Disabled
    When The user requests the transactions
    And The user requests the transaction receipt
    Then The response should contain transactions list
    And The response status should be 200 for transaction receipt
    And The Gateway Is Disabled

[TC-007] Get Credit Transactions With Credit ID When Gateway Is Disabled
    Given The User Has Credit Account
    And The Payment Gateway Is Set To CPG
    And Perform a complete purchase
    And The Gateway Is Disabled
    When The user requests the transactions
    And The user requests the transaction receipt
    Then The response should contain transactions list
    And The response status should be 200 for transaction receipt
    And The Gateway Is Disabled

[TC-008] Get Installment Sale Transactions With Credit ID When Gateway Is Disabled
    Given The User Has Installment Sale Account
    And The Payment Gateway Is Set To ISPG
    And Perform a complete purchase
    And The Gateway Is Disabled
    When The user requests the transactions
    And The user requests the transaction receipt
    Then The response should contain transactions list
    And The response status should be 200 for transaction receipt
    And The Gateway Is Disabled
