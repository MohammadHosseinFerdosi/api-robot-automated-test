*** Settings ***
Resource    services/backend/auth-service.resource


*** Keywords ***
Login Per Business And Set Business Id
    [Documentation]    This Keyword Login Per Business And Set Business Id With Each Business Beacuse Business Id Is Important In Other Test Caes
    [Arguments]    ${business_username}
    IF    "${business_username}"=="${MCRED_KHANOMI_USERNAME}"
        Login For Business    ${MCRED_KHANOMI_USERNAME}    ${MCRED_KHANOMI_PASSWORD}
        RETURN    ${BUSINESS_ID_KHANOMI}
    ELSE IF    "${business_username}"=="${COMPANY_USERNAME}"
        Login For Business    ${COMPANY_USERNAME}    ${COMPANY_PASSWORD}
        RETURN    ${BUSINESS_ID_COMPANY}
    END
