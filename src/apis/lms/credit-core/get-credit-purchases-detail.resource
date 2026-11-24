*** Settings ***
Library         String
Library         Collections
Library         RequestsLibrary
Variables       data/CONSTANTS.yaml
Variables       data/lms/purchase-bnpl.yaml
Resource        services/backend/session-service.resource
Resource        services/backend/auth-service.resource


*** Keywords ***
GET Credit Purchases Detail
    [Documentation]    Sends a request to the Credit Purchases Detail API with the specified parameters.
    [Arguments]
    ...    ${api_call_side}
    ...    ${user_id}
    ...    ${FUND_PROVIDER_BUSINESS_ID}
    ...    ${ticket}
    ...    ${credit_id}
    ...    ${version}
    ...    ${coupon_code}

    ${api_path}=    Set Variable    /credit/purchases/detail/${FUND_PROVIDER_BUSINESS_ID}/${ticket}
    ${headers}=    Create Dictionary    User-Id=${user_id}    Platform_Version=${version}
    IF    '${api_call_side}' == '${MICROSERVICE_SIDE}'
        ${api_path}=    Set Variable    ${MS_CREDIT_MNG_PATH}/purchases/detail/${FUND_PROVIDER_BUSINESS_ID}/${ticket}
    END
    IF    '${coupon_code}' != '${EMPTY}'
        ${params}=    Create Dictionary    creditId=${credit_id}    couponCode=${coupon_code}
    ELSE
        ${params}=    Create Dictionary    creditId=${credit_id}
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
