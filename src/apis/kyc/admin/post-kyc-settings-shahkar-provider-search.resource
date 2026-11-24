*** Settings ***
Resource    services/backend/session-service.resource


*** Keywords ***
POST Admin Kyc Setting Shahkar Provider Search
    [Documentation]    With call this API we set provider setting weights
    [Arguments]
    ...    ${api_call_side}

    ${api_path}    Set Variable    ${MS_KYC_PATH}/admin/kyc/settings/shahkar/provider/search

    ${session}    Create A Session    ${api_call_side}
    ${response}    POST On Session
    ...    ${session}
    ...    ${api_path}
    ...    expected_status=any

    ${result}    Create Dictionary    status_code=${response.status_code}    body=${response.json()}

    RETURN    ${result}

    [Teardown]    Delete A Session    ${session}
