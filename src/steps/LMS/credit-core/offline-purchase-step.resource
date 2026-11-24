*** Settings ***
Library     library/faker_utils.py    WITH NAME    FakerLibrary
Library     RequestsLibrary
Library     Collections
Library     String
Library     DateTime
Resource    services/db/mongo-db-service.resource
Resource    services/backend/import-allocation.resource
Resource    services/backend/user-wallet-initializer-service.resource
Resource    apis/lms/credit-core/post-credit-gateway-activate.resource
Resource    apis/lms/credit-core/post-credit-gateways-disable.resource
Resource    apis/lms/credit-core/post-admin-credit-accounts-block.resource
Resource    services/backend/value-handler.resource
Resource    services/backend/LMS/credit-core/close-account.resource
Resource    apis/lms/credit-core/post-credit-accounts-schedule-close.resource


*** Keywords ***
# Merchant Initialization
Initialize Merchant
    [Documentation]    This is a ```Test Setup``` that generated a merchant that can be used to perform a purchases on and validate the API
    [Arguments]    ${BUSINESS_ID_FOR_CHARGE_TEST_WALLETS}=${BUSINESS_ID_FOR_CHARGE_TEST_WALLETS}

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

    @{role_list}    Create List    merchant-business

    @{wallet_setup_list_1}    Create List
    ...    ${spend_wallet_for_business_1}
    ...    ${credit_spend_wallet_for_business_1}
    ...    ${debit_settlement_wallet_for_business_1}
    ...    ${credit_settlement_wallet_for_business_1}

    ${INIT_BUSINESS_OBJ_1}    Get Initialized Business With Charged Wallet Based On Configuration
    ...    ${wallet_setup_list_1}

    ${LMS_AUTOMATION_BUSINESS_ID}    Set Variable    ${INIT_BUSINESS_OBJ_1['business_id']}
    Set Test Variable    ${LMS_AUTOMATION_BUSINESS_ID}

Reproduce Amount
    [Documentation]    Reproduces the businessId wallets. This is a ```Test Teardown```
    [Arguments]    ${additional_user_lists}=${ALLOCATION_USER_LIST}

    Collect All Amount For Tear Down    additional_user_lists=${additional_user_lists}

Allocate No Fee BNPL Account(1pay)
    [Documentation]    Allocates a no fee bnpl account on a random user
    ${user_object}    Activate Account
    ...    types=${{['${LMS_Account_Type_1PAY}']}}
    ...    fee_types=${{['${LMS_ZERO_FEE}']}}
    ...    default_amount=${DEFAULT_ALLOCATION_AMOUNT}

    ${cell_number}    Set Variable    ${user_object['user_cell_number']}
    ${user_id}    Set Variable    ${user_object['user_id']}
    ${credit_ids}    Set Variable    ${user_object['user_credit_ids']}
    &{user_data}    Create Dictionary    user_id=${user_id}    type=${CUSTOMER_TYPE}
    ${ALLOCATION_USER_LIST}    Create List    ${user_data}

    Set Test Variable    ${cell_number}
    Set Test Variable    ${user_id}
    Set Test Variable    ${credit_ids}
    Set Test Variable    ${user_object}
    Set Test Variable    ${ALLOCATION_USER_LIST}

Allocate No Fee BNPL Account(xpay)
    [Documentation]    Allocates a no fee bnpl account on a random user
    ${user_object}    Activate Account
    ...    types=${{['${LMS_Account_Type_XPAY}']}}
    ...    fee_types=${{['${LMS_ZERO_FEE}']}}
    ...    default_amount=${DEFAULT_ALLOCATION_AMOUNT}

    ${cell_number}    Set Variable    ${user_object['user_cell_number']}
    ${user_id}    Set Variable    ${user_object['user_id']}
    ${credit_ids}    Set Variable    ${user_object['user_credit_ids']}
    &{user_data}    Create Dictionary    user_id=${user_id}    type=${CUSTOMER_TYPE}
    ${ALLOCATION_USER_LIST}    Create List    ${user_data}

    Set Test Variable    ${cell_number}
    Set Test Variable    ${user_id}
    Set Test Variable    ${credit_ids}
    Set Test Variable    ${user_object}
    Set Test Variable    ${ALLOCATION_USER_LIST}

Allocate Fee On Purchase XPay BNPL Account
    [Documentation]    Allocates a fee on purchase bnpl account on a random user
    ${user_object}    Activate Account
    ...    types=${{['${LMS_Account_Type_XPAY}']}}
    ...    fee_types=${{['${LMS_FEE_ON_PURCHASE}']}}
    ...    default_amount=${DEFAULT_ALLOCATION_AMOUNT}

    ${cell_number}    Set Variable    ${user_object['user_cell_number']}
    ${user_id}    Set Variable    ${user_object['user_id']}
    ${credit_ids}    Set Variable    ${user_object['user_credit_ids']}
    &{user_data}    Create Dictionary    user_id=${user_id}    type=${CUSTOMER_TYPE}
    ${ALLOCATION_USER_LIST}    Create List    ${user_data}

    Set Test Variable    ${cell_number}
    Set Test Variable    ${user_id}
    Set Test Variable    ${credit_ids}
    Set Test Variable    ${user_object}
    Set Test Variable    ${ALLOCATION_USER_LIST}

Allocate No Fee CCredit Account
    [Documentation]    Allocates a no fee ccredit account on a random user
    ${user_object}    Activate Account
    ...    types=${{['${LMS_Account_Type_CREDIT}']}}
    ...    fee_types=${{['${LMS_ZERO_FEE}']}}
    ...    default_amount=${DEFAULT_ALLOCATION_AMOUNT}

    ${cell_number}    Set Variable    ${user_object['user_cell_number']}
    ${user_id}    Set Variable    ${user_object['user_id']}
    ${credit_ids}    Set Variable    ${user_object['user_credit_ids']}
    &{user_data}    Create Dictionary    user_id=${user_id}    type=${CUSTOMER_TYPE}
    ${ALLOCATION_USER_LIST}    Create List    ${user_data}

    Set Test Variable    ${cell_number}
    Set Test Variable    ${user_id}
    Set Test Variable    ${credit_ids}
    Set Test Variable    ${user_object}
    Set Test Variable    ${ALLOCATION_USER_LIST}

Allocate Fee On Purchase CCREDIT Account
    [Documentation]    Allocates a fee on purchase ccredit account on a random user
    ${user_object}    Activate Account
    ...    types=${{['${LMS_Account_Type_CREDIT}']}}
    ...    fee_types=${{['${LMS_FEE_ON_PURCHASE}']}}
    ...    default_amount=${DEFAULT_ALLOCATION_AMOUNT}

    ${cell_number}    Set Variable    ${user_object['user_cell_number']}
    ${user_id}    Set Variable    ${user_object['user_id']}
    ${credit_ids}    Set Variable    ${user_object['user_credit_ids']}
    &{user_data}    Create Dictionary    user_id=${user_id}    type=${CUSTOMER_TYPE}
    ${ALLOCATION_USER_LIST}    Create List    ${user_data}

    Set Test Variable    ${cell_number}
    Set Test Variable    ${user_id}
    Set Test Variable    ${credit_ids}
    Set Test Variable    ${user_object}
    Set Test Variable    ${ALLOCATION_USER_LIST}

Allocate No Fee Installment Sale Account
    [Documentation]    Allocates a no fee installment sales account on a random user
    ${user_object}    Activate Account
    ...    types=${{['${LMS_Account_Type_INSTALLMENT_SALE}']}}
    ...    fee_types=${{['${LMS_ZERO_FEE}']}}
    ...    default_amount=${DEFAULT_ALLOCATION_AMOUNT}

    ${cell_number}    Set Variable    ${user_object['user_cell_number']}
    ${user_id}    Set Variable    ${user_object['user_id']}
    ${credit_ids}    Set Variable    ${user_object['user_credit_ids']}
    &{user_data}    Create Dictionary    user_id=${user_id}    type=${CUSTOMER_TYPE}
    ${ALLOCATION_USER_LIST}    Create List    ${user_data}

    Set Test Variable    ${cell_number}
    Set Test Variable    ${user_id}
    Set Test Variable    ${credit_ids}
    Set Test Variable    ${user_object}
    Set Test Variable    ${ALLOCATION_USER_LIST}

Allocate Fee On Purchase Installment Sale Account
    [Documentation]    Allocates a fee on purchase installment sales account on a random user
    ${user_object}    Activate Account
    ...    types=${{['${LMS_Account_Type_INSTALLMENT_SALE}']}}
    ...    fee_types=${{['${LMS_FEE_ON_PURCHASE}']}}
    ...    default_amount=${DEFAULT_ALLOCATION_AMOUNT}

    ${cell_number}    Set Variable    ${user_object['user_cell_number']}
    ${user_id}    Set Variable    ${user_object['user_id']}
    ${credit_ids}    Set Variable    ${user_object['user_credit_ids']}
    &{user_data}    Create Dictionary    user_id=${user_id}    type=${CUSTOMER_TYPE}
    ${ALLOCATION_USER_LIST}    Create List    ${user_data}

    Set Test Variable    ${cell_number}
    Set Test Variable    ${user_id}
    Set Test Variable    ${credit_ids}
    Set Test Variable    ${user_object}
    Set Test Variable    ${ALLOCATION_USER_LIST}

# Gateways

The Payment Gateway Is Set To BPG
    Set Test Variable    ${PAYMENT_GATEWAY}    ${LMS_PAYMENT_GATEWAY.BPG}

The Payment Gateway Is Set To CPG
    Set Test Variable    ${PAYMENT_GATEWAY}    ${LMS_PAYMENT_GATEWAY.CPG}

The Payment Gateway Is Set To ISPG
    Set Test Variable    ${PAYMENT_GATEWAY}    ${LMS_PAYMENT_GATEWAY.ISPG}

# Channels

The Channel Is Set To API
    Set Test Variable    ${PAYMENT_CHANNEL}    ${CHANNEL.API}

The Channel Is Set To UPG
    Set Test Variable    ${PAYMENT_CHANNEL}    ${CHANNEL.UPG}

The Channel Is Set To Smart POS
    Set Test Variable    ${PAYMENT_CHANNEL}    ${CHANNEL.SMART_POS}

The Channel Is Set To QR
    Set Test Variable    ${PAYMENT_CHANNEL}    ${CHANNEL.QR}

The Channel Is Set To Escrow
    Set Test Variable    ${PAYMENT_CHANNEL}    ${CHANNEL.ESCROW}

The Channel Is Set To Barcode
    Set Test Variable    ${PAYMENT_CHANNEL}    ${CHANNEL.BARCODE}

The Channel Is Set To Linux POS
    Set Test Variable    ${PAYMENT_CHANNEL}    ${CHANNEL.LINUX_POS}

The Channel Is Set To PLATFORM CARD
    Set Test Variable    ${PAYMENT_CHANNEL}    ${CHANNEL.PLATFORM_CARD}

# Repayment Option

The Gateway RepaymentOption Is Set To 1pay
    @{REPAYMENT_OPTIONS}    Create List    ${LMS_REPAYMENT_OPTION.ONEPAY}
    Set Test Variable    ${REPAYMENT_OPTIONS}
    The Gateway Is Activated

The Gateway RepaymentOption Is Set To Xpay
    @{REPAYMENT_OPTIONS}    Create List    ${LMS_REPAYMENT_OPTION.XPAY}
    Set Test Variable    ${REPAYMENT_OPTIONS}
    The Gateway Is Activated

The Gateway RepaymentOption Is Set To 1pay And Xpay
    @{REPAYMENT_OPTIONS}    Create List    ${LMS_REPAYMENT_OPTION.ONEPAY}    ${LMS_REPAYMENT_OPTION.XPAY}
    Set Test Variable    ${REPAYMENT_OPTIONS}
    The Gateway Is Activated

# Amount

The Amount Is Set To Greater Than Credit Balance
    ${find_dic}    Create Dictionary    creditId=${credit_ids}[0]
    ${credit_account}    Mongo Db Find    credit-account-mng_db    accounts    ${find_dic}
    ${credit_account_initial_balance}    Set Variable    ${credit_account}[body][0][initialBalance]
    ${credit_account_initial_balance}    Value Handler    ${credit_account_initial_balance}
    ${greater_amount}    Evaluate    ${credit_account_initial_balance} * 2
    Set Test Variable    ${AMOUNT}    ${greater_amount}

The Amount Is Set To Equal To Credit Balance
    ${find_dic}    Create Dictionary    creditId=${credit_ids}[0]
    ${credit_account}    Mongo Db Find    credit-account-mng_db    accounts    ${find_dic}
    ${credit_account_initial_balance}    Set Variable    ${credit_account}[body][0][initialBalance]
    ${credit_account_initial_balance}    Value Handler    ${credit_account_initial_balance}
    Set Test Variable    ${AMOUNT}    ${credit_account_initial_balance}

The Amount Is Set To Little Than Credit Balance
    Set Test Variable    ${AMOUNT}    ${MIN_AMOUNT}

# Expire

Expire Account
    [Documentation]    Wrapper for the Expiration Service
    [Arguments]    ${credit_id}=${credit_ids}[0]

    Expiration Time Setter    credit_id=${credit_id}

# Active/deactive

The Gateway Is Activated
    [Arguments]    ${repeat_count}=10
    FOR    ${i}    IN RANGE    ${0}    ${repeat_count}    ${1}
        ${disable_response}    POST Credit Gateway Disable
        ...    ${MICROSERVICE_SIDE}
        ...    ${LMS_AUTOMATION_BUSINESS_ID}
        ...    ${PAYMENT_CHANNEL}
        ...    ${PAYMENT_GATEWAY}
    END
    ${activate_response}    POST Credit Gateway Activate
    ...    ${MICROSERVICE_SIDE}
    ...    ${LMS_AUTOMATION_BUSINESS_ID}
    ...    ${PAYMENT_CHANNEL}
    ...    ${PAYMENT_GATEWAY}
    ...    0
    ...    ${DASHBOARD_USERNAME}
    ...    ${REPAYMENT_OPTIONS}

The Gateway Is Disabled
    [Arguments]    ${repeat_count}=10
    FOR    ${i}    IN RANGE    ${0}    ${repeat_count}    ${1}
        ${disable_response}    POST Credit Gateway Disable
        ...    ${MICROSERVICE_SIDE}
        ...    ${LMS_AUTOMATION_BUSINESS_ID}
        ...    ${PAYMENT_CHANNEL}
        ...    ${PAYMENT_GATEWAY}
    END

    Should Be Equal As Integers
    ...    ${disable_response['status_code']}
    ...    200
    ...    msg="Expected status code for Credit Gateway Disable API should be 200, and got" ${disable_response['status_code']}

Account Blocked
    [Arguments]    ${credit_id}=${credit_ids}[0]
    ${response}    Post Admin Credit Accounts Block
    ...    ${MICROSERVICE_SIDE}
    ...    ${credit_id}
    ...    0
    ...    ${DASHBOARD_USERNAME}
    Set Test Variable    ${BLOCK_RESPONSE}    ${response}
    ${credit_account_status}    Check Credit Account Status    ${credit_id}
    IF    '${credit_account_status}' != '3'    Fail

Block credit account
    [Arguments]    ${credit_id}
    ${max_retries}    Set Variable    60
    ${retry_count}    Set Variable    0
    ${status}    Set Variable    FAIL
    WHILE    ${retry_count} < ${max_retries} and '${status}' == 'FAIL'
        ${status}    Run Keyword And Return Status    Account Blocked    ${credit_id}
        ${retry_count}    Evaluate    ${retry_count} + 1
        IF    '${status}' == 'FAIL'    Sleep    1s
    END

Check Credit Account Status
    [Arguments]    ${credit_id}
    ${find_dic}    Create Dictionary    creditId=${credit_id}
    ${credit_account}    Mongo Db Find    credit-account-mng_db    accounts    ${find_dic}
    ${credit_account_status}    Set Variable    ${credit_account}[body][0][status]
    RETURN    ${credit_account_status}

Purchase Status Must Be CONFIRMED Or DELIVERED
    [Arguments]    ${tracking_code}=${purchase_response}[body][trackingCode]
    ${filter_query}    Create Dictionary    trackingCode=${tracking_code}
    ${result}    Mongo Db Find
    ...    credit_mng_db
    ...    purchases
    ...    ${filter_query}
    @{records}    Get From Dictionary    ${result}    body
    ${result_object}    Set Variable    ${records}[0]
    IF    '${result_object['status']}'!= 'CONFIRMED'
        IF    '${result_object['status']}' != 'DELIVERED'
            Fail
            ...    msg=Expected the status for the purchase to be either CONFIRMED or DELIVERED but got ${result_object['status']}!
        END
    END

Purchase Should Be Assigned To The Billing Cycle
    [Arguments]    ${tracking_code}=${purchase_response}[body][trackingCode]
    ${filter_query}    Create Dictionary    trackingCode=${tracking_code}
    ${result}    Mongo Db Find
    ...    credit_mng_db
    ...    purchases
    ...    ${filter_query}
    @{records}    Get From Dictionary    ${result}    body
    ${result_object}    Set Variable    ${records}[0]
    Should Be Equal As Strings    ${result_object['billingCycleAssigned']}    True

Empty Balance
    [Arguments]    ${credit_id}=${credit_ids}[0]
    ${find_dic}    Create Dictionary    creditId=${credit_id}
    ${credit_account}    Mongo Db Find    credit-account-mng_db    accounts    ${find_dic}
    ${credit_account_initial_balance}    Set Variable    ${credit_account}[body][0][initialBalance]
    ${credit_account_initial_balance}    Value Handler    ${credit_account_initial_balance}

    ${amount}    Evaluate    ${credit_account_initial_balance}*2

    ${tracking_code}    Perform A Complete Offline Purchase    ${user_id}    ${credit_id}    ${amount}

    Purchase Status Must Be CONFIRMED Or DELIVERED    tracking_code=${tracking_code}
    Wait Until Keyword Succeeds
    ...    2 minute
    ...    10 s
    ...    Purchase Should Be Assigned To The Billing Cycle
    ...    tracking_code=${tracking_code}

    Set Test Variable    ${tracking_code}

Complete A Purchase
    [Arguments]
    ...    ${user_id}=${user_id}
    ...    ${credit_id}=${credit_ids}[0]
    ...    ${terminal_id}=${EMPTY}
    ${skip}    Create List    deliver
    IF    '${terminal_id}'!='${EMPTY}'    Set Test Variable    ${terminal_id}
    ${tracking_code}    Perform A Complete Offline Purchase
    ...    user_id=${user_id}
    ...    credit_id=${credit_id}
    ...    business_id=${LMS_AUTOMATION_BUSINESS_ID}
    ...    terminal_id=${terminal_id}
    ...    channel=${PAYMENT_CHANNEL}
    ...    skip=${skip}

    Set Test Variable    ${tracking_code}

Full Flow Of Reversed Purchase
    [Arguments]
    ...    ${user_id}=${user_id}
    ...    ${credit_id}=${credit_ids}[0]

    ${tracking_code}    Perform A Reversed Offline Purchase    user_id=${user_id}    credit_id=${credit_id}

    Set Test Variable    ${tracking_code}

Get Confirmed Status From Credit Management DB
    [Arguments]    ${tracking_code}
    ${filter_query}    Create Dictionary    trackingCode=${tracking_code}
    ${result}    Mongo Db Find    credit_mng_db    purchases    ${filter_query}
    @{records}    Get From Dictionary    ${result}    body
    ${result_object}    Set Variable    ${records}[0]
    Should Be Equal    ${result_object['status']}    CONFIRMED

    Wait Until Keyword Succeeds
    ...    2 minute
    ...    10 s
    ...    Purchase Should Be Assigned To The Billing Cycle
    ...    tracking_code=${tracking_code}

Get Confirmed Status From Credit Management DB And Report Management DB And Purchase Has Terminal Id And RRN
    [Arguments]    ${tracking_code}
    ${filter_query}    Create Dictionary    trackingCode=${tracking_code}
    ${result}    Mongo Db Find    credit_mng_db    purchases    ${filter_query}
    @{records}    Get From Dictionary    ${result}    body
    ${result_object}    Set Variable    ${records}[0]
    Should Be Equal    ${result_object['status']}    CONFIRMED
    Should Not Be Empty    ${result_object['payResponse']['rrn']}
    Should Be Equal As Strings    ${result_object['payResponse']['terminalId']}    ${terminal_id}
    Wait Until Keyword Succeeds
    ...    2 minute
    ...    10 s
    ...    Check report management db for purchase with terminal id and rrn
    ...    tracking_code=${tracking_code}
    Wait Until Keyword Succeeds
    ...    2 minute
    ...    10 s
    ...    Purchase Should Be Assigned To The Billing Cycle
    ...    tracking_code=${tracking_code}

Check report management db for purchase with terminal id and rrn
    [Arguments]    ${tracking_code}
    ${report_mng_filter_query}    Create Dictionary    trackingCode=${tracking_code}
    ${report_mng_result}    Mongo Db Find    report_mng_db    activities    ${report_mng_filter_query}
    @{report_mng_records}    Get From Dictionary    ${report_mng_result}    body
    ${report_mng_result_object}    Set Variable    ${report_mng_records}[0]
    Should Be Equal As Numbers    ${report_mng_result_object['status']}    0
    Should Not Be Empty    ${report_mng_result_object['metaData']['settlementTerminal']}
    Should Be Equal As Strings    ${report_mng_result_object['metaData']['settlementTerminal']}    ${terminal_id}

Initiate Purchase
    [Arguments]
    ...    ${user_id}
    ...    ${credit_id}
    ...    ${cell_number}=${cell_number}
    ...    ${api_call_side}=${MICROSERVICE_SIDE}
    ...    ${amount}=${MIN_AMOUNT}
    ...    ${business_id}=${LMS_AUTOMATION_BUSINESS_ID}
    ...    ${channel}=${PAYMENT_CHANNEL}
    ...    ${seller_Id}=default
    ...    ${supplier_id}=default
    ...    ${product_code}=default
    ...    ${brand}=default
    ...    ${product_type}=1
    ...    ${count}=1
    ...    ${category_id}=default
    ...    ${sub_category_ids}=default
    ...    ${cheque_eligible}=true
    ...    ${basket_id}=${EMPTY}
    ...    ${provider_id}=${EMPTY}
    ...    ${version}=${MANIFEST_PLATFORM_VERSION}
    ...    ${terminal_id}=${EMPTY}
    IF    '${provider_id}'=='${EMPTY}'
        ${random_string}    Generate Random String    15    123456789
        Set Test Variable    ${provider_id}    ${random_string}
    END
    IF    '${basket_id}'=='${EMPTY}'
        ${basket_id}    Generate Random String    6    123456789
    END
    IF    '${terminal_id}'!='${EMPTY}'    Set Test Variable    ${terminal_id}
    ${response_init}    POST Credit Purchases Init
    ...    api_call_side=${api_call_side}
    ...    user_id=${user_id}
    ...    credit_id=${credit_id}
    ...    amount=${amount}
    ...    provider_id=${provider_id}
    ...    business_id=${business_id}
    ...    channel=${channel}
    ...    seller_Id=${seller_Id}
    ...    supplier_id=${supplier_id}
    ...    product_code=${product_code}
    ...    brand=${brand}
    ...    product_type=${product_type}
    ...    count=${count}
    ...    category_id=${category_id}
    ...    sub_category_ids=${sub_category_ids}
    ...    cheque_eligible=${cheque_eligible}
    ...    basket_id=${basket_id}
    ...    version=${version}
    ...    cell_number=${cell_number}
    ...    terminal_id=${terminal_id}
    ${body_init}    Set Variable    ${response_init['body']}
    ${status_code}    Set Variable    ${response_init['status_code']}
    IF    '${status_code}'=='200'
        ${tracking_code}    Set Variable    ${body_init['trackingCode']}
        ${cash_amount}    Set Variable    ${body_init['cashAmount']}

        ${result}    Create Dictionary    status_code=${status_code}
        ...    provider_id=${provider_id}
        ...    tracking_code=${tracking_code}
        ...    cash_amount=${cash_amount}

        Set Test Variable    ${tracking_code}
        Set Test Variable    ${cash_amount}
        Set Test Variable    ${result}
        RETURN    ${result}
    ELSE
        ${result}    Create Dictionary
        ...    status_code=${status_code}
        ...    body=${body_init}
        Set Test Variable    ${result}
        RETURN    ${result}
    END

Pay The Credit Amount Of The Purchase
    [Arguments]
    ...    ${tracking_code}
    ...    ${provider_id}
    ...    ${api_call_side}=${MICROSERVICE_SIDE}

    ${response_pay}    POST Credit Purchases Pay
    ...    api_call_side=${api_call_side}
    ...    tracking_code=${tracking_code}
    ...    provider_id=${provider_id}
    ${status_code}    Set Variable    ${response_pay['status_code']}
    Set Test Variable    ${status_code}
    RETURN    ${status_code}

Pay The Cash Amount Of The Purchase
    [Arguments]
    ...    ${tracking_code}
    ...    ${api_call_side}=${MICROSERVICE_SIDE}
    ...    ${confirmation_code}=${EMPTY}
    ...    ${rrn}=${EMPTY}
    ...    ${terminal_id}=${EMPTY}
    ...    ${masked_pan}=${EMPTY}
    ...    ${psp_code}=${PSP_CODE.IRKISH}
    ...    ${result_code}=${EMPTY}
    IF    '${confirmation_code}'=='${EMPTY}'
        ${confirmation_code}    Generate Random String    16    123456789
    END
    IF    '${rrn}'=='${EMPTY}'
        ${rrn}    Generate Random String    16    123456789
    END
    IF    '${terminal_id}'=='${EMPTY}'
        ${terminal_id}    Generate Random String    9    123456789
    END
    IF    '${masked_pan}'=='${EMPTY}'
        ${masked_pan}    Generate Random String    16    123456789
    END
    IF    '${result_code}'=='${EMPTY}'
        ${result_code}    Generate Random String    3    123456789
    END
    ${response_prepayment}    POST Credit Prepayment Pay Cash Result
    ...    api_call_side=${api_call_side}
    ...    tracking_code=${tracking_code}
    ...    confirmation_code=${confirmation_code}
    ...    rrn=${rrn}
    ...    terminal_id=${terminal_id}
    ...    masked_pan=${masked_pan}
    ...    psp_code=${PSP_CODE}
    ...    result_code=${result_code}

    ${status_code}    Set Variable    ${response_prepayment['status_code']}
    Set Test Variable    ${status_code}
    RETURN    ${status_code}

Reverse Purchase
    [Arguments]
    ...    ${tracking_code}
    ...    ${provider_id}
    ...    ${api_call_side}=${MICROSERVICE_SIDE}

    ${response_reverse}    POST Credit Purchase Reverse
    ...    api_call_side=${api_call_side}
    ...    tracking_code=${tracking_code}
    ...    provider_id=${provider_id}
    ...    user_id=${LMS_AUTOMATION_BUSINESS_ID}

    ${status_code}    Set Variable    ${response_reverse['status_code']}

    RETURN    ${status_code}

Verify Purchase
    [Arguments]
    ...    ${tracking_code}
    ...    ${provider_id}
    ...    ${api_call_side}=${MICROSERVICE_SIDE}

    ${response_verify}    POST Credit Purchases Verify
    ...    api_call_side=${api_call_side}
    ...    tracking_code=${tracking_code}
    ...    provider_id=${provider_id}
    ...    user_id=${LMS_AUTOMATION_BUSINESS_ID}

    ${status_code}    Set Variable    ${response_verify['status_code']}
    Set Test Variable    ${response_verify}
    Set Test Variable    ${status_code}
    RETURN    ${status_code}

Check The Status On Mongo DB
    [Arguments]    ${tracking_code}    ${cash_amount}
    IF    ${cash_amount}>0
        Pay The Credit Amount Of The Purchase    ${tracking_code}    ${provider_id}
        ${filter_query}    Create Dictionary    trackingCode=${tracking_code}
        ${result}    Mongo Db Find    credit_mng_db    purchases    ${filter_query}
        @{records}    Get From Dictionary    ${result}    body
        ${result_object}    Set Variable    ${records}[0]
        Should Be Equal    ${result_object['status']}    PENDING

        Pay The Cash Amount Of The Purchase    tracking_code=${tracking_code}
        ${filter_query}    Create Dictionary    trackingCode=${tracking_code}
        ${result}    Mongo Db Find    credit_mng_db    purchases    ${filter_query}
        @{records}    Get From Dictionary    ${result}    body
        ${result_object}    Set Variable    ${records}[0]
        Should Be Equal    ${result_object['status']}    PAID
    ELSE
        Pay The Credit Amount Of The Purchase    tracking_code=${tracking_code}    provider_id=${provider_id}
        ${filter_query}    Create Dictionary    trackingCode=${tracking_code}
        ${result}    Mongo Db Find    credit_mng_db    purchases    ${filter_query}
        @{records}    Get From Dictionary    ${result}    body
        ${result_object}    Set Variable    ${records}[0]
        Should Be Equal    ${result_object['status']}    PAID
    END

Check The Fee Charge On Mongo DB
    [Arguments]    ${tracking_code}    ${cash_amount}    ${provider_id}=${provider_id}
    IF    ${cash_amount}>0
        Pay The Credit Amount Of The Purchase    ${tracking_code}    provider_id=${provider_id}
        ${filter_query}    Create Dictionary    trackingCode=${tracking_code}
        ${result}    Mongo Db Find    credit_mng_db    purchases    ${filter_query}
        @{records}    Get From Dictionary    ${result}    body
        ${result_object}    Set Variable    ${records}[0]
        Should Be Equal    ${result_object['status']}    PENDING

        Pay The Cash Amount Of The Purchase    tracking_code=${tracking_code}
        ${filter_query}    Create Dictionary    trackingCode=${tracking_code}
        ${result}    Mongo Db Find    credit_mng_db    purchases    ${filter_query}
        @{records}    Get From Dictionary    ${result}    body
        ${result_object}    Set Variable    ${records}[0]
        ${fee_charge_raw}    Value Handler    ${result_object['feeCharge']}
        Should Not Be Equal As Numbers    ${fee_charge_raw}    0
    ELSE
        Pay The Credit Amount Of The Purchase    tracking_code=${tracking_code}    provider_id=${provider_id}
        ${filter_query}    Create Dictionary    trackingCode=${tracking_code}
        ${result}    Mongo Db Find    credit_mng_db    purchases    ${filter_query}
        @{records}    Get From Dictionary    ${result}    body
        ${result_object}    Set Variable    ${records}[0]
        ${fee_charge_raw}    Value Handler    ${result_object['feeCharge']}
        Should Be Equal As Numbers    ${fee_charge_raw}    0
    END

Check The Barcode Channel On Mongo DB
    ${filter_query}    Create Dictionary    trackingCode=${tracking_code}
    ${result}    Mongo Db Find    credit_mng_db    purchases    ${filter_query}
    @{records}    Get From Dictionary    ${result}    body
    ${result_object}    Set Variable    ${records}[0]
    Should Be Equal As Strings    ${result_object['paymentChannel']}    5

Check The Linux Pos Channel On Mongo DB
    ${filter_query}    Create Dictionary    trackingCode=${tracking_code}
    ${result}    Mongo Db Find    credit_mng_db    purchases    ${filter_query}
    @{records}    Get From Dictionary    ${result}    body
    ${result_object}    Set Variable    ${records}[0]
    Should Be Equal As Strings    ${result_object['paymentChannel']}    6

Check The Smart Pos Channel On Mongo DB
    ${filter_query}    Create Dictionary    trackingCode=${tracking_code}
    ${result}    Mongo Db Find    credit_mng_db    purchases    ${filter_query}
    @{records}    Get From Dictionary    ${result}    body
    ${result_object}    Set Variable    ${records}[0]
    Should Be Equal As Strings    ${result_object['paymentChannel']}    2

Check The Prepayment On Mongo DB
    [Arguments]    ${tracking_code}    ${cash_amount}
    IF    ${cash_amount}>0
        Pay The Credit Amount Of The Purchase    ${tracking_code}    provider_id=${provider_id}
        ${filter_query}    Create Dictionary    trackingCode=${tracking_code}
        ${result}    Mongo Db Find    credit_mng_db    purchases    ${filter_query}
        @{records}    Get From Dictionary    ${result}    body
        ${result_object}    Set Variable    ${records}[0]
        Should Be Equal    ${result_object['status']}    PENDING

        Pay The Cash Amount Of The Purchase    tracking_code=${tracking_code}
        Verify Purchase    tracking_code=${tracking_code}    provider_id=${provider_id}
        ${filter_query}    Create Dictionary    trackingCode=${tracking_code}
        ${result}    Mongo Db Find    credit_mng_db    purchases    ${filter_query}
        @{records}    Get From Dictionary    ${result}    body
        ${result_object}    Set Variable    ${records}[0]
        Should Not Be Empty    ${result_object['prepaymentTrackingCodes']}
        ${prepaymentTrackingCode}    Set Variable    ${result_object['prepaymentTrackingCodes']}
    ELSE
        Pay The Credit Amount Of The Purchase    tracking_code=${tracking_code}    provider_id=${provider_id}
        ${filter_query}    Create Dictionary    trackingCode=${tracking_code}
        ${result}    Mongo Db Find    credit_mng_db    purchases    ${filter_query}
        @{records}    Get From Dictionary    ${result}    body
        ${result_object}    Set Variable    ${records}[0]
        Should Be Empty    ${result_object['prepaymentTrackingCodes']}
    END

Send Success Prepayment Event On Report Managmant
    [Arguments]    ${tracking_code}
    ${filter_query}    Create Dictionary    trackingCode=${tracking_code}
    ${result}    Mongo Db Find    credit_mng_db    purchases    ${filter_query}
    @{records}    Get From Dictionary    ${result}    body
    ${result_object}    Get From List    ${records}    0
    Should Be Equal    ${result_object['status']}    CONFIRMED
    Should Not Be Empty    ${result_object['prepaymentTrackingCodes']}
    ${tracking_code}    Get From List    ${result_object['prepaymentTrackingCodes']}    0
    ${filter_query}    Create Dictionary    trackingCode=${tracking_code}
    ${result}    Mongo Db Find    report_mng_db    activities    ${filter_query}
    @{records}    Get From Dictionary    ${result}    body
    ${result_object}    Get From List    ${records}    0
    Should Be Equal As Integers    ${result_object['status']}    0

Check The CPG Gateway On Mongo DB
    ${filter_query}    Create Dictionary    trackingCode=${tracking_code}
    ${result}    Mongo Db Find    credit_mng_db    purchases    ${filter_query}
    @{records}    Get From Dictionary    ${result}    body
    ${result_object}    Set Variable    ${records}[0]
    Should Be Equal    ${result_object['payGateway']}    CPG

Check The BPG Gateway On Mongo DB
    ${filter_query}    Create Dictionary    trackingCode=${tracking_code}
    ${result}    Mongo Db Find    credit_mng_db    purchases    ${filter_query}
    @{records}    Get From Dictionary    ${result}    body
    ${result_object}    Set Variable    ${records}[0]
    Should Be Equal    ${result_object['payGateway']}    BPG

Check The ISPG Gateway On Mongo DB
    ${filter_query}    Create Dictionary    trackingCode=${tracking_code}
    ${result}    Mongo Db Find    credit_mng_db    purchases    ${filter_query}
    @{records}    Get From Dictionary    ${result}    body
    ${result_object}    Set Variable    ${records}[0]
    Should Be Equal    ${result_object['payGateway']}    ISPG

Call Cash Result Before Pay
    [Arguments]
    ...    ${tracking_code}
    ...    ${cash_amount}
    IF    "${cash_amount}" > "0"
        ${status_code}    Pay The Cash Amount Of The Purchase    ${tracking_code}
        Should Be Equal As Integers    ${status_code}    422
    END

Call Reverse In Different Status
    [Arguments]
    ...    ${tracking_code}
    ...    ${provider_id}

    ${filter_query}    Create Dictionary    trackingCode=${tracking_code}
    ${result}    Mongo Db Find    credit_mng_db    purchases    ${filter_query}
    @{records}    Get From Dictionary    ${result}    body
    ${result_object}    Set Variable    ${records}[0]
    IF    ( "${result_object['status']}"=="PAID") or ("${result_object['status']}"=="PENDING")
        Reverse Purchase    ${tracking_code}    ${provider_id}
        ${filter_query}    Create Dictionary    trackingCode=${tracking_code}
        ${result}    Mongo Db Find    credit_mng_db    purchases    ${filter_query}
        @{records}    Get From Dictionary    ${result}    body
        ${result_object}    Set Variable    ${records}[0]
        Should Be Equal    ${result_object['status']}    REVERSE_INITIATED
    ELSE
        ${status_code}    Reverse Purchase    ${tracking_code}    ${provider_id}
        Should Be Equal As Integers    ${status_code}    422
    END

Idempotency Of Reverse Api
    [Arguments]
    ...    ${tracking_code}
    ...    ${provider_id}

    ${filter_query}    Create Dictionary    trackingCode=${tracking_code}
    ${result}    Mongo Db Find    credit_mng_db    purchases    ${filter_query}
    @{records}    Get From Dictionary    ${result}    body
    ${result_object}    Set Variable    ${records}[0]
    IF    "${result_object['status']}"=="REVERSE_INITIATED"
        ${status_code}    Reverse Purchase    ${tracking_code}    ${provider_id}
        Should Be Equal As Integers    ${status_code}    200
    END

Call Pay Cash Result After Reverse
    [Arguments]
    ...    ${tracking_code}

    ${filter_query}    Create Dictionary    trackingCode=${tracking_code}
    ${result}    Mongo Db Find    credit_mng_db    purchases    ${filter_query}
    @{records}    Get From Dictionary    ${result}    body
    ${result_object}    Set Variable    ${records}[0]
    IF    "${result_object['status']}"=="REVERSE_INITIATED"
        ${status_code}    Pay The Cash Amount Of The Purchase    ${tracking_code}
        Should Be Equal As Integers    ${status_code}    422
        ...    msg="خرید قابل پرداخت نمی باشد"
    END

Verify Purchase After Reverse
    [Arguments]
    ...    ${tracking_code}
    ...    ${provider_id}

    ${filter_query}    Create Dictionary    trackingCode=${tracking_code}
    ${result}    Mongo Db Find    credit_mng_db    purchases    ${filter_query}
    @{records}    Get From Dictionary    ${result}    body
    ${result_object}    Set Variable    ${records}[0]
    IF    "${result_object['status']}"=="REVERSE_INITIATED"
        ${status_code}    Verify Purchase    ${tracking_code}    ${provider_id}
        Should Be Equal As Integers    ${status_code}    422
        ...    msg="وضعیت خرید برای این درخواست صحیح نمی باشد"
    END

Call The Verify Before Pay
    [Arguments]
    ...    ${tracking_code}
    ...    ${cash_amount}
    ...    ${provider_id}
    IF    ${cash_amount}>0
        ${status_code}    Verify Purchase    ${tracking_code}    ${provider_id}
        Should Be Equal As Integers    ${status_code}    422
    END

Call The Verify Before Pay Cash Result
    [Arguments]
    ...    ${tracking_code}
    ...    ${cash_amount}
    ...    ${provider_id}
    Pay The Credit Amount Of The Purchase    ${tracking_code}    provider_id=${provider_id}
    IF    ${cash_amount}>0
        ${status_code}    Verify Purchase    ${tracking_code}    ${provider_id}
        Should Be Equal As Integers    ${status_code}    422
    ELSE
        ${status_code}    Verify Purchase    ${tracking_code}    ${provider_id}
        Should Be Equal As Integers    ${status_code}    200
    END

Call The Pay Api In Paid Status Two Times
    [Arguments]
    ...    ${tracking_code}
    ...    ${cash_amount}
    ${status_code}    Pay The Credit Amount Of The Purchase
    ...    tracking_code=${tracking_code}
    ...    provider_id=${provider_id}
    ${filter_query}    Create Dictionary    trackingCode=${tracking_code}
    ${result}    Mongo Db Find    credit_mng_db    purchases    ${filter_query}
    @{records}    Get From Dictionary    ${result}    body
    ${result_object}    Set Variable    ${records}[0]
    Should Be Equal    ${result_object['status']}    PAID
    IF    "${cash_amount}" == "0" and "${result_object['status']}" == "PAID"
        ${status_code}    Pay The Credit Amount Of The Purchase
        ...    tracking_code=${tracking_code}
        ...    provider_id=${provider_id}
        Should Be Equal As Integers    ${status_code}    200
    END

Call The Pay Api In Pending Status Two Times
    [Arguments]
    ...    ${tracking_code}
    ...    ${cash_amount}
    ${status_code}    Pay The Credit Amount Of The Purchase
    ...    tracking_code=${tracking_code}
    ...    provider_id=${provider_id}
    ${filter_query}    Create Dictionary    trackingCode=${tracking_code}
    ${result}    Mongo Db Find    credit_mng_db    purchases    ${filter_query}
    @{records}    Get From Dictionary    ${result}    body
    ${result_object}    Set Variable    ${records}[0]
    Should Be Equal    ${result_object['status']}    PENDING
    ...    msg="Status = PENDING"
    IF    "${cash_amount}" > "0" and "${result_object['status']}" == "PENDING"
        ${status_code}    Pay The Credit Amount Of The Purchase
        ...    tracking_code=${tracking_code}
        ...    provider_id=${provider_id}
        Should Be Equal As Integers    ${status_code}    200
    END

Call The Pay Api In CONFIRMED Status Two Times
    [Arguments]
    ...    ${tracking_code}
    ...    ${cash_amount}
    ${filter_query}    Create Dictionary    trackingCode=${tracking_code}
    ${result}    Mongo Db Find    credit_mng_db    purchases    ${filter_query}
    @{records}    Get From Dictionary    ${result}    body
    ${result_object}    Set Variable    ${records}[0]
    IF    "${cash_amount}" > "0" and ("${result_object['status']}" == "PAID" or "${result_object['status']}" == "PENDING" )
        ${status_code}    Pay The Credit Amount Of The Purchase
        ...    tracking_code=${tracking_code}
        ...    provider_id=${provider_id}
        Should Be Equal As Integers    ${status_code}    200
    ELSE
        ${status_code}    Pay The Credit Amount Of The Purchase
        ...    tracking_code=${tracking_code}
        ...    provider_id=${provider_id}
        Should Be Equal As Integers    ${status_code}    422
    END

Call The Init Api in Initiated Status
    [Arguments]
    ...    ${tracking_code}
    ...    ${user_id}=${user_id}
    ...    ${credit_id}=${credit_ids}[0]
    ...    ${terminal_id}=${EMPTY}

    ${result1}    POST Credit Purchases Init
    ...    api_call_side=${MICROSERVICE_SIDE}
    ...    user_id=${user_id}
    ...    credit_id=${credit_id}
    ...    amount=${MIN_AMOUNT}
    ...    provider_id=${provider_id}
    ...    business_id=${LMS_AUTOMATION_BUSINESS_ID}
    ...    channel=${PAYMENT_CHANNEL}
    ...    cell_number=${cell_number}
    ...    terminal_id=${terminal_id}

    ${result2}    POST Credit Purchases Init
    ...    api_call_side=${MICROSERVICE_SIDE}
    ...    user_id=${user_id}
    ...    credit_id=${credit_id}
    ...    amount=${MIN_AMOUNT}
    ...    provider_id=${provider_id}
    ...    business_id=${LMS_AUTOMATION_BUSINESS_ID}
    ...    channel=${PAYMENT_CHANNEL}
    ...    cell_number=${cell_number}
    ...    terminal_id=${terminal_id}
    ${result3}    POST Credit Purchases Init
    ...    api_call_side=${MICROSERVICE_SIDE}
    ...    user_id=${user_id}
    ...    credit_id=${credit_id}
    ...    amount=${MIN_AMOUNT}
    ...    provider_id=${provider_id}
    ...    channel=${PAYMENT_CHANNEL}
    ...    cell_number=${cell_number}
    ...    terminal_id=${terminal_id}
    ${result4}    POST Credit Purchases Init
    ...    api_call_side=${MICROSERVICE_SIDE}
    ...    user_id=${user_id}
    ...    credit_id=${credit_id}
    ...    amount=12345
    ...    provider_id=${provider_id}
    ...    business_id=${LMS_AUTOMATION_BUSINESS_ID}
    ...    channel=${PAYMENT_CHANNEL}
    ...    cell_number=${cell_number}
    ...    terminal_id=${terminal_id}
    ${result5}    POST Credit Purchases Init
    ...    api_call_side=${MICROSERVICE_SIDE}
    ...    user_id=${user_id}
    ...    credit_id=${credit_id}
    ...    amount=${MIN_AMOUNT}
    ...    provider_id=123456789
    ...    business_id=${LMS_AUTOMATION_BUSINESS_ID}
    ...    channel=${PAYMENT_CHANNEL}
    ...    cell_number=${cell_number}
    ...    terminal_id=${terminal_id}
    Should Be Equal As Integers    ${result1['status_code']}
    ...    200
    Should Be Equal As Integers    ${result2['status_code']}
    ...    200
    Should Be Equal As Integers    ${result3['status_code']}
    ...    422
    Should Be Equal As Integers    ${result4['status_code']}
    ...    422
    Should Be Equal As Integers    ${result5['status_code']}
    ...    200

# Assertion

The Purchase Was Not Exist
    Should Be Equal As Strings    ${result.status_code}
    ...    422
    ...    msg="عملیات ناموفق بود لطفا مجددا تلاش کنید"

The Purchase Was Exist
    Should Be Equal As Strings    ${result.status_code}
    ...    200
    ...    msg="عملیات با موفقیت انجام شد"

The Purchase Exist
    Should Be Equal As Integers    ${status_code}    200

The Purchase Did Not Exist Because The Gateway Disable
    Should Be Equal As Integers    ${result['status_code']}    422
    # Should Be Equal As Integers    ${result['body']['result']['status']}    15811
    Should Be Equal    ${result['body']['result']['title']}    CRT_MNG_GATEWAY_NOT_FOUND

The Purchase Did Not Exist Because The Gateway disable After Call Verify API And Account Is Block
    Should Be Equal As Integers    ${response_verify['status_code']}    422
    # Should Be Equal As Integers    ${result['body']['result']['status']}    15811
    Should Be Equal    ${response_verify['body']['result']['title']}    CRT_MNG_ACCOUNT_BLOCKED

The Purchase Did Not Exist Because The Account Expired
    Should Be Equal As Integers    ${result['status_code']}    422
    # Should Be Equal As Integers    ${result['body']['result']['status']}    1026
    Should Be Equal    ${result['body']['result']['title']}    ACCOUNT_NOT_FOUND

Purchase Is Initialized Successfully With Cash Amount Greater Than Zero
    [Arguments]    ${terminal_id}=${EMPTY}
    ${api_call_side}    Set Variable    ${MICROSERVICE_SIDE}
    ${credit_id}    Set Variable    ${credit_ids}[0]
    ${provider_id}    Generate Random String    15    123456789
    Set Test Variable    ${provider_id}
    ${amount}    Set Variable
    ${amount}    Evaluate    ${DEFAULT_ALLOCATION_AMOUNT} + 1000
    ${channel}    Set Variable    ${PAYMENT_CHANNEL}
    ${business_id}    Set Variable    ${LMS_AUTOMATION_BUSINESS_ID}
    ${channel}    Set Variable    ${PAYMENT_CHANNEL}
    ${seller_Id}    Set Variable    SELLER-1
    ${supplier_id}    Set Variable    SUP-1
    ${product_code}    Set Variable    PROD-100
    ${brand}    Set Variable    MyBrand
    ${product_type}    Set Variable    1
    ${count}    Set Variable    1
    ${category_id}    Set Variable    CAT-10
    ${sub_category_ids}    Set Variable    [1,2]
    ${cheque_eligible}    Set Variable    True
    ${basket_id}    Set Variable
    ${basket_id}    Generate Random String    5    123456789
    ${version}    Set Variable    2025-01-26
    ${user_id}    Set Variable    ${user_id}
    ${cell_number}    Set Variable    ${cell_number}
    ${response}    POST Credit Purchases Init
    ...    ${api_call_side}
    ...    ${credit_id}
    ...    ${provider_id}
    ...    ${amount}
    ...    ${business_id}
    ...    ${channel}
    ...    ${seller_Id}
    ...    ${supplier_id}
    ...    ${product_code}
    ...    ${brand}
    ...    ${product_type}
    ...    ${count}
    ...    ${category_id}
    ...    ${sub_category_ids}
    ...    ${cheque_eligible}
    ...    ${basket_id}
    ...    ${version}
    ...    ${user_id}
    ...    ${cell_number}
    ...    ${terminal_id}
    Set Test Variable    ${purchase_response}    ${response}

Offline Purchase Init Is Requested With All Valid Data
    [Arguments]    ${terminal_id}=${EMPTY}
    ${api_call_side}    Set Variable    ${MICROSERVICE_SIDE}
    ${credit_id}    Set Variable    ${credit_ids}[0]
    ${provider_id}    Generate Random String    15    123456789
    Set Test Variable    ${provider_id}
    ${amount}    Set Variable    ${MIN_AMOUNT}
    ${business_id}    Set Variable    ${LMS_AUTOMATION_BUSINESS_ID}
    ${channel}    Set Variable    ${PAYMENT_CHANNEL}
    ${seller_Id}    Set Variable    SELLER-1
    ${supplier_id}    Set Variable    SUP-1
    ${product_code}    Set Variable    PROD-100
    ${brand}    Set Variable    MyBrand
    ${product_type}    Set Variable    1
    ${count}    Set Variable    1
    ${category_id}    Set Variable    CAT-10
    ${sub_category_ids}    Set Variable    [1,2]
    ${cheque_eligible}    Set Variable    True
    ${basket_id}    Set Variable
    ${basket_id}    Generate Random String    5    123456789
    ${version}    Set Variable    2025-01-26
    ${user_id}    Set Variable    ${user_id}
    ${cell_number}    Set Variable    ${cell_number}

    ${response}    POST Credit Purchases Init
    ...    ${api_call_side}
    ...    ${credit_id}
    ...    ${provider_id}
    ...    ${amount}
    ...    ${business_id}
    ...    ${channel}
    ...    ${seller_Id}
    ...    ${supplier_id}
    ...    ${product_code}
    ...    ${brand}
    ...    ${product_type}
    ...    ${count}
    ...    ${category_id}
    ...    ${sub_category_ids}
    ...    ${cheque_eligible}
    ...    ${basket_id}
    ...    ${version}
    ...    ${user_id}
    ...    ${cell_number}
    ...    ${terminal_id}
    Set Test Variable    ${purchase_response}    ${response}

Offline Purchase Init Is Requested With Wrong CreditId Type
    [Arguments]    ${terminal_id}=${EMPTY}
    ${api_call_side}    Set Variable    ${MICROSERVICE_SIDE}
    ${credit_id}    Set Variable    123456789
    ${provider_id}    Generate Random String    15    123456789
    Set Test Variable    ${provider_id}
    ${provider_id}    Generate Random String    15    123456789
    ${amount}    Set Variable    ${MIN_AMOUNT}
    ${business_id}    Set Variable    ${LMS_AUTOMATION_BUSINESS_ID}
    ${channel}    Set Variable    ${PAYMENT_CHANNEL}
    ${seller_Id}    Set Variable    SELLER-1
    ${supplier_id}    Set Variable    SUP-1
    ${product_code}    Set Variable    PROD-100
    ${brand}    Set Variable    MyBrand
    ${product_type}    Set Variable    1
    ${count}    Set Variable    1
    ${category_id}    Set Variable    CAT-10
    ${sub_category_ids}    Set Variable    [1,2]
    ${cheque_eligible}    Set Variable    True
    ${basket_id}    Set Variable
    ${basket_id}    Generate Random String    10    123456789
    ${version}    Set Variable    2025-01-26
    ${user_id}    Set Variable    ${user_id}
    ${cell_number}    Set Variable    ${cell_number}

    ${response}    POST Credit Purchases Init
    ...    ${api_call_side}
    ...    ${credit_id}
    ...    ${provider_id}
    ...    ${amount}
    ...    ${business_id}
    ...    ${channel}
    ...    ${seller_Id}
    ...    ${supplier_id}
    ...    ${product_code}
    ...    ${brand}
    ...    ${product_type}
    ...    ${count}
    ...    ${category_id}
    ...    ${sub_category_ids}
    ...    ${cheque_eligible}
    ...    ${basket_id}
    ...    ${version}
    ...    ${user_id}
    ...    ${cell_number}
    ...    ${terminal_id}
    Set Test Variable    ${purchase_response}    ${response}

Offline Purchase Init Is Requested With Null UserId And Null CellNumber
    [Arguments]    ${terminal_id}=${EMPTY}
    ${api_call_side}    Set Variable    ${MICROSERVICE_SIDE}
    ${credit_id}    Set Variable    ${credit_ids}[0]
    ${provider_id}    Generate Random String    15    123456789
    Set Test Variable    ${provider_id}
    ${amount}    Set Variable    ${MIN_AMOUNT}
    ${business_id}    Set Variable    ${LMS_AUTOMATION_BUSINESS_ID}
    ${channel}    Set Variable    ${PAYMENT_CHANNEL}
    ${seller_Id}    Set Variable    SELLER-1
    ${supplier_id}    Set Variable    SUP-1
    ${product_code}    Set Variable    PROD-100
    ${brand}    Set Variable    MyBrand
    ${product_type}    Set Variable    1
    ${count}    Set Variable    1
    ${category_id}    Set Variable    CAT-10
    ${sub_category_ids}    Set Variable    [1,2]
    ${cheque_eligible}    Set Variable    True
    ${basket_id}    Set Variable
    ${basket_id}    Generate Random String    10    123456789
    ${version}    Set Variable    2025-01-26
    ${user_id}    Set Variable    ${EMPTY}
    ${cell_number}    Set Variable    ${EMPTY}
    ${response}    POST Credit Purchases Init
    ...    ${api_call_side}
    ...    ${credit_id}
    ...    ${provider_id}
    ...    ${amount}
    ...    ${business_id}
    ...    ${channel}
    ...    ${seller_Id}
    ...    ${supplier_id}
    ...    ${product_code}
    ...    ${brand}
    ...    ${product_type}
    ...    ${count}
    ...    ${category_id}
    ...    ${sub_category_ids}
    ...    ${cheque_eligible}
    ...    ${basket_id}
    ...    ${version}
    ...    ${user_id}
    ...    ${cell_number}
    ...    ${terminal_id}
    Set Test Variable    ${purchase_response}    ${response}

Offline Purchase Init Is Requested With Missing basket Detail
    [Arguments]    ${terminal_id}=${EMPTY}
    ${api_call_side}    Set Variable    ${MICROSERVICE_SIDE}
    ${credit_id}    Set Variable    ${credit_ids}[0]
    ${provider_id}    Generate Random String    15    123456789
    Set Test Variable    ${provider_id}
    ${amount}    Set Variable    ${MIN_AMOUNT}
    ${business_id}    Set Variable    ${LMS_AUTOMATION_BUSINESS_ID}
    ${channel}    Set Variable    ${PAYMENT_CHANNEL}
    ${seller_Id}    Set Variable    ${EMPTY}
    ${supplier_id}    Set Variable    ${EMPTY}
    ${product_code}    Set Variable    ${EMPTY}
    ${brand}    Set Variable    ${EMPTY}
    ${product_type}    Set Variable    ${EMPTY}
    ${count}    Set Variable    ${EMPTY}
    ${category_id}    Set Variable    ${EMPTY}
    ${sub_category_ids}    Set Variable    ${EMPTY}
    ${cheque_eligible}    Set Variable    ${EMPTY}
    ${basket_id}    Set Variable    ${EMPTY}
    ${version}    Set Variable    2025-01-26
    ${user_id}    Set Variable    ${user_id}
    ${cell_number}    Set Variable    ${cell_number}

    ${response}    POST Credit Purchases Init
    ...    ${api_call_side}
    ...    ${credit_id}
    ...    ${provider_id}
    ...    ${amount}
    ...    ${business_id}
    ...    ${channel}
    ...    ${seller_Id}
    ...    ${supplier_id}
    ...    ${product_code}
    ...    ${brand}
    ...    ${product_type}
    ...    ${count}
    ...    ${category_id}
    ...    ${sub_category_ids}
    ...    ${cheque_eligible}
    ...    ${basket_id}
    ...    ${version}
    ...    ${user_id}
    ...    ${cell_number}
    ...    ${terminal_id}
    Set Test Variable    ${purchase_response}    ${response}

Offline Purchase Init Is Requested With No Version In Headers
    [Arguments]    ${terminal_id}=${EMPTY}
    ${api_call_side}    Set Variable    ${MICROSERVICE_SIDE}
    ${credit_id}    Set Variable    ${credit_ids}[0]
    ${provider_id}    Generate Random String    15    123456789
    Set Test Variable    ${provider_id}
    ${amount}    Set Variable    ${MIN_AMOUNT}
    ${business_id}    Set Variable    ${LMS_AUTOMATION_BUSINESS_ID}
    ${channel}    Set Variable    ${PAYMENT_CHANNEL}
    ${seller_Id}    Set Variable    SELLER-1
    ${supplier_id}    Set Variable    SUP-1
    ${product_code}    Set Variable    PROD-100
    ${brand}    Set Variable    MyBrand
    ${product_type}    Set Variable    1
    ${count}    Set Variable    1
    ${category_id}    Set Variable    CAT-10
    ${sub_category_ids}    Set Variable    [1,2]
    ${cheque_eligible}    Set Variable    True
    ${basket_id}    Set Variable
    ${basket_id}    Generate Random String    10    123456789
    ${version}    Set Variable    ${EMPTY}
    ${user_id}    Set Variable    ${user_id}
    ${cell_number}    Set Variable    ${cell_number}

    ${response}    POST Credit Purchases Init
    ...    ${api_call_side}
    ...    ${credit_id}
    ...    ${provider_id}
    ...    ${amount}
    ...    ${business_id}
    ...    ${channel}
    ...    ${seller_Id}
    ...    ${supplier_id}
    ...    ${product_code}
    ...    ${brand}
    ...    ${product_type}
    ...    ${count}
    ...    ${category_id}
    ...    ${sub_category_ids}
    ...    ${cheque_eligible}
    ...    ${basket_id}
    ...    ${version}
    ...    ${user_id}
    ...    ${cell_number}
    ...    ${terminal_id}
    Set Test Variable    ${purchase_response}    ${response}

Offline Purchase Init Is Requested With Wrong Product Type
    [Arguments]    ${terminal_id}=${EMPTY}
    ${api_call_side}    Set Variable    ${MICROSERVICE_SIDE}
    ${credit_id}    Set Variable    ${credit_ids}[0]
    ${provider_id}    Generate Random String    15    123456789
    Set Test Variable    ${provider_id}
    ${amount}    Set Variable    ${MIN_AMOUNT}
    ${business_id}    Set Variable    ${LMS_AUTOMATION_BUSINESS_ID}
    ${channel}    Set Variable    ${PAYMENT_CHANNEL}
    ${seller_Id}    Set Variable    SELLER-1
    ${supplier_id}    Set Variable    SUP-1
    ${product_code}    Set Variable    PROD-100
    ${brand}    Set Variable    MyBrand
    ${product_type}    Set Variable    A
    ${count}    Set Variable    1
    ${category_id}    Set Variable    CAT-10
    ${sub_category_ids}    Set Variable    [1,2]
    ${cheque_eligible}    Set Variable    True
    ${basket_id}    Set Variable
    ${basket_id}    Generate Random String    10    123456789
    ${version}    Set Variable    2025-01-26
    ${user_id}    Set Variable    ${user_id}
    ${cell_number}    Set Variable    ${cell_number}

    ${response}    POST Credit Purchases Init
    ...    ${api_call_side}
    ...    ${credit_id}
    ...    ${provider_id}
    ...    ${amount}
    ...    ${business_id}
    ...    ${channel}
    ...    ${seller_Id}
    ...    ${supplier_id}
    ...    ${product_code}
    ...    ${brand}
    ...    ${product_type}
    ...    ${count}
    ...    ${category_id}
    ...    ${sub_category_ids}
    ...    ${cheque_eligible}
    ...    ${basket_id}
    ...    ${version}
    ...    ${user_id}
    ...    ${cell_number}
    ...    ${terminal_id}
    Set Test Variable    ${purchase_response}    ${response}

Offline Purchase Init Is Requested With Empty Body
    [Arguments]    ${terminal_id}=${EMPTY}
    # All arguments as empty values
    ${api_call_side}    Set Variable    ${MICROSERVICE_SIDE}
    ${credit_id}    Set Variable
    ${provider_id}    Generate Random String    15    123456789
    Set Test Variable    ${provider_id}
    ${amount}    Set Variable
    ${business_id}    Set Variable
    ${channel}    Set Variable
    ${seller_Id}    Set Variable
    ${supplier_id}    Set Variable
    ${product_code}    Set Variable
    ${brand}    Set Variable
    ${product_type}    Set Variable
    ${count}    Set Variable
    ${category_id}    Set Variable
    ${sub_category_ids}    Set Variable
    ${cheque_eligible}    Set Variable
    ${basket_id}    Set Variable
    ${version}    Set Variable
    ${user_id}    Set Variable
    ${cell_number}    Set Variable
    ${response}    POST Credit Purchases Init
    ...    ${api_call_side}
    ...    ${credit_id}
    ...    ${provider_id}
    ...    ${amount}
    ...    ${business_id}
    ...    ${channel}
    ...    ${seller_Id}
    ...    ${supplier_id}
    ...    ${product_code}
    ...    ${brand}
    ...    ${product_type}
    ...    ${count}
    ...    ${category_id}
    ...    ${sub_category_ids}
    ...    ${cheque_eligible}
    ...    ${basket_id}
    ...    ${version}
    ...    ${user_id}
    ...    ${cell_number}
    ...    ${terminal_id}
    Set Test Variable    ${purchase_response}    ${response}

Purchase Init Response Status Should Be
    [Arguments]    ${status}
    ${actual}    Convert To String    ${purchase_response.status_code}
    ${expected}    Convert To String    ${status}
    Should Be Equal    ${actual}    ${expected}

Offline Purchase Pay Is Requested With Null Tracking Code
    ${tracking_code}    Set Variable    ${EMPTY}
    ${random_string}    Generate Random String    15    123456789
    Set Test Variable    ${provider_id}    ${random_string}
    ${provider_id}    Generate Random String    15    123456789
    ${response}    POST Credit Purchases Pay
    ...    api_call_side=${MICROSERVICE_SIDE}
    ...    tracking_code=${tracking_code}
    ...    provider_id=${provider_id}
    Set Test Variable    ${pay_response}    ${response}

Purchase Pay Response Status Should Be
    [Arguments]    ${status}
    ${actual}    Convert To String    ${pay_response.status_code}
    ${expected}    Convert To String    ${status}
    Should Be Equal    ${actual}    ${expected}

Purchase Is Initialized Successfully With Cash Amount Equal To Zero
    [Arguments]    ${terminal_id}=${EMPTY}
    ${api_call_side}    Set Variable    ${MICROSERVICE_SIDE}
    ${credit_id}    Set Variable    ${credit_ids}[0]
    ${provider_id}    Generate Random String    15    123456789
    Set Test Variable    ${provider_id}
    ${amount}    Set Variable    ${DEFAULT_ALLOCATION_AMOUNT}
    ${business_id}    Set Variable    ${LMS_AUTOMATION_BUSINESS_ID}
    ${channel}    Set Variable    ${PAYMENT_CHANNEL}
    ${seller_Id}    Set Variable    SELLER-1
    ${supplier_id}    Set Variable    SUP-1
    ${product_code}    Set Variable    PROD-100
    ${brand}    Set Variable    MyBrand
    ${product_type}    Set Variable    1
    ${count}    Set Variable    1
    ${category_id}    Set Variable    CAT-10
    ${sub_category_ids}    Set Variable    [1,2]
    ${cheque_eligible}    Set Variable    True
    ${basket_id}    Set Variable
    ${basket_id}    Generate Random String    10    123456789
    ${version}    Set Variable    2025-01-26
    ${user_id}    Set Variable    ${user_id}
    ${cell_number}    Set Variable    ${cell_number}

    ${response}    POST Credit Purchases Init
    ...    ${api_call_side}
    ...    ${credit_id}
    ...    ${provider_id}
    ...    ${amount}
    ...    ${business_id}
    ...    ${channel}
    ...    ${seller_Id}
    ...    ${supplier_id}
    ...    ${product_code}
    ...    ${brand}
    ...    ${product_type}
    ...    ${count}
    ...    ${category_id}
    ...    ${sub_category_ids}
    ...    ${cheque_eligible}
    ...    ${basket_id}
    ...    ${version}
    ...    ${user_id}
    ...    ${cell_number}
    ...    ${terminal_id}
    Set Test Variable    ${purchase_response}    ${response}

Purchase Pay Step Was Completed Successfully
    [Arguments]    ${provider_id}=${provider_id}
    ${response}    POST Credit Purchases Pay
    ...    api_call_side=${MICROSERVICE_SIDE}
    ...    tracking_code=${purchase_response}[body][trackingCode]
    ...    provider_id=${provider_id}
    Set Test Variable    ${pay_response}    ${response}
    Status Should Be    200
    ${status}    Convert To String    ${pay_response.status_code}
    Should Be Equal As Strings    ${status}    200

Offline Purchase Cash Pay Result Is Requested With All Valid Data
    ${result_code}    Generate Random String    3    123456789
    Set Test Variable    ${result_code}
    ${confirmation_code}    Generate Random String    15    123456789
    Set Test Variable    ${confirmation_code}
    ${rrn}    Generate Random String    15    123456789
    Set Test Variable    ${rrn}
    ${terminal_id}    Generate Random String    7    123456789
    Set Test Variable    ${terminal_id}
    ${psp_code}    Generate Random String    1    123456789
    Set Test Variable    ${psp_code}
    ${masked_pan}    Generate Random String    15    123456789
    Set Test Variable    ${masked_pan}
    ${tracking_code}    Set Variable    ${purchase_response}[body][trackingCode]
    ${response}    POST Credit Prepayment Pay Cash Result
    ...    ${MICROSERVICE_SIDE}
    ...    ${tracking_code}
    ...    ${confirmation_code}
    ...    ${rrn}
    ...    ${terminal_id}
    ...    ${masked_pan}
    ...    ${psp_code}
    ...    ${result_code}
    Set Test Variable    ${cash_result_response}    ${response}

Cash Pay Result Response Status Should Be
    [Arguments]    ${status}
    ${actual}    Convert To String    ${cash_result_response.status_code}
    ${expected}    Convert To String    ${status}
    Should Be Equal As Strings    ${actual}    ${expected}

Offline Purchase Pay Is Requested With Empty Body
    ${tracking_code}    Set Variable
    ${random_string}    Generate Random String    15    123456789
    Set Test Variable    ${provider_id}    ${random_string}
    ${response}    POST Credit Purchases Pay
    ...    api_call_side=${MICROSERVICE_SIDE}
    ...    tracking_code=${tracking_code}
    ...    provider_id=${provider_id}
    Set Test Variable    ${pay_response}    ${response}

Offline Purchase Pay Is Requested With Missing TrackingCode
    [Arguments]    ${provider_id}=${provider_id}
    ${tracking_code}    Set Variable    ${EMPTY}
    ${response}    POST Credit Purchases Pay
    ...    api_call_side=${MICROSERVICE_SIDE}
    ...    tracking_code=${tracking_code}
    ...    provider_id=${provider_id}
    Set Test Variable    ${pay_response}    ${response}

Offline Purchase Pay Is Requested With Invalid TrackingCode
    [Arguments]    ${provider_id}=${provider_id}
    ${tracking_code}    Set Variable    123456789
    ${response}    POST Credit Purchases Pay
    ...    api_call_side=${MICROSERVICE_SIDE}
    ...    tracking_code=${tracking_code}
    ...    provider_id=${provider_id}
    Set Test Variable    ${pay_response}    ${response}

Offline Purchase Pay Is Requested With All Valid Data
    [Arguments]    ${provider_id}=${provider_id}
    ${tracking_code}    Set Variable    ${purchase_response}[body][trackingCode]
    ${response}    POST Credit Purchases Pay
    ...    api_call_side=${MICROSERVICE_SIDE}
    ...    tracking_code=${tracking_code}
    ...    provider_id=${provider_id}
    Set Test Variable    ${pay_response}    ${response}

Call Schedule Close API
    [Documentation]    Checks if the response status code is 200
    [Arguments]    ${credit_id}=${credit_ids}[0]
    ${schedule_close_response}    Post Credit Accounts Schedule Close
    ...    ${MICROSERVICE_SIDE}
    ...    ${credit_ids}[0]
    ...    ${LMS_BLOCK_REASON.ORGANIZATION_REQUEST}
    ...    ${DASHBOARD_USERNAME}
    Set Test Variable    ${schedule_close_response}
