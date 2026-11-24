*** Settings ***
Library         String
Library         Collections
Library         RequestsLibrary
Variables       data/CONSTANTS.yaml
Resource        services/backend/session-service.resource


*** Keywords ***
POST Admin Wallets Businesses Cash-in
    [Documentation]    This API takes a business information and
    ...    if cash-in succeeds or repetitive, returens trackingCode
    ...    otherwise returns failure result.
    [Arguments]
    ...    ${api_call_side}
    ...    ${business_id}
    ...    ${wallet_name}
    ...    ${amount}
    ...    ${ref_number}
    ...    ${provider_code}
    ...    ${user_id}=${EMPTY}

    ${api_path}=    Set Variable    /admin/wallets/businesses/cash-in
    &{header}=    Create Dictionary    &{EMPTY}

    IF    '${api_call_side}' == '${MICROSERVICE_SIDE}'
        ${api_path}=    Set Variable    ${MS_NEMO_PATH}${api_path}
    END

    IF    '${api_call_side}' == '${MICROSERVICE_SIDE}'
        IF    '${user_id}' == '${EMPTY}'
            ${random_user_id}=    Generate Random String    15
            Set To Dictionary    ${header}    User-Id=${random_user_id}
        ELSE
            Set To Dictionary    ${header}    User-Id=${user_id}
        END
    END

    ${body}=    Create Dictionary
    ...    businessId=${business_id}
    ...    walletName=${wallet_name}
    ...    amount=${amount}
    ...    refNumber=${ref_number}
    ...    providerCode=${provider_code}

    ${session}=    Create A Session    ${api_call_side}

    ${response}=    POST On Session
    ...    ${session}
    ...    ${api_path}
    ...    json=${body}
    ...    headers=${header}
    ...    expected_status=any

    ${result}=    Create Dictionary    status_code=${response.status_code}    body=${response.json()}
    RETURN    ${result}
    [Teardown]    Delete A Session    ${session}
