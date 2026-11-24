*** Settings ***
Library     String


*** Keywords ***
Add Separator To Amount
    [Arguments]    ${amount}
    ${amount}    Convert To Integer    ${amount}
    ${formatted_number}    Evaluate    "{:,}".format(int(${amount}))
    RETURN    ${formatted_number}
