*** Settings ***
Library         String
Library         Collections
Library         RequestsLibrary
Variables       data/CONSTANTS.yaml
Resource        services/backend/session-service.resource


*** Keywords ***
GET Credit Early Settlements Detail
    [Documentation]    Sends a request to the Credit Early Settlements and returns the early settlement details for a given ${user_id} and ${credit_id}
    [Arguments]
    ...    ${api_call_side}
    ...    ${user_id}
    ...    ${credit_id}
    ${api_path}    Set Variable    /early-settlements/detail/${credit_id}
    ${headers}    Create Dictionary
    IF    '${api_call_side}' == '${MICROSERVICE_SIDE}'
        ${api_path}    Set Variable    ${MS_CREDIT_MNG_PATH}${api_path}
        Set To Dictionary    ${headers}    User-Id=${user_id}
    ELSE IF    '${api_call_side}' == '${GENERAL_SIDE}'
        ${api_path}    Set Variable    ${GATEWAY_PATH}/credit${api_path}
    END
    ${session}    Create A Session    ${api_call_side}

    ${response}    GET On Session
    ...    ${session}
    ...    ${api_path}
    ...    headers=${headers}
    ...    expected_status=any

    ${result}    Create Dictionary    status_code=${response.status_code}    body=${response.json()}
    RETURN    ${result}

    [Teardown]    Delete A Session    ${session}
