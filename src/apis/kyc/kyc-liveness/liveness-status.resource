*** Settings ***
Resource    services/backend/session-service.resource


*** Keywords ***
GET KYC Liveness Status
    [Arguments]
    ...    ${api_call_side}
    ...    ${user_id}
    ...    ${signature_type}

    ${api_path}    Set Variable    ${MS_KYC_LIVENESS_PATH}/kyc/liveness/status?signatureType=${signature_type}

    &{header}    Create Dictionary    User-Id=${user_id}

    ${session}    Create A Session    ${api_call_side}
    ${response}    GET On Session
    ...    ${session}
    ...    ${api_path}
    ...    headers=&{header}
    ...    expected_status=any

    ${result}    Create Dictionary    status_code=${response.status_code}    body=${response.json()}

    RETURN    ${result}

    [Teardown]    Delete A Session    ${session}
