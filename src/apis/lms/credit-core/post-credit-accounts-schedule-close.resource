*** Settings ***
Library     String
Library     Collections
Library     RequestsLibrary
Resource    services/backend/session-service.resource


*** Keywords ***
Post Credit Accounts Schedule Close
    [Documentation]    Sends a request to the Credit Accounts Block API with the specified parameters.
    [Arguments]
    ...    ${api_call_side}
    ...    ${credit_id}
    ...    ${BLOCK_REASON}=${LMS_BLOCK_REASON.ORGANIZATION_REQUEST}
    ...    ${user_id}=${EMPTY}
    ${api_path}=    Set Variable    /admin/credit/accounts/${credit_id}/schedule-close
    ${headers}=    Create Dictionary
    IF    '${api_call_side}' == '${MICROSERVICE_SIDE}'
        ${api_path}=    Set Variable    ${MS_CREDIT_ACCOUNT_MNG_PATH}/admin/credit/accounts/${credit_id}/schedule-close
        Set To Dictionary    ${headers}    User-Id=${user_id}
    END
    ${json_body}=    Create Dictionary
    ...    blockReason=${BLOCK_REASON}
    ${session}=    Create A Session    ${api_call_side}
    ${response}=    POST On Session
    ...    ${session}
    ...    ${api_path}
    ...    json=${json_body}
    ...    headers=${headers}
    ...    expected_status=any

    ${result}=    Create Dictionary    status_code=${response.status_code}    body=${response.json()}
    RETURN    ${result}

    [Teardown]    Delete A Session    ${session}
