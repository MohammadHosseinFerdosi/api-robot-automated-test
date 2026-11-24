*** Settings ***
Library         String
Library         JSONLibrary
Library         RequestsLibrary
Variables       data/CONSTANTS.yaml
Resource        services/backend/session-service.resource


*** Keywords ***
POST Wallets Transfer
    [Documentation]    This API Get A Ticket Which Is Needed For Transfering
    ...    '${amount}' From '${user_id}' To '${dest_cellnumber}'.
    ...    NOTE: For `MICROSERVICE` call side, '${user_id}' must be set.
    [Arguments]
    ...    ${api-call-side}
    ...    ${user-id}
    ...    ${agent}
    ...    ${amount}
    ...    ${dest_cellnumber}
    ...    ${msg}=${EMPTY}

    ${api_path}    Set Variable    /wallets/transfer
    IF    '${api-call-side}' == '${MICROSERVICE_SIDE}'
        ${api_path}    Set Variable    ${MS_NEMO_PATH}/wallets/transfer
    END

    IF    '${msg}' == '${EMPTY}'
        ${msg}    Generate Random String    20
    END

    IF    '${user-id}' == '${EMPTY}'
        ${user-id}    Set Variable    ${USER_ID}
    END

    ${header}    Create Dictionary
    ...    Agent=${agent}
    ...    User-id=${user-id}

    ${body}    Create Dictionary
    ...    amount=${amount}
    ...    destCellNumber=${dest_cellnumber}
    ...    message=${msg}

    ${session}    Create A Session    ${api-call-side}
    ${result}    POST On Session
    ...    ${session}
    ...    ${api_path}
    ...    headers=${header}
    ...    json=${body}
    ...    expected_status=any
    IF    ${result.status_code} == 200
        ${response}    Create Dictionary    status_code=${result.status_code}    ticket=${result.json().get('ticket')}
        RETURN    ${response}
    ELSE
        ${response}    Create Dictionary    status_code=${result.status_code}    result=${result.json().get('result')}
        RETURN    ${response}
    END

    [Teardown]    Delete A Session    ${session}
