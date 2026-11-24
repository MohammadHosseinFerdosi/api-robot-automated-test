*** Settings ***
Resource    services/backend/amount.resource
Library     Collections


*** Keywords ***
Convert English Digit To Persian Digit
    [Documentation]    This Keyword Receives English Number And Converts It To Persian Number
    [Arguments]    ${english_number}
    ${english_list}=    Convert To List    ${english_number}

    ${persian_numbers}=    Create List    ۰    ۱    ۲    ۳    ۴    ۵    ۶    ۷    ۸    ۹
    ${persian_number}=    Create List
    FOR    ${digit}    IN    @{english_list}
        ${is_number}=    Evaluate    "${digit}".isalnum()
        IF    '${is_number}' == 'True'
            ${int_digit}=    Convert To Integer    ${digit}
            ${persian_digit}=    Get From List    ${persian_numbers}    ${int_digit}
            ${persian_number}=    Catenate    SEPARATOR=    ${persian_number}    ${persian_digit}
            ${persian_number}=    Remove String    ${persian_number}    []
        ELSE
            ${persian_number}=    Catenate    SEPARATOR=    ${persian_number}    ${digit}
        END
    END
    ${string_number_persian}=    Convert To String    ${persian_number}
    RETURN    ${string_number_persian}
