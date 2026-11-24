*** Settings ***
Resource    services/backend/session-service.resource


*** Keywords ***
POST KYC Liveness Native Register
    [Arguments]
    ...    ${api_call_side}
    ...    ${requester_app_name}
    ...    ${user_id}
    ...    ${register_data}

    ${api_path}    Set Variable    ${MS_KYC_LIVENESS_PATH}/kyc/liveness/native/register

    &{header}    Create Dictionary
    ...    Requester-App-Name=${requester_app_name}
    ...    User-Id=${user_id}

    ${session}    Create A Session    ${api_call_side}
    ${response}    POST On Session
    ...    ${session}
    ...    ${api_path}
    ...    headers=&{header}
    ...    json=${register_data}
    ...    expected_status=any

    ${result}    Create Dictionary    status_code=${response.status_code}    body=${response.json()}

    RETURN    ${result}

    [Teardown]    Delete A Session    ${session}
