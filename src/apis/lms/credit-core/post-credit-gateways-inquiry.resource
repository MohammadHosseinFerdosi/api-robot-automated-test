*** Settings ***
Library     String
Library     Collections
Library     JSONLibrary
Library     RequestsLibrary
Resource    services/backend/session-service.resource


*** Keywords ***
POST Credit Gateways Inquiry
    [Documentation]    Post Active offline channel(2,5,6) api is a inquiry of active credit api.
    ...    This API requires several input arguments.
    [Arguments]
    ...    ${api_call_side}
    ...    ${payment_channel}
    ...    ${user_id}
    ...    ${amount}
    ...    ${business_id}
    ...    ${sellerId}
    ...    ${supplier_id}
    ...    ${product_code}
    ...    ${brand}
    ...    ${product_type}
    ...    ${count}
    ...    ${category_id}
    ...    ${sub_category_ids}
    ...    ${cheque_Eligible}
    ...    ${version}

    ${headers}    Create Dictionary
    ${api_path}    Set Variable    /gateways/inquiry
    IF    '${api_call_side}' == '${MICROSERVICE_SIDE}'
        ${api_path}    Set Variable    ${MS_CREDIT_MNG_PATH}${api_path}
        Set To Dictionary    ${headers}    Platform-Version=${version}
    END
    ${body}    Create Dictionary
    IF    '${amount}'!='${EMPTY}'
        ${body}    Set To Dictionary    dictionary=${body}    amount=${amount}
    END

    IF    '${user_id}'!='${EMPTY}'
        ${body}    Set To Dictionary    dictionary=${body}    userId=${user_id}
    END

    IF    '${business_id}'!='${EMPTY}'
        ${body}    Set To Dictionary    dictionary=${body}    businessId=${business_id}
    END

    IF    '${payment_channel}'!='${EMPTY}'
        ${body}    Set To Dictionary    dictionary=${body}    paymentChannel=${payment_channel}
    END

    ${items_list}    Create List
    ${sub_category_list}    Create List    ${sub_category_ids}
    IF    '${product_type}'=='${EMPTY}'
        ${items}    Create Dictionary
        ...    sellerId=${sellerId}
        ...    supplierId=${supplier_id}
        ...    productCode=${product_code}
        ...    brand=${brand}
        ...    count=${count}
        ...    categoryId=${category_id}
        ...    chequeEligible=${cheque_Eligible}
        ...    subCategoryIds=${sub_category_list}
    ELSE
        ${items}    Create Dictionary
        ...    sellerId=${sellerId}
        ...    supplierId=${supplier_id}
        ...    productCode=${product_code}
        ...    brand=${brand}
        ...    productType=${product_type}
        ...    count=${count}
        ...    categoryId=${category_id}
        ...    chequeEligible=${cheque_Eligible}
        ...    subCategoryIds=${sub_category_list}
    END

    Append To List    ${items_list}    ${items}

    Set To Dictionary    ${body}    items=${items_list}

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
