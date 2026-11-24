*** Settings ***
Library     Collections
Library     RequestsLibrary
Library     OperatingSystem
Resource    apis/lms/credit-core/post-credit-gateway-activate.resource
Resource    apis/lms/credit-core/get-credit-transactions.resource
Resource    apis/lms/credit-core/get-credit-activities.resource
Resource    apis/lms/credit-core/post-credit-gateways-disable.resource
Resource    services/backend/import-allocation.resource
Resource    services/backend/user-wallet-initializer-service.resource


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

The user requests the transactions
    ${transactions_response}    GET Credit Transactions
    ...    ${MICROSERVICE_SIDE}
    ...    ${credit_ids}[0]
    ...    ${user_id}

    Set Test Variable    ${transactions_response}

The user requests the transaction receipt
    ${activities_response}    GET Credit Activity
    ...    ${MICROSERVICE_SIDE}
    ...    ${purchase_tracking_code}
    ...    ${user_id}

    Set Test Variable    ${activities_response}

The User Has 1pay Account
    Credit Allocation    types=${{['${LMS_Account_Type_1PAY}']}}    amounts=${{['${DEFAULT_ALLOCATION_AMOUNT}']}}

The User Has 4pay Account
    Credit Allocation    types=${{['${LMS_Account_Type_1PAY}']}}    amounts=${{['${DEFAULT_ALLOCATION_AMOUNT}']}}

The User Has Credit Account
    Credit Allocation    types=${{['${LMS_Account_Type_CREDIT}']}}    amounts=${{['${DEFAULT_ALLOCATION_AMOUNT}']}}

The User Has Installment Sale Account
    Credit Allocation
    ...    types=${{['${LMS_Account_Type_INSTALLMENT_SALE}']}}
    ...    amounts=${{['${DEFAULT_ALLOCATION_AMOUNT}']}}

The Payment Gateway Is Set To BPG
    Set Test Variable    ${PAYMENT_GATEWAY}    ${LMS_PAYMENT_GATEWAY.BPG}

The Payment Gateway Is Set To CPG
    Set Test Variable    ${PAYMENT_GATEWAY}    ${LMS_PAYMENT_GATEWAY.CPG}

The Payment Gateway Is Set To ISPG
    Set Test Variable    ${PAYMENT_GATEWAY}    ${LMS_PAYMENT_GATEWAY.ISPG}

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

Perform a complete purchase
    @{REPAYMENT_OPTIONS}    Create List    ${LMS_REPAYMENT_OPTION.ONEPAY}    ${LMS_REPAYMENT_OPTION.XPAY}
    POST Credit Gateway Activate
    ...    ${MICROSERVICE_SIDE}
    ...    ${LMS_AUTOMATION_BUSINESS_ID}
    ...    2
    ...    ${PAYMENT_GATEWAY}
    ...    0
    ...    ${DASHBOARD_USERNAME}
    ...    ${REPAYMENT_OPTIONS}
    ${tracking_code}    Perform A Complete Offline Purchase
    ...    ${user_id}
    ...    ${credit_ids}[0]
    ...    ${DEFAULT_ALLOCATION_AMOUNT}
    ...    ${LMS_AUTOMATION_BUSINESS_ID}
    ...    2

    Purchase Status Must Be CONFIRMED Or DELIVERED    tracking_code=${tracking_code}
    Wait Until Keyword Succeeds
    ...    2 minute
    ...    10 s
    ...    Purchase Should Be Assigned To The Billing Cycle
    ...    tracking_code=${tracking_code}

    Set Test Variable    ${tracking_code}

The Gateway Is Disabled
    POST Credit Gateway Disable
    ...    ${MICROSERVICE_SIDE}
    ...    ${LMS_AUTOMATION_BUSINESS_ID}
    ...    2
    ...    ${PAYMENT_GATEWAY}

the response should contain transactions list
    Should Be Equal As Integers    ${transactions_response['status_code']}    200
    Should Not Be Empty
    ...    ${transactions_response['body']['businessTransactionDetails'][0]['transactionDetails'][0]['transactionItems'][0]['trackingCode']}

The response status should be 200 for transaction receipt
    Should Be Equal As Integers    ${activities_response['status_code']}    200
