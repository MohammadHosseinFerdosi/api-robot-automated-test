*** Settings ***
Library         DateTime
Resource        apis/iran-wallet/iw-http.resource
Variables       data/iran-wallet/CONSTANTS.yaml


*** Keywords ***
POST Admin External Statement
    [Documentation]    Admin statement for Iran Wallet transfers.
    [Arguments]
    ...    ${api_call_side}
    ...    ${size}=${IW_STATEMENT_SIZE}
    ...    ${page}=${IW_STATEMENT_PAGE}
    ...    ${wallet_provider}=${IRAN_WALLET_PROVIDER}
    ${now}=    Get Current Date    result_format=epoch    exclude_millis=False
    ${to_ms}=    Evaluate    int(float(${now}) * 1000)
    ${from_ms}=    Evaluate    ${to_ms} - ${IW_STATEMENT_WINDOW_MS}
    ${body}=    Create Dictionary
    ...    walletProvider=${wallet_provider}
    ...    fromDate=${from_ms}
    ...    toDate=${to_ms}
    ...    page=${page}
    ...    size=${size}
    ${session}=    Create A Session    ${api_call_side}
    TRY
        ${result}=    Iran Wallet Post Json On Session    ${session}    /admin/external/statement    ${body}
        RETURN    ${result}
    FINALLY
        Delete A Session    ${session}
    END
