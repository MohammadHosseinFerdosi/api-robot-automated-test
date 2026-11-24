*** Settings ***
Library     RequestsLibrary
Resource    services/backend/session-service.resource


*** Keywords ***
POST Admin Wallets businesses config
    [Documentation]    Add ALL configuration for a business, `${wallets_configs_list}` contain wallet cofiguration
    ...    for this business and should be filled based on swagger config, this config contain `auto transfer`,
    ...    `cash out strategy`, `iban list for cash out` and etc per wallets.
    [Arguments]    ${api_call_side}    ${business_id}    ${wallets_configs_list}

    ${api_path}    Set Variable    /admin/wallets/businesses/config
    IF    '${api_call_side}' == '${MICROSERVICE_SIDE}'
        ${api_path}    Set Variable    ${MS_NEMO_PATH}${api_path}
    END

    ${body}    Create Dictionary    businessId=${business_id}    wallets=${wallets_configs_list}

    ${session}    Create A Session    ${api_call_side}
    ${response}    POST On Session
    ...    ${session}
    ...    ${api_path}
    ...    json=${body}
    ...    expected_status=any
    ${result}    Create Dictionary    status_code=${response.status_code}    body=${response.json()}
    RETURN    ${result}
    [Teardown]    Delete A Session    ${session}
