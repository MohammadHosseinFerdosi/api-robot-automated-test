*** Settings ***
Resource    services/backend/LMS/credit-core/pay-early-settlement.resource
Resource    services/backend/import-allocation.resource
Resource    services/backend/LMS/credit-core/credit-online-purchase.resource
Resource    apis/lms/credit-core/post-credit-gateway-activate.resource
Resource    apis/lms/credit-core/post-credit-gateways-disable.resource
Resource    services/backend/value-handler.resource


*** Keywords ***
############################################################################################################################################################################
# Merchant Initialization
Initialize Merchant
    [Documentation]    This is a ```Test Setup``` that generated a merchant that can be used to perform a purchases on and validate the API
    [Arguments]    ${BUSINESS_ID_FOR_CHARGE_TEST_WALLETS}=${BUSINESS_ID_FOR_CHARGE_TEST_WALLETS}

    ${spend_wallet_for_business_1}    Create Dictionary
    ...    definition=${B_WALLET_SPEND_DEFINITION}
    ...    wallet_charge_amount=1
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
    ...    amounts=${{['10000']}}
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
    ...    amounts=${{['10000']}}
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
    ...    amounts=${{['10000']}}
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
# Purchases

Empty Balance
    [Arguments]    ${credit_id}=${credit_ids}[0]
    ${find_dic}    Create Dictionary    creditId=${credit_id}
    ${credit_account}    Mongo Db Find    credit-account-mng_db    accounts    ${find_dic}
    ${credit_account_initial_balance}    Set Variable    ${credit_account}[body][0][initialBalance]
    ${credit_account_initial_balance}    Value Handler    ${credit_account_initial_balance}

    ${amount}    Evaluate    ${credit_account_initial_balance}*2

    ${empty_balance_tracking_code}    Perform A Complete Offline Purchase    ${user_id}    ${credit_id}    ${amount}

    Purchase Status Must Be CONFIRMED Or DELIVERED    tracking_code=${empty_balance_tracking_code}
    Wait Until Keyword Succeeds
    ...    2 minute
    ...    10 s
    ...    Purchase Should Be Assigned To The Billing Cycle
    ...    tracking_code=${empty_balance_tracking_code}

    Set Test Variable    ${empty_balance_tracking_code}

Perform An Offline Purchase
    [Documentation]    Performs a complete offline purchase
    [Arguments]
    ...    ${credit_id}=${credit_ids}[0]
    ...    ${user_id}=${user_id}
    ...    ${cell_number}=${cell_number}
    ...    ${business_id}=${LMS_AUTOMATION_BUSINESS_ID}
    ...    ${default_channel}=${default_channel}
    ...    ${amount}=${amount}

    ${tracking_code}    Perform A Complete Offline Purchase
    ...    user_id=${user_id}
    ...    credit_id=${credit_id}
    ...    amount=${amount}
    ...    business_id=${business_id}
    ...    channel=${default_channel}

    Purchase Status Must Be CONFIRMED Or DELIVERED    tracking_code=${tracking_code}
    Wait Until Keyword Succeeds
    ...    2 minute
    ...    10 s
    ...    Purchase Should Be Assigned To The Billing Cycle
    ...    tracking_code=${tracking_code}

    Set Test Variable    ${tracking_code}

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

############################################################################################################################################################################
# Early Settlements

Early Settlement Status Must Be Confirmed
    [Arguments]    ${early_settlement_ticket}=${early_settlement_ticket}
    ${filter_query}    Create Dictionary    ticket=${early_settlement_ticket}
    ${result}    Mongo Db Find
    ...    credit_mng_db
    ...    early_settlements
    ...    ${filter_query}
    @{records}    Get From Dictionary    ${result}    body
    ${result_object}    Set Variable    ${records}[0]
    Should Be Equal    ${result_object['status']}    CONFIRMED
    ${early_settlement_tracking_code}    Set Variable    ${result_object['trackingCode']}
    RETURN    ${early_settlement_tracking_code}

Fully Pay The Early Settlement
    [Arguments]
    ...    ${credit_id}=${credit_ids}[0]
    ...    ${user_id}=${user_id}
    ...    ${cell_number}=${cell_number}

    ${early_settlement_ticket}    Pay Early Settlement Via Wallet
    ...    user_id=${user_id}
    ...    credit_id=${credit_id}
    ...    cell_number=${cell_number}

    Set Test Variable    ${early_settlement_ticket}

    ${early_settlement_tracking_code}    Wait Until Keyword Succeeds
    ...    1 minute
    ...    5 s
    ...    Early Settlement Status Must Be Confirmed

    Set Test Variable    ${early_settlement_tracking_code}

Return Users Credit Wallet Balance
    [Documentation]    Checks the users credit wallet and returns its balance
    [Arguments]    ${credit_id}=${credit_ids}[0]

    ${wallet_name}    Set Variable    credit_${credit_id}
    ${filter_query}    Create Dictionary    walletName=${wallet_name}
    ${result}    Mongo Db Find    wallet_provider_db    wallets    ${filter_query}
    ${body}    Set Variable    ${result['body']}[0]
    ${wallet_id}    Set Variable    ${body['walletId']}

    ${query}    Set Variable    SELECT * FROM accounts WHERE wallet_id = "${wallet_id}"
    ${result}    MySQL Fetch All    db_name=wallet_provider_db    query=${query}

    ${body}    Set Variable    ${result['body']}
    ${number_of_wallets}    Get Length    ${body}
    ${total_balance}    Set Variable    0
    FOR    ${i}    IN RANGE    ${0}    ${number_of_wallets}    ${1}
        ${wallet_i}    Set Variable    ${body}[${i}]
        ${wallet_i_balance}    Set Variable    ${wallet_i['balance']}
        ${total_balance}    Evaluate    ${total_balance}+${wallet_i_balance}
    END

    ${total_balance}    Evaluate    round(${total_balance})

    RETURN    ${total_balance}

Early Settlement Amount Must Have Been Revolved
    [Arguments]    ${credit_id}=${credit_ids}[0]    ${offset}=0

    ${find_dic}    Create Dictionary    creditId=${credit_id}
    ${credit_account}    Mongo Db Find    credit-account-mng_db    accounts    ${find_dic}
    ${credit_account_initial_balance}    Set Variable    ${credit_account}[body][0][initialBalance]
    ${credit_account_initial_balance}    Value Handler    input_value=${credit_account_initial_balance}

    ${credit_account_initial_balance}    Evaluate    ${credit_account_initial_balance}-${offset}

    ${total_balance}    Return Users Credit Wallet Balance
    IF    ${total_balance}!=${credit_account_initial_balance}
        Fail
        ...    msg=Expected the total balance ${total_balance} to be the same as ${credit_account_initial_balance} with ${offset}; But it was not. Revolving Failed!
    END
