*** Settings ***
Library         Collections
Library         string
Library         JSONLibrary
Library         RequestsLibrary
Variables       data/CONSTANTS.yaml
Resource        services/backend/session-service.resource


*** Keywords ***
Post Test Settlements Contracts Trigger Sync Contracts
    [Documentation]    sync contract with credit
    [Arguments]    ${api_call_side}

    ${api_path}    Set Variable    /test/settlements/contracts/trigger-sync-contracts

    IF    '${api_call_side}' == '${MICROSERVICE_SIDE}'
        ${api_path}    Set Variable    ${MS_SETTLEMENT_PATH}${api_path}
    END
    ${session}    Create A Session    ${MICROSERVICE_SIDE}
    ${response}    POST On Session    ${session}
    ...    ${api_path}
    ...    expected_status=any

    RETURN    ${response}

    [Teardown]    Delete A Session    ${session}
