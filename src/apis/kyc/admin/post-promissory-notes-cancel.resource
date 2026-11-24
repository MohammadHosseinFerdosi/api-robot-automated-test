*** Settings ***
Resource    services/backend/session-service.resource


*** Keywords ***
POST Promissory Notes Cancel
    [Arguments]
    ...    ${api_call_side}
    ...    ${tracking_code}

    &{body}    Create Dictionary

    Set To Dictionary    ${body}    trackingCode    ${tracking_code}

    ${api_path}    Set Variable    ${MS_PROMISSORY_NOTE_PATH}/admin/promissory-notes/cancel

    ${session}    Create A Session    ${api_call_side}
    ${response}    POST On Session
    ...    ${session}
    ...    ${api_path}
    ...    json=${body}
    ...    expected_status=any

    ${result}    Create Dictionary    status_code=${response.status_code}    body=${response.json()}

    RETURN    ${result}

    [Teardown]    Delete A Session    ${session}
