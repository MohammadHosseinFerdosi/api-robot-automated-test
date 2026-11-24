*** Settings ***
Resource    services/backend/session-service.resource


*** Keywords ***
POST KYC Liveness Native Remove
    [Arguments]
    ...    ${api_call_side}
    ...    ${user_id}
    ...    ${signature_type}

    &{body}    Create Dictionary    signatureType=${signature_type}
    ${api_path}    Set Variable    ${MS_KYC_LIVENESS_PATH}/kyc/liveness/native/remove

    &{header}    Create Dictionary    User-Id=${user_id}

    ${session}    Create A Session    ${api_call_side}
    ${response}    POST On Session
    ...    ${session}
    ...    ${api_path}
    ...    headers=&{header}
    ...    json=${body}
    ...    expected_status=any

    ${result}    Create Dictionary    status_code=${response.status_code}    body=${response.json()}

    RETURN    ${result}

    [Teardown]    Delete A Session    ${session}
