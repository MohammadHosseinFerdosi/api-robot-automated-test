*** Settings ***
Resource        apis/iran-wallet/iw-http.resource
Variables       data/iran-wallet/CONSTANTS.yaml


*** Keywords ***
POST Nemo Cash In Register
    [Documentation]    POST /wallets/external/cash-in/register.
    [Arguments]
    ...    ${api_call_side}
    ...    ${amount}=${IW_TEST_AMOUNT}
    ...    ${wallet_provider}=${NEMO_WALLET_PROVIDER}
    ...    ${auth_parameter}=${EMPTY}
    ${body}=    Create Dictionary    walletProvider=${wallet_provider}    amount=${amount}
    ${session}=    Create A Session    ${api_call_side}    ${auth_parameter}
    TRY
        ${result}=    Iran Wallet Post Json On Session    ${session}    /wallets/external/cash-in/register    ${body}
        RETURN    ${result}
    FINALLY
        Delete A Session    ${session}
    END
