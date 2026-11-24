*** Settings ***
Library         DateTime
Library         RabbitMqHttp
Resource        apis/settlement/post-test-settlements-items-trigger-aggregation.resource
Resource        apis/settlement/post-test-settlements-transactions-trigger-create-transactions.resource
Resource        apis/settlement/post-test-settlements-transactions-trigger-recover-transactions.resource
Resource        apis/settlement/post-admin-settlements-transactions-total.resource
Resource        apis/settlement/post-admin-settlements-calendar-total.resource
Resource        apis/settlement/post_admin_settlements_business_config.resource
Resource        apis/settlement/post-admin-settlements-transactions-search.resource
Resource        apis/wallet-provider/admin/admin-wallets-businesses-id-balance.resource
Resource        apis/settlement/post-admin-settlements-calendar-contracts.resource
Resource        apis/settlement/post-admin-settlements-calendar-merchants.resource
Resource        services/backend/auth-service.resource
Resource        services/db/mongo-db-service.resource
Resource        apis/db/rabbit-mq/get-message-rabbit-mq.resource
Resource        services/backend/user-wallet-initializer-service.resource
Variables       data/settlement/aggregation_and_transfer.yaml


*** Keywords ***
Change Finalized Type 2 Aggregation
    [Arguments]    ${settle_date}    ${status}=${True}

    ${find_query}    Create Dictionary    type=${2}    settleDate=${settle_date}
    ${update_value}    Create Dictionary    finalized=${status}
    ${update_query}    Create Dictionary    $set=${update_value}
    Mongo Db Update One
    ...    db_name=${SETTLEMENT_DB_NAME}
    ...    collection_name=${SETTLEMENT_AGGREGATIONS_COLLECTION}
    ...    filter_query=${find_query}
    ...    update_data=${update_query}

Change Status of Enabled Transactions In Business Config
    [Arguments]    ${business_id}    ${transactions_enabled}=${True}

    ${find_query}    Create Dictionary    businessId=${business_id}
    ${update_value}    Create Dictionary
    ...    transactionEnabled=${transactions_enabled}
    ...    softLaunchDate=2010-10-08T20:30:00.000Z
    ${update_query}    Create Dictionary    $set=${update_value}
    ${query}    Create Dictionary    filter=${find_query}    update=${update_query}
    Mongo Db Update One
    ...    db_name=${SETTLEMENT_DB_NAME}
    ...    collection_name=${SETTLEMENT_BUSINESS_CONFIGS_COLLECTION}
    ...    filter_query=${find_query}
    ...    update_data=${update_query}

Aggregate Settlement items
    Wait Until Keyword Succeeds    5x    5sec    Settlement Item Queue Message Is Zero
    ${post_test_settlements_items_trigger_aggregation}    Post Test Settlements Items Trigger Aggregation
    ...    ${MICROSERVICE_SIDE}
    Should Be Equal As Integers
    ...    ${post_test_settlements_items_trigger_aggregation['status_code']}
    ...    200
    ...    msg='trigger aggregation failed.'

Settlement Item Queue Message Is Zero
    ${settle_item_message_list}    Get Message From Rabbit
    ...    queue_name=${SETTLEMENT_ITEM_QUEUE_NAME}
    ...    message_count=1
    Length Should Be    ${settle_item_message_list}    ${0}    msg=settlement item queue must be empty.

Type 3 assertion
    ${post_admin_settlements_calendar_merchants_for_first_date}    Post Admin Settlements Calendar Merchants
    ...    ${MICROSERVICE_SIDE}
    ...    ${first_settle_date}
    ...    0
    ...    10

    ${contents}    Get From Dictionary
    ...    ${post_admin_settlements_calendar_merchants_for_first_date['body']}
    ...    contents
    IF    ${contents}
        FOR    ${item}    IN    @{contents}
            ${merchant_id}    Get From Dictionary    ${item}    merchantId
            ${total_amount}    Get From Dictionary    ${item}    totalAmount

            IF    '${merchant_id}' == '${BUSINESS_ID_1}'
                Should Be Equal As Integers
                ...    ${total_amount}
                ...    ${TOTAL_AMOUNT_FIRST_DATE_BUSINESS_ID_1_AGGREGATIN_TYPE_3}
                ...    msg="total amount in the first date for business 1 is not equal that I expected.(aggregation type3)"
            END

            IF    '${merchant_id}' == '${BUSINESS_ID_2}'
                Should Be Equal As Integers
                ...    ${total_amount}
                ...    ${TOTAL_AMOUNT_FIRST_DATE_BUSINESS_ID_2_AGGREGATIN_TYPE_3}
                ...    msg="total amount in the first date for business 2 is not equal that I expected.(aggregation type3)"
            END
        END
    END

    ${post_admin_settlements_calendar_merchants_for_second_date}    Post Admin Settlements Calendar Merchants
    ...    ${MICROSERVICE_SIDE}
    ...    ${second_settle_date}
    ...    0
    ...    10

    ${contents}    Get From Dictionary
    ...    ${post_admin_settlements_calendar_merchants_for_second_date['body']}
    ...    contents

    IF    ${contents}
        FOR    ${item}    IN    @{contents}
            ${merchant_id}    Get From Dictionary    ${item}    merchantId
            ${total_amount}    Get From Dictionary    ${item}    totalAmount
            IF    '${merchant_id}' == '${BUSINESS_ID_1}'
                Should Be Equal As Integers
                ...    ${total_amount}
                ...    ${TOTAL_AMOUNT_SECOND_DATE_BUSINESS_ID_1_AGGREGATIN_TYPE_3}
                ...    msg="the total amount in business id 1 in the second date is not equal that i expected."
            END
        END
    END

Type 0 assertion
    ${post_admin_settlements_calendar_contracts_first_date_business_id_1}    Post Admin Settlements Calendar Contracts
    ...    ${MICROSERVICE_SIDE}
    ...    ${BUSINESS_ID_1}
    ...    ${first_settle_date}

    ${contents}    Get From Dictionary
    ...    ${post_admin_settlements_calendar_contracts_first_date_business_id_1['body']}
    ...    contents

    IF    ${contents}
        FOR    ${item}    IN    @{contents}
            ${contract}    Get From Dictionary    ${item}    contract
            ${contract_id}    Get From Dictionary    ${contract}    contractId
            ${total_amount}    Get From Dictionary    ${item}    totalAmount
            IF    '${contract_id}' == '${CONTRACT_ID_1}'
                Should Be Equal As Integers
                ...    ${total_amount}
                ...    ${TOTAL_AMOUNT_FIRST_DATE_BUSINESS_ID_1_CONTRACT_1_AGGREGATIN_TYPE_0}
                ...    msg="the total amount in business id 1 for contract id 2 in the first date is not equal that i expected (aggregation type 0)."
            END
            IF    '${contract_id}' == '${CONTRACT_ID_2}'
                Should Be Equal As Integers
                ...    ${total_amount}
                ...    ${TOTAL_AMOUNT_FIRST_DATE_BUSINESS_ID_1_CONTRACT_2_AGGREGATIN_TYPE_0}
                ...    msg="the total amount in business id 1 for contract id 1 in the first date is not equal that i expected (aggregation type 0)."
            END
        END
    END

    ${post_admin_settlements_calendar_contracts_first_date_business_id_2}    Post Admin Settlements Calendar Contracts
    ...    ${MICROSERVICE_SIDE}
    ...    ${BUSINESS_ID_2}
    ...    ${first_settle_date}

    ${contents}    Get From Dictionary
    ...    ${post_admin_settlements_calendar_contracts_first_date_business_id_2['body']}
    ...    contents

    IF    ${contents}
        FOR    ${item}    IN    @{contents}
            ${contract}    Get From Dictionary    ${item}    contract
            ${contract_id}    Get From Dictionary    ${contract}    contractId
            ${total_amount}    Get From Dictionary    ${item}    totalAmount
            IF    '${contract_id}' == '${CONTRACT_ID_4}'
                Should Be Equal As Integers
                ...    ${total_amount}
                ...    ${TOTAL_AMOUNT_FIRST_DATE_BUSINESS_ID_2_CONTRACT_4_AGGREGATIN_TYPE_0}
                ...    msg="the total amount in business id 2 for contract id 4 in the first date is not equal that i expected (aggregation type 0)."
            END
        END
    END

    ${post_admin_settlements_calendar_contracts_second_date_business_id_1}    Post Admin Settlements Calendar Contracts
    ...    ${MICROSERVICE_SIDE}
    ...    ${BUSINESS_ID_1}
    ...    ${second_settle_date}

    ${contents}    Get From Dictionary
    ...    ${post_admin_settlements_calendar_contracts_second_date_business_id_1['body']}
    ...    contents

    IF    ${contents}
        FOR    ${item}    IN    @{contents}
            ${contract}    Get From Dictionary    ${item}    contract
            ${contract_id}    Get From Dictionary    ${contract}    contractId
            ${total_amount}    Get From Dictionary    ${item}    totalAmount
            IF    '${contract_id}' == '${CONTRACT_ID_3}'
                Should Be Equal As Integers
                ...    ${total_amount}
                ...    ${TOTAL_AMOUNT_SECOND_DATE_BUSINESS_ID_1_CONTRACT_3_AGGREGATIN_TYPE_0}
                ...    msg="the total amount in business id 1 for contract id 3 in the first date is not equal that i expected (aggregation type 0)."
            END
        END
    END

Add Businesses To The Business Config For Transactions
    Post Admin Settlements Business Config
    ...    ${MICROSERVICE_SIDE}
    ...    ${BUSINESS_ID_1}
    ...    ${IBAN}
    ...    ${0}
    ...    09126784567
    Post Admin Settlements Business Config
    ...    ${MICROSERVICE_SIDE}
    ...    ${BUSINESS_ID_2}
    ...    ${IBAN}
    ...    ${0}
    ...    09126784567
    Change Status of Enabled Transactions In Business Config    ${BUSINESS_ID_1}
    Change Status of Enabled Transactions In Business Config    ${BUSINESS_ID_2}

Finalize Type 2 Aggregation
    ${first_settle_date_in_utc}    Subtract Time From Date    ${first_settle_date}    03:30:00
    ${first_settle_date}    Evaluate
    ...    datetime.datetime.strptime('${first_settle_date_in_utc}', '%Y-%m-%d %H:%M:%S.%f')
    ...    modules=datetime

    ${second_settle_date_in_utc}    Subtract Time From Date    ${second_settle_date}    03:30:00
    ${second_settle_date}    Evaluate
    ...    datetime.datetime.strptime('${second_settle_date_in_utc}', '%Y-%m-%d %H:%M:%S.%f')
    ...    modules=datetime
    Change Finalized Type 2 Aggregation    ${first_settle_date}
    Change Finalized Type 2 Aggregation    ${second_settle_date}

Trigger Transactions & Transfer
    Sleep    5s    reason="for create transaction after aggregations".

    ${post_test_settlements_transactions_trigger_create_transactions}
    ...    Post Test Settlements Transactions Trigger Create Transactions
    ...    ${MICROSERVICE_SIDE}
    Should Be Equal As Integers
    ...    ${post_test_settlements_transactions_trigger_create_transactions['status_code']}
    ...    200
    ...    msg='the trigger transactions failed.'

    ${post_test_settlements_transactions_recover_create_transactions}
    ...    Post Test Settlements Transactions Trigger Recover Transactions
    ...    ${MICROSERVICE_SIDE}
    Should Be Equal As Integers
    ...    ${post_test_settlements_transactions_recover_create_transactions['status_code']}
    ...    200
    ...    msg='the trigger recover transaction failed.'

    Sleep    15s    reason="for recover the transactions".

All Expected Transaction Must be Transferred To Platform or Merchant Wallet
    ${spend_wallet_balance_response_for_business_1}    GET Admin Wallets Businesses Id Balance
    ...    ${MICROSERVICE_SIDE}
    ...    ${BUSINESS_ID_1}
    ...    spend
    ${credit_spend_wallet_balance_response_for_business_1}    GET Admin Wallets Businesses Id Balance
    ...    ${MICROSERVICE_SIDE}
    ...    ${BUSINESS_ID_1}
    ...    credit-spend
    ${credit_settlement_wallet_balance_response_for_business_1}    GET Admin Wallets Businesses Id Balance
    ...    ${MICROSERVICE_SIDE}
    ...    ${BUSINESS_ID_1}
    ...    credit-settlement
    ${debit_settlement_wallet_balance_response_for_business_1}    GET Admin Wallets Businesses Id Balance
    ...    ${MICROSERVICE_SIDE}
    ...    ${BUSINESS_ID_1}
    ...    debit-settlement

    Should Be Equal As Integers
    ...    ${spend_wallet_balance_response_for_business_1['body']['balance']}
    ...    ${SPEND_WALLET_CHARGE_AMOUNT_FOR_BUSINESS_1}

    Should Be Equal As Integers
    ...    ${credit_spend_wallet_balance_response_for_business_1['body']['balance']}
    ...    ${CREDIT_SPEND_BALANCE_BUSINESS_ONE}

    Should Be Equal As Integers
    ...    ${credit_settlement_wallet_balance_response_for_business_1['body']['balance']}
    ...    0

    Should Be Equal As Integers
    ...    ${debit_settlement_wallet_balance_response_for_business_1['body']['balance']}
    ...    ${DEBIT_SETTLEMENT_BALANCE_BUSINESS_ONE}

    ${spend_wallet_balance_response_for_business_2}    GET Admin Wallets Businesses Id Balance
    ...    ${MICROSERVICE_SIDE}
    ...    ${BUSINESS_ID_2}
    ...    spend
    ${credit_spend_wallet_balance_response_for_business_2}    GET Admin Wallets Businesses Id Balance
    ...    ${MICROSERVICE_SIDE}
    ...    ${BUSINESS_ID_2}
    ...    credit-spend
    ${credit_settlement_wallet_balance_response_for_business_2}    GET Admin Wallets Businesses Id Balance
    ...    ${MICROSERVICE_SIDE}
    ...    ${BUSINESS_ID_2}
    ...    credit-settlement
    ${debit_settlement_wallet_balance_response_for_business_2}    GET Admin Wallets Businesses Id Balance
    ...    ${MICROSERVICE_SIDE}
    ...    ${BUSINESS_ID_2}
    ...    debit-settlement

    Should Be Equal As Integers
    ...    ${spend_wallet_balance_response_for_business_2['body']['balance']}
    ...    ${SPEND_WALLET_CHARGE_AMOUNT_FOR_BUSINESS_1}

    Should Be Equal As Integers
    ...    ${credit_spend_wallet_balance_response_for_business_2['body']['balance']}
    ...    ${CREDIT_SPEND_BALANCE_BUSINESS_TWO}

    Should Be Equal As Integers
    ...    ${credit_settlement_wallet_balance_response_for_business_2['body']['balance']}
    ...    0

    Should Be Equal As Integers
    ...    ${debit_settlement_wallet_balance_response_for_business_2['body']['balance']}
    ...    ${DEBIT_SETTLEMENT_BALANCE_BUSINESS_TWO}

Collect All Amount , Delete Aggregation, Delete Settlement Item, Transactions, Business Config
    Collect All Amount For Tear Down

    ${first_settled_date_utc}    Subtract Time From Date    ${first_settle_date}    03:30:00
    ${first_settle_date}    Evaluate
    ...    datetime.datetime.strptime('${first_settled_date_utc}', '%Y-%m-%d %H:%M:%S.%f')
    ...    modules=datetime

    ${second_settled_date_utc}    Subtract Time From Date    ${second_settle_date}    03:30:00
    ${second_settle_date}    Evaluate
    ...    datetime.datetime.strptime('${second_settled_date_utc}', '%Y-%m-%d %H:%M:%S.%f')
    ...    modules=datetime

    Delete Settlement Item    ${first_settle_date}
    Delete Settlement Item    ${second_settle_date}

    Delete Aggregation    ${first_settle_date}
    Delete Aggregation    ${second_settle_date}

    Delete Transaction    ${first_settle_date}
    Delete Transaction    ${second_settle_date}

    Delete Business Config    ${BUSINESS_ID_1}
    Delete Business Config    ${BUSINESS_ID_2}

Delete Settlement Item
    [Arguments]    ${settle_date}

    ${query}    Create Dictionary    settleDate=${settle_date}
    Mongo Db Delete One    ${SETTLEMENT_DB_NAME}    ${SETTLEMENT_SETTLEMENT_ITEMS_COLLECTION}    ${query}

Delete Aggregation
    [Arguments]    ${settle_date}

    ${query}    Create Dictionary    settleDate=${settle_date}
    Mongo Db Delete One    ${SETTLEMENT_DB_NAME}    ${SETTLEMENT_AGGREGATIONS_COLLECTION}    ${query}

Delete Transaction
    [Arguments]    ${settle_date}
    ${query}    Create Dictionary    settleDate=${settle_date}
    Mongo Db Delete One    ${SETTLEMENT_DB_NAME}    ${SETTLEMENT_TRANSACTIONS_COLLECTION}    ${query}

Delete Business Config
    [Arguments]    ${business_id}
    ${query}    Create Dictionary    businessId=${business_id}
    Mongo Db Delete One    ${SETTLEMENT_DB_NAME}    ${SETTLEMENT_BUSINESS_CONFIGS_COLLECTION}    ${query}
