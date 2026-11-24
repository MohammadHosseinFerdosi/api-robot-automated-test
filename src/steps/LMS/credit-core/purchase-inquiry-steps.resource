*** Settings ***
Resource    services/backend/import-allocation.resource
Resource    services/backend/LMS/credit-core/credit-online-purchase.resource
Resource    apis/lms/credit-core/post-admin-credit-accounts-block.resource
Resource    apis/lms/credit-core/post-credit-gateway-activate.resource
Resource    apis/lms/credit-core/post-credit-gateways-disable.resource
Resource    services/backend/LMS/credit-core/close-account.resource
Resource    services/backend/user-wallet-initializer-service.resource
Resource    apis/lms/credit-core/post-credit-purchase-inquiry.resource


*** Keywords ***
############################################################################################################################################################################
# Merchant Initialization
Initialize Merchant
    [Documentation]    This is a ```Test Setup``` that generated a merchant that can be used to perform a purchases on and validate the API\
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

############################################################################################################################################################################
# Allocations

Allocate No Fee 1PAY Account
    [Documentation]    Allocates a no fee 1pay account. Returns the ${cell_number}, ${credit_ids} as a list, and ${user_id} for the allocated user.
    ...    Sets these variables as ```Set Test Variable```.

    ${user_object}    Activate Account
    ...    types=${{['${LMS_Account_Type_1PAY}']}}
    ...    fee_types=${{['${LMS_ZERO_FEE}']}}
    ...    default_amount=30000

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
    ...    fee_types=${{['${LMS_ZERO_FEE}']}}
    ...    default_amount=30000

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
    ...    fee_types=${{['${LMS_ZERO_FEE}']}}
    ...    default_amount=30000

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
    ...    fee_types=${{['${LMS_ZERO_FEE}']}}
    ...    default_amount=30000

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
    ...    fee_types=${{['${LMS_FEE_ON_PURCHASE}']}}
    ...    default_amount=30000

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
    ...    fee_types=${{['${LMS_FEE_ON_PURCHASE}']}}
    ...    default_amount=30000

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
    ...    fee_types=${{['${LMS_FEE_ON_PURCHASE}']}}
    ...    default_amount=30000

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

Set channel UPG
    [Documentation]    This is a basic set function that sets these variables to the environment so that they can be accessed later on.
    Set Test Variable    ${default_channel}    ${CHANNEL.UPG}

Set channel SMART_POS
    [Documentation]    This is a basic set function that sets these variables to the environment so that they can be accessed later on.
    Set Test Variable    ${default_channel}    ${CHANNEL.SMART_POS}

Set channel QR
    [Documentation]    This is a basic set function that sets these variables to the environment so that they can be accessed later on.
    Set Test Variable    ${default_channel}    ${CHANNEL.QR}

Set channel BARCODE
    [Documentation]    This is a basic set function that sets these variables to the environment so that they can be accessed later on.
    Set Test Variable    ${default_channel}    ${CHANNEL.BARCODE}

Set channel LINUX_POS
    [Documentation]    This is a basic set function that sets these variables to the environment so that they can be accessed later on.
    Set Test Variable    ${default_channel}    ${CHANNEL.LINUX_POS}

Set channel PAYMENT_LINK
    [Documentation]    This is a basic set function that sets these variables to the environment so that they can be accessed later on.
    Set Test Variable    ${default_channel}    ${CHANNEL.PAYMENT_LINK}

Set channel API
    [Documentation]    This is a basic set function that sets these variables to the environment so that they can be accessed later on.
    Set Test Variable    ${default_channel}    ${CHANNEL.API}

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
    ...    ${repeat_count}=10

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
    ...    ${repeat_count}=10

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

Purchase Status Must Be DELIVERED
    [Arguments]    ${tracking_code}=${tracking_code}
    ${filter_query}    Create Dictionary    trackingCode=${tracking_code}
    ${result}    Mongo Db Find
    ...    credit_mng_db
    ...    purchases
    ...    ${filter_query}
    @{records}    Get From Dictionary    ${result}    body
    ${result_object}    Set Variable    ${records}[0]
    IF    '${result_object['status']}' != 'DELIVERED'
        Fail
        ...    msg=Expected the status for the purchase to be either CONFIRMED or DELIVERED but got ${result_object['status']}!
    END

Wait For The Purchase To Be Assigned To The Billing Cycle
    [Arguments]    ${purchase_tracking_code}=${tracking_code}
    Wait Until Keyword Succeeds
    ...    2 minute
    ...    10 s
    ...    Purchase Should Be Assigned To The Billing Cycle
    ...    tracking_code=${purchase_tracking_code}

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
    [Documentation]    Sets the amount greater than the initial balance .
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
    [Documentation]    Sets the amount Equal to the initial balance .
    [Arguments]    ${credit_id}=${credit_ids}[0]
    ${find_dic}    Create Dictionary    creditId=${credit_id}
    ${credit_account}    Mongo Db Find    credit-account-mng_db    accounts    ${find_dic}
    ${credit_account_initial_balance}    Set Variable    ${credit_account}[body][0][initialBalance]
    ${credit_account_initial_balance}    Value Handler    input_value=${credit_account_initial_balance}
    ${amount}    Evaluate    "${credit_account_initial_balance}"

    Set Test Variable    ${amount}

############################################################################################################################################################################
# Online Purchase

Performed An Initiated Online Purchase
    [Documentation]    Performs an initiated online purchase.
    [Arguments]
    ...    ${credit_id}=${credit_ids}[0]
    ...    ${user_id}=${user_id}
    ...    ${cell_number}=${cell_number}
    ...    ${business_id}=${LMS_AUTOMATION_BUSINESS_ID}
    ...    ${default_channel}=${default_channel}
    ...    ${amount}=${amount}

    ${filter_query}    Create Dictionary    creditId=${credit_id}
    ${result}    Mongo Db Find    switch_credit_db    activations    ${filter_query}
    ${body}    Set Variable    ${result}[body][0]
    ${s_type}    Set Variable    ${body['serviceType']}
    ${type}    Set Variable    13
    IF    '${s_type}'=='CREDIT'
        ${type}    Set Variable    5
    END
    IF    '${s_type}'=='INSTALLMENT_SALE'
        ${type}    Set Variable    26
    END
    ${skip_steps}    Create List    prepare    route_info    credit_pay    verify    deliver

    ${ticket}    ${tracking_code}    Perform A Complete Online Credit Purchase
    ...    type=${type}
    ...    cell_number=${cell_number}
    ...    user_id=${user_id}
    ...    credit_id=${credit_id}
    ...    amount=${amount}
    ...    business_id=${business_id}
    ...    channel=${default_channel}
    ...    skip=${skip_steps}

    Set Test Variable    ${ticket}
    Set Test Variable    ${tracking_code}
    Set Test Variable    ${type}

Performed A Prepared Online Purchase
    [Documentation]    Performs a prepared online purchase.
    [Arguments]
    ...    ${credit_id}=${credit_ids}[0]
    ...    ${user_id}=${user_id}
    ...    ${cell_number}=${cell_number}
    ...    ${business_id}=${LMS_AUTOMATION_BUSINESS_ID}
    ...    ${default_channel}=${default_channel}
    ...    ${amount}=${amount}

    ${filter_query}    Create Dictionary    creditId=${credit_id}
    ${result}    Mongo Db Find    switch_credit_db    activations    ${filter_query}
    ${body}    Set Variable    ${result}[body][0]
    ${s_type}    Set Variable    ${body['serviceType']}
    ${type}    Set Variable    13
    IF    '${s_type}'=='CREDIT'
        ${type}    Set Variable    5
    END
    IF    '${s_type}'=='INSTALLMENT_SALE'
        ${type}    Set Variable    26
    END
    ${skip_steps}    Create List    route_info    credit_pay    verify    deliver

    ${ticket}    ${tracking_code}    Perform A Complete Online Credit Purchase
    ...    type=${type}
    ...    cell_number=${cell_number}
    ...    user_id=${user_id}
    ...    credit_id=${credit_id}
    ...    amount=${amount}
    ...    business_id=${business_id}
    ...    channel=${default_channel}
    ...    skip=${skip_steps}

    Set Test Variable    ${ticket}
    Set Test Variable    ${tracking_code}
    Set Test Variable    ${type}

Performed A Routed Online Purchase
    [Documentation]    Performs a Routed online purchase.
    [Arguments]
    ...    ${credit_id}=${credit_ids}[0]
    ...    ${user_id}=${user_id}
    ...    ${cell_number}=${cell_number}
    ...    ${business_id}=${LMS_AUTOMATION_BUSINESS_ID}
    ...    ${default_channel}=${default_channel}
    ...    ${amount}=${amount}

    ${filter_query}    Create Dictionary    creditId=${credit_id}
    ${result}    Mongo Db Find    switch_credit_db    activations    ${filter_query}
    ${body}    Set Variable    ${result}[body][0]
    ${s_type}    Set Variable    ${body['serviceType']}
    ${type}    Set Variable    13
    IF    '${s_type}'=='CREDIT'
        ${type}    Set Variable    5
    END
    IF    '${s_type}'=='INSTALLMENT_SALE'
        ${type}    Set Variable    26
    END
    ${skip_steps}    Create List    credit_pay    verify    deliver

    ${ticket}    ${tracking_code}    Perform A Complete Online Credit Purchase
    ...    type=${type}
    ...    cell_number=${cell_number}
    ...    user_id=${user_id}
    ...    credit_id=${credit_id}
    ...    amount=${amount}
    ...    business_id=${business_id}
    ...    channel=${default_channel}
    ...    skip=${skip_steps}

    Set Test Variable    ${ticket}
    Set Test Variable    ${tracking_code}
    Set Test Variable    ${type}

Performed A Paid Online Purchase
    [Documentation]    Performs a paid online purchase.
    [Arguments]
    ...    ${credit_id}=${credit_ids}[0]
    ...    ${user_id}=${user_id}
    ...    ${cell_number}=${cell_number}
    ...    ${business_id}=${LMS_AUTOMATION_BUSINESS_ID}
    ...    ${default_channel}=${default_channel}
    ...    ${amount}=${amount}

    ${filter_query}    Create Dictionary    creditId=${credit_id}
    ${result}    Mongo Db Find    switch_credit_db    activations    ${filter_query}
    ${body}    Set Variable    ${result}[body][0]
    ${s_type}    Set Variable    ${body['serviceType']}
    ${type}    Set Variable    13
    IF    '${s_type}'=='CREDIT'
        ${type}    Set Variable    5
    END
    IF    '${s_type}'=='INSTALLMENT_SALE'
        ${type}    Set Variable    26
    END
    ${skip_steps}    Create List    verify    deliver

    ${ticket}    ${tracking_code}    Perform A Complete Online Credit Purchase
    ...    type=${type}
    ...    cell_number=${cell_number}
    ...    user_id=${user_id}
    ...    credit_id=${credit_id}
    ...    amount=${amount}
    ...    business_id=${business_id}
    ...    channel=${default_channel}
    ...    skip=${skip_steps}

    Set Test Variable    ${ticket}
    Set Test Variable    ${tracking_code}
    Set Test Variable    ${type}

Performed A Verified Online Purchase
    [Documentation]    Performs a verified online purchase.
    [Arguments]
    ...    ${credit_id}=${credit_ids}[0]
    ...    ${user_id}=${user_id}
    ...    ${cell_number}=${cell_number}
    ...    ${business_id}=${LMS_AUTOMATION_BUSINESS_ID}
    ...    ${default_channel}=${default_channel}
    ...    ${amount}=${amount}

    ${filter_query}    Create Dictionary    creditId=${credit_id}
    ${result}    Mongo Db Find    switch_credit_db    activations    ${filter_query}
    ${body}    Set Variable    ${result}[body][0]
    ${s_type}    Set Variable    ${body['serviceType']}
    ${type}    Set Variable    13
    IF    '${s_type}'=='CREDIT'
        ${type}    Set Variable    5
    END
    IF    '${s_type}'=='INSTALLMENT_SALE'
        ${type}    Set Variable    26
    END
    ${skip_steps}    Create List    deliver

    ${ticket}    ${tracking_code}    Perform A Complete Online Credit Purchase
    ...    type=${type}
    ...    cell_number=${cell_number}
    ...    user_id=${user_id}
    ...    credit_id=${credit_id}
    ...    amount=${amount}
    ...    business_id=${business_id}
    ...    channel=${default_channel}
    ...    skip=${skip_steps}

    Set Test Variable    ${ticket}
    Set Test Variable    ${tracking_code}
    Set Test Variable    ${type}

Performed A Delivered Online Purchase
    [Documentation]    Performs a delivered online purchase.
    [Arguments]
    ...    ${credit_id}=${credit_ids}[0]
    ...    ${user_id}=${user_id}
    ...    ${cell_number}=${cell_number}
    ...    ${business_id}=${LMS_AUTOMATION_BUSINESS_ID}
    ...    ${default_channel}=${default_channel}
    ...    ${amount}=${amount}

    ${filter_query}    Create Dictionary    creditId=${credit_id}
    ${result}    Mongo Db Find    switch_credit_db    activations    ${filter_query}
    ${body}    Set Variable    ${result}[body][0]
    ${s_type}    Set Variable    ${body['serviceType']}
    ${type}    Set Variable    13
    IF    '${s_type}'=='CREDIT'
        ${type}    Set Variable    5
    END
    IF    '${s_type}'=='INSTALLMENT_SALE'
        ${type}    Set Variable    26
    END

    ${ticket}    ${tracking_code}    Perform A Complete Online Credit Purchase
    ...    type=${type}
    ...    cell_number=${cell_number}
    ...    user_id=${user_id}
    ...    credit_id=${credit_id}
    ...    amount=${amount}
    ...    business_id=${business_id}
    ...    channel=${default_channel}

    Set Test Variable    ${ticket}
    Set Test Variable    ${tracking_code}
    Set Test Variable    ${type}

############################################################################################################################################################################
# Offline Purchase

Performed An Initiated Offline Purchase
    [Documentation]    Performs an initiated offline purchase.
    [Arguments]
    ...    ${credit_id}=${credit_ids}[0]
    ...    ${user_id}=${user_id}
    ...    ${business_id}=${LMS_AUTOMATION_BUSINESS_ID}
    ...    ${default_channel}=${default_channel}
    ...    ${amount}=${amount}

    ${skip_steps}    Create List    pay    pay_cash_result    verify    deliver

    ${tracking_code}    Perform A Complete Offline Purchase
    ...    user_id=${user_id}
    ...    credit_id=${credit_id}
    ...    amount=${amount}
    ...    business_id=${business_id}
    ...    channel=${default_channel}
    ...    skip=${skip_steps}

    Set Test Variable    ${tracking_code}

Performed A Paid Offline Purchase
    [Documentation]    Performs a paid offline purchase.
    [Arguments]
    ...    ${credit_id}=${credit_ids}[0]
    ...    ${user_id}=${user_id}
    ...    ${business_id}=${LMS_AUTOMATION_BUSINESS_ID}
    ...    ${default_channel}=${default_channel}
    ...    ${amount}=${amount}

    ${skip_steps}    Create List    pay_cash_result    verify    deliver

    ${tracking_code}    Perform A Complete Offline Purchase
    ...    user_id=${user_id}
    ...    credit_id=${credit_id}
    ...    amount=${amount}
    ...    business_id=${business_id}
    ...    channel=${default_channel}
    ...    skip=${skip_steps}

    Set Test Variable    ${tracking_code}

Performed A Cash Paid Offline Purchase
    [Documentation]    Performs a cash paid offline purchase.
    [Arguments]
    ...    ${credit_id}=${credit_ids}[0]
    ...    ${user_id}=${user_id}
    ...    ${business_id}=${LMS_AUTOMATION_BUSINESS_ID}
    ...    ${default_channel}=${default_channel}
    ...    ${amount}=${amount}

    ${skip_steps}    Create List    verify    deliver

    ${tracking_code}    Perform A Complete Offline Purchase
    ...    user_id=${user_id}
    ...    credit_id=${credit_id}
    ...    amount=${amount}
    ...    business_id=${business_id}
    ...    channel=${default_channel}
    ...    skip=${skip_steps}

    Set Test Variable    ${tracking_code}

Performed A Verified Offline Purchase
    [Documentation]    Performs a verified offline purchase.
    [Arguments]
    ...    ${credit_id}=${credit_ids}[0]
    ...    ${user_id}=${user_id}
    ...    ${business_id}=${LMS_AUTOMATION_BUSINESS_ID}
    ...    ${default_channel}=${default_channel}
    ...    ${amount}=${amount}

    ${skip_steps}    Create List    deliver

    ${tracking_code}    Perform A Complete Offline Purchase
    ...    user_id=${user_id}
    ...    credit_id=${credit_id}
    ...    amount=${amount}
    ...    business_id=${business_id}
    ...    channel=${default_channel}
    ...    skip=${skip_steps}

    Set Test Variable    ${tracking_code}

Performed A Delivered Offline Purchase
    [Documentation]    Performs a delivered offline purchase.
    [Arguments]
    ...    ${credit_id}=${credit_ids}[0]
    ...    ${user_id}=${user_id}
    ...    ${business_id}=${LMS_AUTOMATION_BUSINESS_ID}
    ...    ${default_channel}=${default_channel}
    ...    ${amount}=${amount}

    ${tracking_code}    Perform A Complete Offline Purchase
    ...    user_id=${user_id}
    ...    credit_id=${credit_id}
    ...    amount=${amount}
    ...    business_id=${business_id}
    ...    channel=${default_channel}

    Set Test Variable    ${tracking_code}

############################################################################################################################################################################
# Purchase Expire And Reverse

Check Purchase Status And Fails If Not Expired
    [Documentation]    An intermediatory step that checks the status of the purchase and fails if it is not EXPIRED
    [Arguments]    ${tracking_code}=${tracking_code}

    ${filter_query}    Create Dictionary    trackingCode=${tracking_code}
    ${result}    Mongo Db Find
    ...    credit_mng_db
    ...    purchases
    ...    ${filter_query}
    @{records}    Get From Dictionary    ${result}    body
    ${result_object}    Set Variable    ${records}[0]
    IF    '${result_object['status']}' != 'EXPIRED'
        Fail
        ...    msg=Expected the status for the purchase to be Expired but got ${result_object['status']}!
    END

Expire The Online Purchase
    [Documentation]    Waits until an online purchase Expires
    [Arguments]    ${tracking_code}=${tracking_code}

    ${filter_query}    Create Dictionary    trackingCode=${tracking_code}
    ${result}    Mongo Db Find
    ...    credit_mng_db
    ...    purchases
    ...    ${filter_query}
    @{records}    Get From Dictionary    ${result}    body
    ${result_object}    Set Variable    ${records}[0]
    ${creation_date}    Value Handler    ${result_object['creationDate']}

    ${end_Date}    Evaluate    int(${creation_date} + 1)

    &{find_dic}    Create Dictionary    trackingCode=${tracking_code}
    &{update_query}    Create Dictionary    expirationDate=${end_Date}
    &{set}    Create Dictionary    $set=&{update_query}

    ${result_credit_account}    Mongo Db Update One
    ...    db_name=credit_mng_db
    ...    collection_name=purchases
    ...    filter_query=${find_dic}
    ...    update_data=${set}

    Wait Until Keyword Succeeds
    ...    5 minute
    ...    10 s
    ...    Check Purchase Status And Fails If Not Expired
    ...    tracking_code=${tracking_code}

Perform A Reverse Initiated Offline Purchase
    [Documentation]    Initiates the reverse procedures on a `PAID` offline purchase
    [Arguments]
    ...    ${credit_id}=${credit_ids}[0]
    ...    ${user_id}=${user_id}
    ...    ${business_id}=${LMS_AUTOMATION_BUSINESS_ID}
    ...    ${default_channel}=${default_channel}
    ...    ${amount}=${amount}

    ${tracking_code}    Perform A Reversed Offline Purchase
    ...    user_id=${user_id}
    ...    credit_id=${credit_id}
    ...    amount=${amount}
    ...    business_id=${business_id}
    ...    channel=${default_channel}

    Set Test Variable    ${tracking_code}

Check Purchase Status And Fails If Not REVERSED
    [Documentation]    An intermediatory step that checks the status of the purchase and fails if it is not REVERSED
    [Arguments]    ${tracking_code}=${tracking_code}

    ${filter_query}    Create Dictionary    trackingCode=${tracking_code}
    ${result}    Mongo Db Find
    ...    credit_mng_db
    ...    purchases
    ...    ${filter_query}
    @{records}    Get From Dictionary    ${result}    body
    ${result_object}    Set Variable    ${records}[0]
    IF    '${result_object['status']}' != 'REVERSED'
        Fail
        ...    msg=Expected the status for the purchase to be REVERSED but got ${result_object['status']}!
    END

The Purchase Is Reversed
    [Documentation]    Waits until an online purchase Expires
    [Arguments]    ${tracking_code}=${tracking_code}

    Wait Until Keyword Succeeds
    ...    5 minute
    ...    10 s
    ...    Check Purchase Status And Fails If Not REVERSED
    ...    tracking_code=${tracking_code}

############################################################################################################################################################################
# Purchase Inquiry API

The Purchase Inquiry Is Called
    [Documentation]    Simply calls the API and returns it status and Body
    [Arguments]
    ...    ${api_call_side}=${MICROSERVICE_SIDE}
    ...    ${business_id}=${LMS_AUTOMATION_BUSINESS_ID}
    ...    ${provider_id}=${EMPTY}
    ...    ${tracking_code}=${tracking_code}

    ${filter_query}    Create Dictionary    trackingCode=${tracking_code}
    ${result}    Mongo Db Find
    ...    credit_mng_db
    ...    purchases
    ...    ${filter_query}
    @{records}    Get From Dictionary    ${result}    body
    ${purchase_cc}    Set Variable    ${records}[0]

    IF    '${provider_id}'=='${EMPTY}'
        ${provider_id}    Set Variable    ${purchase_cc['providerId']}
    END

    ${result}    Post Credit Purchase Inquiry
    ...    api_call_side=${api_call_side}
    ...    user_id=${business_id}
    ...    provider_id=${provider_id}
    ...    tracking_code=${tracking_code}

    ${purchase_inquiry_status_code}    Set Variable    ${result['status_code']}
    ${purchase_inquiry_body}    Set Variable    ${EMPTY}
    IF    '${purchase_inquiry_status_code}'=='200' or '${purchase_inquiry_status_code}'=='422'
        ${purchase_inquiry_body}    Set Variable    ${result['body']}
    END

    Set Test Variable    ${purchase_inquiry_status_code}
    Set Test Variable    ${purchase_inquiry_body}
    Set Test Variable    ${purchase_cc}

############################################################################################################################################################################
# Assertions

The Purchase Inquiry Should Have Failed
    [Arguments]    ${purchase_inquiry_status_code}=${purchase_inquiry_status_code}

    IF    '${purchase_inquiry_status_code}'=='200'
        Fail    msg=Expected The Purchase Inquiry To Fail, but got status_code ${purchase_inquiry_status_code}
    END

The Purchase Inquiry Error Should Be Inconsistent Purchase
    [Arguments]    ${purchase_inquiry_body}=${purchase_inquiry_body}

    ${expected_message}    Set Variable    این خرید با داده های متفاوتی قبلا ثبت شده است
    ${result}    Set Variable    ${purchase_inquiry_body['result']}
    ${message}    Set Variable    ${result['message']}

    IF    '${message}'!='${expected_message}'
        Fail
        ...    msg=Expected The Purchase Inquiry To Fail with the invalid purchase error message ${expected_message}; but got ${message}
    END

The Purchase Inquiry Error Should Be Purchase Not Found
    [Arguments]    ${purchase_inquiry_body}=${purchase_inquiry_body}

    ${expected_message}    Set Variable    اطلاعات خرید یافت نشد.
    ${result}    Set Variable    ${purchase_inquiry_body['result']}
    ${message}    Set Variable    ${result['message']}

    IF    '${message}'!='${expected_message}'
        Fail
        ...    msg=Expected The Purchase Inquiry To Fail with the purchase not found error message ${expected_message}; but got ${message}
    END

The Purchase Inquiry Should Have Succeeded
    [Arguments]    ${purchase_inquiry_status_code}=${purchase_inquiry_status_code}

    IF    '${purchase_inquiry_status_code}'!='200'
        Fail    msg=Expected The Purchase Inquiry To Succeed, but got status_code ${purchase_inquiry_status_code}
    END

The Purchase Inquiry Status Must Be
    [Arguments]
    ...    ${expected_status}
    ...    ${purchase_inquiry_body}=${purchase_inquiry_body}

    ${inquiry_status}    Set Variable    ${purchase_inquiry_body['status']}
    Should Be Equal As Integers
    ...    first=${inquiry_status}
    ...    second=${expected_status}
    ...    msg=Expected The Purchase Inquiry To Return Status ${expected_status}, but got ${inquiry_status}

The Purchase Inquiry Fields Should Be Consistent
    [Arguments]
    ...    ${purchase_inquiry_body}=${purchase_inquiry_body}
    ...    ${purchase_cc}=${purchase_cc}
    ...    ${tracking_code}=${tracking_code}

    ${contain_pay_gateway}    Evaluate    'payGateway' in ${purchase_cc}
    IF    '${contain_pay_gateway}'=='True'
        ${payment_gateway_cc}    Set Variable    ${purchase_cc['payGateway']}
    ELSE
        ${ticket_type}    Set Variable    ${purchase_cc['ticketType']}
        IF    '${ticket_type}'=='BNPL'
            ${payment_gateway_cc}    Set Variable    BPG
        END
        IF    '${ticket_type}'=='CREDIT'
            ${payment_gateway_cc}    Set Variable    CPG
        END
        IF    '${ticket_type}'=='CREDIT_CARD'
            ${payment_gateway_cc}    Set Variable    CAPG
        END
        IF    '${ticket_type}'=='INSTALLMENT_SALE'
            ${payment_gateway_cc}    Set Variable    ISPG
        END
    END
    ${payment_gateway_cc}    Set Variable    ${LMS_PAYMENT_GATEWAY['${payment_gateway_cc}']}
    ${amount_cc}    Value Handler    ${purchase_cc['amount']}
    ${credit_amount_cc}    Value Handler    ${purchase_cc['creditAmount']}
    ${purchase_prepayment_detail}    Set Variable    ${purchase_cc['prepayment']}
    ${cash_amount_cc}    Value Handler    ${purchase_prepayment_detail['cashPayAmount']}
    ${filter_query}    Create Dictionary    purchaseTrackingCode=${tracking_code}
    ${result}    Mongo Db Find
    ...    credit_mng_db
    ...    prepayments
    ...    ${filter_query}
    @{records}    Get From Dictionary    ${result}    body
    ${prepayment_length}    Get Length    ${records}
    IF    '${prepayment_length}'!='0'
        ${prepayment_detail}    Set Variable    ${records}[0]
        ${prepayment_amount_cc}    Value Handler    ${prepayment_detail['prepaymentAmount']}
        ${fp_fee_charge_amount}    Value Handler    ${prepayment_detail['fpFeeCharge']}
        ${fee_charge_amount}    Value Handler    ${prepayment_detail['creditFeeCharge']}
        ${prepayment_amount_cc}    Evaluate    ${prepayment_amount_cc}+${fee_charge_amount}
    ELSE
        ${prepayment_amount_cc}    Set Variable    0
    END
    ${creation_date_cc}    Value Handler    ${purchase_cc['creationDate']}
    ${modification_date_cc}    Value Handler    ${purchase_cc['modificationDate']}

    ${payment_gateway_inquiry}    Set Variable    ${purchase_inquiry_body['paymentGateway']}
    ${amount_inquiry}    Set Variable    ${purchase_inquiry_body['amount']}
    ${credit_amount_inquiry}    Set Variable    ${purchase_inquiry_body['creditAmount']}
    ${cash_amount_inquiry}    Set Variable    ${purchase_inquiry_body['cashAmount']}
    ${prepayment_amount_inquiry}    Set Variable    ${purchase_inquiry_body['prepaymentAmount']}
    ${creation_date_inquiry}    Set Variable    ${purchase_inquiry_body['creationDate']}
    ${modification_date_inquiry}    Set Variable    ${purchase_inquiry_body['modificationDate']}

    Should Be Equal As Strings
    ...    first=${payment_gateway_cc}
    ...    second=${payment_gateway_inquiry}
    ...    msg=Expected The Payment Gateway to be ${payment_gateway_cc}, but got ${payment_gateway_inquiry}

    Should Be Equal As Strings
    ...    first=${amount_cc}
    ...    second=${amount_inquiry}
    ...    msg=Expected The Amount to be ${amount_cc}, but got ${amount_inquiry}

    Should Be Equal As Strings
    ...    first=${credit_amount_cc}
    ...    second=${credit_amount_inquiry}
    ...    msg=Expected The Credit Amount to be ${credit_amount_cc}, but got ${credit_amount_inquiry}

    Should Be Equal As Strings
    ...    first=${cash_amount_cc}
    ...    second=${cash_amount_inquiry}
    ...    msg=Expected The Cash Amount to be ${cash_amount_cc}, but got ${cash_amount_inquiry}

    Should Be Equal As Strings
    ...    first=${prepayment_amount_cc}
    ...    second=${prepayment_amount_inquiry}
    ...    msg=Expected The Total Prepayment Amount to be ${prepayment_amount_cc}, but got ${prepayment_amount_inquiry}

    Should Be Equal As Strings
    ...    first=${creation_date_cc}
    ...    second=${creation_date_inquiry}
    ...    msg=Expected The Creation Date to be ${creation_date_cc}, but got ${creation_date_inquiry}

    Should Be Equal As Strings
    ...    first=${modification_date_cc}
    ...    second=${modification_date_inquiry}
    ...    msg=Expected The Modification Date to be ${modification_date_cc}, but got ${modification_date_inquiry}
