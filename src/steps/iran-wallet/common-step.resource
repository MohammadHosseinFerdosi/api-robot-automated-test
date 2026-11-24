*** Settings ***
Library         Collections
Library         library/iran_wallet/tracking.py
Library         library/iran_wallet/mongo_wt.py
Resource        services/backend/auth-service.resource
Resource        apis/iran-wallet/post-transaction-route.resource
Resource        apis/iran-wallet/post-transaction-transfer.resource
Resource        apis/iran-wallet/get-transaction-inquiry.resource
Resource        apis/iran-wallet/post-user-balance.resource
Resource        apis/iran-wallet/post-admin-external-statement.resource
Resource        apis/iran-wallet/post-nemo-external-balance.resource
Resource        apis/iran-wallet/post-nemo-cash-in-register.resource
Resource        apis/iran-wallet/post-nemo-cash-out-register.resource
Variables       data/CONSTANTS.yaml
Variables       data/iran-wallet/CONSTANTS.yaml
Variables       config/environment-stage.yaml


*** Keywords ***
Iran Wallet Suite Teardown
    [Documentation]    Close wallet-transfer Mongo if connected.
    TRY
        Close Iran Wallet Transfer Mongo
    EXCEPT
        Log    Mongo already closed    WARN
    END

Remember Iran Wallet Api Result
    [Documentation]    Store last Iran Wallet HTTP status and body on the test.
    [Arguments]    ${result}
    Set Test Variable    ${IW_LAST_STATUS}    ${result}[status_code]
    Set Test Variable    ${IW_LAST_BODY}    ${result}[body]

Prepare New Tracking Code
    [Documentation]    Generate IW_TRACKING_CODE for this test.
    ${code}=    New Iran Wallet Tracking Code    iw
    Set Test Variable    ${IW_TRACKING_CODE}    ${code}

Nemo User Is Authenticated
    [Documentation]    Login Platform app user for Nemo external-wallet APIs.
    Login To App    ${IW_PRIMARY_MOBILE}

Primary Iran Wallet User Is Available
    [Documentation]    Primary NID fixture is present for balance/statement calls.
    Should Not Be Empty    ${IW_PRIMARY_NATIONAL_CODE}

Unregistered National Code Is Available
    [Documentation]    Unregistered NID fixture is present for negative balance.
    Should Not Be Empty    ${IW_UNREGISTERED_NATIONAL_CODE}

An Unknown Tracking Code Is Ready
    [Documentation]    Unknown tracking fixture for confirm negatives.
    Should Not Be Empty    ${IW_UNKNOWN_TRACKING}

An Unknown Inquiry Tracking Code Is Ready
    [Documentation]    Unknown tracking fixture for inquiry negatives.
    Should Not Be Empty    ${IW_UNKNOWN_INQUIRY}

Connect Wallet Transfer Mongo For Suite
    [Documentation]    Open wallet_transfer_db with env credentials (reuses live client).
    Connect Iran Wallet Transfer Mongo
    ...    ${MONGO_DB_DEFAULT_HOST}
    ...    ${MONGO_DB_DEFAULT_PORT}
    ...    ${IW_WT_MONGO_USER}
    ...    ${MONGO_DB_DEFAULT_PASS}
    ...    ${IW_WT_DB_NAME}

A New Tracking Code Is Ready
    [Documentation]    Fresh tracking code ready for route/confirm.
    Prepare New Tracking Code

Iran Wallet Result Message Should Be Present
    [Documentation]    Assert result.message is non-empty (exact copy is UAT-locale fragile).
    Dictionary Should Contain Key    ${IW_LAST_BODY}    result
    Dictionary Should Contain Key    ${IW_LAST_BODY}[result]    message
    Should Not Be Empty    ${IW_LAST_BODY}[result][message]

Cleanup Prepared Tracking Code From Mongo
    [Documentation]    Best-effort delete of IW_TRACKING_CODE.
    ...    Platform UAT Mongo is often read-only secondary: cleanup WARN-skips and leaves rows.
    ${code}=    Get Variable Value    \${IW_TRACKING_CODE}    ${EMPTY}
    Return From Keyword If    $code is None or '${code}' == '${EMPTY}' or '${code}' == ''
    ${connected}=    Iran Wallet Transfer Mongo Is Connected
    IF    not ${connected}
        TRY
            Connect Wallet Transfer Mongo For Suite
        EXCEPT
            Log    Mongo connect failed; cleanup skipped    WARN
            RETURN
        END
    END
    ${deleted}=    Try Delete Transfers By Tracking Code    ${IW_WT_COLLECTION}    ${code}
    IF    ${deleted} < 0
        Log    Mongo cleanup not writable; tracking docs left in place    WARN
    END
