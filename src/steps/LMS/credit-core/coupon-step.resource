*** Settings ***
Library           RequestsLibrary
Resource    services/backend/LMS/credit-core/expire-credit-account.resource
Resource    apis/lms/credit-core/post-credit-accounts-schedule-close.resource
Resource    apis/lms/credit-core/post-credit-gateway-activate.resource
Resource    apis/lms/credit-core/post-credit-gateways-disable.resource
Resource    apis/lms/credit-core/post-coupon-admin-campaigns.resource
Resource    apis/lms/credit-core/post-coupon-admin-coupons.resource
Resource    apis/lms/credit-core/post-coupon-admin-coupon-codes.resource
Resource    services/backend/import-allocation.resource
Resource    services/backend/user-wallet-initializer-service.resource

*** Keywords ***
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
    [Arguments]    ${additional_user_lists}=${ALLOCATION_USER_LIST}    ${user_object}=${user_object}

    Collect All Amount For Tear Down    additional_user_lists=${additional_user_lists}

Credit Allocation
    [Arguments]    ${types}    ${set_variables_as}=TEST    &{optional_arguments}

    ${user_object}    Activate Account
    ...    types=${types}
    ...    &{optional_arguments}

    ${cell_number}    Set Variable    ${user_object['user_cell_number']}
    ${user_id}    Set Variable    ${user_object['user_id']}
    ${credit_ids}    Set Variable    ${user_object['user_credit_ids']}
    &{user_data}    Create Dictionary    user_id=${user_id}    type=${CUSTOMER_TYPE}
    ${ALLOCATION_USER_LIST}    Create List    ${user_data}

    IF    '${set_variables_as}'=='TEST'
        Set Test Variable    ${cell_number}
        Set Test Variable    ${user_id}
        Set Test Variable    ${credit_ids}
        Set Test Variable    ${user_object}
        Set Test Variable    ${ALLOCATION_USER_LIST}
    END
    IF    '${set_variables_as}'=='SUITE'
        Set Suite Variable    ${cell_number}
        Set Suite Variable    ${user_id}
        Set Suite Variable    ${credit_ids}
        Set Suite Variable    ${user_object}
        Set Suite Variable    ${ALLOCATION_USER_LIST}
    END

The User Has 1pay Account
    Credit Allocation    types=${{['${LMS_Account_Type_1PAY}']}}    amounts=${{['${DEFAULT_ALLOCATION_AMOUNT}']}}

The User Has Credit Account
    Credit Allocation    types=${{['${LMS_Account_Type_CREDIT}']}}    amounts=${{['${DEFAULT_ALLOCATION_AMOUNT}']}}

The User Has 4pay Account
    Set Test Variable    ${DEFAULT_ALLOCATION_AMOUNT_4PAY}    20000
    Credit Allocation    types=${{['${LMS_Account_Type_XPAY}']}}    amounts=${{['${DEFAULT_ALLOCATION_AMOUNT_4PAY}']}}

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

The Payment Gateway Is Set To BPG
    Set Test Variable    ${PAYMENT_GATEWAY}    ${LMS_PAYMENT_GATEWAY.BPG}

The Payment Gateway Is Set To CPG
    Set Test Variable    ${PAYMENT_GATEWAY}    ${LMS_PAYMENT_GATEWAY.CPG}

The Payment Gateway Is Set To ISPG
    Set Test Variable    ${PAYMENT_GATEWAY}    ${LMS_PAYMENT_GATEWAY.ISPG}

The Ticket Type Is Set To BNPL
    Set Test Variable    ${TICKET_TYPE}    ${CREDIT_TICKET_TYPE_V1.BNPL}

The Ticket Type Is Set To Credit
    Set Test Variable    ${TICKET_TYPE}    ${CREDIT_TICKET_TYPE_V1.CREDIT}

The Ticket Type Is Set To Installment Sale
    Set Test Variable    ${TICKET_TYPE}    ${CREDIT_TICKET_TYPE_V1.INSTALLMENT_SALE}

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

Create Campaign With Valid Data
    ${NAME}    Generate Random String    30
    ${DESCRIPTION}    Set Variable    Description for ${NAME}
    ${START_DATE}    Evaluate    random.randint(1666300791000, 1666301791000)    modules=random
    ${END_DATE}    Evaluate    random.randint(1866300791000, 1866301791000)    modules=random
    ${FUNDER_WALLET_USER_ID}    Set Variable    ${PLATFORM_BUSINESS_ID}
    ${FUNDER_WALLET_NAME}    Set Variable    ${PLATFORM_COUPON_FUNDER_WALLET_NAME}
    ${TOTAL_BUDGET}    Evaluate    random.randint(10000, 100000)    modules=random
    ${TOTAL_USAGE_LIMIT}    Evaluate    random.randint(1000000, 2000000)    modules=random

    ${campaign_response}    Post Coupon Admin Campaigns
    ...    api_call_side=${MICROSERVICE_SIDE}
    ...    name=${NAME}
    ...    description=${DESCRIPTION}
    ...    funderWalletUserId=${FUNDER_WALLET_USER_ID}
    ...    funderWalletName=${FUNDER_WALLET_NAME}
    ...    totalBudget=${TOTAL_BUDGET}
    ...    totalUsageLimit=${TOTAL_USAGE_LIMIT}
    ...    startDate=${START_DATE}
    ...    endDate=${END_DATE}
    
    Should Be Equal As Integers
    ...    ${campaign_response['status_code']}
    ...    200

    ${query}    Set Variable
    ...    SELECT id FROM campaigns WHERE name = '${NAME}'
    ${results}    MySQL Fetch All    db_name=${COUPON_DB}    query=${query}
    ${results}    Set Variable    ${results['body']}
    ${row}    Get From List    ${results}    0

    ${id}    Get From Dictionary    ${row}    id
    Log To Console    id: ${id}
    Set Test Variable    $campaign_id    ${id}

Create Coupon With Valid Data
    ${NAME}    Generate Random String    30
    Set Test Variable    ${NAME}
    ${DESCRIPTION}    Set Variable    Description for ${NAME}
    ${START_DATE}    Evaluate    1666301791000
    ${END_DATE}    Evaluate    1866300791000
    ${FUNDER_WALLET_USER_ID}    Set Variable    ${PLATFORM_BUSINESS_ID}
    ${FUNDER_WALLET_NAME}    Set Variable    ${PLATFORM_COUPON_FUNDER_WALLET_NAME}
    ${TOTAL_BUDGET}    Evaluate    10000
    ${TOTAL_USAGE_LIMIT}    Evaluate    1000000
    ${MIN_TRANSACTION_AMOUNT}    Evaluate    random.randint(1, 10)    modules=random
    ${DISCOUNT_PERCENTAGE}    Evaluate    random.randint(1, 99)    modules=random
    @{PAYMENT_METHOD_ALL}    Create List    ${COUPON_PAYMENT_METHOD.BNPL1PAY}    ${COUPON_PAYMENT_METHOD.BNPLXPAY}    ${COUPON_PAYMENT_METHOD.WALLET}
    @{PAYMENT_CHANNELS}    Create List    ${CHANNEL.API}    ${CHANNEL.UPG}    ${CHANNEL.SMART_POS}    ${CHANNEL.QR}    ${CHANNEL.ESCROW}    ${CHANNEL.BARCODE}    ${CHANNEL.LINUX_POS}
    @{MERCHANTS}    Create List    ${COMPANY_USER_ID}
    ${response}    Post Coupon Admin Coupons
    ...    api_call_side=${MICROSERVICE_SIDE}
    ...    campaign_id=${campaign_id}
    ...    name=${NAME}
    ...    discountType=${COUPON_DISCOUNT_TYPE.PERCENTAGE}
    ...    merchantBusinessIds=@{MERCHANTS}
    ...    generationType=${COUPON_GENERATION_TYPE.PUBLIC}
    ...    paymentMethods=@{PAYMENT_METHOD_ALL}
    ...    paymentChannels=@{PAYMENT_CHANNELS}
    ...    startDate=${START_DATE}
    ...    endDate=${END_DATE}
    ...    maxUsage=${TOTAL_USAGE_LIMIT}
    ...    maxUserUsage=${TOTAL_USAGE_LIMIT}
    ...    minTransactionAmount=${MIN_TRANSACTION_AMOUNT}
    ...    maxDiscountAmount=${TOTAL_BUDGET}
    ...    discountPercentage=${COUPON_DISCOUNT_PERCENTAGE.FIFTY}
    ...    state=${COUPON_STATE.ACTIVE}
    Set Test Variable    $coupon_response    ${response}
    Should Be Equal As Integers
    ...    ${coupon_response['status_code']}
    ...    200

Check Campaign in coupon database
    ${coupon_id}    Set Variable    ${coupon_response['body']['id']}
    # ${coupon_in_db}    Get Coupon From Database    ${coupon_id}

Create Coupon Codes Successfully
    ${coupon_id}    Set Variable    ${coupon_response['body']['id']}
    ${generate_code_response}    Post Coupon Admin Coupon Codes
    ...    api_call_side=${MICROSERVICE_SIDE}
    ...    coupon_id=${coupon_id}

    Should Be Equal As Integers
    ...    ${generate_code_response['status_code']}
    ...    200