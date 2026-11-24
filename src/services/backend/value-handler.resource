*** Settings ***
Library     String
Library     Collections


*** Keywords ***
Value Handler
    [Documentation]    Value handler is a utility that simply retrieves the value inside database fields with arbitrary types.
    ...    For example if applied on the field such that `$NumberInt:123`, then the value `123` will be extracted adn returned.
    [Arguments]    ${input_value}
    ${value}    Set Variable    ${input_value}
    ${is_dictionary}    Evaluate    isinstance(${input_value}, dict)
    IF    ${is_dictionary}==True
        ${value}    Get Dictionary Values    ${input_value}
        RETURN    ${value}[0]
    ELSE
        ${value}    Set Variable    ${input_value}
        RETURN    ${value}
    END
