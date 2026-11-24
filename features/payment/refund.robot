*** Settings ***
Resource            steps/payment/refund/refund-initialization.resource
Resource            steps/payment/refund/refund-step.resource

Suite Setup    Create Business With Charged Refund Wallet And Users With Wallets Activated
Suite Teardown    Collect All Amount For Tear Down

*** Test Cases ***
Successful Wallet Auto Refund
    [Tags]    severity:high
    Given Create Verified Wallet Purchase    ${DEFAULT_ONLY_WALLET_CELL_NUMBER}    ${USER_WALLET_CASHOUTABLE_AMOUNT}
    When Auto Refund    ${DEFAULT_ONLY_WALLET_USER_ID}    ${USER_WALLET_CASHOUTABLE_AMOUNT}
    Then Correct Refund Transaction Log Should Be Founded In Report Service    ${USER_WALLET_CASHOUTABLE_AMOUNT}
    And Refund Transaction Log Should Be Founded In Refund Management Service 
    And Increase Cashoutable Balance Of User Wallet By The Refund Amount    ${USER_WALLET_CASHOUTABLE_AMOUNT}    ${DEFAULT_ONLY_WALLET_USER_ID} 
    And Decrease Balance Of Business Refund Wallet By The Refund Amount    ${USER_WALLET_CASHOUTABLE_AMOUNT}   
