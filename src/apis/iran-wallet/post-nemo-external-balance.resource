*** Settings ***
Resource        apis/iran-wallet/iw-http.resource
Variables       data/iran-wallet/CONSTANTS.yaml


*** Keywords ***
POST Nemo External Balance
    [Documentation]    POST /wallets/external/balance.
    [Arguments]
    ...    ${api_call_side}
    ...    ${wallet_provider}=${NEMO_WALLET_PROVIDER}
    ...    ${auth_parameter}=${EMPTY}
    ${body}=    Create Dictionary    walletProvider=${wallet_provider}
    ${session}=    Create A Session    ${api_call_side}    ${auth_parameter}
    TRY
        ${result}=    Iran Wallet Post Json On Session    ${session}    /wallets/external/balance    ${body}
        RETURN    ${result}
    FINALLY
        Delete A Session    ${session}
    END
