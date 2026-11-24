*** Settings ***
Variables       data/los/bnpl.yaml
Resource        apis/los/Journey/post-credit-volunteers-pre-register.resource
Resource        services/frontend/front-auth-service.resource
Resource        services/backend/LMS/credit-core/close-account.resource
Resource        apis/los/bnpl/post-credit-activations-cancel.resource


*** Keywords ***
the user is logged in to the app
    Login To App    ${BNPL_CELL_NUMBER_ARASTOO}

We Close all his BNPLs
    Evaluate    exec("import builtins; builtins.ObjectId = lambda *a, **k: None")
    ${myres}=    Close User Accounts    user_id=${BNPL_USER_ID_ARASTOO}

the user clicks on the verify information button on the /pre-register/submit page from ${APP_SIDE}
    ${RESULT}=    POST Credit Volunteers Pre Register
    ...    ${APP_SIDE}
    ...    ${BNPL_PLATFORM_VERSION}
    ...    ${BNPL_USER_ID_ARASTOO}
    ...    ${BNPL_NATIONAL_CODE_ARASTOO}
    ...    ${BNPL_TIME_STAMP_BIRTH_DATE_ARASTOO}
    ...    ${BNPL_GROUP_ID}
    ...    ${BNPL_PLAN_ID}
    ...    ${BNPL_CART_RESERVATION_REQUEST}
    ...    ${BNPL_BALANCE}

    Set Suite Variable    ${RESULT}
    Should Be Equal As Numbers    ${RESULT['status_code']}    200
    Should Not Be Empty    ${RESULT["body"]}
    Dictionary Should Contain Key    ${RESULT['body']}    fundProviderCode
    Dictionary Should Contain Key    ${RESULT['body']}    creditId
    Dictionary Should Contain Key    ${RESULT['body']}    state

a credit id is generated for that person
    Should Not Contain    ${RESULT['body']['creditId']}    Null
    Set Suite Variable    ${CREDIT_ID}    ${RESULT['body']['creditId']}

Archive The All Unallocated Credit
    [Documentation]    Calls the cancel endpoint and verifies the credit is removed.
    POST Credit Activation Cancel
    ...    fund_provider_code=${BNPL_DP_FP_CODE}
    ...    credit_id=${CREDIT_ID}
    ...    cancel_reason_type=${BNPL_CANCEL_REASON_TYPE}
    ...    cancel_reason=${BNPL_CANCEL_REASON}
    ...    api_call_side=${APP_SIDE}

    ${find_query}=    Create Dictionary    creditId=${CREDIT_ID}
    ${result}=    Mongo Db Find    switch_credit_db    activations    ${find_query}
    Should Be Empty    ${result['body']}
