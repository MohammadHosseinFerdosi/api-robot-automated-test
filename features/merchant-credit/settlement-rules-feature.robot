*** Settings ***
Resource    steps/merchant-credit/utilities/create-merchant-settlement.resource
Resource    apis/merchant-credit/settlement/get-settlements-rules-fund-provider.resource  
Resource    steps/merchant-credit/settlements-rules-step.resource
Resource    steps/merchant-credit/settlements-init-status-step.resource

Suite Setup    Create Merchant And Settlement    ${GENERAL_SIDE}    
...            ${MERCHANT_TYPE_LEGAL}    
...            20    
...            TestLegalUser    
...            ${NATIONAL_CODE_LEGAL}    
...            ${CELL_NUMBER_LEGAL}    
...            ${REGISTER_CELL_NUMBER_LEGAL}    
...            ${IRAN_VENEZULEA_LEGAL_RULE_ID}    
...            200000000    
...            100000000

Test Teardown    Delete Settlement    ${NATIONAL_CODE_LEGAL}
Suite Teardown    Delete Merchant    ${NATIONAL_CODE_LEGAL}    ${True}

*** Test Cases *** 
Display a list of the user's approved fund provider
    Given Show Fund Provider To User  
    When Find User's Approved Fund Providers
    Then Fund Provider Displayed Equal To All User's Approved Fund Provider


