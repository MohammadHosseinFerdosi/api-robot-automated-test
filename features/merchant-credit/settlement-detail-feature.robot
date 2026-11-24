*** Settings ***
Resource    steps/merchant-credit/utilities/create-merchant-settlement.resource
Resource    apis/merchant-credit/settlement/get-settlements-rules-fund-provider.resource  
Resource    steps/merchant-credit/settlements-rules-step.resource
Resource    steps/merchant-credit/settlement-common-step.resource
Resource    steps/merchant-credit/settlement-detail-step.resource

Suite Setup    Create Merchant    ${GENERAL_SIDE}    
...            ${MERCHANT_TYPE_LEGAL}    
...            20    
...            TestLegalUser    
...            ${NATIONAL_CODE_LEGAL}    
...            ${CELL_NUMBER_LEGAL}    
...            ${REGISTER_CELL_NUMBER_LEGAL}    
...            ${IRAN_VENEZULEA_LEGAL_RULE_ID}    
...            200000000    

Test Teardown    Delete Settlement    ${NATIONAL_CODE_LEGAL}
Suite Teardown    Delete Merchant    ${NATIONAL_CODE_LEGAL}    ${True}

*** Variables ***
${invoice_amount}    10000000

*** Test Cases ***
Display User's Invoice Detail
    Given Initiate Settlement Request As Iran Venezuela User    ${invoice_amount}    
    WHEN Show Invoice Detail
    THEN Invoice Detail Displayed Should Be Equal To User's Settlement Detail 