*** Settings ***
Resource    services/backend/import-allocation.resource
Resource    services/backend/user-wallet-initializer-service.resource
Resource    services/backend/LMS/credit-core/credit-online-purchase.resource
Resource    services/backend/LMS/credit-core/credit-offline-purchase.resource
Resource    services/backend/LMS/credit-core/pay-early-settlement.resource
Resource    apis/lms/credit-core/post-credit-purchases-refunds.resource
Resource    apis/lms/credit-core/post-admin-credit-accounts-block.resource
Resource    apis/lms/credit-core/post-credit-gateway-activate.resource
Resource    apis/lms/credit-core/post-credit-gateways-disable.resource
Resource    services/backend/LMS/credit-core/close-billing-cycles.resource
Resource    services/backend/LMS/credit-core/expire-credit-account.resource
Resource    apis/lms/credit-core/post-credit-accounts-schedule-close.resource


*** Keywords ***
# ===================== MERCHANT INITIALIZATION =====================

Initialize Merchants
    [Documentation]    Test setup. Initializes a merchant with all required wallets for LMS refund scenarios.
    ${spend_wallet_for_business_1}    Create Dictionary
    ...    definition=${B_WALLET_SPEND_DEFINITION}
    ...    wallet_charge_amount=0
    ...    currency=${CURRENCY_IRR}

    ${credit_spend_wallet_for_business_1}    Create Dictionary
    ...    definition=${B_WALLET_CREDIT_SPEND_DEFINITION}
    ...    wallet_charge_amount=0
    ...    currency=${CURRENCY_CRR}

    ${debit_settlement_wallet_for_business_1}    Create Dictionary
    ...    definition=${B_WALLET_DEBIT_SETTLEMENT_DEFINITION}
    ...    wallet_charge_amount=0
    ...    currency=${CURRENCY_IRR}

    ${credit_settlement_wallet_for_business_1}    Create Dictionary
    ...    definition=${B_WALLET_CREDIT_SETTLEMENT_DEFINITION}
    ...    wallet_charge_amount=0
    ...    currency=${CURRENCY_CRR}

    ${credit_IRR_refund_wallet_for_business_1}    Create Dictionary
    ...    definition=${B_WALLET_REFUND_DEFINITION}
    ...    wallet_charge_amount=5000
    ...    currency=${CURRENCY_IRR}

    ${credit_CRR_refund_wallet_for_business_1}    Create Dictionary
    ...    definition=${B_WALLET_CREDIT_REFUND_DEFINITION}
    ...    wallet_charge_amount=5000
    ...    currency=${CURRENCY_CRR}

    @{role_list}    Create List    merchant-business

    @{wallet_setup_list_1}    Create List
    ...    ${spend_wallet_for_business_1}
    ...    ${credit_spend_wallet_for_business_1}
    ...    ${debit_settlement_wallet_for_business_1}
    ...    ${credit_settlement_wallet_for_business_1}
    ...    ${credit_IRR_refund_wallet_for_business_1}
    ...    ${credit_CRR_refund_wallet_for_business_1}

    ${INIT_BUSINESS_OBJ_1}    Get Initialized Business With Charged Wallet Based On Configuration
    ...    ${wallet_setup_list_1}

    ${LMS_AUTOMATION_BUSINESS_ID}    Set Variable    ${INIT_BUSINESS_OBJ_1['business_id']}
    Set Test Variable    ${LMS_AUTOMATION_BUSINESS_ID}

Reproduce Amount
    [Documentation]    Test teardown. Reproduces all business and user wallet amounts.
    [Arguments]    ${additional_user_lists}=${ALLOCATION_USER_LIST}
    Collect All Amount For Tear Down    additional_user_lists=${additional_user_lists}


# ===================== ALLOCATION =====================

Allocate No Fee BNPL Account
    [Documentation]    Allocates a no-fee BNPL (Buy Now Pay Later) account for a random user.
    ${user_object}    Activate Account
    ...    types=${{['${LMS_Account_Type_1PAY}']}}
    ...    fee_types=${{['${LMS_ZERO_FEE}']}}
    ...    default_amount=5000

    ${cell_number}    Set Variable    ${user_object['user_cell_number']}
    ${user_id}        Set Variable    ${user_object['user_id']}
    ${credit_ids}     Set Variable    ${user_object['user_credit_ids']}
    &{user_data}      Create Dictionary    user_id=${user_id}    type=${CUSTOMER_TYPE}
    ${ALLOCATION_USER_LIST}    Create List    ${user_data}

    Set Test Variable    ${cell_number}
    Set Test Variable    ${user_id}
    Set Test Variable    ${credit_ids}
    Set Test Variable    ${user_object}
    Set Test Variable    ${ALLOCATION_USER_LIST}

Allocate No Fee Xpay BNPL Account
    [Documentation]    Allocates a no-fee XPAY BNPL account for a random user.
    ${user_object}    Activate Account
    ...    types=${{['${LMS_Account_Type_XPAY}']}}
    ...    fee_types=${{['${LMS_ZERO_FEE}']}}
    ...    default_amount=5000

    ${cell_number}    Set Variable    ${user_object['user_cell_number']}
    ${user_id}        Set Variable    ${user_object['user_id']}
    ${credit_ids}     Set Variable    ${user_object['user_credit_ids']}
    &{user_data}      Create Dictionary    user_id=${user_id}    type=${CUSTOMER_TYPE}
    ${ALLOCATION_USER_LIST}    Create List    ${user_data}

    Set Test Variable    ${cell_number}
    Set Test Variable    ${user_id}
    Set Test Variable    ${credit_ids}
    Set Test Variable    ${user_object}
    Set Test Variable    ${ALLOCATION_USER_LIST}

Allocate Fee On Purchase BNPL Account
    [Documentation]    Allocates a fee-on-purchase XPAY BNPL account for a random user.
    ${user_object}    Activate Account
    ...    types=${{['${LMS_Account_Type_XPAY}']}}
    ...    fee_types=${{['${LMS_FEE_ON_PURCHASE}']}}
    ...    default_amount=5000

    ${cell_number}    Set Variable    ${user_object['user_cell_number']}
    ${user_id}        Set Variable    ${user_object['user_id']}
    ${credit_ids}     Set Variable    ${user_object['user_credit_ids']}
    &{user_data}      Create Dictionary    user_id=${user_id}    type=${CUSTOMER_TYPE}
    ${ALLOCATION_USER_LIST}    Create List    ${user_data}

    Set Test Variable    ${cell_number}
    Set Test Variable    ${user_id}
    Set Test Variable    ${credit_ids}
    Set Test Variable    ${user_object}
    Set Test Variable    ${ALLOCATION_USER_LIST}

Allocate No Fee CCredit Account
    [Documentation]    Allocates a no-fee revolving credit (CCREDIT) account for a random user.
    ${user_object}    Activate Account
    ...    types=${{['${LMS_Account_Type_CREDIT}']}}
    ...    fee_types=${{['${LMS_ZERO_FEE}']}}
    ...    default_amount=5000

    ${cell_number}    Set Variable    ${user_object['user_cell_number']}
    ${user_id}        Set Variable    ${user_object['user_id']}
    ${credit_ids}     Set Variable    ${user_object['user_credit_ids']}
    &{user_data}      Create Dictionary    user_id=${user_id}    type=${CUSTOMER_TYPE}
    ${ALLOCATION_USER_LIST}    Create List    ${user_data}

    Set Test Variable    ${cell_number}
    Set Test Variable    ${user_id}
    Set Test Variable    ${credit_ids}
    Set Test Variable    ${user_object}
    Set Test Variable    ${ALLOCATION_USER_LIST}

Allocate Fee On Purchase CCREDIT Account
    [Documentation]    Allocates a fee-on-purchase CCREDIT account for a random user.
    ${user_object}    Activate Account
    ...    types=${{['${LMS_Account_Type_CREDIT}']}}
    ...    fee_types=${{['${LMS_FEE_ON_PURCHASE}']}}
    ...    default_amount=5000

    ${cell_number}    Set Variable    ${user_object['user_cell_number']}
    ${user_id}        Set Variable    ${user_object['user_id']}
    ${credit_ids}     Set Variable    ${user_object['user_credit_ids']}
    &{user_data}      Create Dictionary    user_id=${user_id}    type=${CUSTOMER_TYPE}
    ${ALLOCATION_USER_LIST}    Create List    ${user_data}

    Set Test Variable    ${cell_number}
    Set Test Variable    ${user_id}
    Set Test Variable    ${credit_ids}
    Set Test Variable    ${user_object}
    Set Test Variable    ${ALLOCATION_USER_LIST}

Allocate No Fee Installment Sale Account
    [Documentation]    Allocates a no-fee installment sale account for a random user.
    ${user_object}    Activate Account
    ...    types=${{['${LMS_Account_Type_INSTALLMENT_SALE}']}}
    ...    fee_types=${{['${LMS_ZERO_FEE}']}}
    ...    default_amount=3000

    ${cell_number}    Set Variable    ${user_object['user_cell_number']}
    ${user_id}        Set Variable    ${user_object['user_id']}
    ${credit_ids}     Set Variable    ${user_object['user_credit_ids']}
    &{user_data}      Create Dictionary    user_id=${user_id}    type=${CUSTOMER_TYPE}
    ${ALLOCATION_USER_LIST}    Create List    ${user_data}

    Set Test Variable    ${cell_number}
    Set Test Variable    ${user_id}
    Set Test Variable    ${credit_ids}
    Set Test Variable    ${user_object}
    Set Test Variable    ${ALLOCATION_USER_LIST}


# ===================== SETTLEMENT METHODS & CHANNELS =====================

Set Settlement Method To BNPL 1pay
    Set Test Variable    ${SETTLEMENT_METHOD}    ${LMS_SETTLEMENT_METHODS.BNPL1PAY}

Set Settlement Method To BNPL Xpay
    Set Test Variable    ${SETTLEMENT_METHOD}    ${LMS_SETTLEMENT_METHODS.BNPLXPAY}

Set Settlement Method To CCREDIT
    Set Test Variable    ${SETTLEMENT_METHOD}    ${LMS_SETTLEMENT_METHODS.CCREDIT}

Set Settlement Method To CREDITCHECK
    Set Test Variable    ${SETTLEMENT_METHOD}    ${LMS_SETTLEMENT_METHODS.CREDITCHECK}

Set Settlement Method To Wallet
    Set Test Variable    ${SETTLEMENT_METHOD}    ${LMS_SETTLEMENT_METHODS.WALLET}

Set Channel To Payment Link
    Set Test Variable    ${PAYMENT_CHANNEL}    ${CHANNEL.PAYMENT_LINK}

Set Channel To UPG
    Set Test Variable    ${PAYMENT_CHANNEL}    ${CHANNEL.UPG}

Set Channel To API
    Set Test Variable    ${PAYMENT_CHANNEL}    ${CHANNEL.API}

The Gateway RepaymentOption Is Set To 1pay
    @{REPAYMENT_OPTIONS}    Create List    ${LMS_REPAYMENT_OPTION.ONEPAY}
    Set Test Variable    ${REPAYMENT_OPTIONS}

The Gateway RepaymentOption Is Set To Xpay
    @{REPAYMENT_OPTIONS}    Create List    ${LMS_REPAYMENT_OPTION.XPAY}
    Set Test Variable    ${REPAYMENT_OPTIONS}

The Gateway RepaymentOption Is Set To 1pay And Xpay
    @{REPAYMENT_OPTIONS}    Create List    ${LMS_REPAYMENT_OPTION.ONEPAY}    ${LMS_REPAYMENT_OPTION.XPAY}
    Set Test Variable    ${REPAYMENT_OPTIONS}

The Payment Gateway Is Set To BPG
    Set Test Variable    ${PAYMENT_GATEWAY}    ${LMS_PAYMENT_GATEWAY.BPG}

The Payment Gateway Is Set To CPG
    Set Test Variable    ${PAYMENT_GATEWAY}    ${LMS_PAYMENT_GATEWAY.CPG}

The Payment Gateway Is Set To ISPG
    Set Test Variable    ${PAYMENT_GATEWAY}    ${LMS_PAYMENT_GATEWAY.ISPG}


# ===================== PURCHASE =====================

Purchase Status Must Be CONFIRMED Or DELIVERED
    [Arguments]    ${tracking_code}=${tracking_code}
    ${filter_query}    Create Dictionary    trackingCode=${tracking_code}
    ${result}    Mongo Db Find    credit_mng_db    purchases    ${filter_query}
    @{records}    Get From Dictionary    ${result}    body
    ${result_object}    Set Variable    ${records}[0]
    IF    '${result_object['status']}'!= 'CONFIRMED'
        IF    '${result_object['status']}' != 'DELIVERED'
            Fail    msg=Expected status to be CONFIRMED or DELIVERED but got ${result_object['status']}.
        END
    END

Purchase Should Be Assigned To The Billing Cycle
    [Arguments]    ${tracking_code}=${tracking_code}
    ${filter_query}    Create Dictionary    trackingCode=${tracking_code}
    ${result}    Mongo Db Find    credit_mng_db    purchases    ${filter_query}
    @{records}    Get From Dictionary    ${result}    body
    ${result_object}    Set Variable    ${records}[0]
    Should Be Equal As Strings    ${result_object['billingCycleAssigned']}    True

Set LMS_AUTOMATION_BUSINESS_ID To
    [Arguments]    ${BUSINESS_ID}
    Set Test Variable    ${LMS_AUTOMATION_BUSINESS_ID}    ${BUSINESS_ID}

A Full Purchase
    [Documentation]    Performs a full online credit purchase.
    [Arguments]
    ...    ${type}
    ...    ${amount}
    ...    ${cell_number}=${cell_number}
    ...    ${credit_id}=${credit_ids}[0]
    ...    ${user_id}=${user_id}
    ...    ${has_cash_pay}=${False}
    ...    ${coupon_code}=${EMPTY}

    ${PAY_CHANNEL}    Set Variable    ${PAYMENT_CHANNEL}
    @{REPAYMENT_OPTIONS}    Create List    ${LMS_REPAYMENT_OPTION.ONEPAY}    ${LMS_REPAYMENT_OPTION.XPAY}

    POST Credit Gateway Activate
    ...    ${MICROSERVICE_SIDE}
    ...    ${LMS_AUTOMATION_BUSINESS_ID}
    ...    ${PAY_CHANNEL}
    ...    ${PAYMENT_GATEWAY}
    ...    0
    ...    ${DASHBOARD_USERNAME}
    ...    ${REPAYMENT_OPTIONS}

    ${ticket}    ${tracking_code}    Perform A Complete Online Credit Purchase
    ...    user_id=${user_id}
    ...    credit_id=${credit_id}
    ...    amount=${amount}
    ...    type=${type}
    ...    channel=${PAY_CHANNEL}
    ...    cell_number=${cell_number}
    ...    business_id=${LMS_AUTOMATION_BUSINESS_ID}
    ...    has_cash_pay=${has_cash_pay}
    ...    coupon_code=${coupon_code}

    Purchase Status Must Be CONFIRMED Or DELIVERED    tracking_code=${tracking_code}
    Wait Until Keyword Succeeds
    ...    3 minute
    ...    5 s
    ...    Purchase Should Be Assigned To The Billing Cycle
    ...    tracking_code=${tracking_code}

    Set Test Variable    ${tracking_code}

Assert Refund Data In Credit Management, Credit Merchant Management And Report Management Is Correct
    [Documentation]    Backward-compatible assertion wrapper used in old tests.
    ...                It simply delegates to `Check Refund Type` so that
    ...                rounding and cross-collection checks are all applied.
    [Arguments]
    ...    ${purchase_tracking_code}=${tracking_code}
    ...    ${debt_paid}=False
    ...    ${billing_cycle_removed}=False
    ...    ${billing_cycle_closed}=False
    ...    ${partial_refund_flag}=${False}
    ...    ${has_cash_pay}=${False}

    Check Refund Type
    ...    purchase_tracking_code=${purchase_tracking_code}
    ...    debt_paid=${debt_paid}
    ...    billing_cycle_removed=${billing_cycle_removed}
    ...    billing_cycle_closed=${billing_cycle_closed}
    ...    partial_refund_flag=${partial_refund_flag}
    ...    has_cash_pay=${has_cash_pay}

Perform A Complete Purchase
    [Documentation]    Performs a complete offline purchase (for API channel scenarios).
    [Arguments]
    ...    ${user_id}=${user_id}
    ...    ${cell_number}=${cell_number}
    ...    ${credit_id}=${credit_ids}[0]
    ...    ${amount}=${MIN_AMOUNT}
    ...    ${business_id}=${LMS_AUTOMATION_BUSINESS_ID}
    ...    ${channel}=${PAYMENT_CHANNEL}

    POST Credit Gateway Activate
    ...    ${MICROSERVICE_SIDE}
    ...    ${LMS_AUTOMATION_BUSINESS_ID}
    ...    ${PAYMENT_CHANNEL}
    ...    ${PAYMENT_GATEWAY}
    ...    0
    ...    ${DASHBOARD_USERNAME}
    ...    ${REPAYMENT_OPTIONS}

    ${tracking_code}    Perform A Complete Offline Purchase
    ...    ${user_id}
    ...    ${credit_id}
    ...    ${amount}
    ...    ${business_id}
    ...    ${channel}

    Set Test Variable    ${tracking_code}
    Wait Until Keyword Succeeds
    ...    1 minute
    ...    5 s
    ...    Purchase Should Be Assigned To The Billing Cycle
    ...    tracking_code=${tracking_code}

Performed An Online Purchase
    [Documentation]    Performs an online purchase and stores purchase status, ticket and tracking code.
    [Arguments]
    ...    ${credit_id}=${credit_ids}[0]
    ...    ${user_id}=${user_id}
    ...    ${cell_number}=${cell_number}
    ...    ${business_id}=${LMS_AUTOMATION_BUSINESS_ID}
    ...    ${default_channel}=${PAYMENT_CHANNEL}
    ...    ${amount}=${MIN_AMOUNT}
    ...    ${has_cash_pay}=${False}

    ${PAY_CHANNEL}    Set Variable    ${PAYMENT_CHANNEL}
    @{REPAYMENT_OPTIONS}    Create List    ${LMS_REPAYMENT_OPTION.ONEPAY}    ${LMS_REPAYMENT_OPTION.XPAY}

    POST Credit Gateway Activate
    ...    ${MICROSERVICE_SIDE}
    ...    ${LMS_AUTOMATION_BUSINESS_ID}
    ...    ${PAY_CHANNEL}
    ...    ${PAYMENT_GATEWAY}
    ...    0
    ...    ${DASHBOARD_USERNAME}
    ...    ${REPAYMENT_OPTIONS}

    ${filter_query}    Create Dictionary    creditId=${credit_id}
    ${result}          Mongo Db Find    switch_credit_db    activations    ${filter_query}
    ${body}            Set Variable    ${result}[body][0]
    ${s_type}          Set Variable    ${body['serviceType']}
    ${type}            Set Variable    13
    IF    '${s_type}'=='CREDIT'
        ${type}    Set Variable    5
    END
    IF    '${s_type}'=='INSTALLMENT_SALE'
        ${type}    Set Variable    26
    END

    ${result}    Run Keyword And Ignore Error    Perform A Complete Online Credit Purchase
    ...    type=${type}
    ...    cell_number=${cell_number}
    ...    user_id=${user_id}
    ...    credit_id=${credit_id}
    ...    amount=${amount}
    ...    business_id=${business_id}
    ...    channel=${default_channel}
    ...    has_cash_pay=${has_cash_pay}

    ${ticket}         Set Variable    ${EMPTY}
    ${tracking_code}  Set Variable    ${EMPTY}
    ${purchase_status}    Set Variable    ${result}[0]

    IF    '${purchase_status}' == 'PASS'
        ${output}        Set Variable    ${result}[1]
        ${ticket}        Set Variable    ${output}[0]
        ${tracking_code}    Set Variable    ${output}[1]
    END

    Set Test Variable    ${ticket}
    Set Test Variable    ${tracking_code}
    Set Test Variable    ${purchase_status}
    Set Test Variable    ${type}


# ===================== REFUND – CORE HELPERS =====================

Get All Refunds For Purchase
    [Documentation]    Returns all refund documents for a given purchase tracking code (any status).
    [Arguments]    ${purchase_tracking_code}=${tracking_code}
    ${filter_query}    Create Dictionary    purchaseTrackingCode=${purchase_tracking_code}
    ${result}          Mongo Db Find    credit_mng_db    refunds    ${filter_query}
    ${body}           Set Variable    ${result['body']}
    ${length}         Get Length      ${body}
    IF    ${length} == 0
        Fail    msg=Expected at least one refund document but found 0.
    END
    @{refunds}    Create List
    FOR    ${i}    IN RANGE    ${0}    ${length}
        ${doc}    Set Variable    ${body}[${i}]
        Append To List    ${refunds}    ${doc}
    END
    RETURN    @{refunds}

Get All Successful Refunds For Purchase
    [Documentation]    Returns only successful refund documents (status == SUCCESS) for a purchase.
    [Arguments]    ${purchase_tracking_code}=${tracking_code}
    @{all}        Get All Refunds For Purchase    ${purchase_tracking_code}
    @{success}    Create List
    @{pending}    Create List
    FOR    ${doc}    IN    @{all}
        ${status}    Set Variable    ${doc['status']}
        IF    '${status}'=='SUCCESS'
            Append To List    ${success}    ${doc}
        ELSE IF    '${status}'=='PENDING'
            Append To List    ${pending}    ${doc}
        END
    END
    ${success_length}    Get Length    ${success}
    ${pending_length}    Get Length    ${pending}
    IF    ${success_length} == 0
        Fail    msg=Expected at least one successful refund document but found none.
    ELSE IF    ${pending_length} > 0
        Fail    There are ${pending_length} PENDING refund documents in addition to ${success_length} SUCCESS refunds.
    END
    RETURN    @{success}

Sum Refund Amounts
    [Documentation]    Sums the amounts of a list of refund documents (after value normalization).
    [Arguments]    @{refunds}
    ${total}    Set Variable    0
    FOR    ${doc}    IN    @{refunds}
        ${raw_amount}    Set Variable    ${doc['amount']}
        ${amount}        Value Handler    input_value=${raw_amount}
        ${total}         Evaluate    ${total} + ${amount}
    END
    RETURN    ${total}

Refunds Should Cover Purchase Amount With Proper Rounding
    [Documentation]    Verifies that total refund amount matches purchase amount within a max difference (rounding).
    [Arguments]
    ...    ${purchase_tracking_code}=${tracking_code}
    ...    ${max_diff}=1

    ${purchase_filter}    Create Dictionary    trackingCode=${purchase_tracking_code}
    ${purchase_result}    Mongo Db Find    credit_mng_db    purchases    ${purchase_filter}
    ${purchase_data}      Set Variable    ${purchase_result['body'][0]}
    ${purchase_raw_amount}    Set Variable    ${purchase_data['amount']}
    ${purchase_amount}       Value Handler    input_value=${purchase_raw_amount}

    @{refunds}        Get All Successful Refunds For Purchase    ${purchase_tracking_code}
    ${refund_total}   Sum Refund Amounts    @{refunds}

    ${diff}    Evaluate    abs(${purchase_amount} - ${refund_total})
    Should Be True
    ...    ${diff} < ${max_diff}
    ...    msg=Refund total ${refund_total} is not within ${max_diff} IRR of purchase amount ${purchase_amount}. Difference is ${diff}.


Get Main Refund For Assertions
    [Documentation]    Returns the main refund document used for deep assertions (prefer CREDIT type).
    [Arguments]
    ...    ${preferred_type}=CREDIT
    ...    @{refunds}

    FOR    ${doc}    IN    @{refunds}
        ${t}    Set Variable    ${doc['type']}
        IF    '${t}'=='${preferred_type}'
            RETURN    ${doc}
        END
    END
    RETURN    ${refunds}[0]


# ===================== REFUND – API CALL & DB STATUS =====================

Make A Refund
    [Documentation]    Calls refund API for a given purchase tracking code and amount.
    [Arguments]
    ...    ${amount}
    ...    ${type}
    ...    ${sale_tracking_code}

    ${provider_id}    Generate Random String    15    123456789
    ${refund_result}    POST Credit Purchases Refunds
    ...    api_call_side=${MICROSERVICE_SIDE}
    ...    sale_tracking_code=${sale_tracking_code}
    ...    amount=${amount}
    ...    type=${type}
    ...    provider_id=${provider_id}
    ...    description=LMS AUTOMATED REFUND
    ...    user_id=${LMS_AUTOMATION_BUSINESS_ID}

    ${refund_result_status_code}    Set Variable    ${refund_result['status_code']}
    Set Test Variable    ${refund_result_status_code}
    Set Test Variable    ${refund_result}

    Refund API Should Be Successful    ${refund_result_status_code}

Refund API Should Be Successful
    [Documentation]    Verifies that refund API returned HTTP 200.
    [Arguments]    ${status_code}=${refund_result_status_code}
    Should Be Equal As Numbers
    ...    ${status_code}
    ...    200
    ...    msg=Expected refund API status code to be 200 but got ${status_code}.

Refund API Should Not Be Successful
    [Documentation]    Verifies that refund API returned HTTP 422.
    [Arguments]    ${status_code}=${refund_result_status_code}
    Should Be Equal As Numbers
    ...    ${status_code}
    ...    422
    ...    msg=Expected refund API status code to be 422 but got ${status_code}.

The Error Code Should Be
    [Documentation]    Verifies refund error payload contains the expected status and title.
    # [Arguments]    ${status}
    [Arguments]    ${status}    ${title}
    Should Be Equal As Strings    ${title}    ${refund_result['body']['result']['title']}
    Should Be Equal As Numbers    ${status}    ${refund_result['body']['result']['status']}

Refund Should Be Successful
    [Documentation]    Verifies that at least one successful refund document exists in DB.
    [Arguments]    ${sale_tracking_code}=${tracking_code}
    @{refunds}    Get All Successful Refunds For Purchase    ${sale_tracking_code}
    ${length}     Get Length    ${refunds}
    Should Be True
    ...    ${length} > 0
    ...    msg=Expected at least one successful refund document but found none.

Perform A Partial Refund
    [Documentation]    Retries refund API and DB status check until success.
    [Arguments]
    ...    ${amount}
    ...    ${type}
    ...    ${sale_tracking_code}=${tracking_code}
    Set Test Variable    ${partial_refund_flag}    ${True}
    Wait Until Keyword Succeeds
    ...    50x
    ...    5 s
    ...    Make A Refund
    ...    sale_tracking_code=${sale_tracking_code}
    ...    amount=${amount}
    ...    type=${type}

    Wait Until Keyword Succeeds
    ...    50x
    ...    5 s
    ...    Refund Should Be Successful
    ...    sale_tracking_code=${sale_tracking_code}

Perform A Partial Refund When Remaining Amount Is More Than Refund Min Remaining Amount
    [Documentation]    Performs a single refund call for invalid amount scenario (no retry on DB).
    [Arguments]
    ...    ${amount}
    ...    ${type}
    ...    ${sale_tracking_code}=${tracking_code}

    ${provider_id}    Generate Random String    15    123456789
    ${refund_result}    POST Credit Purchases Refunds
    ...    api_call_side=${MICROSERVICE_SIDE}
    ...    sale_tracking_code=${sale_tracking_code}
    ...    amount=${amount}
    ...    type=${type}
    ...    provider_id=${provider_id}
    ...    description=LMS AUTOMATED REFUND
    ...    user_id=${LMS_AUTOMATION_BUSINESS_ID}

    ${refund_result_status_code}    Set Variable    ${refund_result['status_code']}
    Set Test Variable    ${refund_result_status_code}
    Set Test Variable    ${refund_result}

Perform A Full Refund
    [Documentation]    Refunds the full purchase amount (with retry on API and DB).
    [Arguments]
    ...    ${type}
    ...    ${sale_tracking_code}=${tracking_code}

    ${filter_query}    Create Dictionary    trackingCode=${sale_tracking_code}
    ${result}          Mongo Db Find    credit_mng_db    purchases    ${filter_query}
    ${raw_amount}      Set Variable    ${result['body'][0]['amount']}
    ${amount}          Value Handler    input_value=${raw_amount}

    Wait Until Keyword Succeeds
    ...    2 minute
    ...    5 s
    ...    Make A Refund
    ...    sale_tracking_code=${sale_tracking_code}
    ...    amount=${amount}
    ...    type=${type}

    Wait Until Keyword Succeeds
    ...    2 minute
    ...    5 s
    ...    Refund Should Be Successful
    ...    sale_tracking_code=${sale_tracking_code}


# ===================== REFUND TYPES (CREDIT / PREPAYMENT / CREDIT_CASH) =====================

Refund Types Should At Least Include
    [Documentation]    Ensures that at least one refund document has the expected type.
    [Arguments]
    ...    ${expected_type}
    ...    @{refunds}

    @{types}    Create List
    FOR    ${doc}    IN    @{refunds}
        ${t}    Set Variable    ${doc['type']}
        Append To List    ${types}    ${t}
    END

    List Should Contain Value
    ...    ${types}
    ...    ${expected_type}
    ...    msg=Expected refund types to include ${expected_type} but it was not found.

Refund Type Must Include Credit
    [Documentation]    Wrapper used in tests. Ensures there is at least one CREDIT refund.
    [Arguments]    ${purchase_tracking_code}=${tracking_code}    ${n_included}=1
    @{refunds}    Get All Successful Refunds For Purchase    ${purchase_tracking_code}
    Refund Types Should At Least Include    CREDIT    @{refunds}

Refund Type Must Include Prepayment
    [Documentation]    Wrapper used in tests. Ensures there is at least one PREPAYMENT refund.
    [Arguments]    ${purchase_tracking_code}=${tracking_code}    ${n_included}=1
    @{refunds}    Get All Successful Refunds For Purchase    ${purchase_tracking_code}
    Refund Types Should At Least Include    PREPAYMENT    @{refunds}

Refund Type Must Include Coupon
    [Documentation]    Wrapper used in tests. Ensures there is at least one PREPAYMENT refund.
    [Arguments]    ${purchase_tracking_code}=${tracking_code}    ${n_included}=1
    @{refunds}    Get All Refunds For Purchase    ${purchase_tracking_code}
    Refund Types Should At Least Include    COUPON    @{refunds}

Refund Type Must Include Credit Cash
    [Documentation]    Wrapper used in tests. Ensures there is at least one CREDIT_CASH refund.
    [Arguments]    ${purchase_tracking_code}=${tracking_code}    ${n_included}=1
    @{refunds}    Get All Successful Refunds For Purchase    ${purchase_tracking_code}
    Refund Types Should At Least Include    CREDIT_CASH    @{refunds}


# ===================== REFUND PAY GATEWAYS (BPG / CPG / ISPG / WALLET / ...) =====================

Refund Pay Gateways Should At Least Include
    [Documentation]    Ensures that at least one refund document has the expected pay gateway.
    [Arguments]
    ...    ${expected_gateway}
    ...    @{refunds}

    @{gateways}    Create List
    FOR    ${doc}    IN    @{refunds}
        ${g}    Set Variable    ${doc['payGateway']}
        Append To List    ${gateways}    ${g}
    END

    List Should Contain Value
    ...    ${gateways}
    ...    ${expected_gateway}
    ...    msg=Expected refund pay gateways to include ${expected_gateway} but it was not found.

Refund Pay Gateway Must Include BPG
    [Documentation]    Wrapper used in tests. Ensures at least one refund via BPG.
    [Arguments]    ${purchase_tracking_code}=${tracking_code}    ${n_included}=1
    @{refunds}    Get All Successful Refunds For Purchase    ${purchase_tracking_code}
    Refund Pay Gateways Should At Least Include    BPG    @{refunds}

Refund Pay Gateway Must Include CPG
    [Documentation]    Wrapper used in tests. Ensures at least one refund via CPG.
    [Arguments]    ${purchase_tracking_code}=${tracking_code}    ${n_included}=1
    @{refunds}    Get All Successful Refunds For Purchase    ${purchase_tracking_code}
    Refund Pay Gateways Should At Least Include    CPG    @{refunds}

Refund Pay Gateway Must Include ISPG
    [Documentation]    Wrapper used in tests. Ensures at least one refund via ISPG.
    [Arguments]    ${purchase_tracking_code}=${tracking_code}    ${n_included}=1
    @{refunds}    Get All Successful Refunds For Purchase    ${purchase_tracking_code}
    Refund Pay Gateways Should At Least Include    ISPG    @{refunds}

Refund Pay Gateway Must Include CAPG
    [Documentation]    Wrapper used in tests. Ensures at least one refund via CAPG.
    [Arguments]    ${purchase_tracking_code}=${tracking_code}    ${n_included}=1
    @{refunds}    Get All Successful Refunds For Purchase    ${purchase_tracking_code}
    Refund Pay Gateways Should At Least Include    CAPG    @{refunds}

Refund Pay Gateway Must Include WALLET
    [Documentation]    Wrapper used in tests. Ensures at least one refund via WALLET.
    [Arguments]    ${purchase_tracking_code}=${tracking_code}    ${n_included}=1
    @{refunds}    Get All Successful Refunds For Purchase    ${purchase_tracking_code}
    Refund Pay Gateways Should At Least Include    WALLET    @{refunds}


# ===================== REFUND SETTLEMENT METHODS =====================

Count Settlement Methods For Refunds
    [Documentation]    Counts how many settlement transactions use the given method for a list of refunds.
    [Arguments]
    ...    ${expected_method}
    ...    @{refunds}

    ${n_found}    Set Variable    0
    FOR    ${doc}    IN    @{refunds}
        ${refund_tracking_code}    Set Variable    ${doc['refundTrackingCode']}
        ${filter_query}    Create Dictionary    trackingCode=${refund_tracking_code}
        ${result}          Mongo Db Find
        ...    credit_merchant_mng_db
        ...    refund_settlement
        ...    ${filter_query}
        ${body}            Set Variable    ${result['body'][0]}
        ${transaction_list}    Set Variable    ${body['transactions']}
        ${length_transactions}    Get Length    ${transaction_list}
        FOR    ${tx}    IN    @{transaction_list}
            ${method}    Set Variable    ${tx['method']}
            IF    '${method}'=='${expected_method}'
                ${n_found}    Evaluate    ${n_found} + 1
            END
        END
    END
    RETURN    ${n_found}

Refund Settlement Method Must Include BNPL 1PAY Method
    [Documentation]    Ensures that settlement includes BNPL1PAY method at least n_included times.
    [Arguments]    ${purchase_tracking_code}=${tracking_code}    ${n_included}=1
    @{refunds}    Get All Successful Refunds For Purchase    ${purchase_tracking_code}
    ${n_found}    Count Settlement Methods For Refunds    ${LMS_SETTLEMENT_METHODS.BNPL1PAY}    @{refunds}
    Should Be True
    ...    ${n_found} >= ${n_included}
    ...    msg=Expected at least ${n_included} BNPL1PAY settlement methods but got ${n_found}.

Refund Settlement Method Must Include BNPL XPAY Method
    [Documentation]    Ensures that settlement includes BNPLXPAY method at least n_included times.
    [Arguments]    ${purchase_tracking_code}=${tracking_code}    ${n_included}=1
    @{refunds}    Get All Successful Refunds For Purchase    ${purchase_tracking_code}
    ${n_found}    Count Settlement Methods For Refunds    ${LMS_SETTLEMENT_METHODS.BNPLXPAY}    @{refunds}
    Should Be True
    ...    ${n_found} >= ${n_included}
    ...    msg=Expected at least ${n_included} BNPLXPAY settlement methods but got ${n_found}.

Refund Settlement Method Must Include CCREDIT Method
    [Documentation]    Ensures that settlement includes CCREDIT method at least n_included times.
    [Arguments]    ${purchase_tracking_code}=${tracking_code}    ${n_included}=1
    @{refunds}    Get All Successful Refunds For Purchase    ${purchase_tracking_code}
    ${n_found}    Count Settlement Methods For Refunds    ${LMS_SETTLEMENT_METHODS.CCREDIT}    @{refunds}
    Should Be True
    ...    ${n_found} >= ${n_included}
    ...    msg=Expected at least ${n_included} CCREDIT settlement methods but got ${n_found}.

Refund Settlement Method Must Include CREDITCHECK Method
    [Documentation]    Ensures that settlement includes CREDITCHECK method at least n_included times.
    [Arguments]    ${purchase_tracking_code}=${tracking_code}    ${n_included}=1
    @{refunds}    Get All Successful Refunds For Purchase    ${purchase_tracking_code}
    ${n_found}    Count Settlement Methods For Refunds    ${LMS_SETTLEMENT_METHODS.CREDITCHECK}    @{refunds}
    Should Be True
    ...    ${n_found} >= ${n_included}
    ...    msg=Expected at least ${n_included} CREDITCHECK settlement methods but got ${n_found}.

Refund Settlement Method Must Include CREDITCARD Method
    [Documentation]    Ensures that settlement includes CREDITCARD method at least n_included times.
    [Arguments]    ${purchase_tracking_code}=${tracking_code}    ${n_included}=1
    @{refunds}    Get All Successful Refunds For Purchase    ${purchase_tracking_code}
    ${n_found}    Count Settlement Methods For Refunds    ${LMS_SETTLEMENT_METHODS.CREDITCARD}    @{refunds}
    Should Be True
    ...    ${n_found} >= ${n_included}
    ...    msg=Expected at least ${n_included} CREDITCARD settlement methods but got ${n_found}.

Refund Settlement Method Must Include CASH Method
    [Documentation]    Ensures that settlement includes CASH method at least n_included times.
    [Arguments]    ${purchase_tracking_code}=${tracking_code}    ${n_included}=1
    @{refunds}    Get All Successful Refunds For Purchase    ${purchase_tracking_code}
    ${n_found}    Count Settlement Methods For Refunds    ${LMS_SETTLEMENT_METHODS.CASH}    @{refunds}
    Should Be True
    ...    ${n_found} >= ${n_included}
    ...    msg=Expected at least ${n_included} CASH settlement methods but got ${n_found}.

Refund Settlement Method Must Include IPG Method
    [Documentation]    Ensures that settlement includes IPG method at least n_included times.
    [Arguments]    ${purchase_tracking_code}=${tracking_code}    ${n_included}=1
    @{refunds}    Get All Successful Refunds For Purchase    ${purchase_tracking_code}
    ${n_found}    Count Settlement Methods For Refunds    ${LMS_SETTLEMENT_METHODS.IPG}    @{refunds}
    Should Be True
    ...    ${n_found} >= ${n_included}
    ...    msg=Expected at least ${n_included} IPG settlement methods but got ${n_found}.

Check Refund Settlement Method Must Include BNPL 1PAY Method
    [Arguments]    ${n_include}=1
    Wait Until Keyword Succeeds
    ...    24x
    ...    5 s
    ...    Refund Settlement Method Must Include BNPL 1PAY Method
    ...    n_included=${n_include}

Check Refund Settlement Method Must Include BNPL XPAY Method
    [Arguments]    ${n_include}=1
    Wait Until Keyword Succeeds
    ...    24x
    ...    5 s
    ...    Refund Settlement Method Must Include BNPL XPAY Method
    ...    n_included=${n_include}

Check Refund Settlement Method Must Include CCREDIT Method
    [Arguments]    ${n_include}=1
    Wait Until Keyword Succeeds
    ...    24x
    ...    5 s
    ...    Refund Settlement Method Must Include CCREDIT Method
    ...    n_included=${n_include}

Check Refund Settlement Method Must Include CREDITCHECK Method
    [Arguments]    ${n_include}=1
    Wait Until Keyword Succeeds
    ...    24x
    ...    5 s
    ...    Refund Settlement Method Must Include CREDITCHECK Method
    ...    n_included=${n_include}

Check Refund Settlement Method Must Include CREDITCARD Method
    [Arguments]    ${n_include}=1
    Wait Until Keyword Succeeds
    ...    24x
    ...    5 s
    ...    Refund Settlement Method Must Include CREDITCARD Method
    ...    n_included=${n_include}

Check Refund Settlement Method Must Include CASH Method
    [Arguments]    ${n_include}=1
    Wait Until Keyword Succeeds
    ...    24x
    ...    5 s
    ...    Refund Settlement Method Must Include CASH Method
    ...    n_included=${n_include}

Check Refund Settlement Method Must Include IPG Method
    [Arguments]    ${n_include}=1
    Wait Until Keyword Succeeds
    ...    24x
    ...    5 s
    ...    Refund Settlement Method Must Include IPG Method
    ...    n_included=${n_include}


# ===================== EARLY SETTLEMENT =====================

Early Settlement Status Must Be Confirmed
    [Arguments]    ${early_settlement_ticket}=${early_settlement_ticket}
    ${filter_query}    Create Dictionary    ticket=${early_settlement_ticket}
    ${result}          Mongo Db Find    credit_mng_db    early_settlements    ${filter_query}
    @{records}         Get From Dictionary    ${result}    body
    ${result_object}   Set Variable    ${records}[0]
    Should Be Equal    ${result_object['status']}    CONFIRMED
    ${early_settlement_tracking_code}    Set Variable    ${result_object['trackingCode']}
    RETURN    ${early_settlement_tracking_code}

Pay The Early Settlement
    [Arguments]
    ...    ${credit_id}=${credit_ids}[0]
    ...    ${user_id}=${user_id}
    ...    ${cell_number}=${cell_number}
    ...    ${amount}=${amount}

    ${early_settlement_ticket}    Pay Early Settlement Via Wallet
    ...    user_id=${user_id}
    ...    credit_id=${credit_id}
    ...    cell_number=${cell_number}
    ...    amount=${amount}

    Set Test Variable    ${early_settlement_ticket}
    ${early_settlement_tracking_code}    Wait Until Keyword Succeeds
    ...    1 minute
    ...    5 s
    ...    Early Settlement Status Must Be Confirmed

    Set Test Variable    ${early_settlement_tracking_code}


# ===================== BILLING CYCLE / SCHEDULE CLOSE =====================

Close billing cycle
    [Arguments]    ${credit_id}
    Wait Until Keyword Succeeds
    ...    24x
    ...    5 s
    ...    Close billing cycles    ${credit_id}

Delete Billing Cycles
    [Documentation]    Deletes billing cycles for a given creditId.
    [Arguments]    ${credit_id}=${credit_ids}[0]

    ${filter_query}    Create Dictionary    creditId=${credit_id}
    ${result}          Mongo Db Find    credit_mng_db    billing_cycles    ${filter_query}
    @{records}         Get From Dictionary    ${result}    body
    ${length}          Get Length    ${records}
    IF    ${length} == 0
        Fail    msg=Expected billing cycles to be found, but found 0 records.
    END
    FOR    ${i}    IN RANGE    ${0}    ${length}
        ${record_i}    Set Variable    ${records}[${i}]
        ${filter_query}    Create Dictionary    trackingCode=${record_i['trackingCode']}
        Mongo Db Delete One
        ...    credit_mng_db
        ...    billing_cycles
        ...    ${filter_query}
    END

    ${result_after_delete}    Mongo Db Find    credit_mng_db    billing_cycles    ${filter_query}
    @{records}               Get From Dictionary    ${result_after_delete}    body
    ${length_after}          Get Length    ${records}
    IF    ${length_after} > 0
        Fail    msg=Expected billing cycles to be deleted, but found ${length_after} records.
    END

Call Schedule Close API
    [Documentation]    Calls schedule close API and stores response.
    [Arguments]    ${credit_id}=${credit_ids}[0]
    ${schedule_close_response}    Post Credit Accounts Schedule Close
    ...    ${MICROSERVICE_SIDE}
    ...    ${credit_ids}[0]
    ...    ${LMS_BLOCK_REASON.ORGANIZATION_REQUEST}
    ...    ${DASHBOARD_USERNAME}
    Set Test Variable    ${schedule_close_response}


# ===================== BLOCK ACCOUNT =====================

Block The Credit Account
    [Documentation]    Blocks the credit account via admin API.
    [Arguments]    ${cell_number}=${cell_number}    ${credit_id}=${credit_ids}[0]    ${user_id}=${user_id}

    ${response}    Post Admin Credit Accounts Block
    ...    api_call_side=${MICROSERVICE_SIDE}
    ...    credit_id=${credit_id}
    ...    user_id=${DASHBOARD_USERNAME}

    Should Be Equal As Integers
    ...    ${response['status_code']}
    ...    200
    ...    msg=Expected status code for Credit Accounts Block API to be 200 but got ${response['status_code']}.


# ===================== GATEWAY DISABLE =====================

The Gateway Is Disabled
    [Arguments]    ${repeat_count}=10
    FOR    ${i}    IN RANGE    ${0}    ${repeat_count}
        ${disable_response}    POST Credit Gateway Disable
        ...    ${MICROSERVICE_SIDE}
        ...    ${LMS_AUTOMATION_BUSINESS_ID}
        ...    ${PAYMENT_CHANNEL}
        ...    ${PAYMENT_GATEWAY}
    END

    Should Be Equal As Integers
    ...    ${disable_response['status_code']}
    ...    200
    ...    msg=Expected status code for Credit Gateway Disable API to be 200 but got ${disable_response['status_code']}.


# ===================== NOTIFICATION / SMS CHECKS =====================

Check SMS For Refund To Credit
    [Arguments]    ${recipient}=${cell_number}    ${initiator}=credit-mng
    Wait Until Keyword Succeeds
    ...    60s
    ...    5s
    ...    Check Notification DB For Refund To Credit
    ...    ${recipient}
    ...    ${initiator}

Check Notification DB For Refund To Credit
    [Arguments]    ${recipient}    ${initiator}

    ${filter_query}    Create Dictionary    recipient=${recipient}    initiator=${initiator}
    ${result}          Mongo Db Find    notification_db    sms_journals    ${filter_query}
    @{records}         Get From Dictionary    ${result}    body
    Should Not Be Empty    ${records}

    ${result_object}    Get From List    ${records}    0
    ${sms_body}         Get From Dictionary    ${result_object}    body

    Should Contain    ${sms_body}    بازگشت به اعتبار
    Should Contain    ${sms_body}    مرجوع شدن خرید

Check SMS For Refund To Cashoutable Wallet
    [Arguments]    ${recipient}=${cell_number}    ${initiator}=credit-mng

    ${filter_query}    Create Dictionary    recipient=${recipient}    initiator=${initiator}
    ${result}          Mongo Db Find    notification_db    sms_journals    ${filter_query}
    @{records}         Get From Dictionary    ${result}    body
    Should Not Be Empty    ${records}

    ${result_object}    Get From List    ${records}    0
    ${sms_body}         Get From Dictionary    ${result_object}    body

    Should Contain    ${sms_body}    واریز به کیف پول
    Should Contain    ${sms_body}    بابت مرجوع شدن خرید

Check SMS For Refund To Non-Cashoutable Wallet
    [Arguments]    ${recipient}=${cell_number}    ${initiator}=credit-mng

    ${filter_query}    Create Dictionary    recipient=${recipient}    initiator=${initiator}
    ${result}          Mongo Db Find    notification_db    sms_journals    ${filter_query}
    @{records}         Get From Dictionary    ${result}    body
    Should Not Be Empty    ${records}

    ${result_object}    Get From List    ${records}    0
    ${sms_body}         Get From Dictionary    ${result_object}    body

    Should Contain    ${sms_body}    واریز به کیف کمپانی‌پی (بابت پرداخت از اعتبار)
    Should Contain
    ...    ${sms_body}
    ...    مبلغ پرداخت شده از اعتبار، غیرقابل برداشت بوده و تنها در کمپانی قابل استفاده است


# ===================== HIGH LEVEL CONSISTENCY CHECKS =====================

Check Refund Type
    [Documentation]    High-level assertion wrapper used in tests. It checks:
    ...    1) At least one successful refund exists.
    ...    2) Amount coverage with rounding.
    ...    3) Cross-collection consistency for the main refund document.
    [Arguments]
    ...    ${purchase_tracking_code}=${tracking_code}
    ...    ${debt_paid}=False
    ...    ${billing_cycle_removed}=False
    ...    ${billing_cycle_closed}=False
    ...    ${partial_refund_flag}=${False}
    ...    ${has_cash_pay}=${False}

    IF    '${partial_refund_flag}' == '${False}'
        Wait Until Keyword Succeeds    5x    2s    Refunds Should Cover Purchase Amount With Proper Rounding    purchase_tracking_code=${purchase_tracking_code}
    END
    Check Refund Type In Credit Management, Credit Merchant Management And Report Management
    ...    ${purchase_tracking_code}
    ...    ${debt_paid}
    ...    ${billing_cycle_removed}
    ...    ${billing_cycle_closed}
    ...    ${has_cash_pay}

Check Refund Type In Credit Management, Credit Merchant Management And Report Management
    [Arguments]
    ...    ${purchase_tracking_code}
    ...    ${debt_paid}
    ...    ${billing_cycle_removed}
    ...    ${billing_cycle_closed}
    ...    ${has_cash_pay}

    ${filter_query}    Create Dictionary    trackingCode=${purchase_tracking_code}
    ${purchase_result}    Mongo Db Find    credit_mng_db    purchases    ${filter_query}
    ${purchase_data}      Set Variable    ${purchase_result['body'][0]}

    @{refunds}            Get All Successful Refunds For Purchase    ${purchase_tracking_code}
    ${refund_data}        Get Main Refund For Assertions    CREDIT    @{refunds}

    ${filter_query}    Create Dictionary    purchaseTrackingCode=${purchase_tracking_code}
    ${settlement_result}    Mongo Db Find
    ...    credit_merchant_mng_db
    ...    refund_settlement
    ...    ${filter_query}
    ${settlement_data}    Set Variable    ${settlement_result['body'][0]}

    ${filter_query}    Create Dictionary    trackingCode=${refund_data['refundTrackingCode']}
    ${activity_result}    Mongo Db Find
    ...    report_mng_db
    ...    activities
    ...    ${filter_query}
    ${activity_data}    Set Variable    ${activity_result['body'][0]}

    ${dashboard_result}    Mongo Db Find
    ...    report_mng_db
    ...    dashboard_transactions
    ...    ${filter_query}
    ${dashboard_data}    Set Variable    ${dashboard_result['body'][0]}

    ${user_result}    Mongo Db Find
    ...    report_mng_db
    ...    user_transactions
    ...    ${filter_query}
    ${user_data}    Set Variable    ${user_result['body'][0]}

    # Business and debtor / creditor consistency
    Should Be Equal
    ...    ${purchase_data['business']['userId']}
    ...    ${refund_data['business']['userId']}
    ...    msg=Business userId mismatch between purchase and refund.

    Should Be Equal
    ...    ${purchase_data['debtor']['userId']}
    ...    ${refund_data['creditor']['userId']}
    ...    msg=User ID mismatch between purchase debtor and refund creditor.

    Should Be Equal
    ...    ${purchase_data['debtor']['cellNumber']}
    ...    ${refund_data['creditor']['cellNumber']}
    ...    msg=Cell number mismatch between purchase debtor and refund creditor.

    # Status and result
    Should Be Equal    ${refund_data['status']}    SUCCESS    msg=Refund status is not SUCCESS.
    Should Be Equal    ${refund_data['result']}    SUCCESS    msg=Refund result is not SUCCESS.

    # Settlement transaction amount
    ${transaction_list}      Set Variable    ${settlement_data['transactions']}
    ${length_transaction}    Get Length    ${transaction_list}
    Should Be Equal As Numbers    ${length_transaction}    1    msg=Expected exactly one settlement transaction.

    ${transaction}    Set Variable    ${transaction_list}[0]
    Should Be Equal    ${transaction['amount']}    ${refund_data['amount']}    msg=Transaction amount mismatch.

    # Activities consistency
    Should Be Equal
    ...    ${activity_data['trackingCode']}
    ...    ${refund_data['refundTrackingCode']}
    ...    msg=Tracking code mismatch in activities.

    Should Be Equal    ${activity_data['amount']}    ${refund_data['amount']}    msg=Amount mismatch in activities.

    Should Be Equal
    ...    ${activity_data['metaData']['purchaseTrackingCode']}
    ...    ${purchase_tracking_code}
    ...    msg=Purchase tracking code mismatch in activities.

    Should Be Equal
    ...    ${activity_data['metaData']['rrn']}
    ...    ${refund_data['rrn']}
    ...    msg=RRN mismatch in activities.

    # Dashboard transactions consistency
    Should Be Equal
    ...    ${dashboard_data['trackingCode']}
    ...    ${refund_data['refundTrackingCode']}
    ...    msg=Tracking code mismatch in dashboard transactions.

    Should Be Equal
    ...    ${dashboard_data['amount']}
    ...    ${refund_data['amount']}
    ...    msg=Amount mismatch in dashboard transactions.

    Should Be Equal
    ...    ${dashboard_data['rrn']}
    ...    ${refund_data['rrn']}
    ...    msg=RRN mismatch in dashboard transactions.

    List Should Contain Value
    ...    ${dashboard_data['owners']}
    ...    ${refund_data['business']['userId']}
    ...    msg=Owner mismatch in dashboard transactions.

    # User transactions consistency
    Should Be Equal
    ...    ${user_data['trackingCode']}
    ...    ${refund_data['refundTrackingCode']}
    ...    msg=Tracking code mismatch in user transactions.

    Should Be Equal
    ...    ${user_data['amount']}
    ...    ${refund_data['amount']}
    ...    msg=Amount mismatch in user transactions.

    Should Be Equal
    ...    ${user_data['destination']['userId']}
    ...    ${refund_data['creditor']['userId']}
    ...    msg=Destination user mismatch in user transactions.

    Should Be Equal
    ...    ${user_data['source']['userId']}
    ...    ${refund_data['business']['userId']}
    ...    msg=Source user mismatch in user transactions.

    Should Be Equal
    ...    ${user_data['owners'][0]}
    ...    ${refund_data['creditor']['userId']}
    ...    msg=Owner mismatch in user transactions.

    Should Be Equal
    ...    ${user_data['viewDetails'][0]['userId']}
    ...    ${refund_data['creditor']['userId']}
    ...    msg=View details user mismatch in user transactions.
