*** Settings ***
Library         String
Library         Collections
Library         JSONLibrary
Library         RequestsLibrary
Resource        services/backend/session-service.resource


*** Keywords ***
POST Ticket Features
    [Arguments]
    ...    ${api_call_side}
    ...    ${channel}
    ...    ${type}
    ...    ${amount}
    ...    ${user_id}
    ...    ${platform_version}
    ...    ${product_type}
    ...    ${basket_id}
    ...    ${sellerId}
    ...    ${supplier_id}
    ...    ${product_code}
    ...    ${brand}
    ...    ${count}
    ...    ${category_id}
    ...    ${merchant_business_id}=${COMPANY_USER_ID}
    ...    ${cheque_eligible}=false
    ...    ${callback_url}=https://example.com

    ${headers}    Create Dictionary
    ...    Platform-Version=${platform_version}
    ${api_path}    Set Variable    /ticket/features
    IF    '${api_call_side}' == '${MICROSERVICE_SIDE}'
        ${api_path}    Set Variable    /credit-mng/platform/api${api_path}
        Set To Dictionary    ${headers}    User-Id=${merchant_business_id}
    END
    ${body}    Create Dictionary
    ...    amount=${amount}
    ...    userId=${user_id}
    ...    type=${type}
    ...    basketDetailsDto=${EMPTY}
    ...    callbackUrl=${callback_url}
    ...    paymentChannel=${channel}
    ${basket_Details_Dto}    Create Dictionary
    ${items_list}    Create List
    ${item}    Create Dictionary
    ...    chequeEligible=${cheque_eligible}
    ...    sellerId=${sellerId}
    ...    supplierId=${supplier_id}
    ...    productCode=${product_code}
    ...    brand=${brand}
    ...    productType=${product_type}
    ...    count=${count}
    ...    categoryId=${category_id}

    Append To List    ${items_list}    ${item}
    Set To Dictionary    ${basket_Details_Dto}    items=${items_list}    basketId=${basket_id}

    Set To Dictionary    ${body}    basketDetailsDto=${basket_Details_Dto}

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
