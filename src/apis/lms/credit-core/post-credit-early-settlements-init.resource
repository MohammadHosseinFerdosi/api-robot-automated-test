*** Settings ***
Library         String
Library         Collections
Library         RequestsLibrary
Variables       data/CONSTANTS.yaml
Resource        services/backend/session-service.resource


*** Keywords ***
POST Credit Early Settlements Init
    [Documentation]    Initiates an Early Settlement and creates a ticker and a record for the early settlement
    [Arguments]
    ...    ${api_call_side}
    ...    ${user_id}
    ...    ${credit_id}
    ...    ${amount}
    ...    ${cell_number}
    ...    ${type}
    ...    ${agent}
    ...    ${redirect_url}
    ...    ${redirect_details_after_result}
    ${api_path}    Set Variable    /early-settlements/init
    ${headers}    Create Dictionary
    IF    '${api_call_side}' == '${MICROSERVICE_SIDE}'
        ${api_path}    Set Variable    ${MS_CREDIT_MNG_PATH}${api_path}
        Set To Dictionary    ${headers}    User-Id=${user_id}
    ELSE IF    '${api_call_side}' == '${GENERAL_SIDE}'
        ${api_path}    Set Variable    ${GATEWAY_PATH}/credit${api_path}
    END

    ${body}    Create Dictionary
    ...    amount=${amount}
    ...    cellNumber=${cell_number}
    ...    type=${type}
    ...    userId=${user_id}
    ...    agent=${agent}    
    ...    redirect_url=${redirect_url}    
    ...    creditId=${credit_id}
    ...    redirectDetailAfterResult=&{redirect_details_after_result}

    ${session}    Create A Session    ${api_call_side}

    ${response}    POST On Session
    ...    ${session}
    ...    ${api_path}
    ...    headers=${headers}
    ...    json=${body}
    ...    expected_status=any

    ${result}    Create Dictionary    status_code=${response.status_code}    body=${response.json()}
    RETURN    ${result}

    [Teardown]    Delete A Session    ${session}
