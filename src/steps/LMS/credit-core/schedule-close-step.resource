*** Settings ***
Library     library/faker_utils.py    WITH NAME    FakerLibrary
Library     RequestsLibrary
Resource    services/backend/import-allocation.resource
Resource    services/backend/user-wallet-initializer-service.resource
Resource    services/backend/LMS/credit-core/close-billing-cycles.resource
Resource    services/backend/value-handler.resource
Resource    services/backend/LMS/credit-core/expire-credit-account.resource
Resource    apis/lms/credit-core/post-admin-credit-accounts-block.resource
Resource    apis/lms/credit-core/get-accounts-creditId-eligibility-close.resource
Resource    apis/lms/credit-core/post-credit-accounts-schedule-close.resource
Resource    apis/lms/credit-core/post-credit-gateways-disable.resource
Resource    apis/lms/credit-core/post-credit-gateway-activate.resource


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
    ...    ${LMS_BLOCK_REASON.ORGANIZATION_REQUEST}
    ...    ${DASHBOARD_USERNAME}
    Set Test Variable    ${BLOCK_RESPONSE}    ${response}
    ${credit_account_status}    Check Credit Account Status    ${credit_id}
    IF    '${credit_account_status}' != '3'    Fail

Check Credit Account Status
    [Arguments]    ${credit_id}
    ${find_dic}    Create Dictionary    creditId=${credit_id}
    ${credit_account}    Mongo Db Find    credit-account-mng_db    accounts    ${find_dic}
    ${credit_account_status}    Set Variable    ${credit_account}[body][0][status]
    Set Test Variable    ${credit_account_status}
    RETURN    ${credit_account_status}

Complete A Offline Purchase
    [Arguments]
    ...    ${user_id}=${user_id}
    ...    ${credit_id}=${credit_ids}[0]
    ...    ${terminal_id}=${EMPTY}
    ${skip}    Create List    deliver
    IF    '${terminal_id}'!='${EMPTY}'    Set Test Variable    ${terminal_id}
    ${tracking_code}    Perform A Complete Offline Purchase
    ...    user_id=${user_id}
    ...    credit_id=${credit_id}
    ...    amount=${AMOUNT}
    ...    business_id=${LMS_AUTOMATION_BUSINESS_ID}
    ...    terminal_id=${terminal_id}
    ...    channel=${PAYMENT_CHANNEL}
    ...    skip=${skip}

    Set Test Variable    ${tracking_code}

Check Account Is Should To Be Eligible To Close
    [Documentation]    This step, check the eligibility of the account and Fails the test if it is found not eligible
    [Arguments]    ${creditId}=${credit_ids}[0]

    ${response}    GET Accounts CreditId Eligibility Close
    ...    api_call_side=${MICROSERVICE_SIDE}
    ...    creditId=${creditId}

    Should Be Equal
    ...    first=${response['body']['isAccountClosable']}
    ...    second=true

Check Account Is Should Not To Be Eligible To Close
    [Documentation]    This step, check the eligibility of the account and Fails the test if it is found not eligible
    [Arguments]    ${creditId}

    ${response}    GET Accounts CreditId Eligibility Close
    ...    api_call_side=${MICROSERVICE_SIDE}
    ...    creditId=${creditId}

    Should Be Equal As Strings
    ...    first=${response['body'][0][isAccountClosable]}
    ...    second=false

Close Billing Cycle
    [Arguments]    ${credit_id}=${credit_ids}[0]
    Wait Until Keyword Succeeds    60s    5s    Close billing cycles    ${credit_id}

Call Schedule Close API
    [Documentation]    Checks if the response status code is 200
    [Arguments]    ${credit_id}=${credit_ids}[0]
    ${schedule_close_response}    Post Credit Accounts Schedule Close
    ...    ${MICROSERVICE_SIDE}
    ...    ${credit_ids}[0]
    ...    ${LMS_BLOCK_REASON.ORGANIZATION_REQUEST}
    ...    ${DASHBOARD_USERNAME}
    Set Test Variable    ${schedule_close_response}

The Response Schedule Close API Should Be Successful
    Should Be Equal As Integers
    ...    first=${schedule_close_response['status_code']}
    ...    second=200
    ...    msg=Expected status code to be 200, got ${schedule_close_response['status_code']} instead.

Check Installment Contract Status
    [Documentation]    This step, checks if the installment contract status is 2 (closed)
    [Arguments]    ${credit_id}=${credit_ids}[0]
    ${query}    Set Variable    SELECT * FROM installment_db.accounts WHERE credit_id=${credit_id}
    ${result_installment_accounts}    MySQL Fetch All    db_name=installment_db    query=${query}
    ${result_installment_accounts_length}    Get length    ${result_installment_accounts}[body]
    IF    ${result_installment_accounts_length} == 0    Fail
    ${contain_account_id}    Evaluate    "id" in ${result_installment_accounts}[body][0]
    IF    '${contain_account_id}' == 'False'    Fail
    IF    ${contain_account_id}
        ${installment_account_id}    Set Variable    ${result_installment_accounts}[body][0][id]
        ${query}    Set Variable    SELECT * FROM installment_db.contracts WHERE account_id=${installment_account_id};
        ${result_contract}    MySQL Fetch All    db_name=installment_db    query=${query}
        ${result_installment_contracts_length}    Get length    ${result_contract}[body]
        IF    ${result_installment_contracts_length} == 0    Fail
        ${contain_contract_status}    Evaluate    "status" in ${result_contract}[body][0]
        IF    '${result_contract}[body][0][status]' != '2'    Fail
    END

Change balance to initial balance
    [Arguments]    ${credit_id}=${credit_ids}[0]
    ${find_dic}    Create Dictionary    walletName=credit_${credit_id}
    ${wallet_doc}    Mongo Db Find    wallet_provider_db    wallets    ${find_dic}
    ${wallet_id}    Set Variable    ${wallet_doc}[body][0][walletId]

    ${query}    Set Variable    SELECT balance FROM accounts WHERE wallet_id='${wallet_id}' AND balance_type=2
    ${result_account}    MySQL Fetch All    db_name=wallet_provider_db    query=${query}
    ${balance}    Set Variable    ${result_account}[body][0][balance]
    ${balance_d128}    Evaluate    __import__('bson').decimal128.Decimal128(str(${balance}))
    ${filter_query}    Create Dictionary    creditId=${credit_id}
    ${update_value}    Create Dictionary    allocatedAmount=${balance_d128}    initialBalance=${balance_d128}
    ${update_query}    Create Dictionary    $set=${update_value}
    ${billing_cycle_result}    Mongo Db Update One
    ...    credit-account-mng_db
    ...    accounts
    ...    ${filter_query}
    ...    ${update_query}

Make Account Closable
    [Documentation]    This step, checks if the account is ready to be closed
    [Arguments]    ${credit_id}=${credit_ids}[0]
    Wait Until Keyword Succeeds    360s    5s    Close Billing Cycle
    Wait Until Keyword Succeeds    360s    5s    Update installment contract status
    Wait Until Keyword Succeeds    360s    5s    Check Installment Contract Status
    Wait Until Keyword Succeeds    360s    5s    Change balance to initial balance

Update installment contract status
    [Arguments]    ${credit_id}=${credit_ids}[0]
    ${query}    Set Variable    SELECT * FROM installment_db.accounts WHERE credit_id=${credit_id}
    ${result_installment_accounts}    MySQL Fetch All    db_name=installment_db    query=${query}
    ${result_installment_accounts_length}    Get length    ${result_installment_accounts}[body]
    IF    ${result_installment_accounts_length} == 0    Fail
    ${contain_account_id}    Evaluate    "id" in ${result_installment_accounts}[body][0]
    IF    '${contain_account_id}' == 'False'    Fail
    IF    ${contain_account_id}
        ${installment_account_id}    Set Variable    ${result_installment_accounts}[body][0][id]
        ${query}    Set Variable
        ...    UPDATE installment_db.contracts SET status=2 WHERE account_id=${installment_account_id};
        ${result_contract}    MySQL Execute Query    db_name=installment_db    query=${query}
        RETURN    ${result_contract}
    END

Check The Account Should Be Closed
    Wait Until Keyword Succeeds    360s    5s    Check Account Status

Check Account Status
    [Documentation]    This step, checks if the account is closed
    [Arguments]    ${credit_id}=${credit_ids}[0]

    ${find_dic}    Create Dictionary    creditId=${credit_id}
    ${credit_account}    Mongo Db Find    credit-account-mng_db    accounts    ${find_dic}
    ${credit_account_status}    Set Variable    ${credit_account}[body][0][status]

    Should Be Equal As Integers
    ...    first=${credit_account_status}
    ...    second=1
    ...    msg=Expected credit account status to be 1 (closed), got ${credit_account_status} instead.

Check Credit Account Mng DB Account Manual Closes
    [Documentation]    This step, checks if the account is found in the credit account management database
    [Arguments]    ${credit_id}=${credit_ids}[0]

    ${find_dic}    Create Dictionary    creditId=${credit_id}
    ${credit_account}    Mongo Db Find    credit-account-mng_db    account_manual_closes    ${find_dic}
    Should Not Be Empty
    ...    ${credit_account}[body]
    ...    msg=Expected credit account manual closes to not be empty, but it was empty.

    Should Be Equal As Numbers
    ...    ${credit_account}[body][0][type]
    ...    1
    ...    msg=Expected credit account manual closes to not be empty, but it was empty.

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
