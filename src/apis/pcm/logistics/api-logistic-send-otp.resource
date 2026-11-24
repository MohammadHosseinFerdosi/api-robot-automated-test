*** Settings ***
Library     RequestsLibrary
Resource    services/backend/session-service.resource


*** Keywords ***
Post api logistic send-otp
    [Documentation]    send-otp for ${logistic_token} and ${direction}
    [Arguments]    ${api_call_side}
    ...    ${logistic_token}
    ...    ${direction}

    ${api_path}    Set Variable    /api/logistic/send-otp

    IF    '${api_call_side}' == '${MICROSERVICE_SIDE}'
        ${api_path}    Set Variable    ${MS_BACKOFFICE_LANDING_PATH}${api_path}
    END

    ${body}    Create Dictionary    logisticToken=${logistic_token}    direction=${direction}

    ${session}    Create A Session    ${api_call_side}
    ${response}    POST On Session
    ...    ${session}
    ...    ${api_path}
    ...    json=${body}
    ...    expected_status=any
    ${result}    Create Dictionary    status_code=${response.status_code}    body=${response.json()}
    RETURN    ${result}
