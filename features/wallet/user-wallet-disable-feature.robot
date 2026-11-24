*** Settings ***

Resource        steps/wallet/user-wallet-disable-initialization.resource
Resource        steps/wallet/user-wallet-disable-step.resource

Suite Setup         Initialize User And Disable Wallet , Business And Wallet
Suite Teardown      Collect All Amount For Tear Down


*** Test Cases ***
Withdraw On Disabled Wallet
    [Tags]    severity:high
    When Withdraw Transaction On Disabled Wallet
    Then Transaction Should Be Failed With    ${TRANSACTION_ON_DISABLE_WALLET_CONTENT}

Transfer on Dsiabled Wallet
    [Tags]    severity:high
    When Transfer Transaction On Disabled Wallet
    Then Transaction Should Be Failed With    ${TRANSACTION_ON_DISABLE_WALLET_CONTENT}

Collect on Dsiables Wallet
    [Tags]    severity:high
    When Collect Transaction On Disabled Wallet
    Then Transaction Should Be Failed With    ${TRANSACTION_COLLECT_ON_DISABLE_WALLET_CONTENT}

Deposit on Dsiables Wallet
    [Tags]    severity:high
    When Deposit Transaction On Disabled Wallet
    Then Transaction Should Be Failed With    ${TRANSACTION_ON_DISABLE_WALLET_CONTENT}

Recieve on Dsiables Wallet
    [Tags]    severity:high
    When Business Receive Transaction From Dsiabled Wallet
    Then Transaction Should Be Failed With    ${TRANSACTION_ON_DISABLE_WALLET_CONTENT}

Payout on Dsiables Wallet
    [Tags]    severity:high
    When Payout To Disabled Wallet
    Then Transaction Should Be Failed With    ${TRANSACTION_ON_DISABLE_WALLET_CONTENT}

Spend on Dsiables Wallet
    [Tags]    severity:high
    When Spend From Disabled Wallet
    Then Transaction Should Be Failed With    ${SPEND_TRANSACTION_ON_DISABLE_WALLET_CONTENT}
