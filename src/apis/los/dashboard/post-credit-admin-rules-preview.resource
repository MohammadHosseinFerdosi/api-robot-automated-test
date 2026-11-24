*** Settings ***
Resource    services/backend/session-service.resource
Variables   data/los/credit.yaml
Variables   config/environment-stage.yaml

*** Keywords ***
POST Credit Admin Rules Preview
    [Arguments]    ${user_id}    ${fund_provider_code}    ${profile_id}    ${min_balance}    ${max_balance}
    [Documentation]    Constructs and sends the POST request to preview a rule
    
    ${header}    Create Dictionary    
    ...    User-Id=${user_id}    
    ...    Content-Type=${CREDIT_CONTENT_TYPE}

    ${full_url}    Set Variable    ${MICROSERVICE_BASE_URL}${MS_CREDIT_ONBOARDING_PATH}/admin/rules/preview

    ${balance}    Create Dictionary    min=${min_balance}    max=${max_balance}
    ${body}       Create Dictionary    
    ...    fundProviderCode=${fund_provider_code}    
    ...    profileId=${profile_id}     
    ...    balance=${balance}

    ${session}     Create A Session    ${MICROSERVICE_SIDE}
    ${response}    POST On Session    ${session}    ${full_url}    json=${body}    headers=${header}    expected_status=any
    
    &{result}      Create Dictionary    status_code=${response.status_code}    body=${response.json()}
    RETURN         ${result}
    [Teardown]     Delete A Session    ${session}