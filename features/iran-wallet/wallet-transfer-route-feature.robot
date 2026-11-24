*** Settings ***
Documentation       Wallet-transfer route for Iran Wallet cash-in and cash-out.
...                 Mongo cleanup is best-effort (UAT secondary often read-only).
Resource            steps/iran-wallet/db-step.resource
Suite Teardown      Iran Wallet Suite Teardown
Test Teardown       Cleanup Prepared Tracking Code From Mongo


*** Test Cases ***
[TC-001][Wallet] Registered User Can Route A Cash In Transfer
    [Documentation]    Route HTTP 201 INITIATED with non-empty providerTrackingCode.
    [Tags]    severity:high    api    smoke    wallet
    Given A New Tracking Code Is Ready
    When User Routes Cash In Transfer
    Then Route Response Should Be Created

[TC-002][Wallet] Registered User Can Route A Cash Out Transfer
    [Documentation]    Cash-out side routes with small amount; Mongo stores CASH_OUT.
    [Tags]    severity:high    e2e    smoke    wallet
    Given Wallet Transfer Mongo Is Connected
    And A New Tracking Code Is Ready
    When User Routes Cash Out Transfer
    Then Route Response Should Be Created
    And Transfer Should Match Cash Out Route In Mongo

[TC-003][Wallet] Duplicate Tracking Code Is Rejected
    [Documentation]    Second route returns DUPLICATE and Mongo keeps one record.
    [Tags]    severity:high    e2e    regression    wallet
    Given Wallet Transfer Mongo Is Connected
    And A Routed Cash In Transfer Exists
    When User Routes With Same Tracking Code Again
    Then Duplicate Route Response Should Be Rejected
    And Transfer Should Persist In Mongo

[TC-004][Wallet] Route Without Wallet Provider Is Rejected
    [Documentation]    Missing walletProvider returns INVALID_PARAMETER.
    [Tags]    severity:medium    api    regression    wallet
    Given A New Tracking Code Is Ready
    When User Routes Without Wallet Provider
    Then Route Response Should Be Invalid Parameter

[TC-005][Wallet] Concurrent Routes For One Tracking Are Race Safe
    [Documentation]    Parallel routes: one created, rest DUPLICATE; Mongo count is 1.
    [Tags]    severity:high    e2e    regression    wallet
    Given Wallet Transfer Mongo Is Connected
    And A New Tracking Code Is Ready
    When User Sends Concurrent Routes For Same Tracking
    Then Concurrent Route Statuses Should Be One Created Rest Rejected
    And Transfer Should Persist In Mongo
