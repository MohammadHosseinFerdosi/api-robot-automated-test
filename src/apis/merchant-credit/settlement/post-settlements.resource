*** Settings ***
Library     RequestsLibrary
Library     Collections
Resource    services/backend/session-service.resource


*** Keywords ***
POST Settlements
    [Arguments]    ${api_call_side}
    ...    ${REGISTRATION_ID}
    ...    ${provider_id}
    ...    ${amount}
    ...    ${due_date}

    ${body}    Create Dictionary
    ...    registrationId=${REGISTRATION_ID}
    ...    providerId=${provider_id}
    ...    amount=${amount}
    ...    dueDate=${due_date}

    ${session}    Create A Session    ${api_call_side}
    ${response}    POST On Session
    ...    ${session}
    ...    /credit/merchants/settlements
    ...    json=${body}
    ...    expected_status=any
    ${result}    Create Dictionary    status_code=${response.status_code}    response=${response.json()}
    RETURN    ${result}

    [Teardown]    Delete A Session    ${session}
