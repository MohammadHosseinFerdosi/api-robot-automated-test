*** Settings ***
Library         String
Library         Collections
Library         JSONLibrary
Library         RequestsLibrary
Resource        services/backend/session-service.resource
Variables       data/lms/purchase-bnpl.yaml


*** Keywords ***
POST Credit Gateway Manifest
    [Documentation]    Post credit gateway manifest api is the implementation of the manifest api.
    ...    This API requires several input arguments.
    ...
    ...    ${api_call_side}: Specifies the side making the API call. Should be either ${MICROSERVICE_SIDE} or ${APP_SIDE}.
    ...    ${channel}: The communication channel for the API request.
    ...    ${type}: The type of the ticket.
    ...    ${amount}: The basket amount associated with the ticket.
    ...    ${product_types}: A list or array of product types included in the transaction.
    ...    ${cell_number}: The mobile phone number associated with the transaction.
    ...    ${platform_version}: The version of the Platform service being used.
    ...    ${product_type}: The type of product in the basket for the transaction.
    ...    ${basket_id}: The unique identifier for the shopping basket.
    ...    ${sellerId}: The ID of the seller offering the product.
    ...    ${supplier_id}: The ID of the supplier providing the product.
    ...    ${product_code}: The unique code representing the product.
    ...    ${brand}: The brand of the product being processed.
    ...    ${count}: The quantity of the product in the transaction.
    ...    ${category_id}: The ID of the product category.
    ...    ${user_id}: The merchant ID for the transaction (defaults to ${COMPANY_USER_ID} if not provided).
    ...
    ...    --Note : Give ${api_call_side} as ${MICROSERVICE_SIDE} requires a valid ${user_id} whereas calling
    ...    the api from ${APP_SIDE} does not require a ${user_id} as ${APP_SIDE} api-calling predefines a ${user_id}
    ...    within the header.
    [Arguments]
    ...    ${api_call_side}
    ...    ${channel}
    ...    ${type}
    ...    ${amount}
    ...    ${product_types}
    ...    ${cell_number}
    ...    ${platform_version}
    ...    ${product_type}
    ...    ${basket_id}
    ...    ${sellerId}
    ...    ${supplier_id}
    ...    ${product_code}
    ...    ${brand}
    ...    ${count}
    ...    ${category_id}
    ...    ${user_id}=${COMPANY_USER_ID}
    ...    ${cheque_eligible}=false

    ${headers}    Create Dictionary
    ...    Platform-Version=${platform_version}
    ${api_path}    Set Variable    /gateways/manifest
    IF    '${api_call_side}' == '${MICROSERVICE_SIDE}'
        ${api_path}    Set Variable    ${MS_CREDIT_MNG_PATH}${api_path}
        Set To Dictionary    ${headers}    User-Id=${user_id}
    END
    ${params}    Create Dictionary    channel=${channel}    type=${type}
    ${body}    Create Dictionary
    ...    amount=${amount}
    ...    productTypes=@{product_types}
    ...    cellNumber=${cell_number}
    ...    basketDetail=${EMPTY}
    ${basket_detail}    Create Dictionary
    ${items_list}    Create List
    ${item}    Create Dictionary
    ...    sellerId=${sellerId}
    ...    chequeEligible=${cheque_eligible}
    ...    supplierId=${supplier_id}
    ...    productCode=${product_code}
    ...    brand=${brand}
    ...    productType=${product_type}
    ...    count=${count}
    ...    categoryId=${category_id}

    Append To List    ${items_list}    ${item}
    Set To Dictionary    ${basket_detail}    items=${items_list}    basketId=${basket_id}

    Set To Dictionary    ${body}    basketDetail=${basket_detail}

    ${session}    Create A Session    ${api_call_side}

    ${response}    POST On Session
    ...    ${session}
    ...    ${api_path}
    ...    params=${params}
    ...    json=${body}
    ...    headers=${headers}
    ...    expected_status=any

    ${result}    Create Dictionary    status_code=${response.status_code}    body=${response.json()}
    RETURN    ${result}

    [Teardown]    Delete A Session    ${session}
