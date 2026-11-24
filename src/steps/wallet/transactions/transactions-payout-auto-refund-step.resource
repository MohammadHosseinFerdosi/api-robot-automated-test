*** Settings ***
Library         library/faker_utils.py    WITH NAME    FakerLibrary
Library         library/rounding.py
Resource        services/backend/auth-service.resource
Resource        apis/wallet-provider/transactions/post-transactions-payout.resource
Resource        apis/wallet-provider/transactions/get-transactions-payout.resource
Resource        apis/wallet-provider/transactions-legacy/post-wallets-payout.resource
Resource        apis/wallet-provider/transactions-legacy/post-wallets-payout-wallet.resource
Resource        apis/wallet-provider/transactions-legacy/get-wallets-payout-inquiry.resource
Resource        apis/wallet-provider/wallets/get-wallets-users-balance.resource
Resource        apis/wallet-provider/wallets/get-wallets-businesses-balance.resource
Variables       data/wallet/transactions/transactions-payout-auto-refund-variables.yaml


*** Keywords ***
Payout To User With Valid Original Sale Tracking Code And Expired Gift Card
    ${description}    Set Variable    Test payout for ${TEST_NAME}
    ${result}    POST Transactions Payout
    ...    ${MICROSERVICE_SIDE}
    ...    amount=${MULTI_TYPE_WALLET_USER['total_spend_amount']}
    ...    source_business_id=${INIT_BUSINESS_ID}
    ...    source_business_wallet_name=${B_WALLET_REFUND_DEFINITION}
    ...    destination_user_id=${MULTI_TYPE_WALLET_USER['user_id']}
    ...    sale_tracking_code=${MULTI_TYPE_WALLET_USER['spend_tracking_code']}
    ...    description=${description}

    Should Be Equal As Integers
    ...    ${result['status_code']}
    ...    200
    ...    msg=Failed to payout. result: ${result['body']}

    ${CURRENT_USER}    Set Variable    ${MULTI_TYPE_WALLET_USER}
    Update Business Expected Balance After Payout    ${CURRENT_USER['total_spend_amount']}
    Set To Dictionary    ${CURRENT_USER}    payout_tracking_code=${result['body']['trackingCode']}
    Set Test Variable    ${CURRENT_USER}

Payout To User With Valid Multi Spend Original Sale Tracking Code And Multi Expired Gift Card
    ${description}    Set Variable    Test payout for ${TEST NAME}
    ${result}    POST Transactions Payout
    ...    ${MICROSERVICE_SIDE}
    ...    amount=${SPLIT_SPEND_USER['total_spend_amount']}
    ...    source_business_id=${INIT_BUSINESS_ID}
    ...    source_business_wallet_name=${B_WALLET_REFUND_DEFINITION}
    ...    destination_user_id=${SPLIT_SPEND_USER['user_id']}
    ...    sale_tracking_code=${SPLIT_SPEND_USER['spend_tracking_code']}
    ...    description=${description}

    Should Be Equal As Integers
    ...    ${result['status_code']}
    ...    200
    ...    msg=Failed to payout. result: ${result['body']}

    ${CURRENT_USER}    Set Variable    ${SPLIT_SPEND_USER}
    Update Business Expected Balance After Payout    ${CURRENT_USER['total_spend_amount']}
    Set Test Variable    ${CURRENT_USER}

Legacy Payout To User With Valid Multi Spend Original Sale Tracking Code And Multi Expired Gift Card
    ${description}    Set Variable    Test payout for ${TEST NAME}
    # transaction_agenda for refund wallet should be 12
    ${result}    POST Wallets Payout
    ...    ${MICROSERVICE_SIDE}
    ...    amount=${SPLIT_SPEND_USER_FOR_LEGACE_PAYOUT['total_spend_amount']}
    ...    source_business_id=${INIT_BUSINESS_ID}
    ...    transaction_agenda=12
    ...    destination_user_id=${SPLIT_SPEND_USER_FOR_LEGACE_PAYOUT['user_id']}
    ...    sale_tracking_code=${SPLIT_SPEND_USER_FOR_LEGACE_PAYOUT['spend_tracking_code']}
    ...    description=${description}

    Should Be Equal As Integers
    ...    ${result['status_code']}
    ...    200
    ...    msg=Failed to payout. result: ${result['body']}

    ${CURRENT_USER}    Set Variable    ${SPLIT_SPEND_USER_FOR_LEGACE_PAYOUT}
    Update Business Expected Balance After Payout    ${CURRENT_USER['total_spend_amount']}
    Set To Dictionary    ${CURRENT_USER}    payout_tracking_code=${result['body']['trackingCode']}
    Set Test Variable    ${CURRENT_USER}

Legacy Payout Wallet To User With Valid Multi Spend Original Sale Tracking Code And Multi Expired Gift Card
    ${description}    Set Variable    Test payout for ${TEST NAME}
    # transaction_agenda for refund wallet should be 12
    ${result}    POST Wallets Payout Wallet
    ...    ${MICROSERVICE_SIDE}
    ...    amount=${SPLIT_SPEND_USER_FOR_LEGACE_PAYOUT_WALLET['total_spend_amount']}
    ...    source_business_id=${INIT_BUSINESS_ID}
    ...    transaction_agenda=12
    ...    destination_user_id=${SPLIT_SPEND_USER_FOR_LEGACE_PAYOUT_WALLET['user_id']}
    ...    sale_tracking_code=${SPLIT_SPEND_USER_FOR_LEGACE_PAYOUT_WALLET['spend_tracking_code']}
    ...    description=${description}

    Should Be Equal As Integers
    ...    ${result['status_code']}
    ...    200
    ...    msg=Failed to payout. result: ${result['body']}

    ${CURRENT_USER}    Set Variable    ${SPLIT_SPEND_USER_FOR_LEGACE_PAYOUT_WALLET}
    Update Business Expected Balance After Payout    ${CURRENT_USER['total_spend_amount']}
    Set Test Variable    ${CURRENT_USER}

Payout To Gift Only User With Valid Original Spend And Expired Gift
    ${description}    Set Variable    Test payout for ${TEST NAME}
    ${result}    POST Transactions Payout
    ...    ${MICROSERVICE_SIDE}
    ...    amount=${GIFT_ONLY_USER['total_spend_amount']}
    ...    source_business_id=${INIT_BUSINESS_ID}
    ...    source_business_wallet_name=${B_WALLET_REFUND_DEFINITION}
    ...    destination_user_id=${GIFT_ONLY_USER['user_id']}
    ...    sale_tracking_code=${GIFT_ONLY_USER['spend_tracking_code']}
    ...    description=${description}

    Should Be Equal As Integers
    ...    ${result['status_code']}
    ...    200
    ...    msg=Failed to payout. result: ${result['body']}

    ${CURRENT_USER}    Set Variable    ${GIFT_ONLY_USER}
    Update Business Expected Balance After Payout    ${CURRENT_USER['total_spend_amount']}
    Set Test Variable    ${CURRENT_USER}

Payout To Cashoutable Only User With Walid Orginal Spend And Expired Gift
    ${description}    Set Variable    Test payout for ${TEST NAME}
    ${result}    POST Transactions Payout
    ...    ${MICROSERVICE_SIDE}
    ...    amount=${CASHOUTABLE_ONLY_USER['total_spend_amount']}
    ...    source_business_id=${INIT_BUSINESS_ID}
    ...    source_business_wallet_name=${B_WALLET_REFUND_DEFINITION}
    ...    destination_user_id=${CASHOUTABLE_ONLY_USER['user_id']}
    ...    sale_tracking_code=${CASHOUTABLE_ONLY_USER['spend_tracking_code']}
    ...    description=${description}

    Should Be Equal As Integers
    ...    ${result['status_code']}
    ...    200
    ...    msg=Failed to payout. result: ${result['body']}

    ${CURRENT_USER}    Set Variable    ${CASHOUTABLE_ONLY_USER}
    Update Business Expected Balance After Payout    ${CURRENT_USER['total_spend_amount']}
    Set Test Variable    ${CURRENT_USER}

Payout To Non-Cashoutable Only User With Walid Orginal Spend And Expired Gift
    ${description}    Set Variable    Test payout for ${TEST NAME}
    ${result}    POST Transactions Payout
    ...    ${MICROSERVICE_SIDE}
    ...    amount=${NON_CASHOUTABLE_ONLY_USER['total_spend_amount']}
    ...    source_business_id=${INIT_BUSINESS_ID}
    ...    source_business_wallet_name=${B_WALLET_REFUND_DEFINITION}
    ...    destination_user_id=${NON_CASHOUTABLE_ONLY_USER['user_id']}
    ...    sale_tracking_code=${NON_CASHOUTABLE_ONLY_USER['spend_tracking_code']}
    ...    description=${description}

    Should Be Equal As Integers
    ...    ${result['status_code']}
    ...    200
    ...    msg=Failed to payout. result: ${result['body']}

    ${CURRENT_USER}    Set Variable    ${NON_CASHOUTABLE_ONLY_USER}
    Update Business Expected Balance After Payout    ${CURRENT_USER['total_spend_amount']}
    Set Test Variable    ${CURRENT_USER}

Payout To User With Valid Orginal Spend And Expired Gift And Percentage Of Spend Amount
    ${description}    Set Variable    Test payout for ${TEST NAME}
    ${refund_amount}    Evaluate    ${REFUND_WITH_DIFFRENET_SPEND_AMOUNT_USER['total_spend_amount']} * 0.6
    ${refund_amount}    Convert To Integer    ${refund_amount}
    ${refund_percentage}    Evaluate
    ...    ${refund_amount} / ${REFUND_WITH_DIFFRENET_SPEND_AMOUNT_USER['total_spend_amount']}
    ${result}    POST Transactions Payout
    ...    ${MICROSERVICE_SIDE}
    ...    amount=${refund_amount}
    ...    source_business_id=${INIT_BUSINESS_ID}
    ...    source_business_wallet_name=${B_WALLET_REFUND_DEFINITION}
    ...    destination_user_id=${REFUND_WITH_DIFFRENET_SPEND_AMOUNT_USER['user_id']}
    ...    sale_tracking_code=${REFUND_WITH_DIFFRENET_SPEND_AMOUNT_USER['spend_tracking_code']}
    ...    description=${description}

    Should Be Equal As Integers
    ...    ${result['status_code']}
    ...    200
    ...    msg=Failed to payout. result: ${result['body']}

    ${CURRENT_USER}    Set Variable    ${REFUND_WITH_DIFFRENET_SPEND_AMOUNT_USER}
    Update Business Expected Balance After Payout    ${refund_amount}
    Set Test Variable    ${CURRENT_USER}
    Set Test Variable    ${REFUND_AMOUNT}
    Set Test Variable    ${REFUND_PERCENTAGE}

Payout To User With Valid Orginal Spend And Just Expired Gift
    ${description}    Set Variable    Test payout for ${TEST NAME}
    ${result}    POST Transactions Payout
    ...    ${MICROSERVICE_SIDE}
    ...    amount=${JUST_EXPIRED_GIFT_USER['total_spend_amount']}
    ...    source_business_id=${INIT_BUSINESS_ID}
    ...    source_business_wallet_name=${B_WALLET_REFUND_DEFINITION}
    ...    destination_user_id=${JUST_EXPIRED_GIFT_USER['user_id']}
    ...    sale_tracking_code=${JUST_EXPIRED_GIFT_USER['spend_tracking_code']}
    ...    description=${description}

    Should Be Equal As Integers
    ...    ${result['status_code']}
    ...    200
    ...    msg=Failed to payout. result: ${result['body']}

    ${CURRENT_USER}    Set Variable    ${JUST_EXPIRED_GIFT_USER}
    Update Business Expected Balance After Payout    ${CURRENT_USER['total_spend_amount']}
    Set Test Variable    ${CURRENT_USER}

Payout To User With Valid Orginal Spend And Without Gift Wallet
    ${description}    Set Variable    Test payout for ${TEST NAME}
    ${result}    POST Transactions Payout
    ...    ${MICROSERVICE_SIDE}
    ...    amount=${WITHOUT_GIFT_USER['total_spend_amount']}
    ...    source_business_id=${INIT_BUSINESS_ID}
    ...    source_business_wallet_name=${B_WALLET_REFUND_DEFINITION}
    ...    destination_user_id=${WITHOUT_GIFT_USER['user_id']}
    ...    sale_tracking_code=${WITHOUT_GIFT_USER['spend_tracking_code']}
    ...    description=${description}

    Should Be Equal As Integers
    ...    ${result['status_code']}
    ...    200
    ...    msg=Failed to payout. result: ${result['body']}

    ${CURRENT_USER}    Set Variable    ${WITHOUT_GIFT_USER}
    Update Business Expected Balance After Payout    ${CURRENT_USER['total_spend_amount']}
    Set Test Variable    ${CURRENT_USER}

Manual Refund To User With Cashoutable Parameter
    ${description}    Set Variable    Test payout for ${TEST NAME}
    ${refund_amount}    Random Int    100    150
    ${refund_cashoutable_amount}    Random Int    50    90
    ${result}    POST Transactions Payout
    ...    ${MICROSERVICE_SIDE}
    ...    amount=${refund_amount}
    ...    source_business_id=${INIT_BUSINESS_ID}
    ...    source_business_wallet_name=${B_WALLET_REFUND_DEFINITION}
    ...    cashoutable_amount=${refund_cashoutable_amount}
    ...    destination_user_id=${MULTI_TYPE_WALLET_USER_FOR_MANUAL_REFFUND['user_id']}
    ...    description=${description}

    Should Be Equal As Integers
    ...    ${result['status_code']}
    ...    200
    ...    msg=Failed to payout. result: ${result['body']}

    ${CURRENT_USER}    Set Variable    ${MULTI_TYPE_WALLET_USER_FOR_MANUAL_REFFUND}
    Update Business Expected Balance After Payout    ${refund_amount}
    Set To Dictionary
    ...    ${CURRENT_USER}
    ...    refund_amount=${refund_amount}
    ...    refund_cashoutable_amount=${refund_cashoutable_amount}
    Set Test Variable    ${CURRENT_USER}

Legacy Manual Refund To User With Cashoutable Parameter
    ${description}    Set Variable    Test payout for ${TEST NAME}
    ${refund_amount}    Random Int    100    150
    ${refund_cashoutable_amount}    Random Int    50    90
    # Transaction agenda for business refund wallet is 12
    ${result}    POST Wallets Payout
    ...    ${MICROSERVICE_SIDE}
    ...    amount=${refund_amount}
    ...    source_business_id=${INIT_BUSINESS_ID}
    ...    transaction_agenda=12
    ...    cashoutable_amount=${refund_cashoutable_amount}
    ...    destination_user_id=${MULTI_TYPE_WALLET_USER_FOR_MANUAL_REFFUND_AND_LEGACY_PAYOUT['user_id']}
    ...    description=${description}

    Should Be Equal As Integers
    ...    ${result['status_code']}
    ...    200
    ...    msg=Failed to payout. result: ${result['body']}

    ${CURRENT_USER}    Set Variable    ${MULTI_TYPE_WALLET_USER_FOR_MANUAL_REFFUND_AND_LEGACY_PAYOUT}
    Update Business Expected Balance After Payout    ${refund_amount}
    Set To Dictionary
    ...    ${CURRENT_USER}
    ...    refund_amount=${refund_amount}
    ...    refund_cashoutable_amount=${refund_cashoutable_amount}
    Set Test Variable    ${CURRENT_USER}

Legacy Payout Wallet Manual Refund To User With Cashoutable Parameter
    ${description}    Set Variable    Test payout for ${TEST NAME}
    ${refund_amount}    Random Int    100    150
    ${refund_cashoutable_amount}    Random Int    50    90
    # Transaction agenda for business refund wallet is 12
    ${result}    POST Wallets Payout Wallet
    ...    ${MICROSERVICE_SIDE}
    ...    amount=${refund_amount}
    ...    source_business_id=${INIT_BUSINESS_ID}
    ...    transaction_agenda=12
    ...    cashoutable_amount=${refund_cashoutable_amount}
    ...    destination_user_id=${MULTI_TYPE_WALLET_USER_FOR_MANUAL_REFFUND_AND_LEGACY_PAYOUT_WALLET['user_id']}
    ...    description=${description}

    Should Be Equal As Integers
    ...    ${result['status_code']}
    ...    200
    ...    msg=Failed to payout. result: ${result['body']}

    ${CURRENT_USER}    Set Variable    ${MULTI_TYPE_WALLET_USER_FOR_MANUAL_REFFUND_AND_LEGACY_PAYOUT_WALLET}
    Update Business Expected Balance After Payout    ${refund_amount}
    Set To Dictionary
    ...    ${CURRENT_USER}
    ...    refund_amount=${refund_amount}
    ...    refund_cashoutable_amount=${refund_cashoutable_amount}
    Set Test Variable    ${CURRENT_USER}

Manual Refund To User With Cashoutable Parameter And Valid Spend Tracking Code
    ${description}    Set Variable    Test payout for ${TEST NAME}
    ${refund_amount}    Random Int    100    150
    ${refund_cashoutable_amount}    Random Int    50    90
    ${result}    POST Transactions Payout
    ...    ${MICROSERVICE_SIDE}
    ...    amount=${refund_amount}
    ...    source_business_id=${INIT_BUSINESS_ID}
    ...    source_business_wallet_name=${B_WALLET_REFUND_DEFINITION}
    ...    destination_user_id=${MANUAL_REFUND_WITH_SALE_TRACKING_CODE_USER['user_id']}
    ...    cashoutable_amount=${refund_cashoutable_amount}
    ...    sale_tracking_code=${MANUAL_REFUND_WITH_SALE_TRACKING_CODE_USER['spend_tracking_code']}
    ...    description=${description}

    Should Be Equal As Integers
    ...    ${result['status_code']}
    ...    200
    ...    msg=Failed to payout. result: ${result['body']}

    ${CURRENT_USER}    Set Variable    ${MANUAL_REFUND_WITH_SALE_TRACKING_CODE_USER}
    Update Business Expected Balance After Payout    ${refund_amount}
    Set To Dictionary
    ...    ${CURRENT_USER}
    ...    refund_amount=${refund_amount}
    ...    refund_cashoutable_amount=${refund_cashoutable_amount}
    Set Test Variable    ${CURRENT_USER}

Refund To Expired Gift
    ${description}    Set Variable    Test payout for ${TEST NAME}
    ${refund_amount}    Random Int    100    150
    ${refund_cashoutable_amount}    Random Int    50    90

    # Find expired wallet name
    FOR    ${wallet}    IN    @{MANUAL_REFUND_FOR_INVALID_SCENARIO_USER['wallets']}
        IF    'expired' in ${wallet}
            ${destination_user_wallet_for_refund}    Set Variable    ${wallet['name']}
        END
    END

    ${result}    POST Transactions Payout
    ...    ${MICROSERVICE_SIDE}
    ...    amount=${refund_amount}
    ...    source_business_id=${INIT_BUSINESS_ID}
    ...    source_business_wallet_name=${B_WALLET_REFUND_DEFINITION}
    ...    cashoutable_amount=${refund_cashoutable_amount}
    ...    destination_user_id=${MANUAL_REFUND_FOR_INVALID_SCENARIO_USER['user_id']}
    ...    destination_user_wallet_name=${destination_user_wallet_for_refund}
    ...    description=${description}

    ${PAYOUT_RESULT}    Set Variable    ${result}
    ${CURRENT_USER}    Set Variable    ${MANUAL_REFUND_FOR_INVALID_SCENARIO_USER}
    Set Test Variable    ${CURRENT_USER}
    Set Test Variable    ${PAYOUT_RESULT}

Refund To Unexpired Expired Gift With Cashoutable Amount
    Refund To Expired Gift

Expired Gift Spend Amount Should Be Transferred To Default Non-Cashoutable Wallet
    [Arguments]    ${refund_percentage_arg}=${0}
    ${total_expired_gift_refund_amount}    Set Variable    ${0}
    ${non_cashoutable_initial_balance}    Set Variable    ${0}

    FOR    ${wallet}    IN    @{CURRENT_USER['wallets']}
        IF    'expired' in ${wallet}
            ${wallet_balance}    GET Wallets Users Balance
            ...    ${MICROSERVICE_SIDE}
            ...    ${CURRENT_USER['user_id']}
            ...    ${wallet['name']}

            ${expired_wallet_remaining_amount_after_spend}    Evaluate
            ...    ${wallet['initial_amount']} - ${wallet['spend_amount']}
            # Expired wallet should be zero
            Should Be Equal As Integers
            ...    ${wallet_balance['body']['balance']}
            ...    ${expired_wallet_remaining_amount_after_spend}
            ...    msg=Balance for expire wallet: ${wallet['name']}, should be ${expired_wallet_remaining_amount_after_spend} but found ${wallet_balance['body']['balance']}.

            # Calculate refund amount for this wallet based on refund percentage
            IF    ${refund_percentage_arg} != ${0}
                ${expected_refund_amount}    Evaluate    ${wallet['initial_amount']} * ${refund_percentage_arg}
                ${expected_refund_amount}    Round Half Up    ${expected_refund_amount}
            ELSE
                ${expected_refund_amount}    Evaluate
                ...    ${wallet['initial_amount']} - ${expired_wallet_remaining_amount_after_spend}
            END

            ${total_expired_gift_refund_amount}    Evaluate
            ...    ${total_expired_gift_refund_amount} + ${expected_refund_amount}
        END

        # Get default cashoutable & non cashoutable initial balance
        IF    '${wallet['type']}' == '${WALLET_DEFAULT_DEFINITION}'
            ${non_cashoutable_initial_balance}    Evaluate
            ...    ${wallet['initial_amount']} - ${wallet['cashoutable_amount']}
        END
    END

    # Calculate non_cashout expected balance based on refund percentage
    IF    ${refund_percentage_arg} != ${0}
        ${non_cashoutable_remaining_amount_after_spend}    Evaluate
        ...    ${CURRENT_USER['total_initial_amount']} - ${CURRENT_USER['total_spend_amount']}

        ${non_cashoutable_spend_amount}    Evaluate
        ...    ${non_cashoutable_initial_balance} - ${non_cashoutable_remaining_amount_after_spend}

        ${non_cashoutable_refund_amount}    Evaluate    ${non_cashoutable_spend_amount} * ${refund_percentage_arg}
        ${non_cashoutable_refund_amount}    Round Half Up    ${non_cashoutable_refund_amount}

        ${expected_non_cashout_balance}    Evaluate
        ...    ${non_cashoutable_remaining_amount_after_spend} + ${non_cashoutable_refund_amount} + ${total_expired_gift_refund_amount}
    ELSE
        ${expected_non_cashout_balance}    Evaluate
        ...    ${non_cashoutable_initial_balance} + ${total_expired_gift_refund_amount}
    END

    ${current_non_cashout_balance}
    ...    GET Wallets Users Balance
    ...    ${MICROSERVICE_SIDE}
    ...    ${CURRENT_USER['user_id']}
    ...    ${WALLET_DEFAULT_DEFINITION}
    Should Be In Range
    ...    actual=${current_non_cashout_balance['body']['nonCashoutableBalance']}
    ...    expected=${expected_non_cashout_balance}
    ...    integer_range=${1}

Expired Gift Spend Amount Should Be Transferred To Default Non-Cashoutable Wallet Based On Percentage Of Spend Amount
    Expired Gift Spend Amount Should Be Transferred To Default Non-Cashoutable Wallet    ${REFUND_PERCENTAGE}

Unexpired Gift Should Be Increased Based On Original Spend
    [Arguments]    ${refund_percentage_arg}=${0}
    FOR    ${wallet}    IN    @{CURRENT_USER['wallets']}
        IF    '${wallet['type']}' == '${WALLET_TIME_BOUND_DEFINITION}}' and 'expired' not in ${wallet}
            IF    ${refund_percentage_arg} != ${0}
                ${expected_refund_amount}    Evaluate    ${wallet['initial_amount']} * ${refund_percentage_arg}
                ${expected_refund_amount}    Round Half Up    ${expected_refund_amount}
            ELSE
                ${expected_refund_amount}    Set Variable    ${wallet['initial_amount']}
            END

            ${current_wallet_balance}    GET Wallets Users Balance
            ...    ${MICROSERVICE_SIDE}
            ...    ${CURRENT_USER['user_id']}
            ...    ${wallet['name']}

            Should Be Equal As Integers
            ...    ${current_wallet_balance['body']['balance']}
            ...    ${expected_refund_amount}
            ...    msg=Balance for unexpire wallet: ${wallet['name']}, should be equal to refund amount but found: ${wallet_balance['body']['balance']}.
        END
    END

Unexpired Gift Should Be Increased Based On Percentage Of Spend Amount
    Unexpired Gift Should Be Increased Based On Original Spend    ${REFUND_PERCENTAGE}

Default Cashoutable And Non-Cashoutable Wallets Should Be Increased Based On Original Spend
    [Arguments]    ${refund_percentage_arg}=${0}
    ${total_expired_gift_refund_amount}    Set Variable    ${0}
    ${non_cashoutable_initial_balance}    Set Variable    ${0}
    ${expected_cashoutable_balance}    Set Variable    ${0}
    FOR    ${wallet}    IN    @{CURRENT_USER['wallets']}
        # Calculate total expired gift spend amount
        IF    'expired' in ${wallet}
            ${wallet_balance}    GET Wallets Users Balance
            ...    ${MICROSERVICE_SIDE}
            ...    ${CURRENT_USER['user_id']}
            ...    ${wallet['name']}
            ${expired_wallet_remaining_amount_after_spend}    Evaluate
            ...    ${wallet['initial_amount']} - ${wallet['spend_amount']}
            # Calculate refund amount for this wallet based on refund percentage
            IF    ${refund_percentage_arg} != ${0}
                ${expected_refund_amount}    Evaluate    ${wallet['initial_amount']} * ${refund_percentage_arg}
                ${expected_refund_amount}    Round Half Up    ${expected_refund_amount}
            ELSE
                ${expected_refund_amount}    Evaluate
                ...    ${wallet['initial_amount']} - ${expired_wallet_remaining_amount_after_spend}
            END

            ${total_expired_gift_refund_amount}    Evaluate
            ...    ${total_expired_gift_refund_amount} + ${expected_refund_amount}
        END

        # Get default cashoutable & non cashoutable initial balance
        IF    '${wallet['type']}' == '${WALLET_DEFAULT_DEFINITION}'
            IF    ${refund_percentage_arg} != ${0}
                ${expected_cashoutable_balance}    Evaluate
                ...    ${wallet['cashoutable_amount']} * ${refund_percentage_arg}
                ${expected_cashoutable_balance}    Round Half Up    ${expected_cashoutable_balance}
            ELSE
                ${expected_cashoutable_balance}    Set Variable    ${wallet['cashoutable_amount']}
            END
            ${non_cashoutable_initial_balance}    Evaluate
            ...    ${wallet['initial_amount']} - ${wallet['cashoutable_amount']}
        END
    END

    # Calculate non_cashout expected balance based on refund percentage
    IF    ${refund_percentage_arg} != ${0}
        ${non_cashoutable_remaining_amount_after_spend}    Evaluate
        ...    ${CURRENT_USER['total_initial_amount']} - ${CURRENT_USER['total_spend_amount']}

        ${non_cashoutable_spend_amount}    Evaluate
        ...    ${non_cashoutable_initial_balance} - ${non_cashoutable_remaining_amount_after_spend}

        ${non_cashoutable_refund_amount}    Evaluate    ${non_cashoutable_spend_amount} * ${refund_percentage_arg}
        ${non_cashoutable_refund_amount}    Round Half Up    ${non_cashoutable_refund_amount}

        ${expected_non_cashout_balance}    Evaluate
        ...    ${non_cashoutable_remaining_amount_after_spend} + ${non_cashoutable_refund_amount} + ${total_expired_gift_refund_amount}
    ELSE
        ${expected_non_cashout_balance}    Evaluate
        ...    ${non_cashoutable_initial_balance} + ${total_expired_gift_refund_amount}
    END
    ${expected_cashoutable_balance}    Convert To Integer    ${expected_cashoutable_balance}
    ${current_default_wallet_balance}
    ...    GET Wallets Users Balance
    ...    ${MICROSERVICE_SIDE}
    ...    ${CURRENT_USER['user_id']}
    ...    ${WALLET_DEFAULT_DEFINITION}
    Should Be In Range
    ...    actual=${current_default_wallet_balance['body']['nonCashoutableBalance']}
    ...    expected=${expected_non_cashout_balance}
    ...    integer_range=${1}
    Should Be In Range
    ...    actual=${current_default_wallet_balance['body']['cashoutableBalance']}
    ...    expected=${expected_cashoutable_balance}
    ...    integer_range=${1}

Default Cashoutable And Non-Cashoutable Wallets Should Be Increased Based On Percentage Of Spend Amount
    Default Cashoutable And Non-Cashoutable Wallets Should Be Increased Based On Original Spend    ${REFUND_PERCENTAGE}

Only Default Wallet Amount Should Be Increased Based On Refund Amount
    FOR    ${wallet}    IN    @{CURRENT_USER['wallets']}
        # Calculate total expired gift spend amount
        ${wallet_balance}    GET Wallets Users Balance
        ...    ${MICROSERVICE_SIDE}
        ...    ${CURRENT_USER['user_id']}
        ...    ${wallet['name']}

        IF    '${wallet['type']}' == '${WALLET_DEFAULT_DEFINITION}'
            ${expected_cashoutable_balance}    Evaluate
            ...    ${wallet['cashoutable_amount']} + ${CURRENT_USER['refund_cashoutable_amount']}
            ${non_cashout_refund_amount}    Evaluate
            ...    ${CURRENT_USER['refund_amount']} - ${CURRENT_USER['refund_cashoutable_amount']}
            ${expected_non_cashoutable_balance}    Evaluate
            ...    (${wallet['initial_amount']} - ${wallet['cashoutable_amount']}) + ${non_cashout_refund_amount}
            ${expected_default_wallet_balance}    Evaluate
            ...    ${expected_cashoutable_balance} + ${expected_non_cashoutable_balance}
            Should Be Equal As Integers
            ...    ${wallet_balance['body']['balance']}
            ...    ${expected_default_wallet_balance}
            ...    msg=Balance for default wallet, should be increased based on refund amount but found: ${wallet_balance['body']['balance']}.
            Should Be In Range
            ...    actual=${wallet_balance['body']['nonCashoutableBalance']}
            ...    expected=${expected_non_cashoutable_balance}
            ...    integer_range=${1}
            Should Be Equal As Integers
            ...    ${wallet_balance['body']['nonCashoutableBalance']}
            ...    ${expected_non_cashoutable_balance}
            ...    msg=Balance for default non cashoutable , should be increased based on refund amount but found: ${wallet_balance['body']['nonCashoutableBalance']}.
            Should Be Equal As Integers
            ...    ${wallet_balance['body']['cashoutableBalance']}
            ...    ${expected_cashoutable_balance}
            ...    msg=Balance for default cashoutable , should be increased based on refund amount but found: ${wallet_balance['body']['cashoutableBalance']}.
        ELSE
            Should Be Equal As Integers
            ...    ${wallet_balance['body']['balance']}
            ...    ${wallet['initial_amount']}
            ...    msg=Balance for wallet: ${wallet['name']}, should not equal as initial amount but found: ${wallet_balance['body']['balance']}.
        END
    END

All Wallets Amount Should Not Be Changed
    FOR    ${wallet}    IN    @{CURRENT_USER['wallets']}
        # Calculate total expired gift spend amount
        ${wallet_balance}    GET Wallets Users Balance
        ...    ${MICROSERVICE_SIDE}
        ...    ${CURRENT_USER['user_id']}
        ...    ${wallet['name']}

        Should Be Equal As Integers
        ...    ${wallet_balance['body']['balance']}
        ...    ${wallet['initial_amount']}
        ...    msg=Balance for wallet: ${wallet['name']}, should not equal as initial amount but found: ${wallet_balance['body']['balance']}.
    END

Only Business Refund Wallet Should Be Decreased Based On Spend Amount
    ${get_balance_result}    GET Wallets Businesses Balance
    ...    ${MICROSERVICE_SIDE}
    ...    ${INIT_BUSINESS_ID}
    ...    ${B_WALLET_REFUND_DEFINITION}

    Should Be Equal As Integers
    ...    ${get_balance_result['body']['balance']}
    ...    ${B_REFUND_WALLET_EXPECTED_AMOUNT}
    ...    msg=The balance of business wallet for refund should be equal: ${B_REFUND_WALLET_EXPECTED_AMOUNT} but found: ${get_balance_result['body']['balance']}

    Spend Wallet Should Not Be Decreased

Only Business Refund Wallet Should Be Decreased Based On Percentage Of Spend Amount
    Only Business Refund Wallet Should Be Decreased Based On Spend Amount

Only Business Refund Wallet Should Be Decreased Based On Refund Amount
    Only Business Refund Wallet Should Be Decreased Based On Spend Amount

Business Refund Wallet Should Not Be Decreased
    Only Business Refund Wallet Should Be Decreased Based On Spend Amount

Update Business Expected Balance After Payout
    [Tags]    robot:private
    [Arguments]    ${payout_amount}

    ${B_REFUND_WALLET_EXPECTED_AMOUNT}    Evaluate    ${B_REFUND_WALLET_EXPECTED_AMOUNT} - ${payout_amount}
    Set Suite Variable    ${B_REFUND_WALLET_EXPECTED_AMOUNT}

Spend Wallet Should Not Be Decreased
    [Tags]    robot:private

    FOR    ${business}    IN    @{BUSINESS_LIST_FOR_SPEND}
        ${get_balance_result}    GET Wallets Businesses Balance
        ...    ${MICROSERVICE_SIDE}
        ...    ${business['id']}
        ...    ${business['wallet_name']}

        Should Be Equal As Integers
        ...    ${get_balance_result['body']['balance']}
        ...    ${business['initial_balance']}
        ...    msg=The balance of business wallet for spend should not be decreased but found: ${get_balance_result['body']['balance']}
    END

Refund Should Be Failed With
    [Arguments]    ${failure_message}
    Dictionaries Should Be Equal    ${failure_message}    ${PAYOUT_RESULT['body']['result']}

Payout Inquiry Should Be Successful State
    ${result}    GET Transactions Payout    ${MICROSERVICE_SIDE}    ${CURRENT_USER['payout_tracking_code']}

    Should Be Equal As Integers
    ...    ${result['status_code']}
    ...    200
    ...    msg=Failed to payout inquiry. result: ${result['body']}

    Should Be Equal As Integers    ${CURRENT_USER['total_spend_amount']}    ${result['body']['amount']}
    ...    msg=Amount in payout inquiry should be same as payout amount but found: ${result['body']['amount']}.

    Should Be Equal As Integers    ${0}    ${result['body']['status']}
    ...    msg=Status in payout inquiry should be successful but found: ${result['body']['status']}.

Legacy Payout Inquiry Should Be Successful State
    ${result}    GET Wallets Payout Inquiry    ${MICROSERVICE_SIDE}    ${CURRENT_USER['payout_tracking_code']}

    Should Be Equal As Integers
    ...    ${result['status_code']}
    ...    200
    ...    msg=Failed to payout inquiry. result: ${result['body']}

    Should Be Equal As Integers    ${CURRENT_USER['total_spend_amount']}    ${result['body']['amount']}
    ...    msg=Amount in payout inquiry should be same as payout amount but found: ${result['body']['amount']}.

    Should Be Equal As Integers    ${0}    ${result['body']['payoutStatus']}
    ...    msg=Status in payout inquiry should be successful but found: ${result['body']['payoutStatus']}.

Should Be In Range
    [Documentation]    this method check by this formula `${ expected - ${integer_range} } <= ${actual} <= ${ expected + ${integer_range} }`
    [Arguments]    ${actual}    ${expected}    ${integer_range}

    IF    ${actual} >= ${expected - ${integer_range} } and ${actual} <= ${ expected + ${integer_range} }
        No Operation
    ELSE
        Fail
        ...    msg=actual value ${actual} should be in range of ${expected} with range ${integer_range}
    END
