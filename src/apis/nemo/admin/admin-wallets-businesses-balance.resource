*** Settings ***
Library         String
Library         Collections
Library         RequestsLibrary
Variables       data/CONSTANTS.yaml
Resource        services/backend/session-service.resource


*** Keywords ***
GET Admin Wallets Businesses Balance
    [Documentation]    This API takes a business id and return`response status code` and
    ...    `all the wallets balance` as a dictionary.
    ...    if you need send api to Microservice directly, `${user-id}` must be filled.
    [Arguments]
    ...    ${api_call_side}
    ...    ${business_id}
    ...    ${zone}=dashboard
    ...    ${user_id}=${Empty}

    ${api_path}    Set Variable    /admin/wallets/businesses/${business_id}/balances

    # Header Builder
    &{header}    Create Dictionary    &{EMPTY}
    IF    '${api_call_side}' == '${MICROSERVICE_SIDE}'
        ${api_path}    Set Variable    /admin/wallets/businesses/${business_id}/balance
        ${api_path}    Set Variable    ${MS_NEMO_PATH}${api_path}
        IF    '${user_id}' != '${EMPTY}'
            &{header_param}    Create Dictionary    User-Id=${user_id}    Zone=${zone}
            Set To Dictionary    ${header}    &{header_param}
        ELSE
            Fail    msg= For microservice call side `user_id` must not be empty.
        END
    END

    ${session}    Create A Session    ${api_call_side}

    ${result}    GET On Session
    ...    ${session}
    ...    ${api_path}
    ...    headers=${header}
    ...    expected_status=any

    &{response}    Create Dictionary
    ...    status_code=${result.status_code}
    ...    body=${result.json()}
    RETURN    ${response}

    [Teardown]    Delete A Session    ${session}
