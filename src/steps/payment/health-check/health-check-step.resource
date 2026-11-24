*** Settings ***
Library         String
Library         Collections
Library         library/faker_utils.py    WITH NAME    FakerLibrary
Variables       data/payment/health-check/health-check.yaml
Resource        services/backend/auth-service.resource
Resource        apis/health-check/health-check-service.resource
Resource        apis/uaa/businesses.resource


*** Keywords ***
Login And Getting Token For Platform Business
    [Documentation]    This Keyword Issues Gateway Access Token For Platform Business
    ...    Based On Username And Password As Arguments
    Login For Business
    ...    ${PLATFORM_UESERNAME}
    ...    ${PLATFORM_PASSWORD}

Login And Getting Token For Company Business
    [Documentation]    This Keyword Issues Gateway Access Token For Company Business
    ...    Based On Username And Password As Arguments
    Login For Business
    ...    ${COMPANY_USERNAME}
    ...    ${COMPANY_PASSWORD}

Login And Getting Token For Dashboard With Admin Access
    [Documentation]    This Keyword Issues Access Token For Platform Dashboard
    ...    Based On Username And Password Of Dashboard_Side As Arguments
    Login To Dashboard
    ...    ${DASHBOARD_USERNAME}
    ...    ${DASHBOARD_PASSWORD}

Login And Getting Token For Dashboard Token With User Access
    [Documentation]    This Keyword Issues Access Token For Dashboard
    ...    Based On Username And Password Of Dashboard_Side As Arguments
    Login To Dashboard
    ...    ${USER_ACCESS_USERNAME}
    ...    ${USER_ACCESS_PASSWORD}

Login And Getting Token For Platform App
    [Documentation]    This Keyword Issues App_Side Access Token For Platform App
    ...    Based On Cell Nember As Arguments
    Login To App
    ...    ${CELL_NUMBER}
    ...    ${PIN_CODE}

Call Health Check Service With Platform Business Token
    [Documentation]    This Keyword Calls Health Check Service With Platform Business Token And Receives Response

    ${HEALTH_CHECK_RESPONSE}    User Health Check Status
    ...    ${GENERAL_SIDE}
    Set Test Variable    ${HEALTH_CHECK_RESPONSE}

Call Health Check Service With Platform Dashboard Token
    [Documentation]    This Keyword Calls Health Check Service With Platform Dashboard Token And Receives Response

    ${HEALTH_CHECK_RESPONSE}    User Health Check Status
    ...    ${DASHBOARD_SIDE}
    Set Test Variable    ${HEALTH_CHECK_RESPONSE}

Call Health Check Service With Platform App Token
    [Documentation]    This Keyword Calls Health Check Service With Platform App Token And Receives Response

    ${HEALTH_CHECK_RESPONSE}    User Health Check Status
    ...    ${APP_SIDE}
    Set Test Variable    ${HEALTH_CHECK_RESPONSE}

Check Response Of Health Service With Permissioned Access
    [Documentation]    This Keyword Checks Response Of Health Service And Returns Activity Status
    Should Be Equal As Integers    ${HEALTH_CHECK_RESPONSE['status_code']}    200
    Should Be Equal As Integers    ${HEALTH_CHECK_RESPONSE['body']['statusInfo']}    0
    ...    msg:Health Is Inactive With Status Info: ${HEALTH_CHECK_RESPONSE['body']['statusInfo']}

Check Response Of Health Service With Denied Access
    [Documentation]    This Keyword Checks Response Of Health Service And Returns Activity Status
    Should Be Equal As Integers    ${HEALTH_CHECK_RESPONSE['status_code']}    403
    Should Be Equal As Integers
    ...    ${HEALTH_CHECK_RESPONSE['body']['message']}
    ...    شما اجازه دسترسی به شبکه کمپانی‌پی را ندارید.

Call Business Health Check Service (Platform) With Platform App Token
    [Documentation]    This Keyword Calls Business Health Check Service With Platform App Token And Receives Response

    ${BUSINESS_HEALTH_CHECK_RESPONSE}    Business Health Check Status
    ...    ${APP_SIDE}
    ...    ${PLATFORM_BUSINESS_ID}
    Set Test Variable    ${BUSINESS_HEALTH_CHECK_RESPONSE}

Call Business Health Check Service (Company) With Platform App Token
    [Documentation]    This Keyword Calls Business Health Check Service With Platform App Token And Receives Response

    ${BUSINESS_HEALTH_CHECK_RESPONSE}    Business Health Check Status
    ...    ${APP_SIDE}
    ...    ${COMPANY_BUSINESS_ID}
    Set Test Variable    ${BUSINESS_HEALTH_CHECK_RESPONSE}

Call Business Health Check Service (Platform) With Dashboard Token
    [Documentation]    This Keyword Calls Business Health Check Service With Platform Dashboard Token And Receives Response

    ${BUSINESS_HEALTH_CHECK_RESPONSE}    Business Health Check Status
    ...    ${DASHBOARD_SIDE}
    ...    ${PLATFORM_BUSINESS_ID}
    Set Test Variable    ${BUSINESS_HEALTH_CHECK_RESPONSE}

Call Business Health Check Service (Company) With Dashboard Token
    [Documentation]    This Keyword Calls Business Health Check Service With Platform Dashboard Token And Receives Response

    ${BUSINESS_HEALTH_CHECK_RESPONSE}    Business Health Check Status
    ...    ${DASHBOARD_SIDE}
    ...    ${COMPANY_BUSINESS_ID}
    Set Test Variable    ${BUSINESS_HEALTH_CHECK_RESPONSE}

Call Business Health Check Service (Platform) With Business Token
    [Documentation]    This Keyword Calls Business Health Check Service With Platform Business Token And Receives Response

    ${BUSINESS_HEALTH_CHECK_RESPONSE}    Business Health Check Status
    ...    ${GENERAL_SIDE}
    ...    ${PLATFORM_BUSINESS_ID}
    Set Test Variable    ${BUSINESS_HEALTH_CHECK_RESPONSE}

Call Business Health Check Service (Company) With Business Token
    [Documentation]    This Keyword Calls Business Health Check Service With Platform Business Token And Receives Response

    ${BUSINESS_HEALTH_CHECK_RESPONSE}    Business Health Check Status
    ...    ${GENERAL_SIDE}
    ...    ${COMPANY_BUSINESS_ID}
    Set Test Variable    ${BUSINESS_HEALTH_CHECK_RESPONSE}

Check Response Of Business Health Service With Permissioned Access
    [Documentation]    This Keyword Checks Response Of Health Service And Returns Activity Status
    Should Be Equal As Integers    ${BUSINESS_HEALTH_CHECK_RESPONSE['status_code']}    200
    Should Be Equal As Integers    ${BUSINESS_HEALTH_CHECK_RESPONSE['body']['statusInfo']}    0
    ...    msg:Health Is Inactive With Status Info: ${BUSINESS_HEALTH_CHECK_RESPONSE['body']['statusInfo']}

Check Response Of Business Health Service With Denied Access
    [Documentation]    This Keyword Checks Response Of Health Service And Returns Activity Status
    Should Be Equal As Integers    ${BUSINESS_HEALTH_CHECK_RESPONSE['status_code']}    403
    Should Be Equal As Strings
    ...    ${BUSINESS_HEALTH_CHECK_RESPONSE['body']['result']['message']}
    ...    شما اجازه دسترسی به شبکه کمپانی‌پی را ندارید.
