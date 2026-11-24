*** Settings ***
Library     String
Library     Collections
Library     JSONLibrary
Library     RequestsLibrary
Resource    services/backend/session-service.resource


*** Keywords ***
POST Credit Purchases Refunds
    [Documentation]    post-credit-purchases-refunds is the LMS refund API.
    ...    The API can be called via ${APP_SIDE} or ${MICROSERVICE_SIDE}.
    ...
    ...    The inputs include:
    ...
    ...    1. ${api_call_side}: The API call side. Valid inputs are ${MICROSERVICE_SIDE} and ${GENERAL_SIDE}
    ...
    ...    2. ${sale_tracking_code}: The purchaseTrackingCode of the purchase
    ...
    ...    3. ${user_id}: The businessId of the purchase. *Optional Argument*: Must be included f the ${MICROSERVICE_SIDE}
    ...
    ...    4. ${type}: The ticket Type (*optional*). The refund mng does not get effected by incorrect or missing types.
    ...
    ...    5. ${provider_id}: A randomly generated providerId for the refund
    ...
    ...    6. ${amount}: The requested refund amount
    ...
    ...    7. ${description}: A description for the refund
    [Arguments]
    ...    ${api_call_side}
    ...    ${sale_tracking_code}
    ...    ${amount}
    ...    ${type}
    ...    ${provider_id}
    ...    ${description}
    ...    ${user_id}=${EMPTY}

    ${headers}    Create Dictionary
    ${api_path}    Set Variable    /refunds

    IF    '${api_call_side}'=='${MICROSERVICE_SIDE}'
        ${api_path}    Set Variable    ${MS_CREDIT_MNG_PATH}/purchases${api_path}
        Set To Dictionary    ${headers}    User-Id=${user_id}
    END

    ${params}    Create Dictionary    type=${type}

    ${body}    Create Dictionary
    ...    saleTrackingCode=${sale_tracking_code}
    ...    amount=${amount}
    ...    providerId=${provider_id}
    ...    description=${description}

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
