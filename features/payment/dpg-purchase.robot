*** Settings ***
Resource    steps/payment/purchase-mng/post-purchases-pay-dpg-step.resource

Test Setup    Create New User And New Business With Purchase Setting And Ticket Config And An Assigned DPG Terminal 
Test Teardown    Collect All Amount For Tear Down


*** Test Cases ***

Success DPG Purchase With Success Verify(Gateway)
    [Tags]    severity:high
    Given Success Getting Ticket For Purchase With Android Agent(Gateway)
    When Success Getting Ticket For Purchase With Android Agent(Gateway)
    And Success Select DPG On Android Agent(Gateway)
    Then Success DPG Purchase(Gateway)
    And Success Verify On DPG Purchase(Gateway)
    And Success DPG Pruchase Activity In Report


    
Success DPG Purchase Without Verify And Success Auto Reverse
    [Tags]    severity:high    robot:skip
    Given Success Getting Ticket For Purchase With Android Agent(Gateway)
    When Success Getting Ticket For Purchase With Android Agent(Gateway)
    And Success Select DPG On Android Agent(Gateway)
    And Success DPG Purchase(Gateway)
    Then Success Auto Reverse Status When Verify Does Not Called
    And Reversed DPG Pruchase Activity In Report



Success DPG Purchase With Success Verify And Success Manual Reverse
    [Tags]    severity:high
    Given Success Getting Ticket For Purchase With Android Agent(Gateway)
    When Success Getting Ticket For Purchase With Android Agent(Gateway)
    And Success Select DPG On Android Agent(Gateway)
    And Success DPG Purchase(Gateway)
    And Success Verify On DPG Purchase(Gateway)
    Then Success Manual Reverse DPG Purchase Before Settlement Time (Gateway)



Failed DPG Purchase With Wrong Card Number
    [Tags]    severity:high
    Given Success Getting Ticket For Purchase With Android Agent(Gateway)
    When Success Getting Ticket For Purchase With Android Agent(Gateway)
    And Success Select DPG On Android Agent(Gateway)
    Then Failed DPG Purchase Through Enter Wrong Card Info(Gateway)


Failed DPG Purchase With Inactive Card
    [Tags]    severity:high
    Given Success Getting Ticket For Purchase With Android Agent(Gateway)
    When Success Getting Ticket For Purchase With Android Agent(Gateway)
    And Success Select DPG On Android Agent(Gateway)
    Then Failed DPG Purchase Through Enter Inactive Card Info(Gateway)


Failed DPG Purchase With Wrong CVV2 Of Card
    [Tags]    severity:high
    Given Success Getting Ticket For Purchase With Android Agent(Gateway)
    When Success Getting Ticket For Purchase With Android Agent(Gateway)
    And Success Select DPG On Android Agent(Gateway)
    Then Failed DPG Purchase Through Enter Wrong Card Info(Gateway)


Failed DPG Purchase With Wrong Pin Of Card
    [Tags]    severity:high
    Given Success Getting Ticket For Purchase With Android Agent(Gateway)
    When Success Getting Ticket For Purchase With Android Agent(Gateway)
    And Success Select DPG On Android Agent(Gateway)
    Then Failed DPG Purchase Through Enter Wrong Pin Card On(Gateway)



Failed DPG Purchase With Wrong Expiration Date Of Card
    [Tags]    severity:high
    Given Success Getting Ticket For Purchase With Android Agent(Gateway)
    When Success Getting Ticket For Purchase With Android Agent(Gateway)
    And Success Select DPG On Android Agent(Gateway)
    Then Failed DPG Purchase Through Enter Wrong Expiration Date Of Card(Gateway)



Failed DPG Purchase With A Ticket In Confirmed Status
    [Tags]    severity:high  
    Given Success Getting Ticket For Purchase With Android Agent(Gateway)
    When Success Getting Ticket For Purchase With Android Agent(Gateway)
    And Success Select DPG On Android Agent(Gateway)
    And Success DPG Purchase(Gateway)
    And Success Verify On DPG Purchase(Gateway)
    Then Call DPG Purchase For A Confirmed State Purchase(Gateway)



Failed DPG Purchase With A Ticket In Paied Status
    [Tags]    severity:high
    Given Success Getting Ticket For Purchase With Android Agent(Gateway)
    When Success Getting Ticket For Purchase With Android Agent(Gateway)
    And Success Select DPG On Android Agent(Gateway)
    And Success DPG Purchase(Gateway)
    Then Call DPG Purchase For A Paid State Purchase(Gateway)










