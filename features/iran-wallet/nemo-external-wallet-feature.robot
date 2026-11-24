*** Settings ***
Documentation       Nemo external Iran Wallet balance, cash-in register URL, cash-out negatives.
Resource            steps/iran-wallet/nemo-step.resource
Suite Teardown      Iran Wallet Suite Teardown


*** Test Cases ***
[TC-001][Nemo] User Can Read Nemo External Wallet Balance
    [Documentation]    Authenticated Nemo balance returns SUCCESS with numeric amount.
    [Tags]    severity:high    api    smoke    wallet    nemo
    Given Nemo User Is Authenticated
    When User Requests Nemo External Balance
    Then Nemo Balance Response Should Be Successful

[TC-002][Nemo] User Can Register Nemo Cash In
    [Documentation]    Cash-in register issues a cash-in detailUrl (does not assert money moved).
    [Tags]    severity:high    api    smoke    wallet    nemo
    Given Nemo User Is Authenticated
    When User Registers Nemo Cash In
    Then Nemo Cash In Response Should Be Successful

[TC-003][Nemo] Invalid Cash In Amount Is Rejected
    [Documentation]    Negative amount returns INVALID_PARAMETER.
    [Tags]    severity:medium    api    regression    wallet    nemo
    Given Nemo User Is Authenticated
    When User Registers Nemo Cash In With Invalid Amount
    Then Nemo Cash In Amount Should Be Rejected

[TC-004][Nemo] Cash Out Without Type Is Rejected
    [Documentation]    Missing type returns INVALID_PARAMETER.
    [Tags]    severity:medium    api    regression    wallet    nemo
    Given Nemo User Is Authenticated
    When User Registers Nemo Cash Out Without Type
    Then Nemo Cash Out Without Type Should Be Rejected
