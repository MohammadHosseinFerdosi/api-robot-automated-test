*** Settings ***
Documentation    API Keyword for Creating Admin Underwriters
Resource    services/backend/session-service.resource
Variables   config/environment-stage.yaml
Variables   data/los/credit.yaml

*** Keywords ***
POST Credit Admin Underwriters
    [Arguments]       ${user_id}    ${name}    ${business_id}
    [Documentation]    Sends POST request to create an underwriter
    
    ${headers}=    Create Dictionary    
    ...    User-Id=${user_id}    
    ...    Content-Type=${CREDIT_CONTENT_TYPE}

    ${body}=    Create Dictionary
    ...    name=${name}
    ...    businessId=${business_id}

    ${url}=    Set Variable    ${MICROSERVICE_BASE_URL}${MS_UNDERWRITING_PATH}/admin/underwriters
    
    ${response}=    POST    url=${url}    json=${body}    headers=${headers}    expected_status=any
    
    RETURN    ${response}
