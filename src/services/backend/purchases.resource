*** Settings ***
Library     Collections
Library     library/faker_utils.py    WITH NAME    FakerLibrary
Resource    services/backend/user-wallet-initializer-service.resource
Resource    apis/tgs/post-tickets-business.resource
Resource    apis/tgs/get-tickets.resource
Resource    apis/tgs/post-tickets-features-select.resource
Resource    apis/tgs/post-admin-tickets-config.resource
Resource    apis/purchase-mng/post-purchases-pay-wallet.resource
Resource    apis/purchase-mng/post-purchases-pay-dpg.resource
Resource    apis/purchase-mng/post-purchases-verify.resource
Resource    apis/purchase-mng/setting/post-purchase-setting.resource
Resource    apis/switch-psp/post-terminal.resource


*** Keywords ***
Create A Verified Wallet purchase With A Fresh User
    [Documentation]    Get A Cell Number Prefix And Get A Fresh User With Wallet, And Pay On Wallet Gateway
    [Arguments]    ${prefix_cellnumber}
    ...    ${amount}
    ...    ${agent}
    ...    ${business_username}
    ...    ${business_password}
# Create A New User With Default Wallet
    ${provider_id}    Generate Random String    15    [LETTERS][NUMBERS]
    ${wallet_config}    Create Dictionary
    ...    definition=${WALLET_DEFAULT_DEFINITION}
    ...    wallet_charge_amount=${amount}
    ...    cashoutable_charge_amount=${amount}
    @{wallet_config_list}    Create List    ${wallet_config}
    ${new_user}    Get Initialized User With Charged Wallet Based On Configuration
    ...    ${prefix_cellnumber}
    ...    ${wallet_config_list}

    ${user_cellnumber}    Set Variable    ${new_user['user_cell_number']}
# Login For Business And Get Ticket
    Login For Business    ${business_username}    ${business_password}
    ${ticket_response}    POST Tickets Business    ${GENERAL_SIDE}
    ...    ${user_cellnumber}
    ...    ${amount}
    ...    ${TEST_CALLBACK_URL}
    ...    ${provider_id}
    ...    ${UPG_TICKET_TYPE}
    ...    ${agent}
    ...    ${PLATFORM_VERSION_2023}
    ${ticket}    Set Variable    ${ticket_response['body']['ticket']}
    ${ticket_info}    Get Tickets    ${GENERAL_SIDE}    ${ticket}    ${PLATFORM_VERSION_2023}
# Select Wallet As Pay Gateway
    ${select_wallet}    Post Tickets Features Select
    ...    ${GENERAL_SIDE}
    ...    ${ticket}
    ...    ${WALLET_FEATURE_NAME}
    ...    ${agent}
    ...    ${PLATFORM_VERSION_2023}
# Call Pay Wallet
    ${wallet_pay}    POST Purchase Pay Wallet
    ...    ${GENERAL_SIDE}
    ...    ${WALLET_DESTINATION_TYPE}
    ...    ${ticket}
    ...    ${PLATFORM_VERSION_2023}
    ${wallet_trackingCode}    Set Variable    ${wallet_pay['body']['trackingCode']}
# Verify Wallet Purchase
    ${verify_response}    POST Purchases Verify    ${GENERAL_SIDE}    ${wallet_trackingCode}
    RETURN    ${wallet_trackingCode}

Create Verified Wallet Purchase For Exsisting User
    [Documentation]    Get a${user_cell_number} and ${amount} then create a wallet purchase and verify. It returns sale tracking code
    [Arguments]    ${user_cell_number}    ${amount}
    # Get purchase ticket
    ${provider_id}    Generate Random String    15    0123456789
    ${ticket_response}    POST Tickets Business    ${GENERAL_SIDE}
    ...    ${user_cell_number}
    ...    ${amount}
    ...    ${TEST_CALLBACK_URL}
    ...    ${provider_id}
    ...    ${UPG_TICKET_TYPE}
    ...    ${WEB_AGENT}
    ...    ${PLATFORM_VERSION_2023}
    ${ticket}    Set Variable    ${ticket_response['body']['ticket']}
    ${ticket_info}    Get Tickets    ${GENERAL_SIDE}    ${ticket}    ${PLATFORM_VERSION_2023}
    # Select Wallet As Pay Gateway
    ${select_wallet}    Post Tickets Features Select
    ...    ${GENERAL_SIDE}
    ...    ${ticket}
    ...    ${WALLET_FEATURE_NAME}
    ...    ${WEB_AGENT}
    ...    ${PLATFORM_VERSION_2023}
    # Call Pay Wallet
    ${wallet_pay}    POST Purchase Pay Wallet
    ...    ${MICROSERVICE_SIDE}
    ...    ${WALLET_DESTINATION_TYPE}
    ...    ${ticket}
    ...    ${PLATFORM_VERSION_2023}
    ${wallet_trackingCode}    Set Variable    ${wallet_pay['body']['trackingCode']}
    # Verify Wallet Purchase
    ${verify_response}    POST Purchases Verify    ${GENERAL_SIDE}    ${wallet_trackingCode}
    RETURN    ${verify_response['body']['trackingCode']}

Create A Verified DPG purchase With A Fresh User
    [Documentation]    Get A Cell Number Prefix And Get A Fresh User, Then Pay On DPG Gateway
    [Arguments]    ${prefix_cellnumber}
    ...    ${amount}
    ...    ${business_username}
    ...    ${business_password}
# Create A New User
    ${provider_id}    Generate Random String    15    [LETTERS][NUMBERS]
    ${new_user}    Get A Fresh User
    ...    ${prefix_cellnumber}

    ${user_cellnumber}    Set Variable    ${new_user['user_cell_number']}
# Login For Business And Get Ticket
    Login For Business    ${business_username}    ${business_password}
    ${ticket_response}    POST Tickets Business    ${GENERAL_SIDE}
    ...    ${user_cellnumber}
    ...    ${amount}
    ...    ${TEST_CALLBACK_URL}
    ...    ${provider_id}
    ...    ${UPG_TICKET_TYPE}
    ...    ANDROID
    ...    ${PLATFORM_VERSION_2023}
    ${ticket}    Set Variable    ${ticket_response['body']['ticket']}
    ${ticket_info}    Get Tickets    ${GENERAL_SIDE}    ${ticket}    ${PLATFORM_VERSION_2023}
# Select Wallet As Pay Gateway
    ${select_DPG}    Post Tickets Features Select
    ...    ${GENERAL_SIDE}
    ...    ${ticket}
    ...    ${DPG_FEATURE_NAME}
    ...    ANDROID
    ...    ${PLATFORM_VERSION_2023}
# Call Pay DPG
    ${DPG_purchase}    POST Purchase Pay DPG
    ...    ${GENERAL_SIDE}
    ...    ${DPG_DESTINATION_TYPE}
    ...    ${ticket}
    ...    1
    ...    ${PAYMENT_TEST_CARD_VALUE}
    ...    ${PAYMENT_TEST_CARD_EXPIREDATE}
    ...    ${PAYMENT_TEST_CARD_PREFIX}
    ...    ${PAYMENT_TEST_CARD_PREFIX}
    ...    ${PAYMENT_TEST_CARD_PIN}
    ...    ${MELLAT_CERT_FILE}
    ...    ANDROID
    ...    ${PLATFORM_VERSION_2023}
    ${dpg_purchase_trackingCode}    Set Variable    ${DPG_purchase['body']['trackingCode']}
# Verify DPG Purchase
    ${verify_response}    POST Purchases Verify    ${GENERAL_SIDE}    ${dpg_purchase_trackingCode}
    RETURN    ${dpg_purchase_trackingCode}

Create Business Purchase And Ticket Setting For Purchase And Refund
    [Documentation]    Creates purchase and ticket settings for a business, enabling specified gateways
    ...    and configuring transaction types, ticket TTL, and feature priorities for purchase and refund handling
    ...    gateway exp. is '3' for creating a wallet purchase
    [Arguments]    ${business_id}    @{active_gateways}
    @{transaction_types}    Create List    ${CREDIT_PURCHASE_TRANSACTION_TYPE}    ${PURCHASE_TRANSACTION_TYPE}
    ${ttl}    Set Variable    ${Ticket_TTL}
    ${type}    Set Variable    ${UPG_TICKET_TYPE}
    &{feature_orders}    Create Dictionary
    ...    ${WALLET_FEATURE_NAME}=${1}
    ...    ${DPG_FEATURE_NAME}=${3}
    ...    ${IPG_FEATURE_NAME}=${5}
    ...    ${CPG_FEATURE_NAME}=${4}
    ...    ${BPG_FEATURE_NAME}=${2}
    ...    ${IPG_CASHIN_FEATURE_NAME}=${1}
    ...    ${DPG_CASHIN_FEATURE_NAME}=${1}
    ...    ${CREDIT_ACTIVATION_NAME}=${6}

    ${purchase_response}    Post admin Purchase setting    ${MICROSERVICE_SIDE}    ${business_id}    @{active_gateways}
    Should Be Equal As Integers
    ...    ${purchase_response['status_code']}
    ...    200
    ...    msg=Failed to create purchase setting. result: ${purchase_response['body']}
    ${ticket_response}    Post admin ticket config
    ...    @{transaction_types}
    ...    api_call_side=${MICROSERVICE_SIDE}
    ...    business_id=${business_id}
    ...    landing_url=${TICKET_LANDING_URL}
    ...    ttl=${ttl}
    ...    type=${type}
    ...    feature_orders=${feature_orders}
    Should Be Equal As Integers
    ...    ${ticket_response['status_code']}
    ...    200
    ...    msg=Failed to create purchase setting. result: ${ticket_response['body']}
