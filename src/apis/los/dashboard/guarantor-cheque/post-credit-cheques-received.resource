*** Settings ***
Library    RequestsLibrary
Library    Collections
Variables    data/los/credit.yaml
Variables    data/CONSTANTS.yaml

*** Keywords ***
POST Credit Admin Cheques Received
    [Arguments]    ${credit_id}    ${user_id}    ${fund_provider_code}    ${admin_id}    ${api_call_side}    ${basic_auth_param}
    
    ${headers}=    Create Dictionary
    ...    Content-Type=application/json
    ...    User-id=${admin_id}
    
    ${body}=    Create Dictionary
    ...    userId=${user_id}
    ...    fundProviderCode=${fund_provider_code}
    ...    creditId=${credit_id}

    ${api_path}=    Set Variable     ${MS_CREDIT_ONBOARDING_PATH}/admin/cheques/received

    ${session}=    Create A Session    ${api_call_side}    ${basic_auth_param}
    
    ${response}=    POST On Session
    ...    ${session}
    ...    ${api_path}
    ...    headers=${headers}
    ...    json=${body}
    ...    expected_status=any

    [Teardown]    Delete A Session    ${session}
    RETURN    ${response}
