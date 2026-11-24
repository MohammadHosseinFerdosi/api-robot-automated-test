*** Settings ***
Resource        steps/wallet/transactions/transactions-payout-auto-refund-init.resource
Resource        steps/wallet/transactions/transactions-payout-auto-refund-step.resource

Suite Setup     Initialize Businesses, Users And Origina Spend Transactions
Suite Teardown  Collect All Amount For Tear Down


*** Test Cases ***
Refund Multi Types Spend With Expired Gift
    [Tags]    severity:high
    When Payout To User With Valid Original Sale Tracking Code And Expired Gift Card
    Then Expired Gift Spend Amount Should Be Transferred To Default Non-Cashoutable Wallet
    And Unexpired Gift Should Be Increased Based On Original Spend
    And Default Cashoutable And Non-Cashoutable Wallets Should Be Increased Based On Original Spend
    And Only Business Refund Wallet Should Be Decreased Based On Spend Amount
    And Payout Inquiry Should Be Successful State

Refund Multi Types Spend With Expired Gift And Multi Origin Source Businesses
    [Tags]    severity:high
    When Payout To User With Valid Multi Spend Original Sale Tracking Code And Multi Expired Gift Card
    Then Expired Gift Spend Amount Should Be Transferred To Default Non-Cashoutable Wallet
    And Unexpired Gift Should Be Increased Based On Original Spend
    And Default Cashoutable And Non-Cashoutable Wallets Should Be Increased Based On Original Spend
    And Only Business Refund Wallet Should Be Decreased Based On Spend Amount

Refund For User That Have Only Gift Wallets And Pay Back To Default Wallet For Expired Gift
    [Tags]    severity:high
    When Payout To Gift Only User With Valid Original Spend And Expired Gift
    Then Expired Gift Spend Amount Should Be Transferred To Default Non-Cashoutable Wallet
    And Unexpired Gift Should Be Increased Based On Original Spend
    And Default Cashoutable And Non-Cashoutable Wallets Should Be Increased Based On Original Spend
    And Only Business Refund Wallet Should Be Decreased Based On Spend Amount

Refund For User That Have Gift And Default Cashsout Wallet And Pay Back To Non-Cashout Wallet For Expired Gift
    [Tags]    severity:high
    when Payout To Cashoutable Only User With Walid Orginal Spend And Expired Gift
    Then Expired Gift Spend Amount Should Be Transferred To Default Non-Cashoutable Wallet
    And Default Cashoutable And Non-Cashoutable Wallets Should Be Increased Based On Original Spend
    And Only Business Refund Wallet Should Be Decreased Based On Spend Amount

Refund For User That Have Gift And Default Non-Cashout Wallet And Pay Back To Non-Cashout Wallet For Expired Gift
    [Tags]    severity:high
    when Payout To Non-Cashoutable Only User With Walid Orginal Spend And Expired Gift
    Then Expired Gift Spend Amount Should Be Transferred To Default Non-Cashoutable Wallet
    And Default Cashoutable And Non-Cashoutable Wallets Should Be Increased Based On Original Spend
    And Only Business Refund Wallet Should Be Decreased Based On Spend Amount

Refund Multi Types Spend With Expired Gift And Percentage Of Spend Amount
    [Tags]    robot:continue-on-failure    severity:high
    when Payout To User With Valid Orginal Spend And Expired Gift And Percentage Of Spend Amount
    Then Expired Gift Spend Amount Should Be Transferred To Default Non-Cashoutable Wallet Based On Percentage Of Spend Amount
    And Unexpired Gift Should Be Increased Based On Percentage Of Spend Amount
    And Default Cashoutable And Non-Cashoutable Wallets Should Be Increased Based On Percentage Of Spend Amount
    And Only Business Refund Wallet Should Be Decreased Based On Percentage Of Spend Amount

Refund For User That Have Just Expired Gift And Pay Back To Non-Cashout Wallet
    [Tags]    severity:high
    when Payout To User With Valid Orginal Spend And Just Expired Gift
    Then Expired Gift Spend Amount Should Be Transferred To Default Non-Cashoutable Wallet
    And Default Cashoutable And Non-Cashoutable Wallets Should Be Increased Based On Original Spend
    And Only Business Refund Wallet Should Be Decreased Based On Spend Amount

Refund Multi Types Spend Without Any Gift Wallet
    [Tags]    severity:high
    when Payout To User With Valid Orginal Spend And Without Gift Wallet
    And Default Cashoutable And Non-Cashoutable Wallets Should Be Increased Based On Original Spend
    And Only Business Refund Wallet Should Be Decreased Based On Spend Amount

Manual Refund Multi Types Spend With Expired Gift
    [Tags]    severity:high
    When Manual Refund To User With Cashoutable Parameter
    Then Only Default Wallet Amount Should Be Increased Based On Refund Amount
    And Only Business Refund Wallet Should Be Decreased Based On Refund Amount

#TODO: Manual Refund Multi Types Spend With Expired Gift And Valid Spend Tracking Code
#    When Manual Refund To User With Cashoutable Parameter And Valid Spend Tracking Code
#    Then Only Default Wallet Amount Should Be Increased Based On Refund Amount
#    And Only Business Refund Wallet Should Be Decreased Based On Refund Amount

Manual Refund To A Expired Gift
    [Tags]    severity:medium
    When Refund To Expired Gift
    Then Refund Should Be Failed With    ${REFUND_TO_EXPIRED_WALLET_FAILURE_CONTENT}
    And All Wallets Amount Should Not Be Changed
    And Business Refund Wallet Should Not Be Decreased

Multi Types Spend With Expired Gift And Multi Origin Source Businesses (Legacy Wallets Payout)
    [Tags]    severity:high
    When Legacy Payout To User With Valid Multi Spend Original Sale Tracking Code And Multi Expired Gift Card
    Then Expired Gift Spend Amount Should Be Transferred To Default Non-Cashoutable Wallet
    And Unexpired Gift Should Be Increased Based On Original Spend
    And Default Cashoutable And Non-Cashoutable Wallets Should Be Increased Based On Original Spend
    And Only Business Refund Wallet Should Be Decreased Based On Spend Amount
    And Legacy Payout Inquiry Should Be Successful State

Multi Types Spend With Expired Gift And Multi Origin Source Businesses (Legacy Wallets Payout Wallets)
    [Tags]    severity:high
    When Legacy Payout Wallet To User With Valid Multi Spend Original Sale Tracking Code And Multi Expired Gift Card
    Then Expired Gift Spend Amount Should Be Transferred To Default Non-Cashoutable Wallet
    And Unexpired Gift Should Be Increased Based On Original Spend
    And Default Cashoutable And Non-Cashoutable Wallets Should Be Increased Based On Original Spend
    And Only Business Refund Wallet Should Be Decreased Based On Spend Amount

Manual Refund Multi Types Spend With Expired Gift (Legacy Wallets Payout)
    [Tags]    severity:high
    When Legacy Manual Refund To User With Cashoutable Parameter
    Then Only Default Wallet Amount Should Be Increased Based On Refund Amount
    And Only Business Refund Wallet Should Be Decreased Based On Refund Amount

Manual Refund Multi Types Spend With Expired Gift (Legacy Wallets Payout Wallets)
    [Tags]    severity:high
    When Legacy Payout Wallet Manual Refund To User With Cashoutable Parameter
    Then Only Default Wallet Amount Should Be Increased Based On Refund Amount
    And Only Business Refund Wallet Should Be Decreased Based On Refund Amount