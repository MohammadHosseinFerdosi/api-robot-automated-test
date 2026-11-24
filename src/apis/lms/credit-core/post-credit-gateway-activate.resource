*** Settings ***
Library     String
Library     Collections
Library     JSONLibrary
Library     RequestsLibrary
Resource    services/backend/session-service.resource


*** Keywords ***
POST Credit Gateway Activate
    [Arguments]
    ...    ${api_call_side}
    ...    ${business_id}
    ...    ${channel}
    ...    ${payment_gateway}
    ...    ${trigger_action}
    ...    ${user_id}
    ...    ${repayment_options}

    ${headers}    Create Dictionary
    ${api_path}    Set Variable    /gateways/activate
    IF    '${api_call_side}' == '${MICROSERVICE_SIDE}'
        ${api_path}    Set Variable    ${MS_CREDIT_MERCHANT_MNG_PATH}/credit${api_path}
        Set To Dictionary    ${headers}    User-Id=${user_id}
    END
    ${body}    Create Dictionary
    ...    businessId=${business_id}
    ...    channel=${channel}
    ...    paymentGateway=${payment_gateway}
    ...    repaymentOptions=${repayment_options}
    ...    settlementTerm=${EMPTY}
    ${settlement_term}    Create Dictionary    triggerAction=${trigger_action}

    Set To Dictionary    ${body}    settlementTerm=${settlement_term}
    ${session}    Create A Session    ${api_call_side}

    ${response}    POST On Session
    ...    ${session}
    ...    ${api_path}
    ...    json=${body}
    ...    headers=${headers}
    ...    expected_status=any

    ${result}    Create Dictionary    status_code=${response.status_code}    body=${response.json()}
    RETURN    ${result}

    [Teardown]    Delete A Session    ${session}
