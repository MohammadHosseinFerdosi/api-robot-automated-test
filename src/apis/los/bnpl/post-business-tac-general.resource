*** Settings ***
Resource    services/backend/session-service.resource

*** Keywords ***
POST Business TAC General
    [Arguments]
    ...    ${external_requester_id}
    ...    ${cell_number}
    ...    ${national_code}
    ...    ${api_call_side}
    ${headers}    Create Dictionary
    ${api_path}    Set Variable    /business/credit/tac/general
    IF    '${api_call_side}' == '${MICROSERVICE_SIDE}'
        ${api_path}    Set Variable    ${MS_CREDIT_ONBOARDING_PATH}${api_path}
    END
    ${body}    Create Dictionary
    ...    externalRequesterId=${external_requester_id}
    ...    cellNumber=${cell_number}
    ...    nationalCode=${national_code}
    ${session}    Create A Session    ${api_call_side}
    ${response}    POST On Session
    ...    ${session}
    ...    ${api_path}
    ...    json=${body}
    ...    headers=${headers}
    ...    expected_status=any
    RETURN    ${response}
    [Teardown]    Delete A Session    ${session}
