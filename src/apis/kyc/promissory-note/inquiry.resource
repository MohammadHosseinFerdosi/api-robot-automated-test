*** Settings ***
Resource    services/backend/session-service.resource


*** Keywords ***
POST Promissory Notes Inquiry
    [Arguments]
    ...    ${api_call_side}
    ...    ${tracking_code}

    &{body}    Create Dictionary
    @{tracking_codes_list}    Create List

    Append To List    ${tracking_codes_list}    ${tracking_code}
    Set To Dictionary    ${body}    trackingCodes    ${tracking_codes_list}

    ${api_path}    Set Variable    ${MS_PROMISSORY_NOTE_PATH}/promissory-notes/inquiry

    ${session}    Create A Session    ${api_call_side}
    ${response}    POST On Session
    ...    ${session}
    ...    ${api_path}
    ...    json=${body}
    ...    expected_status=any

    ${result}    Create Dictionary    status_code=${response.status_code}    body=${response.json()}

    RETURN    ${result}

    [Teardown]    Delete A Session    ${session}
