*** Settings ***
Resource            steps/merchant-credit/settlements-init-status-step.resource
Resource            apis/merchant-credit/settlement/get-merchant-credit-settlements-config.resource
Resource            steps/merchant-credit/settlement-config-step.resource
Resource            steps/merchant-credit/utilities/merchant-utilities.resource
Library             DataDriver    file=${EXECDIR}/src/data/merchant-credit/rules-settlement-invoice-amount.csv    encoding=utf_8

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
Test Template       Invoice amount in border minimum amount per fund provider


*** Test Cases ***    Amount
Invoce Amount    ${amount}


*** Keywords ***
Invoice amount in border minimum amount per fund provider
    [Arguments]    ${amount}
    Initiate Settlement Request As Iran Venezuela User    ${amount}
    User Selects Fund Provider And Show Max Credit Amount
    Check Validation Invoice Amount    ${amount}
