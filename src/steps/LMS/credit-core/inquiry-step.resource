*** Settings ***
Library     library/faker_utils.py    WITH NAME    FakerLibrary
Library     RequestsLibrary
Library     DateTime
Resource    apis/lms/credit-core/post-credit-gateways-inquiry.resource
Resource    apis/lms/credit-core/post-admin-credit-accounts-block.resource
Resource    apis/lms/credit-core/post-admin-credit-accounts-unblock.resource
Resource    services/backend/import-allocation.resource
Resource    apis/lms/credit-core/post-credit-gateway-activate.resource
Resource    apis/lms/credit-core/post-credit-gateways-disable.resource
Resource    services/backend/LMS/credit-core/credit-online-purchase.resource
Resource    services/backend/LMS/credit-core/close-account.resource
Resource    services/backend/user-wallet-initializer-service.resource
Resource    apis/lms/credit-core/post-credit-accounts-schedule-close.resource


*** Keywords ***
############################################################################################################################################################################
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
    [Arguments]    ${additional_user_lists}=${ALLOCATION_USER_LIST}    ${user_object}=${user_object}

    Collect All Amount For Tear Down    additional_user_lists=${additional_user_lists}

############################################################################################################################################################################
# Allocations

Allocate No Fee 1PAY Account
    [Documentation]    Allocates a no fee 1pay account. Returns the ${cell_number}, ${credit_ids} as a list, and ${user_id} for the allocated user.
    ...    Sets these variables as ```Set Test Variable```.

    ${user_object}    Activate Account
    ...    types=${{['${LMS_Account_Type_1PAY}']}}
    ...    amounts=${{['${DEFAULT_ALLOCATION_AMOUNT}']}}
    ...    fee_types=${{['${LMS_ZERO_FEE}']}}

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

Allocate No Fee XPAY Account
    [Documentation]    Allocates a no fee XPAY account. Returns the ${cell_number}, ${credit_ids} as a list, and ${user_id} for the allocated user.
    ...    Sets these variables as ```Set Test Variable```.

    ${user_object}    Activate Account
    ...    types=${{['${LMS_Account_Type_XPAY}']}}
    ...    amounts=${{['${DEFAULT_ALLOCATION_AMOUNT}']}}
    ...    fee_types=${{['${LMS_ZERO_FEE}']}}

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

Allocate No Fee CCREDIT Account
    [Documentation]    Allocates a no fee ccredit account. Returns the ${cell_number}, ${credit_ids} as a list, and ${user_id} for the allocated user.
    ...    Sets these variables as ```Set Test Variable```.

    ${user_object}    Activate Account
    ...    types=${{['${LMS_Account_Type_CREDIT}']}}
    ...    amounts=${{['${DEFAULT_ALLOCATION_AMOUNT}']}}
    ...    fee_types=${{['${LMS_ZERO_FEE}']}}

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

Allocate No Fee INSTALLMENT SALES Account
    [Documentation]    Allocates a no fee installment sales account. Returns the ${cell_number}, ${credit_ids} as a list, and ${user_id} for the allocated user.
    ...    Sets these variables as ```Set Test Variable```.

    ${user_object}    Activate Account
    ...    types=${{['${LMS_Account_Type_INSTALLMENT_SALE}']}}
    ...    amounts=${{['${DEFAULT_ALLOCATION_AMOUNT}']}}
    ...    fee_types=${{['${LMS_ZERO_FEE}']}}

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

Allocate Fee On Purchase XPAY Account
    [Documentation]    Allocates a fee on purchase XPAY account. Returns the ${cell_number}, ${credit_ids} as a list, and ${user_id} for the allocated user.
    ...    Sets these variables as ```Set Test Variable```.

    ${user_object}    Activate Account
    ...    types=${{['${LMS_Account_Type_XPAY}']}}
    ...    amounts=${{['${DEFAULT_ALLOCATION_AMOUNT}']}}
    ...    fee_types=${{['${LMS_FEE_ON_PURCHASE}']}}

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
    [Documentation]    Allocates a fee on purchase ccredit account. Returns the ${cell_number}, ${credit_ids} as a list, and ${user_id} for the allocated user.
    ...    Sets these variables as ```Set Test Variable```.

    ${user_object}    Activate Account
    ...    types=${{['${LMS_Account_Type_CREDIT}']}}
    ...    amounts=${{['${DEFAULT_ALLOCATION_AMOUNT}']}}
    ...    fee_types=${{['${LMS_FEE_ON_PURCHASE}']}}

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

Allocate Fee On Purchase INSTALLMENT SALES Account
    [Documentation]    Allocates a fee on purchase installment sales account. Returns the ${cell_number}, ${credit_ids} as a list, and ${user_id} for the allocated user.
    ...    Sets these variables as ```Set Test Variable```.

    ${user_object}    Activate Account
    ...    types=${{['${LMS_Account_Type_INSTALLMENT_SALE}']}}
    ...    amounts=${{['${DEFAULT_ALLOCATION_AMOUNT}']}}
    ...    fee_types=${{['${LMS_FEE_ON_PURCHASE}']}}

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

Allocate No Fee 1 PAY AND No Fee XPAY AND No Fee CCREDIT Account
    [Documentation]    Allocates a no fee 1pay, XPAY, ccredit, and installment sales accounts. Returns the ${cell_number}, ${credit_ids} as a list, and ${user_id} for the allocated user.
    ...    Sets these variables as ```Set Test Variable```.

    ${user_object}    Activate Account
    ...    types=${{['${LMS_Account_Type_1PAY}','${LMS_Account_Type_XPAY}','${LMS_Account_Type_CREDIT}']}}
    ...    amounts=${{['${DEFAULT_ALLOCATION_AMOUNT}','${DEFAULT_ALLOCATION_AMOUNT}','${DEFAULT_ALLOCATION_AMOUNT}',]}}
    ...    fee_types=${{['${LMS_ZERO_FEE}','${LMS_ZERO_FEE}','${LMS_ZERO_FEE}']}}

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

Allocate No Fee 1 PAY AND No Fee XPAY AND No Fee Saderat CCREDIT AND No Fee INSTALLMENT SALES Account
    [Documentation]    Allocates a no fee 1pay, XPAY, ccredit, and installment sales accounts. Returns the ${cell_number}, ${credit_ids} as a list, and ${user_id} for the allocated user.
    ...    Sets these variables as ```Set Test Variable```.

    ${user_object}    Activate Account
    ...    types=${{['${LMS_Account_Type_1PAY}','${LMS_Account_Type_XPAY}','${LMS_Account_Type_CREDIT}','${LMS_Account_Type_INSTALLMENT_SALE}']}}
    ...    fund_providers=${{['${LMS_FP_PLATFORM}','${LMS_FP_PLATFORM}','${LMS_FP_TEJARAT}','${LMS_FP_PLATFORM}']}}
    ...    amounts=${{['${DEFAULT_ALLOCATION_AMOUNT}','${DEFAULT_ALLOCATION_AMOUNT}','${DEFAULT_ALLOCATION_AMOUNT}','${DEFAULT_ALLOCATION_AMOUNT}']}}
    ...    fee_types=${{['${LMS_ZERO_FEE}','${LMS_ZERO_FEE}','${LMS_ZERO_FEE}','${LMS_ZERO_FEE}']}}

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

Allocate No Fee 1 PAY AND Fee On Purchase XPAY AND Fee On Purchase CCREDIT AND Fee On Purchase INSTALLMENT SALES Account
    [Documentation]    Allocates a no fee 1pay, and fee on purchase XPAY, ccredit, and installment sales accounts. Returns the ${cell_number}, ${credit_ids} as a list, and ${user_id} for the allocated user.
    ...    Sets these variables as ```Set Test Variable```.

    ${user_object}    Activate Account
    ...    types=${{['${LMS_Account_Type_1PAY}','${LMS_Account_Type_XPAY}','${LMS_Account_Type_CREDIT}','${LMS_Account_Type_INSTALLMENT_SALE}']}}
    ...    amounts=${{['${DEFAULT_ALLOCATION_AMOUNT}','${DEFAULT_ALLOCATION_AMOUNT}','${DEFAULT_ALLOCATION_AMOUNT}','${DEFAULT_ALLOCATION_AMOUNT}']}}
    ...    fee_types=${{['${LMS_ZERO_FEE}','${LMS_FEE_ON_PURCHASE}','${LMS_FEE_ON_PURCHASE}','${LMS_FEE_ON_PURCHASE}']}}

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

############################################################################################################################################################################
# Set channel, repayment option and payment gateway Configs

Set Repayment Option 1PAY
    [Documentation]    This is a basic set function that sets these variables to the environment so that they can be accessed later on.
    Set Test Variable    @{repayment_options}    ${LMS_REPAYMENT_OPTION.ONEPAY}

Set Repayment Option XPAY
    [Documentation]    This is a basic set function that sets these variables to the environment so that they can be accessed later on.
    Set Test Variable    @{repayment_options}    ${LMS_REPAYMENT_OPTION.XPAY}

Set Repayment Option 1PAY And XPAY
    [Documentation]    This is a basic set function that sets these variables to the environment so that they can be accessed later on.
    Set Test Variable    @{repayment_options}    ${LMS_REPAYMENT_OPTION.ONEPAY}    ${LMS_REPAYMENT_OPTION.XPAY}

Set Payment Gateway BPG
    [Documentation]    This is a basic set function that sets these variables to the environment so that they can be accessed later on.
    Set Test Variable    ${payment_gateway}    ${LMS_PAYMENT_GATEWAY.BPG}

Set Payment Gateway CPG
    [Documentation]    This is a basic set function that sets these variables to the environment so that they can be accessed later on.
    Set Test Variable    ${payment_gateway}    ${LMS_PAYMENT_GATEWAY.CPG}

Set Payment Gateway ISPG
    [Documentation]    This is a basic set function that sets these variables to the environment so that they can be accessed later on.
    Set Test Variable    ${payment_gateway}    ${LMS_PAYMENT_GATEWAY.ISPG}

############################################################################################################################################################################
# Disable And Enable Gateways

Credit Gateway Activate Intermediary step
    [Documentation]    Activates a Gateway; It first disables the gateway and then enables it with the new configs
    [Arguments]
    ...    ${default_channel}=${default_channel}
    ...    ${payment_gateway}=${payment_gateway}
    ...    ${repayment_options}=${repayment_options}
    ...    ${trigger_action}=0
    ...    ${business_id}=${LMS_AUTOMATION_BUSINESS_ID}
    ...    ${repeat_count}=1

    FOR    ${i}    IN RANGE    ${0}    ${repeat_count}    ${1}
        ${disable_response}    POST Credit Gateway Disable
        ...    api_call_side=${MICROSERVICE_SIDE}
        ...    business_id=${business_id}
        ...    channel=${default_channel}
        ...    payment_gateway=${payment_gateway}
    END
    Should Be Equal As Integers
    ...    ${disable_response['status_code']}
    ...    200
    ...    msg="Expected status code for Credit Gateway Disable API should be 200, and got" ${disable_response['status_code']}

    ${activate_response}    POST Credit Gateway Activate
    ...    api_call_side=${MICROSERVICE_SIDE}
    ...    business_id=${business_id}
    ...    channel=${default_channel}
    ...    payment_gateway=${payment_gateway}
    ...    trigger_action=${trigger_action}
    ...    user_id="a4e0b186-eb81-4969-ba4d-7a9cd7637552"
    ...    repayment_options=${repayment_options}

    Should Be Equal As Integers
    ...    ${activate_response['status_code']}
    ...    200
    ...    msg="Expected status code for Credit Gateway Activate API should be 200, and got" ${activate_response['status_code']}

Credit Gateway Activate
    [Documentation]    Activates a Gateway; It first disables the gateway and then enables it with the new configs.
    ...    Compatible with parallel processing
    [Arguments]
    ...    ${default_channel}=${default_channel}
    ...    ${payment_gateway}=${payment_gateway}
    ...    ${repayment_options}=${repayment_options}
    ...    ${trigger_action}=0
    ...    ${business_id}=${LMS_AUTOMATION_BUSINESS_ID}

    Wait Until Keyword Succeeds
    ...    1 minute
    ...    1 s
    ...    Credit Gateway Activate Intermediary step
    ...    default_channel=${default_channel}
    ...    payment_gateway=${payment_gateway}
    ...    repayment_options=${repayment_options}
    ...    trigger_action=${trigger_action}
    ...    business_id=${business_id}

Credit Gateway Disable Intermediary step
    [Documentation]    Disables a Gateway;
    [Arguments]
    ...    ${default_channel}=${default_channel}
    ...    ${payment_gateway}=${payment_gateway}
    ...    ${business_id}=${LMS_AUTOMATION_BUSINESS_ID}
    ...    ${repeat_count}=1

    FOR    ${i}    IN RANGE    ${0}    ${repeat_count}    ${1}
        ${disable_response}    POST Credit Gateway Disable
        ...    api_call_side=${MICROSERVICE_SIDE}
        ...    business_id=${business_id}
        ...    channel=${default_channel}
        ...    payment_gateway=${payment_gateway}
    END
    Should Be Equal As Integers
    ...    ${disable_response['status_code']}
    ...    200
    ...    msg="Expected status code for Credit Gateway Disable API should be 200, and got" ${disable_response['status_code']}

Credit Gateway Disable
    [Documentation]    Disables a Gateway;
    ...    Compatible with parallel processing
    [Arguments]
    ...    ${default_channel}=${default_channel}
    ...    ${payment_gateway}=${payment_gateway}
    ...    ${business_id}=${LMS_AUTOMATION_BUSINESS_ID}

    Wait Until Keyword Succeeds
    ...    1 minute
    ...    1 s
    ...    Credit Gateway Disable Intermediary step
    ...    default_channel=${default_channel}
    ...    payment_gateway=${payment_gateway}
    ...    business_id=${business_id}

Check If All Gateways Are Disabled
    [Documentation]    Makes sure that all the gateways are disabled
    [Arguments]    ${business_id}=${LMS_AUTOMATION_BUSINESS_ID}    ${default_channel}=${default_channel}
    ${all}    Create Dictionary    businessId=${business_id}    channel=${default_channel}
    ${result}    Mongo Db Find
    ...    db_name=credit_merchant_mng_db
    ...    collection_name=gateways
    ...    query_dict=${all}
    @{disabled}    Create List
    @{active}    Create List
    FOR    ${doc}    IN    ${result['body']}
        ${status}    Set Variable    ${doc['status']}
        IF    '${status}'=='0'
            Append To List    ${disabled}    ${doc}
        ELSE IF    '${status}'=='1'
            Append To List    ${active}    ${doc}
        END
    END
    ${disabled_length}    Get Length    ${disabled}
    ${active_length}    Get Length    ${active}
    IF    ${disabled_length} == 0
        Fail    msg=Expected at least one gateway but got 0.
    ELSE IF    ${active_length} > 0
        Fail    There are ${active_length} active gateway documents in addition to ${disabled_length} disabled gateways.
    END
    RETURN    @{disabled}

Check If All Gateways Are Enabled
    [Documentation]    Makes sure that all the gateways are disabled
    [Arguments]    ${business_id}=${LMS_AUTOMATION_BUSINESS_ID}    ${default_channel}=${default_channel}    ${count}=4

    ${filter_query}    Create Dictionary    businessId=${business_id}    channel=${default_channel}

    ${result}    Mongo Db Find
    ...    credit_merchant_mng_db
    ...    gateways
    ...    ${filter_query}
    ${body}    Set Variable    ${result['body']}
    ${length}    Get Length    ${body}
    Should Be Equal As Integers
    ...    first=${length}
    ...    second=4
    ...    msg=Expected to have all the gateways enable, but found only ${length} gateways active for ${business_id}, expected ${count}.

Disable All Gateways Intermediary step
    [Documentation]    Disables All gateways for a ${default_channel} and ${LMS_AUTOMATION_BUSINESS_ID}
    [Arguments]    ${business_id}=${LMS_AUTOMATION_BUSINESS_ID}    ${default_channel}=${default_channel}

    Credit Gateway Disable
    ...    default_channel=${default_channel}
    ...    payment_gateway=${LMS_PAYMENT_GATEWAY.BPG}
    ...    business_id=${business_id}
    Credit Gateway Disable
    ...    default_channel=${default_channel}
    ...    payment_gateway=${LMS_PAYMENT_GATEWAY.CPG}
    ...    business_id=${business_id}
    Credit Gateway Disable
    ...    default_channel=${default_channel}
    ...    payment_gateway=${LMS_PAYMENT_GATEWAY.CAPG}
    ...    business_id=${business_id}
    Credit Gateway Disable
    ...    default_channel=${default_channel}
    ...    payment_gateway=${LMS_PAYMENT_GATEWAY.ISPG}
    ...    business_id=${business_id}

    Check If All Gateways Are Disabled    business_id=${business_id}    default_channel=${default_channel}

Disable All Gateways
    [Documentation]    Disables All gateways for a ${default_channel} and ${LMS_AUTOMATION_BUSINESS_ID}
    [Arguments]    ${business_id}=${LMS_AUTOMATION_BUSINESS_ID}    ${default_channel}=${default_channel}

    Wait Until Keyword Succeeds
    ...    1 minute
    ...    1 s
    ...    Disable All Gateways Intermediary step
    ...    business_id=${LMS_AUTOMATION_BUSINESS_ID}
    ...    default_channel=${default_channel}

Activate All Gateways Intermediary step
    [Documentation]    Activate All gateways for a ${default_channel} and ${LMS_AUTOMATION_BUSINESS_ID}
    [Arguments]
    ...    ${business_id}=${LMS_AUTOMATION_BUSINESS_ID}
    ...    ${default_channel}=${default_channel}
    ...    ${repayment_options}=${repayment_options}

    Credit Gateway Activate
    ...    default_channel=${default_channel}
    ...    payment_gateway=${LMS_PAYMENT_GATEWAY.BPG}
    ...    business_id=${business_id}
    ...    repayment_options=${repayment_options}
    Credit Gateway Activate
    ...    default_channel=${default_channel}
    ...    payment_gateway=${LMS_PAYMENT_GATEWAY.CPG}
    ...    business_id=${business_id}
    ...    repayment_options=${repayment_options}
    Credit Gateway Activate
    ...    default_channel=${default_channel}
    ...    payment_gateway=${LMS_PAYMENT_GATEWAY.CAPG}
    ...    business_id=${business_id}
    ...    repayment_options=${repayment_options}
    Credit Gateway Activate
    ...    default_channel=${default_channel}
    ...    payment_gateway=${LMS_PAYMENT_GATEWAY.ISPG}
    ...    business_id=${business_id}
    ...    repayment_options=${repayment_options}

    Check If All Gateways Are Enabled    business_id=${business_id}    default_channel=${default_channel}

Activate All Gateways
    [Documentation]    Activate All gateways for a ${default_channel} and ${LMS_AUTOMATION_BUSINESS_ID}
    [Arguments]
    ...    ${business_id}=${LMS_AUTOMATION_BUSINESS_ID}
    ...    ${default_channel}=${default_channel}
    ...    ${repayment_options}=${repayment_options}

    Wait Until Keyword Succeeds
    ...    1 minute
    ...    1 s
    ...    Activate All Gateways Intermediary step
    ...    business_id=${LMS_AUTOMATION_BUSINESS_ID}
    ...    default_channel=${default_channel}
    ...    repayment_options=${repayment_options}

############################################################################################################################################################################
# Account Conditions

Empty Balance
    [Arguments]    ${credit_id}=${credit_ids}[0]
    ${find_dic}    Create Dictionary    creditId=${credit_id}
    ${credit_account}    Mongo Db Find    credit-account-mng_db    accounts    ${find_dic}
    ${credit_account_initial_balance}    Set Variable    ${credit_account}[body][0][initialBalance]
    ${credit_account_initial_balance}    Value Handler    ${credit_account_initial_balance}
    IF    '${default_channel}'=='5' or '${default_channel}'=='0'
        ${amount}    Set Variable    ${credit_account_initial_balance}
    ELSE
        ${amount}    Evaluate    ${credit_account_initial_balance}*2
    END
    ${empty_balance_tracking_code}    Perform A Complete Offline Purchase
    ...    user_id=${user_id}
    ...    credit_id=${credit_id}
    ...    amount=${amount}
    ...    business_id=${LMS_AUTOMATION_BUSINESS_ID}
    ...    channel=${default_channel}

    Purchase Status Must Be CONFIRMED Or DELIVERED    tracking_code=${empty_balance_tracking_code}
    Wait Until Keyword Succeeds
    ...    2 minute
    ...    10 s
    ...    Purchase Should Be Assigned To The Billing Cycle
    ...    tracking_code=${empty_balance_tracking_code}

    Set Test Variable    ${empty_balance_tracking_code}

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

Block Credit Account
    [Documentation]    Blocks a Credit Id
    [Arguments]
    ...    ${credit_id}=${credit_ids}[0]
    ${response}    Post Admin Credit Accounts Block
    ...    api_call_side=${MICROSERVICE_SIDE}
    ...    credit_id=${credit_id}
    ...    BLOCK_REASON=${LMS_BLOCK_REASON.ORGANIZATION_REQUEST}
    ...    user_id=${DASHBOARD_USERNAME}

    Should Be Equal As Integers    ${response['status_code']}
    ...    200
    ...    msg="Expected status code for Credit Accounts Block API should be 200, and got" ${response['status_code']}

Check account status
    [Documentation]    Checks the credit account mng database if the account is expired
    [Arguments]    ${credit_id}=${credit_ids}[0]
    ${find_dic}    Create Dictionary    creditId=${credit_id}
    ${account}    Mongo Db Find    credit-account-mng_db    accounts    ${find_dic}
    ${account_status}    Set Variable    ${account}[body][0][status]
    ${contain_expire_relay_time}    Evaluate    "expireRelayTime" in ${account}[body][0]
    IF    '${contain_expire_relay_time}'=='False'
        Fail    msg=Account has not been expired yet!
    END

Expire Account
    [Documentation]    Wrapper for the Expiration Service
    [Arguments]    ${credit_id}=${credit_ids}[0]

    Expiration Time Setter    credit_id=${credit_id}

Check Account Status After Closure
    [Documentation]    Checks the account status in the switch credit db and fails if the account status is not ```CLOSE```
    [Arguments]    ${credit_id}=${credit_ids}[0]
    ${find_dic}    Create Dictionary    creditId=${credit_id}
    ${account}    Mongo Db Find    switch_credit_db    activations    ${find_dic}
    ${status_switch_credit}    Set Variable    ${account}[body][0][status]
    IF    '${status_switch_credit}'!='CLOSE'
        Fail    msg=The Account is not in the valid status. Got ${status_switch_credit}, but expected CLOSE
    END

Close Account Via Credit Id
    [Documentation]    Closes an account, identified by the input ${credit_id}
    [Arguments]    ${credit_id}=${credit_ids}[0]
    Close Account    credit_id=${credit_id}
    Check Account Status After Closure    credit_id=${credit_id}

############################################################################################################################################################################
# Set amount Configs

Set Amount Over Balance
    [Documentation]    Sets the amount greater than the initial balance .
    [Arguments]    ${credit_id}=${credit_ids}[0]
    ${find_dic}    Create Dictionary    creditId=${credit_id}
    ${credit_account}    Mongo Db Find    credit-account-mng_db    accounts    ${find_dic}
    ${credit_account_initial_balance}    Set Variable    ${credit_account}[body][0][initialBalance]
    ${credit_account_initial_balance}    Value Handler    input_value=${credit_account_initial_balance}
    ${amount}    Evaluate    ${credit_account_initial_balance}+1
    Set Test Variable    ${amount}

Set Amount Less Than Balance
    [Documentation]    Sets the amount less than the initial balance .
    [Arguments]    ${credit_id}=${credit_ids}[0]
    ${find_dic}    Create Dictionary    creditId=${credit_id}
    ${credit_account}    Mongo Db Find    credit-account-mng_db    accounts    ${find_dic}
    ${credit_account_initial_balance}    Set Variable    ${credit_account}[body][0][initialBalance]
    ${credit_account_initial_balance}    Value Handler    input_value=${credit_account_initial_balance}
    ${amount}    Evaluate    ${credit_account_initial_balance}-1
    IF    ${amount} >= ${MIN_AMOUNT}
        ${amount}    Set Variable    ${MIN_AMOUNT}
    END

    Set Test Variable    ${amount}

Set Amount Equal To Balance
    [Documentation]    Sets the amount equal to the current balance for full credit purchase
    [Arguments]    ${credit_id}=${credit_ids}[0]
    ${find_dic}    Create Dictionary    creditId=${credit_id}
    ${credit_account}    Mongo Db Find    credit-account-mng_db    accounts    ${find_dic}
    ${credit_account_initial_balance}    Set Variable    ${credit_account}[body][0][initialBalance]
    ${credit_account_initial_balance}    Value Handler    input_value=${credit_account_initial_balance}
    Set Test Variable    ${amount}    ${credit_account_initial_balance}

Set Amount For API Channel
    [Documentation]    Sets amount for API channel (payment channel = 0) - only full credit purchases are valid
    [Arguments]    ${credit_id}=${credit_ids}[0]
    Set Amount Equal To Balance    credit_id=${credit_id}

Set Amount For Non API Channel
    [Documentation]    Sets amount for non-API channels - allows partial purchases for most account types
    [Arguments]    ${credit_id}=${credit_ids}[0]
    Set Amount Less Than Balance    credit_id=${credit_id}

Set Amount For Installment Sale API Channel
    [Documentation]    Sets amount for installment sale accounts in API channel - only full credit purchases are valid
    [Arguments]    ${credit_id}=${credit_ids}[0]
    Set Amount Equal To Balance    credit_id=${credit_id}

Set Amount For Installment Sale Non API Channel
    [Documentation]    Sets amount for installment sale accounts in non-API channels - only exact balance is valid
    [Arguments]    ${credit_id}=${credit_ids}[0]
    Set Amount Equal To Balance    credit_id=${credit_id}

Set Amount Zero
    [Documentation]    Sets the amount to zero
    Set Test Variable    ${amount}    0

Set Amount For Partial Purchase
    [Documentation]    Sets amount for partial purchase testing (amount < balance)
    [Arguments]    ${credit_id}=${credit_ids}[0]
    Set Amount Less Than Balance    credit_id=${credit_id}

Set Amount For Full Purchase
    [Documentation]    Sets amount for full purchase testing (amount = balance)
    [Arguments]    ${credit_id}=${credit_ids}[0]
    Set Amount Equal To Balance    credit_id=${credit_id}

Set Amount For Over Purchase
    [Documentation]    Sets amount for over purchase testing (amount > balance)
    [Arguments]    ${credit_id}=${credit_ids}[0]
    Set Amount Over Balance    credit_id=${credit_id}

############################################################################################################################################################################
# Set Product Type Configs

Set Product Type CONSUMPTION GOODS
    [Documentation]    An Intermediary step that sets product type as 1
    Set Test Variable    ${test_product_type}    ${PRODUCT_TYPE.CONSUMPTIONGOODS}

Set Product Type DURABLE GOODS
    [Documentation]    An Intermediary step that sets product type as 1
    Set Test Variable    ${test_product_type}    ${PRODUCT_TYPE.DURABLEGOODS}

Set Product Type SERVICE
    [Documentation]    An Intermediary step that sets product type as 3
    Set Test Variable    ${test_product_type}    ${PRODUCT_TYPE.SERVICE}

Set Product Type DURABLE CONSUMPTION GOODS
    [Documentation]    An Intermediary step that sets product type as 4
    Set Test Variable    ${test_product_type}    ${PRODUCT_TYPE.DURABLECONSUMPTION_GOODS}

Set Product Type EMPTY
    [Documentation]    An Intermediary step that sets product as EMPTY
    Set Test Variable    ${test_product_type}    ${EMPTY}

############################################################################################################################################################################
# Set Product Type Configs

Update Fund Provider To Not Include Product Type CONSUMPTION GOODS
    [Documentation]    Updates the credit_account_mng_db collection fund_providers, for fund provider with businessId: 8edd4fbd-b493-427e-a75a-b28fa24bbc66,    to not include productType ${1}
    &{find_dic}    Create Dictionary    businessId=44afbb26-2c08-4f8e-84e0-46d57407e0b8
    ${product_types}    Create List
    ...    ${${PRODUCT_TYPE.DURABLEGOODS}}
    ...    ${${PRODUCT_TYPE.SERVICE}}
    ...    ${${PRODUCT_TYPE.DURABLECONSUMPTION_GOODS}}
    &{update_query}    Create Dictionary    productTypes=${product_types}
    &{set}    Create Dictionary    $set=&{update_query}
    ${result_credit_account}    Mongo Db Update One
    ...    db_name=credit-account-mng_db
    ...    collection_name=fund_providers
    ...    filter_query= ${find_dic}
    ...    update_data=${set}

Update Fund Provider To Include Product Type CONSUMPTION GOODS
    [Documentation]    Updates the credit_account_mng_db collection fund_providers, for fund provider with businessId: 8edd4fbd-b493-427e-a75a-b28fa24bbc66,    to include productType ${1}
    &{find_dic}    Create Dictionary    businessId=44afbb26-2c08-4f8e-84e0-46d57407e0b8
    ${product_types}    Create List
    ...    ${${PRODUCT_TYPE.CONSUMPTIONGOODS}}
    ...    ${${PRODUCT_TYPE.DURABLEGOODS}}
    ...    ${${PRODUCT_TYPE.SERVICE}}
    ...    ${${PRODUCT_TYPE.DURABLECONSUMPTION_GOODS}}
    &{update_query}    Create Dictionary    productTypes=${product_types}
    &{set}    Create Dictionary    $set=&{update_query}
    ${result_credit_account}    Mongo Db Update One
    ...    db_name=credit-account-mng_db
    ...    collection_name=fund_providers
    ...    filter_query= ${find_dic}
    ...    update_data=${set}

    RETURN

############################################################################################################################################################################
# Calling The Inquiry API

Inquiry API Is Called
    [Documentation]    API calls the inquiry API
    [Arguments]
    ...    ${payment_channel}=${default_channel}
    ...    ${user_id}=${user_id}
    ...    ${amount}=${amount}
    ...    ${business_id}=${LMS_AUTOMATION_BUSINESS_ID}
    ...    ${test_product_type}=${PRODUCT_TYPE.CONSUMPTIONGOODS}
    ...    ${version}=${MANIFEST_PLATFORM_VERSION}
    ...    ${cheque_Eligible}=true
    ...    ${payment_gateway}=${payment_gateway}

    ${response}    POST Credit Gateways Inquiry
    ...    api_call_side=${MICROSERVICE_SIDE}
    ...    payment_channel=${payment_channel}
    ...    user_id=${user_id}
    ...    amount=${amount}
    ...    business_id=${business_id}
    ...    sellerId="default"
    ...    supplier_id="default"
    ...    product_code="default"
    ...    brand="default"
    ...    product_type=${test_product_type}
    ...    count=1
    ...    category_id="default"
    ...    sub_category_ids="default"
    ...    cheque_Eligible=${cheque_Eligible}
    ...    version=${MANIFEST_PLATFORM_VERSION}

    ${response_status_code}    Set Variable    ${response['status_code']}
    ${response_body}    Set Variable    ${response['body']}

    Set Test Variable    ${response_status_code}
    Set Test Variable    ${response_body}

############################################################################################################################################################################
# Repayment Options Assertions

Inquiry List Must Be Empty
    [Documentation]    An assertion that checks whether the inquiryList is an Empty List
    [Arguments]    ${response_body}=${response_body}
    ${result}    Set Variable    ${response_body['result']}
    ${result_title}    Set Variable    ${result['title']}
    Should Be Equal As Strings
    ...    first=${result_title}
    ...    second=SUCCESS
    ...    msg=Got ${result_title} as the result but expected SUCCESS
    ${inquiry_list}    Set Variable    ${response_body['inquiryList']}
    ${length}    Get Length    ${inquiry_list}

    Should Be Equal As Integers
    ...    first=${length}
    ...    second=0
    ...    msg=Major: Inquiry Failed! Expected the length to be 0, but got ${length}

Inquiry List Must Have The Length
    [Documentation]    An assertion that checks whether the inquiryList is a list with a specific Length
    [Arguments]    ${expected_length}    ${response_body}=${response_body}
    ${result}    Set Variable    ${response_body['result']}
    ${result_title}    Set Variable    ${result['title']}
    Should Be Equal As Strings
    ...    first=${result_title}
    ...    second=SUCCESS
    ...    msg=Got ${result_title} as the result but expected SUCCESS
    ${inquiry_list}    Set Variable    ${response_body['inquiryList']}
    ${length}    Get Length    ${inquiry_list}

    Should Be Equal As Integers
    ...    first=${length}
    ...    second=${expected_length}
    ...    msg=Major: Inquiry Failed! Expected the length to be ${expected_length}, but got ${length}

############################################################################################################################################################################
# Status Assertions

Inquiry List Status Must Be Sufficient
    Validate Inquiry List Status    expected_status=1

Inquiry List Status Must Be Insufficient
    Validate Inquiry List Status    expected_status=2

Inquiry List Status Must Be Unusable
    Validate Inquiry List Status    expected_status=0

Validate Inquiry List Status
    [Arguments]    ${expected_status}    ${credit_id}=${credit_ids}[0]    ${response_body}=${response_body}
    ${inquiry_list}    Set Variable    ${response_body['inquiryList']}
    ${length}    Get Length    ${inquiry_list}

    IF    '${expected_status}' == '0'
        ${account_status}    Get Account Status If Needed    ${credit_id}
        IF    '${account_status}' == '3' or '${account_status}' == '4'
            FOR    ${i}    IN RANGE    ${length}
                ${inquiry_i}    Set Variable    ${inquiry_list}[${i}]
                IF    '${default_channel}' != '0'
                    Validate Projection For Inquiry    ${inquiry_i}
                END
            END
        ELSE
            FOR    ${i}    IN RANGE    ${length}
                ${inquiry_i}    Set Variable    ${inquiry_list}[${i}]
                Should Be Equal    ${inquiry_i['purchaseProjection']}    ${None}
            END
        END
    ELSE
        FOR    ${i}    IN RANGE    ${length}
            ${inquiry_i}    Set Variable    ${inquiry_list}[${i}]
            IF    '${default_channel}' != '0'
                Validate Projection For Inquiry    ${inquiry_i}
            END
        END
    END

    FOR    ${i}    IN RANGE    ${length}
        ${inquiry_i}    Set Variable    ${inquiry_list}[${i}]
        ${status}    Set Variable    ${inquiry_i['status']}
        Should Be Equal As Strings
        ...    first=${status}
        ...    second=${expected_status}
        ...    msg=Expected status of inquiry item ${i} to be ${expected_status} but got ${status}
    END

Validate Projection For Inquiry
    [Arguments]    ${inquiry_i}
    ${projection}    Set Variable    ${inquiry_i['purchaseProjection']}
    Should Not Be Empty    ${projection}
    ${cashAmount}    Set Variable    ${projection['cashAmount']}
    ${creditAmount}    Set Variable    ${projection['creditAmount']}
    ${is_num1}    Evaluate    isinstance(${cashAmount}, (int, float))
    ${is_num2}    Evaluate    isinstance(${creditAmount}, (int, float))
    Should Be True    ${is_num1}
    Should Be True    ${is_num2}

Get Account Status If Needed
    [Arguments]    ${credit_id}
    ${find_dic}    Create Dictionary    creditId=${credit_id}
    ${account}    Mongo Db Find    credit-account-mng_db    accounts    ${find_dic}
    ${body}    Set Variable    ${account['body']}
    ${first_item}    Set Variable    ${body[0]}
    ${account_status}    Set Variable    ${first_item['status']}
    RETURN    ${account_status}

############################################################################################################################################################################
# Remain Balance Assertions

Remain Balance Must Be Accurate
    [Documentation]    Check the remaining Balance field to have the accurate amount
    [Arguments]    ${expected_balance}    ${response_body}=${response_body}
    ${inquiry_list}    Set Variable    ${response_body['inquiryList']}
    ${length}    Get Length    ${inquiry_list}
    FOR    ${i}    IN RANGE    ${0}    ${length}    ${1}
        ${inquiry_i}    Set Variable    ${inquiry_list}[${i}]
        ${remain_balance}    Set Variable    ${inquiry_i['remainBalance']}
        Should Be Equal As Integers
        ...    first=${remain_balance}
        ...    second=${expected_balance}
        ...    msg=Expected the inquiry item ${i} to have remainBalance of ${expected_balance} but got ${remain_balance}
    END

############################################################################################################################################################################
# Service Type Assertions

Service Type Must Be Accurate
    [Documentation]    Check the service type field to have the accurate value
    [Arguments]    ${expected_service_types}    ${response_body}=${response_body}
    ${inquiry_list}    Set Variable    ${response_body['inquiryList']}
    ${length}    Get Length    ${inquiry_list}
    FOR    ${i}    IN RANGE    ${0}    ${length}    ${1}
        ${inquiry_i}    Set Variable    ${inquiry_list}[${i}]
        ${serviceType}    Set Variable    ${inquiry_i['serviceType']}
        ${expected_service_type}    Set Variable    ${expected_service_types}[${i}]
        Should Be Equal As Integers
        ...    first=${serviceType}
        ...    second=${expected_service_type}
        ...    msg=Expected the inquiry item ${i} to have service type of ${expected_service_type} but got ${serviceType}
    END

############################################################################################################################################################################
# Status Code    Assertions

Status Code Must Be 200
    [Documentation]    Check the Status Code Of The Inquiry API
    [Arguments]    ${status_code}=${response_status_code}
    Should Be Equal As Integers
    ...    first=${status_code}
    ...    second=200
    ...    msg=Expected The Status Code to be 200 but got ${status_code}

Status Code Must Be 422
    [Documentation]    Check the Status Code Of The Inquiry API
    [Arguments]    ${status_code}=${response_status_code}
    Should Be Equal As Integers
    ...    first=${status_code}
    ...    second=422
    ...    msg=Expected The Status Code to be 422 but got ${status_code}

############################################################################################################################################################################
# Remain Balance Null Assertions

Remain Balance Must Be Null
    [Documentation]    Check the remaining Balance field to be null
    [Arguments]    ${response_body}=${response_body}
    ${inquiry_list}    Set Variable    ${response_body['inquiryList']}
    ${length}    Get Length    ${inquiry_list}
    FOR    ${i}    IN RANGE    ${0}    ${length}    ${1}
        ${inquiry_i}    Set Variable    ${inquiry_list}[${i}]
        ${remain_balance}    Set Variable    ${inquiry_i['remainBalance']}
        Should Be Equal
        ...    first=${remain_balance}
        ...    second=${None}
        ...    msg=Expected the inquiry item ${i} to have remainBalance of null but got ${remain_balance}
    END

All Remain Balance Must Be Null
    [Documentation]    Check all remaining Balance fields to be null
    [Arguments]    ${response_body}=${response_body}
    ${inquiry_list}    Set Variable    ${response_body['inquiryList']}
    ${length}    Get Length    ${inquiry_list}
    FOR    ${i}    IN RANGE    ${0}    ${length}    ${1}
        ${inquiry_i}    Set Variable    ${inquiry_list}[${i}]
        ${remain_balance}    Set Variable    ${inquiry_i['remainBalance']}
        Should Be Equal
        ...    first=${remain_balance}
        ...    second=${None}
        ...    msg=Expected the inquiry item ${i} to have remainBalance of null but got ${remain_balance}
    END

############################################################################################################################################################################
# Payment Channel Setting Keywords

Set Payment Channel API
    [Documentation]    Sets the payment channel to 0 for testing
    Set Test Variable    ${default_channel}    0

Set Payment Channel UPG
    [Documentation]    Sets the payment channel to UPG
    Set Test Variable    ${default_channel}    ${CHANNEL.UPG}

Set Payment Channel SMART_POS
    [Documentation]    Sets the payment channel to SMART_POS
    Set Test Variable    ${default_channel}    ${CHANNEL.SMART_POS}

Set Payment Channel QR
    [Documentation]    Sets the payment channel to QR
    Set Test Variable    ${default_channel}    ${CHANNEL.QR}

Set Payment Channel BARCODE
    [Documentation]    Sets the payment channel to BARCODE
    Set Test Variable    ${default_channel}    ${CHANNEL.BARCODE}

Set Payment Channel LINUX_POS
    [Documentation]    Sets the payment channel to LINUX_POS
    Set Test Variable    ${default_channel}    ${CHANNEL.LINUX_POS}

Set Payment Channel PLATFORM_CARD
    [Documentation]    Sets the payment channel to PLATFORM_CARD
    Set Test Variable    ${default_channel}    ${CHANNEL.PLATFORM_CARD}

Set Invalid Payment Channel
    [Documentation]    Sets an invalid payment channel for error testing
    Set Test Variable    ${default_channel}    999

Set Negative Payment Channel
    [Documentation]    Sets a negative payment channel for error testing
    Set Test Variable    ${default_channel}    -1

############################################################################################################################################################################
# Account Status Setting Keywords

Set Account To Inactive
    [Documentation]    Sets an account to inactive status
    [Arguments]    ${credit_id}=${credit_ids}[0]
    ${find_dic}    Create Dictionary    creditId=${credit_id}
    ${update_query}    Create Dictionary    status=2
    &{set}    Create Dictionary    $set=&{update_query}
    ${result}    Mongo Db Update One
    ...    db_name=credit-account-mng_db
    ...    collection_name=accounts
    ...    filter_query=${find_dic}
    ...    update_data=${set}

Set Negative Amount
    [Documentation]    Sets a negative balance for testing
    Set Test Variable    ${amount}    -1

############################################################################################################################################################################
# Modified API Call Keywords

Inquiry API Is Called Without Payment Channel
    [Documentation]    API calls the inquiry API without payment channel parameter
    [Arguments]
    ...    ${user_id}=${user_id}
    ...    ${amount}=${amount}
    ...    ${business_id}=${LMS_AUTOMATION_BUSINESS_ID}
    ...    ${test_product_type}=${PRODUCT_TYPE.CONSUMPTIONGOODS}
    ...    ${version}=${MANIFEST_PLATFORM_VERSION}
    ...    ${cheque_Eligible}=true
    ...    ${payment_gateway}=${payment_gateway}

    ${response}    POST Credit Gateways Inquiry
    ...    api_call_side=${MICROSERVICE_SIDE}
    ...    payment_channel=${EMPTY}
    ...    user_id=${user_id}
    ...    amount=${amount}
    ...    business_id=${business_id}
    ...    sellerId="default"
    ...    supplier_id="default"
    ...    product_code="default"
    ...    brand="default"
    ...    product_type=${test_product_type}
    ...    count=1
    ...    category_id="default"
    ...    sub_category_ids="default"
    ...    cheque_Eligible=${cheque_Eligible}
    ...    version=${MANIFEST_PLATFORM_VERSION}

    ${response_status_code}    Set Variable    ${response['status_code']}
    ${response_body}    Set Variable    ${response['body']}

    Set Test Variable    ${response_status_code}
    Set Test Variable    ${response_body}

Call Schedule Close API
    [Documentation]    Checks if the response status code is 200
    [Arguments]    ${credit_id}=${credit_ids}[0]
    ${schedule_close_response}    Post Credit Accounts Schedule Close
    ...    ${MICROSERVICE_SIDE}
    ...    ${credit_ids}[0]
    ...    ${LMS_BLOCK_REASON.ORGANIZATION_REQUEST}
    ...    ${DASHBOARD_USERNAME}
    Set Test Variable    ${schedule_close_response}

Check Inquiry Status Of Account
    [Documentation]    Check the status of each inquiry item in the inquiry list according to the status list given as argument
    [Arguments]    @{expected_status_list}    ${response_body}=${response_body}
    ${inquiry_list}    Set Variable    ${response_body}[inquiryList]
    ${inquiry_list_length}    Get Length    ${inquiry_list}
    ${expected_status_list_length}    Get Length    ${expected_status_list}
    Should Be Equal As Integers
    ...    first=${inquiry_list_length}
    ...    second=${expected_status_list_length}
    ...    msg=Expected the length of inquiry list to be equal to the length of expected status list but got ${inquiry_list_length} and ${expected_status_list_length} respectively
    FOR    ${i}    IN RANGE    ${0}    ${inquiry_list_length}    ${1}
        ${inquiry_i}    Set Variable    ${inquiry_list}[${i}]
        ${status}    Set Variable    ${inquiry_i['status']}
        ${expected_status}    Set Variable    ${expected_status_list}[${i}]
        Should Be Equal As Strings
        ...    first=${status}
        ...    second=${expected_status}
        ...    msg=Expected status of inquiry item ${i} to be ${expected_status} but got ${status}
    END

Inquiry Item Status Must Be
    [Documentation]    Status Check for specific inquiry list item by index
    [Arguments]    ${index}    ${expected_status}    ${response_body}=${response_body}
    ${inquiry_list}    Set Variable    ${response_body['inquiryList']}
    ${inquiry_i}    Set Variable    ${inquiry_list}[${index}]
    ${status}    Set Variable    ${inquiry_i['status']}
    Should Be Equal As Strings
    ...    first=${status}
    ...    second=${expected_status}
    ...    msg=Expected status of inquiry item ${index} to be ${expected_status} but got ${status}
