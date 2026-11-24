*** Settings ***
Library     String
Library     Collections
Library     JSONLibrary
Library     RequestsLibrary
Resource    services/backend/session-service.resource


*** Keywords ***
POST Credit Gateway Disable
    [Arguments]
    ...    ${api_call_side}
    ...    ${business_id}
    ...    ${channel}
    ...    ${payment_gateway}

    ${headers}    Create Dictionary
    ${api_path}    Set Variable    /gateways/disable
    IF    '${api_call_side}' == '${MICROSERVICE_SIDE}'
        ${api_path}    Set Variable    ${MS_CREDIT_MERCHANT_MNG_PATH}/credit${api_path}
    END
    ${body}    Create Dictionary
    ...    businessId=${business_id}
    ...    channel=${channel}
    ...    paymentGateway=${payment_gateway}

    ${session}    Create A Session    ${api_call_side}

    ${response}    POST On Session
    ...    ${session}
    ...    ${api_path}
    ...    json=${body}
    ...    expected_status=any

    ${result}    Create Dictionary    status_code=${response.status_code}    body=${response.json()}
    RETURN    ${result}

    [Teardown]    Delete A Session    ${session}
