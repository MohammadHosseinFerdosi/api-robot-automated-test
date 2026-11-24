*** Settings ***
Library         String
Library         Collections
Library         RequestsLibrary
Variables       data/CONSTANTS.yaml
Resource        services/backend/session-service.resource
Resource        services/backend/auth-service.resource


*** Keywords ***
GET Credit Purchases Prepare
    [Documentation]    Sends a request to the Credit Purchases Ticket API with the specified parameters.
    [Arguments]
    ...    ${api_call_side}
    ...    ${user_id}
    ...    ${fp_business_id}
    ...    ${credit_id}
    ...    ${ticket}
    ...    ${amount}
    ...    ${credit_amount}
    ...    ${coupon_code}=${EMPTY}

    ${api_path}=    Set Variable    /credit/purchases/prepare/${fp_business_id}/${credit_id}/${ticket}
    ${headers}=    Create Dictionary    User-Id=${user_id}
    IF    '${api_call_side}' == '${MICROSERVICE_SIDE}'
        ${api_path}=    Set Variable    ${MS_CREDIT_MNG_PATH}/purchases/prepare/${fp_business_id}/${credit_id}/${ticket}
    END
    IF    '${coupon_code}' != '${EMPTY}'
        ${params}=    Create Dictionary    creditAmount=${credit_amount}    couponCode=${coupon_code}
    ELSE
        ${params}=    Create Dictionary    creditAmount=${credit_amount}
    END
    ${session}=    Create A Session    ${api_call_side}

    ${response}=    GET On Session
    ...    ${session}
    ...    ${api_path}
    ...    params=${params}
    ...    headers=${headers}
    ...    expected_status=any

    ${result}=    Create Dictionary    status_code=${response.status_code}    body=${response.json()}
    RETURN    ${result}

    [Teardown]    Delete A Session    ${session}
