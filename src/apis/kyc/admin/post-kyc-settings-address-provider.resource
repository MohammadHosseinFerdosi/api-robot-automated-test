*** Settings ***
Resource    services/backend/session-service.resource


*** Keywords ***
POST Admin Kyc Setting Address Provider
    [Documentation]    With call this API we set provider setting weights
    [Arguments]
    ...    ${api_call_side}
    ...    ${body}

    ${api_path}    Set Variable    ${MS_KYC_PATH}/admin/kyc/settings/address/provider

    ${session}    Create A Session    ${api_call_side}
    ${response}    POST On Session
    ...    ${session}
    ...    ${api_path}
    ...    json=${body}
    ...    expected_status=any

    ${result}    Create Dictionary    status_code=${response.status_code}    body=${response.json()}

    RETURN    ${result}

    [Teardown]    Delete A Session    ${session}
