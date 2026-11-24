*** Settings ***
Resource    steps/pcm/delivery/delivery-handled-step.resource

Test Teardown   Delete Delivery Handled In Database
*** Test Cases ***
[TC-001] Successfully Handled Delivery
    When Delivery Handled
    Then Check In Delivery Handled Database
    
