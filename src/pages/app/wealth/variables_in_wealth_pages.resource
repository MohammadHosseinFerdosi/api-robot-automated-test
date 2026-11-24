
*** Variables ***
${wealth_fund_icon}      css=i.icon-chart-three-line-bold.icon-primary
${wealth_wallet_icon}     id=HOME_TREASURY_WALLET_TEXT
${gold_deposite_btn}    xpath=//wealth-applet-wallet-deposit-card[1]//div[1]//ngx-button[1]//button[1]
${Withdraw_btn}       id=WALLET_BTN_WITHDRAW
${fx_withdraw_btn}    xpath=//p[@class='st-8 text-onback-high'][contains(text(),'طرح درآمد ثابت')]
${gold_withdraw_btn}    xpath=//p[@class='st-8 text-onback-high'][contains(text(),'طلای 24 عیار')]
${fx_deposite_btn}     xpath=//wealth-applet-wallet-deposit-card[2]//div[1]//ngx-button[1]//button[1]
${banner_30percent}      xpath=//*[@id="main-layout"]/div[3]/ngx-bottom-sheet/div/div/div/wealth-applet-profit-onboarding/div/ngx-button/button
${fx_deposite_input}          css=input[aria-label="مبلغ مورد نظر"]
${gold_deposite_input}       css=input[aria-label="مبلغ مورد نظر"]
${AMOUNT_ERROR}          xpath=//div[@class='dg-error-message ng-star-inserted']
${DEPOSIT_SUBMIT}        css=button[type="submit"], css=button:has-text("Deposit")
${all_plan}               xpath=//div[@class='all-width-container opacity-full open']
${fx_deposite_txt}               css=input[placeholder='مبلغ مورد نظر'][type='text']
${fx_deposite_submit_btn}    id=WALLET_FX_CASH_IN
${fx_withdraw_submit_btn}    xpath=//button[@class='bt-2 mode-form ngx-button size-medium style-fill']
${gold_withdraw_submit_btn}    xpath=//button[@class='bt-2 mode-form ngx-button size-medium style-fill']
${gold_deposite_submit_btn}    id=WALLET_GOLD_CASH_IN
${above_maximum_err_text}        حداکثر مبلغ قابل پرداخت درگاه بانکی
${bellow_minimum_err_text}        حداقل مبلغ خرید، 10٬000٬000 ریال است
${confirm&pay_btn}    id=CONFIRM_AND_QUICK_PAYMENT
${gold_plan}         xpath=//p[@class='st-8 text-onback-high'][contains(text(),'طرح طلا')]
${swap_button}            xpath=//button[@class='bt-2 mode-form ngx-button size-small style-link']
${fx_treasury_amount}               css=p.st-8.text-onback-medium[_ngcontent-ng-c160609235='']
${IPG_cancell_btn}    xpath=//button[contains(text(),'انصراف')]
${gold_total_amount}    css=.st-7.text-onback-high
${sheba_add_btn}    xpath=//button[@class='bt-2 mode-form ngx-button size-medium style-link']
${sheba_add_input}    css=input[placeholder='شبا']
${confirm_iban_btn}    id=WALLET_CONFIRM_IBAN
${sheba_icon}    css=div.bt-3
${sheba_spot_icon}    css=button.bt-3
${sheba_del_btn}    css=button.bt-1.is-destructive
${sheba_user_name}    xpath=//span[contains(text(),'بهار حكمت')]
${confirm_cashout_btn}    id=CONFIRM_AND_CASH_OUT