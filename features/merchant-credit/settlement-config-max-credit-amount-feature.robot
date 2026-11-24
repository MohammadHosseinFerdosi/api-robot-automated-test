*** Settings ***
Resource    steps/merchant-credit/utilities/create-merchant-settlement.resource
Resource    steps/merchant-credit/settlement-config-step.resource
Resource    steps/merchant-credit/settlements-init-status-step.resource

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
Suite Teardown      Delete Merchant    ${NATIONAL_CODE_INDIVIDUAL}    ${True}

*** Variables ***
${invoice_amount}    20000000

*** Test Cases ***
Calculate Max Credit Amount Without Balanced Amount
    Given Initiate Settlement Request As Iran Venezuela User    ${invoice_amount}
    When User Selects Fund Provider And Show Max Credit Amount 
    Then Check Max Credit Amount Based On Invoice Amount    ${invoice_amount}
