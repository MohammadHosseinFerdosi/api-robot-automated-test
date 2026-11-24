*** Settings ***
Resource    services/backend/session-service.resource


*** Keywords ***
POST Digital Signatures Revoke
    [Arguments]
    ...    ${api_call_side}
    ...    ${requester_app_name}
    ...    ${user_id}
    ...    ${signature_type}

    &{body}    Create Dictionary    type=${signature_type}
    ${api_path}    Set Variable    ${MS_DIGITAL_SIGNATURE_PATH}/digital-signatures/revoke

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
