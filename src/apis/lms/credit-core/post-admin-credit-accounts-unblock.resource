*** Settings ***
Library         String
Library         Collections
Library         RequestsLibrary
Resource        services/backend/session-service.resource

*** Keywords ***
Post Admin Credit Accounts Unblock
    [Documentation]    Sends a request to the Credit Accounts Unblock API with the specified parameters.
    [Arguments]
    ...    ${api_call_side}
    ...    ${credit_id}
    ...    ${user_id}=${EMPTY}
    ${api_path}=    Set Variable    /admin/credit/accounts/${credit_id}/unblock
    ${headers}    Create Dictionary
    IF    '${api_call_side}' == '${MICROSERVICE_SIDE}'
        ${api_path}    Set Variable    ${MS_CREDIT_ACCOUNT_MNG_PATH}/admin/credit/accounts/${credit_id}/unblock
        Set To Dictionary    ${headers}    User-Id=${user_id}
    END
    ${session}=    Create A Session    ${api_call_side}
    ${response}=    POST On Session
    ...    ${session}
    ...    ${api_path}
    ...    headers=${headers}
    ...    expected_status=any

    ${result}=    Create Dictionary    status_code=${response.status_code}    body=${response.json()}
    RETURN    ${result}

    [Teardown]    Delete A Session    ${session}