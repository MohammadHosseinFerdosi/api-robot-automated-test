*** Settings ***
Resource    steps/pcm/logistics/delivery-reserve-pickup-courier-step.resource


*** Test Cases ***
succussfully pickup courier
    Given Selecting pickup courier
    When check in db reserve
    Then check in db deletereserve
