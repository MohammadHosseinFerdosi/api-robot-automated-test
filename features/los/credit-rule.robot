*** Settings ***
Resource        steps/LOS/credit-rule.resource 

*** Test Cases ***
[TC-001] Activate Credit Through Complete Cheque Workflow
    [Tags]    credit    activation    severity:high    api    smoke
    [Documentation]    Complete credit activation flow from pre-register to final activation with cheque workflow
    Given User Completes Pre-Registration Phase
    And Bank Scoring Is Processed
    And User Updates Profile Information
    When User And Admin Complete The Cheque Workflow
    And User Validates Digital Signature
    And User Generates And Signs Documents
    And Credit File Inquiry Is Checked
    And User Initiates Credit Subscription
    Then Admin Completes Allocation And Prepayments
    And Credit Activation Is Closed

[TC-002] User And Admin Complete The Import File Workflow And Archive Credit
    [Tags]    credit     archive     severity:high    api    smoke
    [Documentation]    Archive credit activation flow from Import to Archive Activation
    Given Upload Import File
    When Bank Scoring Is Processed
    And User Updates Profile Information
    Then Archive An Unallocated Credit
[TC-003] Cancels Credit 
    [Tags]    credit     archive     severity:high    api    smoke
    [Documentation]    Cancels credit activation flow from pre-register to Cancels Activation
    Given User Completes Pre-Registration Phase
    And Bank Scoring Is Processed
    And User Updates Profile Information
    When User And Admin Complete The Cheque Workflow-by Scanner
    And User Validates Digital Signature
    And User Generates And Signs Documents
    And Credit File Inquiry Is Checked
    Then User Initiates Credit Subscription
    And Admin Rejects And Cancels Credit