*** Settings ***
Documentation    API Keyword for Admin Underwriters Search
Resource    services/backend/session-service.resource
Variables   config/environment-stage.yaml
Variables   data/los/credit.yaml

*** Keywords ***
POST Credit Admin Underwriters Search
    [Arguments]    ${user_id}    ${page}    ${size}    ${restrictions}    ${orders}
    [Documentation]    Sends POST request to search underwriters
    
    ${headers}=    Create Dictionary    
    ...    User-Id=${user_id}    
    ...    Content-Type=${CREDIT_CONTENT_TYPE}

    ${body}=    Create Dictionary
    ...    restrictions=${restrictions}
    ...    orders=${orders}

    ${url}=    Set Variable    ${MICROSERVICE_BASE_URL}${MS_UNDERWRITING_PATH}/admin/underwriters/search?page=${page}&size=${size}
    
    ${response}=    POST    url=${url}    json=${body}    headers=${headers}    expected_status=any
    
    RETURN    ${response}
