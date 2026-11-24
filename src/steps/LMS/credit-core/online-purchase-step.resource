*** Settings ***
Resource    services/backend/import-allocation.resource
Resource    services/backend/LMS/credit-core/credit-online-purchase.resource
Resource    apis/lms/credit-core/post-admin-credit-accounts-block.resource
Resource    apis/lms/credit-core/post-credit-gateway-activate.resource
Resource    apis/lms/credit-core/post-credit-gateways-disable.resource
Resource    services/backend/LMS/credit-core/close-account.resource
Resource    services/backend/user-wallet-initializer-service.resource
Resource    apis/lms/credit-core/post-credit-accounts-schedule-close.resource
Resource    services/backend/ipg-mock-assigning.resource


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

Reproduce Amount And Credit Gateway Disable
    [Documentation]    Reproduces the businessId wallets. This is a ```Test Teardown```
    [Arguments]    ${additional_user_lists}=${ALLOCATION_USER_LIST}
    Credit Gateway Disable
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

Empty Balance
    [Arguments]    ${credit_id}=${credit_ids}[0]
    ${find_dic}    Create Dictionary    creditId=${credit_id}
    ${credit_account}    Mongo Db Find    credit-account-mng_db    accounts    ${find_dic}
    ${credit_account_initialBalance}    Set Variable    ${credit_account}[body][0][initialBalance]
    ${credit_account_initialBalance}    Value Handler    ${credit_account_initialBalance}
    ${amount}    Evaluate    ${credit_account_initialBalance}*2
    ${empty_balance_tracking_code}    Perform A Complete Offline Purchase    ${user_id}    ${credit_id}    ${amount}

    Purchase Status Must Be CONFIRMED Or DELIVERED    tracking_code=${empty_balance_tracking_code}
    Wait Until Keyword Succeeds
    ...    2 minute
    ...    10 s
    ...    Purchase Should Be Assigned To The Billing Cycle
    ...    tracking_code=${empty_balance_tracking_code}

    Set Test Variable    ${empty_balance_tracking_code}

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

Expire Account
    [Documentation]    Wrapper for the Expiration Service
    [Arguments]    ${credit_id}=${credit_ids}[0]

    Expiration Time Setter    credit_id=${credit_id}

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

Performed An Online Purchase
    [Documentation]    Performs a complete online purchase And returns the status of the purchase.
    [Arguments]
    ...    ${credit_id}=${credit_ids}[0]
    ...    ${user_id}=${user_id}
    ...    ${cell_number}=${cell_number}
    ...    ${business_id}=${LMS_AUTOMATION_BUSINESS_ID}
    ...    ${default_channel}=${default_channel}
    ...    ${amount}=${amount}
    ...    ${has_cash_pay}=${False}

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

    ${result}    Run Keyword And Ignore Error    Perform A Complete Online Credit Purchase
    ...    type=${type}
    ...    cell_number=${cell_number}
    ...    user_id=${user_id}
    ...    credit_id=${credit_id}
    ...    amount=${amount}
    ...    business_id=${business_id}
    ...    channel=${default_channel}
    ...    has_cash_pay=${has_cash_pay}

    ${ticket}    Set Variable    ${EMPTY}
    ${tracking_code}    Set Variable    ${EMPTY}

    ${purchase_status}    Set Variable    ${result}[0]

    IF    '${purchase_status}' == 'PASS'
        ${output}    Set Variable    ${result}[1]
        ${ticket}    Set Variable    ${output}[0]
        ${tracking_code}    Set Variable    ${output}[1]
    END

    Set Test Variable    ${ticket}
    Set Test Variable    ${tracking_code}
    Set Test Variable    ${purchase_status}
    Set Test Variable    ${type}

Performed An Initiated Online Purchase
    [Documentation]    Performs an initiated online purchase And returns the status of the purchase.
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

    ${result}    Run Keyword And Ignore Error    Perform A Complete Online Credit Purchase
    ...    type=${type}
    ...    cell_number=${cell_number}
    ...    user_id=${user_id}
    ...    credit_id=${credit_id}
    ...    amount=${amount}
    ...    business_id=${business_id}
    ...    channel=${default_channel}
    ...    skip=${skip_steps}

    ${ticket}    Set Variable    ${EMPTY}
    ${tracking_code}    Set Variable    ${EMPTY}

    ${purchase_status}    Set Variable    ${result}[0]

    IF    '${purchase_status}' == 'PASS'
        ${output}    Set Variable    ${result}[1]
        ${ticket}    Set Variable    ${output}[0]
        ${tracking_code}    Set Variable    ${output}[1]
    END

    Set Test Variable    ${ticket}
    Set Test Variable    ${tracking_code}
    Set Test Variable    ${purchase_status}
    Set Test Variable    ${type}

Performed A Prepared Online Purchase
    [Documentation]    Performs a prepared online purchase And returns the status of the purchase.
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

    ${result}    Run Keyword And Ignore Error    Perform A Complete Online Credit Purchase
    ...    type=${type}
    ...    cell_number=${cell_number}
    ...    user_id=${user_id}
    ...    credit_id=${credit_id}
    ...    amount=${amount}
    ...    business_id=${business_id}
    ...    channel=${default_channel}
    ...    skip=${skip_steps}

    ${ticket}    Set Variable    ${EMPTY}
    ${tracking_code}    Set Variable    ${EMPTY}

    ${purchase_status}    Set Variable    ${result}[0]

    IF    '${purchase_status}' == 'PASS'
        ${output}    Set Variable    ${result}[1]
        ${ticket}    Set Variable    ${output}[0]
        ${tracking_code}    Set Variable    ${output}[1]
    END

    Set Test Variable    ${ticket}
    Set Test Variable    ${tracking_code}
    Set Test Variable    ${purchase_status}
    Set Test Variable    ${type}

Performed A Routed Online Purchase
    [Documentation]    Performs a Routed online purchase And returns the status of the purchase.
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

    ${result}    Run Keyword And Ignore Error    Perform A Complete Online Credit Purchase
    ...    type=${type}
    ...    cell_number=${cell_number}
    ...    user_id=${user_id}
    ...    credit_id=${credit_id}
    ...    amount=${amount}
    ...    business_id=${business_id}
    ...    channel=${default_channel}
    ...    skip=${skip_steps}

    ${ticket}    Set Variable    ${EMPTY}
    ${tracking_code}    Set Variable    ${EMPTY}

    ${purchase_status}    Set Variable    ${result}[0]

    IF    '${purchase_status}' == 'PASS'
        ${output}    Set Variable    ${result}[1]
        ${ticket}    Set Variable    ${output}[0]
        ${tracking_code}    Set Variable    ${output}[1]
    END

    Set Test Variable    ${ticket}
    Set Test Variable    ${tracking_code}
    Set Test Variable    ${purchase_status}
    Set Test Variable    ${type}

Performed A Paid Online Purchase
    [Documentation]    Performs a paid online purchase And returns the status of the purchase.
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
    # credit_pay
    ${result}    Run Keyword And Ignore Error    Perform A Complete Online Credit Purchase
    ...    type=${type}
    ...    cell_number=${cell_number}
    ...    user_id=${user_id}
    ...    credit_id=${credit_id}
    ...    amount=${amount}
    ...    business_id=${business_id}
    ...    channel=${default_channel}
    ...    skip=${skip_steps}

    ${ticket}    Set Variable    ${EMPTY}
    ${tracking_code}    Set Variable    ${EMPTY}

    ${purchase_status}    Set Variable    ${result}[0]

    IF    '${purchase_status}' == 'PASS'
        ${output}    Set Variable    ${result}[1]
        ${ticket}    Set Variable    ${output}[0]
        ${tracking_code}    Set Variable    ${output}[1]
    END

    Set Test Variable    ${ticket}
    Set Test Variable    ${tracking_code}
    Set Test Variable    ${purchase_status}
    Set Test Variable    ${type}

Performed A Verified Online Purchase
    [Documentation]    Performs a verified online purchase And returns the status of the purchase.
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

    ${result}    Run Keyword And Ignore Error    Perform A Complete Online Credit Purchase
    ...    type=${type}
    ...    cell_number=${cell_number}
    ...    user_id=${user_id}
    ...    credit_id=${credit_id}
    ...    amount=${amount}
    ...    business_id=${business_id}
    ...    channel=${default_channel}
    ...    skip=${skip_steps}

    ${ticket}    Set Variable    ${EMPTY}
    ${tracking_code}    Set Variable    ${EMPTY}

    ${purchase_status}    Set Variable    ${result}[0]

    IF    '${purchase_status}' == 'PASS'
        ${output}    Set Variable    ${result}[1]
        ${ticket}    Set Variable    ${output}[0]
        ${tracking_code}    Set Variable    ${output}[1]
    END

    Set Test Variable    ${ticket}
    Set Test Variable    ${tracking_code}
    Set Test Variable    ${purchase_status}
    Set Test Variable    ${type}

Prepare The Credit Purchase
    [Documentation]    An intermediatory keyword that simply calls the API and retrieve the relevant information from the API
    [Arguments]
    ...    ${user_id}=${user_id}
    ...    ${credit_id}=${credit_ids}[0]
    ...    ${ticket}=${ticket}
    ...    ${amount}=${amount}
    ...    ${credit_amount}=${amount}
    ...    ${api_call_side}=${MICROSERVICE_SIDE}
    ...    ${fp_business_id}=${FUND_PROVIDER_BUSINESS_ID.PLATFORM}

    ${response}    GET Credit Purchases Prepare
    ...    api_call_side=${api_call_side}
    ...    user_id=${user_id}
    ...    fp_business_id=${fp_business_id}
    ...    credit_id=${credit_id}
    ...    ticket=${ticket}
    ...    amount=${amount}
    ...    credit_amount=${credit_amount}

    ${prepare_status_code}    Set Variable    ${response['status_code']}

    Set Test Variable    ${prepare_status_code}

Route Info The Credit Purchase
    [Documentation]    An intermediatory keyword that simply calls the API and retrieve the relevant information from the API
    [Arguments]
    ...    ${ticket}=${ticket}
    ...    ${api_call_side}=${MICROSERVICE_SIDE}

    ${response}    GET Credit Purchases Route Info
    ...    ${MICROSERVICE_SIDE}
    ...    ${ticket}

    ${route_info_status_code}    Set Variable    ${response['status_code']}

    Set Test Variable    ${route_info_status_code}

Pay The Credit Purchase
    [Documentation]    An intermediatory keyword that simply calls the API and retrieve the relevant information from the API
    [Arguments]
    ...    ${ticket}=${ticket}
    ...    ${api_call_side}=${MICROSERVICE_SIDE}

    ${result}    Run Keyword And Ignore Error    GET Credit Purchases Pay
    ...    api_call_side=${api_call_side}
    ...    ticket=${ticket}

    ${pay_api_status}    Set Variable    ${result}[0]

    IF    '${pay_api_status}' == 'PASS'
        ${output}    Set Variable    ${result}[1]
        ${credit_pay_status_code}    Set Variable    ${output['status_code']}
        ${credit_pay_response}    Set Variable    ${output['body']}
    ELSE
        ${credit_pay_status_code}    Set Variable    405
        ${credit_pay_response}    Set Variable    ${EMPTY}
    END

    Set Test Variable    ${credit_pay_status_code}
    Set Test Variable    ${credit_pay_response}

Verify The Credit Purchase
    [Documentation]    An intermediatory keyword that simply calls the API and retrieve the relevant information from the API
    [Arguments]
    ...    ${type}=${type}
    ...    ${tracking_code}=${tracking_code}
    ...    ${api_call_side}=${MICROSERVICE_SIDE}
    ...    ${user_id}=${LMS_AUTOMATION_BUSINESS_ID}

    ${response}    POST Credit Purchases Verify
    ...    api_call_side=${api_call_side}
    ...    tracking_code=${tracking_code}
    ...    type=${type}
    ...    user_id=${user_id}

    ${verify_status_code}    Set Variable    ${response['status_code']}

    Set Test Variable    ${verify_status_code}

Deliver The Credit Purchase
    [Documentation]    An intermediatory keyword that simply calls the API and retrieve the relevant information from the API
    [Arguments]
    ...    ${tracking_code}=${tracking_code}
    ...    ${type}=${type}
    ...    ${api_call_side}=${MICROSERVICE_SIDE}
    ...    ${delivery_date}=${EMPTY}
    ...    ${invoice_number}=${EMPTY}
    ...    ${products}=${EMPTY}
    ...    ${user_id}=${LMS_AUTOMATION_BUSINESS_ID}

    IF    '${delivery_date}'=='${EMPTY}'
        ${delivery_date}    Get Time    epoch    now
    END
    IF    '${invoice_number}'=='${EMPTY}'
        ${invoice_number}    Generate Random String    7    1234567890
    END
    IF    '${products}'=='${EMPTY}'
        ${products}    Create List    product-1
    END

    ${response}    POST Credit Purchases Deliver
    ...    api_call_side=${api_call_side}
    ...    delivery_date=${delivery_date}
    ...    invoice_number=${invoice_number}
    ...    tracking_code=${tracking_code}
    ...    type=${type}
    ...    products=${products}
    ...    user_id=${user_id}

    ${delivery_status_code}    Set Variable    ${response['status_code']}

    Set Test Variable    ${delivery_status_code}

############################################################################################################################################################################
# Assertions

The Purchase Should have Been Successful
    [Documentation]    If the status of the service is `PASS`, then it is a Pass; Otherwise it is not.
    [Arguments]    ${purchase_status}=${purchase_status}

    IF    '${purchase_status}'!='PASS'
        Fail    msg=Expected The Status Code To Be PASS, but got ${purchase_status}.
    END

The Purchase Should Not have Been Successful
    [Documentation]    If the status of the service is `FAIL`, then it is a Pass; Otherwise it is not.
    [Arguments]    ${purchase_status}=${purchase_status}

    IF    '${purchase_status}'!='FAIL'
        Fail    msg=Expected The Status Code To Be FAIL, but got ${purchase_status}.
    END

Check Activities Report
    [Documentation]    An intermediatory step that checks the activities within the report_mng. Used for retry purposes.
    [Arguments]    ${tracking_code}=${tracking_code}
    ${filter_query}    Create Dictionary    trackingCode=${tracking_code}
    ${result}    Mongo Db Find
    ...    report_mng_db
    ...    activities
    ...    ${filter_query}

    ${body}    Set Variable    ${result['body']}
    ${length}    Get Length    ${body}

    IF    '${length}'=='0'
        Fail    msg=Expected to have a record of this purchase in the activities/report_mng_db; But got None.
    END

Record Must Exist In Report
    [Documentation]    At least one record must be found with the provided ${tracking_code}
    [Arguments]    ${tracking_code}=${tracking_code}

    Wait Until Keyword Succeeds
    ...    1 minute
    ...    1 s
    ...    Check Activities Report
    ...    tracking_code=${tracking_code}

Should Not Have Been Able To Prepare
    [Documentation]    Simply checks the ${prepare_status_code} and Fails if it is `200`.
    [Arguments]    ${prepare_status_code}=${prepare_status_code}

    IF    '${prepare_status_code}'=='200'
        Fail    msg=Expected The Prepare To Fail, but got ${prepare_status_code}!
    END

Should Have Been Able To Prepare
    [Documentation]    Simply checks the ${prepare_status_code} and Fails if it is not `200`.
    [Arguments]    ${prepare_status_code}=${prepare_status_code}

    IF    '${prepare_status_code}'!='200'
        Fail    msg=Expected The Prepare To Succeed, but got ${prepare_status_code}!
    END

Should Not Have Been Able To Route Info
    [Documentation]    Simply checks the ${route_info_status_code} and Fails if it is `200`.
    [Arguments]    ${route_info_status_code}=${route_info_status_code}

    IF    '${route_info_status_code}'=='200'
        Fail    msg=Expected The Route Info To Fail, but got ${route_info_status_code}!
    END

Should Have Been Able To Route Info
    [Documentation]    Simply checks the ${route_info_status_code} and Fails if it is not `200`.
    [Arguments]    ${route_info_status_code}=${route_info_status_code}

    IF    '${route_info_status_code}'!='200'
        Fail    msg=Expected The Route Info To Succeed, but got ${route_info_status_code}!
    END

Should Not Have Been Able To Pay
    [Documentation]    Simply checks the ${credit_pay_status_code} and Fails if it is `200`.
    ...    Additionally checks the response result ${credit_pay_response}.
    [Arguments]    ${credit_pay_status_code}=${credit_pay_status_code}    ${credit_pay_response}=${credit_pay_response}
    IF    '${credit_pay_status_code}'=='200'
        ${data_pay}    Set Variable    ${credit_pay_response['data']}
        ${data_pay}    Convert String To Json    ${data_pay}
        ${result_pay}    Set Variable    ${data_pay['result']}
        IF    '${result_pay}'!='FAILURE'
            Fail    msg=Expected The Credit Pay To Fail, but got ${credit_pay_status_code} and ${result_pay}!
        END
    END

Should Have Been Able To Pay
    [Documentation]    Simply checks the ${credit_pay_status_code} and Fails if it is not `200`.
    ...    Additionally checks the response result ${credit_pay_response}.
    [Arguments]    ${credit_pay_status_code}=${credit_pay_status_code}    ${credit_pay_response}=${credit_pay_response}

    IF    '${credit_pay_status_code}'!='200'
        Fail    msg=Expected The Credit Pay To Succeed, but got ${credit_pay_status_code}!
    END
    ${data_pay}    Set Variable    ${credit_pay_response['data']}
    ${data_pay}    Convert String To Json    ${data_pay}
    ${result_pay}    Set Variable    ${data_pay['result']}
    IF    '${result_pay}'=='FAILURE'
        Fail    msg=Expected pay result to not be FAILURE, but got ${result_pay}!
    END

Should Not Have Been Able To Verify
    [Documentation]    Simply checks the ${verify_status_code} and Fails if it is `200`.
    [Arguments]    ${verify_status_code}=${verify_status_code}

    IF    '${verify_status_code}'=='200'
        Fail    msg=Expected The Verification To Fail, but got ${verify_status_code}!
    END

Should Have Been Able To Verify
    [Documentation]    Simply checks the ${verify_status_code} and Fails if it is not `200`.
    [Arguments]    ${verify_status_code}=${verify_status_code}

    IF    '${verify_status_code}'!='200'
        Fail    msg=Expected The Verification To Succeed, but got ${verify_status_code}!
    END

Should Not Have Been Able To Deliver
    [Documentation]    Simply checks the ${delivery_status_code} and Fails if it is `200`.
    [Arguments]    ${delivery_status_code}=${delivery_status_code}

    IF    '${delivery_status_code}'=='200'
        Fail    msg=Expected The Delivery To Fail, but got ${delivery_status_code}!
    END

Should Have Been Able To Deliver
    [Documentation]    Simply checks the ${delivery_status_code} and Fails if it is not `200`.
    [Arguments]    ${delivery_status_code}=${delivery_status_code}

    IF    '${delivery_status_code}'!='200'
        Fail    msg=Expected The Delivery To Succeed, but got ${delivery_status_code}!
    END

Assert Purchase Data In Credit Management, Credit Merchant Management And Report Management Is Correct
    [Arguments]    ${purchase_tracking_code}=${tracking_code}
    Wait Until Keyword Succeeds    30 seconds    5 s
    ...    Check Purchase Data Consistency    ${purchase_tracking_code}

Check Purchase Data Consistency
    [Documentation]    Validates that purchase data is consistent across credit_mng_db.purchases, credit_mng_db.prepayments, credit_merchant_mng_db.settlement, and report_mng_db collections
    [Arguments]    ${purchase_tracking_code}=${tracking_code}

    # Get purchase data
    ${filter_query}    Create Dictionary    trackingCode=${purchase_tracking_code}
    ${purchase_result}    Mongo Db Find    credit_mng_db    purchases    ${filter_query}
    ${purchase_data}    Set Variable    ${purchase_result['body'][0]}

    # Set Online Or Offline strategy
    ${purchase_is_online}    Set Variable    False
    ${purchase_is_offline}    Set Variable    False
    ${payment_channel}    Set Variable    ${purchase_data['paymentChannel']}
    ${online_channels}    Create List    1    3    8
    ${offline_channels}    Create List    2    5    6
    ${purchase_is_online}    Evaluate    '${payment_channel}' in ${online_channels}
    ${purchase_is_offline}    Evaluate    '${payment_channel}' in ${offline_channels}

    # Get prepayment data if any
    ${filter_query}    Create Dictionary    purchaseTrackingCode=${purchase_tracking_code}
    ${prepayment_result}    Mongo Db Find
    ...    credit_mng_db
    ...    prepayments
    ...    ${filter_query}
    ${length}    Get Length    ${prepayment_result['body']}
    ${has_prepayment}    Set Variable    False
    IF    ${length}>0
        ${prepayment_data}    Set Variable    ${prepayment_result['body'][0]}
        ${has_prepayment}    Set Variable    True
    END

    # Get settlement data
    ${filter_query}    Create Dictionary    purchaseTrackingCode=${purchase_tracking_code}
    ${settlement_result}    Mongo Db Find
    ...    credit_merchant_mng_db
    ...    settlement
    ...    ${filter_query}
    ${settlement_data}    Set Variable    ${settlement_result['body'][0]}

    # Get report_mng_db data for the purchase
    ${filter_query}    Create Dictionary    trackingCode=${purchase_data['trackingCode']}
    ${purchase_activity_result}    Mongo Db Find
    ...    report_mng_db
    ...    activities
    ...    ${filter_query}
    ${purchase_activity_data}    Set Variable    ${purchase_activity_result['body'][0]}

    ${filter_query}    Create Dictionary    trackingCode=${purchase_data['trackingCode']}
    ${purchase_dashboard_result}    Mongo Db Find
    ...    report_mng_db
    ...    dashboard_transactions
    ...    ${filter_query}
    ${purchase_dashboard_data}    Set Variable    ${purchase_dashboard_result['body'][0]}

    ${filter_query}    Create Dictionary    trackingCode=${purchase_data['trackingCode']}
    ${purchase_user_result}    Mongo Db Find
    ...    report_mng_db
    ...    user_transactions
    ...    ${filter_query}
    ${purchase_user_data}    Set Variable    ${purchase_user_result['body'][0]}

    # Get report_mng_db data for the prepayment if any
    IF    '${has_prepayment}'=='True'
        ${filter_query}    Create Dictionary    trackingCode=${prepayment_data['trackingCode']}
        ${prepayment_activity_result}    Mongo Db Find
        ...    report_mng_db
        ...    activities
        ...    ${filter_query}
        ${prepayment_activity_data}    Set Variable    ${prepayment_activity_result['body'][0]}

        ${filter_query}    Create Dictionary    trackingCode=${prepayment_data['trackingCode']}
        ${prepayment_dashboard_result}    Mongo Db Find
        ...    report_mng_db
        ...    dashboard_transactions
        ...    ${filter_query}
        ${prepayment_dashboard_data}    Set Variable    ${prepayment_dashboard_result['body'][0]}

        ${filter_query}    Create Dictionary    trackingCode=${prepayment_data['trackingCode']}
        ${prepayment_user_result}    Mongo Db Find
        ...    report_mng_db
        ...    user_transactions
        ...    ${filter_query}
        ${prepayment_user_data}    Set Variable    ${prepayment_user_result['body'][0]}
    END

    # Compare common fields between purchase and prepayments if the prepayment exits

    IF    '${has_prepayment}'=='True'
        Should Be Equal As Strings
        ...    ${purchase_data['business']['userId']}
        ...    ${prepayment_data['business']['userId']}
        ...    msg=Business userId mismatch between purchase and prepayments
        Should Be Equal As Strings
        ...    ${purchase_data['debtor']['userId']}
        ...    ${prepayment_data['debtor']['userId']}
        ...    msg=User ID mismatch between purchase debtor and prepayment debtor
        Should Be Equal As Strings
        ...    ${purchase_data['debtor']['cellNumber']}
        ...    ${prepayment_data['debtor']['cellNumber']}
        ...    msg=Cell number mismatch between purchase debtor and prepayment debtor
        Should Be Equal As Strings
        ...    ${purchase_data['debtor']['cellNumber']}
        ...    ${prepayment_data['debtor']['cellNumber']}
        ...    msg=Cell number mismatch between purchase debtor and prepayment debtor
        Should Be Equal As Strings
        ...    ${purchase_data['paymentChannel']}
        ...    ${prepayment_data['paymentChannel']}
        ...    msg=Payment Channel mismatch between purchase and prepayment
        Should Be Equal As Strings
        ...    ${purchase_data['initiator']}
        ...    ${prepayment_data['initiator']}
        ...    msg=Initiator mismatch between purchase and prepayment
        Should Be Equal As Strings
        ...    ${purchase_data['providerId']}
        ...    ${prepayment_data['providerId']}
        ...    msg=Provider Id mismatch between purchase and prepayment
    END

    # Compare common fields between purchase and settlement
    Should Be Equal As Strings
    ...    ${purchase_data['business']['userId']}
    ...    ${settlement_data['merchantId']}
    ...    msg=Business ID mismatch between purchase and settlement
    Should Be Equal As Strings
    ...    ${purchase_data['paymentChannel']}
    ...    ${settlement_data['paymentChannel']}
    ...    msg=Payment Channel mismatch between purchase and prepayment

    # Compare Purchases with itself and prepayment and settlement

    ## payment gateway
    ${ticket_to_gateway}    Create Dictionary    BNPL=BPG    CREDIT=CPG    INSTALLMENT_SALE=ISPG    CREDIT_CARD=CAPG
    ${ticket_type}    Set Variable    ${purchase_data['ticketType']}
    ${expected_gateway}    Set Variable    ${ticket_to_gateway['${ticket_type}']}
    Should Be Equal As Strings
    ...    ${purchase_data['payGateway']}
    ...    ${expected_gateway}
    ...    msg=Expected the payGateway to be ${expected_gateway} but got ${purchase_data['payGateway']}.

    ## Repayment Options
    ${filter_query}    Create Dictionary    creditId=${purchase_data['creditId']}
    ${credit_id_result}    Mongo Db Find
    ...    credit-account-mng_db
    ...    accounts
    ...    ${filter_query}
    ${credit_id_data}    Set Variable    ${credit_id_result['body'][0]}
    ${installment_count}    Value Handler    ${credit_id_data['installmentCount']}
    ${expected_repayment_option}    Set Variable    0
    IF    ${installment_count}>1
        ${expected_repayment_option}    Set Variable    1
    END

    ${expected_primary_method}    Set Variable    ${EMPTY}

    IF    '${purchase_data['payGateway']}'=='CPG'
        ${expected_primary_method}    Set Variable    2
    END

    IF    '${purchase_data['payGateway']}'=='ISPG'
        ${expected_primary_method}    Set Variable    3
    END

    IF    '${purchase_data['payGateway']}'=='CAPG'
        ${expected_primary_method}    Set Variable    4
    END

    IF    '${purchase_data['payGateway']}'=='BPG'
        IF    ${installment_count}>1
            ${expected_primary_method}    Set Variable    7
        ELSE
            ${expected_primary_method}    Set Variable    6
        END
    END

    ## Numeric Assertions

    ${amount}    Value Handler    ${purchase_data['amount']}
    ${credit_amount}    Value Handler    ${purchase_data['creditAmount']}
    ${filter_query}    Create Dictionary    profileId=${purchase_data['profileId']}
    ${profile_result}    Mongo Db Find
    ...    credit_mng_db
    ...    profiles
    ...    ${filter_query}
    ${profile_data}    Set Variable    ${profile_result['body'][0]}
    ${payment_term}    Set Variable    ${profile_data['paymentTerm']}
    ${has_down_payment}    Evaluate    'downPaymentPercentage' in ${payment_term}
    ${has_fee_charge}    Evaluate    'feeCharge' in ${payment_term}
    ${has_fp_fee_charge}    Evaluate    'fpFeeCharge' in ${payment_term}

    IF    '${has_down_payment}'=='True'
        ${down_payment_percentage}    Value Handler    ${payment_term['downPaymentPercentage']}
    ELSE
        ${down_payment_percentage}    Set Variable    0
    END
    IF    '${has_fee_charge}'=='True'
        ${fee_charge_percentage}    Value Handler    ${payment_term['feeCharge']}
    ELSE
        ${fee_charge_percentage}    Set Variable    0
    END
    IF    '${has_fp_fee_charge}'=='True'
        ${fp_fee_charge_percentage}    Value Handler    ${payment_term['fpFeeCharge']}
    ELSE
        ${fp_fee_charge_percentage}    Set Variable    0
    END

    IF    '${has_prepayment}'=='False'
        Should Be Equal As Strings
        ...    ${amount}
        ...    ${credit_amount}
        ...    msg=Expected creditAmount to have the same value as amount but ${credit_amount}!=${amount}.
    ELSE
        ${expected_prepayment_amount}    Evaluate    ${amount}-${credit_amount}
        ${cash_pay_amount}    Value Handler    ${purchase_data['prepayment']['cashPayAmount']}
        ${fee_charge}    Value Handler    ${purchase_data['prepayment']['feeCharge']}
        ${fp_fee_charge}    Value Handler    ${purchase_data['prepayment']['fpFeeCharge']}
        ${prepayment_amount}    Value Handler    ${purchase_data['prepayment']['prepaymentAmount']}
        ${round_off_amount}    Value Handler    ${purchase_data['prepayment']['roundOffAmount']}
        ${total_prepayment_amount}    Evaluate
        ...    ${cash_pay_amount}+${fee_charge}+${fp_fee_charge}+${prepayment_amount}+${round_off_amount}

        Should Be Equal As Strings
        ...    ${expected_prepayment_amount}
        ...    ${total_prepayment_amount}
        ...    msg=Expected prepayment amount to be ${expected_prepayment_amount} but got ${total_prepayment_amount}.

        ${expected_cash_pay_amount}    Evaluate    int(${down_payment_percentage}*${amount}/100)
        ${expected_fee_charge}    Evaluate    int(${fee_charge_percentage}*${credit_amount}/100)
        ${expected_fp_fee_charge}    Evaluate    int(${fp_fee_charge_percentage}*${credit_amount}/100)

        Should Be Equal As Strings
        ...    ${expected_cash_pay_amount}
        ...    ${cash_pay_amount}
        ...    msg=Expected prepayment cash pay amount / down payment to be ${expected_cash_pay_amount} but got ${cash_pay_amount}.

        Should Be Equal As Strings
        ...    ${expected_fee_charge}
        ...    ${fee_charge}
        ...    msg=Expected prepayment fee charge to be ${expected_fee_charge} but got ${fee_charge}.

        Should Be Equal As Strings
        ...    ${expected_fp_fee_charge}
        ...    ${fp_fee_charge}
        ...    msg=Expected prepayment FP fee charge to be ${expected_fp_fee_charge} but got ${fp_fee_charge}.

        # Check prepayment values as well

        ${prepayment_cash_pay_amount}    Value Handler    ${prepayment_data['cashPayAmount']}
        ${prepayment_fee_charge}    Value Handler    ${prepayment_data['feeCharge']}
        ${prepayment_fp_fee_charge}    Value Handler    ${prepayment_data['fpFeeCharge']}

        ${total_prepayment_amount}    Evaluate    ${cash_pay_amount}+${fee_charge}+${fp_fee_charge}

        ${prepayment_data_amount}    Value Handler    ${prepayment_data['amount']}
        Should Be Equal As Strings
        ...    ${prepayment_data_amount}
        ...    ${total_prepayment_amount}
        ...    msg=Expected prepayment amount to be ${total_prepayment_amount} but got ${prepayment_data_amount}.

        ${expected_cash_pay_amount}    Evaluate    int(${down_payment_percentage}*${amount}/100)
        ${expected_fee_charge}    Evaluate    int(${fee_charge_percentage}*${credit_amount}/100)
        ${expected_fp_fee_charge}    Evaluate    int(${fp_fee_charge_percentage}*${credit_amount}/100)

        Should Be Equal As Strings
        ...    ${expected_cash_pay_amount}
        ...    ${prepayment_cash_pay_amount}
        ...    msg=Expected prepayment cash pay amount / down payment to be ${expected_cash_pay_amount} but got ${cash_pay_amount}.

        Should Be Equal As Strings
        ...    ${expected_fee_charge}
        ...    ${prepayment_fee_charge}
        ...    msg=Expected prepayment fee charge to be ${expected_fee_charge} but got ${fee_charge}.

        Should Be Equal As Strings
        ...    ${expected_fp_fee_charge}
        ...    ${prepayment_fp_fee_charge}
        ...    msg=Expected prepayment FP fee charge to be ${expected_fp_fee_charge} but got ${fp_fee_charge}.
    END

    ## Specif Fields Consistency in prepayment and purchase

    IF    '${purchase_is_offline}'=='True'
        Should Be Equal As Strings
        ...    ${purchase_data['initiator']}
        ...    API
        ...    msg=Purchase Initiator is other than API
        IF    '${has_prepayment}'=='True'
            Should Be Equal As Strings
            ...    ${prepayment_data['initiator']}
            ...    API
            ...    msg=Prepayment Initiator is other than API
            Should Be Equal As Strings
            ...    ${prepayment_data['payGateway']}
            ...    CASH
            ...    msg=Prepayment Pay Gateway is other than CASH
        END
    ELSE
        Should Be Equal As Strings
        ...    ${purchase_data['initiator']}
        ...    WEB_CREDIT
        ...    msg=Purchase Initiator is other than WEB_CREDIT
        IF    '${has_prepayment}'=='True'
            Should Be Equal As Strings
            ...    ${prepayment_data['initiator']}
            ...    WEB_CREDIT
            ...    msg=Prepayment Initiator is other than WEB_CREDIT
            Should Be Equal As Strings
            ...    ${prepayment_data['payGateway']}
            ...    IPG
            ...    msg=Prepayment Pay Gateway is other than IPG
        END
    END

    # Validate purcahse fields

    Purchase Status Must Be CONFIRMED Or DELIVERED    tracking_code=${purchase_tracking_code}
    Wait Until Keyword Succeeds
    ...    2 minute
    ...    10 s
    ...    Purchase Should Be Assigned To The Billing Cycle
    ...    tracking_code=${purchase_tracking_code}

    # Validate Settlement Transactions
    ${transaction_list}    Set Variable    ${settlement_data['transactions']}
    ${length}    Get Length    ${transaction_list}
    IF    '${has_prepayment}'=='True'
        ${found_prepayment}    Set Variable    False
        ${found_primary}    Set Variable    False
        Should Be Equal As Integers    ${length}    2    msg=Expected 2 transactions but got ${length}
        FOR    ${i}    IN RANGE    ${0}    ${length}    ${1}
            ${transaction_i}    Set Variable    ${transaction_list}[${i}]
            ${method_i}    Value Handler    ${transaction_i['method']}
            ${amount_i}    Value Handler    ${transaction_i['amount']}
            IF    '${purchase_is_offline}'=='True'
                IF    '${method_i}'=='8'
                    Fail    msg=Expected The Method to be CASH (5) but got IPG (${method_i})
                END
                IF    '${method_i}'=='5'
                    Should Be Equal As Strings
                    ...    ${total_prepayment_amount}
                    ...    ${amount_i}
                    ...    msg=Expected The prepayment amount to be ${total_prepayment_amount} but got ${amount_i} on method ${method_i}
                    ${found_prepayment}    Set Variable    True
                END
            END
            IF    '${purchase_is_online}'=='True'
                IF    '${method_i}'=='5'
                    Fail    msg=Expected The Method to be IPG (8) but got CASH (${method_i})
                END
                IF    '${method_i}'=='8'
                    Should Be Equal As Strings
                    ...    ${total_prepayment_amount}
                    ...    ${amount_i}
                    ...    msg=Expected The prepayment amount to be ${total_prepayment_amount} but got ${amount_i} on method ${method_i}
                    ${found_prepayment}    Set Variable    True
                END
            END
            IF    '${method_i}'=='${expected_primary_method}'
                Should Be Equal As Strings
                ...    ${credit_amount}
                ...    ${amount_i}
                ...    msg=Expected The credit amount to be ${credit_amount} but got ${amount_i} on method ${method_i}
                ${found_primary}    Set Variable    True
            END
        END
        Should Be Equal As Strings
        ...    ${found_primary}
        ...    True
        ...    msg=Expected to find a ${expected_primary_method} in the ${transaction_list}, but failed!
        Should Be Equal As Strings
        ...    ${found_prepayment}
        ...    True
        ...    msg=Expected to find an appropriate prepayment method in the ${transaction_list}, but failed!
    ELSE
        ${found_primary}    Set Variable    False
        Should Be Equal As Integers    ${length}    1    msg=Expected 1 transactions but got ${length}
        ${transaction_i}    Set Variable    ${transaction_list}[0]
        ${method_i}    Value Handler    ${transaction_i['method']}
        ${amount_i}    Value Handler    ${transaction_i['amount']}
        IF    '${method_i}'=='${expected_primary_method}'
            Should Be Equal As Strings
            ...    ${credit_amount}
            ...    ${amount_i}
            ...    msg=Expected The credit amount to be ${credit_amount} but got ${amount_i} on method ${method_i}
            ${found_primary}    Set Variable    True
        END
        Should Be Equal As Strings
        ...    ${found_primary}
        ...    True
        ...    msg=Expected to find a ${expected_primary_method} in the ${transaction_list}, but failed!
    END

    # Validate activities data for the purchase and the prepayment
    Should Be Equal As Strings
    ...    ${purchase_activity_data['amount']}
    ...    ${purchase_data['amount']}
    ...    msg=Amount Mismatch in activities and purchases

    Should Be Equal As Strings
    ...    ${purchase_activity_data['paymentChannel']}
    ...    ${purchase_data['paymentChannel']}
    ...    msg=Payment Channel Mismatch in activities and purchases

    Should Be Equal As Strings
    ...    ${purchase_activity_data['destination']['owner']['username']}
    ...    ${purchase_data['business']['userId']}
    ...    msg=Destination user mismatch in activities for a purchase
    Should Be Equal As Strings
    ...    ${purchase_activity_data['initiator']['username']}
    ...    ${purchase_data['debtor']['userId']}
    ...    msg=Initiator user mismatch in activities for a purchase

    Should Be Equal As Strings
    ...    ${purchase_activity_data['status']}
    ...    0
    ...    msg=Expected status 0 for the confirmed/delivered purchase but got ${purchase_activity_data['status']}

    Should Be Equal As Strings
    ...    ${purchase_activity_data['type']}
    ...    5
    ...    msg=Expected Type 5 for the confirmed/delivered purchase but got ${purchase_activity_data['type']}

    IF    '${has_prepayment}'=='True'
        Should Be Equal As Strings
        ...    ${prepayment_activity_data['amount']}
        ...    ${prepayment_data['amount']}
        ...    msg=Amount Mismatch in activities and prepayment

        Should Be Equal As Strings
        ...    ${prepayment_activity_data['paymentChannel']}
        ...    ${prepayment_data['paymentChannel']}
        ...    msg=Payment Channel Mismatch in activities and prepayment

        Should Be Equal
        ...    ${prepayment_activity_data['metaData']['rrn']}
        ...    ${prepayment_data['payResponse']['rrn']}
        ...    msg=RRN mismatch in activities

        Should Be Equal As Strings
        ...    ${prepayment_activity_data['destination']['owner']['username']}
        ...    ${prepayment_data['business']['userId']}
        ...    msg=Destination user mismatch in activities for a prepayment

        Should Be Equal As Strings
        ...    ${prepayment_activity_data['initiator']['username']}
        ...    ${prepayment_data['debtor']['userId']}
        ...    msg=Initiator user mismatch in activities for a prepayment

        Should Be Equal As Strings
        ...    ${prepayment_activity_data['status']}
        ...    0
        ...    msg=Expected status 0 for the confirmed prepayment but got ${prepayment_data['status']}

        Should Be Equal As Strings
        ...    ${prepayment_activity_data['type']}
        ...    130
        ...    msg=Expected Type 5 for the confirmed prepayment but got ${purchase_activity_data['type']}
    END

    # Validate dashboard activities data for the purchase and the prepayment
    Should Be Equal As Strings
    ...    ${purchase_dashboard_data['amount']}
    ...    ${purchase_data['amount']}
    ...    msg=Amount Mismatch in dashboard activities and purchases

    Should Be Equal As Strings
    ...    ${purchase_dashboard_data['paymentChannel']}
    ...    ${purchase_data['paymentChannel']}
    ...    msg=Payment Channel Mismatch in dashboard activities and purchases

    Should Be Equal As Strings
    ...    ${purchase_dashboard_data['destination']['user']['userId']}
    ...    ${purchase_data['business']['userId']}
    ...    msg=Destination user mismatch in dashboard activities for a purchase
    Should Be Equal As Strings
    ...    ${purchase_dashboard_data['source']['user']['userId']}
    ...    ${purchase_data['debtor']['userId']}
    ...    msg=Source user mismatch in dashboard activities for a purchase

    Should Be Equal As Strings
    ...    ${purchase_dashboard_data['status']}
    ...    0
    ...    msg=Expected status 0 for the confirmed/delivered purchase but got ${purchase_dashboard_data['status']}

    Should Be Equal As Strings
    ...    ${purchase_dashboard_data['type']}
    ...    5
    ...    msg=Expected Type 5 for the confirmed/delivered purchase but got ${purchase_dashboard_data['type']}

    IF    '${has_prepayment}'=='True'
        Should Be Equal As Strings
        ...    ${prepayment_dashboard_data['amount']}
        ...    ${prepayment_data['amount']}
        ...    msg=Amount Mismatch in dashboard activities and prepayment

        Should Be Equal As Strings
        ...    ${prepayment_dashboard_data['paymentChannel']}
        ...    ${prepayment_data['paymentChannel']}
        ...    msg=Payment Channel Mismatch in dashboard activities and prepayment

        Should Be Equal
        ...    ${prepayment_dashboard_data['rrn']}
        ...    ${prepayment_data['payResponse']['rrn']}
        ...    msg=RRN mismatch in dashboard activities

        Should Be Equal As Strings
        ...    ${prepayment_dashboard_data['destination']['user']['userId']}
        ...    ${prepayment_data['business']['userId']}
        ...    msg=Destination user mismatch in dashboard activities for a prepayment

        Should Be Equal As Strings
        ...    ${prepayment_dashboard_data['source']['user']['userId']}
        ...    ${prepayment_data['debtor']['userId']}
        ...    msg=Initiator user mismatch in dashboard activities for a prepayment

        Should Be Equal As Strings
        ...    ${prepayment_dashboard_data['status']}
        ...    0
        ...    msg=Expected status 0 for the confirmed prepayment but got ${prepayment_dashboard_data['status']}

        Should Be Equal As Strings
        ...    ${prepayment_dashboard_data['type']}
        ...    130
        ...    msg=Expected Type 5 for the confirmed prepayment but got ${prepayment_dashboard_data['type']}
    END

    # Validate user transactions data for the purchase and the prepayment
    Should Be Equal As Strings
    ...    ${purchase_user_data['amount']}
    ...    ${purchase_data['amount']}
    ...    msg=Amount Mismatch in user transactions and purchases

    Should Be Equal As Strings
    ...    ${purchase_user_data['destination']['userId']}
    ...    ${purchase_data['business']['userId']}
    ...    msg=Destination user mismatch in user transactions for a purchase
    Should Be Equal As Strings
    ...    ${purchase_user_data['source']['userId']}
    ...    ${purchase_data['debtor']['userId']}
    ...    msg=Source user mismatch in user transactions for a purchase

    Should Be Equal As Strings
    ...    ${purchase_user_data['status']}
    ...    0
    ...    msg=Expected status 0 for the confirmed/delivered purchase but got ${purchase_user_data['status']}

    Should Be Equal As Strings
    ...    ${purchase_user_data['type']}
    ...    5
    ...    msg=Expected Type 5 for the confirmed/delivered purchase but got ${purchase_user_data['type']}

    Should Be Equal As Strings
    ...    ${purchase_user_data['gateway']}
    ...    ${purchase_dashboard_data['gateway']}
    ...    msg=Expected gateway for dashboard and user to be equal but got ${purchase_user_data['gateway']}!=${purchase_dashboard_data['gateway']}

    Should Be Equal As Strings
    ...    ${purchase_user_data['gateway']}
    ...    ${purchase_activity_data['gateway']}
    ...    msg=Expected gateway for user and activity to be equal but got ${purchase_user_data['gateway']}!=${purchase_activity_data['gateway']}

    IF    '${has_prepayment}'=='True'
        Should Be Equal As Strings
        ...    ${prepayment_user_data['amount']}
        ...    ${prepayment_data['amount']}
        ...    msg=Amount Mismatch in user transactions and prepayment

        Should Be Equal As Strings
        ...    ${prepayment_user_data['destination']['userId']}
        ...    ${prepayment_data['business']['userId']}
        ...    msg=Destination user mismatch in user transactions for a prepayment

        Should Be Equal As Strings
        ...    ${prepayment_user_data['source']['userId']}
        ...    ${prepayment_data['debtor']['userId']}
        ...    msg=Initiator user mismatch in user transactions for a prepayment

        Should Be Equal As Strings
        ...    ${prepayment_user_data['status']}
        ...    0
        ...    msg=Expected status 0 for the confirmed prepayment but got ${prepayment_user_data['status']}

        Should Be Equal As Strings
        ...    ${prepayment_user_data['type']}
        ...    130
        ...    msg=Expected Type 5 for the confirmed prepayment but got ${prepayment_user_data['type']}

        Should Be Equal As Strings
        ...    ${prepayment_user_data['gateway']}
        ...    ${prepayment_dashboard_data['gateway']}
        ...    msg=Expected gateway for dashboard and user to be equal but got ${prepayment_user_data['gateway']}!=${prepayment_dashboard_data['gateway']}

        Should Be Equal As Strings
        ...    ${prepayment_user_data['gateway']}
        ...    ${prepayment_activity_data['gateway']}
        ...    msg=Expected gateway for user and activity to be equal but got ${prepayment_user_data['gateway']}!=${prepayment_activity_data['gateway']}
    END

Call Schedule Close API
    [Documentation]    Checks if the response status code is 200
    [Arguments]    ${credit_id}=${credit_ids}[0]
    ${schedule_close_response}    Post Credit Accounts Schedule Close
    ...    ${MICROSERVICE_SIDE}
    ...    ${credit_ids}[0]
    ...    ${LMS_BLOCK_REASON.ORGANIZATION_REQUEST}
    ...    ${DASHBOARD_USERNAME}
    Set Test Variable    ${schedule_close_response}
