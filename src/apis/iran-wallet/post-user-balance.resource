*** Settings ***
Resource        apis/iran-wallet/iw-http.resource
Variables       data/iran-wallet/CONSTANTS.yaml


*** Keywords ***
POST User Balance
    [Documentation]    POST /user/balance. Pass wallet_provider=${EMPTY} to omit field.
    [Arguments]
    ...    ${api_call_side}
    ...    ${national_code}=${IW_PRIMARY_NATIONAL_CODE}
    ...    ${wallet_provider}=${IRAN_WALLET_PROVIDER}
    ${prev}=    Set Log Level    WARN
    TRY
        IF    '${wallet_provider}' == '${EMPTY}'
            ${body}=    Create Dictionary    nationalCode=${national_code}
        ELSE
            ${body}=    Create Dictionary
            ...    nationalCode=${national_code}
            ...    walletProvider=${wallet_provider}
        END
    FINALLY
        Set Log Level    ${prev}
    END
    ${session}=    Create A Session    ${api_call_side}
    TRY
        ${result}=    Iran Wallet Post Json On Session    ${session}    /user/balance    ${body}
        RETURN    ${result}
    FINALLY
        Delete A Session    ${session}
    END

POST User Balance Raw
    [Documentation]    POST /user/balance with a raw request body string.
    [Arguments]    ${api_call_side}    ${raw_body}
    ${session}=    Create A Session    ${api_call_side}
    ${headers}=    Create Dictionary    Content-Type=application/json
    TRY
        ${result}=    Iran Wallet Post Raw On Session    ${session}    /user/balance    ${raw_body}    ${headers}
        RETURN    ${result}
    FINALLY
        Delete A Session    ${session}
    END
