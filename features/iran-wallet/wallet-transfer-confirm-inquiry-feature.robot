*** Settings ***
Documentation       Confirm and inquiry negatives for unknown tracking codes.
Resource            steps/iran-wallet/wallet-transfer-step.resource
Suite Teardown      Iran Wallet Suite Teardown


*** Test Cases ***
[TC-001][Wallet] Confirm Unknown Tracking Code Returns Transaction Not Found
    [Documentation]    Confirm with unknown tracking code returns TRANSACTION_NOT_FOUND.
    [Tags]    severity:medium    api    regression    wallet
    Given An Unknown Tracking Code Is Ready
    When User Confirms Unknown Tracking Code
    Then Confirm Response Should Be Transaction Not Found

[TC-002][Wallet] Inquiry Unknown Tracking Code Returns Transaction Not Found
    [Documentation]    Inquiry for unknown tracking code returns TRANSACTION_NOT_FOUND.
    [Tags]    severity:medium    api    regression    wallet
    Given An Unknown Inquiry Tracking Code Is Ready
    When User Inquires Unknown Tracking Code
    Then Inquiry Response Should Be Transaction Not Found
