*** Settings ***
Resource    services/backend/session-service.resource


*** Keywords ***
GET Admin Promissory Notes Setting Provider
    [Documentation]    With call this API we get proviser setting weights

    ${api_path}    Set Variable    ${MS_PROMISSORY_NOTE_PATH}/admin/promissory-notes/settings/provider

    ${session}    Create A Session    ${MICROSERVICE_SIDE}
    ${response}    GET On Session
    ...    ${session}
    ...    ${api_path}
    ...    expected_status=any

    ${result}    Create Dictionary    status_code=${response.status_code}    body=${response.json()}

    RETURN    ${result}

    [Teardown]    Delete A Session    ${session}
