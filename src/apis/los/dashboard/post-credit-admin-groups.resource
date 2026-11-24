*** Settings ***
Documentation    API Keyword for Creating a Credit Group
Resource         services/backend/session-service.resource
Variables         data/los/credit.yaml


*** Keywords ***
POST Credit Admin Groups
    [Documentation]    Sends POST request to create a group using the framework session structure.
    [Arguments]    
    ...    ${api_call_side}
    ...    ${user_id}    
    ...    ${title}    
    ...    ${fund_provider_id}    
    ...    ${rule_id}    
    ...    ${user_entry_point}    
    ...    ${crn}
    
    ${header}    Create Dictionary     
    ...    User-Id=${user_id}    
    ...    Content-Type=${CREDIT_CONTENT_TYPE}

    ${api_path}    Set Variable    /admin/groups
    IF    '${api_call_side}' == '${MICROSERVICE_SIDE}'
        ${api_path}    Set Variable    ${MS_CREDIT_ONBOARDING_PATH}${api_path}
    END

    ${body}    Create Dictionary    
    ...    title=${title}    
    ...    fundProviderId=${fund_provider_id}    
    ...    ruleId=${rule_id}    
    ...    userEntryPoint=${user_entry_point}    
    ...    crn=${crn}

    ${session}    Create A Session    ${api_call_side}
    
    ${response}    POST On Session
    ...    ${session}
    ...    ${api_path}
    ...    headers=${header}
    ...    json=${body}
    ...    expected_status=any

    ${result}    Create Dictionary    status_code=${response.status_code}    body=${response.json()}
    
    RETURN    ${result}
    
    [Teardown]    Delete A Session    ${session}
