*** Settings ***
Resource        steps/wallet/users-total-balance-step.resource
Resource        steps/wallet/users-total-balance-initialization.resource

Suite Setup     Initialize User And Wallets
Suite Teardown  Collect All Amount For Tear Down


*** Test Cases ***
Check Aggregated Balance For Multi Type Wallet User
    [Tags]    severity:high
    Given Login With A Multi Type Wallet User To App
    When Get User Aggregated Balance
    Then All Unexpired And Default Wallet Amount Should Be Aggregated In Balance Result

Check Aggregated Balance For User With Only Time-Bound Wallet
    [Tags]    severity:high
    Given Login With Only Time-Bound Wallet User To App
    When Get User Aggregated Balance
    Then Just Time-Bound Balance Should Have Value And Cashout And Not-Cashout Should Be Zero

Check Aggregated Balance For User With Only Expired Time-Bound Wallet
    [Tags]    severity:high
    Given Login With Only Expired Time-Bound Wallet User To App
    When Get User Aggregated Balance
    Then All Balances Should Be Zero

Check Aggregated Balance For User With Only Default Wallet
    [Tags]    severity:high
    Given Login With Only Default Wallet User To App
    When Get User Aggregated Balance
    Then Just Cashout And Non-Cashout Should Have Value And Time-Bound Balance Should Be Zero

Check Aggregated Balance For User With Only Default Cashoutable Wallet
    [Tags]    severity:high
    Given Login With Only Default Cashoutable Wallet User To App
    When Get User Aggregated Balance
    Then Just Cashout Should Have Value And Time-Bound And Non-Cashout Balance Should Be Zero

Check Aggregated Balance For User With Only Non-Cashoutable Default Wallet
    [Tags]    severity:high
    Given Login With Only Default Non-Cashoutable Wallet User To App
    When Get User Aggregated Balance
    Then Just Non-Cashout Should Have Value And Time-Bound And Cashout Balance Should Be Zero

Check Aggregated Balance For User Without Wallet
    [Tags]    severity:medium
    Given Login For Without Wallet User To App
    When Get User Aggregated Balance
    Then All Balances Should be Zero

Check Aggregated Balance With Invalid User
    [Tags]    severity:low
    When Get Aggregated Balance With Invalid User
    Then Response Should Be Failed With User Not Found Content 

