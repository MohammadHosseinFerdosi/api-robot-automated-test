*** Settings ***
Library     Collections
Library     RequestsLibrary
Resource    apis/lms/credit-core/post-credit-gateway-manifest.resource
Resource    apis/lms/credit-core/post-credit-gateway-activate.resource
Resource    apis/lms/credit-core/post-credit-gateways-disable.resource
Resource    services/backend/import-allocation.resource
Resource    apis/lms/credit-core/post-admin-credit-accounts-block.resource
Resource    services/backend/user-wallet-initializer-service.resource
Resource    services/backend/value-handler.resource
Resource    services/backend/LMS/credit-core/close-account.resource
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

The User Has 1pay And 4pay Accounts
    Set Test Variable    ${DEFAULT_ALLOCATION_AMOUNT_4PAY}    40000
    Credit Allocation
    ...    types=${{['${LMS_Account_Type_1PAY}','${LMS_Account_Type_XPAY}']}}
    ...    amounts=${{['${DEFAULT_ALLOCATION_AMOUNT}','${DEFAULT_ALLOCATION_AMOUNT_4PAY}']}}

The User Has Credit Account
    Credit Allocation    types=${{['${LMS_Account_Type_CREDIT}']}}    amounts=${{['${DEFAULT_ALLOCATION_AMOUNT}']}}

The User Has Installment Sale Account
    Credit Allocation
    ...    types=${{['${LMS_Account_Type_INSTALLMENT_SALE}']}}
    ...    amounts=${{['${DEFAULT_ALLOCATION_AMOUNT}']}}

The User Has 1pay Account
    Credit Allocation    types=${{['${LMS_Account_Type_1PAY}']}}    amounts=${{['${DEFAULT_ALLOCATION_AMOUNT}']}}

The User Has 4pay Account
    Set Test Variable    ${DEFAULT_ALLOCATION_AMOUNT_4PAY}    40000
    Credit Allocation    types=${{['${LMS_Account_Type_XPAY}']}}    amounts=${{['${DEFAULT_ALLOCATION_AMOUNT_4PAY}']}}

The User Has 4pay And Credit Accounts
    Set Test Variable    ${DEFAULT_ALLOCATION_AMOUNT_4PAY}    40000
    Credit Allocation
    ...    types=${{['${LMS_Account_Type_XPAY}','${LMS_Account_Type_CREDIT}']}}
    ...    amounts=${{['${DEFAULT_ALLOCATION_AMOUNT}','${DEFAULT_ALLOCATION_AMOUNT_4PAY}']}}

The User Has 1pay, 4pay, And Credit Accounts
    Set Test Variable    ${DEFAULT_ALLOCATION_AMOUNT_4PAY}    40000
    Credit Allocation
    ...    types=${{['${LMS_Account_Type_1PAY}','${LMS_Account_Type_XPAY}','${LMS_Account_Type_CREDIT}']}}
    ...    amounts=${{['${DEFAULT_ALLOCATION_AMOUNT}','${DEFAULT_ALLOCATION_AMOUNT_4PAY}','${DEFAULT_ALLOCATION_AMOUNT}']}}

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

The Ticket Type Is Set To BNPL
    Set Test Variable    ${TICKET_TYPE}    ${CREDIT_TICKET_TYPE_V1.BNPL}

The Ticket Type Is Set To Credit
    Set Test Variable    ${TICKET_TYPE}    ${CREDIT_TICKET_TYPE_V1.CREDIT}

The Ticket Type Is Set To Installment Sale
    Set Test Variable    ${TICKET_TYPE}    ${CREDIT_TICKET_TYPE_V1.INSTALLMENT_SALE}

Expire Account
    [Documentation]    Wrapper for the Expiration Service
    [Arguments]    ${credit_id}=${credit_ids}[0]

    Expiration Time Setter    credit_id=${credit_id}

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

Blocker
    [Arguments]    ${credit_id}=${credit_ids}[0]
    ${response}    Post Admin Credit Accounts Block
    ...    ${MICROSERVICE_SIDE}
    ...    ${credit_id}
    ...    ${LMS_BLOCK_REASON.ORGANIZATION_REQUEST}
    ...    ${DASHBOARD_USERNAME}
    Set Test Variable    ${BLOCK_RESPONSE}    ${response}
    ${credit_account_status}    Check Credit Account Status    ${credit_id}
    IF    '${credit_account_status}' != '3'    Fail

Call Schedule Close API
    [Documentation]    Checks if the response status code is 200
    [Arguments]    ${credit_id}=${credit_ids}[0]
    ${schedule_close_response}    Post Credit Accounts Schedule Close
    ...    ${MICROSERVICE_SIDE}
    ...    ${credit_ids}[0]
    ...    ${LMS_BLOCK_REASON.ORGANIZATION_REQUEST}
    ...    ${DASHBOARD_USERNAME}
    Set Test Variable    ${schedule_close_response}

Block credit account
    [Arguments]    ${credit_id}=${credit_ids}[0]
    ${max_retries}    Set Variable    60
    ${retry_count}    Set Variable    0
    ${status}    Set Variable    FAIL
    WHILE    ${retry_count} < ${max_retries} and '${status}' == 'FAIL'
        ${status}    Run Keyword And Return Status    Blocker    ${credit_id}
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

    ${amount}    Evaluate    ${credit_account_initial_balance}*2

    ${empty_balance_tracking_code}    Perform A Complete Offline Purchase    ${user_id}    ${credit_id}    ${amount}

    Purchase Status Must Be CONFIRMED Or DELIVERED    tracking_code=${empty_balance_tracking_code}
    Wait Until Keyword Succeeds
    ...    2 minute
    ...    10 s
    ...    Purchase Should Be Assigned To The Billing Cycle
    ...    tracking_code=${empty_balance_tracking_code}

    Set Test Variable    ${empty_balance_tracking_code}

The Manifest API Is Called
    @{product_types}    Create List    ${PRODUCT_TYPE.CONSUMPTIONGOODS}
    ${response}    POST Credit Gateway Manifest
    ...    ${MICROSERVICE_SIDE}
    ...    ${PAYMENT_CHANNEL}
    ...    ${TICKET_TYPE}
    ...    ${AMOUNT}
    ...    ${product_types}
    ...    ${cell_number}
    ...    ${MANIFEST_PLATFORM_VERSION}
    ...    1    # Product type
    ...    123456    # BasketId
    ...    default    # sellerId
    ...    default    # supplier_id
    ...    default    # product_code
    ...    default    # brand
    ...    1    # count
    ...    default    # category_id
    ...    ${LMS_AUTOMATION_BUSINESS_ID}
    ...    true    # chequeEligible

    Set Test Variable    ${MANIFEST_RESPONSE}    ${response}

The Response Should Contain 1pay BNPL Account And State Is Active
    Should Be Equal As Numbers    ${MANIFEST_RESPONSE['body']['manifests'][0]['state']}    1
    Should Be Equal As Numbers    ${MANIFEST_RESPONSE['body']['manifests'][0]['repaymentOption']}    0

The Response Should Contain Xpay BNPL Account And State Is Active
    Should Be Equal As Numbers    ${MANIFEST_RESPONSE['body']['manifests'][0]['state']}    1
    Should Be Equal As Numbers    ${MANIFEST_RESPONSE['body']['manifests'][0]['repaymentOption']}    1

The Response Should Contain 1pay BNPL Account And State Is Inactive
    Should Be Equal As Strings    ${MANIFEST_RESPONSE['body']['manifests'][0]['state']}    2
    Should Be Equal As Numbers    ${MANIFEST_RESPONSE['body']['manifests'][0]['repaymentOption']}    0

The Response Should Contain Xpay BNPL Account And State Is Inactive
    Should Be Equal As Numbers    ${MANIFEST_RESPONSE['body']['manifests'][0]['state']}    2
    Should Be Equal As Numbers    ${MANIFEST_RESPONSE['body']['manifests'][0]['repaymentOption']}    1

The Response Should Contain 1pay BNPL Account (Zero Credit Balance) And State Is Active
    Should Be Equal As Numbers    ${MANIFEST_RESPONSE['body']['manifests'][0]['state']}    1
    Should Be Equal As Numbers    ${MANIFEST_RESPONSE['body']['manifests'][0]['creditAmount']}    0
    Should Be Equal As Numbers    ${MANIFEST_RESPONSE['body']['manifests'][0]['repaymentOption']}    0

The Response Should Contain Xpay BNPL Account (Zero Credit Balance) And State Is Active
    Should Be Equal As Numbers    ${MANIFEST_RESPONSE['body']['manifests'][0]['state']}    1
    Should Be Equal As Numbers    ${MANIFEST_RESPONSE['body']['manifests'][0]['creditAmount']}    0
    Should Be Equal As Numbers    ${MANIFEST_RESPONSE['body']['manifests'][0]['repaymentOption']}    1

The Response Should Contain 1pay BNPL And Xpay BNPL Account And State Is Active
    Should Be Equal As Numbers    ${MANIFEST_RESPONSE['body']['manifests'][0]['state']}    1
    Should Be Equal As Numbers    ${MANIFEST_RESPONSE['body']['manifests'][0]['repaymentOption']}    0
    Should Be Equal As Numbers    ${MANIFEST_RESPONSE['body']['manifests'][1]['state']}    1
    Should Be Equal As Numbers    ${MANIFEST_RESPONSE['body']['manifests'][1]['repaymentOption']}    1

The Response Should Contain 1pay BNPL And Xpay (Zero Credit Balance) BNPL Account And State Is Active
    Should Be Equal As Numbers    ${MANIFEST_RESPONSE['body']['manifests'][0]['state']}    1
    Should Be Equal As Numbers    ${MANIFEST_RESPONSE['body']['manifests'][0]['repaymentOption']}    0
    Should Be Equal As Numbers    ${MANIFEST_RESPONSE['body']['manifests'][1]['state']}    1
    Should Be Equal As Numbers    ${MANIFEST_RESPONSE['body']['manifests'][1]['repaymentOption']}    1
    Should Be Equal As Numbers    ${MANIFEST_RESPONSE['body']['manifests'][1]['creditAmount']}    0

The Response Should Contain 1pay BNPL (Zero Credit Balance) And Xpay BNPL Account And State Is Active
    Should Be Equal As Numbers    ${MANIFEST_RESPONSE['body']['manifests'][0]['state']}    1
    Should Be Equal As Numbers    ${MANIFEST_RESPONSE['body']['manifests'][0]['repaymentOption']}    0
    Should Be Equal As Numbers    ${MANIFEST_RESPONSE['body']['manifests'][0]['creditAmount']}    0
    Should Be Equal As Numbers    ${MANIFEST_RESPONSE['body']['manifests'][1]['state']}    1
    Should Be Equal As Numbers    ${MANIFEST_RESPONSE['body']['manifests'][1]['repaymentOption']}    1

The Response Should Contain 1pay BNPL (Zero Credit Balance) And Xpay BNPL (Zero Credit Balance) Account And State Is Active
    Should Be Equal As Numbers    ${MANIFEST_RESPONSE['body']['manifests'][0]['state']}    1
    Should Be Equal As Numbers    ${MANIFEST_RESPONSE['body']['manifests'][0]['repaymentOption']}    0
    Should Be Equal As Numbers    ${MANIFEST_RESPONSE['body']['manifests'][0]['creditAmount']}    0
    Should Be Equal As Numbers    ${MANIFEST_RESPONSE['body']['manifests'][1]['state']}    1
    Should Be Equal As Numbers    ${MANIFEST_RESPONSE['body']['manifests'][1]['repaymentOption']}    1
    Should Be Equal As Numbers    ${MANIFEST_RESPONSE['body']['manifests'][1]['creditAmount']}    0

The Response Should Contain 1pay BNPL And Xpay BNPL Account And State Is Inactive
    Should Be Equal As Numbers    ${MANIFEST_RESPONSE['body']['manifests'][0]['state']}    2
    Should Be Equal As Numbers    ${MANIFEST_RESPONSE['body']['manifests'][0]['repaymentOption']}    0
    Should Be Equal As Numbers    ${MANIFEST_RESPONSE['body']['manifests'][1]['state']}    2
    Should Be Equal As Numbers    ${MANIFEST_RESPONSE['body']['manifests'][1]['repaymentOption']}    1

The Response Should Contain 1pay BNPL State Is Active And Xpay BNPL Account State Is Inactive
    Should Be Equal As Numbers    ${MANIFEST_RESPONSE['body']['manifests'][1]['state']}    1
    Should Be Equal As Numbers    ${MANIFEST_RESPONSE['body']['manifests'][1]['repaymentOption']}    0
    Should Be Equal As Numbers    ${MANIFEST_RESPONSE['body']['manifests'][0]['state']}    2
    Should Be Equal As Numbers    ${MANIFEST_RESPONSE['body']['manifests'][0]['repaymentOption']}    1

The Response Should Contain 1pay BNPL State Is Inactive And Xpay BNPL Account State Is Active
    Should Be Equal As Numbers    ${MANIFEST_RESPONSE['body']['manifests'][0]['state']}    2
    Should Be Equal As Numbers    ${MANIFEST_RESPONSE['body']['manifests'][0]['repaymentOption']}    0
    Should Be Equal As Numbers    ${MANIFEST_RESPONSE['body']['manifests'][1]['state']}    1
    Should Be Equal As Numbers    ${MANIFEST_RESPONSE['body']['manifests'][1]['repaymentOption']}    1

The Response Should Contain No Accounts
    Length Should Be    ${MANIFEST_RESPONSE['body']['manifests']}    length=1
    Should Be Equal As Numbers    ${MANIFEST_RESPONSE['body']['manifests'][0]['state']}    3

The Response Should Contain State Is Disable
    Length Should Be    ${MANIFEST_RESPONSE['body']['manifests']}    length=1
    Should Be Equal As Numbers    ${MANIFEST_RESPONSE['body']['manifests'][0]['state']}    0

The Response Should Contain No Installment Sale Account And State Is Disable
    Should Be Equal As Numbers    ${MANIFEST_RESPONSE['body']['state']}    3

The Response Should Contain Credit Account And State Is Active
    Should Be Equal As Numbers    ${MANIFEST_RESPONSE['body']['state']}    1
    Should Be Equal As Numbers    ${MANIFEST_RESPONSE['body']['creditAmount']}    ${DEFAULT_ALLOCATION_AMOUNT}
    Should Be Equal As Strings    ${MANIFEST_RESPONSE['body']['disable']}    False
    Should Be Equal As Strings    ${MANIFEST_RESPONSE['body']['visible']}    True

The Response Should Contain Credit Account And State Is Inactive
    Should Be Equal As Numbers    ${MANIFEST_RESPONSE['body']['state']}    3
    Should Be Equal As Numbers    ${MANIFEST_RESPONSE['body']['creditAmount']}    0
    Should Be Equal As Strings    ${MANIFEST_RESPONSE['body']['disable']}    False

The Response Should Contain Two Credit Accounts And State Is Inactive
    Should Be Equal As Numbers    ${MANIFEST_RESPONSE['body']['state']}    2
    Should Be Equal As Numbers    ${MANIFEST_RESPONSE['body']['creditAmount']}    0
    Should Be Equal As Strings    ${MANIFEST_RESPONSE['body']['disable']}    True

The Response Should Contain No Credit Account And State Is Disable
    Should Be Equal As Strings    ${MANIFEST_RESPONSE['body']['disable']}    True
    Should Be Equal As Strings    ${MANIFEST_RESPONSE['body']['visible']}    False

The Response Should Contain No Credit Account And State Is Disable For Payment Gateway BPG
    Should Be Equal As Strings    ${MANIFEST_RESPONSE['body']['manifests'][0]['disable']}    True
    Should Be Equal As Strings    ${MANIFEST_RESPONSE['body']['manifests'][0]['visible']}    False
    Should Be Equal As Strings    ${MANIFEST_RESPONSE['body']['manifests'][0]['state']}    0

The Response Should Contain No Credit Account And State Is Disable For Payment Gateway CPG
    Should Be Equal As Strings    ${MANIFEST_RESPONSE['body']['disable']}    True
    Should Be Equal As Strings    ${MANIFEST_RESPONSE['body']['visible']}    False
    Should Be Equal As Strings    ${MANIFEST_RESPONSE['body']['state']}    0

The Response Should Contain Installment Sale Account And State Is Active
    Should Be Equal As Strings    ${MANIFEST_RESPONSE['body']['disable']}    False
    Should Be Equal As Numbers    ${MANIFEST_RESPONSE['body']['state']}    1
    Should Be Equal As Numbers    ${MANIFEST_RESPONSE['body']['creditAmount']}    ${DEFAULT_ALLOCATION_AMOUNT}
    Should Be Equal As Strings    ${MANIFEST_RESPONSE['body']['visible']}    True

The Response Should Contain Installment Sale Account And State Is Inactive
    Should Be Equal As Strings    ${MANIFEST_RESPONSE['body']['disable']}    True
    Should Be Equal As Numbers    ${MANIFEST_RESPONSE['body']['state']}    2
    Should Be Equal As Strings    ${MANIFEST_RESPONSE['body']['creditAmount']}    None
    Should Be Equal As Strings    ${MANIFEST_RESPONSE['body']['visible']}    True

The Response Should Contain Installment Sale Account And State Is Inactive And Credit Amount Is Zero
    Should Be Equal As Strings    ${MANIFEST_RESPONSE['body']['disable']}    True
    Should Be Equal As Numbers    ${MANIFEST_RESPONSE['body']['state']}    2
    Should Be Equal As Strings    ${MANIFEST_RESPONSE['body']['creditAmount']}    0
    Should Be Equal As Strings    ${MANIFEST_RESPONSE['body']['visible']}    True
