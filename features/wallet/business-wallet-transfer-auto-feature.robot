*** Settings ***
Resource    steps/wallet/businesses-transfer-auto-step.resource

Test Setup    Initalize A Business And Wallets

*** Test Cases ***
Auto Transfer Between Two Wallets Of A Business
    [Tags]    severity:high   robot:skip
    When Set Auto Transfer Configuration For Internal Transfer
    And Wait For Business Transfer Scheduler
    Then Source Wallet Should Be Decreased
    And Destination Wallet Should Be Increased
    And Report With Valid Data For Internal Transfer Should Be Find In Activity 

Auto Transfer Between Wallets Of Two Businesses
    [Tags]    severity:high   robot:skip
    When Set Auto Transfer Configuration With Different Source Business
    And Wait For Business Transfer Scheduler
    Then External Source Wallet Should Be Decreased
    And Internal Destination Wallet Should Be Increased
    And Report With Valid Data For External Transfer Should Be Find In Activity
