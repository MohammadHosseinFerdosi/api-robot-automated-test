*** Settings ***
Library     Browser
Library    String
*** Variables ***
${DEFAULT_ELEMENT_TIMEOUT}    20s
${MAX_RETRY}                  5
${WAIT_TIME}                  2s
*** Keywords ***
Get Page URL
    RETURN    /top-up/confirm

Get Page Elements
    &{elements}    Create Dictionary
    ...    wallet=xpath=//div[div[contains(text(),'کیف پول')]]
    ...    ipg=xpath=//div[div[contains(text(),'درگاه پرداخت اینترنتی')]]
    ...    bnpl=xpath=//div[div[contains(text(),'پرداخت اعتباری')]]
    ...    payment_button=xpath=//button[span[normalize-space(.)='پرداخت']]
    ...    confirm_and_pay_btn=xpath=//button[span[normalize-space(.)='تایید و پرداخت']]
    ...    increase_and_pay_btn=xpath=//button[span[normalize-space(.)='افزایش موجودی و پرداخت']]
    ...    increase_amount_bottom_sheet=xpath=//app-cash-in-and-pay
    ...    exit_btn=xpath=//*[@class='btn btn-decline']
    ...    cancelation_alert=xpath=//app-badge-alert
    ...    cancel_payment=xpath=//button[contains(normalize-space(.),'انصراف از پرداخت')]
    ...    back_button=//ngx-app-bar//button[.//i[contains(@class,'icon-arrow-right-linear')]]
    ...    amount=xpath=//*[@class='price-number']
    RETURN    ${elements}

Should Be On UPG Page
    ${elements}    Get Page Elements
    Wait For Elements State    ${elements['ipg']}    visible    ${DEFAULT_ELEMENT_TIMEOUT}

Return Payment Amount
    ${elements}=    Get Page Elements
    Browser.Wait For Elements State    ${elements['amount']}    visible    ${DEFAULT_ELEMENT_TIMEOUT}
    ${amount}=    Browser.Get Text    ${elements['amount']}
    ${amount}=    Convert Persian To English    ${amount}
    ${amount}=    Replace String    ${amount}    ریال    ${EMPTY}
    ${amount}=    Replace String    ${amount}    ,    ${EMPTY}
    ${amount}=    Replace String    ${amount}    ${SPACE}    ${EMPTY}
    ${amount}=    Replace String    ${amount}    \u00A0    ${EMPTY}
    ${amount}=    Evaluate    ''.join(ch for ch in """${amount}""" if ch.isdigit())
    RETURN    ${amount}

Convert Persian To English
    [Arguments]    ${persian_number}
    ${persian_digits}    Set Variable    ۰۱۲۳۴۵۶۷۸۹
    ${english_digits}    Set Variable    0123456789
    ${english_number}    Set Variable    ${persian_number}
    FOR    ${i}    IN RANGE    0    10
        ${english_number}    Replace String    ${english_number}    ${persian_digits}[${i}]    ${english_digits}[${i}]
    END
    RETURN    ${english_number}

Select IPG As A Payment Method
    ${elements}    Get Page Elements
    Wait For Elements State    ${elements['ipg']}    visible    ${DEFAULT_ELEMENT_TIMEOUT}
    Click    ${elements['ipg']}

Click On The Confirm And Pay button
    ${elements}    Get Page Elements
    Wait For Elements State    ${elements['confirm_and_pay_btn']}    visible    ${DEFAULT_ELEMENT_TIMEOUT}
    ${upg_url}    Browser.Get Url
    ${response}    Set Variable    ${False}
    WHILE    '${response}' != 'True'
        Click    ${elements['confirm_and_pay_btn']}
        Sleep    5s
        ${current_url}    Browser.Get Url
        IF    '${current_url}' != '${upg_url}'
            ${response}    Set Variable    ${True}
        END
    END

Route On The PSP
    Should Be On UPG Page
    Select IPG As A Payment Method
    Click On The Confirm And Pay button

Click On The Confirm And Pay button V2
    ${elements}    Get Page Elements
    Wait For Elements State    ${elements['confirm_and_pay_btn']}    visible    ${DEFAULT_ELEMENT_TIMEOUT}
    Click    ${elements['confirm_and_pay_btn']}
    ${count}       Set Variable    0
    ${is_gateway}  Set Variable    ${False}
    WHILE    ${count} < ${MAX_RETRY}
        Click    text="تایید و ادامه"
        Sleep    ${WAIT_TIME}
        ${is_gateway}    Run Keyword And Return Status
        ...    Wait For Elements State    text="شماره کارت"    visible    2s
        IF    ${is_gateway}
            Exit For Loop
        END
        ${count}    Evaluate    ${count} + 1
    END
    Run Keyword Unless    ${is_gateway}    Fail    درگاه لود نشد بعد از ${MAX_RETRY} بار تلاش

Payment Cancelation
    ${elements}    Get Page Elements
    Wait For Elements State    ${elements['exit_btn']}        visible    ${DEFAULT_ELEMENT_TIMEOUT}
    Click    ${elements['exit_btn']}
    Wait For Elements State    ${elements['back_button']}  visible    ${DEFAULT_ELEMENT_TIMEOUT}
    Click    ${elements['back_button']}

