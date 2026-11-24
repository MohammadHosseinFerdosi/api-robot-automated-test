*** Settings ***
Resource    steps/iran-wallet/common-step.resource


*** Keywords ***
A Routed Cash In Transfer Exists
    [Documentation]    Route a cash-in transfer for later duplicate/route asserts.
    Prepare New Tracking Code
    ${result}=    POST Transaction Route
    ...    ${WALLET_TRANSFER_SIDE}
    ...    ${IW_TRACKING_CODE}
    ...    side=${TRANSFER_SIDE_CASH_IN}
    Remember Iran Wallet Api Result    ${result}
    Should Be Equal As Integers    ${IW_LAST_STATUS}    ${HTTP_CREATED}

User Routes Cash In Transfer
    [Documentation]    POST cash-in route for IW_TRACKING_CODE.
    ${result}=    POST Transaction Route
    ...    ${WALLET_TRANSFER_SIDE}
    ...    ${IW_TRACKING_CODE}
    ...    side=${TRANSFER_SIDE_CASH_IN}
    Remember Iran Wallet Api Result    ${result}

User Routes Cash Out Transfer
    [Documentation]    POST cash-out route with small amount.
    ${result}=    POST Transaction Route
    ...    ${WALLET_TRANSFER_SIDE}
    ...    ${IW_TRACKING_CODE}
    ...    side=${TRANSFER_SIDE_CASH_OUT}
    ...    amount=${IW_CASH_OUT_ROUTE_AMOUNT}
    Remember Iran Wallet Api Result    ${result}

User Routes With Same Tracking Code Again
    [Documentation]    Re-route the same tracking code (duplicate case).
    ${result}=    POST Transaction Route
    ...    ${WALLET_TRANSFER_SIDE}
    ...    ${IW_TRACKING_CODE}
    Remember Iran Wallet Api Result    ${result}

User Routes Without Wallet Provider
    [Documentation]    Route omitting walletProvider.
    ${result}=    POST Transaction Route
    ...    ${WALLET_TRANSFER_SIDE}
    ...    ${IW_TRACKING_CODE}
    ...    wallet_provider=${EMPTY}
    Remember Iran Wallet Api Result    ${result}

User Confirms Unknown Tracking Code
    [Documentation]    Confirm a tracking code that was never routed.
    ${result}=    POST Transaction Transfer    ${WALLET_TRANSFER_SIDE}    ${IW_UNKNOWN_TRACKING}
    Remember Iran Wallet Api Result    ${result}

User Inquires Unknown Tracking Code
    [Documentation]    Inquiry for an unknown tracking code.
    ${result}=    GET Transaction Inquiry    ${WALLET_TRANSFER_SIDE}    ${IW_UNKNOWN_INQUIRY}
    Remember Iran Wallet Api Result    ${result}

User Requests Primary Balance
    [Documentation]    Read balance for the primary national code.
    ${result}=    POST User Balance    ${WALLET_TRANSFER_SIDE}
    Remember Iran Wallet Api Result    ${result}

User Requests Balance For Unregistered National Code
    [Documentation]    Balance for an unregistered national code.
    ${result}=    POST User Balance
    ...    ${WALLET_TRANSFER_SIDE}
    ...    national_code=${IW_UNREGISTERED_NATIONAL_CODE}
    Remember Iran Wallet Api Result    ${result}

User Requests Balance Without Wallet Provider
    [Documentation]    Balance omitting walletProvider.
    ${result}=    POST User Balance    ${WALLET_TRANSFER_SIDE}    wallet_provider=${EMPTY}
    Remember Iran Wallet Api Result    ${result}

User Posts Malformed Balance Json
    [Documentation]    Truncated JSON balance body from IW_BALANCE_MALFORMED_BODY.
    ${result}=    POST User Balance Raw    ${WALLET_TRANSFER_SIDE}    ${IW_BALANCE_MALFORMED_BODY}
    Remember Iran Wallet Api Result    ${result}

User Requests External Statement
    [Documentation]    Admin external statement for Iran Wallet.
    ${result}=    POST Admin External Statement    ${WALLET_TRANSFER_SIDE}
    Remember Iran Wallet Api Result    ${result}

User Sends Concurrent Routes For Same Tracking
    [Documentation]    Parallel routes for one tracking code.
    ${results}=    POST Concurrent Transaction Route Same Tracking
    ...    ${WALLET_TRANSFER_SIDE}
    ...    ${IW_TRACKING_CODE}
    ...    workers=${IW_CONCURRENT_WORKERS}
    Set Test Variable    ${IW_CONCURRENT_RESULTS}    ${results}

Route Response Should Be Created
    [Documentation]    Expect 201 INITIATED with non-empty providerTrackingCode.
    Should Be Equal As Integers    ${IW_LAST_STATUS}    ${HTTP_CREATED}
    Dictionary Should Contain Key    ${IW_LAST_BODY}    providerTrackingCode
    Should Not Be Empty    ${IW_LAST_BODY}[providerTrackingCode]
    Should Be Equal    ${IW_LAST_BODY}[status]    ${ROUTE_STATUS_INITIATED}

Route Response Should Be Invalid Parameter
    [Documentation]    Expect 422 INVALID_PARAMETER with message.
    Should Be Equal As Integers    ${IW_LAST_STATUS}    ${HTTP_UNPROC}
    Should Be Equal    ${IW_LAST_BODY}[result][title]    ${API_RESULT_INVALID_PARAMETER}
    Iran Wallet Result Message Should Be Present

Duplicate Route Response Should Be Rejected
    [Documentation]    Expect 422 DUPLICATE with message.
    Should Be Equal As Integers    ${IW_LAST_STATUS}    ${HTTP_UNPROC}
    Should Be Equal    ${IW_LAST_BODY}[result][title]    ${API_RESULT_DUPLICATE}
    Iran Wallet Result Message Should Be Present

Confirm Response Should Be Transaction Not Found
    [Documentation]    Expect 422 TRANSACTION_NOT_FOUND with message.
    Should Be Equal As Integers    ${IW_LAST_STATUS}    ${HTTP_UNPROC}
    Should Be Equal    ${IW_LAST_BODY}[result][title]    ${API_RESULT_TRANSACTION_NOT_FOUND}
    Iran Wallet Result Message Should Be Present

Inquiry Response Should Be Transaction Not Found
    [Documentation]    Expect 422 TRANSACTION_NOT_FOUND with message.
    Should Be Equal As Integers    ${IW_LAST_STATUS}    ${HTTP_UNPROC}
    Should Be Equal    ${IW_LAST_BODY}[result][title]    ${API_RESULT_TRANSACTION_NOT_FOUND}
    Iran Wallet Result Message Should Be Present

Balance Response Should Be Successful
    [Documentation]    Expect 200 with numeric balance >= 0.
    ...    WT /user/balance payload is {balance} only (no result.title wrapper).
    Should Be Equal As Integers    ${IW_LAST_STATUS}    ${HTTP_OK}
    Dictionary Should Contain Key    ${IW_LAST_BODY}    balance
    ${bal}=    Set Variable    ${IW_LAST_BODY}[balance]
    ${ok}=    Evaluate    isinstance($bal, (int, float)) and not isinstance($bal, bool)
    Should Be True    ${ok}
    Should Be True    ${bal} >= 0
    ${has_result}=    Run Keyword And Return Status    Dictionary Should Contain Key    ${IW_LAST_BODY}    result
    IF    ${has_result}
        Should Be Equal    ${IW_LAST_BODY}[result][title]    ${API_RESULT_SUCCESS}
    END

Balance Response Should Be Account Not Found
    [Documentation]    Expect 422 ACCOUNT_NOT_FOUND with message.
    Should Be Equal As Integers    ${IW_LAST_STATUS}    ${HTTP_UNPROC}
    Should Be Equal    ${IW_LAST_BODY}[result][title]    ${API_RESULT_ACCOUNT_NOT_FOUND}
    Iran Wallet Result Message Should Be Present

Balance Response Should Be Invalid Parameter
    [Documentation]    Expect 422 INVALID_PARAMETER with message.
    Should Be Equal As Integers    ${IW_LAST_STATUS}    ${HTTP_UNPROC}
    Should Be Equal    ${IW_LAST_BODY}[result][title]    ${API_RESULT_INVALID_PARAMETER}
    Iran Wallet Result Message Should Be Present

Balance Response Should Be Bad Request
    [Documentation]    Expect 400 problem+json with title and detail.
    Should Be Equal As Integers    ${IW_LAST_STATUS}    ${HTTP_BAD}
    Should Be Equal    ${IW_LAST_BODY}[title]    Bad Request
    Should Not Be Empty    ${IW_LAST_BODY}[detail]

Statement Response Should Be Successful
    [Documentation]    Expect 200 with consistent total/transactions; nonempty page for smoke.
    Should Be Equal As Integers    ${IW_LAST_STATUS}    ${HTTP_OK}
    Dictionary Should Contain Key    ${IW_LAST_BODY}    total
    Dictionary Should Contain Key    ${IW_LAST_BODY}    transactions
    ${total}=    Set Variable    ${IW_LAST_BODY}[total]
    ${txns}=    Set Variable    ${IW_LAST_BODY}[transactions]
    ${ok_total}=    Evaluate    isinstance($total, int) and not isinstance($total, bool)
    ${ok_txns}=    Evaluate    isinstance($txns, list)
    Should Be True    ${ok_total}
    Should Be True    ${ok_txns}
    ${txn_len}=    Get Length    ${txns}
    IF    $total == 0
        Should Be Equal As Integers    ${txn_len}    ${0}
        Fail    statement total is 0 in 7d window — empty page is soft-green; check provider/window
    END
    Should Be True    ${txn_len} > 0
    Should Be True    ${txn_len} <= ${total}
    ${first}=    Get From List    ${txns}    0
    Dictionary Should Contain Key    ${first}    amount
    Dictionary Should Contain Key    ${first}    status

Concurrent Route Statuses Should Be One Created Rest Rejected
    [Documentation]    Exactly one 201 INITIATED; rest 422 DUPLICATE.
    ${created}=    Set Variable    ${0}
    FOR    ${item}    IN    @{IW_CONCURRENT_RESULTS}
        ${code}=    Set Variable    ${item}[status_code]
        ${body}=    Set Variable    ${item}[body]
        IF    ${code} == ${HTTP_CREATED}
            ${created}=    Evaluate    ${created} + 1
            Should Be Equal    ${body}[status]    ${ROUTE_STATUS_INITIATED}
            Dictionary Should Contain Key    ${body}    providerTrackingCode
            Should Not Be Empty    ${body}[providerTrackingCode]
        ELSE
            Should Be Equal As Integers    ${code}    ${HTTP_UNPROC}
            Should Be Equal    ${body}[result][title]    ${API_RESULT_DUPLICATE}
        END
    END
    Should Be Equal As Integers    ${created}    ${1}
