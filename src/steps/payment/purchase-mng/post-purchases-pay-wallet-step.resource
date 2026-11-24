*** Settings ***
Resource        apis/purchase-mng/post-purchases-pay-wallet.resource
Resource        apis/wallet-provider/transactions/post-transactions-payout.resource
Resource        apis/purchase-mng/post-purchases-verify.resource
Resource        apis/purchase-mng/post-purchases-reverse.resource
Resource        services/backend/purchases.resource
Variables       data/payment/purchase/purchase-wallet.yaml


*** Keywords ***
Create New User And New Business With Purchase Setting And Ticket Config
    # create new user
    ${wallet_config}    Create Dictionary
    ...    definition=${WALLET_DEFAULT_DEFINITION}
    ...    wallet_charge_amount=${TEST_AMOUNT}
    ...    cashoutable_charge_amount=${TEST_AMOUNT}
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
    @{active_gateways}    Create List    ${DPG_GATEWAY}    ${WALLET_GATEWAY}
    ${new_business_config}    Create Business Purchase And Ticket Setting For Purchase And Refund
    ...    ${new_business_id}
    ...    @{active_gateways}
    Login For Business    ${new_business_id}    ${new_business_password}
    RETURN    ${new_business}

################################### TICKET PROCCESS #################################

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
    ...    ${PLATFORM_VERSION_2020}
    Should Be Equal As Integers    ${post_ticket_response['status_code']}    200    Invalid response code
    Set Test Variable    ${SDK_Ticket}    ${post_ticket_response['body']['ticket']}
    ${redirctUrl}    Get Value From Json    ${post_ticket_response['body']}    $.redirectUrl
    # Should Be Equal As Strings    ${post_ticket_response["body"].result.title}    ${SUCCESS_TITLE}
    Should Be Equal As Integers    ${post_ticket_response['body'].result.status}    ${SUCCESS_STATUS_CODE}
    Should Be Equal As Strings    ${post_ticket_response['body'].result.message}    ${SUCCESS_MESSAGE}
    Should Be Equal As Strings    ${post_ticket_response['body'].result.level}    ${INFO_LEVEL}

Success Getting Ticket For Purchase With Web Agent(Gateway)
    [Documentation]    This API Will Be Called From Gateway, So Business Token Should Be Set And Agent Is Web
    ${providerId}    Generate Random String    15
    ${post_ticket_response}    POST Tickets Business
    ...    ${GENERAL_SIDE}
    ...    ${TEST_CELLNUMBER_PAY}
    ...    ${TEST_AMOUNT}
    ...    ${TEST_CALLBACK_URL}
    ...    ${providerId}
    ...    ${UPG_TICKET_TYPE}
    ...    ${WEB_AGENT}
    ...    ${PLATFORM_VERSION_2020}
    Should Be Equal As Integers    ${post_ticket_response['status_code']}    200    Invalid response code
    Set Test Variable    ${UPG_Ticket}    ${post_ticket_response['body']['ticket']}
    ${redirctUrl}    Get Value From Json    ${post_ticket_response['body']}    $.redirectUrl
    # Should Be Equal As Strings    ${post_ticket_response['body'].result.title}    ${SUCCESS_TITLE}
    Should Be Equal As Integers    ${post_ticket_response['body'].result.status}    ${SUCCESS_STATUS_CODE}
    Should Be Equal As Strings    ${post_ticket_response['body'].result.message}    ${SUCCESS_MESSAGE}
    Should Be Equal As Strings    ${post_ticket_response['body'].result.level}    ${INFO_LEVEL}

Success Getting Ticket's Features With Android Agent(Gateway)
    [Documentation]    Getting Features Of Ticket In TGS On Android Agent Through Gateway Request
    ${get_ticket_info_response}    Get Tickets    ${GENERAL_SIDE}
    ...    ${SDK_Ticket}
    ...    ${PLATFORM_VERSION_2020}
    Should Be Equal As Integers    ${get_ticket_info_response['status_code']}    200    Invalid response code
    Should Be Equal As Strings    ${get_ticket_info_response['body'].result.title}    ${SUCCESS_TITLE}
    Should Be Equal As Integers    ${get_ticket_info_response['body'].result.status}    ${SUCCESS_STATUS_CODE}
    Should Be Equal As Strings    ${get_ticket_info_response['body'].result.message}    ${SUCCESS_MESSAGE}
    Should Be Equal As Strings    ${get_ticket_info_response['body'].result.level}    ${INFO_LEVEL}
    ${payment_method_length}    Get Length    ${get_ticket_info_response['body'].features}
    ${features_list}    Create List    ${get_ticket_info_response['body'].features[0].name}

    FOR    ${index}    IN RANGE    1    ${payment_method_length}
        Append To List    ${features_list}    ${get_ticket_info_response['body'].features[${index}].name}
        ${features_list_length}    Get Length    ${features_list}
    END
    Sort List    ${features_list}
    Should Be Equal    ${features_list}    ${DEBIT_UPG_FEATURES}

Success Getting Ticket's Features With Web Agent(Gateway)
    [Documentation]    Getting Features Of Ticket In TGS On Web Agent Through Gateway Request
    ${get_ticket_info_response}    Get Tickets    ${GENERAL_SIDE}
    ...    ${UPG_Ticket}
    ...    ${PLATFORM_VERSION_2020}
    Should Be Equal As Integers    ${get_ticket_info_response['status_code']}    200    Invalid response code
    Should Be Equal As Strings    ${get_ticket_info_response['body'].result.title}    ${SUCCESS_TITLE}
    Should Be Equal As Integers    ${get_ticket_info_response['body'].result.status}    ${SUCCESS_STATUS_CODE}
    Should Be Equal As Strings    ${get_ticket_info_response['body'].result.message}    ${SUCCESS_MESSAGE}
    Should Be Equal As Strings    ${get_ticket_info_response['body'].result.level}    ${INFO_LEVEL}

    ${payment_method_length}    Get Length    ${get_ticket_info_response['body'].features}
    ${features_list}    Create List    ${get_ticket_info_response['body'].features[0].name}

    FOR    ${index}    IN RANGE    1    ${payment_method_length}
        Append To List    ${features_list}    ${get_ticket_info_response['body'].features[${index}].name}
        ${features_list_length}    Get Length    ${features_list}
    END
    Sort List    ${features_list}
    Should Be Equal    ${features_list}    ${WEB_DEBIT_UPG_FEATURES}

Success Select Wallet On Android Agent(Gateway)
    [Documentation]    This API Gets Ticket And Wallet Feature Name And Wallet Feature Should Be Selected
    ...    And A Record Should Exist In Purchase DB After Selection
    ${select_feature_response}    Post Tickets Features Select
    ...    ${GENERAL_SIDE}
    ...    ${SDK_Ticket}
    ...    ${WALLET_FEATURE_NAME}
    ...    ${ANDROID_AGENT}
    ...    ${PLATFORM_VERSION_2020}
    Should Be Equal As Integers    ${select_feature_response['status_code']}    200    msg=Invalid response code
    Should Be Equal As Strings    ${select_feature_response["body"].result.title}    ${SUCCESS_TITLE}
    Should Be Equal As Integers    ${select_feature_response['body'].result.status}    ${SUCCESS_STATUS_CODE}
    Should Be Equal As Strings    ${select_feature_response['body'].result.message}    ${SUCCESS_MESSAGE}
    Should Be Equal As Strings    ${select_feature_response['body'].result.level}    ${INFO_LEVEL}

    Dictionary Should Contain Key
    ...    ${select_feature_response['body']}
    ...    amount
    Dictionary Should Contain Key
    ...    ${select_feature_response['body']}
    ...    walletBalance
    Dictionary Should Contain Key
    ...    ${select_feature_response['body']}
    ...    redirectUrl
    Dictionary Should Contain Key
    ...    ${select_feature_response['body']}
    ...    payUrl
    Should Be Equal As Strings    ${select_feature_response['body']['payUrl']}    ${WALLET_PAY_URL}
    ${filter_query}    Create Dictionary    ticket=${SDK_Ticket}
    ${data_response}    Mongo Db Find
    ...    ${PURCHASE_MNG_DB_MANE}
    ...    ${PURCHASE_MNG_PURCHASE_COLLECTION}
    ...    ${filter_query}
    Should Be Equal As Integers    ${data_response['status_code']}    0
    Should Not Be Empty    ${data_response['body']}
    Should Be Equal As Strings    ${data_response['body'][0]['payGateway']}    WALLET
    Should Be Equal As Strings    ${data_response['body'][0]['status']}    INITIATED
    Should Be Equal As Strings    ${data_response['body'][0]['owner']['agent']}    ${ANDROID_AGENT}
    Set Test Variable    ${purchase_trackingCode}    ${data_response['body'][0]['trackingCode']}

Success Select Wallet On Web Agent(Gateway)
    [Documentation]    This API Gets Ticket And Wallet Feature Name And Wallet Feature Should Be Selected
    ...    And A Record Should Exist In Purchase DB After Selection
    ${select_feature_response}    Post Tickets Features Select
    ...    ${GENERAL_SIDE}
    ...    ${UPG_Ticket}
    ...    ${WALLET_FEATURE_NAME}
    ...    ${WEB_AGENT}
    ...    ${PLATFORM_VERSION_2020}
    Should Be Equal As Integers    ${select_feature_response['status_code']}    200    msg=Invalid response code
    Should Be Equal As Strings    ${select_feature_response["body"].result.title}    ${SUCCESS_TITLE}
    Should Be Equal As Integers    ${select_feature_response['body'].result.status}    ${SUCCESS_STATUS_CODE}
    Should Be Equal As Strings    ${select_feature_response['body'].result.message}    ${SUCCESS_MESSAGE}
    Should Be Equal As Strings    ${select_feature_response['body'].result.level}    ${INFO_LEVEL}

    Dictionary Should Contain Key
    ...    ${select_feature_response['body']}
    ...    amount
    Dictionary Should Contain Key
    ...    ${select_feature_response['body']}
    ...    walletBalance
    Dictionary Should Contain Key
    ...    ${select_feature_response['body']}
    ...    redirectUrl
    Dictionary Should Contain Key
    ...    ${select_feature_response['body']}
    ...    payUrl
    Should Be Equal As Strings    ${select_feature_response['body']['payUrl']}    ${WALLET_PAY_URL}
    ${filter_query}    Create Dictionary    ticket=${UPG_Ticket}
    ${data_response}    Mongo Db Find
    ...    ${PURCHASE_MNG_DB_MANE}
    ...    ${PURCHASE_MNG_PURCHASE_COLLECTION}
    ...    ${filter_query}
    Should Be Equal As Integers    ${data_response['status_code']}    0
    Should Not Be Empty    ${data_response['body']}
    Should Be Equal As Strings    ${data_response['body'][0]['payGateway']}    WALLET
    Should Be Equal As Strings    ${data_response['body'][0]['status']}    INITIATED
    Should Be Equal As Strings    ${data_response['body'][0]['owner']['agent']}    ${WEB_AGENT}
    Set Test Variable    ${wallet_purchase_trackingCode}    ${data_response['body'][0]['trackingCode']}

################################### Android Wallet Purchase ###########################

Wallet Balance Should Be Equal To Zero
    ${expected_amount}    Set Variable    0
    ${wallet_balance_response}    GET Wallets Users Balance
    ...    ${MICROSERVICE_SIDE}
    ...    ${TEST_USERID_PAY}
    ...    wallet_name=default
    ${new_balance}    Set Variable    ${wallet_balance_response['body']['balance']}
    Should Be Equal As Integers    ${new_balance}    ${expected_amount}

Wallet Balance Should Not Be Decreased After Purchase
    ${expected_amount}    Set Variable    ${user_balance}
    ${wallet_balance_response}    GET Wallets Users Balance
    ...    ${MICROSERVICE_SIDE}
    ...    ${TEST_USERID_PAY}
    ...    wallet_name=default
    ${new_balance}    Set Variable    ${wallet_balance_response['body']['balance']}
    Should Be Equal As Integers    ${new_balance}    ${expected_amount}

Wallet Balance Should Be Increased After Reverse
    ${expected_amount}    Evaluate    ${user_balance} + ${TEST_AMOUNT}
    ${wallet_balance_response}    GET Wallets Users Balance
    ...    ${MICROSERVICE_SIDE}
    ...    ${TEST_USERID_PAY}
    ...    wallet_name=default
    ${increased_balance}    Set Variable    ${wallet_balance_response['body']['balance']}
    Should Be Equal As Integers    ${increased_balance}    ${expected_amount}

Wallet Balance Check
    ${wallet_balance_response}    GET Wallets Users Balance
    ...    ${MICROSERVICE_SIDE}
    ...    ${TEST_USERID_PAY}
    ...    wallet_name=default
    Set Test Variable    ${user_balance}    ${wallet_balance_response['body']['balance']}

Success Wallet Purchase With Android Agent(Gateway)
    [Documentation]    This API After Getting New Ticket On Android Agent And Select Wallet Feature
    ...    Gets ${WALLET_DESTINATION_TYPE} And ${SDK_Ticket} And Then Send Wallet Purchase Request

    ${pay_wallet_response}    POST Purchase Pay Wallet
    ...    ${GENERAL_SIDE}
    ...    ${WALLET_DESTINATION_TYPE}
    ...    ${SDK_Ticket}
    ...    ${ANDROID_AGENT}
    ...    ${PLATFORM_VERSION_2023}

    Should Be Equal As Integers    ${pay_wallet_response['status_code']}    200
    Should Be Equal As Strings    ${pay_wallet_response['body'].result.title}    ${SUCCESS_TITLE}
    Should Be Equal As Integers    ${pay_wallet_response['body'].result.status}    ${SUCCESS_STATUS_CODE}
    Should Be Equal As Strings    ${pay_wallet_response['body'].result.message}    ${SUCCESS_MESSAGE}
    Should Be Equal As Strings    ${pay_wallet_response['body'].result.level}    ${INFO_LEVEL}

    Dictionary Should Contain Key
    ...    ${pay_wallet_response['body']}
    ...    paymentResult
    Dictionary Should Contain Key
    ...    ${pay_wallet_response['body']}
    ...    trackingCode
    Dictionary Should Contain Key
    ...    ${pay_wallet_response['body']}
    ...    payInfo
    Dictionary Should Contain Key
    ...    ${pay_wallet_response['body']}
    ...    status
    Should Be Equal As Strings    ${pay_wallet_response['body']['status']}    ${SUCCESS_STATUS_MESSAGGE}
    Dictionary Should Contain Key
    ...    ${pay_wallet_response['body']}
    ...    amount
    Dictionary Should Contain Key
    ...    ${pay_wallet_response['body']}
    ...    redirectDetail
    Dictionary Should Contain Key
    ...    ${pay_wallet_response['body']}
    ...    type
    ${trackingCode}    Get Value From Json    ${pay_wallet_response['body']}    $.trackingCode
    Set Test Variable    ${Wallet_Purchase_TrackingCode}    ${trackingCode[0]}
    ${filter_query}    Create Dictionary    trackingCode=${Wallet_Purchase_TrackingCode}
    ${data_response}    Mongo Db Find
    ...    ${PURCHASE_MNG_DB_MANE}
    ...    ${PURCHASE_MNG_PURCHASE_COLLECTION}
    ...    ${filter_query}
    Should Be Equal As Integers    ${data_response['status_code']}    0
    Should Not Be Empty    ${data_response['body']}
    Should Be Equal As Strings    ${data_response['body'][0]['payGateway']}    WALLET
    Should Be Equal As Strings    ${data_response['body'][0]['status']}    PAID
    Should Be Equal As Strings    ${data_response['body'][0]['paymentChannel']}    UPG
    Should Be Equal As Strings    ${data_response['body'][0]['owner']['agent']}    ${ANDROID_AGENT}

Success Wallet Purchase With Android Agent(Microservice)
    [Documentation]    This API After Getting New Ticket On Android Agent And Select Wallet Feature
    ...    Gets ${WALLET_DESTINATION_TYPE} And ${SDK_Ticket} And Then Send Wallet Purchase Request

    ${pay_wallet_response}    POST Purchase Pay Wallet
    ...    ${MICROSERVICE_SIDE}
    ...    ${WALLET_DESTINATION_TYPE}
    ...    ${SDK_Ticket}
    ...    ${ANDROID_AGENT}
    ...    ${PLATFORM_VERSION_2023}

    Should Be Equal As Integers    ${pay_wallet_response['status_code']}    200
    Should Be Equal As Strings    ${pay_wallet_response['body'].result.title}    ${SUCCESS_TITLE}
    Should Be Equal As Integers    ${pay_wallet_response['body'].result.status}    ${SUCCESS_STATUS_CODE}
    Should Be Equal As Strings    ${pay_wallet_response['body'].result.message}    ${SUCCESS_MESSAGE}
    Should Be Equal As Strings    ${pay_wallet_response['body'].result.level}    ${INFO_LEVEL}

    Dictionary Should Contain Key
    ...    ${pay_wallet_response['body']}
    ...    paymentResult
    Dictionary Should Contain Key
    ...    ${pay_wallet_response['body']}
    ...    trackingCode
    Dictionary Should Contain Key
    ...    ${pay_wallet_response['body']}
    ...    payInfo
    Dictionary Should Contain Key
    ...    ${pay_wallet_response['body']}
    ...    status
    Should Be Equal As Strings    ${pay_wallet_response['body']['status']}    ${SUCCESS_STATUS_MESSAGGE}
    Dictionary Should Contain Key
    ...    ${pay_wallet_response['body']}
    ...    amount
    Dictionary Should Contain Key
    ...    ${pay_wallet_response['body']}
    ...    redirectDetail
    Dictionary Should Contain Key
    ...    ${pay_wallet_response['body']}
    ...    type
    ${trackingCode}    Get Value From Json    ${pay_wallet_response['body']}    $.trackingCode
    Set Test Variable    ${Wallet_Purchase_TrackingCode}    ${trackingCode[0]}

    ${filter_query}    Create Dictionary    trackingCode=${Wallet_Purchase_TrackingCode}
    ${data_response}    Mongo Db Find
    ...    ${PURCHASE_MNG_DB_MANE}
    ...    ${PURCHASE_MNG_PURCHASE_COLLECTION}
    ...    ${filter_query}
    Should Be Equal As Integers    ${data_response['status_code']}    0
    Should Not Be Empty    ${data_response['body']}
    Should Be Equal As Strings    ${data_response['body'][0]['payGateway']}    WALLET
    Should Be Equal As Strings    ${data_response['body'][0]['status']}    PAID
    Should Be Equal As Strings    ${data_response['body'][0]['paymentChannel']}    UPG
    Should Be Equal As Strings    ${data_response['body'][0]['owner']['agent']}    ${ANDROID_AGENT}

############################ Web Wallet Purchase ######################################

Success Wallet Purchase With Web Agent(Gateway)
    [Documentation]    This API After Getting New Ticket On Web Agent And Select Wallet Feature
    ...    Gets ${WALLET_DESTINATION_TYPE} And ${SDK_Ticket} And Then Send Wallet Purchase Request

    ${pay_wallet_response}    POST Purchase Pay Wallet
    ...    ${GENERAL_SIDE}
    ...    ${WALLET_DESTINATION_TYPE}
    ...    ${UPG_Ticket}
    ...    ${WEB_AGENT}
    ...    ${PLATFORM_VERSION_2023}

    Should Be Equal As Integers    ${pay_wallet_response['status_code']}    200
    Should Be Equal As Strings    ${pay_wallet_response['body'].result.title}    ${SUCCESS_TITLE}
    Should Be Equal As Integers    ${pay_wallet_response['body'].result.status}    ${SUCCESS_STATUS_CODE}
    Should Be Equal As Strings    ${pay_wallet_response['body'].result.message}    ${SUCCESS_MESSAGE}
    Should Be Equal As Strings    ${pay_wallet_response['body'].result.level}    ${INFO_LEVEL}

    Dictionary Should Contain Key
    ...    ${pay_wallet_response['body']}
    ...    paymentResult
    Dictionary Should Contain Key
    ...    ${pay_wallet_response['body']}
    ...    trackingCode
    Dictionary Should Contain Key
    ...    ${pay_wallet_response['body']}
    ...    payInfo
    Dictionary Should Contain Key
    ...    ${pay_wallet_response['body']}
    ...    status
    Should Be Equal As Strings    ${pay_wallet_response['body']['status']}    ${SUCCESS_STATUS_MESSAGGE}
    Dictionary Should Contain Key
    ...    ${pay_wallet_response['body']}
    ...    amount
    Dictionary Should Contain Key
    ...    ${pay_wallet_response['body']}
    ...    redirectDetail
    Dictionary Should Contain Key
    ...    ${pay_wallet_response['body']}
    ...    type
    ${trackingCode}    Get Value From Json    ${pay_wallet_response['body']}    $.trackingCode
    Set Test Variable    ${Wallet_Purchase_TrackingCode}    ${trackingCode[0]}
    ${filter_query}    Create Dictionary    trackingCode=${Wallet_Purchase_TrackingCode}
    ${data_response}    Mongo Db Find
    ...    ${PURCHASE_MNG_DB_MANE}
    ...    ${PURCHASE_MNG_PURCHASE_COLLECTION}
    ...    ${filter_query}
    Should Be Equal As Integers    ${data_response['status_code']}    0
    Should Not Be Empty    ${data_response['body']}
    Should Be Equal As Strings    ${data_response['body'][0]['payGateway']}    WALLET
    Should Be Equal As Strings    ${data_response['body'][0]['status']}    PAID
    Should Be Equal As Strings    ${data_response['body'][0]['paymentChannel']}    UPG
    Should Be Equal As Strings    ${data_response['body'][0]['owner']['agent']}    ${WEB_AGENT}

Success Wallet Purchase With Web Agent(Microservice)
    [Documentation]    This API After Getting New Ticket On Web Agent And Select Wallet Feature
    ...    Gets ${WALLET_DESTINATION_TYPE} And ${SDK_Ticket} And Then Send Wallet Purchase Request

    ${pay_wallet_response}    POST Purchase Pay Wallet
    ...    ${MICROSERVICE_SIDE}
    ...    ${WALLET_DESTINATION_TYPE}
    ...    ${UPG_Ticket}
    ...    ${WEB_AGENT}
    ...    ${PLATFORM_VERSION_2023}

    Should Be Equal As Integers    ${pay_wallet_response['status_code']}    200
    Should Be Equal As Strings    ${pay_wallet_response['body'].result.title}    ${SUCCESS_TITLE}
    Should Be Equal As Integers    ${pay_wallet_response['body'].result.status}    ${SUCCESS_STATUS_CODE}
    Should Be Equal As Strings    ${pay_wallet_response['body'].result.message}    ${SUCCESS_MESSAGE}
    Should Be Equal As Strings    ${pay_wallet_response['body'].result.level}    ${INFO_LEVEL}

    Dictionary Should Contain Key
    ...    ${pay_wallet_response['body']}
    ...    paymentResult
    Dictionary Should Contain Key
    ...    ${pay_wallet_response['body']}
    ...    trackingCode
    Dictionary Should Contain Key
    ...    ${pay_wallet_response['body']}
    ...    payInfo
    Dictionary Should Contain Key
    ...    ${pay_wallet_response['body']}
    ...    status
    Should Be Equal As Strings    ${pay_wallet_response['body']['status']}    ${SUCCESS_STATUS_MESSAGGE}
    Dictionary Should Contain Key
    ...    ${pay_wallet_response['body']}
    ...    amount
    Dictionary Should Contain Key
    ...    ${pay_wallet_response['body']}
    ...    redirectDetail
    Dictionary Should Contain Key
    ...    ${pay_wallet_response['body']}
    ...    type
    ${trackingCode}    Get Value From Json    ${pay_wallet_response['body']}    $.trackingCode
    Set Test Variable    ${Wallet_Purchase_TrackingCode}    ${trackingCode[0]}

    ${filter_query}    Create Dictionary    trackingCode=${Wallet_Purchase_TrackingCode}
    ${data_response}    Mongo Db Find
    ...    ${PURCHASE_MNG_DB_MANE}
    ...    ${PURCHASE_MNG_PURCHASE_COLLECTION}
    ...    ${filter_query}
    Should Be Equal As Integers    ${data_response['status_code']}    0
    Should Not Be Empty    ${data_response['body']}
    Should Be Equal As Strings    ${data_response['body'][0]['payGateway']}    WALLET
    Should Be Equal As Strings    ${data_response['body'][0]['status']}    PAID
    Should Be Equal As Strings    ${data_response['body'][0]['paymentChannel']}    UPG
    Should Be Equal As Strings    ${data_response['body'][0]['owner']['agent']}    ${WEB_AGENT}

Failed Wallet Purchase With Android Agent Through Enter Wrong Ticket (Gateway)
    [Documentation]    This Step Gets A Type And A Wrong Ticket And Returns A Proper Response
    ${random_ticket}    Generate Random String    30    chars=[LETTERS][NUMBERS]
    ${pay_wallet_response}    POST Purchase Pay Wallet
    ...    ${GENERAL_SIDE}
    ...    ${WALLET_DESTINATION_TYPE}
    ...    ${random_ticket}
    ...    ${ANDROID_AGENT}
    ...    ${PLATFORM_VERSION_2023}

    Should Be Equal As Integers    ${pay_wallet_response['status_code']}    422
    Should Be Equal As Integers    ${pay_wallet_response['body'].result.status}    ${INVALID_TOKEN_STATUS_CODE}
    Should Be Equal As Strings    ${pay_wallet_response['body'].result.message}    ${INVALID_TOKEN_MESSAGE}
    Should Be Equal As Strings    ${pay_wallet_response['body'].result.level}    ${WARNING_LEVEL}

Call Wallet Purchase For A Paid State Purchase(Gateway)
    [Documentation]    This API After Getting New Ticket On Android Agent And Select Wallet Feature
    ...    Gets ${WALLET_DESTINATION_TYPE} And ${SDK_Ticket} And Then Send Wallet Purchase Request

    ${pay_wallet_response}    POST Purchase Pay Wallet
    ...    ${GENERAL_SIDE}
    ...    ${WALLET_DESTINATION_TYPE}
    ...    ${SDK_Ticket}
    ...    ${ANDROID_AGENT}
    ...    ${PLATFORM_VERSION_2023}

    Should Be Equal As Integers    ${pay_wallet_response['status_code']}    422
    Should Be Equal As Integers    ${pay_wallet_response['body'].result.status}    ${NON_PAYABLE_STATUS_CODE}
    Should Be Equal As Strings    ${pay_wallet_response['body'].result.message}    ${NON_PAYABLE_MESSAGE}
    Should Be Equal As Strings    ${pay_wallet_response['body'].result.level}    ${WARNING_LEVEL}

    ${filter_query}    Create Dictionary    trackingCode=${Wallet_Purchase_TrackingCode}
    ${data_response}    Mongo Db Find
    ...    ${PURCHASE_MNG_DB_MANE}
    ...    ${PURCHASE_MNG_PURCHASE_COLLECTION}
    ...    ${filter_query}
    Should Be Equal As Integers    ${data_response['status_code']}    0
    Should Not Be Empty    ${data_response['body']}
    Should Be Equal As Strings    ${data_response['body'][0]['payGateway']}    WALLET
    Should Be Equal As Strings    ${data_response['body'][0]['status']}    PAID
    Should Be Equal As Strings    ${data_response['body'][0]['paymentChannel']}    UPG
    Should Be Equal As Strings    ${data_response['body'][0]['owner']['agent']}    ${ANDROID_AGENT}

Call Wallet Purchase For A Confirmed State Purchase(Gateway)
    [Documentation]    This API After Getting New Ticket On Android Agent And Select Wallet Feature
    ...    Gets ${WALLET_DESTINATION_TYPE} And ${SDK_Ticket} And Then Send Wallet Purchase Request

    ${pay_wallet_response}    POST Purchase Pay Wallet
    ...    ${GENERAL_SIDE}
    ...    ${WALLET_DESTINATION_TYPE}
    ...    ${SDK_Ticket}
    ...    ${ANDROID_AGENT}
    ...    ${PLATFORM_VERSION_2023}

    Should Be Equal As Integers    ${pay_wallet_response['status_code']}    422
    Should Be Equal As Integers    ${pay_wallet_response['body'].result.status}    ${NON_PAYABLE_STATUS_CODE}
    Should Be Equal As Strings    ${pay_wallet_response['body'].result.message}    ${NON_PAYABLE_MESSAGE}
    Should Be Equal As Strings    ${pay_wallet_response['body'].result.level}    ${WARNING_LEVEL}

    ${filter_query}    Create Dictionary    trackingCode=${Wallet_Purchase_TrackingCode}
    ${data_response}    Mongo Db Find
    ...    ${PURCHASE_MNG_DB_MANE}
    ...    ${PURCHASE_MNG_PURCHASE_COLLECTION}
    ...    ${filter_query}
    Should Be Equal As Integers    ${data_response['status_code']}    0
    Should Not Be Empty    ${data_response['body']}
    Should Be Equal As Strings    ${data_response['body'][0]['payGateway']}    WALLET
    Should Be Equal As Strings    ${data_response['body'][0]['status']}    CONFIRMED
    Should Be Equal As Strings    ${data_response['body'][0]['paymentChannel']}    UPG
    Should Be Equal As Strings    ${data_response['body'][0]['owner']['agent']}    ${ANDROID_AGENT}

################################### Check Activity Of Wallet Purchase In Report-MNG ######################

Success Wallet Pruchase Activity In Report
    [Documentation]    Query On Activity Collection Of Report Management DB With `${Wallet_Purchase_TrackingCode}` And Check Success Status Of Wallet Prchase
    ${filter_query}    Create Dictionary    trackingCode=${Wallet_Purchase_TrackingCode}
    ${data_response}    Mongo Db Find
    ...    ${REPORT_MNG_DB_NAME}
    ...    ${REPORT_ACTIVITY_COlLECTION}
    ...    ${filter_query}
    Should Be Equal As Integers    ${data_response['status_code']}    0
    Should Not Be Empty    ${data_response['body']}
    Should Be Equal As Strings    ${data_response['body'][0]['gateway']}    4
    Should Be Equal As Strings    ${data_response['body'][0]['status']}    0
    Should Be Equal As Strings    ${data_response['body'][0]['paymentChannel']}    1

Reversed Wallet Pruchase Activity In Report
    [Documentation]    Query On Activity Collection Of Report Management DB With `${Wallet_Purchase_TrackingCode}` And Check Success Status Of Wallet Prchase
    ${filter_query}    Create Dictionary    trackingCode=${Wallet_Purchase_TrackingCode}
    ${data_response}    Mongo Db Find
    ...    ${REPORT_MNG_DB_NAME}
    ...    ${REPORT_ACTIVITY_COlLECTION}
    ...    ${filter_query}
    Should Be Equal As Integers    ${data_response['status_code']}    0
    Should Not Be Empty    ${data_response['body']}
    Should Be Equal As Strings    ${data_response['body'][0]['gateway']}    4
    Should Be Equal As Strings    ${data_response['body'][0]['status']}    4
    Should Be Equal As Strings    ${data_response['body'][0]['paymentChannel']}    1

###################################### VERIFY WALLET PURCHASE ################################################

Success Verify On Wallet Purchase With Android Agent(Gateway)
    [Documentation]    This API Gets Tracking Code Of A Success DPG, And Changes Its Status From "PAID" To "CONFIRMED"
    ${verifyresponse}    POST Purchases Verify
    ...    ${GENERAL_SIDE}
    ...    ${Wallet_Purchase_TrackingCode}
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
    ...    rrn
    Dictionary Should Contain Key
    ...    ${verify_response['body']}
    ...    amount
    Should Be Equal As Strings    ${verify_response['body']['amount']}    ${TEST_AMOUNT}
    Dictionary Should Contain Key
    ...    ${verify_response['body']}
    ...    paymentGateway
    Should Be Equal As Strings    ${verify_response['body']['paymentGateway']}    3

    ${filter_query}    Create Dictionary    trackingCode=${Wallet_Purchase_TrackingCode}
    ${data_response}    Mongo Db Find
    ...    ${PURCHASE_MNG_DB_MANE}
    ...    ${PURCHASE_MNG_PURCHASE_COLLECTION}
    ...    ${filter_query}
    Should Be Equal As Integers    ${data_response['status_code']}    0
    Should Not Be Empty    ${data_response['body']}
    Should Be Equal As Strings    ${data_response['body'][0]['status']}    CONFIRMED
    Should Be Equal As Strings    ${data_response['body'][0]['paymentChannel']}    UPG

Success Verify On Wallet Purchase With Android Agent(Microservice)
    [Documentation]    This API Gets Tracking Code Of A Success DPG, And Changes Its Status From "PAID" To "CONFIRMED"
    ${verifyresponse}    POST Purchases Verify
    ...    ${MICROSERVICE_SIDE}
    ...    ${Wallet_Purchase_TrackingCode}
    ...    ${PLATFORM_UESERNAME}
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
    ...    rrn
    Dictionary Should Contain Key
    ...    ${verify_response['body']}
    ...    amount
    Should Be Equal As Strings    ${verify_response['body']['amount']}    ${TEST_AMOUNT}
    Dictionary Should Contain Key
    ...    ${verify_response['body']}
    ...    paymentGateway
    Should Be Equal As Strings    ${verify_response['body']['paymentGateway']}    3

    ${filter_query}    Create Dictionary    trackingCode=${Wallet_Purchase_TrackingCode}
    ${data_response}    Mongo Db Find
    ...    ${PURCHASE_MNG_DB_MANE}
    ...    ${PURCHASE_MNG_PURCHASE_COLLECTION}
    ...    ${filter_query}
    Should Be Equal As Integers    ${data_response['status_code']}    0
    Should Not Be Empty    ${data_response['body']}
    Should Be Equal As Strings    ${data_response['body'][0]['status']}    CONFIRMED
    Should Be Equal As Strings    ${data_response['body'][0]['paymentChannel']}    UPG

# Web

Success Verify On Wallet Purchase With Web Agent(Gateway)
    [Documentation]    This API Gets Tracking Code Of A Success DPG, And Changes Its Status From "PAID" To "CONFIRMED"
    ${verifyresponse}    POST Purchases Verify
    ...    ${GENERAL_SIDE}
    ...    ${Wallet_Purchase_TrackingCode}
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
    ...    rrn
    Dictionary Should Contain Key
    ...    ${verify_response['body']}
    ...    amount
    Should Be Equal As Strings    ${verify_response['body']['amount']}    ${TEST_AMOUNT}
    Dictionary Should Contain Key
    ...    ${verify_response['body']}
    ...    paymentGateway
    Should Be Equal As Strings    ${verify_response['body']['paymentGateway']}    3

    ${filter_query}    Create Dictionary    trackingCode=${Wallet_Purchase_TrackingCode}
    ${data_response}    Mongo Db Find
    ...    ${PURCHASE_MNG_DB_MANE}
    ...    ${PURCHASE_MNG_PURCHASE_COLLECTION}
    ...    ${filter_query}
    Should Be Equal As Integers    ${data_response['status_code']}    0
    Should Not Be Empty    ${data_response['body']}
    Should Be Equal As Strings    ${data_response['body'][0]['status']}    CONFIRMED
    Should Be Equal As Strings    ${data_response['body'][0]['paymentChannel']}    UPG

Success Verify On Wallet Purchase With Web Agent(Microservice)
    [Documentation]    This API Gets Tracking Code Of A Success DPG, And Changes Its Status From "PAID" To "CONFIRMED"
    ${verifyresponse}    POST Purchases Verify
    ...    ${MICROSERVICE_SIDE}
    ...    ${Wallet_Purchase_TrackingCode}
    ...    ${PLATFORM_UESERNAME}
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
    ...    rrn
    Dictionary Should Contain Key
    ...    ${verify_response['body']}
    ...    amount
    Should Be Equal As Strings    ${verify_response['body']['amount']}    ${TEST_AMOUNT}
    Dictionary Should Contain Key
    ...    ${verify_response['body']}
    ...    paymentGateway
    Should Be Equal As Strings    ${verify_response['body']['paymentGateway']}    3

    ${filter_query}    Create Dictionary    trackingCode=${Wallet_Purchase_TrackingCode}
    ${data_response}    Mongo Db Find
    ...    ${PURCHASE_MNG_DB_MANE}
    ...    ${PURCHASE_MNG_PURCHASE_COLLECTION}
    ...    ${filter_query}
    Should Be Equal As Integers    ${data_response['status_code']}    0
    Should Not Be Empty    ${data_response['body']}
    Should Be Equal As Strings    ${data_response['body'][0]['status']}    CONFIRMED
    Should Be Equal As Strings    ${data_response['body'][0]['paymentChannel']}    UPG

Wallet Purchase With Android Agent On Platform And Verify On Company (Microservice)
    [Documentation]    This Step Gets Tracking Code Of A Success DPG, And Changes Its Status From "PAID" To "CONFIRMED"
    ${verifyresponse}    POST Purchases Verify
    ...    ${MICROSERVICE_SIDE}
    ...    ${Wallet_Purchase_TrackingCode}
    ...    ${COMPANY_USER_ID}
    Should Be Equal As Integers    ${verify_response['status_code']}    422
    Should Be Equal As Integers    ${verify_response['body'].result.status}    9000
    Should Be Equal As Strings    ${verify_response['body'].result.message}    اطلاعات خرید یافت نشد.
    Should Be Equal As Strings    ${verify_response['body'].result.level}    ${WARNING_LEVEL}

Failed Wallet Purchase Verify With Android Agent After More Than 10 Min After Purchase On Platform (Gateway)
    [Documentation]    This Step Gets Tracking Code Of A Success DPG, And Changes Its Status From "PAID" To "CONFIRMED"
    Sleep    11 minutes
    ${verifyresponse}    POST Purchases Verify
    ...    ${GENERAL_SIDE}
    ...    ${Wallet_Purchase_TrackingCode}
    Should Be Equal As Integers    ${verify_response['status_code']}    422
    Should Be Equal As Integers    ${verify_response['body'].result.status}    9009
    Should Be Equal As Strings    ${verify_response['body'].result.message}    محدوده ی زمانی تایید تراکنش گذشته است
    Should Be Equal As Strings    ${verify_response['body'].result.level}    ${WARNING_LEVEL}

Wallet Purchase With Web Agent On Platform And Verify On Company (Microservice)
    [Documentation]    This Step Gets Tracking Code Of A Success DPG, And Changes Its Status From "PAID" To "CONFIRMED"
    ${verifyresponse}    POST Purchases Verify
    ...    ${MICROSERVICE_SIDE}
    ...    ${Wallet_Purchase_TrackingCode}
    ...    ${COMPANY_USER_ID}
    Should Be Equal As Integers    ${verify_response['status_code']}    422
    Should Be Equal As Integers    ${verify_response['body'].result.status}    9000
    Should Be Equal As Strings    ${verify_response['body'].result.message}    اطلاعات خرید یافت نشد.
    Should Be Equal As Strings    ${verify_response['body'].result.level}    ${WARNING_LEVEL}

Failed Wallet Purchase Verify With Web Agent After More Than 10 Min After Purchase On Platform (Gateway)
    [Documentation]    This Step Gets Tracking Code Of A Success DPG, And Changes Its Status From "PAID" To "CONFIRMED"
    Sleep    11 minutes
    ${verifyresponse}    POST Purchases Verify
    ...    ${GENERAL_SIDE}
    ...    ${Wallet_Purchase_TrackingCode}
    Should Be Equal As Integers    ${verify_response['status_code']}    422
    Should Be Equal As Integers    ${verify_response['body'].result.status}    9009
    Should Be Equal As Strings    ${verify_response['body'].result.message}    محدوده ی زمانی تایید تراکنش گذشته است
    Should Be Equal As Strings    ${verify_response['body'].result.level}    ${WARNING_LEVEL}

################################### Auto Reverse Wallet Purchase ########################################

Success Auto Reverse Wallet Purchase When Verify Does Not Called (Gateway)
    [Documentation]    This Step Gets A Tracking Code Of A Verified Purchase And Makes A New Record In "reverse" Collection Of Purchase-mng DB
    ${reverse_status}    Wait Until Keyword Succeeds
    ...    20 minute
    ...    20 s
    ...    Wallet Purchase Auto Reverse Staus Inquiry In Purchase Management

Wallet Purchase Auto Reverse Staus Inquiry In Purchase Management
    [Documentation]    Query On Purchase DB To Inquiry Purchase Status After Auto Reverse
    ${filter_query}    Create Dictionary    trackingCode=${Wallet_Purchase_TrackingCode}
    ${data_response}    Mongo Db Find
    ...    ${PURCHASE_MNG_DB_MANE}
    ...    ${PURCHASE_MNG_PURCHASE_COLLECTION}
    ...    ${filter_query}
    Should Be Equal As Integers    ${data_response['status_code']}    0
    Should Not Be Empty    ${data_response['body']}
    Should Be Equal As Strings    ${data_response['body'][0]['status']}    REVERSED
    Should Be Equal As Strings    ${data_response['body'][0]['paymentChannel']}    UPG
