*** Settings ***
Library     String
Library     Collections
Library     JSONLibrary
Library     RequestsLibrary
Resource    services/backend/session-service.resource


*** Keywords ***
GET Merchant Gateways Account
    [Documentation]    This API retrieves the list of active gateways for a specific merchant.
    ...    Each gateway includes details such as the channel,paymentGateway, repaymentOptions, and businessType.
    ...    If the merchant is included in the server configuration whitelist, 
    ...    the response will also contain gatewayConfigs with the following fields
    ...    showBalance (boolean): Indicates whether the balance should be displayed.
    ...    otpThreshold (number): Defines the threshold value for requiring OTP.
    ...    If the merchant is not in the whitelist, the gatewayConfigs will be returned as an empty array.

    [Arguments]
    ...    ${api_call_side}
    ...    ${user_id}

    ${api_path}    Set Variable    /credit/merchants/gateways/${user_id}
    IF    '${api_call_side}' == '${MICROSERVICE_SIDE}'
        ${api_path}    Set Variable    ${MS_CREDIT_MERCHANT_MNG_PATH}${api_path}
    END
    # ${params}    Create Dictionary    type=${type}
    ${session}    Create A Session    ${api_call_side}

    ${response}    GET On Session
    ...    ${session}
    ...    ${api_path}
    # ...    params=${params}
    ...    expected_status=any

    ${result}    Create Dictionary    status_code=${response.status_code}    body=${response.json()}
    RETURN    ${result}

    [Teardown]    Delete A Session    ${session}
