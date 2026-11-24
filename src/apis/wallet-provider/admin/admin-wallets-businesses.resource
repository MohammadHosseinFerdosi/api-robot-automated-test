*** Settings ***
Library         Collections
Library         string
Library         JSONLibrary
Library         RequestsLibrary
Variables       data/CONSTANTS.yaml
Resource        services/backend/session-service.resource


*** Keywords ***
POST Admin Wallets Businesses
    [Documentation]    This API creates wallets for a business,
    ...    if api done with successfull state,'${True}' boolean value will be returned.
    [Arguments]
    ...    ${api_call_side}
    ...    ${business_id_arg}
    ...    ${wallet_arg}
    ...    ${currency}=${CURRENCY_IRR}

    ${api_path}    Set Variable    /admin/wallets/businesses
    IF    '${api_call_side}' == '${MICROSERVICE_SIDE}'
        ${api_path}    Set Variable    ${MS_WALLET_PROVIDER_PATH}${api_path}
    END
    ${header}    Create Dictionary    Agent=CONSOLE

    ${body}    Create Dictionary
    ...    businessId=${business_id_arg}
    ...    walletName=${wallet_arg}
    ...    currency=${currency}


    ${session}    Create A Session    ${api_call_side}
    ${response}    POST On Session
    ...    ${session}
    ...    ${api_path}
    ...    headers=${header}
    ...    json=${body}
    ...    expected_status=any


    IF    ${response.status_code} == 200
        ${success}    Get Value From Json    ${response.json()}    $.result.title    fail_on_empty=True
        IF    '${success}[0]' == '${API_SUCCESS_STATE}'    RETURN    ${True}
    ELSE
        ${result}    Create Dictionary
        ...    response_status_code=${response.status_code}
        ...    response_body=${response.json().get('response')}
        RETURN    ${result}
    END

    [Teardown]    Delete A Session    ${session}
