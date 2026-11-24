*** Settings ***
Library         Collections
Library         string
Library         JSONLibrary
Library         RequestsLibrary
Variables       data/CONSTANTS.yaml
Resource        services/backend/session-service.resource


*** Keywords ***
GET Wallets Users Total Balance
    [Documentation]    Get aggregated balance for A user, result contains cash-out and noncash-outable balance.
    [Arguments]
    ...    ${api_call_side}
    ...    ${user_id}=${EMPTY}

    ${api_path}    Set Variable    /wallets/users/total-balance
    ${header}    Create Dictionary
    IF    '${api_call_side}' == '${MICROSERVICE_SIDE}'
        Should Not Be Empty    ${user_id}    msg=For microservice side call, user id should not be empty.
        ${api_path}    Set Variable    ${MS_WALLET_PROVIDER_PATH}${api_path}
        Set To Dictionary    ${header}    User-Id=${user_id}
    END

    ${session}    Create A Session    ${api_call_side}
    ${response}    GET On Session
    ...    ${session}
    ...    ${api_path}
    ...    headers=${header}
    ...    expected_status=any

    ${result}    Create Dictionary    status_code=${response.status_code}    body=${response.json()}
    RETURN    ${result}
    [Teardown]    Delete A Session    ${session}
