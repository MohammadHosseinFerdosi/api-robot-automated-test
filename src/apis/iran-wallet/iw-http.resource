*** Settings ***
Library         library/iran_wallet/response.py
Resource        services/backend/session-service.resource
Variables       data/iran-wallet/CONSTANTS.yaml


*** Keywords ***
Iran Wallet Post Json On Session
    [Documentation]    POST JSON; mute RequestsLibrary dumps; return {status_code,body}.
    [Arguments]    ${session}    ${path}    ${body}    ${timeout}=${IW_HTTP_TIMEOUT_SEC}
    Iran Wallet Log Masked Request    POST    ${path}    ${body}
    Iran Wallet Mute Requests Library Logs
    TRY
        ${response}=    POST On Session
        ...    ${session}
        ...    ${path}
        ...    json=${body}
        ...    expected_status=any
        ...    timeout=${timeout}
    FINALLY
        Iran Wallet Restore Requests Library Logs
    END
    ${result}=    Handle API Response    ${response}
    RETURN    ${result}

Iran Wallet Post Raw On Session
    [Documentation]    POST raw body; mute dumps; return {status_code,body}.
    [Arguments]    ${session}    ${path}    ${data}    ${headers}    ${timeout}=${IW_HTTP_TIMEOUT_SEC}
    Iran Wallet Log Masked Request    POST    ${path}    ${None}
    Iran Wallet Mute Requests Library Logs
    TRY
        ${response}=    POST On Session
        ...    ${session}
        ...    ${path}
        ...    data=${data}
        ...    headers=${headers}
        ...    expected_status=any
        ...    timeout=${timeout}
    FINALLY
        Iran Wallet Restore Requests Library Logs
    END
    ${result}=    Handle API Response    ${response}
    RETURN    ${result}

Iran Wallet Get On Session
    [Documentation]    GET; mute dumps; return {status_code,body}.
    [Arguments]    ${session}    ${path}    ${timeout}=${IW_HTTP_TIMEOUT_SEC}
    Iran Wallet Log Masked Request    GET    ${path}    ${None}
    Iran Wallet Mute Requests Library Logs
    TRY
        ${response}=    GET On Session
        ...    ${session}
        ...    ${path}
        ...    expected_status=any
        ...    timeout=${timeout}
    FINALLY
        Iran Wallet Restore Requests Library Logs
    END
    ${result}=    Handle API Response    ${response}
    RETURN    ${result}
