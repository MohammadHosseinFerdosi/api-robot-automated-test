*** Settings ***
Resource    pages/app/login.resource
Resource    pages/app/hub.resource
Resource    pages/app/internet.resource
Resource    pages/app/internet-bundles.resource
Resource    services/frontend/playwright/browser-service.resource
Resource    services/frontend/playwright/front-auth-service.resource
Resource    pages/app/confirm-internet.resource
Resource    pages/app/upg.resource
Variables   data/app/mini-apps/internet.yaml

*** Keywords ***
Start Browser
    [Documentation]    Starts browser session with URL and alias.
    ...    Inputs: ${url} (default ${APP_LOGIN_URL}), ${alias} (default ${HEADLESS_CHROME})
    ...    Side effects: Opens browser session.
    [Arguments]    ${url}=${APP_LOGIN_URL}    ${alias}=${HEADLESS_CHROME}
    Start Browser Session    ${url}    ${alias}

Logins To App Via APP Processes
    [Documentation]    Logs in to app using cell number and options.
    ...    Inputs: ${USER_CELL_NUMBER}, ${skip_walkthrough}, ${skip_login_popup}
    ...    Preconditions: Browser is open and on login page.
    ...    Side effects: Completes login process.
    [Arguments]    ${USER_CELL_NUMBER}    ${skip_walkthrough}=${False}    ${skip_login_popup}=${False}
    UI Login To App
    ...    cell_number=${USER_CELL_NUMBER}
    ...    type=${LOGIN_TYPE_APP}
    ...    skip_walk_through=${skip_walkthrough}
    ...    Skip_Login_Popup=${skip_login_popup}

Navigate To Internet Package Page
    [Documentation]    Navigates to internet package page from hub.
    ...    Preconditions: User is on hub page.
    ...    Side effects: Navigates to internet package page.
    ${elements}=    hub.Get Page Elements
    Browser.Wait For Elements State
    ...    ${elements['internet_package']}
    ...    visible
    ...    timeout=${DEFAULT_ELEMENT_TIMEOUT}
    hub.Navigate To    ${INTERNET_PACKAGE_PAGE}
    internet.Should Be On Internet Package Page

Full Flow Of Internet Page
    internet.Enter Cell Number    ${PREPAID_MCI_CELL_NUMBER}
    internet.Click Purchase Internet Button
    internet.Select The Type Of Sim Card    ${PREPAID}

Return To Internet Package Page From Bundles
    [Documentation]    Navigates back from bundles page to internet package page.
    ...    Outputs: ${TRUE} if successful
    ...    Preconditions: User is on bundles page.
    ...    Side effects: Navigates back to internet package page.
    ${clicked}=    internet-bundles.Click Back Button
    IF    ${clicked}
        internet.Should Be On Internet Package Page
        RETURN    ${TRUE}
    ELSE
        Fail    Back button not found or click failed
    END
    
Purchase Internet Package Flow
    [Documentation]    Complete flow for purchasing internet package.
    ...    Inputs: ${cell_number}, ${sim_type}, ${tab_key}, ${package_index}, ${bottom_sheet_action}
    ...    Outputs: &{package_obj}
    ...    Preconditions: User is on internet package page.
    ...    Side effects: Purchases package and navigates through payment flow.
    [Arguments]    ${cell_number}    ${sim_type}    ${tab_key}=${MONTHLY_TAB}    ${package_index}=1    ${bottom_sheet_action}=${NONE}
    Enter Cell Number    ${cell_number}
    Click Purchase Internet Button
    Select The Type Of Sim Card    ${sim_type}
    Should Be On Internet Bundles Page
    Select Bundle Tab    ${tab_key}
    ${package_info}=    Select Bundle Package    ${package_index}
    IF    '${bottom_sheet_action}' != '${NONE}'
        Handle Package Details Bottom Sheet    ${bottom_sheet_action}
    END
    &{package_obj}=    Create Dictionary
    ...    description=${package_info['description']}
    ...    amount=${package_info['amount']}
    ...    amount_raw=${package_info['amount_raw']}
    ...    cell_number=${cell_number}
    Set Test Variable    ${package_obj}
    RETURN    ${package_obj}

Purchase Recommended Internet Package Flow
    [Documentation]    Purchases package using recommended numbers.
    ...    Inputs: ${tab_key}
    ...    Outputs: &{package_obj}
    ...    Preconditions: User is on internet package page.
    ...    Side effects: Selects recommended option and proceeds.
    [Arguments]    ${tab_key}=${MONTHLY_TAB}
    ${elements}    internet.Get Page Elements
    ${cell_number}    internet.Select The Frequent Option
    Select Bundle Tab    ${tab_key}
    ${package_info}=    Select Bundle Package
    &{package_obj}=    Create Dictionary
    ...    description=${package_info['description']}
    ...    amount=${package_info['amount']}
    ...    amount_raw=${package_info['amount_raw']}
    ...    cell_number=${cell_number}
    Set Test Variable    ${package_obj}
    RETURN    ${package_obj}

Validate Package Details
    [Documentation]    Validates package details on confirmation page.
    ...    Preconditions: User is on confirmation page.
    ...    Side effects: Compares package details.
    ${confirm_package_obj}=    Return Internet Package Object
    Should Be Equal    ${package_obj['cell_number']}    ${confirm_package_obj['cell_number']}
    Should Be Equal    ${package_obj['description']}    ${confirm_package_obj['description']}

Validate Payment Amount
    [Documentation]    Validates payment amount matches package amount.
    ...    Preconditions: User is on UPG page.
    ...    Side effects: Compares payment amount.
    ${upg_amount}=    Return Payment Amount
    Should Be Equal    ${upg_amount}    ${package_obj['amount']}

Cancel Payment
    [Documentation]    Cancels payment process.
    ...    Preconditions: User is on UPG page.
    ...    Side effects: Cancels payment.
    upg.Payment Cancelation

Confirm Internet Package Payment
    [Documentation]    Completes the payment flow.
    ...    Preconditions: User is on confirmation page.
    ...    Side effects: Confirms payment and navigates to UPG.
    confirm-internet.Should Be On Confirm Page
    Validate Package Details
    confirm-internet.Confirm The Service Payment
    upg.Should Be On UPG Page
    Validate Payment Amount

Purchase MCI Prepaid Monthly Internet Package
    [Documentation]    Purchases MCI prepaid monthly internet package.
    ...    Preconditions: User is on internet package page.
    ...    Side effects: Purchases package and navigates through payment flow.
    Purchase Internet Package Flow    ${PREPAID_MCI_CELL_NUMBER}    ${PREPAID}    ${MONTHLY_TAB}

Purchase MCI Postpaid Internet Package
    [Documentation]    Purchases MCI postpaid internet package.
    ...    Preconditions: User is on internet package page.
    ...    Side effects: Purchases package and navigates through payment flow.
    Purchase Internet Package Flow    ${POSTPAID_MCI_CELL_NUMBER}    ${POSTPAID}    ${MONTHLY_TAB}    ${FIRST_PACKAGE_INDEX}

Purchase MTN Prepaid Monthly Internet Package
    [Documentation]    Purchases MTN prepaid monthly internet package.
    ...    Preconditions: User is on internet package page.
    ...    Side effects: Purchases package and navigates through payment flow.
    Purchase Internet Package Flow    ${PREPAID_MTN_CELL_NUMBER}    ${PREPAID}    ${MONTHLY_TAB}

Purchase MTN Postpaid Monthly Internet Package
    [Documentation]    Purchases MTN postpaid monthly internet package.
    ...    Preconditions: User is on internet package page.
    ...    Side effects: Purchases package and navigates through payment flow.
    Purchase Internet Package Flow    ${POSTPAID_MTN_CELL_NUMBER}    ${POSTPAID}    ${MONTHLY_TAB}

Purchase TD-LTE Internet Package
    [Documentation]    Purchases TD-LTE internet package.
    ...    Preconditions: User is on internet package page.
    ...    Side effects: Purchases package and navigates through payment flow.
    Purchase Internet Package Flow    ${TD_LTE_CELL_NUMBER}    ${TD_LTE}    ${MONTHLY_TAB}

Purchase Rightel Prepaid Monthly Internet Package
    [Documentation]    Purchases Rightel prepaid monthly internet package.
    ...    Preconditions: User is on internet package page.
    ...    Side effects: Purchases package and navigates through payment flow.
    Purchase Internet Package Flow    ${PREPAID_RI_CELL_NUMBER}    ${PREPAID}    ${MONTHLY_TAB}

Purchase Shatel Data Internet Package
    [Documentation]    Purchases Shatel data internet package.
    ...    Preconditions: User is on internet package page.
    ...    Side effects: Purchases package and navigates through payment flow.
    Purchase Internet Package Flow    ${PREPAID_SHATEL_CELL_NUMBER}    ${DATA}    ${WEEKLY_TAB}

Purchase Shatel Prepaid Internet Package
    [Documentation]    Purchases Shatel prepaid internet package.
    ...    Preconditions: User is on internet package page.
    ...    Side effects: Purchases package and navigates through payment flow.
    Purchase Internet Package Flow    ${PREPAID_SHATEL_CELL_NUMBER}    ${PREPAID}    ${MONTHLY_TAB}

Purchase MCI Prepaid Daily Internet Package
    [Documentation]    Purchases MCI prepaid daily internet package.
    ...    Preconditions: User is on internet package page.
    ...    Side effects: Purchases package and navigates through payment flow.
    Purchase Internet Package Flow    ${PREPAID_MCI_CELL_NUMBER}    ${PREPAID}    ${DAILY_TAB}

Purchase MTN Prepaid Weekly Internet Package
    [Documentation]    Purchases MTN prepaid weekly internet package.
    ...    Preconditions: User is on internet package page.
    ...    Side effects: Purchases package and navigates through payment flow.
    Purchase Internet Package Flow    ${PREPAID_MTN_CELL_NUMBER}    ${PREPAID}    ${WEEKLY_TAB}    ${1}    CONFIRM

Purchase MCI Prepaid Popular Internet Package
    [Documentation]    Purchases MCI prepaid popular internet package.
    ...    Preconditions: User is on internet package page.
    ...    Side effects: Purchases package and navigates through payment flow.
    Purchase Internet Package Flow    ${PREPAID_MCI_CELL_NUMBER}    ${PREPAID}    ${POPULAR_TAB}

Purchase MTN Spatial Internet Package
    [Documentation]    Purchases MTN spatial internet package.
    ...    Preconditions: User is on internet package page.
    ...    Side effects: Purchases package and navigates through payment flow.
    Purchase Internet Package Flow    ${PREPAID_MTN_CELL_NUMBER}    ${PREPAID}    ${ALL_TAB}    ${1}    CONFIRM

Purchase Recommended Internet Package
    [Documentation]    Purchases recommended internet package.
    ...    Preconditions: User is on internet package page.
    ...    Side effects: Selects recommended option and proceeds.
    Purchase Recommended Internet Package Flow    ${DAILY_TAB}