*** Settings ***
Documentation    API Keyword for Getting Admin Underwriters Validation by Business Id
Resource    services/backend/session-service.resource
Variables   config/environment-stage.yaml
Variables   data/los/credit.yaml

*** Keywords ***
GET Credit Admin Underwriters Validation By Business Id
    [Arguments]    ${user_id}    ${business_id}
    [Documentation]    Sends GET request to retrieve underwriter validation by business ID
    
    ${headers}=    Create Dictionary    
    ...    User-Id=${user_id}    
    ...    Content-Type=${CREDIT_CONTENT_TYPE}

    ${url}=    Set Variable    ${MICROSERVICE_BASE_URL}${MS_UNDERWRITING_PATH}/admin/underwriters/validation/${business_id}
    
    ${response}=    GET    url=${url}    headers=${headers}    expected_status=any
    
    RETURN    ${response}
