*** Settings ***
Resource    services/backend/session-service.resource


*** Keywords ***
POST Promissory Notes Init
    [Arguments]
    ...    ${api_call_side}
    ...    ${requester_app_name}
    ...    ${tracking_code}
    ...    ${promissory_note_data}
    ...    ${recepiant_code}

    &{body}    Create Dictionary
    ...    trackingCode    ${tracking_code}
    ...    owner    ${promissory_note_data['owner']}
    ...    iban    ${promissory_note_data['iban']}
    ...    amount    ${promissory_note_data['amount']}
    ...    dueType    ${promissory_note_data['dueType']}
    ...    dueOffsetInYears    ${promissory_note_data['dueOffsetInYears']}
    ...    recipientId    ${promissory_note_data['recipientId']}
    ...    recipientCode    ${recepiant_code}
    ...    description    ${promissory_note_data['description']}

    ${api_path}    Set Variable    ${MS_PROMISSORY_NOTE_PATH}/promissory-notes/init

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
