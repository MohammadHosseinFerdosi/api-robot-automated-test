*** Settings ***
Library         RequestsLibrary
Library         Collections
Resource        services/backend/session-service.resource
Variables       data/los/credit.yaml

*** Keywords ***
POST Credit Admin Activation Extend File Import
    [Arguments]
    ...    ${api_call_side}
    ...    ${user_id}
    ...    ${data}
    ...    ${file_name}
    ...    ${fund_provider_code}
    ...    ${tracking_code}
    ...    ${basic_auth_param}=${EMPTY}

    ${header}    Create Dictionary
    ...    Content-Type=${CREDIT_CONTENT_TYPE}
    ...    User-Id=${user_id}

    ${api_path}    Set Variable
    ...    ${MS_CREDIT_ONBOARDING_PATH}/admin/activations/extend/file/import

    ${body}    Create Dictionary
    ...    data=${data}
    ...    fileName=${file_name}
    ...    fundProviderCode=${fund_provider_code}
    ...    trackingCode=${tracking_code}

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
    
    [Teardown]    Delete A Session    ${session}
    RETURN    ${result}