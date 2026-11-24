*** Settings ***
Library     String
Library     Collections
Library     JSONLibrary
Library     RequestsLibrary
Resource    services/backend/session-service.resource


*** Keywords ***
POST Purchases Coupon Validate
    [Documentation]    This API is exclusively called by Company from the Credit Merchant Management microservice
    ...    for the UPG channel. Based on the value of repaymentOption 0= single installment 1=multiple installment,
    ...    the API determines which active gateways to display
    [Arguments]
    ...    ${api_call_side}
    ...    ${ticket}
    ...    ${coupon_code}
    ...    ${credit_id}

    ${api_path}    Set Variable    /purchases/coupon/validate/${ticket}
    IF    '${api_call_side}' == '${MICROSERVICE_SIDE}'
        ${api_path}    Set Variable    ${MS_CREDIT_MNG_PATH}${api_path}
    END
    ${body}    Create Dictionary    couponCode=${coupon_code}    creditId=${credit_id}
    ${session}    Create A Session    ${api_call_side}

    ${response}    POST On Session
    ...    ${session}
    ...    ${api_path}
    ...    json=${body}
    ...    expected_status=any

    ${result}    Create Dictionary    status_code=${response.status_code}    body=${response.json()}
    RETURN    ${result}

    [Teardown]    Delete A Session    ${session}
