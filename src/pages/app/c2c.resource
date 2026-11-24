*** Settings ***
Resource    parent.resource
Library     String


*** Keywords ***
Get Page URL
    RETURN    /service/c2c

Get Page Elements
    [Tags]    robot:private
    &{elements}    Create Dictionary
    ...    C2C_Lable=//div[contains(text(),'کارت به کارت')]
    ...    add_card_btn=//div[contains(text(),' افزودن کارت ')]//parent::button
    ...    transfer_button=//button[@class='bt-1 mode-form ngx-button size-large style-fill']
    ...    wrong_card_error=//div[@class='dg-error-message ng-star-inserted']
    ...    inactive_card_error=//span[contains(text(),'کارت غیرفعال می باشد.')]
    ...    card_num_text=//input[@inputmode='numeric']
    ...    source_card_scroll=//*[@class='slide-wrapper ng-star-inserted']
    ...    continue_btn=//*[contains(text(),'ادامه')]/parent::button
    ...    c2c_approve_button=//common-ui-components-temp-ngx-button[@class='continue-btn w-100']//button[@class='bt-1 mode-form ngx-button size-large style-fill']
    ...    shaparak_dialog="//app-shaparak-confirmation-bottom-sheet"
    ...    amount_input=//input
    ...    shown_card_number=//div[@class='card-number']
    ...    shown_target_card_owner=//div[@class='name']
    ...    shown_amount=//div[@class='amount']/span
    ...    save_card_btn=//*[@title='ذخیره کارت']
    ...    add_to_repeated_btn=//*[@title='تراکنش پرتکرار']
    ...    cvv2_text_box=//label[text()=' CVV2 ']/following-sibling::input[@type='password']
    ...    card_pass_text_box=//label[text()=' رمز دوم ']/following-sibling::input[@type='password']
    ...    pay_button=//button[contains(@class, 'bt-2')]
    ...    approve_expire_date_btn="//button[contains(.,'تایید')]"
    ...    expire_date_text_box=//label[contains(text(),'تاریخ انقضا')]
    ...    expire_date_overlay="class:overlay"
    ...    target_card_info=//p[contains(text(), 'واریز به کارت')]/preceding-sibling::p[contains(@class, 'text-onback-high')]
    ...    source_card_info=//p[contains(text(), 'پرداخت از کارت')]/preceding-sibling::p[contains(@class, 'text-onback-high')]
    ...    amount_element=//p[@class='payment-price text-onback-high fs-32 m-atom t-4']
    ...    trackingCode_element=//p[contains(text(), 'کد رهگیری')]/preceding-sibling::p
    ...    status_element=class:payment-status
    RETURN    ${elements}

Should Be In C2C Page
    ${expected_path}    Get Page URL
    Wait Until Location Contains    ${expected_path}
    ${elements}    Get Page Elements
    Element Should Be Visible    ${elements['C2C_Lable']}

Add New Card
    [Arguments]    ${card_num}
    Open Add New Source Card Page
    Enter New Card Number    ${card_num}
    Continue to save card

C2C Action
    [Arguments]    ${source_card_number}    ${target_card_number}    ${amount}
    Swipe to find card and click on it    ${source_card_number}
    User Has Entered Target Card    ${target_card_number}
    User Enters An Amount    ${amount}
    Click On Conitue Button

Open Add New Source Card Page
    [Tags]    robot:private
    ${elements}    Get Page Elements
    Wait Until Element Is Visible    ${elements['add_card_btn']}
    Click Element    ${elements['add_card_btn']}

Enter New Card Number
    [Tags]    robot:private
    [Arguments]    ${card_num}
    ${elements}    Get Page Elements
    Wait Until Page Contains    کارت جدید
    Input Text    ${elements['card_num_text']}    ${card_num}

Return The Adding Card Error Message
    ${elements}    Get Page Elements
    Wait Until Element Is Visible    ${elements['wrong_card_error']}
    ${error_message}    Get text    ${elements['wrong_card_error']}
    RETURN    ${error_message}

User Has Entered Target Card
    [Tags]    robot:private
    [Arguments]    ${card_num}
    ${elements}    Get Page Elements
    ${status}    Run Keyword And Return Status    Page Should Contain    ${card_num}
    IF    '${status}'=='True'
        Click Element    //div[contains(text(),' ${card_num} ')]
    ELSE
        Input Text    ${elements['card_num_text']}    ${card_num}
        Click On Conitue Button
    END

Click On Conitue Button
    ${elements}    Get Page Elements
    Click Button    ${elements['continue_btn']}

User Enters An Amount
    [Tags]    robot:private
    [Arguments]    ${transfer-amount}
    ${elements}    Get Page Elements
    Wait Until Element Is Visible    ${elements['amount_input']}
    Input Text    ${elements['amount_input']}    ${transfer-amount}

Return The Target Card Number On C2C Info Buttom Sheet
    ${elements}    Get Page Elements
    Wait Until Page Contains Element    ${elements['shown_card_number']}
    ${shown_card_num_text}    Get Text    ${elements['shown_card_number']}
    ${shown_card_num_text}    Remove String Using Regexp    ${shown_card_num_text}    [ -]
    RETURN    ${shown_card_num_text}

Return The Target Card Owner On C2C Info Buttom Sheet
    ${elements}    Get Page Elements
    Wait Until Page Contains Element    ${elements['shown_target_card_owner']}
    ${shown_owner_text}    Get text    ${elements['shown_target_card_owner']}
    RETURN    ${shown_owner_text}

Reapeated Transaction Button Is Shown
    ${elements}    Get Page Elements
    ${status}    Run Keyword And Return Status
    ...    Wait Until Page Contains Element
    ...    ${elements['add_to_repeated_btn']}
    RETURN    ${status}

Continue To Save Card
    [Tags]    robot:private
    ${elements}    Get Page Elements
    Click Button    ${elements['continue_btn']}

Return The Amount On C2C Info Buttom Sheet
    ${elements}    Get Page Elements
    Wait Until Page Contains Element    ${elements['shown_amount']}
    ${shown_amount_text}    Get Text    ${elements['shown_amount']}
    RETURN    ${shown_amount_text}

Save Card Button Is Shown
    ${elements}    Get Page Elements
    ${status}    Run Keyword And Return Status    Wait Until Page Contains Element    ${elements['save_card_btn']}
    RETURN    ${status}

User Approves C2C Info
    [Arguments]    ${save_card}    ${frequent_transaction}
    IF    '${save_card}'=='False'    User tries not to save card
    IF    '${frequent_transaction}'=='True'
        User tries to save as frequent transaction
    END
    Approve The Transfer Detail

Approve The Transfer Detail
    [Tags]    robot:private
    ${elements}    Get Page Elements
    Wait Until Element Is Visible    ${elements['c2c_approve_button']}
    Click Element    ${elements['c2c_approve_button']}

User Tries Not To Save Card
    [Tags]    robot:private
    ${elements}    Get Page Elements
    Click Element    ${elements['save_card_btn']}

User Tries To Save As Frequent Transaction
    [Tags]    robot:private
    ${elements}    Get Page Elements
    Click Element    ${elements['add_to_repeated_btn']}

Check The Shaparak Message
    ${elements}    Get Page Elements
    ${satus}    Run Keyword And Return Status    Page Should Contain Element    ${elements['shaparak_dialog']}
    RETURN    ${satus}

Swipe To Find Card And Click On It
    [Tags]    robot:private
    [Arguments]    ${card_num}
    ${elements}    Get Page Elements
    Wait Until Element Is Visible    ${elements['source_card_scroll']}
    ${count}    Get Element Count    ${elements['source_card_scroll']}
    FOR    ${i}    IN RANGE    ${count}-1
        ${status}    Run Keyword And Return Status    Click Element    //div[text()=' ${card_num} ']
        Run Keyword And Ignore Error    Click Button    //*[@class='ignore ng-star-inserted']
        IF    '${status}'=='True'    BREAK
        Drag And Drop    (${elements['source_card_scroll']})[${i}+2]    (${elements['source_card_scroll']})[${i}+1]
    END

User Enters Card Credential Data
    [Arguments]    ${cvv2}    ${static_pass}    ${expire_year}=${EMPTY}    ${expire_month}=${EMPTY}
    Enter cvv2    ${cvv2}
    Enter card password    ${static_pass}

Enter CVV2
    [Tags]    robot:private
    [Arguments]    ${cvv2}
    ${elements}    Get Page Elements
    Click Element    ${elements['cvv2_text_box']}
    Input Text    ${elements['cvv2_text_box']}    ${cvv2}

Enter Card Password
    [Tags]    robot:private
    [Arguments]    ${static_pass}
    ${elements}    Get Page Elements
    Input Text    ${elements['card_pass_text_box']}    ${static_pass}

Clicks On Pay Button
    ${elements}    Get Page Elements
    Click Element    ${elements['pay_button']}

Return The C2C Transaction Receipt Details
    ${elements}    Get Page Elements

    ${target_element_value}    Get Text    ${elements['target_card_info']}
    ${target_bank_name}    ${target_last_4_digit}    Split String    ${target_element_value}    -

    ${source_element_value}    Get Text    ${elements['source_card_info']}
    ${source_bank_name}    ${source_last_4_digit}    Split String    ${source_element_value}    -

    ${actual_amount}    Get Text    ${elements['amount_element']}
    ${new_amount}    Remove String    ${actual_amount}    ٬    ریال    ${SPACE}
    ${new_amount}    Convert To Integer    ${new_amount}

    ${result}    Create Dictionary
    ...    target_bank_name=${target_bank_name.strip()}
    ...    target_last_4_digit=${target_last_4_digit.strip()}
    ...    source_bank_name=${source_bank_name.strip()}
    ...    source_last_4_digit=${source_last_4_digit.strip()}
    ...    transfer_amount=${new_amount}

    RETURN    ${result}

Get Tracking Code On C2C Transaction
    ${elements}    Get Page Elements
    ${trackingCode}    Get Text    ${elements['trackingCode_element']}
    RETURN    ${trackingCode}

IS Continue Button Disable
    ${elements}    Get Page Elements
    ${status}    Run Keyword And Return Status    Element Should Be Disabled    ${elements['continue_btn']}
    RETURN    ${status}
