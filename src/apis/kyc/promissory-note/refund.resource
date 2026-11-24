*** Settings ***
Resource    services/backend/session-service.resource


*** Keywords ***
POST Promissory Notes Refund
    [Arguments]
    ...    ${api_call_side}
    ...    ${requester_app_name}
    ...    ${tracking_code}

    &{body}    Create Dictionary

    Set To Dictionary    ${body}    trackingCode    ${tracking_code}

    ${api_path}    Set Variable    ${MS_PROMISSORY_NOTE_PATH}/promissory-notes/refund

    &{header}    Create Dictionary
    ...    Requester-App-Name=${requester_app_name}

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
