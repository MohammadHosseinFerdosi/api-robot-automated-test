*** Settings ***
Resource        steps/wallet/user-transfer/user-wallet-transfer-step.resource
Resource        steps/wallet/user-transfer/user-wallet-initialization.resource

Suite Setup     Initialization Of A User, Business And Their Wallets


*** Test Cases ***
Check The Transfer From A Customer Wallet to Another Customer Wallet - Valid Users
    [Tags]    severity:high
    When Transfer Occurs Between Wallets
    Then Source Wallet Ballance Should Be Decreased
    And Destination Wallet Ballance Should Be Increased
    And User Activity Should Be Found
    And Dashboard Activity Should Be Found

Check The Transfer From A Customer Wallet to Another Customer Wallet - Invalid Source
    [Tags]    severity:medium
    When Transfer Occures From Invalid Source
    Then Incorrect Cell Number Error Should Be Returned

Check The Transfer From A Customer Wallet to Another Customer Wallet - Valid Source & Invalid Destination
    [Tags]    severity:medium
    When Transfer Occures From Valid Source To Invalid Destination
    Then Incorrect Cell Number Error Should Be Returned

Check If The Transfer Amount Is Under Minimum Limit
    [Tags]    severity:medium
    When Transfer Occurs Between Wallets With Under Minimum Limit Amount
    Then Out Of Limit Error Should Be Returned

Check If The Transfer Amount Is Over Max Limit
    [Tags]    severity:medium
    When Transfer Occurs Between Wallets With Over Maximum Limit Amount
    Then Insufficient Balance Error Should Be Returned

Check If The Transfer Amount Is Invalid
    [Tags]    severity:medium
    When Transfer Occurs Between Wallets With Invalid Amount
    Then Input Data Error Should Be Returned

Check If Source And Destination Wallet Is The Same
    [Tags]    severity:medium
    When Transfer Occures Between Same Wallets
    Then Same Wallet Error Should Be Returned

Check The Transfer Between Wallet When Amount Is Non Cashoutable
    [Tags]    severity:medium
    When Transfer Occurs Between Wallets With Non Cashoutable Amount
    Then Ticket Error Should Be Returned
