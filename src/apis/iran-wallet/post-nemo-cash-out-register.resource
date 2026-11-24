*** Settings ***
Resource        apis/iran-wallet/iw-http.resource
Variables       data/iran-wallet/CONSTANTS.yaml


*** Keywords ***
POST Nemo Cash Out Register
    [Documentation]    POST /wallets/external/cash-out/register. Pass cash_out_type=${EMPTY} to omit type.
    [Arguments]
    ...    ${api_call_side}
    ...    ${amount}=${IW_NEMO_CASH_OUT_MIN}
    ...    ${wallet_provider}=${NEMO_WALLET_PROVIDER}
    ...    ${cash_out_type}=${EMPTY}
    ...    ${auth_parameter}=${EMPTY}
    IF    '${cash_out_type}' == '${EMPTY}'
        ${body}=    Create Dictionary    walletProvider=${wallet_provider}    amount=${amount}
    ELSE
        ${body}=    Create Dictionary
        ...    walletProvider=${wallet_provider}
        ...    amount=${amount}
        ...    type=${cash_out_type}
    END
    ${session}=    Create A Session    ${api_call_side}    ${auth_parameter}
    TRY
        ${result}=    Iran Wallet Post Json On Session    ${session}    /wallets/external/cash-out/register    ${body}
        RETURN    ${result}
    FINALLY
        Delete A Session    ${session}
    END
