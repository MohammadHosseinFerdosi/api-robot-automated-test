*** Settings ***
Library     Collections
Library     RequestsLibrary
Resource    apis/lms/credit-core/post-credit-gateway-activate.resource
Resource    apis/lms/credit-core/post-credit-gateways-disable.resource
Resource    apis/lms/credit-core/post-credit-purchases-init.resource
Resource    services/backend/import-allocation.resource
Resource    apis/lms/credit-core/post-admin-credit-accounts-block.resource
Resource    services/backend/user-wallet-initializer-service.resource
Resource    services/backend/value-handler.resource
Resource    services/backend/LMS/credit-core/close-account.resource


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

The User Has 1pay , 4pay And Credit Accounts
    Credit Allocation
    ...    types=${{['${LMS_Account_Type_1PAY}','${LMS_Account_Type_XPAY}','${LMS_Account_Type_CREDIT}']}}

The User Has 1pay And 4pay Accounts
    Credit Allocation    types=${{['${LMS_Account_Type_1PAY}','${LMS_Account_Type_XPAY}']}}

The User Has 4pay And Credit Accounts
    Credit Allocation    types=${{['${LMS_Account_Type_XPAY}','${LMS_Account_Type_CREDIT}']}}

The User Has 4pay Account
    Credit Allocation    types=${{['${LMS_Account_Type_XPAY}']}}

The User Has 1pay Account
    Credit Allocation    types=${{['${LMS_Account_Type_1PAY}']}}

The User Has Installment Account
    Credit Allocation    types=${{['${LMS_Account_Type_INSTALLMENT_SALE}']}}

# Set RepaymentOptin

The Gateway RepaymentOption Set To 1pay
    @{REPAYMENT_OPTIONS}    Create List    ${LMS_REPAYMENT_OPTION.ONEPAY}
    Set Test Variable    ${REPAYMENT_OPTIONS}
    The Gateway Is Activated

The Gateway RepaymentOption Set To Xpay
    @{REPAYMENT_OPTIONS}    Create List    ${LMS_REPAYMENT_OPTION.XPAY}
    Set Test Variable    ${REPAYMENT_OPTIONS}
    The Gateway Is Activated

The Gateway RepaymentOption Set To 1pay And Xpay
    @{REPAYMENT_OPTIONS}    Create List    ${LMS_REPAYMENT_OPTION.ONEPAY}    ${LMS_REPAYMENT_OPTION.XPAY}
    Set Test Variable    ${REPAYMENT_OPTIONS}
    The Gateway Is Activated

# Set Channel

The Channel Set To API
    Set Test Variable    ${PAYMENT_CHANNEL}    ${CHANNEL.API}

The Channel Set To Smart POS
    Set Test Variable    ${PAYMENT_CHANNEL}    ${CHANNEL.SMART_POS}

The Channel Set To Barcode
    Set Test Variable    ${PAYMENT_CHANNEL}    ${CHANNEL.BARCODE}

The Channel Set To Linux POS
    Set Test Variable    ${PAYMENT_CHANNEL}    ${CHANNEL.LINUX_POS}

# Set Gateway

The Payment Gateway Set To BPG
    Set Test Variable    ${PAYMENT_GATEWAY}    ${LMS_PAYMENT_GATEWAY.BPG}

The Payment Gateway Set To CPG
    Set Test Variable    ${PAYMENT_GATEWAY}    ${LMS_PAYMENT_GATEWAY.CPG}

The Payment Gateway Set To ISPG
    Set Test Variable    ${PAYMENT_GATEWAY}    ${LMS_PAYMENT_GATEWAY.ISPG}

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

Purchase Status Must Be CONFIRMED Or DELIVERED
    [Arguments]    ${tracking_code}=${tracking_code}

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
    [Arguments]    ${tracking_code}=${tracking_code}
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
    IF    '${PAYMENT_CHANNEL}'=='5'
        ${amount}    Set Variable    ${credit_account_initial_balance}
    ELSE
        ${amount}    Evaluate    ${credit_account_initial_balance}*2
    END
    ${tracking_code}    Perform A Complete Offline Purchase
    ...    ${user_id}
    ...    ${credit_id}
    ...    ${amount}
    ...    business_id=${LMS_AUTOMATION_BUSINESS_ID}
    ...    channel=${PAYMENT_CHANNEL}

    Purchase Status Must Be CONFIRMED Or DELIVERED    tracking_code=${tracking_code}
    Wait Until Keyword Succeeds
    ...    2 minute
    ...    5 s
    ...    Purchase Should Be Assigned To The Billing Cycle
    ...    tracking_code=${tracking_code}

    Set Test Variable    ${tracking_code}

Calling The Initiate API
    [Arguments]
    ...    ${user_id}=${EMPTY}
    ...    ${credit_id}=${EMPTY}
    ...    ${cell_number}=${EMPTY}
    ...    ${api_call_side}=${MICROSERVICE_SIDE}
    ...    ${amount}=${AMOUNT}
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
        ${provider_id}    Generate Random String    15    123456789
    END
    IF    '${basket_id}'=='${EMPTY}'
        ${basket_id}    Generate Random String    6    123456789
    END

    ${response_init}    POST Credit Purchases Init
    ...    api_call_side=${api_call_side}
    ...    user_id=${user_id}
    ...    cell_number=${cell_number}
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

        Set Test Variable    ${result}
        Set Test Variable    ${tracking_code}
        Set Test Variable    ${cash_amount}
        Set Test Variable    ${provider_id}
        RETURN    ${result}
    ELSE
        ${result}    Create Dictionary    status_code=${status_code}
        Set Test Variable    ${result}
        RETURN    ${result}
    END

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
    ...    ${LMS_BLOCK_REASON.ORGANIZATION_REQUEST}
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

Expire Account
    [Documentation]    Wrapper for the Expiration Service
    [Arguments]    ${credit_id}=${credit_ids}[0]

    Expiration Time Setter    credit_id=${credit_id}

The Response Should Countain TrackingCode
    Should Be Equal As Integers    ${result['status_code']}
    ...    200
    ...    msg="Expected status code to initiated trackingCode should be 200"
    RETURN    ${tracking_code}

The Response Should Countain TrackingCode But Without Terminal Id
    Should Be Equal As Integers    ${result['status_code']}
    ...    200
    ...    msg="Expected status code to initiated trackingCode should be 200"

    RETURN    ${tracking_code}

The Response Shouldn't Countain TrackingCode
    Should Be Equal As Integers    ${result['status_code']}
    ...    422
    ...    msg="Expected status code to initiated trackingCode should be 422"
