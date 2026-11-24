*** Settings ***
Resource    steps/pcm/logistics/delivery-reserve-pickup-inperson-step.resource


*** Test Cases ***
succussfully pickup inperson
    Given Selecting pickup inperson
    When check in db reserve
    Then check in db deletereserve
