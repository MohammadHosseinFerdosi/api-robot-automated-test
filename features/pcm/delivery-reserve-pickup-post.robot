*** Settings ***
Resource    steps/pcm/logistics/delivery-reserve-pickup-post-step.resource


*** Test Cases ***
Succussfully pickup Post
    Given Selecting pickup Post
    when Check In Db Reserve
    then Check In Db Delete Reserve
