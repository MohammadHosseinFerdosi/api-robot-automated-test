*** Settings ***
Resource        parent.resource



*** Keywords ***
# Keyword to get the Pay page URL
Get Page URL
    RETURN    /transactions

# Keyword to get the base URL of the application

Get App Base URL
    RETURN    ${APP_BASE_URL}

# Keyword to retrieve elements on the pay page and store them in a dictionary

Get Page Elements
    &{elements}    Create Dictionary
    ...    wallet_card=//wallet-card[@class='radius-plus ng-star-inserted']
    ...    bnpl_cards=//credit-card[@class='radius-plus ng-star-inserted']
    ...    credit_cards=//credit-card[contains(@class, 'radius-plus')]//div[contains(@class, 'wallet-amount')]
    ...    bank_cards=//div[@class='ng-trigger ng-trigger-cards ng-tns-c2176462859-6 card-item no-select ng-star-inserted active']//bank-card[@class='radius-plus ng-star-inserted']
    ...    transaction_history_lable=//transactions-applet-past-transactions-summary//div[@class='d-flex gap-small half-section align-items-center ng-star-inserted']//div[1]
    ...    wallet_cash_in_button=//div[@class='cta-item d-flex flex-column gap-small align-items-center justify-content-center ng-star-inserted']
    ...    wallet_cash_out_button=//div[@class='cta-item d-flex flex-column gap-small align-items-center justify-content-center ng-star-inserted' and .//div[text()=' برداشت ']]
    ...    add-gift-card-button=//div[contains(@class, 'cta-icon') and .//i[contains(@class, 'icon-gift-linear')]]
    ...    cards_text_title=//div[@class='title-item d-flex flex-row justify-content-center align-items-center fade']
    ...    next_card_button=//div[@class='title-item title-item d-flex flex-row justify-content-end align-items-center']
    ...    installment_button=//div[contains(@class, 'cta-item') and .//div[contains(text(), 'اقساط')]]
    ...    store_button=//div[contains(@class, 'cta-item') and .//div[text()=' فروشگاه‌ها ']]
    ...    show_all=(//button[@class='bt-2 mode-section ngx-button size-medium style-link'])[1]
    ...    show_all_transactions_history=//button[@class='bt-2 mode-section ngx-button size-medium style-link']
    ...    select-transaction=//div[@class='d-flex gap-minus py-minus']
    ...    time-periode-filter=//*[@id="dpx-page-layout-body"]/common-ui-components-tab-group/div[2]/transactions-applet-transactions-history/common-ui-components-filter/div/div[1]/common-ui-components-chip/div
    ...    backbtnfromtransactionspagetopay=//body[1]/dpx-root[1]/dpx-main[1]/div[6]/div[2]/div[1]/dpx-with-navigation[1]/transactions-applet-transactions[1]/common-ui-components-page-layout[1]/div[1]/div[1]/div[1]/div[1]/div[1]/common-icon-dp-icon[1]/ngx-icon[1]/span[1]/i[1]
    ...    Selectfilter=//div[@class='ng-tns-c3931102699-8 align-items-center border-color-light chip d-flex flex-row h-40 p-small radius-giant surface-elevated ng-star-inserted border-500']
    ...    buycharge=//div[@id="swiper-4549"]/common-ui-components-chip[2]/div

    RETURN    ${elements}

# Keyword to verify if the current page is the home page

Should Be In Pay Page
    ${expected_path}    Get Page URL
    Wait Until Location Contains    ${expected_path}
    ${elements}    Get Page Elements
    Wait Until Page Contains Element    ${elements['transaction_history_lable']}
    Page Should Contain Element    ${elements['transaction_history_lable']}

# Keyword to navigate to a specified location from the pay page

Navigate To
    [Documentation]    Navigate to the specified location from the pay page.
    [Arguments]    ${location}
    ${elements}    Get Page Elements
    ${current_url}    Get Location
    ${pay_url}    Get Page URL
    IF    '${current_url}' != '${pay_url}'    Back To Pay
    ${elements}    Get Page Elements

# Scroll to the desierd location in the pay page

Scroll To
    [Documentation]    Scroll to the desierd location in the pay page.
    [Arguments]    ${location}
    ${elements}    Get Page Elements
    ${current_url}    Get Location
    ${pay_url}    Get Page URL
    IF    '${current_url}' != '${pay_url}'    Back To Pay
    Execute JavaScript    arguments[0].scrollLeft += 100;    ${elements['wallet_card']}    # Scroll right

Back To Pay
    ${base_url}    Get App Base URL
    ${page_url}    Get Page URL
    ${full_url}    Set Variable    ${base_url}${page_url}
    ${current_url}    Get Location
    IF    "${current_url}" != "${full_url}"    Go To    ${full_url}

Go To Desired Card
    [Arguments]    ${DESIRED_CARD_LABLE}
    ${elements}    Get Page Elements
    Wait Until Page Contains Element    ${elements['cards_text_title']}
    ${current_text}    Get Text    ${elements['cards_text_title']}
    IF    '${current_text}' != '${DESIRED_CARD_LABLE}'
        Click Element    ${elements['next_card_button']}
    END
    IF    '${current_text}' == '${DESIRED_CARD_LABLE}'    Exit For Loop

Click On Wallet Card
    ${elements}    Get Page Elements
    Wait Until Element Is Visible    ${elements['wallet_card']}
    Click Element    ${elements['wallet_card']}

Clicks On Cash-in Button
    ${elements}    Get Page Elements
    Wait Until Element Is Visible    ${elements['wallet_card']}
    Click Element    ${elements['wallet_cash_in_button']}

Clicks On Cash-out Button
    ${elements}    Get Page Elements
    Wait Until Element Is Visible    ${elements['wallet_card']}
    Click Element    ${elements['wallet_cash_out_button']}

Clicks On Add Gift Card Button
    ${elements}    Get Page Elements
    Wait Until Element Is Visible    ${elements['wallet_card']}
    Click Element    ${elements['add-gift-card-button']}

Clicks On Bnpl Card's card
    ${elements}    Get Page Elements
    Wait Until Element Is Visible    ${elements['bnpl_cards']}
    Click Element    ${elements['bnpl_cards']}

Clicks On installments's Button
    ${elements}    Get Page Elements
    Wait Until Element Is Visible    ${elements['installment_button']}
    Click Element    ${elements['installment_button']}

Clicks On Credit Card's card
    ${elements}    Get Page Elements
    Wait Until Element Is Visible    ${elements['credit_cards']}
    Click Element    ${elements['credit_cards']}

Clicks On Store's Button
    ${elements}    Get Page Elements
    Wait Until Element Is Visible    ${elements['store_button']}
    Click Element    ${elements['store_button']}

Clicks On Bank Card's Card
    ${elements}    Get Page Elements
    Wait Until Element Is Visible    ${elements['bank_cards']}
    Click Element    ${elements['bank_cards']}
