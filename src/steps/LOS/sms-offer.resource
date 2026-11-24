*** Settings ***
Variables   data/los/credit.yaml
Resource    apis/los/Journey/get-credit-offer.resource

*** Keywords ***
Admin Gets Credit Offer Successfully
    ${header}=    Create Dictionary
    ...    Content-Type=${CREDIT_CONTENT_TYPE}
    ...    Origin=${APP_BASE_URL}
    ...    Referer=${APP_BASE_URL}/
    ...    User-Id=${CREDIT_USER_ID}
    
    ${service_type}=    Set Variable    1
    ${amount}=          Set Variable    100000000
    
    ${api_path}=    Set Variable
    ...    ${MS_CREDIT_ONBOARDING_PATH}/offer?serviceType=${service_type}&amount=${amount}
    
    ${result}=    GET Credit Offer
    ...    api_call_side=${MICROSERVICE_SIDE}
    ...    api_path=${api_path}
    ...    header=${header}
    ...    body=${{ {} }}
    ...    basic_auth_param=${EMPTY}
    
    Should Be Equal As Numbers    ${result.status_code}    200