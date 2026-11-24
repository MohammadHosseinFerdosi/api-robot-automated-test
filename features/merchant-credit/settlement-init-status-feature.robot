*** Settings ***
Resource            steps/merchant-credit/settlements-init-status-step.resource
Resource            steps/merchant-credit/utilities/merchant-utilities.resource
Library             DataDriver    file=${EXECDIR}/src/data/merchant-credit/init-settlement.csv    encoding=utf_8

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
Suite Teardown      Delete Merchant    ${NATIONAL_CODE_LEGAL}    ${True}
Test Teardown       Delete Settlement    ${NATIONAL_CODE_LEGAL}
Test Template       The User Submit Early Settlement Request With Invoice Amounts In the border intervals of the minimum fee


*** Test Cases ***    Amount
Invoce Amount    ${amount}


*** Keywords ***
The User Submit Early Settlement Request With Invoice Amounts In the border intervals of the minimum fee
    [Arguments]    ${amount}
    Initiate Settlement Request As Iran Venezuela User    ${amount}
    In the border intervals of the minimum fee    ${amount}
    Submit Settlement Request With INIT Status
