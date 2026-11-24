*** Settings ***
Resource    services/backend/session-service.resource
*** Keywords ***
POST Admin Credit Cheques Received
    [Arguments]
    ...    ${api_call_side}
    ...    ${fund_provider_code}
    ...    ${user_id}
    ...    ${credit_id}
    ${header}    Create Dictionary    User-id=${ADMIN_USER_ID}
    ${api_path}    Set Variable    /admin/cheques/received
    IF    '${api_call_side}' == '${MICROSERVICE_SIDE}'
        ${api_path}    Set Variable    ${MS_CREDIT_ONBOARDING_PATH}${api_path}
    END
    ${body}    Create Dictionary
    ...    userId=${user_id}
    ...    fundProviderCode=${fund_provider_code}
    ...    creditId=${credit_id}
    ${session}    Create A Session    ${api_call_side}
    ${response}    POST On Session
    ...    ${session}
    ...    ${api_path}
    ...    json=${body}
    ...    headers=${header}
    ...    expected_status=any
    ${result}    Create Dictionary    status_code=${response.status_code}    body=${response.json()}
    RETURN    ${result}
    [Teardown]    Delete A Session    ${session}
