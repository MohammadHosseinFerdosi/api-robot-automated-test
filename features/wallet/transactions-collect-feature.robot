*** Settings ***
Resource        steps/wallet/transactions/transactions-collect-step.resource
Resource        steps/wallet/transactions/transactions-collect-initialization.resource

Suite Setup     Initialize A User And Business
Suite Teardown  Collect All Amount For Tear Down


*** Test Cases ***
#TODO: Add auto collect test for redeemed or just assigned wallets
Collect All Amount Of A Expired User Wallet
    [Tags]    severity:high
    When Collect Amount From    ${EXPIRED_WALLET_NAME}
    Then Amount Should Be Zero For    ${EXPIRED_WALLET_NAME}
    And Business Wallet Should Be Increased BY    ${INIT_WALLET_AMOUNT}

Collect All Amount Of A Expired Wallet with Zero Amount
    [Tags]    severity:high
    When Collect Amount From    ${EXPIRED_WALLET_NAME_ZERO_AMOUNT}
    Then Transaction Should Be Failed With    ${ZERO_AMOUNT_FAILURE_CONTENT}
    And Business Wallet Amount Should Not Be Changed

Collect Amount Of A Unexpired Wallet
    [Tags]    severity:high
    When Collect Amount From    ${UNEXPIRED_WALLET_NAME}
    Then Transaction Should Be Failed With    ${UNEXPIRED_FAILURE_CONTENT}
    And Business Wallet Amount Should Not Be Changed
    And User Wallet Amount Should Not Be Changed    ${UNEXPIRED_WALLET_NAME}

Collect Amount Of Default Wallet
    [Tags]    severity:high
    When Collect Amount From    ${USER_DEFAULT_WALLET}
    Then Transaction Should Be Failed With    ${DEFAULT_WALLET_FAILURE_CONTENT}
    And Business Wallet Amount Should Not Be Changed
    And User Wallet Amount Should Not Be Changed    ${USER_DEFAULT_WALLET}    ${USER_DEFAULT_WALLET_INIT_BALANCE}

Collect Amount Of A Invalid Source Wallet
    [Tags]    severity:low
    When Collect Amount From    ${INVALID_USER_WALLET_NAME}
    Then Transaction Should Be Failed With    ${INVALID_USER_WALLET_FAILURE_CONTENT}

Collect Amount Of A Invalid User
    [Tags]    severity:low
    When Collect Amount From    ${EXPIRED_WALLET_NAME}    user_id=${INVALID_USER_ID}
    Then Transaction Should Be Failed With    ${INVALID_USER_FAILURE_CONTENT}

Collect For Invalid Business Wallet
    [Tags]    severity:low
    When Collect Amount From    ${EXPIRED_WALLET_NAME}    business_wallet=${INVALID_BUSINESS_WALLET}
    Then Transaction Should Be Failed With    ${INVALID_BUSINESS_WALLET_FAILURE_CONTENT}

Collect For Invalid Business
    [Tags]    severity:low
    When Collect Amount From    ${EXPIRED_WALLET_NAME}    business_id=${INVALID_BUSINESS_ID}
    Then Transaction Should Be Failed With    ${INVALID_BUSINESS_ID_FAILURE_CONTENT}


