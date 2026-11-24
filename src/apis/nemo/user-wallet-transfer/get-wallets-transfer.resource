*** Settings ***
Library         String
Library         JSONLibrary
Library         RequestsLibrary
Variables       data/CONSTANTS.yaml
Resource        services/backend/session-service.resource


*** Keywords ***
GET Wallets Transfer
    [Documentation]    This API Gets The User Wallet Informations. 
    [Arguments]
    ...    ${api-call-side}
    ...    ${user-id}
    ...    ${agent}

    ${api_path}    Set Variable    /wallets/transfer
    IF    '${api-call-side}' == '${MICROSERVICE_SIDE}'
        ${api_path}    Set Variable    ${MS_NEMO_PATH}${api_path}
    END

    ${header}    Create Dictionary
    ...    Agent=${agent}
    ...    User-id=${user-id}

    ${session}    Create A Session    ${api-call-side}
    ${result}    GET On Session
    ...    ${session}
    ...    ${api_path}
    ...    headers=${header}
    ...    expected_status=any
    IF    ${result.status_code} == 200
        ${response}    Create Dictionary    status_code=${result.status_code}    body=${result.json()}
        RETURN    ${response}
    ELSE
        ${response}    Create Dictionary    status_code=${result.status_code}    result=${result.json().get('result')}
        RETURN    ${response}
    END

    [Teardown]    Delete A Session    ${session}
    
