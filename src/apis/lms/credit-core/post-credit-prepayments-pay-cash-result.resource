*** Settings ***
Library         String
Library         Collections
Library         JSONLibrary
Library         RequestsLibrary
Resource        services/backend/session-service.resource
Variables       data/CONSTANTS.yaml


*** Keywords ***
POST Credit Prepayment Pay Cash Result
    [Documentation]    This Api Pay the cash Part of Offline Purchase For Channel 5,6
    ...    This API requires several input arguments.
    [Arguments]
    ...    ${api_call_side}
    ...    ${tracking_code}
    ...    ${confirmation_code}
    ...    ${rrn}
    ...    ${terminal_id}
    ...    ${masked_pan}
    ...    ${psp_code}
    ...    ${result_code}

    ${api_path}=    Set Variable    /prepayments/pay/cash/result

    IF    '${api_call_side}' == '${MICROSERVICE_SIDE}'
        ${api_path}=    Set Variable    ${MS_CREDIT_MNG_PATH}${api_path}
    END

    ${body}=    Create Dictionary
    ...    trackingCode=${tracking_code}
    ...    confirmationCode=${confirmation_code}
    ...    rrn=${rrn}
    ...    terminalId=${terminal_id}
    ...    maskedPan=${masked_pan}
    ...    pspCode=${psp_code}
    ...    resultCode=${result_code}
    ${session}=    Create A Session    ${api_call_side}

    ${response}=    POST On Session
    ...    ${session}
    ...    ${api_path}
    ...    json=${body}
    ...    expected_status=any
    IF    '${response.status_code}'=='400'
        ${result}=    Create Dictionary    status_code=400    body=[]
    ELSE
        ${result}=    Create Dictionary    status_code=${response.status_code}    body=${response.json()}
    END

    RETURN    ${result}

    [Teardown]    Delete A Session    ${session}
