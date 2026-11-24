*** Settings ***
Resource    steps/iran-wallet/common-step.resource
Resource    steps/iran-wallet/wallet-transfer-step.resource


*** Keywords ***
Wallet Transfer Mongo Is Connected
    [Documentation]    Connect Mongo for wallet-transfer asserts.
    Connect Wallet Transfer Mongo For Suite

Transfer Should Persist In Mongo
    [Documentation]    One transaction doc for IW_TRACKING_CODE (retry briefly).
    Wait Until Keyword Succeeds
    ...    ${IW_DB_RETRY_TIMEOUT_SEC}s
    ...    ${IW_DB_RETRY_INTERVAL_SEC}s
    ...    Transfer Count Should Be One

Transfer Count Should Be One
    [Documentation]    Assert exactly one Mongo doc for IW_TRACKING_CODE.
    ${count}=    Count Transfers By Tracking Code    ${IW_WT_COLLECTION}    ${IW_TRACKING_CODE}
    Should Be Equal As Integers    ${count}    ${1}

Transfer Should Have Initiated Journal
    [Documentation]    Journals include INITIATED (retry briefly).
    Wait Until Keyword Succeeds
    ...    ${IW_DB_RETRY_TIMEOUT_SEC}s
    ...    ${IW_DB_RETRY_INTERVAL_SEC}s
    ...    Transfer Initiated Journal Should Exist

Transfer Initiated Journal Should Exist
    [Documentation]    Assert INITIATED journal exists for IW_TRACKING_CODE.
    ${ok}=    Transfer Has Initiated Journal    ${IW_WT_COLLECTION}    ${IW_TRACKING_CODE}
    Should Be True    ${ok}

Transfer Should Match Cash In Route In Mongo
    [Documentation]    Persist with side CASH_IN and IW_TEST_AMOUNT.
    Transfer Should Persist In Mongo
    Wait Until Keyword Succeeds
    ...    ${IW_DB_RETRY_TIMEOUT_SEC}s
    ...    ${IW_DB_RETRY_INTERVAL_SEC}s
    ...    Transfer Cash In Fields Should Match

Transfer Cash In Fields Should Match
    [Documentation]    Assert Mongo side/amount for cash-in route.
    Transfer Field Equals    ${IW_WT_COLLECTION}    ${IW_TRACKING_CODE}    side    ${TRANSFER_SIDE_CASH_IN}
    Transfer Field Equals    ${IW_WT_COLLECTION}    ${IW_TRACKING_CODE}    amount    ${IW_TEST_AMOUNT}

Transfer Should Match Cash Out Route In Mongo
    [Documentation]    Persist with side CASH_OUT and IW_CASH_OUT_ROUTE_AMOUNT.
    Transfer Should Persist In Mongo
    Wait Until Keyword Succeeds
    ...    ${IW_DB_RETRY_TIMEOUT_SEC}s
    ...    ${IW_DB_RETRY_INTERVAL_SEC}s
    ...    Transfer Cash Out Fields Should Match

Transfer Cash Out Fields Should Match
    [Documentation]    Assert Mongo side/amount for cash-out route.
    Transfer Field Equals    ${IW_WT_COLLECTION}    ${IW_TRACKING_CODE}    side    ${TRANSFER_SIDE_CASH_OUT}
    Transfer Field Equals    ${IW_WT_COLLECTION}    ${IW_TRACKING_CODE}    amount    ${IW_CASH_OUT_ROUTE_AMOUNT}
