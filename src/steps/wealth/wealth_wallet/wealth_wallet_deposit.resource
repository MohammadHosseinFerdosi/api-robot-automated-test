*** Settings ***
Library         DatabaseLibrary
Resource        services/frontend/playwright/browser-service.resource
Resource        services/frontend/playwright/front-auth-service.resource
Resource        steps/app/core/app-login-steps.resource
Resource        pages/app/wealth/variables_in_wealth_pages.resource
Variables       data/wealth/wealth_wallet_deposit.yaml

*** Keywords ***

Deposit Should Work For In Range Number
    [Tags]    deposit    valid-amount    in-range    positive    wealth-wallet    regression    smoke    
    [Arguments]    ${type}    ${amount_case}
    Given User is in wealth wallet
    When The user enters an amount to increase the balance in  ${type}    ${amount_case}
    Then The user can go to next page and choose a method to pay  ${type}
    And The user can go to IPG page
    And The user will return to platform by callback for   cancell

Deposit and Withdraw Shouldnt Work For Out Of Range Number
    [Tags]    deposit    invalid-amount    out-of-range    negative    wealth-wallet    regression    smoke
    [Arguments]    ${type}    ${amount_case}    ${expected_text}
    Given User is in wealth wallet
    When The user enters an amount to increase the balance in  ${type}    ${amount_case}
    Then Continue by click on confirm button is not possible    ${type}
    And The error message will be displayed    ${type}    ${expected_text}

Withdraw Should Work For In Range Number
    [Tags]    withdraw    valid-amount    in-range    positive    wealth-wallet    regression    smoke
    [Arguments]    ${type}    ${amount_case}
    Given User is in wealth wallet
    When The user enters an amount to Withdraw from balance in  ${type}    ${amount_case}
    Then The user can go to next page and choose a card bank to pay  ${type}
    And The user can go to confirmation page    ${type}
    

Open Site
    Start Browser Session
    ...    https://example.com
    ...    CHROME
    #   HEADLESSCHROME

Normalize Amount
    [Arguments]    ${value}
    ${value}=    Replace String    ${value}    ۰    0
    ${value}=    Replace String    ${value}    ۱    1
    ${value}=    Replace String    ${value}    ۲    2
    ${value}=    Replace String    ${value}    ۳    3
    ${value}=    Replace String    ${value}    ۴    4
    ${value}=    Replace String    ${value}    ۵    5
    ${value}=    Replace String    ${value}    ۶    6
    ${value}=    Replace String    ${value}    ۷    7
    ${value}=    Replace String    ${value}    ۸    8
    ${value}=    Replace String    ${value}    ۹    9
    RETURN    ${value}

Enter Amount
    [Arguments]    ${type}    ${amount}
    ${btn}=    Run Keyword If    '${type}'=='fx'    Set Variable    ${fx_deposite_input}
    ...    ELSE              Set Variable    ${gold_deposite_input}
    Wait For Elements State    ${btn}    visible
    Fill Text    ${btn}    ${amount}
Connection to Database
    [Arguments]    ${type}    ${amount_case}    ${Operation type}
    Connect To Database    psycopg2    wealth_db    wealth_user   5ErpGj1WR2Fhb4TD1xZr    10.198.111.81    5432
    ${InstrumentId}=    Run Keyword If    '${type}'=='fx'    Set Variable    270
    ...    ELSE              Set Variable   271
    
    IF    '${amount_case}' == 'over_maximum'
        ${key}=    Set Variable If
        ...    '${Operation type}' == 'deposite'    MaximumPurchasableAmount
        ...    '${Operation type}' == 'withdraw'    MaximumSellableAmount
        ...    ELSE    Fail    Unsupported operation type: ${Operation type}

        ${result}=    Query    SELECT "Value" FROM "InstrumentMetadata" WHERE "InstrumentId" = ${InstrumentId} AND "Key" = '${key}'

        Should Not Be Empty    ${result}
        ${amount}=    Evaluate    int(${result}[0][0]) + 1
    END
    IF    '${amount_case}' == 'bellow_minimum'

        ${key}=    Set Variable If
        ...    '${Operation type}' == 'deposite'    MinimumPurchasableAmount
        ...    '${Operation type}' == 'withdraw'    MinimumSellableAmount
        ...    ELSE    Fail    Unsupported operation type: ${Operation type}

        ${result}=    Query    SELECT "Value" FROM "InstrumentMetadata" WHERE "InstrumentId" = ${InstrumentId} AND "Key" = '${key}'

        Should Not Be Empty    ${result}

        ${base_amount}=    Set Variable    ${result}[0][0]
        ${amount}=    Evaluate    ${base_amount} - 1
        ${amount}=    Convert To Integer    ${amount}

    END
    IF    '${amount_case}' == 'valid_amount_in_middle'
        ${min_key}=    Set Variable If
        ...    '${Operation type}' == 'deposite'    MinimumPurchasableAmount
        ...    '${Operation type}' == 'withdraw'    MinimumSellableAmount
        ...    ELSE    Fail    Unsupported operation type: ${Operation type}

        ${max_key}=    Set Variable If
        ...    '${Operation type}' == 'deposite'    MaximumPurchasableAmount
        ...    '${Operation type}' == 'withdraw'    MaximumSellableAmount
        ...    ELSE    Fail    Unsupported operation type: ${Operation type}

        ${min_result}=    Query    SELECT "Value" FROM "InstrumentMetadata" WHERE "InstrumentId" = ${InstrumentId} AND "Key" = '${min_key}'
        ${max_result}=    Query    SELECT "Value" FROM "InstrumentMetadata" WHERE "InstrumentId" = ${InstrumentId} AND "Key" = '${max_key}'
        
        Should Not Be Empty    ${min_result}
        Should Not Be Empty    ${max_result}

        ${min}=    Evaluate    int(${min_result}[0][0])
        ${max}=    Evaluate    int(${max_result}[0][0])

        ${amount}=    Evaluate    (${min} + ${max}) // 2
        IF    '${Operation type}' == 'withdraw' 
            ${userid}=    Query    SELECT "w"."UserId" FROM "Wallets" w INNER JOIN "Customers" c ON c."UserId"::text = w."UserId"::text WHERE c."PhoneNumber" = '09131562201' AND "InstrumentId" = 270
            ${userid}=    Set Variable    ${userid}[0][0]
            Log    ${userid}
            ${mybalance}=    Query    SELECT "Wallets"."Balance" FROM "Wallets" WHERE "UserId" = '${userid}' AND "InstrumentId" = ${InstrumentId}
            ${my_uncollectable_balance}=    Query    SELECT "Wallets"."UncollectibleBalance" FROM "Wallets" WHERE "UserId" = '${userid}' AND "InstrumentId" = ${InstrumentId}
            ${my_balance}=    Evaluate    int(${my_balance}[0][0])
            ${my_uncollectable_balance}=    Evaluate    int(${my_uncollectable_balance}[0][0])
            ${real_amount}=    Evaluate    ${my_balance}-${my_uncollectable_balance}
            ${real_amount}=    Convert To Integer    ${real_amount}
            IF    ${amount} > ${real_amount}
                ${amount}=    Evaluate    ${real_amount} // 2
            END
        END
    END
    IF    '${amount_case}' == 'valid_amount_in_minimum_range'

        ${key}=    Set Variable If
        ...    '${Operation type}' == 'deposite'    MinimumPurchasableAmount
        ...    '${Operation type}' == 'withdraw'    MinimumSellableAmount
        ...    ELSE    Fail    Unsupported operation type: ${Operation type}

        ${result}=    Query    SELECT "Value" FROM "InstrumentMetadata" WHERE "InstrumentId" = ${InstrumentId} AND "Key" = '${key}'

        Should Not Be Empty    ${result}

        ${amount}=    Set Variable    ${result}[0][0]
        ${amount}=    Convert To Integer    ${amount}
    END
    IF    '${amount_case}' == 'valid_amount_in_maximum_range'

        ${key}=    Set Variable If
        ...    '${Operation type}' == 'deposite'    MaximumPurchasableAmount
        ...    '${Operation type}' == 'withdraw'    MaximumSellableAmount
        ...    ELSE    Fail    Unsupported operation type: ${Operation type}

        ${result}=    Query    SELECT "Value" FROM "InstrumentMetadata" WHERE "InstrumentId" = ${InstrumentId} AND "Key" = '${key}'

        Should Not Be Empty    ${result}

        ${amount}=    Set Variable    ${result}[0][0]
        ${amount}=    Convert To Integer    ${amount}
    END
    Disconnect From Database

    RETURN    ${amount}
Update balance amount
    [Arguments]    ${type}    
    Connect To Database    psycopg2    wealth_db    wealth_user   5ErpGj1WR2Fhb4TD1xZr    10.198.111.81    5432
    IF    "${type}" == "fx"
            ${userid}=    Query    SELECT "w"."UserId" FROM "Wallets" w INNER JOIN "Customers" c ON c."UserId"::text = w."UserId"::text WHERE c."PhoneNumber" = '09131562201' AND "InstrumentId" = 270
            ${userid}=    Set Variable    ${userid}[0][0]
            Log    ${userid}
            ${current_balance}=    Query    SELECT "Wallets"."Balance" FROM "Wallets" WHERE "UserId" = '${userid}' AND "InstrumentId" = 270
            ${current_balance}=    Evaluate    int(${current_balance}[0][0])
            IF    ${current_balance} < ${fx_balance_data}
                Execute Sql String    UPDATE "Wallets" SET "Balance" = ${fx_balance_data} WHERE "UserId" = '${userid}' AND "InstrumentId" = 270; 
                ${current_balance}=    Query    SELECT "Wallets"."Balance" FROM "Wallets" WHERE "UserId" = '${userid}' AND "InstrumentId" = 270;
                ${current_balance}=    Evaluate    int(${current_balance}[0][0])
                Log    message= "now balance for fx is" ${current_balance}
            END
    ELSE IF    "${type}" == "gold"
            ${userid}=    Query    SELECT "w"."UserId" FROM "Wallets" w INNER JOIN "Customers" c ON c."UserId"::text = w."UserId"::text WHERE c."PhoneNumber" = '09131562201' AND "InstrumentId" = 271
            ${userid}=    Set Variable    ${userid}[0][0]
            Log    ${userid}
            ${current_balance}=    Query    SELECT "Wallets"."Balance" FROM "Wallets" WHERE "UserId" = '${userid}' AND "InstrumentId" = 271
            ${current_balance}=    Evaluate    int(${current_balance}[0][0])
            IF    ${current_balance} < ${gold_balance_data}
                Execute Sql String    UPDATE "Wallets" SET "Balance" = ${gold_balance_data}, "WeightInGrams" = ${gold_gram_data} WHERE "UserId" = '${userid}' AND "InstrumentId" = 271;
                ${current_balance}=    Query    SELECT "Wallets"."Balance" FROM "Wallets" WHERE "UserId" = '${userid}' AND "InstrumentId" = 271;
                ${current_balance}=    Evaluate    int(${current_balance}[0][0])
                Log    message= "now balance for gold is" ${current_balance}
            END             
    END
    Disconnect From Database
User is in wealth wallet
    UI Login To App  ${cell_number}
    Browser.Go To   https://example.com/hub
    ${current_url}=    Get Url
    IF    "${current_url}" == "https://example.com/mini-app/wealth/wallets/treasury"
        Browser.Go To   https://example.com/hub 
    END
    Wait For Elements State   ${wealth_fund_icon}
    Click    ${wealth_fund_icon}
    TRY
        Wait For Elements State    ${banner_30percent}    visible     timeout=4s
        Click     ${banner_30percent}
    EXCEPT
        Log    Banner not found,continuing
    END
    Wait For Elements State    ${wealth_wallet_icon}
    Click    ${wealth_wallet_icon}

The user enters an amount to increase the balance in
    [Arguments]    ${type}    ${amount_case} 
    ${btn}=    Run Keyword If    '${type}'=='fx'    Set Variable    ${fx_deposite_btn}
    ...    ELSE              Set Variable    ${gold_deposite_btn}
    ${input}=    Run Keyword If    '${type}'=='fx'    Set Variable    ${fx_deposite_input}
    ...    ELSE              Set Variable    ${gold_deposite_input}
    Wait For Elements State    ${btn}
    Click    ${btn}
    Wait For Elements State    ${input}    visible    2s
    Click    ${input}
    ${amount}=    Connection to Database    ${type}    ${amount_case}    deposite
    Enter Amount    type=${type}    amount=${amount}

The user can go to next page and choose a method to pay
    [Arguments]    ${type}
    ${btn}=    Run Keyword If    '${type}'=='fx'    Set Variable   ${fx_deposite_submit_btn}
    ...    ELSE              Set Variable   ${gold_deposite_submit_btn}
    Wait For Elements State    ${btn}    
    Promise To    Wait For Navigation    url=**/quick-payment/treasury
    Click     ${btn}
    Wait For Navigation    url=**/quick-payment/treasury
    ${CURRENT_URL}=    Get Url
    Should Contain    ${CURRENT_URL}    https://example.com/mini-app/wealth/quick-payment/treasury   
    Wait For Elements State    ${confirm&pay_btn}  visible

The user can go to IPG page
    Click    ${confirm&pay_btn}
    Wait For Elements State  ${IPG_cancell_btn}    timeout=10s
    ${CURRENT_URL}=    Get Url
    Should Contain    ${CURRENT_URL}    https://bpm.shaparak.ir

The user will return to platform by callback for
    [Arguments]    ${callback_type}
    IF    "${callback_type}" == "cancell"
        Wait For Elements State     ${IPG_cancell_btn}
        Click     ${IPG_cancell_btn}
        Wait Until Keyword Succeeds    2s    30s    Current Url Should Contain    https://example.com/mini-app/wealth/receipt?trackingCode=
    END
    ${CURRENT_URL}=    Get Url
    Should Contain    ${CURRENT_URL}    https://example.com/mini-app/wealth/receipt?trackingCode=

Continue by click on confirm button is not possible
    [Arguments]    ${type}
    IF    "${type}" == "fx"
        Wait For Elements State    ${fx_deposite_submit_btn}    disabled    timeout=5s
    ELSE
        Wait For Elements State    ${gold_deposite_submit_btn}    disabled    timeout=5s
    END
The error message will be displayed
    [Arguments]    ${type}    ${expected_text}
    IF    "${type}" == "fx"
        Click    .messages
        Should Show Amount Error    ${expected_text}
    ELSE
        Click     ${gold_total_amount}
        Should Show Amount Error    ${expected_text}
    END

Should Show Amount Error
    [Arguments]    ${expected_text}

    Wait For Elements State    div.dg-error-message.ng-star-inserted    visible
    ${actual_text}=    Browser.Get Text   div.dg-error-message.ng-star-inserted
    Should Contain    ${actual_text}    ${expected_text}

The user enters an amount to Withdraw from balance in
    [Arguments]  ${type}    ${amount_case}
    Update balance amount    ${type}
    Wait For Elements State   ${Withdraw_btn}
    Click    ${Withdraw_btn}
    ${btn}=    Run Keyword If    '${type}'=='fx'    Set Variable    ${fx_withdraw_btn}
    ...    ELSE              Set Variable    ${gold_withdraw_btn}
    Wait Until Keyword Succeeds    2s    30s    Wait For Elements State   ${btn}
    Click    ${btn}
    ${input}=    Run Keyword If    '${type}'=='fx'    Set Variable    ${fx_deposite_input}
    ...    ELSE              Set Variable    ${gold_deposite_input}
    Wait For Elements State    ${input}    visible
    Click    ${input}
    ${amount}=    Connection to Database    ${type}    ${amount_case}    withdraw
    Enter Amount    type=${type}    amount=${amount}
The user can go to next page and choose a card bank to pay
    [Arguments]    ${type}
    IF    "${type}" == 'fx'
        Wait Until Keyword Succeeds    2s    30s    Wait For Elements State   ${fx_withdraw_submit_btn}
        Click    ${fx_withdraw_submit_btn} 
    ELSE IF    "${type}" == 'gold'
        Wait Until Keyword Succeeds    2s    30s    Wait For Elements State   ${gold_withdraw_submit_btn}
        Click    ${gold_withdraw_submit_btn}
    END
    Wait For Navigation    url=**/select-bank-account/treasury
    Wait Until Keyword Succeeds    2s    30s    Current Url Should Contain    select-bank-account/treasury
    TRY   
        Wait For Elements State    ${sheba_spot_icon}
        Click     ${sheba_spot_icon}
        Wait For Elements State    text=حذف شبا    visible    1s
        Click    text=حذف شبا
    EXCEPT
        Log    message=no sheba number was added
    END
    Wait For Elements State    ${sheba_add_btn}
    Click    ${sheba_add_btn}
    Wait For Elements State    ${sheba_add_input}    visible    2s
    click  ${sheba_add_input}
    Fill Text    ${sheba_add_input}    ${sheba_number}
    Wait For Elements State    ${confirm_iban_btn}
    Click    ${confirm_iban_btn}


The user can go to confirmation page
    [Arguments]    ${type}
    Wait For Elements State    ${fx_withdraw_submit_btn}    visible
    Click    ${fx_withdraw_submit_btn}
    Wait Until Keyword Succeeds    30s    2s    Current Url Should Contain    wallet-${type}-withdraw-confirmation/treasury
    Wait For Elements State    ${confirm_cashout_btn}    visible
    Click    ${confirm_cashout_btn}

The user can successfully withdraw from balance
    Wait Until Keyword Succeeds    30s    2s    Current Url Should Contain    walletAction=cashOut

Current Url Should Contain
    [Arguments]    ${expected}
    ${CURRENT_URL}=    Get Url
    Should Contain    ${CURRENT_URL}    ${expected}