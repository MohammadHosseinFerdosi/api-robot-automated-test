*** Settings ***
Documentation       Mongo integrity for wallet-transfer Iran Wallet routes.
...                 Cleanup best-effort when Mongo is not writable.
Resource            steps/iran-wallet/db-step.resource
Suite Teardown      Iran Wallet Suite Teardown
Test Teardown       Cleanup Prepared Tracking Code From Mongo


*** Test Cases ***
[TC-001][Wallet] Cash In Route Persists In Transaction Collection
    [Documentation]    After a successful route, Mongo holds cash-in transfer fields.
    [Tags]    severity:high    e2e    regression    wallet
    Given Wallet Transfer Mongo Is Connected
    And A New Tracking Code Is Ready
    When User Routes Cash In Transfer
    Then Route Response Should Be Created
    And Transfer Should Match Cash In Route In Mongo

[TC-002][Wallet] Route Writes An Initiated Journal Entry
    [Documentation]    Routed transfer journals include INITIATED action.
    [Tags]    severity:high    e2e    regression    wallet
    Given Wallet Transfer Mongo Is Connected
    And A New Tracking Code Is Ready
    When User Routes Cash In Transfer
    Then Route Response Should Be Created
    And Transfer Should Have Initiated Journal
