*** Settings ***
Resource          steps/merchant-credit/utilities/merchant-utilities.resource
Resource          steps/merchant-credit/settlement-inquiry-step.resource
Resource          steps/merchant-credit/settlement-common-step.resource
Suite Setup       Create Merchant
...                  ${GENERAL_SIDE}
...                  ${MERCHANT_TYPE_INDIVIDUAL}
...                  20
...                  TestIndiviualUser
...                  ${NATIONAL_CODE_INDIVIDUAL}
...                  ${CELL_NUMBER_INDIVIDUAL}
...                  ${REGISTER_CELL_NUMBER_INDIVIDUAL}
...                  ${IRAN_VENEZULEA_INDIVIDUAL_RULE_ID}
...                  1990000000
Suite Teardown    Delete Merchant    ${NATIONAL_CODE_INDIVIDUAL}
Test Teardown     Delete Settlement  ${NATIONAL_CODE_INDIVIDUAL}

*** Test Cases ***
The Business Get Inquiry From Early settlement With INIT Status
    Given Initiate Settlement Request As Iran Venezuela User    25000000
    When Business Get Inquiry    0
    Then Receive Response With Shoulde Be Status 0

The Business Get Inquiry From Early settlement With PROVIDER_VERIFICATION_COMPLETED Status
    Given Initiate Settlement Request As Iran Venezuela User    25000000
    When Business Get Inquiry    17
    Then Receive Response With Shoulde Be Status 0

The Business Get Inquiry From Early settlement With PAID Status
    Given Initiate Settlement Request As Iran Venezuela User    25000000
    When The User Paid Fee And Business Get Inquiry   1
    Then Receive Response With Shoulde Be Status 1

The Business Get Inquiry From Early settlement With UPLOADED Status
    Given Initiate Settlement Request As Iran Venezuela User    25000000
    When The User Paid Fee And Business Get Inquiry    3
    Then Receive Response With Shoulde Be Status 3