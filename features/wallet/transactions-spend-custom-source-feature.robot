*** Settings ***
Resource        steps/wallet/transactions/transactions-spend-custom-source-initialize.resource
Resource        steps/wallet/transactions/transactions-spend-custom-source-step.resource

Suite Setup     Initialize User And Wallets
Suite Teardown  Collect All Amount For Tear Down


*** Test Cases ***
Spend From Custom Defualt Wallet User That Have Multi Types Wallet
    [Tags]    severity:high
    When Custom Source Spend From Default Wallet Of Multi Types Wallet User
    Then Only Default Wallet Should Be Decreased Based on Spend Amount
    And Destination Business Wallet Should Be Increased Based on Spend Amount

Spend From Custom Unexpired Gift Wallet User That Have Multi Types Wallet
    [Tags]    severity:high
    When Custom Source Spend From Unexpired Gift Wallet Of Multi Types Wallet User
    Then Only Unexpired Gift Wallet Should Be Decreased Based on Spend Amount
    And Destination Business Wallet Should Be Increased Based on Spend Amount

Spend From Custom Wallets With Order, Default And Unexpired User That Have Multi Types Wallet
    [Tags]    severity:high
    When Custom Source Spend From Default Wallet And Unexpired Gift Wallet Of Multi Types Wallet User
    Then Default Wallet Amount Before Unexpired Gift Wallet Amount Should Be Decreased
    And Destination Business Wallet Should Be Increased Based on Spend Amount

Spend From Custom Defualt Wallet User That Have Only Default Wallet
    [Tags]    severity:high
    When Custom Source Spend From Default Wallet
    Then Only Default Wallet Should Be Decreased Based on Spend Amount
    And Destination Business Wallet Should Be Increased Based on Spend Amount

Spend From Custom Unexpired Gift Wallet User That Have Only Gift Wallet
    [Tags]    severity:high
    When Custom Source Spend From Unexpired Gift Wallet
    Then Only Unexpired Gift Wallet Should Be Decreased Based on Spend Amount
    And Destination Business Wallet Should Be Increased Based on Spend Amount

Spend From Custom Expired Gift Wallet User That Have Multi Types Wallet
    [Tags]    severity:high
    When Custom Source Spend From Expired Gift Wallet Of Multi Types Wallet User
    Then Spend Should Be Failed With    ${SPEND_WALLET_USER_NOT_FOUND_FAILURE_CONTENT}
    And All User Wallet Should Not Be Decreased
    And Destination Business Wallet Should Not Be Increased Based on Spend Amount

Spend From Custom Zero Amount Gift Wallet User That Have Multi Types Wallet
    [Tags]    severity:high
    When Custom Source Spend From Zero Amount Gift Wallet Of Multi Types Wallet User
    Then Spend Should Be Failed With    ${ACCOUNT_NOT_FOUND_FAILURE_CONTENT}
    And All User Wallet Should Not Be Decreased
    And Destination Business Wallet Should Not Be Increased Based on Spend Amount

Spend From Custom Wallets With Order, Default And Expired User That Have Multi Types Wallet
    [Tags]    severity:high
    When Custom Source Spend From Default Wallet And Expired Gift Wallet Of Multi Types Wallet User
    Then Spend Should Be Failed With    ${SPEND_WALLET_USER_NOT_FOUND_FAILURE_CONTENT}
    And All User Wallet Should Not Be Decreased
    And Destination Business Wallet Should Not Be Increased Based on Spend Amount

Spend From Custom Wallet With Amount Upper Than User Balance
    [Tags]    severity:high
    When Custom Source Spend From Default Wallet And Unexpired Gift Wallet With Upper Spend Amount
    Then Spend Should Be Failed With    ${SPEND_AMOUNT_UPPER_THAN_TOTAL_AMOUNT_FAILURE_CONTENT}
    And All User Wallet Should Not Be Decreased
    And Destination Business Wallet Should Not Be Increased Based on Spend Amount

Spend From Custom Wallet With Source Amount Not Equal To Main Amount
    [Tags]    severity:high
    When Custom Source Spend From Default Wallet And Unexpired Gift Wallet With Unmatched Spend Amount
    Then Spend Should Be Failed With    ${DIFFERENT_AMOUNT_SOURCE_AND_DESTINATION_FAILURE_CONTENT}
    And All User Wallet Should Not Be Decreased
    And Destination Business Wallet Should Not Be Increased Based on Spend Amount

Spend From Custom Default Wallet For User Without Default Wallet
    [Tags]    severity:high
    When Custom Source Spend From Default Wallet Of Without Wallet User
    Then Spend Should Be Failed With  ${SPEND_WALLET_USER_NOT_FOUND_FAILURE_CONTENT}
    And Destination Business Wallet Should Not Be Increased Based on Spend Amount

# TODO: Spend From Multi User As Transaction Source
