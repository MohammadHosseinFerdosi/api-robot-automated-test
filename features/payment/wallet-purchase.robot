*** Settings ***
Resource    steps/payment/purchase-mng/post-purchases-pay-wallet-step.resource

Test Setup    Create New User And New Business With Purchase Setting And Ticket Config 
Test Teardown    Collect All Amount For Tear Down

*** Test Cases ***

Success Wallet Purchase With Android Agent And Success Verify(Gateway)
    [Tags]    severity:high
    Given Wallet Balance Check 
    And Success Getting Ticket For Purchase With Android Agent(Gateway)
    When Success Getting Ticket's Features With Android Agent(Gateway)
    And Success Select Wallet On Android Agent(Gateway)
    Then Success Wallet Purchase With Android Agent(Gateway)
    And Success Verify On Wallet Purchase With Android Agent(Gateway)
    And Wallet Balance Should Be Equal To Zero



Success Wallet Purchase With Web Agent And Success Verify(Gateway)
    [Tags]    severity:high
    Given Wallet Balance Check 
    And Success Getting Ticket For Purchase With Web Agent(Gateway)
    When Success Getting Ticket's Features With Web Agent(Gateway)
    And Success Select Wallet On Web Agent(Gateway)
    Then Success Wallet Purchase With Web Agent(Gateway)
    And Success Verify On Wallet Purchase With Web Agent(Gateway)
    And Wallet Balance Should Be Equal To Zero



Success Wallet Purchase With Android Agent Without Verify And Success Auto Reverse
    [Tags]    severity:high  robot:skip
    Given Wallet Balance Check 
    And Success Getting Ticket For Purchase With Android Agent(Gateway)
    When Success Getting Ticket's Features With Android Agent(Gateway)
    And Success Select Wallet On Android Agent(Gateway)
    And Success Wallet Purchase With Android Agent(Gateway)
    And Wallet Balance Should Not Be Decreased After Purchase
    Then Success Auto Reverse Wallet Purchase When Verify Does Not Called (Gateway)
    And Wallet Balance Should Be Increased After Reverse



Success Wallet Purchase With Web Agent Without Verify And Success Auto Reverse
    [Tags]    severity:high  robot:skip
    Given Wallet Balance Check 
    And Success Getting Ticket For Purchase With Web Agent(Gateway)
    When Success Getting Ticket's Features With Web Agent(Gateway)
    And Success Select Wallet On Web Agent(Gateway)
    And Success Wallet Purchase With Web Agent(Gateway)
    And Wallet Balance Should Not Be Decreased After Purchase
    Then Success Auto Reverse Wallet Purchase When Verify Does Not Called (Gateway)
    And Wallet Balance Should Be Increased After Reverse




Failed Wallet Purchase With Wrong Ticket 
    [Tags]    severity:high
    Given Success Getting Ticket For Purchase With Web Agent(Gateway)
    When Success Getting Ticket's Features With Web Agent(Gateway)
    And Success Select Wallet On Web Agent(Gateway)
    Then Failed Wallet Purchase With Android Agent Through Enter Wrong Ticket (Gateway)




Failed Wallet Purchase With A Ticket In Confirmed Status(Gateway)
    [Tags]    severity:high
    Given Success Getting Ticket For Purchase With Android Agent(Gateway)
    When Success Getting Ticket's Features With Android Agent(Gateway)
    And Success Select Wallet On Android Agent(Gateway)
    And Success Wallet Purchase With Android Agent(Gateway)
    And Success Verify On Wallet Purchase With Android Agent(Gateway)
    Then Call Wallet Purchase For A Confirmed State Purchase(Gateway)



Failed Wallet Purchase With A Ticket In Paied Status(Gateway)
    [Tags]    severity:high
    Given Success Getting Ticket For Purchase With Android Agent(Gateway)
    When Success Getting Ticket's Features With Android Agent(Gateway)
    And Success Select Wallet On Android Agent(Gateway)
    And Success Wallet Purchase With Android Agent(Gateway)
    Then Call Wallet Purchase For A Paid State Purchase(Gateway)







