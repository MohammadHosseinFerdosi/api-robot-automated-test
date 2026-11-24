*** Settings ***
Library     RequestsLibrary
Resource    services/backend/session-service.resource


*** Keywords ***
Post api logistic verify-otp
    [Documentation]    verify-otp for ${logistic_token} and ${otp_code}
    [Arguments]
    ...    ${api_call_side}
    ...    ${logistic_token}
    ...    ${otp_code}

    ${api_path}    Set Variable    /api/logistic/verify-otp

    IF    '${api_call_side}' == '${MICROSERVICE_SIDE}'
        ${api_path}    Set Variable    ${MS_BACKOFFICE_LANDING_PATH}${api_path}
    END

    ${body}    Create Dictionary    logisticToken=${logistic_token}    otpCode=${otp_code}

    ${session}    Create A Session    ${api_call_side}
    ${response}    POST On Session
    ...    ${session}
    ...    ${api_path}
    ...    json=${body}
    ...    expected_status=any
    ${result}    Create Dictionary    status_code=${response.status_code}    body=${response.json()}
    RETURN    ${result}
