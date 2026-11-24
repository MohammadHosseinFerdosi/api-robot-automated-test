*** Settings ***
Variables   data/los/credit.yaml
Variables   config/environment-stage.yaml
Library     Collections
Resource    services/db/mysql-db-service.resource

Resource    services/backend/session-service.resource
Resource    apis/los/dashboard/post-credit-admin-organizations-search.resource
Resource    apis/los/dashboard/get-credit-admin-organizations-validation.resource
Resource    apis/los/dashboard/post-credit-admin-organizations.resource

*** Keywords ***

Admin Searches Organizations Successfully
    Admin Searches For Organizations
    Check Organizations Search Success  

Admin Validates Organizations
     Admin Submits Get Organizations Validation Request
     Check Organization Validation Success

Admin Creates Organizations
    Admin Submits Post Organizations Request
    Check Post Organizations Success

Clean Data From Database
     Delete Organization By Business Id


Admin Searches For Organizations
    ${restrictions}=    Create List
    
    ${order_item}=      Create Dictionary    field=activationTime    order=desc
    ${orders}=          Create List          ${order_item}

    ${result}=    POST Credit Admin Organizations Search
    ...    api_call_side=${MICROSERVICE_SIDE}
    ...    user_id=${ADMIN_USER_ID}
    ...    page=${PAGE}
    ...    size=${SIZE}
    ...    restrictions=${restrictions}
    ...    orders=${orders}
    
    Set Test Variable    ${SEARCH_RESPONSE}    ${result}

Check Organizations Search Success
    Should Be Equal As Numbers    ${SEARCH_RESPONSE.status_code}    200


Admin Submits Get Organizations Validation Request
    ${result}=    GET Credit Admin Organizations Validation
    ...    user_id=${ADMIN_USER_ID}
    ...    business_id=${BUSINESS_ID}
    
    Set Test Variable    ${GET_ORG_VALIDATION_RESPONSE}    ${result}

Check Organization Validation Success
    Should Be Equal As Numbers    ${GET_ORG_VALIDATION_RESPONSE.status_code}    200

Admin Submits Post Organizations Request
    ${result}=    POST Credit Admin Organizations
    ...    user_id=${ADMIN_USER_ID}
    ...    business_id=${BUSINESS_ID}
    ...    name=${BUSINESS_NAME}
    ...    crn=${CRN}
    
    Set Test Variable    ${POST_ORGANIZATIONS_RESPONSE}    ${result}

Check Post Organizations Success
    Run Keyword If    ${POST_ORGANIZATIONS_RESPONSE.status_code} == 422
    ...    Fail   Duplicate input data.
    
    Should Be Equal As Numbers    ${POST_ORGANIZATIONS_RESPONSE.status_code}    200

Delete Organization By Business Id
    ${query}=    Set Variable    DELETE FROM organizations WHERE business_id='${BUSINESS_ID}'
    ${response}=    MySQL Execute Query    ${SWITCH_CREDIT_DB_NAME}    ${query}
    Should Be Equal As Numbers    ${response['status_code']}    0