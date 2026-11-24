*** Settings ***
Resource    services/backend/session-service.resource

*** Keywords ***
POST Admin Credit Cheques Accept Cheque Status
    [Arguments]
    ...    ${api_call_side}
    ...    ${reasons}
    ...    ${cheque_id}
    ...    ${doc_id}
    ...    ${credit_id}
    ${header}    Create Dictionary
    ${api_path}    Set Variable    /admin/cheques/accept
    IF    '${api_call_side}' == '${MICROSERVICE_SIDE}'
        ${api_path}    Set Variable    ${MS_CREDIT_ONBOARDING_PATH}${api_path}
    END
    ${body}    Create Dictionary
    ...    reasons=${reasons}
    ...    chequeId=${cheque_id}
    ...    docId=${doc_id}
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
