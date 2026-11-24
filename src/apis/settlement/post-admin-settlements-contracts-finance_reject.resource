*** Settings ***
Library         RequestsLibrary
Variables       data/CONSTANTS.yaml
Resource        services/backend/session-service.resource


*** Keywords ***
Post Admin Settlements Contracts Finance Reject
    [Documentation]    Finance Reject
    [Arguments]    ${api_call_side}    ${contract_id}    ${description}

    ${api_path}    Set Variable    /admin/settlements/contracts/${contract_id}/finance-reject

    IF    '${api_call_side}' == '${MICROSERVICE_SIDE}'
        ${api_path}    Set Variable    ${MS_SETTLEMENT_PATH}${api_path}
    END

    ${session}    Create A Session    ${api_call_side}
    ${body}    Create Dictionary
    ...    description=${description}
    ${response}    POST On Session
    ...    ${session}
    ...    ${api_path}
    ...    json=${body}
    ...    expected_status=any
    ${result}    Create Dictionary    status_code=${response.status_code}    body=${response.json()}
    RETURN    ${result}

    [Teardown]    Delete A Session    ${session}
