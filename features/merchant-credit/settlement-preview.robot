*** Settings ***
Resource            steps/merchant-credit/utilities/create-merchant-settlement.resource
Resource            steps/merchant-credit/settlement-preview-step.resource

Suite Setup         Create Merchant And Settlement
...                     ${GENERAL_SIDE}
...                     ${MERCHANT_TYPE_INDIVIDUAL}
...                     10
...                     TestIndividualUser
...                     ${NATIONAL_CODE_INDIVIDUAL}
...                     ${CELL_NUMBER_INDIVIDUAL}
...                     ${REGISTER_CELL_NUMBER_INDIVIDUAL}
...                     ${IRAN_VENEZULEA_INDIVIDUAL_RULE_ID}
...                     1990000000    
...                     20000000
Suite Teardown      Delete Merchant    ${NATIONAL_CODE_INDIVIDUAL}    ${True}

*** Test Cases ***
The User Enter Requested Amount And Final Amount Must Be Correct
   Given The User Submit Early Settlement 
   When The User Enters Request Amount    10000000
   Then Check Final Amount That User Can Be Received Is Correct    10000000

The User Enter Requested Amount And Platform Fee Must Be Correct
    [Tags]    robot:skip
   Given The User Submit Early Settlement 
   When The User Enters Request Amount    10000000
   Then Check Platform Fee Is Correct    10000000

The User Enter Requested Amount And Fund Provider Fee Must Be Correct
    [Tags]    robot:skip
   Given The User Submit Early Settlement 
   When The User Enters Request Amount    10000000
   Then Check Fund Provider Fee Is Correct    10000000

The User Enter Requested Amount And Fund Provider Interest Must Be Correct
   Given The User Submit Early Settlement 
   When The User Enters Request Amount    10000000
   Then Check Fund Provider Interest Is Correct    10000000