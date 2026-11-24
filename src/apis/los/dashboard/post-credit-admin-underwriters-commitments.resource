*** Settings ***
Documentation    API Keyword for Creating Underwriters Commitments
Library     RequestsLibrary
Variables   data/los/credit.yaml
Variables   config/environment-stage.yaml

*** Keywords ***
POST Credit Admin Underwriters Commitments
    [Arguments]    ${user_id}    ${fund_provider_code}    ${business_id}    ${profile_id_value}    ${profile_id}    ${organization_id}
    [Documentation]    Sends POST request to create commitments for underwriters
    
    ${headers}=    Create Dictionary    
    ...    User-Id=${user_id}    
    ...    Content-Type=${CREDIT_CONTENT_TYPE}

    ${body}=    Create Dictionary
    ...    fundProviderCode=${fund_provider_code}
    ...    businessId=${business_id}
    ...    profileIdValue=${profile_id_value}
    ...    profileId=${profile_id}
    ...    organizationId=${organization_id}

    ${url}=    Set Variable    ${MICROSERVICE_BASE_URL}${MS_UNDERWRITING_PATH}/admin/underwriters/commitments
    
    ${response}=    POST    url=${url}    json=${body}    headers=${headers}    expected_status=any
    
    RETURN    ${response}
