*** Settings ***
Documentation       Iran Wallet user balance and admin statement.
Resource            steps/iran-wallet/wallet-transfer-step.resource
Suite Teardown      Iran Wallet Suite Teardown


*** Test Cases ***
[TC-001][Wallet] Primary User Balance Can Be Read
    [Documentation]    Balance for the primary national code returns a numeric balance.
    [Tags]    severity:high    api    smoke    wallet
    Given Primary Iran Wallet User Is Available
    When User Requests Primary Balance
    Then Balance Response Should Be Successful

[TC-002][Wallet] Unregistered National Code Balance Is Rejected
    [Documentation]    Unknown national code returns ACCOUNT_NOT_FOUND.
    [Tags]    severity:medium    api    regression    wallet
    Given Unregistered National Code Is Available
    When User Requests Balance For Unregistered National Code
    Then Balance Response Should Be Account Not Found

[TC-003][Wallet] Balance Without Wallet Provider Is Rejected
    [Documentation]    Missing walletProvider returns INVALID_PARAMETER.
    [Tags]    severity:medium    api    regression    wallet
    Given Primary Iran Wallet User Is Available
    When User Requests Balance Without Wallet Provider
    Then Balance Response Should Be Invalid Parameter

[TC-004][Wallet] Malformed Balance Json Is Bad Request
    [Documentation]    Truncated JSON body returns HTTP Bad Request.
    [Tags]    severity:medium    api    regression    wallet
    Given Primary Iran Wallet User Is Available
    When User Posts Malformed Balance Json
    Then Balance Response Should Be Bad Request

[TC-005][Wallet] Admin External Statement Can Be Read
    [Documentation]    Admin statement returns nonempty page with amount/status on first txn.
    [Tags]    severity:high    api    smoke    wallet
    Given Primary Iran Wallet User Is Available
    When User Requests External Statement
    Then Statement Response Should Be Successful
