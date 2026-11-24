*** Settings ***
Resource        pages/app/login.resource
Resource        pages/app/home-and-navigation.resource
Resource        pages/app/onboarding.resource
Resource        pages/app/hub.resource
Resource        pages/app/wallet-management.resource
Resource        services/frontend/browser-service.resource
Resource        services/frontend/front-auth-service.resource
Resource        apis/wallet-provider/wallets/get-wallets-users-total-balance.resource
Variables       data/app/wallet/wallet-management.yaml


*** Keywords ***
Init Browser
    ${app_url}    home-and-navigation.Get App Base URL
    VAR    ${option}    add_argument("--disable-notifications")
    Connect To Browser    ${app_url}    browser=${FIREFOX}    option=${option}    is_remote=${True}
    Should Be In Onboarding Page

    # Get user id based on cell number from mysql
    ${db_qury_result}    MySQL Fetch All    db_name=uaa_db
    ...    query=SELECT * FROM uaa_db.users WHERE cell_number="${USER_CELL_NUMBER}" AND zone_id="app"
    Should Be Equal As Integers
    ...    ${db_qury_result['status_code']}
    ...    0
    ...    msg=mysql result should be successful but found: ${db_qury_result['body']}

    ${user_id}    Set Variable    ${db_qury_result['body'][0]['user_id']}

    # Get user total balance with api

    ${balance_api_result}    GET Wallets Users Total Balance
    ...    api_call_side=${MICROSERVICE_SIDE}
    ...    user_id=${user_id}
    ${user_total_balance}    Set Variable    ${balance_api_result['body']['balance']}

    # add thousand delimeter in arabic format
    ${user_total_balance}    Convert To String    ${user_total_balance}
    ${formated_user_total_balance}    Evaluate    "{:,.0f}".format(${user_total_balance}).replace(",", "٬")

    Login To A specific account    ${USER_CELL_NUMBER}

    Set Suite Variable    ${EXPECTED_USER_TOTAL_BALANCE}    ${formated_user_total_balance}

Login To App With A User
    Login To App With API    ${USER_CELL_NUMBER}
    Should Be In Hub Page

Navigate To Wallet Management Page
    hub.Navigate To    ${WALLET_MANAGEMENT_PAGE}
    Should Be In Wallet Management Page

User Total Balance Should Be Show
    Total Balance Should Be    ${EXPECTED_USER_TOTAL_BALANCE}
