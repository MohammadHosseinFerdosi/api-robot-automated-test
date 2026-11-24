*** Settings ***
Resource    services/backend/session-service.resource


*** Keywords ***
POST KYC Liveness Native Selfie
    [Arguments]
    ...    ${api_call_side}
    ...    ${user_id}
    ...    ${selfie_data}
    ...    ${selfie_picture_file}

    &{body}    Create Dictionary
    ...    signatureType    ${selfie_data['signatureType']}
    ...    selfieFileName    ${selfie_data['selfieFileName']}
    ...    selfieFileContent    ${selfie_picture_file}

    ${api_path}    Set Variable    ${MS_KYC_LIVENESS_PATH}/kyc/liveness/native/selfie

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
