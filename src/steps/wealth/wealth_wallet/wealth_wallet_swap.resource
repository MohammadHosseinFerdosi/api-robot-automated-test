*** Settings ***
Resource        services/frontend/playwright/browser-service.resource
Resource        services/frontend/playwright/front-auth-service.resource
Resource        steps/app/core/app-login-steps.resource
Resource        pages/app/wealth/variables_in_wealth_pages.resource
Variables       data/wealth/wealth_wallet_deposit.yaml
  

*** Keywords ***
Open Site
    Start Browser Session
    ...    https://example.com
    ...    CHROME
    
User click on treasury swap button in wealth wallet home
        
    UI Login To App  ${cell_number}
    Browser.Go To   https://example.com/hub
    ${current_url}=    Get Url
    IF    "${current_url}" == "https://example.com/mini-app/wealth/wallets/treasury"
        Browser.Go To   https://example.com/hub 
    END
    Wait For Elements State   ${wealth_fund_icon}
    Click    ${wealth_fund_icon}
    TRY
        Wait For Elements State    ${banner_30percent}    visible     timeout=10s
        Click     ${banner_30percent}
    EXCEPT
        Log    Banner not found, continuing
    END
    Wait For Elements State    ${treasury_wallet_icon}
    Click    ${treasury_wallet_icon}
    Wait For Elements State    ${swap_button}
    Click    ${swap_button}
    
The user swap gold balance to fix income with this amount

The swap will done successfully