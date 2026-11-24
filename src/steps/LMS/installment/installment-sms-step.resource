*** Settings ***
Library         library/faker_utils.py    WITH NAME    FakerLibrary
Library         RequestsLibrary
Library         Collections
Library         OperatingSystem
Library         String
Library         DateTime
Library         library/installment_date_utils.py
Resource        services/db/mongo-db-service.resource
Resource        services/backend/import-allocation.resource
Resource        services/backend/user-wallet-initializer-service.resource
Resource        apis/lms/credit-core/post-credit-gateway-activate.resource
Resource        apis/lms/credit-core/post-credit-gateways-disable.resource
Resource        apis/lms/credit-core/post-admin-credit-accounts-block.resource
Resource        services/backend/value-handler.resource
Resource        services/backend/LMS/credit-core/close-account.resource
Variables       data/CONSTANTS.yaml


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

Allocate Fee On Purchase BNPL Account
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

    # ${cell_number}    Set Variable    09966022116
    # ${user_id}    Set Variable    816f6cd5-c5cf-4a63-a9a5-e2880370b384
    # ${credit_ids}    Create List    7654742761752999785392
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

The Payment Gateway Is Set To BPG
    Set Test Variable    ${PAYMENT_GATEWAY}    ${LMS_PAYMENT_GATEWAY.BPG}

The Payment Gateway Is Set To CPG
    Set Test Variable    ${PAYMENT_GATEWAY}    ${LMS_PAYMENT_GATEWAY.CPG}

The Channel Is Set To Linux POS
    Set Test Variable    ${PAYMENT_CHANNEL}    ${CHANNEL.LINUX_POS}

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

Complete A Purchase
    [Arguments]
    ...    ${user_id}=${user_id}
    ...    ${credit_id}=${credit_ids}[0]
    ${skip}    Create List    deliver

    ${tracking_code}    Perform A Complete Offline Purchase
    ...    user_id=${user_id}
    ...    credit_id=${credit_id}
    ...    skip=${skip}

    Set Test Variable    ${tracking_code}

Set Notification Days
    [Arguments]    ${day}=0
    ${current_date}    Get Current Date    result_format=epoch
    ${due_date}    Add Time To Date    ${current_date}    ${day} days    epoch
    ${due_date}    Evaluate    int(${due_date} * 1000)
    Set Test Variable    ${due_date}

Change End Date Of Billing Cycle To Due Date
    [Arguments]    ${credit_id}=${credit_ids}[0]    ${purchaseTrackingCodes}=${tracking_code}
    ${current_date}    Get Time    epoch
    ${yesterday}    Add Time To Date    ${current_date}    -1 days    epoch
    ${yesterday}    Evaluate    int(${yesterday} * 1000)
    ${filter_query}    Create Dictionary    creditId=${credit_id}    status=${0}
    ${update_value}    Create Dictionary    endDate=${yesterday}
    ${update_query}    Create Dictionary    $set=${update_value}
    ${billing_cycle_result}    Mongo Db Update One
    ...    credit_mng_db
    ...    billing_cycles
    ...    ${filter_query}
    ...    ${update_query}
    ${find_filter_query}    Create Dictionary    creditId=${credit_id}    purchaseTrackingCodes=${purchaseTrackingCodes}
    ${billing_cycles}    Mongo Db Find
    ...    credit_mng_db
    ...    billing_cycles
    ...    ${find_filter_query}
    Should Be Equal As Numbers    ${billing_cycles['body'][0]['status']}    1

Make Scheduler Enable for Due Date Reminder SMS
    [Documentation]    Delete row in mysql database installment_db.notification_creation_jobs where modification_date is little than today date like ( 2025-07-21 16:17:38 )
    [Arguments]    ${user_id}=${user_id}
    ${current_date}    Get Current Date    result_format=%Y-%m-%d %H:%M:%S
    ${current_date_YY_MM_DD}    Get Current Date    result_format=%Y-%m-%d
    ${notifications}    MySQL Fetch All
    ...    db_name=installment_db
    ...    query=SELECT * FROM notifications WHERE user_id = '${user_id}' AND creation_date = '${current_date_YY_MM_DD}'
    IF    ${notifications}[body] != []
        ${body_list}    Get From Dictionary    ${notifications}    body
        FOR    ${notification}    IN    @{body_list}
            ${notification_id}    Set Variable    ${notification['id']}
            MySQL Execute Query
            ...    db_name=installment_db
            ...    query=DELETE FROM notification_details WHERE notification_id = ${notification_id}
            MySQL Execute Query
            ...    db_name=installment_db
            ...    query=DELETE FROM notification WHERE user_id = '${user_id}' AND creation_date = '${current_date_YY_MM_DD}'
        END
    END
    MySQL Execute Query
    ...    db_name=installment_db
    ...    query=DELETE FROM notification_creation_jobs WHERE modification_date < '${current_date}'
Make User Account Ready To Be Validated For Total Debt of Multiple Contracts
    [Arguments]    ${type}
    Complete A Purchase
    Wait Until Keyword Succeeds    360s    5s    Change End Date Of Billing Cycle To Due Date
    Complete A Purchase
    Make User Account Ready To Send Reminder SMS    type=${type}


Make User Account Ready To Be Validated
    [Arguments]
    ...    ${type}
    ...    ${sms_type}
    ...    ${user_id}=${user_id}
    ...    ${credit_id}=${credit_ids}[0]
    ...    ${due_date}=${due_date}
    IF    '${type}' != '${LMS_Account_Type_CREDIT}'
        Wait Until Keyword Succeeds    360s    5s    Change End Date Of Billing Cycle To Due Date
    END
    ${user_installment_account}    MySQL Fetch All
    ...    db_name=installment_db
    ...    query=SELECT * FROM accounts WHERE credit_id = ${credit_id}
    Set Test Variable    ${user_installment_account}
    ${account_id}    Set Variable    ${user_installment_account}[body][0][id]
    IF    ${user_installment_account}[body] == []
        Fail    User installment account is not found for credit_id ${credit_id}
    ELSE
         IF    '${type}' == '${LMS_Account_Type_CREDIT}'
            ${installment_redis_cache}    Get File    ./src/data/lms/installment_redis_cache.json
            Set Test Variable    ${installment_redis_cache}
            ${dict}    Evaluate    __import__('json').loads('''${installment_redis_cache}''')
            ${now}    Get Current Date    result_format=epoch
            ${now_int}    Evaluate    int(${now} * 1000)
            Set To Dictionary    ${dict}    expirationDate=${now_int}
            
            
            Set To Dictionary
            ...    dictionary=${dict['tejaratInquiry']}
            ...    facilityId=${user_installment_account}[body][0][external_contract_number]
            IF    'before3' in $sms_type
                ${next_month_iso}    Get Current Date    result_format=%Y-%m-%dT%H:%M:%S    increment=+3 days
                Set To Dictionary    ${dict['tejaratInquiry']['tejaratInstallments'][0]}    effectiveDate=${next_month_iso}
            ELSE IF    'before5' in $sms_type
                ${next_month_iso}    Get Current Date    result_format=%Y-%m-%dT%H:%M:%S    increment=+5 days
                Set To Dictionary    ${dict['tejaratInquiry']['tejaratInstallments'][0]}    effectiveDate=${next_month_iso}
            ELSE IF    'follow.up' in $sms_type
                ${next_month_iso}    Get Current Date    result_format=%Y-%m-%dT%H:%M:%S    increment=-8 days
                Set To Dictionary    ${dict['tejaratInquiry']['tejaratInstallments'][0]}    effectiveDate=${next_month_iso}            
            ELSE
                ${now_iso}    Get Current Date    result_format=%Y-%m-%dT%H:%M:%S  
                Set To Dictionary    ${dict['tejaratInquiry']['tejaratInstallments'][0]}    effectiveDate=${now_iso}
            END
            IF    'total.debt' in $sms_type
                ${last_month_iso}    Get Current Date    result_format=%Y-%m-%dT%H:%M:%S    increment=-60 days
                Set To Dictionary    ${dict['tejaratInquiry']['tejaratInstallments'][1]}    effectiveDate=${last_month_iso}
            END
            
            ${new_json}    Evaluate    __import__('json').dumps(${dict})
            ${redis_key}    Set Variable    inst_tej_inqry_${user_installment_account}[body][0][external_contract_number]
            Redis Delete Key    ${redis_key}    master_name=standalone
            Redis Set Key    ${redis_key}    ${new_json}    master_name=standalone
        END
    END
    Set Test Variable    ${account_id}
    ${contract_result}    MySQL Execute Query
    ...    db_name=installment_db
    ...    query=UPDATE contracts SET report_state = 0 , start_date = ${due_date} WHERE account_id = ${account_id} AND status = 1
    ${affected_rows}    Set Variable    ${contract_result}[body][affected_rows]
    IF    ${affected_rows}<1
        Fail    Contract report_state is not updated to 2
    END

Make User Account Ready To Send Reminder SMS
    [Arguments]    ${type}    ${sms_type}=NONE    ${due_date}=${due_date}
    Wait Until Keyword Succeeds    120s    5s    Make User Account Ready To Be Validated    ${type}    ${sms_type}

Get Payment Order Report Amount
    [Arguments]        ${claim_type}=2    ${contract_id}=${contract_result}
    # @{contract_ids}    Evaluate    [item['id'] for item in response['body']]    response=${contract_id}
    @{items}    Get From Dictionary    ${contract_id}    body
    @{contract_ids}=    Create List
    FOR    ${item}    IN    @{items}
        ${this_id}=    Get From Dictionary    ${item}    id
        Append To List    ${contract_ids}    ${this_id}
    END
    ${contract_ids}    Catenate    SEPARATOR=,    @{contract_ids}  
    ${query}     Set Variable    contract_id in (${contract_ids})
    ${payment_order_reports}    MySQL Fetch All
    ...    db_name=installment_db
    ...    query=SELECT * FROM payment_order_reports WHERE ${query} and claim_type in (${claim_type})
    Set Test Variable    ${payment_order_reports}
    IF    ${payment_order_reports}[body]==[]    Fail

Customize The Due Date Reminder SMS Content For User Account
    [Arguments]
    ...    ${sms_type}
    IF    'credit' in $sms_type
        @{items}    Get From Dictionary    ${payment_order_reports}    body
        ${total_debt_amount}    Set Variable    0
        ${debt_amount}    Set Variable    0
        FOR    ${item}    IN    @{items}
            IF    'grace.period.single.total.debt' in $sms_type
                ${claim_type}=    Get From Dictionary    ${item}    claim_type 
                IF    $claim_type == 2
                    ${debt_amount}    Get From Dictionary    ${item}    remaining_amount
                    ${penalty_amount}    Get From Dictionary    ${item}    remaining_penalty_amount
                    IF    ${penalty_amount} != 0
                        ${debt_amount}    Evaluate    ${debt_amount} - ${penalty_amount}
                    END
                    
                END
            ELSE IF    'grace.period.total.total.debt' in $sms_type
                ${claim_type}=    Get From Dictionary    ${item}    claim_type  
                IF    $claim_type == 3
                    ${amount}    Get From Dictionary    ${item}    remaining_amount 
                    ${debt_amount}    Evaluate    ${debt_amount} + ${amount}
                    ${penalty_amount}    Get From Dictionary    ${item}    remaining_penalty_amount
                    IF    ${penalty_amount} != 0
                        ${debt_amount}    Evaluate    ${debt_amount} - ${penalty_amount}
                    END
                END 
            ELSE IF    'due.date.single.total.debt' in $sms_type
                ${claim_type}=    Get From Dictionary    ${item}    claim_type  
                IF    $claim_type == 3
                    ${debt_amount}    Get From Dictionary    ${item}    remaining_amount
                    ${penalty_amount}    Get From Dictionary    ${item}    remaining_penalty_amount
                    IF    ${penalty_amount} != 0
                        ${debt_amount}    Evaluate    ${debt_amount} - ${penalty_amount}
                    END
                END
            ELSE IF    'due.date.total.total.debt' in $sms_type
                ${claim_type}=    Get From Dictionary    ${item}    claim_type  
                IF    $claim_type == 3
                    ${amount}    Get From Dictionary    ${item}    remaining_amount 
                    ${debt_amount}    Evaluate    ${debt_amount} + ${amount}
                    ${penalty_amount}    Get From Dictionary    ${item}    remaining_penalty_amount
                    IF    ${penalty_amount} != 0
                        ${debt_amount}    Evaluate    ${debt_amount} - ${penalty_amount}
                    END
                END 
            ELSE IF    'due.date.credit.single.total.debt' in $sms_type
                ${claim_type}=    Get From Dictionary    ${item}    claim_type 
                IF    $claim_type == 2
                    ${debt_amount}    Get From Dictionary    ${item}    remaining_amount
                    ${penalty_amount}    Get From Dictionary    ${item}    remaining_penalty_amount
                    IF    ${penalty_amount} != 0
                        ${debt_amount}    Evaluate    ${debt_amount} - ${penalty_amount}
                    END
                END
            END
            ${amt}    Get From Dictionary    ${item}    remaining_amount
            ${total_debt_amount}    Evaluate    ${total_debt_amount} + ${amt}   
        END
        IF    'before3.due.date.single' in "${sms_type}" or 'before5.due.date.single' in "${sms_type}"
            ${total_debt_amount}    Get From Dictionary    ${items}[0]    remaining_amount
            ${installment_effective_date}    Get From Dictionary    ${items}[0]    effective_date
            ${ts_int}          Evaluate    int(${installment_effective_date}) / 1000
            ${jdt}    Evaluate    __import__('jdatetime').datetime.fromtimestamp(${ts_int}).strftime('%Y/%m/%d')
            ${next_month_iso}    Convert effective date To Persian Digit    ${jdt}
        END
        ${total_debt_amount}    Convert To String    ${total_debt_amount}
        ${total_debt_amount}    Evaluate    "{:,}".format(${total_debt_amount})
        ${total_debt_amount_persian_character}    Convert To Persian Digit    ${total_debt_amount}
        IF    $debt_amount != 0
            ${debt_amount}    Convert To String    ${debt_amount}
            ${debt_amount}    Evaluate    "{:,}".format(${debt_amount})
            ${debt_amount_persian_character}    Convert To Persian Digit    ${debt_amount}
        END
    END
    

    IF    '${sms_type}'=='bnpl.reminder.follow.up.with.penalty.single'
        ${sms_content}    Catenate    SEPARATOR=\n
        # ...    تاخیر در پرداخت بدهی
        ...    دیرکرد بدهی کمپانی‌پی
        ...
        ...    کاربر عزیز، لینک جهت پرداخت:
        # ...    کاربر گرامی
        # ...    مبلغ قسط پرداخت نشده شما ${total_debt_amount_persian_character} ریال است.
        # ...    لطفا برای جلوگیری از جریمه روز شمار بیشتر، بدهی خود را در اسرع وقت پرداخت کنید.
        # ...
        ...   dgpay.ir/yASAR2
        # ...    شماره پشتیبانی: ۰۲۱۵۳۹۲۴۰۰۰
        # ...
        # ...    درصورتی که تا قبل از دریافت پیامک بدهی خود را پرداخت کرده اید این پیام را نادیده بگیرید.
        # ...
        # ...    کمپانی‌پی
    ELSE IF    '${sms_type}'=='bnpl.reminder.follow.up.with.penalty.total'
        ${sms_content}    Catenate    SEPARATOR=\n
        # ...    تاخیر در پرداخت بدهی
        ...    دیرکرد بدهی کمپانی‌پی
        ...
        ...    کاربر عزیز، لینک جهت پرداخت:
        # ...
        # ...    کاربر گرامی
        # ...    مبلغ اقساط پرداخت نشده شما ${total_debt_amount_persian_character} ریال است.
        # ...    لطفا برای جلوگیری از جریمه روز شمار بیشتر، بدهی خود را در اسرع وقت پرداخت کنید.
        # ...
        ...   dgpay.ir/yASAR2
        # ...    شماره پشتیبانی: ۰۲۱۵۳۹۲۴۰۰۰
        # ...
        # ...    درصورتی که تا قبل از دریافت پیامک بدهی خود را پرداخت کرده اید این پیام را نادیده بگیرید.
        # ...
        # ...    کمپانی‌پی
    ELSE IF    '${sms_type}'=='bnpl.reminder.follow.up.with.penalty.single.total.debt'
        ${sms_content}    Catenate    SEPARATOR=\n
        # ...    تاخیر در پرداخت بدهی
        ...    دیرکرد بدهی کمپانی‌پی
        ...
        ...    کاربر عزیز، لینک جهت پرداخت:
        # ...
        # ...    کاربر گرامی
        # ...    مبلغ قسط پرداخت نشده شما ${total_debt_amount_persian_character} ریال است.
        # ...    با احتساب قسط جدید، مجموع کل اقساط پرداخت نشده شما تاکنون ${total_debt_amount_persian_character} ریال است.
        # ...    لطفا برای جلوگیری از جریمه روز شمار بیشتر، بدهی خود را در اسرع وقت پرداخت کنید.
        # ...
        ...   dgpay.ir/yASAR2
        # ...    شماره پشتیبانی: ۰۲۱۵۳۹۲۴۰۰۰
        # ...
        # ...    درصورتی که تا قبل از دریافت پیامک بدهی خود را پرداخت کرده اید این پیام را نادیده بگیرید.
        # ...
        # ...    کمپانی‌پی
    ELSE IF    '${sms_type}'=='bnpl.reminder.follow.up.with.penalty.total.total.debt'
        ${sms_content}    Catenate    SEPARATOR=\n
        # ...    تاخیر در پرداخت بدهی
        ...    دیرکرد بدهی کمپانی‌پی
        ...
        ...    کاربر عزیز، لینک جهت پرداخت:
        # ...
        # ...    کاربر گرامی
        # ...    مبلغ قسط پرداخت نشده شما ${total_debt_amount_persian_character} ریال است.
        # ...    با احتساب قسط جدید، مجموع کل اقساط پرداخت نشده شما تاکنون ${total_debt_amount_persian_character} ریال است.
        # ...    لطفا برای جلوگیری از جریمه روز شمار بیشتر، بدهی خود را در اسرع وقت پرداخت کنید.
        # ...
        ...   dgpay.ir/yASAR2
        # ...    شماره پشتیبانی: ۰۲۱۵۳۹۲۴۰۰۰
        # ...
        # ...    درصورتی که تا قبل از دریافت پیامک بدهی خود را پرداخت کرده اید این پیام را نادیده بگیرید.
        # ...
        # ...    کمپانی‌پی
    ELSE IF    '${sms_type}'=='bnpl.reminder.grace.period.single'
        ${sms_content}    Catenate    SEPARATOR=\n
        # ...    فرصت پرداخت بدون جریمه بدهی
        ...   یادآوری بدهی کمپانی‌پی
        ...    
        ...    کاربر عزیز، لینک جهت پرداخت:
        # ...
        # ...    کاربر گرامی
        # ...    مبلغ قسط شما ${total_debt_amount_persian_character} ریال است.
        # ...
        ...   dgpay.ir/yASAR2
        # ...    شماره پشتیبانی: ۰۲۱۵۳۹۲۴۰۰۰
        # ...
        # ...    درصورتی که تا قبل از دریافت پیامک بدهی خود را پرداخت کرده اید این پیام را نادیده بگیرید.
        # ...
        # ...    کمپانی‌پی
    ELSE IF    '${sms_type}'=='bnpl.reminder.grace.period.total'
        ${sms_content}    Catenate    SEPARATOR=\n
        # ...    فرصت پرداخت بدون جریمه بدهی
        ...   یادآوری بدهی کمپانی‌پی
        ...    
        ...    کاربر عزیز، لینک جهت پرداخت:
        # ...
        # ...    کاربر گرامی
        # ...    مبلغ اقساط شما ${total_debt_amount_persian_character} ریال است.
        # ...
        ...   dgpay.ir/yASAR2
        # ...    شماره پشتیبانی: ۰۲۱۵۳۹۲۴۰۰۰
        # ...
        # ...    درصورتی که تا قبل از دریافت پیامک بدهی خود را پرداخت کرده اید این پیام را نادیده بگیرید.
        # ...
        # ...    کمپانی‌پی
    ELSE IF    '${sms_type}'=='bnpl.reminder.grace.period.single.total.debt'
        ${sms_content}    Catenate    SEPARATOR=\n
        # ...    فرصت پرداخت بدون جریمه بدهی
        ...   یادآوری بدهی کمپانی‌پی
        ...    
        ...    کاربر عزیز، لینک جهت پرداخت:
        # ...
        # ...    کاربر گرامی
        # ...    مبلغ قسط سررسید شده جدید شما ${debt_amount_persian_character} ریال است.
        # ...    با احتساب قسط جدید، مجموع کل اقساط پرداخت نشده شما تاکنون ${total_debt_amount_persian_character} ریال است.
        # ...
        ...   dgpay.ir/yASAR2
        # ...    شماره پشتیبانی: ۰۲۱۵۳۹۲۴۰۰۰
        # ...
        # ...    درصورتی که تا قبل از دریافت پیامک بدهی خود را پرداخت کرده اید این پیام را نادیده بگیرید.
        # ...
        # ...    کمپانی‌پی
    ELSE IF    '${sms_type}'=='bnpl.reminder.grace.period.total.total.debt'
        ${sms_content}    Catenate    SEPARATOR=\n
        # ...    فرصت پرداخت بدون جریمه بدهی
        ...   یادآوری بدهی کمپانی‌پی
        ...    
        ...    کاربر عزیز، لینک جهت پرداخت:
        # ...
        # ...    کاربر گرامی
        # ...    مبلغ اقساط سررسید شده جدید شما ${debt_amount_persian_character} ریال است. 
        # ...    با احتساب قسط جدید، مجموع کل اقساط پرداخت نشده شما تا کنون ${total_debt_amount_persian_character} ریال است.
        # ...
        ...   dgpay.ir/yASAR2
        # ...    شماره پشتیبانی: ۰۲۱۵۳۹۲۴۰۰۰
        # ...
        # ...    درصورتی که تا قبل از دریافت پیامک بدهی خود را پرداخت کرده اید این پیام را نادیده بگیرید.
        # ...
        # ...    کمپانی‌پی
    ELSE IF    '${sms_type}'=='bnpl.reminder.end.of.grace.period.single'
        ${sms_content}    Catenate    SEPARATOR=\n
        # ...    آخرین مهلت پرداخت بدون جریمه
        ...   یادآوری بدهی کمپانی‌پی
        ...    
        ...    کاربر عزیز، لینک جهت پرداخت:
        # ...
        # ...    کاربر گرامی
        # ...    مبلغ قسط شما ${total_debt_amount_persian_character} ریال است.
        # ...
        ...   dgpay.ir/yASAR2
        # ...    شماره پشتیبانی: ۰۲۱۵۳۹۲۴۰۰۰
        # ...
        # ...    درصورتی که تا قبل از دریافت پیامک بدهی خود را پرداخت کرده اید این پیام را نادیده بگیرید.
        # ...
        # ...    کمپانی‌پی
    ELSE IF    '${sms_type}'=='bnpl.reminder.end.of.grace.period.total'
        ${sms_content}    Catenate    SEPARATOR=\n
        # ...    آخرین مهلت پرداخت بدون جریمه
        ...   یادآوری بدهی کمپانی‌پی
        ...    
        ...    کاربر عزیز، لینک جهت پرداخت:
        # ...
        # ...    کاربر گرامی
        # ...    مبلغ اقساط شما ${total_debt_amount_persian_character} ریال است.
        # ...
        ...   dgpay.ir/yASAR2
        # ...    شماره پشتیبانی: ۰۲۱۵۳۹۲۴۰۰۰
        # ...
        # ...    درصورتی که تا قبل از دریافت پیامک بدهی خود را پرداخت کرده اید این پیام را نادیده بگیرید.
        # ...
        # ...    کمپانی‌پی
    ELSE IF    '${sms_type}'=='bnpl.reminder.end.of.grace.period.single.total.debt'
        ${sms_content}    Catenate    SEPARATOR=\n
        # ...    آخرین مهلت پرداخت بدون جریمه
        ...   یادآوری بدهی کمپانی‌پی
        ...    
        ...    کاربر عزیز، لینک جهت پرداخت:
        # ...
        # ...    کاربر گرامی
        # ...    مبلغ قسط سررسید شده جدید شما ${debt_amount_persian_character} ریال است.
        # ...    با احتساب قسط جدید، مجموع کل اقساط پرداخت نشده شما تاکنون ${total_debt_amount_persian_character} ریال است.
        # ...
        ...   dgpay.ir/yASAR2
        # ...    شماره پشتیبانی: ۰۲۱۵۳۹۲۴۰۰۰
        # ...
        # ...    درصورتی که تا قبل از دریافت پیامک بدهی خود را پرداخت کرده اید این پیام را نادیده بگیرید.
        # ...
        # ...    کمپانی‌پی
    ELSE IF    '${sms_type}'=='bnpl.reminder.end.of.grace.period.total.total.debt'
        ${sms_content}    Catenate    SEPARATOR=\n
        # ...    آخرین مهلت پرداخت بدون جریمه
        ...   یادآوری بدهی کمپانی‌پی
        ...    
        ...    کاربر عزیز، لینک جهت پرداخت:
        # ...
        # ...    کاربر گرامی
        # ...    مبلغ اقساط سررسید شده جدید شما ${debt_amount_persian_character} ریال است.
        # ...    با احتساب قسط جدید، مجموع کل اقساط پرداخت نشده شما تاکنون ${total_debt_amount_persian_character} ریال است.
        # ...
        ...   dgpay.ir/yASAR2
        # ...    شماره پشتیبانی: ۰۲۱۵۳۹۲۴۰۰۰
        # ...
        # ...    درصورتی که تا قبل از دریافت پیامک بدهی خود را پرداخت کرده اید این پیام را نادیده بگیرید.
        # ...
        # ...    کمپانی‌پی
    ELSE IF    '${sms_type}'=='bnpl.reminder.due.date.single'
        ${sms_content}    Catenate    SEPARATOR=\n
        # ...    سررسید پرداخت بدهی
        ...   سررسید بدهی کمپانی‌پی
        ...    
        ...    کاربر عزیز، لینک جهت پرداخت:
        # ...
        # ...    کاربر گرامی
        # ...    مبلغ قسط سررسید شده شما ${total_debt_amount_persian_character} ریال است.
        # ...
        ...   dgpay.ir/yASAR2
        # ...    شماره پشتیبانی: ۰۲۱۵۳۹۲۴۰۰۰
        # ...
        # ...    درصورتی که تا قبل از دریافت پیامک بدهی خود را پرداخت کرده اید این پیام را نادیده بگیرید.
        # ...
        # ...    کمپانی‌پی
    ELSE IF    '${sms_type}'=='bnpl.reminder.due.date.total'
        ${sms_content}    Catenate    SEPARATOR=\n
        # ...    سررسید پرداخت بدهی
        ...   سررسید بدهی کمپانی‌پی
        ...    
        ...    کاربر عزیز، لینک جهت پرداخت:
        # ...
        # ...    کاربر گرامی
        # ...    مبلغ اقساط سررسید شده شما ${total_debt_amount_persian_character} ریال است.
        # ...
        ...   dgpay.ir/yASAR2
        # ...    شماره پشتیبانی: ۰۲۱۵۳۹۲۴۰۰۰
        # ...
        # ...    درصورتی که تا قبل از دریافت پیامک بدهی خود را پرداخت کرده اید این پیام را نادیده بگیرید.
        # ...
        # ...    کمپانی‌پی
    ELSE IF    '${sms_type}'=='bnpl.reminder.due.date.single.total.debt'
        ${sms_content}    Catenate    SEPARATOR=\n
        # ...    سررسید پرداخت بدهی
        ...   سررسید بدهی کمپانی‌پی
        ...    
        ...    کاربر عزیز، لینک جهت پرداخت:
        # ...
        # ...    کاربر گرامی
        # ...    مبلغ قسط سررسید شده جدید شما ${debt_amount_persian_character}ریال است.
        # ...    با احتساب قسط جدید، مجموع کل اقساط پرداخت نشده شما تا کنون ${total_debt_amount_persian_character} ریال است.
        # ...
        ...   dgpay.ir/yASAR2
        # ...    شماره پشتیبانی: ۰۲۱۵۳۹۲۴۰۰۰
        # ...
        # ...    درصورتی که تا قبل از دریافت پیامک بدهی خود را پرداخت کرده اید این پیام را نادیده بگیرید.
        # ...
        # ...    کمپانی‌پی
    ELSE IF    '${sms_type}'=='bnpl.reminder.due.date.total.total.debt'
        ${sms_content}    Catenate    SEPARATOR=\n
        # ...    سررسید پرداخت بدهی
        ...   سررسید بدهی کمپانی‌پی
        ...    
        ...    کاربر عزیز، لینک جهت پرداخت:
        # ...
        # ...    کاربر گرامی
        # ...    مبلغ اقساط سررسید شده جدید شما ${debt_amount_persian_character}ریال است.
        # ...    با احتساب قسط جدید، مجموع کل اقساط پرداخت نشده شما تا کنون ${total_debt_amount_persian_character} ریال است.
        # ...
        ...   dgpay.ir/yASAR2
        # ...    شماره پشتیبانی: ۰۲۱۵۳۹۲۴۰۰۰
        # ...
        # ...    درصورتی که تا قبل از دریافت پیامک بدهی خود را پرداخت کرده اید این پیام را نادیده بگیرید.
        # ...
        # ...    کمپانی‌پی
    ELSE IF    '${sms_type}'=='credit.reminder.before3.due.date.single'
        ${sms_content}    Catenate    SEPARATOR=\n
        ...    تسویه زودتر از موعد وام بانک تجارت
        ...
        ...    کاربر گرامی
        ...    قسط بعدی شما به مبلغ ${total_debt_amount_persian_character} ریال ۳ روز دیگر سررسید می شود.با تسویه زودتر جز مشتریان خوش حساب کمپانی‌پی باشید.
        ...    تاریخ سررسید:${next_month_iso}
        ...
        ...    مشاهده و پرداخت: dgpay.ir/fh4dm9
        ...    شماره پشتیبانی:۰۲۱۵۳۹۲۴۰۰۰
        ...    
        # ...    درصورتی که تا قبل از دریافت پیامک بدهی خود را پرداخت کرده اید این پیام را نادیده بگیرید.
        # ...
        ...    کمپانی‌پی
    ELSE IF    '${sms_type}'=='credit.reminder.before5.due.date.single'
        ${sms_content}    Catenate    SEPARATOR=\n
        ...    تسویه زودتر از موعد وام بانک تجارت
        ...
        ...    کاربر گرامی
        ...    قسط بعدی شما به مبلغ ${total_debt_amount_persian_character} ریال به زودی سررسید می شود.با تسویه زودتر جز مشتریان خوش حساب کمپانی‌پی باشید.
        ...    تاریخ سررسید:${next_month_iso}
        ...
        ...    مشاهده و پرداخت: dgpay.ir/fh4dm9
        ...    شماره پشتیبانی:۰۲۱۵۳۹۲۴۰۰۰
        # ...
        # ...    درصورتی که تا قبل از دریافت پیامک بدهی خود را پرداخت کرده اید این پیام را نادیده بگیرید.
        ...
        ...    کمپانی‌پی
    ELSE IF    '${sms_type}'=='credit.reminder.due.date.single'
        ${sms_content}    Catenate    SEPARATOR=\n
        ...    سررسید وام بانک تجارت
        ...
        ...    کاربر گرامی
        ...    مبلغ قسط سررسید شده شما ${total_debt_amount_persian_character} ریال است.
        ...
        ...    مشاهده و پرداخت: dgpay.ir/fh4dm9
        ...    شماره پشتیبانی: ۰۲۱۵۳۹۲۴۰۰۰
        ...
        ...    درصورتی که تا قبل از دریافت پیامک بدهی خود را پرداخت کرده اید این پیام را نادیده بگیرید.
        ...
        ...    کمپانی‌پی
    ELSE IF    '${sms_type}'=='credit.reminder.due.date.credit.single.total.debt.credit'
        ${sms_content}    Catenate    SEPARATOR=\n
        ...    سررسید وام بانک تجارت
        ...
        ...    کاربر گرامی
        ...    مبلغ قسط سررسید شده جدید شما ${debt_amount_persian_character}ریال است.
        ...    با احتساب قسط جدید، مجموع کل اقساط پرداخت نشده شما تا کنون ${total_debt_amount_persian_character} ریال است.
        ...
        ...    مشاهده و پرداخت: dgpay.ir/fh4dm9
        ...    شماره پشتیبانی: ۰۲۱۵۳۹۲۴۰۰۰
        ...
        ...    درصورتی که تا قبل از دریافت پیامک بدهی خود را پرداخت کرده اید این پیام را نادیده بگیرید.
        ...
        ...    کمپانی‌پی
    ELSE IF    '${sms_type}'=='credit.reminder.follow.up.total.debt'
        ${sms_content}    Catenate    SEPARATOR=\n
        ...    تاخیر در پرداخت وام بانک تجارت
        ...
        ...    کاربر گرامی
        ...    مبلغ اقساط پرداخت نشده شما ${total_debt_amount_persian_character} ریال است.
        ...    لطفا برای جلوگیری از جریمه روز شمار بیشتر، بدهی خود را در اسرع وقت پرداخت کنید.
        ...
        ...    مشاهده و پرداخت: dgpay.ir/fh4dm9
        ...    شماره پشتیبانی: ۰۲۱۵۳۹۲۴۰۰۰
        ...
        ...    درصورتی که تا قبل از دریافت پیامک بدهی خود را پرداخت کرده اید این پیام را نادیده بگیرید.
        ...
        ...    کمپانی‌پی
    ELSE IF    '${sms_type}'=='credit.reminder.follow.up.single'
        ${sms_content}    Catenate    SEPARATOR=\n
        ...    تاخیر در پرداخت وام بانک تجارت
        ...
        ...    کاربر گرامی
        ...    مبلغ قسط پرداخت نشده شما ${total_debt_amount_persian_character} ریال است.
        ...    لطفا برای جلوگیری از جریمه روز شمار بیشتر، بدهی خود را در اسرع وقت پرداخت کنید.
        ...
        ...    مشاهده و پرداخت: dgpay.ir/fh4dm9
        ...    شماره پشتیبانی: ۰۲۱۵۳۹۲۴۰۰۰
        ...
        ...    درصورتی که تا قبل از دریافت پیامک بدهی خود را پرداخت کرده اید این پیام را نادیده بگیرید.
        ...
        ...    کمپانی‌پی    
    END

    Set Test Variable    ${sms_content}

Check Contract Report State is 2
    [Arguments]    ${account_id}=${account_id}
    ${contract_result}    MySQL Fetch All
    ...    db_name=installment_db
    ...    query=SELECT * FROM contracts WHERE account_id = ${account_id}
    Set Test Variable    ${contract_result}
    Should Be Equal As Integers
    ...    first=${contract_result}[body][0][report_state]
    ...    second=2

Check Create Notification Is Exist
    [Arguments]    ${user_id}=${user_id}
    ${today}    Get Current Date    result_format=%Y-%m-%d
    Log To Console    twenty
    ${create_notification_result}    MySQL Fetch All
    ...    db_name=installment_db
    ...    query=SELECT * FROM notification_creation_jobs WHERE creation_date = '${today}' 
    Set Test Variable    ${create_notification_result}
    Should Be Equal As Integers
    ...    first=${create_notification_result}[body][0][status]
    ...    second=1
    
Check Notification Is Exist
    [Arguments]    ${user_id}=${user_id}
    ${today}    Get Current Date    result_format=%Y-%m-%d
    ${notification_result}    MySQL Fetch All
    ...    db_name=installment_db
    ...    query=SELECT * FROM notifications WHERE creation_date = '${today}' AND user_id = '${user_id}'
    Set Test Variable    ${notification_result}
    Should Not Be Empty    ${notification_result}[body]

Check Notification Details Is Exist
    [Arguments]    ${notification_result}=${notification_result}
    ${notification_id}    Set Variable    ${notification_result}[body][0][id]
    ${notification_detail}    MySQL Fetch All
    ...    db_name=installment_db
    ...    query=SELECT * FROM notification_details WHERE notification_id = ${notification_id}
    Set Test Variable    ${notification_detail}
    IF    ${notification_detail}[body]==[]    Fail

Check The SMS Content
    [Arguments]
    ...    ${sms_type}
    ...    ${claim_type}
    Wait Until Keyword Succeeds    360s    5s    Get Payment Order Report Amount    ${claim_type}
    Customize The Due Date Reminder SMS Content For User Account    ${sms_type}
    Should Be Equal As Strings
    ...    first=${notification_detail}[body][0][content]
    ...    second=${sms_content}

Check The SMS Is Sent To User
    [Arguments]
    ...    ${user_id}=${user_id}
    Wait Until Keyword Succeeds    560s    5s    Check Contract Report State is 2
    Wait Until Keyword Succeeds    460s    5s    Check create Notification Is Exist
    Wait Until Keyword Succeeds    460s    5s    Check Notification Is Exist
    Wait Until Keyword Succeeds    360s    5s    Check Notification Details Is Exist
    

Remove Create Notification Lock
    ${filter_query}    Create Dictionary    serviceName=installment    methodName=createNotification
    Mongo Db Delete One
    ...    hampay_core_db
    ...    lock_details
    ...    ${filter_query}
