*** Settings ***
Library         Collections
Library         String
Library         JSONLibrary
Library         RequestsLibrary
Variables       data/CONSTANTS.yaml
Resource        services/backend/session-service.resource


*** Keywords ***
Post Purchase Refund
    [Documentation]    Post a refund request, for auto refund request ${sale_tracking_code} is mandatory
    [Arguments]
    ...    ${api_call_side}
    ...    ${amount}=${None}
    ...    ${business_id}=${None}
    ...    ${user_id}=${None}
    ...    ${sale_tracking_code}=${None}
    ...    ${provider_id}=${None}
    ...    ${pan}=${None}
    ...    ${iban}=${None}
    ...    ${description}=${None}
    ...    ${customer_name}=${None}
    ...    ${cell_number}=${None}
    ...    ${sale_order_id}=${None}
    ...    ${restrictions}=${None}
    ...    ${type}=${None}

    ${api_path}    Set Variable    /refunds
    ${refund_microservise_path}    Set Variable    /purchases
    ${header}    Create Dictionary
    IF    '${api_call_side}' == '${MICROSERVICE_SIDE}'
        ${api_path}    Set Variable    ${MS_PURCHASE_PATH}${refund_microservise_path}${api_path}
        Set To Dictionary    ${header}    User-Id=${business_id}
    END

    ${additional_info}    Create Dictionary
    ...    saleOrderId=${sale_order_id}
    ...    restrictions=${restrictions}

    ${param}    Create Dictionary    type=${type}
    ${body}    Create Dictionary
    ...    amount=${amount}
    ...    userId=${user_id}
    ...    providerId=${provider_id}
    ...    saleTrackingCode=${sale_tracking_code}
    ...    pan=${pan}
    ...    iban=${iban}
    ...    userId=${user_id}
    ...    description=${description}
    ...    customerName=${customer_name}
    ...    cellNumber=${cell_number}
    ...    additional_info=${additional_info}
    
    
    ${session}    Create A Session    ${api_call_side}
    ${response}    POST On Session    ${session}
    ...    ${api_path}
    ...    headers=${header}
    ...    params=${param}
    ...    json=${body}
    ...    expected_status=any
    ${result}    Create Dictionary    status_code=${response.status_code}    body=${response.json()}
    RETURN    ${result}

    [Teardown]    Delete A Session    ${session}
