*** Settings ***
Resource    services/backend/session-service.resource


*** Keywords ***
POST KYC Liveness Native Signature
    [Arguments]
    ...    ${api_call_side}
    ...    ${requester_app_name}
    ...    ${user_id}
    ...    ${signature_data}
    ...    ${signature_image_file}

    &{body}    Create Dictionary
    ...    signatureType    ${signature_data['signatureType']}
    ...    signatureFileName    ${signature_data['signatureFileName']}
    ...    signatureFileContent    ${signature_image_file}

    ${api_path}    Set Variable    ${MS_KYC_LIVENESS_PATH}/kyc/liveness/native/signature

    &{header}    Create Dictionary
    ...    Requester-App-Name=${requester_app_name}
    ...    User-Id=${user_id}

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
