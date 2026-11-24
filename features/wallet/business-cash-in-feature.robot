*** Settings ***
Resource        steps/wallet/businesses-cash-in-step.resource

Test Setup      Initilaize A Business


*** Test Cases ***
Validate Business Cash-in
    [Tags]    severity:high
    When Business Cash-in    ${WALLET_NAME_DATA}
    And Get Currnet Balance    ${WALLET_NAME_DATA}
    Then Wallet Amount Should Be Increased By Input Amount

Cash-in For Undefiend Business
    [Tags]    severity:low
    When Business Cash-in    ${WALLET_NAME_DATA}  business_id=${INVALID_BUSINESS_ID}
    Then Cash-in Should Be Failed With    ${INVALID_BUSINESS_ID_FAILURE_CONTENT}

Cash-in For Undefined Wallet
    [Tags]    severity:low
    When Business Cash-in    ${INVALID_WALLET_NAME}
    Then Cash-in Should Be Failed With    ${INVALID_WALLET_NAME_FAILURE_CONTENT}

Cahs-in With Repetitive Ref Number
    [Tags]    severity:low
    When Business Cash-in    ${WALLET_NAME_DATA}
    And Get Currnet Balance    ${WALLET_NAME_DATA}
    And Business Cash-in    ${WALLET_NAME_DATA}
    And Get Currnet Balance    ${WALLET_NAME_DATA}
    Then Wallet Amount Should Not Be Increased
