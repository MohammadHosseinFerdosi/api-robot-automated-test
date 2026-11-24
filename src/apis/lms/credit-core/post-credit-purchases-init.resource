*** Settings ***
Library         String
Library         Collections
Library         JSONLibrary
Library         RequestsLibrary
Resource        services/backend/session-service.resource
Variables       data/lms/purchase-bnpl.yaml


*** Keywords ***
POST Credit Purchases Init
    [Documentation]    This Api Initiated a Purchase For Offline Channels for 2, 5, 6 and Channel 8 (Payment Link)
    ...    This API requires several input arguments.
    [Arguments]
    ...    ${api_call_side}=${EMPTY}
    ...    ${credit_id}=${EMPTY}
    ...    ${provider_id}=${EMPTY}
    ...    ${amount}=${EMPTY}
    ...    ${business_id}=${EMPTY}
    ...    ${channel}=${EMPTY}
    ...    ${seller_Id}=${EMPTY}
    ...    ${supplier_id}=${EMPTY}
    ...    ${product_code}=${EMPTY}
    ...    ${brand}=${EMPTY}
    ...    ${product_type}=${EMPTY}
    ...    ${count}=${EMPTY}
    ...    ${category_id}=${EMPTY}
    ...    ${sub_category_ids}=${EMPTY}
    ...    ${cheque_eligible}=${EMPTY}
    ...    ${basket_id}=${EMPTY}
    ...    ${version}=${EMPTY}
    ...    ${user_id}=${EMPTY}
    ...    ${cell_number}=${EMPTY}
    ...    ${terminal_id}=${EMPTY}
    IF    '${terminal_id}' == '${EMPTY}'
        ${headers}    Create Dictionary    Platform-Version=${version}    businessId=${business_id}
    ELSE
        ${headers}    Create Dictionary
        ...    Platform-Version=${version}
        ...    businessId=${business_id}
        ...    Terminal-Id=${terminal_id}
    END
    ${api_path}    Set Variable    /purchases/init
    IF    '${api_call_side}'=='${MICROSERVICE_SIDE}'
        ${api_path}    Set Variable    ${MS_CREDIT_MNG_PATH}${api_path}
    END
    ${body}    Create Dictionary
    IF    '${user_id}' == '${EMPTY}' and '${cell_number}' != '${EMPTY}'
        ${body}    Create Dictionary
        ...    cellNumber=${cell_number}
        ...    creditId=${credit_id}
        ...    amount=${amount}
        ...    businessId=${business_id}
        ...    providerId=${provider_id}
        ...    channel=${channel}
        ...    basketDetail=${EMPTY}
    ELSE IF    '${cell_number}' == '${EMPTY}' and '${user_id}' != '${EMPTY}'
        ${body}    Create Dictionary
        ...    userId=${user_id}
        ...    creditId=${credit_id}
        ...    amount=${amount}
        ...    businessId=${business_id}
        ...    providerId=${provider_id}
        ...    channel=${channel}
        ...    basketDetail=${EMPTY}
    ELSE
        ${body}    Create Dictionary
        ...    cellNumber=${cell_number}
        ...    userId=${user_id}
        ...    creditId=${credit_id}
        ...    amount=${amount}
        ...    businessId=${business_id}
        ...    providerId=${provider_id}
        ...    channel=${channel}
        ...    basketDetail=${EMPTY}
    END
    ${basket_detail}    Create Dictionary
    @{items_list}    Create List
    @{sub_category_list}    Create List    ${sub_category_ids}
    ${items}    Create Dictionary
    ...    sellerId=${seller_Id}
    ...    supplierId=${supplier_id}
    ...    productCode=${product_code}
    ...    brand=${brand}
    ...    productType=${product_type}
    ...    count=${count}
    ...    categoryId=${category_id}
    ...    chequeEligible=${cheque_Eligible}
    ...    subCategoryIds=${sub_category_list}

    Append To List    ${items_list}    ${items}
    Set To Dictionary    ${basket_detail}    items=${items_list}    basketId=${basket_id}

    Set To Dictionary    ${body}    basketDetail=${basket_detail}

    ${session}    Create A Session    ${api_call_side}

    ${response}    POST On Session
    ...    ${session}
    ...    ${api_path}
    ...    json=${body}
    ...    headers=${headers}
    ...    expected_status=any
    IF    '${response.status_code}'=='400'
        ${result}    Create Dictionary    status_code=400    body=[]
    ELSE
        ${result}    Create Dictionary    status_code=${response.status_code}    body=${response.json()}
    END

    RETURN    ${result}

    [Teardown]    Delete A Session    ${session}
