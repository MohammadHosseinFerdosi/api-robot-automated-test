*** Settings ***
Resource    steps/pcm/delivery/delivery-deliver-to-post-step.resource


*** Test Cases ***
 succussfully deliver to post
    Given deliver to post
    when register tracking code
    Then check in db reserve
    And check in db deletereserve
