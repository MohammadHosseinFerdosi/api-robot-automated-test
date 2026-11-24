*** Settings ***
Library     DateTime


*** Keywords ***
Convert Milliseconds To Second Epoch
    [Documentation]    This keyword convert Milliseconds To Second epoch Date And Convert to timestamp format
    [Arguments]    ${epoch_input}
    ${temp}    Evaluate    ${epoch_input}/1000
    ${temp}    Convert To Integer    ${temp}
    ${temp}    Convert Date    ${temp}
    RETURN    ${temp}
