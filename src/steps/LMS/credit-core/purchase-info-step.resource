*** Settings ***
Library     String
Library     RequestsLibrary
Library     Collections
Library     JSONLibrary
Library     Browser
Library     library/installment_date_utils.py
Resource    apis/lms/credit-core/get-credit-purchases-info.resource
Resource    apis/lms/credit-core/post-credit-gateway-activate.resource
Resource    apis/lms/credit-core/post-credit-gateways-disable.resource
Resource    services/backend/import-allocation.resource
Resource    services/backend/LMS/credit-core/credit-online-purchase.resource
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
    Always Close Browser

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
    Set Test Variable    ${DEFAULT_ALLOCATION_AMOUNT_4PAY}    20000
    Credit Allocation
    ...    types=${{['${LMS_Account_Type_1PAY}','${LMS_Account_Type_XPAY}']}}
    ...    amounts=${{['${DEFAULT_ALLOCATION_AMOUNT}','${DEFAULT_ALLOCATION_AMOUNT_4PAY}']}}

The User Has 1pay Account
    Credit Allocation    types=${{['${LMS_Account_Type_1PAY}']}}    amounts=${{['${DEFAULT_ALLOCATION_AMOUNT}']}}

The User Has 4pay Account
    Set Test Variable    ${DEFAULT_ALLOCATION_AMOUNT_4PAY}    20000
    Credit Allocation    types=${{['${LMS_Account_Type_XPAY}']}}    amounts=${{['${DEFAULT_ALLOCATION_AMOUNT_4PAY}']}}

The User Has 4pay And Credit Accounts
    Set Test Variable    ${DEFAULT_ALLOCATION_AMOUNT_4PAY}    20000
    Credit Allocation
    ...    types=${{['${LMS_Account_Type_XPAY}','${LMS_Account_Type_CREDIT}']}}
    ...    amounts=${{['${DEFAULT_ALLOCATION_AMOUNT}','${DEFAULT_ALLOCATION_AMOUNT_4PAY}']}}

The User Has 1pay, 4pay, And Credit Accounts
    Set Test Variable    ${DEFAULT_ALLOCATION_AMOUNT_4PAY}    4000
    Credit Allocation
    ...    types=${{['${LMS_Account_Type_1PAY}','${LMS_Account_Type_XPAY}','${LMS_Account_Type_CREDIT}']}}
    ...    amounts=${{['${DEFAULT_ALLOCATION_AMOUNT}','${DEFAULT_ALLOCATION_AMOUNT_4PAY}','${DEFAULT_ALLOCATION_AMOUNT}']}}

The User Has Installment Sale Account
    Credit Allocation
    ...    types=${{['${LMS_Account_Type_INSTALLMENT_SALE}']}}
    ...    amounts=${{['${DEFAULT_ALLOCATION_AMOUNT}']}}

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

Get a Ticket And Initiate Purchase
    [Arguments]
    ...    ${api_call_side}=${MICROSERVICE_SIDE}
    ...    ${type}=${TICKET_TYPE}
    ...    ${amount}=${AMOUNT}
    ...    ${cell_number}=${cell_number}
    ...    ${credit_id}=${EMPTY}
    ...    ${channel}=${PAYMENT_CHANNEL}
    ...    ${provider_id}=${EMPTY}
    ...    ${redirect_url}=https://example.com/
    ...    ${seller_id}=default
    ...    ${supplier_id}=default
    ...    ${product_code}=default
    ...    ${brand}=default
    ...    ${count}=1
    ...    ${category_id}=default
    ...    ${cheque_eligible}=true
    ...    ${product_type}=${PRODUCT_TYPE.CONSUMPTIONGOODS}
    ...    ${basket_id}=${EMPTY}
    ...    ${user_id}=${LMS_AUTOMATION_BUSINESS_ID}

    IF    '${provider_id}'=='${EMPTY}'
        ${provider_id}    Generate random string    16    1234567890
    END
    IF    '${basket_id}'=='${EMPTY}'
        ${basket_id}    Generate random string    6    1234567890
    END

    ${response}    POST Credit Purchases Ticket
    ...    ${MICROSERVICE_SIDE}
    ...    type=${type}
    ...    channel=${channel}
    ...    amount=${amount}
    ...    cell_number=${cell_number}
    ...    credit_id=${credit_id}
    ...    provider_id=${provider_id}
    ...    redirect_url=${redirect_url}
    ...    seller_id=${seller_id}
    ...    supplier_id=${supplier_id}
    ...    product_code=${product_code}
    ...    brand=${brand}
    ...    count=${count}
    ...    category_id=${category_id}
    ...    cheque_eligible=${cheque_eligible}
    ...    product_type=${product_type}
    ...    basket_id=${basket_id}
    ...    user_id=${user_id}

    ${ticket_status_code}    Set Variable    ${response['status_code']}
    Set Test Variable    ${ticket_status_code}

    ${ticket}    Set Variable    ${EMPTY}
    ${tracking_code}    Set Variable    ${EMPTY}

    ${body}    Set Variable    ${response['body']}
    IF    '${ticket_status_code}'=='200'
        ${ticket}    Set Variable    ${body['ticket']}
        ${tracking_code}    Find The Purchase Tracking Code    ticket=${ticket}
    END
    Set Test Variable    ${ticket}
    RETURN    ${ticket}    ${tracking_code}

Perform a BNPL UPG Purchase on Company via Credit
    [Arguments]
    ...    ${amount}=4000
    ...    ${cell_number}=${cell_number}
    ...    ${credit_id}=${credit_ids}[0]
    ...    ${user_id}=${LMS_AUTOMATION_BUSINESS_ID}

    ${ticket}    ${tracking_code}    Perform A Complete Online Credit Purchase
    ...    type=${CREDIT_TICKET_TYPE_V1.BNPL}
    ...    amount=${amount}
    ...    cell_number=${cell_number}
    ...    credit_id=${credit_id}
    ...    user_id=${user_id}

    Purchase Status Must Be CONFIRMED Or DELIVERED    tracking_code=${tracking_code}
    Wait Until Keyword Succeeds
    ...    2 minute
    ...    10 s
    ...    Purchase Should Be Assigned To The Billing Cycle
    ...    tracking_code=${tracking_code}

    Set Test Variable    ${tracking_code}

Perform a CCREDIT UPG Purchase on Company via Credit
    [Documentation]    Performs a complete purchase via channel UPG where the it is paid only via the credit
    [Arguments]
    ...    ${amount}=4000
    ...    ${cell_number}=${cell_number}
    ...    ${credit_id}=${credit_ids}[2]
    ...    ${user_id}=${LMS_AUTOMATION_BUSINESS_ID}
    ${ticket}    ${tracking_code}    Perform A Complete Online Credit Purchase
    ...    type=${CREDIT_TICKET_TYPE_V1.CREDIT}
    ...    amount=${amount}
    ...    cell_number=${cell_number}
    ...    credit_id=${credit_id}
    ...    user_id=${user_id}

    Purchase Status Must Be CONFIRMED Or DELIVERED    tracking_code=${tracking_code}
    Wait Until Keyword Succeeds
    ...    2 minute
    ...    10 s
    ...    Purchase Should Be Assigned To The Billing Cycle
    ...    tracking_code=${tracking_code}

    Set Test Variable    ${tracking_code}

The Purchase Info Api Called
    [Arguments]
    ...    ${credit_amount}=${AMOUNT}
    ...    ${ticket}=${ticket}

    ${response}    GET Credit Purchases Info
    ...    ${MICROSERVICE_SIDE}
    ...    ticket=${ticket}
    ...    credit_amount=${credit_amount}

    Set Test Variable    ${response}

The Purchase Info Page Must Have Discount Applied
    [Arguments]    ${expected_discount}=${expected_discount}
    Open Browser Session
    New Page    ${BASE_URL}
    Click And Wait (Robust, No-Promise)
    Assert Landed    url=https://example.com
    Take Screenshot On Failure
    Close Browser Session

The Response Should Contain CreditInfo
    Should Be Equal As Integers    ${response['status_code']}    200

The Response For Account With Zero Balance
    Should Be Equal As Integers    ${response['status_code']}    200
    Should Be Equal As Integers    ${response['body']['creditDetails'][0]['balance']}    0

The Response Shouldn't Contain CreditDetails
    Should Be Equal As Integers    ${response['status_code']}    200
    Should Be Empty    ${response['body']['creditDetails']}

The Response Of BNPL With RepaymentOption 1pay Should Contain Account
    Should Be Equal As Integers    ${response['status_code']}    200
    Should Be Equal As Integers    ${response['body']['creditDetails'][0]['installmentCount']}    1

The Response Of BNPL With RepaymentOption Xpay Should Contain Account
    Should Be Equal As Integers    ${response['status_code']}    200
    Should Be Equal As Integers    ${response['body']['creditDetails'][0]['installmentCount']}    3

The Response Of Credit With RepaymentOption Xpay Should Contain Account
    Should Be Equal As Integers    ${response['status_code']}    200
    Should Be Equal As Integers    ${response['body']['creditDetails'][0]['installmentCount']}    6

The Response Should Contain Disabled Account
    Should Be Equal As Integers    ${response['status_code']}    200
    Should Be True    ${response['body']['creditDetails'][0]['disable']}

The Ticket Generation Must Have Failed
    [Arguments]    ${ticket_status_code}=${ticket_status_code}
    IF    '${ticket_status_code}'=='200'
        Fail    msg=Expected the ticket generation to fail, but got status code ${ticket_status_code}
    END

Wait For Url Contains
    [Arguments]    ${fragment}
    ${url}    Set Variable
    ${url}    browser.Get Url
    Should Contain    ${url}    ${fragment}

Extract Otp From Response
    [Arguments]    ${response}
    ${key}    Set Variable    auth_otp_${user_id}
    ${get_otp_result}    Redis Get Key    key=${key}    master_name=redis-new-master
    ${get_otp_value}    Set Variable    ${get_otp_result['body']['value']}

    # Decode bytes → string
    ${json_str}    Decode Bytes To String    bytes=${get_otp_value}    encoding=utf-8\

    # Parse JSON safely
    ${otp_data}    Evaluate    json.loads("""${json_str}""")    json

    # Navigate JSON
    ${otpCodes}    Get From Dictionary    ${otp_data}    otpCodes
    ${otpList}    Get From List    ${otpCodes}    1
    ${otpToken}    Get From List    ${otpList}    0
    ${OTP}    Get From Dictionary    ${otpToken}    value
    RETURN    ${OTP}

Get OTP Code
    # 1) Pull the dynamic response from Redis
    ${redis_response}    Redis Get Key    auth_otp_${user_id}    master_name=redis-new-master
    ${OTP}    Extract Otp From Response    ${redis_response}
    Set Test Variable    ${OTP}
    RETURN    ${OTP}

Fill OTP
    [Arguments]    ${otp}=${OTP}
    ${otp}    Convert To String    item=${otp}
    ${digits}    Split String To Characters    ${otp}
    FOR    ${i}    IN RANGE    0    6
        ${pos}    Evaluate    ${i} + 1
        ${d}    Set Variable    ${digits}[${i}]
        browser.Wait For Elements State
        ...    xpath=(//app-ui-pin-input//input)[${pos}]
        ...    visible    15s
        browser.Fill Text
        ...    xpath=(//app-ui-pin-input//input)[${pos}]
        ...    ${d}
    END

Pay With Platform BNPL
    [Arguments]    ${type}
    # ––– 1) Call the API –––#
    ${purchases_info_response}
    ...    GET Credit Purchases Info
    ...    ${MICROSERVICE_SIDE}
    ...    ticket=${ticket}
    ...    credit_amount=${AMOUNT}
    ${purchase_amount}
    ...    Evaluate    "{:,}".format(${purchases_info_response}[body][amount])
    ${purchase_amount}    Convert To Persian Digit    ${purchase_amount}

    # ––– 2) Open initial BNPL‑pay page & check amount –––#

    ${video_dir}    Set Variable    ${OUTPUT DIR}/videos
    New Context    recordVideo={"dir":"${video_dir}", "size":{"width":1280,"height":720}}
    browser.New Page    ${WEB_BASE_URL}/credit/bnpl-pay/${ticket}
    browser.Wait For Load State    networkidle    15s
    browser.Wait For Elements State    xpath=//div[contains(@class,"info-body-title")]    visible    15s

    ${ui_amount}
    ...    browser.Get Text
    ...    xpath=//*[@id="global-styles"]//span[contains(@class,"currency")]
    ${ui_amount}    Convert To Persian Digit    ${ui_amount}
    Should Be Equal As Strings
    ...    ${ui_amount}    ${purchase_amount} ریال

    # ––– 3) Select first card & confirm –––#
    browser.Click
    ...    xpath=(//div[contains(@class,"service")])[1]
    IF    '${type}' == '1pay'
        browser.Wait For Elements State
        ...    xpath=(//div[contains(@class,"service") and contains(@class,"is-selected")])[1]
        ...    visible    5s
    END
    IF    '${type}' != '1pay'
        browser.Wait For Elements State
        ...    xpath=(//div[contains(@class,"service") and contains(@class,"is-selected")])[0]
        ...    visible    5s
    END
    browser.Click
    ...    xpath=//button[normalize-space(.)="تایید و پرداخت"]

    Wait For Url Contains    /credit/bnpl-pay/details

    ${pages}    Get Page Ids
    FOR    ${id}    IN    @{pages}
        Switch Page    ${id}
        ${title}    Get Title
        ${safe_title}    Replace String    ${title}    ${SPACE}    _
        Take Screenshot    fullPage=True    filename=${safe_title}.png
    END
    # --- 5) Get OTP and submit it ---#

    browser.Wait For Elements State    xpath=//app-ui-pin-input    visible    15s
    Get OTP Code
    Fill OTP
    IF    '${type}' != '1pay'
        browser.Click    xpath=//button[normalize-space(.)="تایید"]
    END
    # 5) Wait for that sheet to go away & details to load
    browser.Wait For Elements State    xpath=//app-ui-pin-input    hidden    15s
    browser.Wait For Elements State    xpath=//div[contains(@class,"info-amount")]    visible    15s
    # ––– 4) On details page, verify purchase amount –––#
    browser.Wait For Elements State
    ...    xpath=//div[contains(@class,"info-amount")]    visible    15s

    ${details_amount}
    ...    browser.Get Text
    ...    xpath=//div[contains(@class,"info-amount")]

    Should Be Equal As Strings
    ...    ${details_amount}    ${purchase_amount} ریال

    # ––– 5) Select second card & final confirm –––#
    browser.Click
    ...    xpath=(//app-selective-card)[2]//div[contains(@class,"content-col")]
    browser.Click
    ...    xpath=//button[normalize-space(.)="تایید و پرداخت"]

    # ––– 6) Assert final redirect back to BNPL‑pay –––#
    Wait For Url Contains    /credit/bnpl-pay/details
    browser.Wait For Elements State
    ...    xpath=//div[contains(@class,"info-header")]    visible    15s

    # ––– Tear down –––#
    browser.Close Browser

Always Close Browser
    Run Keyword And Ignore Error    browser.Close Browser
