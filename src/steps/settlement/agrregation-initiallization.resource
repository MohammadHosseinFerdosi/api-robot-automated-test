*** Settings ***
Library         DateTime
Library         library/faker_utils.py    WITH NAME    FakerLibrary
Resource        services/backend/user-wallet-initializer-service.resource
Resource        apis/settlement/post-admin-settlements-contracts.resource
Resource        apis/db/rabbit-mq/publish-message-rabbit-mq.resource
Resource        apis/settlement/post-admin-settlements-contracts-activate.resource
Resource        apis/settlement/post-admin-settlements-contracts-search.resource
Resource        apis/settlement/post-admin-settlements-calendar-total.resource
Resource        apis/settlement/post-admin-settlements-contracts-sales_approved.resource
Resource        apis/settlement/post-admin-settlements-contracts-finance_approved.resource
Variables       data/settlement/aggregation_and_transfer.yaml


*** Keywords ***
Login To Dashboard as Business Admin
    [Arguments]    ${username}    ${password}
    Login To Dashboard    ${username}    ${password}

Generate Date In MiliSeconds
    [Arguments]    ${days_from_current_time}    ${action}

    ${current_date}    Get Current Date    result_format=%Y-%m-%d %H:%M:%S
    IF    '${action}' == 'subtract'
        ${new_date}    Subtract Time From Date
        ...    ${current_date}
        ...    time=${days_from_current_time} days
        ...    result_format=epoch
    ELSE
        ${new_date}    Add Time To Date    ${current_date}    ${days_from_current_time} days    result_format=epoch
    END

    ${new_date_to_mili_seconds}    Evaluate    int(${new_date} * 1000)
    RETURN    ${new_date_to_mili_seconds}

Initialize Merchant, contracts, settle-items
    ${SPEND_WALLET_CHARGE_AMOUNT_FOR_BUSINESS_1}    Set Variable    25000
    ${CREDIT_SPEND_WALLET_CHARGE_AMOUNT_FOR_BUSINESS_1}    Set Variable    25000

    ${spend_wallet_for_business_1}    Create Dictionary
    ...    definition=${B_WALLET_SPEND_DEFINITION}
    ...    wallet_charge_amount=${SPEND_WALLET_CHARGE_AMOUNT_FOR_BUSINESS_1}
    ...    currency=${CURRENCY_IRR}

    ${credit_spend_wallet_for_business_1}    Create Dictionary
    ...    definition=${B_WALLET_CREDIT_SPEND_DEFINITION}
    ...    wallet_charge_amount=${CREDIT_SPEND_WALLET_CHARGE_AMOUNT_FOR_BUSINESS_1}
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
    ...    ${role_list}
    ...    ${DASHBOARD_ZONE}

    ${BUSINESS_ID_1}    Set Variable    ${INIT_BUSINESS_OBJ_1['business_id']}

    ${INIT_BUSINESS_OBJ_2}    Get Initialized Business With Charged Wallet Based On Configuration
    ...    ${wallet_setup_list_1}
    ...    ${role_list}
    ...    ${DASHBOARD_ZONE}

    ${BUSINESS_ID_2}    Set Variable    ${INIT_BUSINESS_OBJ_2['business_id']}

    # caculate settle date
    ${current_date}    Get Current Date    result_format=timestamp
    ${first_settle_date}    Add Time To Date    ${current_date}    8 days    result_format=%Y-%m-%d
    Set Test Variable    ${first_settle_date}
    ${second_settle_date}    Add Time To Date    ${current_date}    9 days    result_format=%Y-%m-%d
    Set Test Variable    ${second_settle_date}

    ${today_date}    Get Current Date    result_format=%w

    ${day_number}    Evaluate    {'0': 2, '1': 3, '2': 4, '3': 5, '4': 6, '5': 7, '6': 1}[str(${today_date})]

    ${first_period_param_amount}    Evaluate    (${day_number} + 1 - 1) % 7 + 1
    ${second_period_param_amount}    Evaluate    (${day_number} + 2 - 1) % 7 + 1

    ${first_period_params}    Create List
    Append To List    ${first_period_params}    ${first_period_param_amount}

    ${second_period_params}    Create List
    Append To List    ${second_period_params}    ${second_period_param_amount}

    ${CONTRACT_ID_1}    Create Contract
    ...    ${BUSINESS_ID_1}
    ...    ${METHOD_CONTRACT_1}
    ...    ${first_period_params}
    ...    ${BPG_GATEWAY_ID}

    ${CONTRACT_ID_2}    Create Contract
    ...    ${BUSINESS_ID_1}
    ...    ${METHOD_CONTRACT_2}
    ...    ${first_period_params}
    ...    ${CPG_GATEWAY_ID}

    ${CONTRACT_ID_3}    Create Contract
    ...    ${BUSINESS_ID_1}
    ...    ${METHOD_CONTRACT_3}
    ...    ${second_period_params}
    ...    ${ISPG_GATEWAY_ID}

    # create contract for second business
    ${CONTRACT_ID_4}    Create Contract
    ...    ${BUSINESS_ID_2}
    ...    ${METHOD_CONTRACT_1}
    ...    ${first_period_params}
    ...    ${BPG_GATEWAY_ID}

    ${transaction_one_amount}    Set Variable    1000
    ${transaction_one_fee}    Evaluate    ${transaction_one_amount} / ${FEE_PROPERTIES['fixedFeePercent']}
    ${tax_one_fee}    Evaluate    ${transaction_one_fee} / ${TAX_PERCENT}
    ${transaction_two_amount}    Set Variable    1500
    ${transaction_two_fee}    Evaluate    ${transaction_two_amount} / ${FEE_PROPERTIES['fixedFeePercent']}
    ${tax_two_fee}    Evaluate    ${transaction_two_fee} / ${TAX_PERCENT}
    ${transaction_three_amount}    Set Variable    2000
    ${transaction_three_fee}    Evaluate    ${transaction_three_amount} / ${FEE_PROPERTIES['fixedFeePercent']}
    ${tax_three_fee}    Evaluate    ${transaction_three_fee} / ${TAX_PERCENT}
    ${transaction_four_amount}    Set Variable    2500
    ${transaction_four_fee}    Evaluate    ${transaction_four_amount} / ${FEE_PROPERTIES['fixedFeePercent']}
    ${tax_four_fee}    Evaluate    ${transaction_four_fee} / ${TAX_PERCENT}
    ${transaction_five_amount}    Set Variable    3000
    ${transaction_five_fee}    Evaluate    ${transaction_five_amount} / ${FEE_PROPERTIES['fixedFeePercent']}
    ${tax_five_fee}    Evaluate    ${transaction_five_fee} / ${TAX_PERCENT}
    ${transaction_six_amount}    Set Variable    3500
    ${transaction_six_fee}    Evaluate    ${transaction_six_amount} / ${FEE_PROPERTIES['fixedFeePercent']}
    ${tax_six_fee}    Evaluate    ${transaction_six_fee} / ${TAX_PERCENT}
    ${transaction_seven_amount}    Set Variable    4000
    ${transaction_seven_fee}    Evaluate    ${transaction_seven_amount} / ${FEE_PROPERTIES['fixedFeePercent']}
    ${tax_seven_fee}    Evaluate    ${transaction_seven_fee} / ${TAX_PERCENT}
    ${transaction_eight_amount}    Set Variable    4500
    ${transaction_eight_fee}    Evaluate    ${transaction_eight_amount} / ${FEE_PROPERTIES['fixedFeePercent']}
    ${tax_eight_fee}    Evaluate    ${transaction_eight_fee} / ${TAX_PERCENT}
    ${transaction_nine_amount}    Set Variable    5000
    ${transaction_nine_fee}    Evaluate    ${transaction_nine_amount} / ${FEE_PROPERTIES['fixedFeePercent']}
    ${tax_nine_fee}    Evaluate    ${transaction_nine_fee} / ${TAX_PERCENT}
    ${transaction_ten_amount}    Set Variable    5500
    ${transaction_ten_fee}    Evaluate    ${transaction_ten_amount} / ${FEE_PROPERTIES['fixedFeePercent']}
    ${tax_ten_fee}    Evaluate    ${transaction_ten_fee} / ${TAX_PERCENT}

    # type 3 aggregations
    ${TOTAL_AMOUNT_FIRST_DATE_BUSINESS_ID_1_AGGREGATIN_TYPE_3}    Evaluate
    ...    ${transaction_one_amount} + ${transaction_two_amount} + ${transaction_three_amount} + ${transaction_four_amount} + ${transaction_five_amount} + ${transaction_six_amount} + ${transaction_seven_amount} - ${transaction_one_fee} - ${transaction_two_fee} - ${transaction_three_fee} - ${transaction_four_fee} - ${transaction_five_fee} - ${transaction_six_fee} - ${transaction_seven_fee} - ${tax_one_fee} - ${tax_two_fee} - ${tax_three_fee} - ${tax_four_fee} - ${tax_five_fee} - ${tax_six_fee} - ${tax_seven_fee}

    ${TOTAL_AMOUNT_FIRST_DATE_BUSINESS_ID_2_AGGREGATIN_TYPE_3}    Evaluate
    ...    ${transaction_eight_amount} + ${transaction_nine_amount} - ${transaction_eight_fee} - ${transaction_nine_fee} - ${tax_eight_fee} - ${tax_nine_fee}

    ${TOTAL_AMOUNT_SECOND_DATE_BUSINESS_ID_1_AGGREGATIN_TYPE_3}    Evaluate
    ...    ${transaction_ten_amount} - ${transaction_ten_fee} - ${tax_ten_fee}

    # type 0 aggregations

    ${TOTAL_AMOUNT_FIRST_DATE_BUSINESS_ID_1_CONTRACT_2_AGGREGATIN_TYPE_0}    Evaluate
    ...    ${transaction_five_amount} + ${transaction_six_amount} + ${transaction_seven_amount} - ${transaction_five_fee} - ${transaction_six_fee} - ${transaction_seven_fee} - ${tax_five_fee} - ${tax_six_fee} - ${tax_seven_fee}

    ${TOTAL_AMOUNT_FIRST_DATE_BUSINESS_ID_1_CONTRACT_1_AGGREGATIN_TYPE_0}    Evaluate
    ...    ${transaction_one_amount} + ${transaction_two_amount} + ${transaction_three_amount} + ${transaction_four_amount} - ${transaction_one_fee} - ${transaction_two_fee} - ${transaction_three_fee} - ${transaction_four_fee} - ${tax_one_fee} - ${tax_two_fee} - ${tax_three_fee} - ${tax_four_fee}

    ${TOTAL_AMOUNT_FIRST_DATE_BUSINESS_ID_2_CONTRACT_4_AGGREGATIN_TYPE_0}    Evaluate
    ...    ${transaction_eight_amount} + ${transaction_nine_amount} - ${transaction_eight_fee} - ${transaction_nine_fee} - ${tax_eight_fee} - ${tax_nine_fee}

    ${TOTAL_AMOUNT_SECOND_DATE_BUSINESS_ID_1_CONTRACT_3_AGGREGATIN_TYPE_0}    Evaluate
    ...    ${transaction_ten_amount} - ${transaction_ten_fee} - ${tax_ten_fee}

    # check wallet business one
    ${DEBIT_SETTLEMENT_BALANCE_BUSINESS_ONE}    Evaluate
    ...    ${transaction_one_amount} + ${transaction_two_amount} + ${transaction_three_amount} + ${transaction_four_amount} + ${transaction_five_amount} + ${transaction_six_amount} + ${transaction_seven_amount} + ${transaction_ten_amount} - ${transaction_one_fee} - ${transaction_two_fee} - ${transaction_three_fee} - ${transaction_four_fee} - ${transaction_five_fee} - ${transaction_six_fee} - ${transaction_seven_fee} - ${transaction_ten_fee} - ${tax_one_fee} - ${tax_two_fee} - ${tax_three_fee} - ${tax_four_fee} - ${tax_five_fee} - ${tax_six_fee} - ${tax_seven_fee} - ${tax_ten_fee}

    ${CREDIT_SPEND_BALANCE_BUSINESS_ONE}    Evaluate
    ...    ${CREDIT_SPEND_WALLET_CHARGE_AMOUNT_FOR_BUSINESS_1} - ${transaction_one_amount} - ${transaction_two_amount} - ${transaction_three_amount} - ${transaction_four_amount} - ${transaction_five_amount} - ${transaction_six_amount} - ${transaction_seven_amount} - ${transaction_ten_amount}

    # check wallet businesss second

    ${DEBIT_SETTLEMENT_BALANCE_BUSINESS_TWO}    Evaluate
    ...    ${transaction_eight_amount} + ${transaction_nine_amount} - ${transaction_eight_fee} - ${transaction_nine_fee} - ${tax_eight_fee} - ${tax_nine_fee}

    ${CREDIT_SPEND_BALANCE_BUSINESS_TWO}    Evaluate
    ...    ${CREDIT_SPEND_WALLET_CHARGE_AMOUNT_FOR_BUSINESS_1} - ${transaction_eight_amount} - ${transaction_nine_amount}

    # current date in miliseconds

    ${current_date}    Get Current Date    result_format=epoch
    ${current_date_to_mili_seconds}    Evaluate    int(${current_date} * 1000)

    # settlement item 1
    ${transaction}    Create Dictionary
    ...    contractId=${contract_id_1}
    ...    amount=${transaction_one_amount}
    ...    method=${METHOD_CONTRACT_1}
    ...    provider=${SETTLEMENT_ITEM_PROVIDER_ID}

    ${transactions}    Create List    ${transaction}

    Publish Transaction
    ...    merchant_id=${BUSINESS_ID_1}
    ...    tracking_code=si1
    ...    settlement_tracking_code=si1
    ...    channel=${CHANNEL_UPG_CONTRACT}
    ...    transaction_date=${current_date_to_mili_seconds}
    ...    transactions=${transactions}

    # settlement item 2,3
    ${transaction1}    Create Dictionary
    ...    contractId=${contract_id_1}
    ...    amount=${transaction_two_amount}
    ...    fee=${transaction_two_fee}
    ...    method=${METHOD_CONTRACT_1}
    ...    provider=${SETTLEMENT_ITEM_PROVIDER_ID}

    ${transaction2}    Create Dictionary
    ...    contractId=${contract_id_1}
    ...    amount=${transaction_three_amount}
    ...    fee=${transaction_three_fee}
    ...    method=${METHOD_CONTRACT_1}
    ...    provider=${SETTLEMENT_ITEM_PROVIDER_ID}

    ${transactions}    Create List    ${transaction1}    ${transaction2}

    Publish Transaction
    ...    merchant_id=${BUSINESS_ID_1}
    ...    tracking_code=si2-3
    ...    settlement_tracking_code=si2-3
    ...    channel=${CHANNEL_UPG_CONTRACT}
    ...    transaction_date=${current_date_to_mili_seconds}
    ...    transactions=${transactions}

    # settlement item 4
    ${transaction}    Create Dictionary
    ...    contractId=${contract_id_1}
    ...    amount=${transaction_four_amount}
    ...    fee=${transaction_four_fee}
    ...    method=${METHOD_CONTRACT_1}
    ...    provider=${SETTLEMENT_ITEM_PROVIDER_ID}

    ${transactions}    Create List    ${transaction}

    Publish Transaction
    ...    merchant_id=${BUSINESS_ID_1}
    ...    tracking_code=si4
    ...    settlement_tracking_code=si4
    ...    channel=${CHANNEL_UPG_CONTRACT}
    ...    transaction_date=${current_date_to_mili_seconds}
    ...    transactions=${transactions}

    # # settlement item 5
    ${transaction}    Create Dictionary
    ...    contractId=${contract_id_2}
    ...    amount=${transaction_five_amount}
    ...    fee=${transaction_five_fee}
    ...    method=${METHOD_CONTRACT_2}
    ...    provider=${SETTLEMENT_ITEM_PROVIDER_ID}

    ${transactions}    Create List    ${transaction}

    Publish Transaction
    ...    merchant_id=${BUSINESS_ID_1}
    ...    tracking_code=si5
    ...    settlement_tracking_code=si5
    ...    channel=${CHANNEL_UPG_CONTRACT}
    ...    transaction_date=${current_date_to_mili_seconds}
    ...    transactions=${transactions}

    # settlement item 6,7
    ${transaction1}    Create Dictionary
    ...    contractId=${contract_id_2}
    ...    amount=${transaction_six_amount}
    ...    fee=${transaction_six_fee}
    ...    method=${METHOD_CONTRACT_2}
    ...    provider=${SETTLEMENT_ITEM_PROVIDER_ID}

    ${transaction2}    Create Dictionary
    ...    contractId=${contract_id_2}
    ...    amount=${transaction_seven_amount}
    ...    fee=${transaction_seven_fee}
    ...    method=${METHOD_CONTRACT_2}
    ...    provider=${SETTLEMENT_ITEM_PROVIDER_ID}

    ${transactions}    Create List    ${transaction1}    ${transaction2}

    Publish Transaction
    ...    merchant_id=${BUSINESS_ID_1}
    ...    tracking_code=si6-7
    ...    settlement_tracking_code=si6-7
    ...    channel=${CHANNEL_UPG_CONTRACT}
    ...    transaction_date=${current_date_to_mili_seconds}
    ...    transactions=${transactions}

    # settlement item 8,9
    ${transaction1}    Create Dictionary
    ...    contractId=${contract_id_4}
    ...    amount=${transaction_eight_amount}
    ...    fee=${transaction_eight_fee}
    ...    method=${METHOD_CONTRACT_4}
    ...    provider=${SETTLEMENT_ITEM_PROVIDER_ID}

    ${transaction2}    Create Dictionary
    ...    contractId=${contract_id_4}
    ...    amount=${transaction_nine_amount}
    ...    fee=${transaction_nine_fee}
    ...    method=${METHOD_CONTRACT_4}
    ...    provider=${SETTLEMENT_ITEM_PROVIDER_ID}

    ${transactions}    Create List    ${transaction1}    ${transaction2}

    Publish Transaction
    ...    merchant_id=${BUSINESS_ID_2}
    ...    tracking_code=si8-9
    ...    settlement_tracking_code=si8-9
    ...    channel=${CHANNEL_UPG_CONTRACT}
    ...    transaction_date=${current_date_to_mili_seconds}
    ...    transactions=${transactions}

    # settlement item 10
    ${transaction}    Create Dictionary
    ...    contractId=${contract_id_3}
    ...    amount=${transaction_ten_amount}
    ...    fee=${transaction_ten_fee}
    ...    method=${METHOD_CONTRACT_3}
    ...    provider=${SETTLEMENT_ITEM_PROVIDER_ID}

    ${transactions}    Create List    ${transaction}

    Publish Transaction
    ...    merchant_id=${BUSINESS_ID_1}
    ...    tracking_code=si10
    ...    settlement_tracking_code=si10
    ...    channel=${CHANNEL_UPG_CONTRACT}
    ...    transaction_date=${current_date_to_mili_seconds}
    ...    transactions=${transactions}

    # business
    Set Test Variable    ${BUSINESS_ID_1}
    Set Test Variable    ${INIT_BUSINESS_OBJ_1}
    Set Test Variable    ${BUSINESS_ID_2}
    Set Test Variable    ${INIT_BUSINESS_OBJ_2}

    # wallet charge amout
    Set Test Variable    ${SPEND_WALLET_CHARGE_AMOUNT_FOR_BUSINESS_1}
    Set Test Variable    ${CREDIT_SPEND_WALLET_CHARGE_AMOUNT_FOR_BUSINESS_1}

    # contrct ids
    Set Test Variable    ${CONTRACT_ID_1}
    Set Test Variable    ${CONTRACT_ID_2}
    Set Test Variable    ${CONTRACT_ID_3}
    Set Test Variable    ${CONTRACT_ID_4}

    Set Test Variable
    ...    ${TOTAL_AMOUNT_FIRST_DATE_BUSINESS_ID_1_AGGREGATIN_TYPE_3}
    Set Test Variable
    ...    ${TOTAL_AMOUNT_FIRST_DATE_BUSINESS_ID_2_AGGREGATIN_TYPE_3}
    Set Test Variable    ${TOTAL_AMOUNT_SECOND_DATE_BUSINESS_ID_1_AGGREGATIN_TYPE_3}

    Set Test Variable    ${TOTAL_AMOUNT_FIRST_DATE_BUSINESS_ID_1_CONTRACT_1_AGGREGATIN_TYPE_0}
    Set Test Variable    ${TOTAL_AMOUNT_FIRST_DATE_BUSINESS_ID_1_CONTRACT_2_AGGREGATIN_TYPE_0}
    Set Test Variable    ${TOTAL_AMOUNT_FIRST_DATE_BUSINESS_ID_2_CONTRACT_4_AGGREGATIN_TYPE_0}
    Set Test Variable    ${TOTAL_AMOUNT_SECOND_DATE_BUSINESS_ID_1_CONTRACT_3_AGGREGATIN_TYPE_0}

    Set Test Variable    ${DEBIT_SETTLEMENT_BALANCE_BUSINESS_ONE}
    Set Test Variable    ${CREDIT_SPEND_BALANCE_BUSINESS_ONE}
    Set Test Variable    ${DEBIT_SETTLEMENT_BALANCE_BUSINESS_TWO}
    Set Test Variable    ${CREDIT_SPEND_BALANCE_BUSINESS_TWO}

Publish Transaction
    [Arguments]
    ...    ${merchant_id}
    ...    ${tracking_code}
    ...    ${settlement_tracking_code}
    ...    ${channel}
    ...    ${transaction_date}
    ...    ${transactions}

    ${payload}    Create Dictionary
    ...    trackingCode=${tracking_code}
    ...    settlementTrackingCode=${settlement_tracking_code}
    ...    merchantId=${merchant_id}
    ...    channel=${channel}
    ...    transactionDate=${transaction_date}
    ...    transactions=${transactions}

    ${string_json_payload}    Convert JSON To String    ${payload}

    Publish Message To Rabbit
    ...    ${EXCHANGE_NAME}
    ...    ${ROUTING_KEY}
    ...    ${string_json_payload}
    ...    ${TRANSACTIONS_HEADERS}
    ...    ${payload_encoding}

Create Contract
    [Arguments]
    ...    ${buiness_id}
    ...    ${method}
    ...    ${period_params}
    ...    ${gateway}

    ${start_date}    Generate Date In MiliSeconds    ${100}    subtract

    ${end_date}    Generate Date In MiliSeconds    ${100}    add

    ${clauses}    Create List

    ${data}    Create Dictionary
    ...    method=${method}
    ...    settlementDelayDays=2
    ...    periodicType=0
    ...    feeStrategy=0
    ...    periodParams=${period_params}
    ...    feeProperties=${FEE_PROPERTIES}
    ...    thresholdProperty=${THRESHOLD_PROPERTY}

    Append To List    ${clauses}    ${data}

    ${create_contract_response}    Post Admin Settlements Contracts
    ...    ${MICROSERVICE_SIDE}
    ...    ${buiness_id}
    ...    ${start_date}
    ...    ${end_date}
    ...    ${clauses}
    ...    ${gateway}
    ...    ${GUILD_CONTRACT}
    ...    ${CHANNEL_UPG_CONTRACT}
    ...    ${MERCHANT_PANEL_OWNER_GROUP}
    ...    ${USER_ID_CREATE_CONTRACT}

    ${post_admin_settlements_contract_sales_approved}    Post Admin Settlements Contracts Sales Approve
    ...    ${MICROSERVICE_SIDE}
    ...    ${create_contract_response['body']['contractId']}
    ...    ${USER_ID_CREATE_CONTRACT}
    Should Be Equal As Integers
    ...    ${post_admin_settlements_contract_sales_approved['status_code']}
    ...    200
    ...    msg='contract ${create_contract_response['body']['contractId']} activation failed.'

    ${post_admin_settlements_contract_finance_approved}    Post Admin Settlements Contracts Finance Approve
    ...    ${MICROSERVICE_SIDE}
    ...    ${create_contract_response['body']['contractId']}
    ...    ${USER_ID_CREATE_CONTRACT}

    Should Be Equal As Integers
    ...    ${post_admin_settlements_contract_finance_approved['status_code']}
    ...    200
    ...    msg='contract ${create_contract_response['body']['contractId']} activation failed.'

    RETURN    ${create_contract_response['body']['contractId']}
