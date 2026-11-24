*** Settings ***
Resource        steps/wallet/businesses-balance-step.resource

Suite Setup     Initialize A Business With Wallet


*** Test Cases ***
Get a Correct Business Wallets Balance
    [Tags]    severity:high
    Given Cash-in To All Wallets Of A Business
    When Get Business Balance    ${DASHBOARD_SIDE}
    Then Balance Of All Wallets Should Be Increased By Cash-in Amount

Get Balance For Undefined Business
    [Tags]    severity:low
    When Get Business Balance    ${DASHBOARD_SIDE}    ${INVALID_BUSINESS_ID}
    Then Balance List Should Be Empty

Get Balance With Unauthorized User
    [Tags]    severity:medium
    When Get Business Balance    ${MICROSERVICE_SIDE}    user_id=${INVALID_USER_ID}
    Then Request Should Be Failed With    ${INVALID_USER_ID_FAILURE_CONTENT}    ${INVALID_USER_ID_STATUS_CODE}

Get Balance With Invalid Zone Field In Header
    [Tags]    severity:low
    When Get Business Balance    ${MICROSERVICE_SIDE}    user_id=${DASHBOARD_USERNAME}    zone=${INVALID_ZONE}
    Then Request Should Be Failed With    ${INVALID_ZONE_FAILURE_CONTENT}    ${INVALID_ZONE_STATUS_CODE}
