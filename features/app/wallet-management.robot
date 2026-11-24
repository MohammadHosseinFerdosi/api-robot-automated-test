*** Settings ***
Resource            steps/app/wallet/wallet-management-step.resource

Suite Setup         Init Browser
Suite Teardown      Close All Browsers


*** Test Cases ***
Check Wallet Management Page Balance
    [Tags]    robot:skip
    When Navigate To Wallet Management Page
    Then User Total Balance Should Be Show