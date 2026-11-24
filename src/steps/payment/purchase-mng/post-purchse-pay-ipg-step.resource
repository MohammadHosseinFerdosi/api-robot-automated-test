*** Settings ***
Resource        apis/purchase-mng/post-purchases-pay-dpg.resource
Resource        apis/purchase-mng/post-purchases-verify.resource
Resource        apis/purchase-mng/post-purchases-reverse.resource
Resource        services/backend/user-wallet-initializer-service.resource
Resource        services/backend/purchases.resource
Resource        apis/purchase-mng/moke-pay/mock-ipg-result.resource
Resource        apis/purchase-mng/moke-pay/mock-ipg-result-psp.resource
Resource        services/backend/ipg-mock-assigning.resource
Variables       data/payment/purchase/purchase-ipg.yaml
Variables       data/payment/purchase/ipg_mock.yaml


*** Keywords ***
Create New User And New Business With Purchase Setting And Ticket Config And An Assigned IPG Terminal
    # create new user
    ${wallet_config}    Create Dictionary
    ...    definition=${WALLET_DEFAULT_DEFINITION}
    ...    wallet_charge_amount=1
    ...    cashoutable_charge_amount=0
    @{wallet_config_list}    Create List    ${wallet_config}

    ${new_user}    Get Initialized User With Charged Wallet Based On Configuration
    ...    ${CELL_NUMBER_PREFIX}
    ...    ${wallet_config_list}
    Set Test Variable    ${TEST_CELLNUMBER_PAY}    ${new_user['user_cell_number']}
    Set Test Variable    ${TEST_USERID_PAY}    ${new_user['user_id']}

    # create new business
    @{role_list}    Create List    ${USER_ROLE}    ${LOGIN_STAFF_ROLE}
    ${spend_wallet_for_business}    Create Dictionary
    ...    definition=${B_WALLET_SPEND_DEFINITION}
    ...    wallet_charge_amount=0
    ...    currency=${CURRENCY_IRR}
    ${refund_wallet_for_business}    Create Dictionary
    ...    definition=${B_WALLET_REFUND_DEFINITION}
    ...    wallet_charge_amount=0
    ...    currency=${CURRENCY_IRR}
    @{wallet_list}    Create List
    ...    ${spend_wallet_for_business}
    ...    ${refund_wallet_for_business}
    ${new_business}    Get Initialized Business With Charged Wallet Based On Configuration
    ...    ${wallet_list}
    ...    ${role_list}
    ...    zone=app
    ${new_business_id}    Set Variable    ${new_business['business_id']}
    ${new_business_password}    Set Variable    ${new_business['password']}
    # create purchase setting and ticket config
    @{active_gateways}    Create List    ${IPG_GATEWAY}
    ${new_business_config}    Create Business Purchase And Ticket Setting For Purchase And Refund
    ...    ${new_business_id}
    ...    @{active_gateways}
    # assign terminal
    Assign Mock PSP To A New Business    ${DASHBOARD_SIDE}    ${new_business_id}
    ${assigning_result}    POST Terminals
    ...    ${IPG_SUPPORTED_TAG}
    ...    ${PURCHASE_TRANSACTION_TYPE}
    ...    ${MICROSERVICE_SIDE}
    ...    ${MOCK_TERMINAL_ID}
    ...    ${MOCK_KYC_SUPPORTED}
    ...    ${MOCK_BANK_CODE}
    ...    ${MOCK_PIN_CODE}
    ...    ${MOCK_MERCHANT_ID}
    ...    ${new_business_id}
    ...    ${MOCK_PSP_CODE}
    ...    ${MOCK_ACTIVATION_STATUS}
    RETURN    ${assigning_result}
    Login For Business    ${new_business_id}    ${new_business_password}
    RETURN    ${new_business}

####################################    TTICKET PROCCESS ###############################

Success Getting Ticket For Purchase With Android Agent(Gateway)
    [Documentation]    This API Will Be Called From Gateway, So Platform Business Token Should Be Set And Agent Is Android
    ${providerId}    Generate Random String    15
    ${post_ticket_response}    POST Tickets Business
    ...    ${GENERAL_SIDE}
    ...    ${TEST_CELLNUMBER_PAY}
    ...    ${TEST_AMOUNT}
    ...    ${TEST_CALLBACK_URL}
    ...    ${providerId}
    ...    ${UPG_TICKET_TYPE}
    ...    ${ANDROID_AGENT}
    ...    ${PLATFORM_VERSION_2023}
    Should Be Equal As Integers    ${post_ticket_response['status_code']}    200    Invalid response code
    Set Test Variable    ${SDK_Ticket}    ${post_ticket_response['body']['ticket']}
    ${redirctUrl}    Get Value From Json    ${post_ticket_response['body']}    $.redirectUrl
    # Should Be Equal As Strings    ${post_ticket_response["body"].result.title}    ${SUCCESS_TITLE}
    Should Be Equal As Integers    ${post_ticket_response['body'].result.status}    ${SUCCESS_STATUS_CODE}
    Should Be Equal As Strings    ${post_ticket_response['body'].result.message}    ${SUCCESS_MESSAGE}
    Should Be Equal As Strings    ${post_ticket_response['body'].result.level}    ${INFO_LEVEL}

Success Select IPG On Android Agent(Gateway)
    [Documentation]    This API Gets Ticket And DPG Feature Name And DPG Feature Should Be Selected
    ...    And A Record Should Exist In Purchase DB After Selection
    ${select_feature_response}    Wait Until Keyword Succeeds    1 minute    5 s    Get Successful Select Feature
    ...    ${GENERAL_SIDE}
    ...    ${SDK_Ticket}
    ...    ${IPG_FEATURE_NAME}
    ...    ${ANDROID_AGENT}
    ...    ${PLATFORM_VERSION_2020}
    Should Be Equal As Integers    ${select_feature_response['status_code']}    200
    Should Be Equal As Strings    ${select_feature_response["body"].result.title}    ${SUCCESS_TITLE}
    Should Be Equal As Integers    ${select_feature_response['body'].result.status}    ${SUCCESS_STATUS_CODE}
    Should Be Equal As Strings    ${select_feature_response['body'].result.message}    ${SUCCESS_MESSAGE}
    Should Be Equal As Strings    ${select_feature_response['body'].result.level}    ${INFO_LEVEL}

    Dictionary Should Contain Key
    ...    ${select_feature_response['body']}
    ...    amount
    Dictionary Should Contain Key
    ...    ${select_feature_response['body']}
    ...    pspCode
    Dictionary Should Contain Key
    ...    ${select_feature_response['body']}
    ...    redirectUrl
    Dictionary Should Contain Key
    ...    ${select_feature_response['body']}
    ...    payUrl
    Should Be Equal As Strings    ${select_feature_response['body']['payUrl']}    ${IPG_PAY_URL}/${SDK_Ticket}
    ${purchase_data_response}    Post MongoDB Find
    ...    ${PURCHASE_MNG_DB_MANE}
    ...    ${PURCHASE_MNG_PURCHASE_COLLECTION}
    ...    ticket=${SDK_Ticket}
    Should Be Equal As Integers    ${purchase_data_response['status_code']}    200
    Should Not Be Empty    ${purchase_data_response['body']}
    Should Be Equal As Strings    ${purchase_data_response['body'][0]['payGateway']}    IPG
    Should Be Equal As Strings    ${purchase_data_response['body'][0]['status']}    INITIATED
    Should Be Equal As Strings    ${purchase_data_response['body'][0]['owner']['agent']}    ${ANDROID_AGENT}
    Set Test Variable    ${purchase_trackingCode}     ${purchase_data_response['body'][0]['trackingCode]}
    Set Test Variable    ${purchase_traceId}     ${purchase_data_response['body'][0]['traceId]}

    ${switch_data_response}    Post MongoDB Find
    ...    ${SWITCH_PSP_DB_NAME}
    ...    ${SWITCH_PSP_IPG_DETAILS_CHOICE}
    ...    trackingCode=${purchase_trackingCode}
    Set Test Variable    ${psp_token}    ${switch_data_response['body'][0]['token']}

Get Successful Select Feature
    [Documentation]    This Keyword Is A Rapper To Call "Post Tickets Features Select" API
    [Arguments]
    ...    ${api_call_side}
    ...    ${ticket}
    ...    ${featureName}
    ...    ${Agent}
    ...    ${PLATFORM_VERSION}

    ${response}    Post Tickets Features Select
    ...    ${api_call_side}
    ...    ${ticket}
    ...    ${featureName}
    ...    ${Agent}
    ...    ${PLATFORM_VERSION}
    Should Be Equal As Integers    ${response['status_code']}    200
    RETURN    ${response}

Success IPG Purchase
    ${first_pay_response}    POST IPG Result
    ...    ${GENERAL_SIDE}
    ...    ${psp_token}
    ...    ${SUCCESS_PAY}
    ${rrn}    Get From List    ${first_pay_response}    0
    ${sale_order_id}    Get From List    ${first_pay_response}    1
    ${final_pay_response}    POST IPG Result PSP
    ...    ${GENERAL_SIDE}
    ...    ${psp_token}
    ...    ${SUCCESS_PAY}
    ...    ${purchase_traceId}
    ...    ${rrn}
    ...    ${sale_order_id}
    Should Be Equal As Integers    ${final_pay_response['status_code']}    200
    ${purchase_data_response}    Post MongoDB Find
    ...    ${PURCHASE_MNG_DB_MANE}
    ...    ${PURCHASE_MNG_PURCHASE_COLLECTION}
    ...    treceId=${purchase_traceId}
    Should Be Equal As Strings    ${purchase_data_response['body'][0]['status']}    PAID




Call IPG Purchase For A Confirmed State Purchase(Gateway)
    [Documentation]    This API After Getting New Ticket On Android Agent And Select DPG Feature
    ...    Gets Card Information And Send DPG Purchase Request
    ${pay_ipg_response}    POST Purchase Pay DPG
    ...    ${GENERAL_SIDE}
    ...    ${DPG_DESTINATION_TYPE}
    ...    ${SDK_Ticket}
    ...    ${IPG_FEATURE_NAME}
    ...    ${PAYMENT_TEST_CARD_VALUE}
    ...    ${PAYMENT_TEST_CARD_EXPIREDATE}
    ...    ${PAYMENT_TEST_CARD_PREFIX}
    ...    ${PAYMENT_TEST_CARD_POSTFIX}
    ...    ${PAYMENT_TEST_CARD_PIN}
    ...    ${MELLAT_CERT_FILE}
    ...    ${ANDROID_AGENT}
    ...    ${PLATFORM_VERSION_2023}

    Should Be Equal As Integers    ${pay_dpg_response['status_code']}    422
    Should Be Equal As Integers    ${pay_dpg_response['body'].result.status}    ${NON_PAYABLE_STATUS_CODE}
    Should Be Equal As Strings    ${pay_dpg_response['body'].result.message}    ${NON_PAYABLE_MESSAGE}
    Should Be Equal As Strings    ${pay_dpg_response['body'].result.level}    ${WARNING_LEVEL}

    ${data_response}    Post MongoDB Find
    ...    ${PURCHASE_MNG_DB_MANE}
    ...    ${PURCHASE_MNG_PURCHASE_COLLECTION}
    ...    trackingCode=${IPG_Purchase_TrackingCode}
    Should Be Equal As Integers    ${data_response['status_code']}    200
    Should Not Be Empty    ${data_response['body']}
    Should Be Equal As Strings    ${data_response['body'][0]['payGateway']}    IPG
    Should Be Equal As Strings    ${data_response['body'][0]['status']}    CONFIRMED
    Should Be Equal As Strings    ${data_response['body'][0]['paymentChannel']}    UPG
    Should Be Equal As Strings    ${data_response['body'][0]['owner']['agent']}    ${ANDROID_AGENT}
    Set Test Variable    ${purchase_trackingCode}    ${data_response['body'][0]['trackingCode']}

Call IPG Purchase For A Paid State Purchase(Gateway)
    [Documentation]    This API After Getting New Ticket On Android Agent And Select DPG Feature
    ...    Gets Card Information And Send DPG Purchase Request
    ${pay_dpg_response}    POST Purchase Pay DPG
    ...    ${GENERAL_SIDE}
    ...    ${DPG_DESTINATION_TYPE}
    ...    ${SDK_Ticket}
    ...    ${DPG_FEATURE_NAME}
    ...    ${PAYMENT_TEST_CARD_VALUE}
    ...    ${PAYMENT_TEST_CARD_EXPIREDATE}
    ...    ${PAYMENT_TEST_CARD_PREFIX}
    ...    ${PAYMENT_TEST_CARD_POSTFIX}
    ...    ${PAYMENT_TEST_CARD_PIN}
    ...    ${MELLAT_CERT_FILE}
    ...    ${ANDROID_AGENT}
    ...    ${PLATFORM_VERSION_2023}

    Should Be Equal As Integers    ${pay_dpg_response['status_code']}    422
    Should Be Equal As Integers    ${pay_dpg_response['body'].result.status}    ${NON_PAYABLE_STATUS_CODE}
    Should Be Equal As Strings    ${pay_dpg_response['body'].result.message}    ${NON_PAYABLE_MESSAGE}
    Should Be Equal As Strings    ${pay_dpg_response['body'].result.level}    ${WARNING_LEVEL}

    ${data_response}    Post MongoDB Find
    ...    ${PURCHASE_MNG_DB_MANE}
    ...    ${PURCHASE_MNG_PURCHASE_COLLECTION}
    ...    trackingCode=${DPG_Purchase_TrackingCode}
    Should Be Equal As Integers    ${data_response['status_code']}    200
    Should Not Be Empty    ${data_response['body']}
    Should Be Equal As Strings    ${data_response['body'][0]['payGateway']}    DPG
    Should Be Equal As Strings    ${data_response['body'][0]['status']}    PAID
    Should Be Equal As Strings    ${data_response['body'][0]['paymentChannel']}    UPG
    Should Be Equal As Strings    ${data_response['body'][0]['owner']['agent']}    ${ANDROID_AGENT}
    Set Test Variable    ${purchase_trackingCode}    ${data_response['body'][0]['trackingCode']}

################################### Check Activity Of Wallet Purchase In Report-MNG ######################

Success IPG Pruchase Activity In Report
    [Documentation]    Query On Activity Collection Of Report Management DB With `${DPG_Purchase_TrackingCode}` And Check Success Status Of DPG Purchase
    ${data_response}    Post MongoDB Find
    ...    ${REPORT_MNG_DB_NAME}
    ...    ${REPORT_MNG_ACTIVITIES_COLLECTION}
    ...    trackingCode=${IPG_Purchase_TrackingCode}
    Should Be Equal As Integers    ${data_response['status_code']}    200
    Should Not Be Empty    ${data_response['body']}
    Should Be Equal As Strings    ${data_response['body'][0]['gateway']}    0
    Should Be Equal As Strings    ${data_response['body'][0]['status']}    0
    Should Be Equal As Strings    ${data_response['body'][0]['paymentChannel']}    1

Reversed IPG Pruchase Activity In Report
    [Documentation]    Query On Activity Collection Of Report Management DB With `${DPG_Purchase_TrackingCode}` And Check Reverse Status Of DPG Purchase
    ${data_response}    Post MongoDB Find
    ...    ${REPORT_MNG_DB_NAME}
    ...    ${REPORT_MNG_ACTIVITIES_COLLECTION}
    ...    trackingCode=${DPG_Purchase_TrackingCode}
    Should Be Equal As Integers    ${data_response['status_code']}    200
    Should Not Be Empty    ${data_response['body']}
    Should Be Equal As Strings    ${data_response['body'][0]['gateway']}    1
    Should Be Equal As Strings    ${data_response['body'][0]['status']}    4
    Should Be Equal As Strings    ${data_response['body'][0]['paymentChannel']}    1

Manual Reverse On IPG Purchase In Report
    [Documentation]    Query On Activity Collection Of Report Management DB With `${DPG_Purchase_TrackingCode}` And Check Reverse Status Of DPG Purchase
    ${data_response}    Post MongoDB Find
    ...    ${REPORT_MNG_DB_NAME}
    ...    ${REPORT_MNG_ACTIVITIES_COLLECTION}
    ...    trackingCode=${Manual_Reverse_TrackingCode}
    Should Be Equal As Integers    ${data_response['status_code']}    200
    Should Not Be Empty    ${data_response['body']}
    Should Be Equal As Strings    ${data_response['body'][0]['gateway']}    0
    Should Be Equal As Strings    ${data_response['body'][0]['status']}    1
    Should Be Equal As Strings    ${data_response['body'][0]['paymentChannel']}    1

###################################### VERIFY IPG PURCHASE ################################################

Success Verify On IPG Purchase(Gateway)
    [Documentation]    This API Gets Tracking Code Of A Success DPG, And Changes Its Status From "PAID" To "CONFIRMED"
    ${verifyresponse}    POST Purchases Verify
    ...    ${GENERAL_SIDE}
    ...    ${purchase_trackingCode}
    Should Be Equal As Integers    ${verify_response['status_code']}    200
    Should Be Equal As Integers    ${verify_response['body'].result.status}    ${SUCCESS_STATUS_CODE}
    Should Be Equal As Strings    ${verify_response['body'].result.message}    ${SUCCESS_MESSAGE}
    Should Be Equal As Strings    ${verify_response['body'].result.level}    ${INFO_LEVEL}

    Dictionary Should Contain Key
    ...    ${verify_response['body']}
    ...    trackingCode
    Dictionary Should Contain Key
    ...    ${verify_response['body']}
    ...    providerId
    Dictionary Should Contain Key
    ...    ${verify_response['body']}
    ...    terminalId
    Dictionary Should Contain Key
    ...    ${verify_response['body']}
    ...    rrn
    Dictionary Should Contain Key
    ...    ${verify_response['body']}
    ...    maskedPan
    Dictionary Should Contain Key
    ...    ${verify_response['body']}
    ...    pspCode
    Dictionary Should Contain Key
    ...    ${verify_response['body']}
    ...    amount
    Should Be Equal As Strings    ${verify_response['body']['amount']}    ${TEST_AMOUNT}
    Dictionary Should Contain Key
    ...    ${verify_response['body']}
    ...    paymentGateway
    Should Be Equal As Strings    ${verify_response['body']['paymentGateway']}    1

    ${data_response}    Post MongoDB Find
    ...    ${PURCHASE_MNG_DB_MANE}
    ...    ${PURCHASE_MNG_PURCHASE_COLLECTION}
    ...    trackingCode=${purchase_trackingCode}
    Should Be Equal As Integers    ${data_response['status_code']}    200
    Should Not Be Empty    ${data_response['body']}
    Should Be Equal As Strings    ${data_response['body'][0]['status']}    CONFIRMED
    Should Be Equal As Strings    ${data_response['body'][0]['paymentChannel']}    UPG

Failed Verify After More Than 10 Min After Purchase On Platform (Gateway)
    [Documentation]    This Step Gets Tracking Code Of A Success DPG, And Changes Its Status From "PAID" To "CONFIRMED"
    Sleep    11 minutes
    ${verifyresponse}    POST Purchases Verify
    ...    ${GENERAL_SIDE}
    ...    ${purchase_trackingCode}
    Should Be Equal As Integers    ${verify_response['status_code']}    422
    Should Be Equal As Integers    ${verify_response['body'].result.status}    9009
    Should Be Equal As Strings    ${verify_response['body'].result.message}    محدوده ی زمانی تایید تراکنش گذشته است
    Should Be Equal As Strings    ${verify_response['body'].result.level}    ${WARNING_LEVEL}

#################################### Reverse DPG Purchase ###########################################

Success Manual Reverse IPG Purchase Before Settlement Time (Gateway)
    [Documentation]    This Step Gets A Tracking Code Of A Verified Purchase And Makes A New Record In "reverse" Collection Of Purchase-mng DB

    ${provider_id}    Generate Random String    15
    ${manual_reverse_response}    POST Purchases Reverse
    ...    ${GENERAL_SIDE}
    ...    ${purchase_trackingCode}
    ...    ${provider_id}
    Should Be Equal As Integers    ${manual_reverse_response['status_code']}    422
    Should Be Equal As Strings    ${manual_reverse_response['body'].result.status}    ${FAILED_REVERSE_STATUS_CODE}
    Should Be Equal As Strings    ${manual_reverse_response['body'].result.message}    ${FAILED_REVERSE_MESSAGE}
    Should Be Equal As Strings    ${manual_reverse_response['body'].result.level}    ${WARNING_LEVEL}

Success Auto Reverse Status When Verify Does Not Called
    [Documentation]    This Step Gets A Tracking Code Of A Purchase Without Verify And Check Status Of This Purchase In "puchases" Collection Of Purchase-mng DB
    ${reverse_status}    Wait Until Keyword Succeeds
    ...    20 minute
    ...    30 s
    ...    DPG Purchase Auto Reverse Staus Inquiry In Purchase Management

IPG Purchase Auto Reverse Staus Inquiry In Purchase Management
    [Documentation]    Query On Purchase DB To Inquiry Purchase Status After Auto Reverse
    ${data_response}    Post MongoDB Find
    ...    ${PURCHASE_MNG_DB_MANE}
    ...    ${PURCHASE_MNG_PURCHASE_COLLECTION}
    ...    trackingCode=${purchase_trackingCode}
    Should Be Equal As Integers    ${data_response['status_code']}    200
    Should Not Be Empty    ${data_response['body']}
    Should Be Equal As Strings    ${data_response['body'][0]['status']}    REVERSED
    Should Be Equal As Strings    ${data_response['body'][0]['previousStatus']}    PAID
    Should Be Equal As Strings    ${data_response['body'][0]['paymentChannel']}    UPG
