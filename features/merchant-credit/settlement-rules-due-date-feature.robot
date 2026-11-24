*** Settings ***
Resource            steps/merchant-credit/settlements-rules-step.resource
Resource            steps/merchant-credit/settlements-init-status-step.resource
Resource            steps/merchant-credit/utilities/merchant-utilities.resource
Resource            steps/merchant-credit/settlement-rules-due-date-step.resource
Library             DataDriver    file=${EXECDIR}/src/data/merchant-credit/rules-settlement-due-date.csv    encoding=utf_8

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
Test Template       due date in border minimum due date and delay per fund provider


*** Test Cases ***
difference between due date and today    ${time_gap}


*** Keywords ***
due date in border minimum due date and delay per fund provider
    [Arguments]    ${time_gap}
    Call Settlement Api By Determining Buffer To Due Date    ${time_gap}
    Show Fund Provider To User
    Assert Fund providers Based On Due Date
