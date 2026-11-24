*** Settings ***
Resource    steps/tms/account/bank-account-step.resource


*** Test Cases ***
 succussfully create a account 
    Given create a account
    when check in db reserve
    Then check in db deletereserve