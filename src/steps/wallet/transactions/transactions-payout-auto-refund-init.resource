*** Settings ***
Library         library/faker_utils.py    WITH NAME    FakerLibrary
Resource        apis/wallet-provider/transactions/post-transactions-spend-pay.resource
Resource        apis/wallet-provider/transactions/post-transactions-spend-verify.resource
Resource        services/backend/user-wallet-initializer-service.resource
Variables       data/wallet/transactions/transactions-payout-auto-refund-variables.yaml


*** Keywords ***
Initialize Businesses, Users And Origina Spend Transactions
    # Create Businesses And Cash-in to a wallet for payout
    ${B_REFUND_WALLET_EXPECTED_AMOUNT}    Set Variable    ${7000}

    ${business_wallet_spend_config}    Create Dictionary
    ...    definition=${B_WALLET_SPEND_DEFINITION}
    ...    wallet_charge_amount=0
    ...    currency=${CURRENCY_IRR}
    ${business_wallet_refund_config}    Create Dictionary
    ...    definition=${B_WALLET_REFUND_DEFINITION}
    ...    wallet_charge_amount=${B_REFUND_WALLET_EXPECTED_AMOUNT}
    ...    currency=${CURRENCY_IRR}
    @{main_business_config}    Create List    ${business_wallet_spend_config}    ${business_wallet_refund_config}
    @{second_business_config}    Create List    ${business_wallet_spend_config}

    ${init_business_obj}    Get Initialized Business With Charged Wallet Based On Configuration
    ...    ${main_business_config}
    ${INIT_BUSINESS_ID}    Set Variable    ${init_business_obj['business_id']}

    ${second_business_obj}    Get Initialized Business With Charged Wallet Based On Configuration
    ...    ${second_business_config}
    ${SECOND_BUSINESS_ID}    Set Variable    ${second_business_obj['business_id']}

    # Create user wallet setup configuration
    ${wallet_charge_amount}    Random Int    100    200
    ${default_wallet_cashoutable_amount}    Evaluate    ${wallet_charge_amount} - 90
    ${expired_wallet}    Create Dictionary
    ...    definition=${WALLET_TIME_BOUND_DEFINITION}
    ...    should_be_expired=${True}
    ...    wallet_charge_amount=${wallet_charge_amount}
    ${unexpired_wallet}    Create Dictionary
    ...    definition=${WALLET_TIME_BOUND_DEFINITION}
    ...    wallet_charge_amount=${wallet_charge_amount}
    ${unexpired_zero_amount_wallet}    Create Dictionary
    ...    definition=${WALLET_TIME_BOUND_DEFINITION}
    ...    wallet_charge_amount=0
    ${default_wallet}    Create Dictionary
    ...    definition=${WALLET_DEFAULT_DEFINITION}
    ...    wallet_charge_amount=${wallet_charge_amount}
    ...    cashoutable_charge_amount=${default_wallet_cashoutable_amount}
    ${default_only_non_cashout_wallet}    Create Dictionary
    ...    definition=${WALLET_DEFAULT_DEFINITION}
    ...    wallet_charge_amount=${wallet_charge_amount}
    ...    cashoutable_charge_amount=0
    ${default_only_cashout_wallet}    Create Dictionary
    ...    definition=${WALLET_DEFAULT_DEFINITION}
    ...    wallet_charge_amount=${wallet_charge_amount}
    ...    cashoutable_charge_amount=${wallet_charge_amount}

    @{multi_type_wallet_setup_list}    Create List
    ...    ${expired_wallet}
    ...    ${unexpired_wallet}
    ...    ${default_wallet}
    @{gift_only_wallet_setup_list}    Create List
    ...    ${expired_wallet}
    ...    ${unexpired_wallet}
    @{default_only_wallet_setup_list}    Create List    ${default_wallet}
    @{expired_gift_only_wallet_setup_list}    Create List    ${expired_wallet}
    @{cashout_only_wallet_setup_list}    Create List    ${default_only_cashout_wallet}
    @{non_cashout_only_wallet_setup_list}    Create List    ${default_only_non_cashout_wallet}

    # Create business list for spend transaction
    @{spend_businesses_list}    Create List
    ${main_business}    Create Dictionary
    ...    businessId=${INIT_BUSINESS_ID}
    ...    walletName=${B_WALLET_SPEND_DEFINITION}
    Append To List    ${spend_businesses_list}    ${main_business}

    @{multi_spend_businesses_list}    Create List
    ${main_business}    Create Dictionary
    ...    businessId=${INIT_BUSINESS_ID}
    ...    walletName=${B_WALLET_SPEND_DEFINITION}
    ${second_business}    Create Dictionary
    ...    businessId=${SECOND_BUSINESS_ID}
    ...    walletName=${B_WALLET_SPEND_DEFINITION}
    Append To List    ${multi_spend_businesses_list}    ${main_business}    ${second_business}

    ## Multi type wallet
    ${MULTI_TYPE_WALLET_USER}    Get Initialized User With Charged Wallet Based On Configuration
    ...    ${USER_CELL_NUMBER_PREFIX}
    ...    ${multi_type_wallet_setup_list}

    ${MULTI_TYPE_WALLET_USER}    Spend Pay And Verify Based On User Total Amount
    ...    ${MULTI_TYPE_WALLET_USER}
    ...    ${spend_businesses_list}

    ## Split spend wallet initializer
    ${SPLIT_SPEND_USER}    Get Initialized User With Charged Wallet Based On Configuration
    ...    ${USER_CELL_NUMBER_PREFIX}
    ...    ${multi_type_wallet_setup_list}

    ${SPLIT_SPEND_USER}    Spend Pay And Verify Based On User Total Amount
    ...    ${SPLIT_SPEND_USER}
    ...    ${multi_spend_businesses_list}

    ## Split spend wallet initializer for legace wallets payout
    ${SPLIT_SPEND_USER_FOR_LEGACE_PAYOUT}    Get Initialized User With Charged Wallet Based On Configuration
    ...    ${USER_CELL_NUMBER_PREFIX}
    ...    ${multi_type_wallet_setup_list}

    ${SPLIT_SPEND_USER_FOR_LEGACE_PAYOUT}    Spend Pay And Verify Based On User Total Amount
    ...    ${SPLIT_SPEND_USER_FOR_LEGACE_PAYOUT}
    ...    ${multi_spend_businesses_list}

    ## Split spend wallet initializer for legace wallets payout wallets
    ${SPLIT_SPEND_USER_FOR_LEGACE_PAYOUT_WALLET}    Get Initialized User With Charged Wallet Based On Configuration
    ...    ${USER_CELL_NUMBER_PREFIX}
    ...    ${multi_type_wallet_setup_list}

    ${SPLIT_SPEND_USER_FOR_LEGACE_PAYOUT_WALLET}    Spend Pay And Verify Based On User Total Amount
    ...    ${SPLIT_SPEND_USER_FOR_LEGACE_PAYOUT_WALLET}
    ...    ${multi_spend_businesses_list}

    ## Gift only wallet initializer
    ${GIFT_ONLY_USER}    Get Initialized User With Charged Wallet Based On Configuration
    ...    ${USER_CELL_NUMBER_PREFIX}
    ...    ${gift_only_wallet_setup_list}

    ${GIFT_ONLY_USER}    Spend Pay And Verify Based On User Total Amount
    ...    ${GIFT_ONLY_USER}
    ...    ${spend_businesses_list}

    ## Cashoutable only user wallet initializer
    ${CASHOUTABLE_ONLY_USER}    Get Initialized User With Charged Wallet Based On Configuration
    ...    ${USER_CELL_NUMBER_PREFIX}
    ...    ${cashout_only_wallet_setup_list}

    ${CASHOUTABLE_ONLY_USER}    Spend Pay And Verify Based On User Total Amount
    ...    ${CASHOUTABLE_ONLY_USER}
    ...    ${spend_businesses_list}

    # Non cashoutable only user wallet initializer
    ${NON_CASHOUTABLE_ONLY_USER}    Get Initialized User With Charged Wallet Based On Configuration
    ...    ${USER_CELL_NUMBER_PREFIX}
    ...    ${non_cashout_only_wallet_setup_list}

    ${NON_CASHOUTABLE_ONLY_USER}    Spend Pay And Verify Based On User Total Amount
    ...    ${NON_CASHOUTABLE_ONLY_USER}
    ...    ${spend_businesses_list}

    # User for refund with diferenet amount of spend
    ${REFUND_WITH_DIFFRENET_SPEND_AMOUNT_USER}    Get Initialized User With Charged Wallet Based On Configuration
    ...    ${USER_CELL_NUMBER_PREFIX}
    ...    ${multi_type_wallet_setup_list}
    ${REFUND_WITH_DIFFRENET_SPEND_AMOUNT_USER}    Spend Pay And Verify Based On User Total Amount
    ...    ${REFUND_WITH_DIFFRENET_SPEND_AMOUNT_USER}
    ...    ${spend_businesses_list}

    ${JUST_EXPIRED_GIFT_USER}    Get Initialized User With Charged Wallet Based On Configuration
    ...    ${USER_CELL_NUMBER_PREFIX}
    ...    ${expired_gift_only_wallet_setup_list}
    ${JUST_EXPIRED_GIFT_USER}    Spend Pay And Verify Based On User Total Amount
    ...    ${JUST_EXPIRED_GIFT_USER}
    ...    ${spend_businesses_list}

    ${WITHOUT_GIFT_USER}    Get Initialized User With Charged Wallet Based On Configuration
    ...    ${USER_CELL_NUMBER_PREFIX}
    ...    ${default_only_wallet_setup_list}
    ${WITHOUT_GIFT_USER}    Spend Pay And Verify Based On User Total Amount
    ...    ${WITHOUT_GIFT_USER}
    ...    ${spend_businesses_list}

    ## Multi type wallet for manual refund
    ${MULTI_TYPE_WALLET_USER_FOR_MANUAL_REFFUND}    Get Initialized User With Charged Wallet Based On Configuration
    ...    ${USER_CELL_NUMBER_PREFIX}
    ...    ${multi_type_wallet_setup_list}

    ## Multi type wallet for manual refund
    ${MULTI_TYPE_WALLET_USER_FOR_MANUAL_REFFUND_AND_LEGACY_PAYOUT}
    ...    Get Initialized User With Charged Wallet Based On Configuration
    ...    ${USER_CELL_NUMBER_PREFIX}
    ...    ${multi_type_wallet_setup_list}

    ## Multi type wallet for manual refund
    ${MULTI_TYPE_WALLET_USER_FOR_MANUAL_REFFUND_AND_LEGACY_PAYOUT_WALLET}
    ...    Get Initialized User With Charged Wallet Based On Configuration
    ...    ${USER_CELL_NUMBER_PREFIX}
    ...    ${multi_type_wallet_setup_list}

    ## Manual Refund for invalid scenarios
    ${MANUAL_REFUND_FOR_INVALID_SCENARIO_USER}    Get Initialized User With Charged Wallet Based On Configuration
    ...    ${USER_CELL_NUMBER_PREFIX}
    ...    ${multi_type_wallet_setup_list}

    ## Multi type wallet for manual refund with sale tracking code
    ${MANUAL_REFUND_WITH_SALE_TRACKING_CODE_USER}    Get Initialized User With Charged Wallet Based On Configuration
    ...    ${USER_CELL_NUMBER_PREFIX}
    ...    ${multi_type_wallet_setup_list}
    ${MANUAL_REFUND_WITH_SALE_TRACKING_CODE_USER}    Spend Pay And Verify Based On User Total Amount
    ...    ${MANUAL_REFUND_WITH_SALE_TRACKING_CODE_USER}
    ...    ${spend_businesses_list}

    Sleep    40s    reason=for ensure from expiring wallets.

    # Get initial business balance after spend for assertion in step section
    ${main_business}    Create Dictionary    id=${INIT_BUSINESS_ID}    wallet_name=${B_WALLET_SPEND_DEFINITION}
    ${second_business}    Create Dictionary    id=${SECOND_BUSINESS_ID}    wallet_name=${B_WALLET_SPEND_DEFINITION}
    ${BUSINESS_LIST_FOR_SPEND}    Create List    ${main_business}    ${second_business}
    ${BUSINESS_LIST_FOR_SPEND}    Get Current Balance Of Business Wallet For Spend    ${BUSINESS_LIST_FOR_SPEND}

    Set Suite Variable    ${MULTI_TYPE_WALLET_USER}
    Set Suite Variable    ${REFUND_WITH_DIFFRENET_SPEND_AMOUNT_USER}
    Set Suite Variable    ${WITHOUT_GIFT_USER}
    Set Suite Variable    ${CASHOUTABLE_ONLY_USER}
    Set Suite Variable    ${NON_CASHOUTABLE_ONLY_USER}
    Set Suite Variable    ${GIFT_ONLY_USER}
    Set Suite Variable    ${JUST_EXPIRED_GIFT_USER}
    Set Suite Variable    ${SPLIT_SPEND_USER}
    Set Suite Variable    ${SPLIT_SPEND_USER_FOR_LEGACE_PAYOUT}
    Set Suite Variable    ${SPLIT_SPEND_USER_FOR_LEGACE_PAYOUT_WALLET}
    Set Suite Variable    ${MULTI_TYPE_WALLET_USER_FOR_MANUAL_REFFUND}
    Set Suite Variable    ${MULTI_TYPE_WALLET_USER_FOR_MANUAL_REFFUND_AND_LEGACY_PAYOUT}
    Set Suite Variable    ${MULTI_TYPE_WALLET_USER_FOR_MANUAL_REFFUND_AND_LEGACY_PAYOUT_WALLET}
    Set Suite Variable    ${MANUAL_REFUND_FOR_INVALID_SCENARIO_USER}
    Set Suite Variable    ${MANUAL_REFUND_WITH_SALE_TRACKING_CODE_USER}
    Set Suite Variable    ${INIT_BUSINESS_ID}
    Set Suite Variable    ${SECOND_BUSINESS_ID}
    Set Suite Variable    ${BUSINESS_LIST_FOR_SPEND}
    Set Suite Variable    ${B_REFUND_WALLET_EXPECTED_AMOUNT}

Spend Pay And Verify Based On User Total Amount
    [Documentation]    Spend pay and Spend Verify and return user object with
    ...    `spend_amount` & `spend_tracking_code` as dictionary.
    [Tags]    robot:private
    [Arguments]
    ...    ${user_object}
    ...    ${spend_business_list}

    ${total_spend_amount}    Evaluate    ${user_object['total_initial_amount']} * 0.9
    ${total_spend_amount}    Convert To Integer    ${total_spend_amount}
    ${spend_business_list}    Update Business List Based On Spend Amount
    ...    ${total_spend_amount}
    ...    ${spend_business_list}

    ${pay_result}    POST Transactions Spend Pay
    ...    ${MICROSERVICE_SIDE}
    ...    ${user_object['user_id']}
    ...    ${spend_business_list}
    ...    ${CURRENCY_IRR}

    Should Be Equal As Integers
    ...    ${pay_result['status_code']}
    ...    200
    ...    msg=Failed to spend pay. result: ${pay_result['body']}

    ${verify_result}    POST Transactions Spend Verify
    ...    ${MICROSERVICE_SIDE}
    ...    ${pay_result['body']['trackingCode']}
    ...    ${pay_result['body']['confirmationCode']}

    Should Be Equal As Integers
    ...    ${verify_result['status_code']}
    ...    200
    ...    msg=Failed to spend verify. result: ${verify_result['body']}

    FOR    ${wallet}    IN    @{user_object['wallets']}
        ${wallet_balance}    GET Wallets Users Balance
        ...    ${MICROSERVICE_SIDE}
        ...    ${user_object['user_id']}
        ...    ${wallet['name']}
        ${spend_amount}    Evaluate    ${wallet['initial_amount']} - ${wallet_balance['body']['balance']}
        Set To Dictionary    ${wallet}    spend_amount=${spend_amount}
    END

    Set To Dictionary
    ...    ${user_object}
    ...    total_spend_amount=${total_spend_amount}
    ...    spend_tracking_code=${pay_result['body']['trackingCode']}

    RETURN    ${user_object}

Update Business List Based On Spend Amount
    [Tags]    robot:private
    [Arguments]    ${spend_amount}    ${spend_busienss_list}

    ${buisness_list_length}    Get Length    ${spend_busienss_list}
    ${counter}    Set Variable    ${1}
    FOR    ${business}    IN    @{spend_busienss_list}
        ${business_spned_amount}    Evaluate    ${spend_amount} / ${buisness_list_length}
        IF    ${counter} == ${buisness_list_length}
            ${business_spned_amount}    Evaluate
            ...    (${spend_amount} / ${buisness_list_length}) + (${spend_amount} % ${buisness_list_length})
        END
        ${business_spned_amount}    Convert To Integer    ${business_spned_amount}
        Set To Dictionary    ${business}    amount=${business_spned_amount}
        ${counter}    Evaluate    ${counter} + 1
    END

    RETURN    ${spend_busienss_list}

Get Current Balance Of Business Wallet For Spend
    [Tags]    robot:private
    [Arguments]    ${business_list}
    FOR    ${business}    IN    @{business_list}
        ${get_balance_result}    GET Wallets Businesses Balance
        ...    ${MICROSERVICE_SIDE}
        ...    ${business['id']}
        ...    ${business['wallet_name']}

        Should Be Equal As Integers
        ...    ${get_balance_result['status_code']}
        ...    200
        ...    msg=Failed to get business balance result: ${get_balance_result['body']}

        Set To Dictionary
        ...    ${business}
        ...    initial_balance=${get_balance_result['body']['balance']}
    END

    RETURN    ${business_list}
