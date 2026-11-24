*** Settings ***
Resource    steps/pcm/logistics/delivery-reserve-return-post-step.resource


*** Test Cases ***
Succussfully Reurn Post
    Given An OTP Was Sent
    and Verify OTP
    when Selecting Return Option Via Post
    Then Check In Db Reserve
    And Check In Db Delete Reserve
