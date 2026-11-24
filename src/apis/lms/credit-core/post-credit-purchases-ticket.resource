*** Settings ***
Library     String
Library     Collections
Library     RequestsLibrary
Resource    services/backend/session-service.resource
Resource    services/backend/auth-service.resource


*** Keywords ***
POST Credit Purchases Ticket
    [Documentation]    Sends a request to the Credit Purchases Ticket API with the specified parameters.
    [Arguments]
    ...    ${api_call_side}
    ...    ${type}
    ...    ${channel}
    ...    ${amount}
    ...    ${cell_number}
    ...    ${credit_id}
    ...    ${provider_id}
    ...    ${redirect_url}
    ...    ${seller_id}
    ...    ${supplier_id}
    ...    ${product_code}
    ...    ${brand}
    ...    ${count}
    ...    ${category_id}
    ...    ${cheque_eligible}
    ...    ${product_type}
    ...    ${basket_id}
    ...    ${user_id}

    ${api_path}=    Set Variable    /businesses/ticket

    ${body}=    Create Dictionary
    ...    amount=${amount}
    ...    cellNumber=${cell_number}
    ...    providerId=${provider_id}
    ...    redirectUrl=${redirect_url}
    ...    basketDetail=${EMPTY}

    ${headers}=    Create Dictionary    User-Id=${user_id}
    IF    '${api_call_side}' == '${MICROSERVICE_SIDE}'
        ${api_path}=    Set Variable    ${MS_CREDIT_MNG_PATH}/purchases/ticket
    END
    IF    '${credit_id}' != '${EMPTY}'
        ${params}=    Create Dictionary    type=${type}    channel=${channel}    creditId=${credit_id}
    ELSE
        ${params}=    Create Dictionary    type=${type}    channel=${channel}
    END

    ${basket_detail}=    Create Dictionary
    ${items_list}=    Create List
    ${item}=    Create Dictionary
    ...    chequeEligible=${cheque_Eligible}
    ...    sellerId=${seller_id}
    ...    supplierId=${supplier_id}
    ...    productCode=${product_code}
    ...    brand=${brand}
    ...    productType=${product_type}
    ...    count=${count}
    ...    categoryId=${category_id}

    Append To List    ${items_list}    ${item}
    Set To Dictionary    ${basket_detail}    items=${items_list}    basketId=${basket_id}

    Set To Dictionary    ${body}    basketDetail=${basket_detail}

    ${session}=    Create A Session    ${api_call_side}

    ${response}=    POST On Session
    ...    ${session}
    ...    ${api_path}
    ...    params=${params}
    ...    json=${body}
    ...    headers=${headers}
    ...    expected_status=any

    ${result}=    Create Dictionary    status_code=${response.status_code}    body=${response.json()}
    RETURN    ${result}

    [Teardown]    Delete A Session    ${session}
