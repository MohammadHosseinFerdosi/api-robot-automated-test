*** Settings ***
Resource        steps/wallet/business-transfer-step.resource

Suite Setup     Initialize Business And Wallets With Amount

#TODO: get report from activity and check tracking code
*** Test Cases ***
Validate Transfer Between Two Wallet Of A Business
    [Tags]    severity:high
    When Transfer Between Wallets
    Then Source Wallet Amount Should Be Decreased
    And Destination Wallet Amount Should Be Increased
    And Transfer Transaction Log Should Be Founded In Report Service
    ...    for_source_wallet=${True}
    ...    for_destination_wallet=${True}

Transfer To Undefined Wallet
    [Tags]    severity:low
    When Transfer Between Wallets    destination_wallet_arg=${INVALID_WALLET_NAME}
    Then Transfer Should Be Failed With    ${INVALID_WALLET_FAILURE_CONTENT}
    And Source Wallet Amount Should Not Be Decreased

Transfer From Undefined Wallet
    [Tags]    severity:low
    When Transfer Between Wallets    source_wallet_arg=${INVALID_WALLET_NAME}
    Then Transfer Should Be Failed With    ${INVALID_WALLET_FAILURE_CONTENT}
    And Destination Wallet Amount Should Not Be Increased

Transfer Between Same Source And Destination
    [Tags]    severity:medium
    When Transfer Between Wallets    source_wallet_arg=${WALLET_LIST}[0]    destination_wallet_arg=${WALLET_LIST}[0]
    Then Transfer Should Be Failed With    ${SAME_SOURCE_AND_DESTINATION_WALLET_FAILURE_CONTENT}
    And Source Wallet Amount Should Not Be Decreased

Transfer Upper Than A Wallet Amount
    [Tags]    severity:medium
    When Transfer Between Wallets    amount=${UPPER_BOUND_AMOUNT}
    Then Transfer Should Be Failed With    ${UPPER_BALANCE_TRANSFER_FAILURE_CONTENT}
    And Source Wallet Amount Should Not Be Decreased
    And Destination Wallet Amount Should Not Be Increased

Transfer With Zero Amount
    [Tags]    severity:low
    When Transfer Between Wallets    amount=0
    Then Transfer Should Be Failed With    ${ZERO_AMOUNT_TRANSFER_FAILURE_CONTENT}
    And Source Wallet Amount Should Not Be Decreased
    And Destination Wallet Amount Should Not Be Increased

Transfer With Invalid User ID
    [Tags]    severity:low
    When Transfer Between Wallets    user_id=${INVALID_USER_ID}   agent=${AGENT}
    Then Transfer Should Be Failed With    ${INVALID_USER_ID_FAILURE_CONTENT}
    And Source Wallet Amount Should Not Be Decreased
    And Destination Wallet Amount Should Not Be Increased

Transfer With Invalid Agent
    [Tags]    severity:low
    When Transfer Between Wallets    agent=${INVALID_USER_ID}    user_id=${DASHBOARD_USERNAME}
    Then Transfer Should Be Failed With    ${INVALID_AGENT_FAILURE_CONTENT}
    And Source Wallet Amount Should Not Be Decreased
    And Destination Wallet Amount Should Not Be Increased
