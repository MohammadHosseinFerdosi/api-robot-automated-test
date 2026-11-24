*** Settings ***
Library     String
Library     Collections
Library     JSONLibrary
Library     RequestsLibrary
Resource    services/backend/session-service.resource


*** Keywords ***
GET Account Info From Gateway
    [Documentation]    This API is exclusively called by Company from the Credit Merchant Management microservice
    ...    for the UPG channel. Based on the value of repaymentOption 0= single installment 1=multiple installment,
    ...    the API determines which active gateways to display
    [Arguments]
    ...    ${api_call_side}
    ...    ${cell_number}
    ...    ${type}
    ...    ${user_id}

    ${api_path}    Set Variable    /credit/accounts/${cell_number}
    ${headers}    Create Dictionary    User-Id=${user_id}
    IF    '${api_call_side}' == '${MICROSERVICE_SIDE}'
        ${api_path}    Set Variable    ${MS_CREDIT_MERCHANT_MNG_PATH}${api_path}
    END
    ${params}    Create Dictionary    type=${type}
    ${session}    Create A Session    ${api_call_side}

    ${response}    GET On Session
    ...    ${session}
    ...    ${api_path}
    ...    params=${params}
    ...    headers=${headers}
    ...    expected_status=any

    ${result}    Create Dictionary    status_code=${response.status_code}    body=${response.json()}
    RETURN    ${result}

    [Teardown]    Delete A Session    ${session}
