*** Settings ***
Resource    pages/app/login.resource
Resource    pages/app/hub.resource
Resource    pages/app/top-up.resource
Resource    services/frontend/playwright/browser-service.resource
Resource    services/frontend/playwright/front-auth-service.resource
Resource    pages/app/confirm.resource
Resource    pages/app/upg.resource
Variables   data/app/mini-apps/top-up.yaml

*** Keywords ***
Start Browser
    [Arguments]    ${url}=${APP_LOGIN_URL}    ${alias}=${HEADLESS_CHROME}
    Start Browser Session    ${url}    ${alias}  

Logins To App Via APP Processes
    [Arguments]    ${USER_CELL_NUMBER}    ${skip_walkthrough}=${False}    ${skip_login_popup}=${False}
    UI Login To App
    ...    cell_number=${USER_CELL_NUMBER}
    ...    type=${LOGIN_TYPE_APP}
    ...    skip_walk_through=${skip_walkthrough}
    ...    Skip_Login_Popup=${skip_login_popup}

Navigate To Top Up Page
    ${elements}=    hub.Get Page Elements
    Browser.Wait For Elements State
    ...    ${elements['top_up']}
    ...    visible
    ...    timeout=${DEFAULT_ELEMENT_TIMEOUT}
    hub.Navigate To    ${TOP_UP_PAGE}
    top-up.Should Be On Top Up Page

Purchase top-up
    [Documentation]    Executes top-up purchase with parameters.
    ...    Inputs: ${cell_number}, ${sim_type}, ${amount}, ${charge_type}
    ...    Side effects: Fills cell number, selects SIM type, sets amount, and proceeds.
    [Arguments]    ${cell_number}    ${sim_type}    ${amount}    ${charge_type}
    ${elements}    top-up.Get Page Elements
    Enter Cell Number    ${cell_number}
    Click    ${elements['purchase_btn']}
    Select The Type Of Sim Card    ${sim_type}
    Select WOW Top-up             ${charge_type}
    ${amount}    Select The Charge Amount    ${amount}
    Set Top-up Obj    ${cell_number}    ${amount}    ${charge_type}

Purchase MCI Prepaid Top-Up
    Purchase top-up    ${PREPAID_MCI_CELL_NUMBER}    ${PREPAID}    ${None}    ${NORMAL_CHARGE}

Purchase MTNI Prepaid Top-Up
    Purchase top-up    ${PREPAID_MTN_CELL_NUMBER}    ${PREPAID}    ${None}    ${NORMAL_CHARGE}

Purchase Rightel Prepaid Top-Up
    Purchase top-up    ${PREPAID_RI_CELL_NUMBER}    ${PREPAID}    ${None}    ${NORMAL_CHARGE}

Purchase Shatel Prepaid Top-Up
    Purchase top-up    ${PREPAID_Shatel_CELL_NUMBER}    ${PREPAID}    ${None}    ${NORMAL_CHARGE}

Purchase MCI Prepaid Top-Up By Entering Charge Amount
    Purchase top-up    ${PREPAID_MCI_CELL_NUMBER}    ${PREPAID}    ${MANUAL_AMOUNT}    ${NORMAL_CHARGE}

Purchase For Recommended Number
    Purchase Recommended Top-Up    ${None}    ${NORMAL_CHARGE}

Purchase MTNI WOW Prepaid Top-Up
    Purchase top-up    ${PREPAID_MTN_CELL_NUMBER}    ${PREPAID}    ${None}    ${WOW_CHARGE}

Purchase Rightel WOW Prepaid Top-Up
    Purchase top-up    ${PREPAID_RI_CELL_NUMBER}    ${PREPAID}    ${None}    ${WOW_CHARGE}

Purchase MCI Postpaid Top-Up
    Purchase top-up    ${POSTPAID_MCI_CELL_NUMBER}    ${POSTPAID}    ${None}    ${NORMAL_CHARGE}
    Purchase For Permanen Sim    

Set Top-up Obj
    [Arguments]    ${cell_number}    ${amount}    ${charge_type}
    &{top_up_obj}    Create Dictionary
    ...    cell_number=${cell_number}
    ...    amount=${amount}
    ...    charge_type=${charge_type}
    Set Test Variable    ${top_up_obj}

Purchase Recommended Top-Up
    [Arguments]    ${amount}    ${charge_type}
    ${elements}    top-up.Get Page Elements
    ${top_up_obj}    Select The Frequent Optin    ${amount}    ${charge_type}
    Set Test Variable    ${top_up_obj}

Validate Details
    ${confirm_top_up_obj}    Return Top-Up Object
    Should Be Equal    ${top_up_obj['cell_number']}    ${confirm_top_up_obj['cell_number']}
    Should Be Equal    ${top_up_obj['amount']}        ${confirm_top_up_obj['amount']}

Validate Payment Amount
    ${upg_amount}    Return Payment Amount
    Should Be Equal    ${upg_amount}    ${top_up_obj['amount']}

Cancel Payment
    upg.Payment Cancelation

Confirm Top-up Payment
    top-up.Click Continue BTN
    confirm.Should Be On Confirm Page
    Validate Details
    confirm.Confirm The Service Payment
    upg.Should Be On UPG Page
    Validate Payment Amount

Payment Cancelation
    Should Be On UPG Page
    Cancel Payment

Purchase For Permanen Sim
    top-up.Click Continue BTN
    top-up.Verify Error Message    ${EXPECTED_ERROR_MESSAGE}

    

