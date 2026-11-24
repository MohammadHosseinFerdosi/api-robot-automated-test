*** Settings ***
Library     RequestsLibrary
Resource    services/backend/session-service.resource
Variables   config/environment-stage.yaml
Variables   data/los/credit.yaml


*** Keywords ***
POST Credit Admin Organizations
    [Arguments]    ${user_id}    ${business_id}    ${name}    ${crn}
    
    ${headers}=    Create Dictionary    
    ...    User-Id=${user_id}    
    ...    Content-Type=${CREDIT_CONTENT_TYPE}

    ${body}=    Create Dictionary
    ...    businessId=${business_id}
    ...    name=${name}
    ...    crn=${crn}

    ${url}=    Set Variable    ${MICROSERVICE_BASE_URL}${MS_CREDIT_ONBOARDING_PATH}/admin/organizations
    
    ${response}=    POST    url=${url}    headers=${headers}    json=${body}    expected_status=any
    
    RETURN    ${response}
