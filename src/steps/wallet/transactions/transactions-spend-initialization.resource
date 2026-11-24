*** Settings ***
Library         library/faker_utils.py    WITH NAME    FakerLibrary
Resource        services/backend/auth-service.resource
Resource        apis/uaa/post-admin-businesses.resource
Resource        apis/wallet-provider/wallets/post-wallets-definitions-users.resource
Resource        apis/wallet-provider/wallets/post-wallets-users.resource
Resource        apis/wallet-provider/admin/admin-wallets-businesses.resource
Resource        apis/nemo/admin/admin-wallets-businesses-cash-in.resource
Resource        apis/wallet-provider/transactions/post-transactions-payout.resource
Resource        apis/wallet-provider/wallets/get-wallets-users-balances.resource
Resource        apis/wallet-provider/wallets/get-wallets-users-balance.resource
Variables       data/wallet/transactions/transactions-spend-variables.yaml


*** Keywords ***
Initialize Business And User
    ${current_time}    Get Time    epoch
    ${expiration_date}    Evaluate    (${current_time} * 1000) + 90000
    ${future_date}    Evaluate    (${current_time} * 1000) + 10000000

    # Create Users and Assign Wallets
    ${USER_ID_MULTI_TYPE_WALLET}    Get A Fresh User    ${USER_CELL_NUMBER_PREFIX}
    ${MULTI_TYPE_USER_EXPIRED_WALLET_NAME}    Create User Wallet
    ...    gift
    ...    expired-wallet
    ...    ${USER_ID_MULTI_TYPE_WALLET}
    ...    expiration_date=${expiration_date}
    ${MULTI_TYPE_USER_UNEXPIRED_WALLET_NAME_ZERO_AMOUNT}    Create User Wallet
    ...    gift
    ...    unexpired-wallet-zero-amount
    ...    ${USER_ID_MULTI_TYPE_WALLET}
    ...    expiration_date=${future_date}
    ${MULTI_TYPE_USER_UNEXPIRED_WALLET_NAME}    Create User Wallet
    ...    gift
    ...    unexpired-wallet
    ...    ${USER_ID_MULTI_TYPE_WALLET}
    ...    expiration_date=${future_date}

    ${USER_ID_MULTI_TYPE_WALLET_SPEND_ALL}    Get A Fresh User    ${USER_CELL_NUMBER_PREFIX}
    ${MULTI_TYPE_USER_SPEND_ALL_UNEXPIRED_WALLET_NAME}    Create User Wallet
    ...    gift
    ...    unexpired-wallet
    ...    ${USER_ID_MULTI_TYPE_WALLET_SPEND_ALL}
    ...    expiration_date=${future_date}

    ${USER_ID_ONLY_GIFT_WALLET}    Get A Fresh User    ${USER_CELL_NUMBER_PREFIX}
    ${GIFT_ONLY_USER_UNEXPIRED_WALLET_NAME}    Create User Wallet
    ...    gift
    ...    unexpired-wallet
    ...    ${USER_ID_ONLY_GIFT_WALLET}
    ...    expiration_date=${future_date}
    ${GIFT_ONLY_USER_SECOND_UNEXPIRED_WALLET_NAME}    Create User Wallet
    ...    gift
    ...    second-unexpired-wallet
    ...    ${USER_ID_ONLY_GIFT_WALLET}
    ...    expiration_date=${future_date}

    ${USER_ID_FOR_SPLIT_SPEND}    Get A Fresh User    ${USER_CELL_NUMBER_PREFIX}
    ${SPLIT_SPEND_USER_UNEXPIRED_WALLET_NAME}    Create User Wallet
    ...    gift
    ...    unexpired-wallet
    ...    ${USER_ID_FOR_SPLIT_SPEND}
    ...    expiration_date=${future_date}

    ${USER_ID_WITH_DEFAULT_WALLET}    Get A Fresh User    ${USER_CELL_NUMBER_PREFIX}

    ${USER_ID_WITH_DEFAULT_ONLY_CASHOUTABLE_WALLET}    Get A Fresh User    ${USER_CELL_NUMBER_PREFIX}

    ${USER_ID_WITH_DEFAULT_ONLY_NON_CASHOUTABLE_WALLET}    Get A Fresh User    ${USER_CELL_NUMBER_PREFIX}

    ${USER_ID_ONLY_EXPIRED_WALLET}    Get A Fresh User    ${USER_CELL_NUMBER_PREFIX}
    ${ONLY_EXPIRED_WALLET_USER_WALLET_NAME}    Create User Wallet
    ...    gift
    ...    expired-wallet
    ...    ${USER_ID_ONLY_EXPIRED_WALLET}
    ...    expiration_date=${expiration_date}

    ${USER_ID_WITHOUT_WALLET}    Get A Fresh User    ${USER_CELL_NUMBER_PREFIX}

    ${USER_ID_FOR_INVALID_SCENARIO}    Get A Fresh User    ${USER_CELL_NUMBER_PREFIX}
    ${USER_FOR_INVALID_SCENARIO_UNEXPIRED_WALLET_NAME}    Create User Wallet
    ...    gift
    ...    unexpired-wallet
    ...    ${USER_ID_FOR_INVALID_SCENARIO}
    ...    expiration_date=${future_date}

    ${USER_ID_MULTI_TYPE_WALLET_FOR_REVERSE}    Get A Fresh User    ${USER_CELL_NUMBER_PREFIX}
    ${MULTI_TYPE_USER_EXPIRED_WALLET_NAME_FOR_REVERSE}    Create User Wallet
    ...    gift
    ...    expired-wallet
    ...    ${USER_ID_MULTI_TYPE_WALLET_FOR_REVERSE}
    ...    expiration_date=${expiration_date}
    ${MULTI_TYPE_USER_UNEXPIRED_WALLET_NAME_ZERO_AMOUNT_FOR_REVERSE}    Create User Wallet
    ...    gift
    ...    unexpired-wallet-zero-amount
    ...    ${USER_ID_MULTI_TYPE_WALLET_FOR_REVERSE}
    ...    expiration_date=${future_date}
    ${MULTI_TYPE_USER_UNEXPIRED_WALLET_NAME_FOR_REVERSE}    Create User Wallet
    ...    gift
    ...    unexpired-wallet
    ...    ${USER_ID_MULTI_TYPE_WALLET_FOR_REVERSE}
    ...    expiration_date=${future_date}

    ${USER_ID_VERIFY_SCENARIO}    Get A Fresh User    ${USER_CELL_NUMBER_PREFIX}
    ${VERIFY_SCENARIO_USER_UNEXPIRED_WALLET_NAME}    Create User Wallet
    ...    gift
    ...    unexpired-wallet
    ...    ${USER_ID_VERIFY_SCENARIO}
    ...    expiration_date=${future_date}

    ${USER_ID_REPEATED_VERIFY_SCENARIO}    Get A Fresh User    ${USER_CELL_NUMBER_PREFIX}
    ${REPEATED_VERIFY_SCENARIO_USER_UNEXPIRED_WALLET_NAME}    Create User Wallet
    ...    gift
    ...    unexpired-wallet
    ...    ${USER_ID_REPEATED_VERIFY_SCENARIO}
    ...    expiration_date=${future_date}

    ${USER_ID_OLD_API_SCENARIO}    Get A Fresh User    ${USER_CELL_NUMBER_PREFIX}
    ${OLD_API_SCENARIO_USER_UNEXPIRED_WALLET_NAME}    Create User Wallet
    ...    gift
    ...    unexpired-wallet
    ...    ${USER_ID_OLD_API_SCENARIO}
    ...    expiration_date=${future_date}

    # Create Businesses And Cash-in to a wallet for payout
    ${INIT_BUSINESS_ID}    Create Business
    Create Business Wallet    ${INIT_BUSINESS_ID}    ${B_WALLET_FOR_PAYOUT}
    Create Business Wallet    ${INIT_BUSINESS_ID}    ${B_WALLET_FOR_SPEND_MULTI_TYPE}
    Create Business Wallet    ${INIT_BUSINESS_ID}    ${B_WALLET_FOR_SPLIT_SPEND_BUSINESS}
    Create Business Wallet    ${INIT_BUSINESS_ID}    ${B_WALLET_FOR_SPEND_GIFT_ONLY_TYPE}
    Create Business Wallet    ${INIT_BUSINESS_ID}    ${B_WALLET_FOR_SPEND_ALL_AMOUNT}
    Create Business Wallet    ${INIT_BUSINESS_ID}    ${B_WALLET_FOR_SPEND_DEFAULT_WALLET}
    Create Business Wallet    ${INIT_BUSINESS_ID}    ${B_WALLET_FOR_SPEND_DEFAULT_NONCASHOUTABLE}
    Create Business Wallet    ${INIT_BUSINESS_ID}    ${B_WALLET_FOR_SPEND_DEFAULT_CASHOUTABLE}
    Create Business Wallet    ${INIT_BUSINESS_ID}    ${B_WALLET_FOR_SPEND_EXPIRED_WALLET}
    Create Business Wallet    ${INIT_BUSINESS_ID}    ${B_WALLET_FOR_SPEND_INVALID_SCENARIO}
    Create Business Wallet    ${INIT_BUSINESS_ID}    ${B_WALLET_FOR_SPEND_AND_REVERSE}
    Create Business Wallet    ${INIT_BUSINESS_ID}    ${B_WALLET_FOR_SPEND_OLD_API}
    Create Business Wallet    ${INIT_BUSINESS_ID}    ${B_WALLET_FOR_VERIFY_SCENARIO}

    ${BUSINESS_ID_FOR_SPLIT_SPEND}    Create Business
    Create Business Wallet    ${BUSINESS_ID_FOR_SPLIT_SPEND}    ${B_WALLET_FOR_SPLIT_SPEND_BUSINESS}
    Create Business Wallet    ${BUSINESS_ID_FOR_SPLIT_SPEND}    ${B_WALLET_FOR_SPEND_INVALID_SCENARIO}
    Create Business Wallet    ${BUSINESS_ID_FOR_SPLIT_SPEND}    ${B_WALLET_FOR_SPEND_AND_REVERSE}

    Cash-in To Business Wallet    ${INIT_BUSINESS_ID}    ${B_WALLET_FOR_PAYOUT}    amount=5000

    # Payout To Wallet And Get All Wallets Initial Balances Per User
    ##Payout To Multi Type Wallet User
    ${wallet_initial_amount}    Random Int    100    200
    Payout To User Wallet
    ...    ${INIT_BUSINESS_ID}
    ...    ${B_WALLET_FOR_PAYOUT}
    ...    ${USER_ID_MULTI_TYPE_WALLET}
    ...    ${MULTI_TYPE_USER_EXPIRED_WALLET_NAME}
    ...    ${wallet_initial_amount}
    ...    0
    ${wallet_initial_amount}    Random Int    100    200
    Payout To User Wallet
    ...    ${INIT_BUSINESS_ID}
    ...    ${B_WALLET_FOR_PAYOUT}
    ...    ${USER_ID_MULTI_TYPE_WALLET}
    ...    ${MULTI_TYPE_USER_UNEXPIRED_WALLET_NAME}
    ...    ${wallet_initial_amount}
    ...    0
    ${wallet_initial_amount}    Random Int    100    200
    ${cashoutable_initial_amount}    Random Int    30    50
    Payout To User Wallet
    ...    ${INIT_BUSINESS_ID}
    ...    ${B_WALLET_FOR_PAYOUT}
    ...    ${USER_ID_MULTI_TYPE_WALLET}
    ...    ${USER_DEFAULT_WALLET}
    ...    ${wallet_initial_amount}
    ...    ${cashoutable_initial_amount}

    ## Payout To Split Spend User
    ${wallet_initial_amount}    Random Int    100    200
    Payout To User Wallet
    ...    ${INIT_BUSINESS_ID}
    ...    ${B_WALLET_FOR_PAYOUT}
    ...    ${USER_ID_FOR_SPLIT_SPEND}
    ...    ${SPLIT_SPEND_USER_UNEXPIRED_WALLET_NAME}
    ...    ${wallet_initial_amount}
    ...    0
    ${wallet_initial_amount}    Random Int    100    200
    ${cashoutable_initial_amount}    Random Int    30    50
    Payout To User Wallet
    ...    ${INIT_BUSINESS_ID}
    ...    ${B_WALLET_FOR_PAYOUT}
    ...    ${USER_ID_FOR_SPLIT_SPEND}
    ...    ${USER_DEFAULT_WALLET}
    ...    ${wallet_initial_amount}
    ...    ${cashoutable_initial_amount}

    ## Payout To Gift Only User
    ${wallet_initial_amount}    Random Int    100    200
    Payout To User Wallet
    ...    ${INIT_BUSINESS_ID}
    ...    ${B_WALLET_FOR_PAYOUT}
    ...    ${USER_ID_ONLY_GIFT_WALLET}
    ...    ${GIFT_ONLY_USER_UNEXPIRED_WALLET_NAME}
    ...    ${wallet_initial_amount}
    ...    0
    ${wallet_initial_amount}    Random Int    100    200
    Payout To User Wallet
    ...    ${INIT_BUSINESS_ID}
    ...    ${B_WALLET_FOR_PAYOUT}
    ...    ${USER_ID_ONLY_GIFT_WALLET}
    ...    ${GIFT_ONLY_USER_SECOND_UNEXPIRED_WALLET_NAME}
    ...    ${wallet_initial_amount}
    ...    0

    ## Payout To Spend All Amount Type User Wallet
    ${wallet_initial_amount}    Random Int    100    200
    Payout To User Wallet
    ...    ${INIT_BUSINESS_ID}
    ...    ${B_WALLET_FOR_PAYOUT}
    ...    ${USER_ID_MULTI_TYPE_WALLET_SPEND_ALL}
    ...    ${MULTI_TYPE_USER_SPEND_ALL_UNEXPIRED_WALLET_NAME}
    ...    ${wallet_initial_amount}
    ...    0
    ${wallet_initial_amount}    Random Int    100    200
    ${cashoutable_initial_amount}    Random Int    30    50
    Payout To User Wallet
    ...    ${INIT_BUSINESS_ID}
    ...    ${B_WALLET_FOR_PAYOUT}
    ...    ${USER_ID_MULTI_TYPE_WALLET_SPEND_ALL}
    ...    ${USER_DEFAULT_WALLET}
    ...    ${wallet_initial_amount}
    ...    ${cashoutable_initial_amount}

    ##Payout To User With Only Default Wallet
    ${wallet_initial_amount}    Random Int    100    200
    ${cashoutable_initial_amount}    Random Int    30    50
    Payout To User Wallet
    ...    ${INIT_BUSINESS_ID}
    ...    ${B_WALLET_FOR_PAYOUT}
    ...    ${USER_ID_WITH_DEFAULT_WALLET}
    ...    ${USER_DEFAULT_WALLET}
    ...    ${wallet_initial_amount}
    ...    ${cashoutable_initial_amount}

    ##Payout To User With Default Wallet Only with Cashoutable
    ${wallet_initial_amount}    Random Int    100    200
    Payout To User Wallet
    ...    ${INIT_BUSINESS_ID}
    ...    ${B_WALLET_FOR_PAYOUT}
    ...    ${USER_ID_WITH_DEFAULT_ONLY_CASHOUTABLE_WALLET}
    ...    ${USER_DEFAULT_WALLET}
    ...    ${wallet_initial_amount}
    ...    cashoutable_amount=${wallet_initial_amount}

    ##Payout To User With Default Wallet Only with NON-Cashoutable
    ${wallet_initial_amount}    Random Int    100    200
    Payout To User Wallet
    ...    ${INIT_BUSINESS_ID}
    ...    ${B_WALLET_FOR_PAYOUT}
    ...    ${USER_ID_WITH_DEFAULT_ONLY_NON_CASHOUTABLE_WALLET}
    ...    ${USER_DEFAULT_WALLET}
    ...    ${wallet_initial_amount}
    ...    0

    ## Payout to User with Only Expired Wallet
    ${wallet_initial_amount}    Random Int    100    200
    Payout To User Wallet
    ...    ${INIT_BUSINESS_ID}
    ...    ${B_WALLET_FOR_PAYOUT}
    ...    ${USER_ID_ONLY_EXPIRED_WALLET}
    ...    ${ONLY_EXPIRED_WALLET_USER_WALLET_NAME}
    ...    ${wallet_initial_amount}
    ...    0

    ## Payout To User Wallet for Invalid Business Scenarios
    ${wallet_initial_amount}    Random Int    100    200
    Payout To User Wallet
    ...    ${INIT_BUSINESS_ID}
    ...    ${B_WALLET_FOR_PAYOUT}
    ...    ${USER_ID_FOR_INVALID_SCENARIO}
    ...    ${USER_FOR_INVALID_SCENARIO_UNEXPIRED_WALLET_NAME}
    ...    ${wallet_initial_amount}
    ...    0
    ${wallet_initial_amount}    Random Int    100    200
    ${cashoutable_initial_amount}    Random Int    30    50
    Payout To User Wallet
    ...    ${INIT_BUSINESS_ID}
    ...    ${B_WALLET_FOR_PAYOUT}
    ...    ${USER_ID_FOR_INVALID_SCENARIO}
    ...    ${USER_DEFAULT_WALLET}
    ...    ${wallet_initial_amount}
    ...    ${cashoutable_initial_amount}

    ##Payout To Multi Type Wallet User For Reverse Scenario
    ${wallet_initial_amount}    Random Int    100    200
    Payout To User Wallet
    ...    ${INIT_BUSINESS_ID}
    ...    ${B_WALLET_FOR_PAYOUT}
    ...    ${USER_ID_MULTI_TYPE_WALLET_FOR_REVERSE}
    ...    ${MULTI_TYPE_USER_EXPIRED_WALLET_NAME_FOR_REVERSE}
    ...    ${wallet_initial_amount}
    ...    0
    ${wallet_initial_amount}    Random Int    100    200
    Payout To User Wallet
    ...    ${INIT_BUSINESS_ID}
    ...    ${B_WALLET_FOR_PAYOUT}
    ...    ${USER_ID_MULTI_TYPE_WALLET_FOR_REVERSE}
    ...    ${MULTI_TYPE_USER_UNEXPIRED_WALLET_NAME_FOR_REVERSE}
    ...    ${wallet_initial_amount}
    ...    0
    ${wallet_initial_amount}    Random Int    100    200
    ${cashoutable_initial_amount}    Random Int    30    50
    Payout To User Wallet
    ...    ${INIT_BUSINESS_ID}
    ...    ${B_WALLET_FOR_PAYOUT}
    ...    ${USER_ID_MULTI_TYPE_WALLET_FOR_REVERSE}
    ...    ${USER_DEFAULT_WALLET}
    ...    ${wallet_initial_amount}
    ...    ${cashoutable_initial_amount}

    ##Payout To Wallet User For Verify Scenario
    ${wallet_initial_amount}    Random Int    100    200
    Payout To User Wallet
    ...    ${INIT_BUSINESS_ID}
    ...    ${B_WALLET_FOR_PAYOUT}
    ...    ${USER_ID_VERIFY_SCENARIO}
    ...    ${VERIFY_SCENARIO_USER_UNEXPIRED_WALLET_NAME}
    ...    ${wallet_initial_amount}
    ...    0
    ${wallet_initial_amount}    Random Int    100    200
    ${cashoutable_initial_amount}    Random Int    30    50
    Payout To User Wallet
    ...    ${INIT_BUSINESS_ID}
    ...    ${B_WALLET_FOR_PAYOUT}
    ...    ${USER_ID_VERIFY_SCENARIO}
    ...    ${USER_DEFAULT_WALLET}
    ...    ${wallet_initial_amount}
    ...    ${cashoutable_initial_amount}

    ##Payout To Wallet User For Repeated Verify Scenario
    ${wallet_initial_amount}    Random Int    100    200
    Payout To User Wallet
    ...    ${INIT_BUSINESS_ID}
    ...    ${B_WALLET_FOR_PAYOUT}
    ...    ${USER_ID_REPEATED_VERIFY_SCENARIO}
    ...    ${REPEATED_VERIFY_SCENARIO_USER_UNEXPIRED_WALLET_NAME}
    ...    ${wallet_initial_amount}
    ...    0
    ${wallet_initial_amount}    Random Int    100    200
    ${cashoutable_initial_amount}    Random Int    30    50
    Payout To User Wallet
    ...    ${INIT_BUSINESS_ID}
    ...    ${B_WALLET_FOR_PAYOUT}
    ...    ${USER_ID_REPEATED_VERIFY_SCENARIO}
    ...    ${USER_DEFAULT_WALLET}
    ...    ${wallet_initial_amount}
    ...    ${cashoutable_initial_amount}

    ##Payout To Wallet User For Old API Scenario
    ${wallet_initial_amount}    Random Int    100    200
    Payout To User Wallet
    ...    ${INIT_BUSINESS_ID}
    ...    ${B_WALLET_FOR_PAYOUT}
    ...    ${USER_ID_OLD_API_SCENARIO}
    ...    ${OLD_API_SCENARIO_USER_UNEXPIRED_WALLET_NAME}
    ...    ${wallet_initial_amount}
    ...    0
    ${wallet_initial_amount}    Random Int    100    200
    ${cashoutable_initial_amount}    Random Int    30    50
    Payout To User Wallet
    ...    ${INIT_BUSINESS_ID}
    ...    ${B_WALLET_FOR_PAYOUT}
    ...    ${USER_ID_OLD_API_SCENARIO}
    ...    ${USER_DEFAULT_WALLET}
    ...    ${wallet_initial_amount}
    ...    ${cashoutable_initial_amount}

    Sleep    90s    reason=for ensure from expiring wallets.

    # Calculate total wallet balance after wallet expiration
    ${MULTI_TYPE_WALLET_USER_ALL_INIT_BALANCE}    Give User Total Wallet Balances
    ...    ${USER_ID_MULTI_TYPE_WALLET}
    ${MULTI_TYPE_WALLET_USER_EXPIRED_WALLET_INIT_BALANCE}    Give User Wallet Balance
    ...    ${USER_ID_MULTI_TYPE_WALLET}
    ...    ${MULTI_TYPE_USER_EXPIRED_WALLET_NAME}

    ${SPLIT_SPEND_WALLET_USER_ALL_INIT_BALANCE}    Give User Total Wallet Balances
    ...    ${USER_ID_FOR_SPLIT_SPEND}

    ${GIFT_ONLY_WALLET_USER_ALL_INIT_BALANCE}    Give User Total Wallet Balances
    ...    ${USER_ID_ONLY_GIFT_WALLET}

    ${SPEND_ALL_WALLET_USER_ALL_INIT_BALANCE}    Give User Total Wallet Balances
    ...    ${USER_ID_MULTI_TYPE_WALLET_SPEND_ALL}

    ${ONLY_DEFAULT_WALLET_USER_ALL_INIT_BALANCE}    Give User Total Wallet Balances
    ...    ${USER_ID_WITH_DEFAULT_WALLET}

    ${ONLY_CASHOUTABLE_WALLET_USER_ALL_INIT_BALANCE}    Give User Total Wallet Balances
    ...    ${USER_ID_WITH_DEFAULT_ONLY_CASHOUTABLE_WALLET}

    ${ONLY_NON_CASHOUTABLE_WALLET_USER_ALL_INIT_BALANCE}    Give User Total Wallet Balances
    ...    ${USER_ID_WITH_DEFAULT_ONLY_NON_CASHOUTABLE_WALLET}

    ${ONLY_EXPIRED_WALLET_USER_ALL_INIT_BALANCE}    Give User Wallet Balance
    ...    ${USER_ID_ONLY_EXPIRED_WALLET}
    ...    ${ONLY_EXPIRED_WALLET_USER_WALLET_NAME}

    ${USER_WALLET_FOR_INVALID_SCENARIO_ALL_INIT_BALANCE}    Give User Total Wallet Balances
    ...    ${USER_ID_FOR_INVALID_SCENARIO}

    ${MULTI_TYPE_WALLET_USER_FOR_REVERSE_ALL_INIT_BALANCE}    Give User Total Wallet Balances
    ...    ${USER_ID_MULTI_TYPE_WALLET_FOR_REVERSE}
    ${MULTI_TYPE_WALLET_USER_EXPIRED_WALLET_FOR_REVERSE_INIT_BALANCE}    Give User Wallet Balance
    ...    ${USER_ID_MULTI_TYPE_WALLET_FOR_REVERSE}
    ...    ${MULTI_TYPE_USER_EXPIRED_WALLET_NAME_FOR_REVERSE}

    ${VERIFY_SCENARIO_USER_ALL_INIT_BALANCE}    Give User Total Wallet Balances
    ...    ${USER_ID_VERIFY_SCENARIO}

    ${REPEATED_VERIFY_SCENARIO_USER_ALL_INIT_BALANCE}    Give User Total Wallet Balances
    ...    ${USER_ID_REPEATED_VERIFY_SCENARIO}

    ${OLD_API_SCENARIO_USER_ALL_INIT_BALANCE}    Give User Total Wallet Balances
    ...    ${USER_ID_OLD_API_SCENARIO}

    Set Suite Variable    ${USER_ID_MULTI_TYPE_WALLET}
    Set Suite Variable    ${MULTI_TYPE_USER_EXPIRED_WALLET_NAME}
    Set Suite Variable    ${MULTI_TYPE_USER_UNEXPIRED_WALLET_NAME_ZERO_AMOUNT}
    Set Suite Variable    ${MULTI_TYPE_USER_UNEXPIRED_WALLET_NAME}
    Set Suite Variable    ${MULTI_TYPE_WALLET_USER_ALL_INIT_BALANCE}
    Set Suite Variable    ${MULTI_TYPE_WALLET_USER_EXPIRED_WALLET_INIT_BALANCE}
    Set Suite Variable    ${USER_ID_MULTI_TYPE_WALLET_SPEND_ALL}
    Set Suite Variable    ${MULTI_TYPE_USER_SPEND_ALL_UNEXPIRED_WALLET_NAME}
    Set Suite Variable    ${SPEND_ALL_WALLET_USER_ALL_INIT_BALANCE}
    Set Suite Variable    ${USER_ID_ONLY_GIFT_WALLET}
    Set Suite Variable    ${GIFT_ONLY_USER_UNEXPIRED_WALLET_NAME}
    Set Suite Variable    ${GIFT_ONLY_USER_SECOND_UNEXPIRED_WALLET_NAME}
    Set Suite Variable    ${GIFT_ONLY_WALLET_USER_ALL_INIT_BALANCE}
    Set Suite Variable    ${USER_ID_FOR_SPLIT_SPEND}
    Set Suite Variable    ${SPLIT_SPEND_WALLET_USER_ALL_INIT_BALANCE}
    Set Suite Variable    ${USER_ID_WITH_DEFAULT_WALLET}
    Set Suite Variable    ${ONLY_DEFAULT_WALLET_USER_ALL_INIT_BALANCE}
    Set Suite Variable    ${USER_ID_WITH_DEFAULT_ONLY_CASHOUTABLE_WALLET}
    Set Suite Variable    ${ONLY_CASHOUTABLE_WALLET_USER_ALL_INIT_BALANCE}
    Set Suite Variable    ${USER_ID_WITH_DEFAULT_ONLY_NON_CASHOUTABLE_WALLET}
    Set Suite Variable    ${ONLY_NON_CASHOUTABLE_WALLET_USER_ALL_INIT_BALANCE}
    Set Suite Variable    ${USER_ID_ONLY_EXPIRED_WALLET}
    Set Suite Variable    ${ONLY_EXPIRED_WALLET_USER_WALLET_NAME}
    Set Suite Variable    ${ONLY_EXPIRED_WALLET_USER_ALL_INIT_BALANCE}
    Set Suite Variable    ${USER_ID_FOR_INVALID_SCENARIO}
    Set Suite Variable    ${USER_FOR_INVALID_SCENARIO_UNEXPIRED_WALLET_NAME}
    Set Suite Variable    ${USER_WALLET_FOR_INVALID_SCENARIO_ALL_INIT_BALANCE}
    Set Suite Variable    ${USER_ID_MULTI_TYPE_WALLET_FOR_REVERSE}
    Set Suite Variable    ${MULTI_TYPE_USER_EXPIRED_WALLET_NAME_FOR_REVERSE}
    Set Suite Variable    ${MULTI_TYPE_USER_UNEXPIRED_WALLET_NAME_ZERO_AMOUNT_FOR_REVERSE}
    Set Suite Variable    ${MULTI_TYPE_USER_UNEXPIRED_WALLET_NAME_FOR_REVERSE}
    Set Suite Variable    ${MULTI_TYPE_WALLET_USER_FOR_REVERSE_ALL_INIT_BALANCE}
    Set Suite Variable    ${MULTI_TYPE_WALLET_USER_EXPIRED_WALLET_FOR_REVERSE_INIT_BALANCE}
    Set Suite Variable    ${USER_ID_WITHOUT_WALLET}
    Set Suite Variable    ${USER_ID_OLD_API_SCENARIO}
    Set Suite Variable    ${OLD_API_SCENARIO_USER_UNEXPIRED_WALLET_NAME}
    Set Suite Variable    ${OLD_API_SCENARIO_USER_ALL_INIT_BALANCE}
    Set Suite Variable    ${USER_ID_VERIFY_SCENARIO}
    Set Suite Variable    ${VERIFY_SCENARIO_USER_UNEXPIRED_WALLET_NAME}
    Set Suite Variable    ${VERIFY_SCENARIO_USER_ALL_INIT_BALANCE}
    Set Suite Variable    ${USER_ID_REPEATED_VERIFY_SCENARIO}
    Set Suite Variable    ${REPEATED_VERIFY_SCENARIO_USER_UNEXPIRED_WALLET_NAME}
    Set Suite Variable    ${REPEATED_VERIFY_SCENARIO_USER_ALL_INIT_BALANCE}
    Set Suite Variable    ${INIT_BUSINESS_ID}
    Set Suite Variable    ${BUSINESS_ID_FOR_SPLIT_SPEND}

Get A Fresh User
    [Documentation]    Return a fresh user that have only default wallet with amount zero.
    ...    NOTE: `${user_cell_number_prefix}` length must be equal 7.
    [Arguments]    ${user_cell_number_prefix}
    ${cell_number_prefix_length}    Get Length    ${user_cell_number_prefix}
    IF    ${cell_number_prefix_length} != 7
        Fail    msg=Cell Number Prefix Length Must Be Equal 7 but Found: ${cell_number_prefix_length}.
    END

    ${fresh_user_id}    Set Variable    ${EMPTY}
    WHILE    True    limit=50
        ${random_number}    Random Int    1111    9999
        ${user_cell_number}    Set Variable    ${user_cell_number_prefix}${random_number}
        ${user_id}    Login To App    ${user_cell_number}
        ${user_wallets}    Give User Total Wallet Balances    ${user_id}
        ${wallet_count}    Get Length    ${user_wallets['balance_list']}
        IF    ${wallet_count} == 0 and ${user_wallets['total_balance']} == 0
            ${fresh_user_id}    Set Variable    ${user_id}
            BREAK
        END
    END

    IF    '${fresh_user_id}' == '${EMPTY}'
        Fail    msg=Failed to Create A Fresh User With
    END

    RETURN    ${fresh_user_id}

Create Definition
    [Arguments]    ${definition_name}    ${description}

    ${result}    POST Wallets Definitions Users
    ...    ${MICROSERVICE_SIDE}
    ...    ${definition_name}
    ...    ${description}

    Should Be Equal As Integers
    ...    ${result['status_code']}
    ...    200
    ...    msg=Failed to create definition. result: ${result['body']}

Create User Wallet
    [Arguments]    ${definition_name}    ${wallet_name}    ${user_id}    ${expiration_date}

    ${wallet_based_on_definition}    Set Variable    ${definition_name}_${wallet_name}
    ${result}    POST Wallets Users
    ...    ${MICROSERVICE_SIDE}
    ...    ${user_id}
    ...    ${wallet_based_on_definition}
    ...    ${expiration_date}

    Should Be Equal As Integers
    ...    ${result['status_code']}
    ...    200
    ...    msg=Failed to create wallet: ${wallet_name} for user: ${user_id}. result: ${result['body']}
    RETURN    ${wallet_based_on_definition}

Create Business
    Login To Dashboard    ${DASHBOARD_USERNAME}    ${DASHBOARD_PASSWORD}
    ${random_color}    FakerLibrary.Color Name
    ${random_name}    FakerLibrary.First Name
    ${name}    Catenate    Test-${random_color}-${random_name}
    ${username}    FakerLibrary.Username
    ${password}    FakerLibrary.Password
    @{role_list}    Create List    BUSINESS_ADMIN
    ${response}    POST Admin Businesses
    ...    ${DASHBOARD_SIDE}
    ...    ${name}
    ...    ${username}
    ...    ${password}
    ...    ${role_list}
    Should Be Equal As Integers
    ...    200
    ...    ${response['status_code']}
    ...    msg=Business initialization failed with status code: ${response['status_code']}
    RETURN    ${response['business_id']}

Create Business Wallet
    [Arguments]    ${business_id}    ${wallet_name}
    ${is_wallet_added}    POST Admin Wallets Businesses
    ...    ${DASHBOARD_SIDE}
    ...    ${business_id}
    ...    ${wallet_name}
    ...    ${CURRENCY_IRR}
    Should Be True    ${is_wallet_added}    msg=Wallet Not Added in Busienss.

Cash-in To Business Wallet
    [Arguments]    ${business_id}    ${wallet_name}    ${amount}
    ${ref_number}    Generate Random String    18    [LOWER]
    ${providerCode}    FakerLibrary.Color Name
    ${response}    POST Admin Wallets Businesses Cash-in
    ...    ${DASHBOARD_SIDE}
    ...    ${business_id}
    ...    ${wallet_name}
    ...    ${amount}
    ...    ${ref_number}
    ...    ${providerCode}
    Dictionary Should Contain Key
    ...    ${response['body']}
    ...    trackingCode
    ...    msg=Cash-in result failed and should be contain trackingCode. responseBody: ${response['body']}

Payout To User Wallet
    [Arguments]
    ...    ${business_id}
    ...    ${business_wallet_name}
    ...    ${user_id}
    ...    ${user_wallet_name}
    ...    ${amount}
    ...    ${cashoutable_amount}

    ${description}    Set Variable
    ...    Payout from ${business_id} with wallet ${business_wallet_name} to user ${user_id} with wallet ${user_wallet_name}
    ${sale_tracking_code}    Generate Random String    16
    ${result}    POST Transactions Payout
    ...    ${MICROSERVICE_SIDE}
    ...    ${amount}
    ...    ${business_id}
    ...    ${business_wallet_name}
    ...    ${user_id}
    ...    ${user_wallet_name}
    ...    ${cashoutable_amount}
    ...    ${sale_tracking_code}
    ...    ${description}

    Should Be Equal As Integers
    ...    ${result['status_code']}
    ...    200
    ...    msg=Failed to payout. result: ${result['body']}

Give User Total Wallet Balances
    [Tags]    robot:private
    [Arguments]    ${wallet_user_id}
    ${response}    GET Wallets Users Balances    ${MICROSERVICE_SIDE}    ${wallet_user_id}

    ${total_balance}    Set Variable    0
    FOR    ${wallet}    IN    @{response['body']['balances']}
        IF    ${wallet['balance']} >= 1
            ${total_balance}    Evaluate    ${total_balance} + ${wallet['balance']}
        END
    END
    ${result}    Create Dictionary    total_balance=${total_balance}    balance_list=${response['body']['balances']}
    RETURN    ${result}

Give User Wallet Balance
    [Tags]    robot:private
    [Arguments]    ${wallet_user_id}    ${wallet_name}

    ${response}    GET Wallets Users Balance    ${MICROSERVICE_SIDE}    ${wallet_user_id}    ${wallet_name}
    RETURN    ${response['body']}
