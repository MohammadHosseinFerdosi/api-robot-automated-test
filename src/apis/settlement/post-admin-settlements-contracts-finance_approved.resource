*** Settings ***
Library         RequestsLibrary
Variables       data/CONSTANTS.yaml
Resource        services/backend/session-service.resource


*** Keywords ***
Post Admin Settlements Contracts Finance Approve
    [Documentation]    Finance Approved Contract
    [Arguments]    ${api_call_side}    ${contract_id}    ${user_id}

    ${api_path}    Set Variable    /admin/settlements/contracts/${contract_id}/finance-approve

    IF    '${api_call_side}' == '${MICROSERVICE_SIDE}'
        ${api_path}    Set Variable    ${MS_SETTLEMENT_PATH}${api_path}
    END


    ${headers}    Create Dictionary    
    ...        User-Id=${user_id}

    ${session}    Create A Session    ${api_call_side}
    ${response}    POST On Session
    ...    ${session}
    ...    ${api_path}
    ...    headers=${headers}
    ...    expected_status=any
    ${result}    Create Dictionary    status_code=${response.status_code}    body=${response.json()}
    RETURN    ${result}

    [Teardown]    Delete A Session    ${session}
