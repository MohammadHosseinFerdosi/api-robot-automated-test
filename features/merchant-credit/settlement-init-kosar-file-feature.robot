*** Settings ***
Resource            steps/merchant-credit/settlements-init-kosar-file-step.resource
Resource            steps/merchant-credit/utilities/merchant-utilities.resource
Library             DataDriver    file=${EXECDIR}/src/data/merchant-credit/init-settlement-kosar-file.csv    encoding=utf_8

Suite Setup         Create Merchant
...                     ${GENERAL_SIDE}
...                     ${MERCHANT_TYPE_LEGAL}
...                     20
...                     TestLegalUser
...                     ${NATIONAL_CODE_LEGAL}
...                     ${CELL_NUMBER_LEGAL}
...                     ${REGISTER_CELL_NUMBER_LEGAL}
...                     ${IRAN_VENEZULEA_LEGAL_RULE_ID}
...                     4990000000
Suite Teardown      Delete Merchant    ${NATIONAL_CODE_LEGAL}
Test Template       The user Have a Balance With Amount Negative And Zero Amount


*** Test Cases ***    Amount
Balances Amount    ${amount}


*** Keywords ***
The user Have a Balance With Amount Negative And Zero Amount
    [Arguments]    ${amount}
    Given Upload Kosar File With Negative Amount And Zero Amount    ${amount}
    When The User Requests Early Settlement
    Then Receive "The user's credit limit has been reached" Message
