*** Settings ***
Library     String
Library     Collections
Library     RequestsLibrary
Resource    services/backend/session-service.resource

*** Keywords ***
Post Coupon Admin Coupons
    [Documentation]    Sends a request to create a coupon with the specified parameters.
    [Arguments]
    ...    ${api_call_side}
    ...    ${campaign_id}
    ...    ${name}
    ...    ${discountType}
    ...    ${merchantBusinessIds}
    ...    ${generationType}
    ...    ${paymentMethods}
    ...    ${paymentChannels}
    ...    ${startDate}
    ...    ${endDate}
    ...    ${maxUsage}
    ...    ${maxUserUsage}
    ...    ${minTransactionAmount}
    ...    ${maxDiscountAmount}
    ...    ${discountPercentage}
    ...    ${state}

    ${api_path}=    Set Variable    /admin/coupons
    ${headers}=    Create Dictionary
    ${campaign_data}=    Create Dictionary
    ...    name=${name}
    ...    discountType=${discountType}
    ...    merchantBusinessIds=${merchantBusinessIds}
    ...    generationType=${generationType}
    ...    paymentMethods=${paymentMethods}
    ...    paymentChannels=${paymentChannels}
    ...    startDate=${startDate}
    ...    endDate=${endDate}
    ...    prefix=${name}
    ...    maxUsage=${maxUsage}
    ...    maxUserUsage=${maxUserUsage}
    ...    minTransactionAmount=${minTransactionAmount}
    ...    maxDiscountAmount=${maxDiscountAmount}
    ...    discountPercentage=${discountPercentage}
    ...    state=${state}

    IF    '${api_call_side}' == '${MICROSERVICE_SIDE}'
        ${api_path}=    Set Variable    ${MS_COUPON}/admin/coupons/${campaign_id}
        Set To Dictionary    ${headers}    User-Id=${DASHBOARD_USERNAME}
    END
    
    ${session}    Create A Session    ${api_call_side}
    ${response}=    POST On Session
    ...    ${session}
    ...    ${api_path}
    ...    json=${campaign_data}
    ...    headers=${headers}
    ...    expected_status=any

    ${result}=    Create Dictionary    status_code=${response.status_code}    body=${response.json()}
    [Teardown]    Delete A Session    ${session}
    RETURN    ${result}