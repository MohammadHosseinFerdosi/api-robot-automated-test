*** Settings ***
Resource        services/frontend/browser-service.resource
Variables       data/los/credit.yaml
Resource        services/frontend/front-auth-service.resource


*** Variables ***
${LOAN_ITEM_ICON}       xpath=//*[@id="hub-walkthrough"]/div/common-app-services-frequent-services-preview[3]/div/div[1]/div/common-icon-dp-icon/ngx-icon/span/i[1]
${LOAN_PAGE_BUTTON}     xpath=//button[@class='bt-1 elevation-sticky is-brand-button mode-section ngx-button size-large style-fill']


*** Keywords ***
Init Browser
    ${app_login_url}=    Set Variable    ${APP_BASE_URL}/auth/login
    VAR    ${option}    add_argument("--disable-notifications")
    Connect To Browser    ${app_login_url}    browser=${FIREFOX}    option=${option}    is_remote=${False}

I am login to app
    Login To App With API    ${CREDIT_CELL_NUMBER}

I click on loan Item
    Wait Until Element Is Visible    ${LOAN_ITEM_ICON}
    Execute JavaScript
    ...    Array.from(document.querySelectorAll("*")).find(el => el.textContent.trim() === "وام")?.click();

I should redirect to loan page
    TRY
        Wait Until Element Is Visible    ${LOAN_PAGE_BUTTON}
    EXCEPT
        ${current_url}=    Get Location
        Wait Until Location Contains    /service/credit/pre-register?step=Plan
    END
