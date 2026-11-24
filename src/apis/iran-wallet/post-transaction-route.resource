*** Settings ***
Library         library/iran_wallet/concurrent_route.py
Resource        apis/iran-wallet/iw-http.resource
Variables       data/iran-wallet/CONSTANTS.yaml


*** Keywords ***
POST Transaction Route
    [Documentation]    POST /transaction/route. Pass wallet_provider=${EMPTY} to omit field.
    [Arguments]
    ...    ${api_call_side}
    ...    ${tracking_code}
    ...    ${side}=${TRANSFER_SIDE_CASH_IN}
    ...    ${amount}=${IW_TEST_AMOUNT}
    ...    ${national_code}=${IW_PRIMARY_NATIONAL_CODE}
    ...    ${description}=${IW_DESCRIPTION}
    ...    ${wallet_provider}=${IRAN_WALLET_PROVIDER}
    ${prev}=    Set Log Level    WARN
    TRY
        IF    '${wallet_provider}' == '${EMPTY}'
            ${body}=    Create Dictionary
            ...    amount=${amount}
            ...    nationalCode=${national_code}
            ...    description=${description}
            ...    trackingCode=${tracking_code}
            ...    side=${side}
        ELSE
            ${body}=    Create Dictionary
            ...    amount=${amount}
            ...    nationalCode=${national_code}
            ...    walletProvider=${wallet_provider}
            ...    description=${description}
            ...    trackingCode=${tracking_code}
            ...    side=${side}
        END
    FINALLY
        Set Log Level    ${prev}
    END
    ${session}=    Create A Session    ${api_call_side}
    TRY
        ${result}=    Iran Wallet Post Json On Session    ${session}    /transaction/route    ${body}
        RETURN    ${result}
    FINALLY
        Delete A Session    ${session}
    END

POST Concurrent Transaction Route Same Tracking
    [Documentation]    Parallel POST /transaction/route for one tracking (raw thread-pool client).
    [Arguments]
    ...    ${api_call_side}
    ...    ${tracking_code}
    ...    ${workers}=${IW_CONCURRENT_WORKERS}
    ...    ${amount}=${IW_TEST_AMOUNT}
    ...    ${national_code}=${IW_PRIMARY_NATIONAL_CODE}
    ...    ${side}=${TRANSFER_SIDE_CASH_IN}
    ${session}=    Create A Session    ${api_call_side}
    TRY
        ${base_url}=    Path Builder    ${api_call_side}
        ${headers}=    Iran Wallet Session Headers    ${session}
        ${prev}=    Set Log Level    WARN
        TRY
            ${body}=    Create Dictionary
            ...    amount=${amount}
            ...    nationalCode=${national_code}
            ...    walletProvider=${IRAN_WALLET_PROVIDER}
            ...    description=${IW_DESCRIPTION}
            ...    trackingCode=${tracking_code}
            ...    side=${side}
        FINALLY
            Set Log Level    ${prev}
        END
        Iran Wallet Log Masked Request    POST    /transaction/route    ${body}
        ${results}=    Concurrent Post Json Results
        ...    ${base_url}/transaction/route
        ...    ${body}
        ...    ${workers}
        ...    ${IW_HTTP_TIMEOUT_SEC}
        ...    ${headers}
        RETURN    ${results}
    FINALLY
        Delete A Session    ${session}
    END
