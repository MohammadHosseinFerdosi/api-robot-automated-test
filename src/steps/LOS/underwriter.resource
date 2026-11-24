*** Settings ***
Variables   data/los/credit.yaml
Variables   config/environment-stage.yaml
Library     Process
Library     RequestsLibrary
Library     DateTime
Library     String
Library     Collections

Resource    services/db/mysql-db-service.resource
Resource    services/db/mongo-db-service.resource

Resource    apis/los/dashboard/post-credit-admin-underwriters-search.resource
Resource    apis/los/dashboard/get-credit-admin-underwriters-validation-by-business-id.resource
Resource    apis/los/dashboard/post-credit-admin-underwriters-validation.resource
Resource    apis/los/dashboard/post-credit-admin-underwriters.resource
Resource    apis/los/dashboard/post-credit-admin-underwriters-commitments.resource

*** Keywords ***
Admin Searches Underwriters Successfully
    Admin Submits Underwriters Search Request
    Check Underwriters Search Success

Admin Validates Underwriter
    Admin Submits Get Validation By Business Id Request
    Check Get Validation By Business Id Success
    Admin Submits Underwriter Validation Request
    Check Underwriter Validation Success

Admin Creates Underwriter
    Admin Submits Create Underwriter Request
    Check Create Underwriter Success

Admin Creates Commitments
    Admin Creates Underwriters Commitments Successfully

Clean Data From Database
    Delete Underwriter Records If Exist
    Delete Commitments Records If Exist



Admin Submits Underwriters Search Request
    ${restrictions}=    Create List
    ${order_dict}=      Create Dictionary    field=creationTime    order=desc
    ${orders}=          Create List          ${order_dict}
    
    ${result}=    POST Credit Admin Underwriters Search
    ...    user_id=${ADMIN_USER_ID}
    ...    page=${PAGE}
    ...    size=${SIZE}
    ...    restrictions=${restrictions}
    ...    orders=${orders}
    
    Set Test Variable    ${SEARCH_RESPONSE}    ${result}

Check Underwriters Search Success
    Should Be Equal As Numbers    ${SEARCH_RESPONSE.status_code}    200


Admin Submits Get Validation By Business Id Request
    ${result}=    GET Credit Admin Underwriters Validation By Business Id
    ...    user_id=${ADMIN_USER_ID}
    ...    business_id=${BUSINESS_ID}
    
    Set Test Variable    ${GET_VALIDATION_RESPONSE}    ${result}

Check Get Validation By Business Id Success
    Run Keyword If    ${GET_VALIDATION_RESPONSE.status_code} == 422    Fail    این شناسه بیزینس حامی اعتباری دارد.
    Should Be Equal As Numbers    ${GET_VALIDATION_RESPONSE.status_code}    200


Admin Submits Underwriter Validation Request
    ${result}=    POST Credit Admin Underwriters Validation
    ...    user_id=${ADMIN_USER_ID}
    ...    name=${BUSINESS_NAME}
    ...    business_id=${BUSINESS_ID}
    
    Set Test Variable    ${VALIDATION_RESPONSE}    ${result}

Check Underwriter Validation Success
    Should Be Equal As Numbers    ${VALIDATION_RESPONSE.status_code}    200


Admin Submits Create Underwriter Request
    ${result}=    POST Credit Admin Underwriters
    ...    user_id=${ADMIN_USER_ID}
    ...    name=${BUSINESSNAME}
    ...    business_id=${BUSINESSID}
    
    Set Test Variable    ${CREATE_UNDERWRITER_RESPONSE}    ${result}

Check Create Underwriter Success
    Should Be Equal As Numbers    ${CREATE_UNDERWRITER_RESPONSE.status_code}    200


Admin Creates Underwriters Commitments Successfully
    [Documentation]    Calls the API to create commitments and validates a 200 success response
    
    ${response}=    POST Credit Admin Underwriters Commitments
    ...    user_id=${ADMIN_USER_ID}
    ...    fund_provider_code=${CREDIT_TEJARAT_FP_CODE}
    ...    business_id=${BUSINESS_ID}
    ...    profile_id_value=${CREDIT_PROFILE_ID}
    ...    profile_id=${CREDIT_PROFILE_ID}
    ...    organization_id=${ORGANIZATION_ID}
    
    Should Be Equal As Integers    ${response.status_code}    200
    
    RETURN    ${response.json()}


Delete Underwriter Records If Exist
    [Documentation]    Deletes records from underwriters collections by underwriterId if they exist.
    
    ${filter}=    Create Dictionary    underwriterId=${BUSINESS_ID}
    
    Run Keyword And Ignore Error    Mongo Db Delete Many    underwriting_db    underwriters    ${filter}


Delete Commitments Records If Exist
    [Documentation]    Deletes records from commitments collections by underwriterId if they exist.
    
    ${filter}=    Create Dictionary    underwriterId=${BUSINESS_ID}    
    Run Keyword And Ignore Error    Mongo Db Delete Many    underwriting_db    commitments    ${filter}