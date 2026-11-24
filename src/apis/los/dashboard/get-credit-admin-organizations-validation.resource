*** Settings ***
Resource    services/backend/session-service.resource
Variables   config/environment-stage.yaml
Variables   data/los/credit.yaml

*** Keywords ***
GET Credit Admin Organizations Validation
    [Arguments]    ${user_id}    ${business_id}
    
    ${headers}=    Create Dictionary    
    ...    User-Id=${user_id}    
    ...    Content-Type=${CREDIT_CONTENT_TYPE}

    ${params}=    Create Dictionary
    ...    businessId=${business_id}

    ${url}=    Set Variable    ${MICROSERVICE_BASE_URL}${MS_CREDIT_ONBOARDING_PATH}/admin/organizations/validation
    
    ${response}=    GET    url=${url}    headers=${headers}    params=${params}    expected_status=any
    
    RETURN    ${response}
