*** Settings ***
Resource    steps/tms/transaction-type-detection/tejarat-step.resource



Test Setup   Update Activation Bankaccount
*** Test Cases ***
[TC-001] Succussfully Detection Type Tejarat 794
    [Tags]     severity:high    e2e    regression    sanity
    When Manuall Collect From Fetch Data   
    Then checking status manual collect
    And Check In Database From Transaction Type
    And Delete Statment In Database