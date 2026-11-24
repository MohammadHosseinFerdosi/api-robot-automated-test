*** Settings ***
Resource    services/backend/session-service.resource
Variables    data/los/credit.yaml

*** Keywords ***
POST Credit Cheques Add
    [Arguments]    ${api_call_side}    ${fund_provider_code}    ${credit_id}    ${user_id}    ${body}    ${basic_auth_param}=${EMPTY}
    ${header}    Create Dictionary
     ...    Agent=${CREDIT_AGENT}
     ...    Client-Version=${CLIENT_VERSION}
    ...    Platform-Version=${CREDIT_PLATFORM_VERSION}
    ...    User-Id=${user_id}
    ...    content-type=${CREDIT_CONTENT_TYPE}
    
    ${api_path}    Set Variable    /cheques/${fund_provider_code}/${credit_id}
    IF    '${api_call_side}' == '${MICROSERVICE_SIDE}'
        ${api_path}    Set Variable    ${MS_CREDIT_ONBOARDING_PATH}${api_path}
    ELSE
        ${api_path}    Set Variable    /credit${api_path}
    END

    ${session}    Create A Session    ${api_call_side}    ${basic_auth_param}
    ${response}    POST On Session
    ...    ${session}
    ...    ${api_path}
    ...    headers=${header}
    ...    json=${body}
    ...    expected_status=any

    &{result}    Create Dictionary
    ...    status_code=${response.status_code}
    ...    body=${response.json()}
    RETURN    ${result}
    [Teardown]    Delete A Session    ${session}
