*** Settings ***
Resource        apis/iran-wallet/iw-http.resource
Variables       data/iran-wallet/CONSTANTS.yaml


*** Keywords ***
POST Transaction Transfer
    [Documentation]    POST /transaction/transfer (confirm).
    [Arguments]    ${api_call_side}    ${tracking_code}
    ${body}=    Create Dictionary    trackingCode=${tracking_code}
    ${session}=    Create A Session    ${api_call_side}
    TRY
        ${result}=    Iran Wallet Post Json On Session    ${session}    /transaction/transfer    ${body}
        RETURN    ${result}
    FINALLY
        Delete A Session    ${session}
    END
