*** Settings ***
Resource        apis/iran-wallet/iw-http.resource
Variables       data/iran-wallet/CONSTANTS.yaml


*** Keywords ***
GET Transaction Inquiry
    [Documentation]    GET /transaction/transfer/{trackingCode}.
    [Arguments]    ${api_call_side}    ${tracking_code}
    ${session}=    Create A Session    ${api_call_side}
    TRY
        ${result}=    Iran Wallet Get On Session    ${session}    /transaction/transfer/${tracking_code}
        RETURN    ${result}
    FINALLY
        Delete A Session    ${session}
    END
