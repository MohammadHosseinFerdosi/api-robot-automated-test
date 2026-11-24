*** Settings ***
Library         RequestsLibrary
Variables       data/CONSTANTS.yaml
Resource        services/backend/session-service.resource


*** Keywords ***
Post Admin Settlements Business Config
    [Documentation]    add business config for settlement
    [Arguments]    ${api_call_side}    ${business_id}    ${iban}    ${blocked_balance}=${0}    ${cell_number}=${EMPTY}    ${block_reason}=${EMPTY}


    ${api_path}    Set Variable    /admin/settlement/business-configs

    IF    '${api_call_side}' == '${MICROSERVICE_SIDE}'
        ${api_path}    Set Variable    ${MS_SETTLEMENT_PATH}${api_path}
    END


    ${body}    Create Dictionary    businessId=${business_id}    iban=${iban}    blockedBalance=${blocked_balance}    cellNumber=${cell_number}    blockReason=${block_reason}

    ${session}    Create A Session    ${api_call_side}
    ${response}    POST On Session
    ...    ${session}
    ...    ${api_path}
    ...    json=${body}
    ...    expected_status=any
    ${result}    Create Dictionary    status_code=${response.status_code}    body=${response.json()}
    RETURN    ${result}

    [Teardown]    Delete A Session    ${session}
