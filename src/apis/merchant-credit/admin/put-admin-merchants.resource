*** Settings ***
Library     String
Library     Collections
Library     RequestsLibrary
Library     JSONLibrary
Resource    services/backend/session-service.resource


*** Keywords ***
PUT Admin Merchants
    [Arguments]
    ...    ${api_call_side}
    ...    ${credit_id_arg}
    ...    ${event}
    ...    ${message}=${None}
    ...    ${bank_account}=${None}

    ${header}    Create Dictionary
    ...    Agent=CONSOLE

    ${body}    Create Dictionary    event=${event}    message=${message}    bankAccount=${bank_account}


    ${sesion}    Create A Session    ${api_call_side}
    ${response}    PUT On Session
    ...    ${sesion}
    ...    /admin/credit/merchants/${credit_id_arg}
    ...    headers=${header}
    ...    json=${body}
    ...    expected_status=any
    ${result}    Create Dictionary    status_code=${response.status_code}    response_rule=${response.json()}
    RETURN    ${result}

    [Teardown]    Delete A Session    ${sesion}
