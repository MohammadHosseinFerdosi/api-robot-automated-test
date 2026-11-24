*** Settings ***
Resource    steps/iran-wallet/common-step.resource


*** Keywords ***
User Requests Nemo External Balance
    [Documentation]    POST Nemo external balance.
    ${result}=    POST Nemo External Balance    ${NEMO_APP_SIDE}
    Remember Iran Wallet Api Result    ${result}

User Registers Nemo Cash In
    [Documentation]    POST Nemo cash-in register.
    ${result}=    POST Nemo Cash In Register    ${NEMO_APP_SIDE}
    Remember Iran Wallet Api Result    ${result}

User Registers Nemo Cash In With Invalid Amount
    [Documentation]    POST Nemo cash-in with invalid amount.
    ${result}=    POST Nemo Cash In Register    ${NEMO_APP_SIDE}    amount=${IW_NEMO_INVALID_AMOUNT}
    Remember Iran Wallet Api Result    ${result}

User Registers Nemo Cash Out Without Type
    [Documentation]    POST Nemo cash-out without type.
    ${result}=    POST Nemo Cash Out Register    ${NEMO_APP_SIDE}
    Remember Iran Wallet Api Result    ${result}

Nemo Balance Response Should Be Successful
    [Documentation]    Expect 200 SUCCESS with numeric amount >= 0.
    Should Be Equal As Integers    ${IW_LAST_STATUS}    ${HTTP_OK}
    Should Be Equal    ${IW_LAST_BODY}[result][title]    ${API_RESULT_SUCCESS}
    Dictionary Should Contain Key    ${IW_LAST_BODY}    amount
    ${amount}=    Set Variable    ${IW_LAST_BODY}[amount]
    ${ok}=    Evaluate    isinstance($amount, (int, float)) and not isinstance($amount, bool)
    Should Be True    ${ok}
    Should Be True    ${amount} >= 0

Nemo Cash In Response Should Be Successful
    [Documentation]    Expect 200 SUCCESS with cash-in detailUrl (register URL only; not balance delta).
    Should Be Equal As Integers    ${IW_LAST_STATUS}    ${HTTP_OK}
    Should Be Equal    ${IW_LAST_BODY}[result][title]    ${API_RESULT_SUCCESS}
    Dictionary Should Contain Key    ${IW_LAST_BODY}    detailUrl
    Should Not Be Empty    ${IW_LAST_BODY}[detailUrl]
    Should Contain    ${IW_LAST_BODY}[detailUrl]    /wallets/cash-in/

Nemo Cash In Amount Should Be Rejected
    [Documentation]    Expect 422 INVALID_PARAMETER with message.
    Should Be Equal As Integers    ${IW_LAST_STATUS}    ${HTTP_UNPROC}
    Should Be Equal    ${IW_LAST_BODY}[result][title]    ${API_RESULT_INVALID_PARAMETER}
    Iran Wallet Result Message Should Be Present

Nemo Cash Out Without Type Should Be Rejected
    [Documentation]    Expect 422 INVALID_PARAMETER with message.
    Should Be Equal As Integers    ${IW_LAST_STATUS}    ${HTTP_UNPROC}
    Should Be Equal    ${IW_LAST_BODY}[result][title]    ${API_RESULT_INVALID_PARAMETER}
    Iran Wallet Result Message Should Be Present
