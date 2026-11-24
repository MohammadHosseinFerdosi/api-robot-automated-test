*** Settings ***
Library         String
Library         JSONLibrary
Library         RequestsLibrary
Variables       data/CONSTANTS.yaml
Resource        services/backend/session-service.resource


*** Keywords ***
POST Wallets Transfer Pay Wallet
    [Documentation]    This API Get A Ticket From "Post gateway user-wallet to get transfer ticket"
    ...    And Transfers '${amount}' From '${user_id}' To '${dest_cellnumber}' By Ticket.
    [Arguments]
    ...    ${api-call-side}
    ...    ${ticket}
    ...    ${user-ip}
    ...    ${type}
    ...    ${agent}

    ${api_path}    Set Variable    /wallets/transfer/pay/wallet
    IF    '${api-call-side}' == '${MICROSERVICE_SIDE}'
        ${api_path}    Set Variable    ${MS_NEMO_PATH}${api_path}
    END

    ${header}    Create Dictionary
    ...    Agent=${agent}

    ${body}    Create Dictionary
    ...    ticket=${ticket}
    ...    userIP=${user-ip}
    ...    type=${type}

    ${session}    Create A Session    ${api-call-side}
    ${result}    POST On Session
    ...    ${session}
    ...    ${api_path}
    ...    headers=${header}
    ...    json=${body}
    ...    expected_status=any
    IF    ${result.status_code} == 200
        ${response}    Create Dictionary    status_code=${result.status_code}    body=${result.json()}
        RETURN    ${response}
    ELSE
        ${response}    Create Dictionary    status_code=${result.status_code}    result=${result.json().get('result')}
        RETURN    ${response}
    END

    [Teardown]    Delete A Session    ${session}
    
