*** Settings ***
Resource        pages/app/login.resource
Resource        pages/app/home-and-navigation.resource
Resource        pages/app/pay.resource
Resource        pages/app/hub.resource
Resource        pages/app/cash-in.resource
Resource        pages/app/cash-out.resource
Resource        pages/app/credit-card's-managment.resource
Resource        pages/app/stores.resource
Resource        pages/app/bnpl-overview.resource
Resource        pages/app/wallet-management.resource
Resource        pages/app/c2c.resource
Resource        services/frontend/browser-service.resource
Resource        services/frontend/front-auth-service.resource
Variables       data/app/hub/hub.yaml
Variables       data/app/pay/pay.yaml


*** Keywords ***
Init Browser
    VAR    ${option}    add_argument("--disable-notifications")
    VAR    ${option2}    add_argument("--disable-gpu")

    ${app_url}    pay.Get App Base URL
    Connect To Browser    ${app_url}    browser=${FIREFOX}    option=${option}    option=${option2}  is_remote=${False}


    # Get user id based on cell number from mysql
    ${db_qury_result}    MySQL Fetch All    db_name=uaa_db
    ...    query=SELECT * FROM uaa_db.users WHERE cell_number="${USER_CELL_NUMBER}" AND zone_id="app"
    Should Be Equal As Integers
    ...    ${db_qury_result['status_code']}
    ...    0
    ...    msg=mysql result should be successful but found: ${db_qury_result['body']}

    Login To A specific account    ${USER_CELL_NUMBER}

    ${user_id}    Set Variable    ${db_qury_result['body'][0]['user_id']}

Navigate To Pay Page
    hub.Navigate To    ${PAY_PAGE}
    Should Be In Pay Page

Clicks On Wallet Card
    pay.Click On Wallet Card

Redirects To Wallet Management Page And Turns Back To Pay Page
    Should Be In Wallet Management Page
    wallet-management.Click On Back Button

Clicks On Cash-in Btn
    pay.Clicks On Cash-in Button

Redirects To Cash-in Page And Turns Back To Pay Page
    Should Be In Cash-in Page
    cash-in.Click On Back Button

Clicks On Cash-out Btn
    pay.Clicks On Cash-out Button

Redirects To Cash-out Page And Turns Back To Pay Page
    Should Be In Cash-out Page
    cash-out.Click On Back Button

Clicks On Add Gift Card Btn
    pay.Clicks On Add Gift Card Button

Switch to bnpl's card
    Should Be In Pay Page
    Go To Desired Card    BNPL_CARD_TITLE

Clicks On Bnpl card
    pay.Clicks On Bnpl Card's card

Clicks On installments's Button
    pay.Clicks On installments's Button

Redirects To installments Page And Turns Back To Pay Page
    ${elements}    pay.Get Page Elements

Switch to Credit Card's card
    Should Be In Pay Page
    Go To Desired Card    CREDIT_CARD_TITLE

Clicks On Credit card
    Clicks On Credit Card's card

Redirects To Credit Card's Managment Page And Turns Back To Pay Page
    Should Be In Credit Card's Managment Page
    credit-card's-managment.Click On Back Button

Clicks On Store's Btn
    pay.Clicks On Store's Button

Redirects To Store's Page And Turns Back To Pay Page
    Should Be In Stores's Page
    Navigate To Pay Page
    Switch to Credit Card's card

User Redirects To Bnpl's Overview Page And Turns Back To Pay Page
    Should Be In Bnpl's Overview's Page

Switch to Bank Card's card
    Should Be In Pay Page
    Go To Desired Card    BANK_CARD_TITLE

Clicks On Bank Card
    Clicks On Bank Card's Card

User Redirects To C2C Page And Turns Back To Pay Page
    Should Be In c2c's Page
    c2c.Click On Back Button
