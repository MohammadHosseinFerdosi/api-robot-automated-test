*** Settings ***
Library         Collections
Library         string
Library         JSONLibrary
Library         RequestsLibrary
Variables       data/CONSTANTS.yaml
Resource        services/backend/session-service.resource


*** Keywords ***
Post Test Settlements Transactions Trigger Create Transactions
    [Documentation]    create transaction based on aggregations
    [Arguments]    ${api_call_side}

    ${api_path}    Set Variable    /test/settlements/transactions/trigger-create-transactions

    IF    '${api_call_side}' == '${MICROSERVICE_SIDE}'
        ${api_path}    Set Variable    ${MS_SETTLEMENT_PATH}${api_path}
    END

    ${session}    Create A Session    ${MICROSERVICE_SIDE}
    ${response}    POST On Session    ${session}
    ...    ${api_path}
    ...    expected_status=any

    ${result}    Create Dictionary    status_code=${response.status_code}
    RETURN    ${result}
    [Teardown]    Delete A Session    ${session}
