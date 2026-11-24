*** Settings ***
Resource            steps/merchant-credit/utilities/create-merchant-settlement.resource
Resource            steps/merchant-credit/settlement-config-step.resource
Resource            steps/merchant-credit/settlements-init-status-step.resource
Library             DataDriver    file=${EXECDIR}/src/data/merchant-credit/config-settlement-max-credit-amount.csv    encoding=utf_8

Suite Setup         Create Merchant
...                     ${GENERAL_SIDE}
...                     ${MERCHANT_TYPE_LEGAL}
...                     20
...                     TestLegalUser
...                     ${NATIONAL_CODE_LEGAL}
...                     ${CELL_NUMBER_LEGAL}
...                     ${REGISTER_CELL_NUMBER_LEGAL}
...                     ${IRAN_VENEZULEA_LEGAL_RULE_ID}
...                     1990000000
Suite Teardown      Delete Merchant    ${NATIONAL_CODE_LEGAL}    ${True}
Test Teardown       Delete Settlement    ${NATIONAL_CODE_LEGAL}
Test Template       User Selects Fund Provider And Show Max Credit Amount Must Be Percentage Invoice Amount


*** Variables ***
${invoice_amount}       20000000


*** Test Cases ***    Amount
Balances Amount    ${amount}


*** Keywords ***
User Selects Fund Provider And Show Max Credit Amount Must Be Percentage Invoice Amount
    [Arguments]
    ...    ${amount}
    Upload Kosar File With Negative Amount And Zero Amount    ${amount}
    Initiate Settlement Request As Iran Venezuela User    ${invoice_amount}
    User Selects Fund Provider And Show Max Credit Amount
    Check Max Credit Amount Based On Balance Amount
