*** Settings ***
Resource    steps/pcm/delivery/delivery-request-treasury-output-step.resource


*** Test Cases ***
succussfully treasury output and accept
    Given request treasury output
    when requests accept
    Then check in db reserve
    And check in db deletereserve
