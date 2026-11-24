*** Settings ***
Resource            steps/merchant-credit/settlements-init-due-date-step.resource
Resource            steps/merchant-credit/utilities/merchant-utilities.resource
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

*** Test Cases ***
The Due Date Of The Invoice less Than Tottal OF minDueDate And delay Fields
    Given The DueDate Of Invoice Lesser Than Tottal Delay Day and Minimum Day Of Iran-Ven Provider
    When The user Sumbit Ealy settlement Request
    Then Submit Settlement Request With INIT Status