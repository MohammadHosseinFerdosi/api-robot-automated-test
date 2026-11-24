*** Settings ***
Library         library/faker_utils.py    WITH NAME    FakerLibrary
Resource        apis/wallet-provider/wallets/get-wallets-users-balances.resource
Resource        apis/wallet-provider/wallets/get-wallets-users-balance.resource
Resource        apis/wallet-provider/wallets/get-wallets-businesses-balance.resource
Resource        apis/wallet-provider/transactions/post-transactions-spend-pay.resource
Resource        apis/wallet-provider/transactions/get-transactions-spend.resource
Resource        apis/wallet-provider/transactions/post-transactions-spend-verify.resource
Resource        apis/wallet-provider/transactions-legacy/post-wallets-spend.resource
Resource        apis/wallet-provider/transactions-legacy/post-wallets-spend-verify.resource
Resource        apis/wallet-provider/transactions-legacy/get-wallets-spend-inquiry.resource
Variables       data/wallet/transactions/transactions-spend-variables.yaml


*** Keywords ***
Spend Without Verify From User Wallet To Multi Business
    [Arguments]
    ...    ${user_id}
    ...    ${user_wallets_init_balance}
    ...    ${main_business_id}
    ...    ${main_business_wallet}
    ...    ${second_business_id}
    ...    ${second_business_wallet}

    Spend From User Wallet To Multi Business
    ...    ${user_id}
    ...    ${user_wallets_init_balance}
    ...    ${main_business_id}
    ...    ${main_business_wallet}
    ...    ${second_business_id}
    ...    ${second_business_wallet}
    ...    disable_verify_arg=${True}

Spend From User Wallet To Multi Business
    [Arguments]
    ...    ${user_id}
    ...    ${user_wallets_init_balance}
    ...    ${main_business_id}
    ...    ${main_business_wallet}
    ...    ${second_business_id}
    ...    ${second_business_wallet}
    ...    ${main_splited_business_amount}=${EMPTY}
    ...    ${second_splited_business_amount}=${EMPTY}
    ...    ${disable_verify_arg}=${False}

    ${EXPECTED_REMAINING_BALANCE}    Random Int    10    20
    ${spend_amount}    Evaluate
    ...    ${user_wallets_init_balance['total_balance']} - ${EXPECTED_REMAINING_BALANCE}
    ${SECOND_BUSINESS_SPEND_AMOUNT}    Random Int    10    20
    ${MAIN_BUSINESS_SPEND_AMOUNT}    Evaluate    ${spend_amount} - ${SECOND_BUSINESS_SPEND_AMOUNT}

    # For Invalid Split Spend Scenarions
    IF    '${main_splited_business_amount}' != '${EMPTY}'
        ${MAIN_BUSINESS_SPEND_AMOUNT}    Convert To Integer    ${main_splited_business_amount}
    END
    IF    '${second_splited_business_amount}' != '${EMPTY}'
        ${SECOND_BUSINESS_SPEND_AMOUNT}    Convert To Integer    ${second_splited_business_amount}
    END

    @{split_businesses_list}    Create List
    ${main_business}    Create Dictionary
    ...    businessId=${main_business_id}
    ...    walletName=${main_business_wallet}
    ...    amount=${MAIN_BUSINESS_SPEND_AMOUNT}
    ${second_business}    Create Dictionary
    ...    businessId=${second_business_id}
    ...    walletName=${second_business_wallet}
    ...    amount=${SECOND_BUSINESS_SPEND_AMOUNT}
    Append To List    ${split_businesses_list}    ${main_business}
    Append To List    ${split_businesses_list}    ${second_business}

    ${pay_result}    POST Transactions Spend Pay
    ...    ${MICROSERVICE_SIDE}
    ...    ${user_id}
    ...    ${split_businesses_list}
    ...    ${CURRENCY_IRR}

    IF    ${pay_result['status_code']} == 200
        IF    ${disable_verify_arg} == ${False}
            ${verify_result}    POST Transactions Spend Verify
            ...    ${MICROSERVICE_SIDE}
            ...    ${pay_result['body']['trackingCode']}
            ...    ${pay_result['body']['confirmationCode']}
        END
        ${EXPECTED_WALLET_SPEND_AMOUNT}    Set Variable    ${spend_amount}
        ${SPEND_PAY_TRACKING_CODE}    Set Variable    ${pay_result['body']['trackingCode']}
        ${SPEND_PAY_CONFIRMATION_CODE}    Set Variable    ${pay_result['body']['confirmationCode']}
        Set Test Variable    ${EXPECTED_WALLET_SPEND_AMOUNT}
        Set Test Variable    ${EXPECTED_REMAINING_BALANCE}
        Set Test Variable    ${MAIN_BUSINESS_SPEND_AMOUNT}
        Set Test Variable    ${SECOND_BUSINESS_SPEND_AMOUNT}
        Set Test Variable    ${SPEND_PAY_TRACKING_CODE}
        Set Test Variable    ${SPEND_PAY_CONFIRMATION_CODE}
    ELSE
        ${SPEND_FAILURE_CONTENT}    Set Variable    ${pay_result['body']}
        Set Test Variable    ${SPEND_FAILURE_CONTENT}
    END

Spend Without Verify From User To Business
    [Arguments]
    ...    ${user_id}
    ...    ${user_total_balance}
    ...    ${business_id}
    ...    ${business_wallet_name}
    ...    ${spend_all_amount}=${False}

    Spend From User To Business
    ...    ${user_id}
    ...    ${user_total_balance}
    ...    ${business_id}
    ...    ${business_wallet_name}
    ...    spend_all_amount=${spend_all_amount}
    ...    disable_verify_arg=${True}

Spend From User To Business
    [Arguments]
    ...    ${user_id}
    ...    ${user_total_balance}
    ...    ${business_id}
    ...    ${business_wallet_name}
    ...    ${spend_all_amount}=${False}
    ...    ${disable_verify_arg}=${False}

    IF    ${spend_all_amount} == ${False}
        ${EXPECTED_REMAINING_BALANCE}    Random Int    10    20
    ELSE
        ${EXPECTED_REMAINING_BALANCE}    Set Variable    0
    END

    ${spend_amount}    Evaluate
    ...    ${user_total_balance} - ${EXPECTED_REMAINING_BALANCE}

    @{spend_destination_list}    Create List
    ${main_business}    Create Dictionary
    ...    businessId=${business_id}
    ...    walletName=${business_wallet_name}
    ...    amount=${spend_amount}
    Append To List    ${spend_destination_list}    ${main_business}

    ${pay_result}    POST Transactions Spend Pay
    ...    ${MICROSERVICE_SIDE}
    ...    ${user_id}
    ...    ${spend_destination_list}
    ...    ${CURRENCY_IRR}

    IF    ${pay_result['status_code']} == 200
        IF    ${disable_verify_arg} == ${False}
            ${verify_result}    POST Transactions Spend Verify
            ...    ${MICROSERVICE_SIDE}
            ...    ${pay_result['body']['trackingCode']}
            ...    ${pay_result['body']['confirmationCode']}
        END
        ${EXPECTED_WALLET_SPEND_AMOUNT}    Set Variable    ${spend_amount}
        ${SPEND_PAY_TRACKING_CODE}    Set Variable    ${pay_result['body']['trackingCode']}
        ${SPEND_PAY_CONFIRMATION_CODE}    Set Variable    ${pay_result['body']['confirmationCode']}
        Set Test Variable    ${EXPECTED_WALLET_SPEND_AMOUNT}
        Set Test Variable    ${EXPECTED_REMAINING_BALANCE}
        Set Test Variable    ${SPEND_PAY_TRACKING_CODE}
        Set Test Variable    ${SPEND_PAY_CONFIRMATION_CODE}
    ELSE
        ${SPEND_FAILURE_CONTENT}    Set Variable    ${pay_result['body']}
        Set Test Variable    ${SPEND_FAILURE_CONTENT}
    END

Legacy Spend From User To Business
    [Arguments]
    ...    ${user_id}
    ...    ${user_total_balance}
    ...    ${business_id}

    ${EXPECTED_REMAINING_BALANCE}    Random Int    10    20

    ${SPEND_PAY_TRACKING_CODE}    Generate Random String    25

    ${spend_amount}    Evaluate
    ...    ${user_total_balance} - ${EXPECTED_REMAINING_BALANCE}

    ${pay_result}    Legacy Pay And Verify
    ...    ${spend_amount}
    ...    ${user_id}
    ...    ${business_id}
    ...    ${SPEND_PAY_TRACKING_CODE}

    IF    ${pay_result['status_code']} == 200
        ${EXPECTED_WALLET_SPEND_AMOUNT}    Set Variable    ${spend_amount}
        Set Test Variable    ${EXPECTED_WALLET_SPEND_AMOUNT}
        Set Test Variable    ${EXPECTED_REMAINING_BALANCE}
        Set Test Variable    ${SPEND_PAY_TRACKING_CODE}
    END

User Unexpired Wallet And Default Wallet Amount Should Be Decreased
    [Documentation]    Compare total balance of a user with expected balance that after spend remained.
    ...    also check balance based on spend strategy for default wallet. first cashoutable should be
    ...    decreased after that, non-cashoutable
    [Arguments]    ${user_id}
    Compare User Wallet Balance With Expected Balance
    ...    ${user_id}
    ...    ${EXPECTED_REMAINING_BALANCE}
    ...    check_default_wallet=${True}

All Wallet Amount Should Be Decreased
    [Arguments]    ${user_id}    ${expected_balance}
    Compare User Wallet Balance With Expected Balance    ${user_id}    ${expected_balance}

All Wallet Amount Should Not Be Decreased
    [Arguments]    ${user_id}    ${expected_balance}
    Compare User Wallet Balance With Expected Balance    ${user_id}    ${expected_balance}

Wallet Amount Should Be Decreased
    [Arguments]    ${user_id}    ${wallet_name}    ${expected_balance}
    Compare User Wallet Balance With Expected Balance    ${user_id}    ${expected_balance}    ${wallet_name}

Wallet Amount Should Not Be Decreased
    [Arguments]    ${user_id}    ${wallet_name}    ${expected_balance}
    Compare User Wallet Balance With Expected Balance    ${user_id}    ${expected_balance}    ${wallet_name}

Compare User Wallet Balance With Expected Balance
    [Arguments]    ${user_id}    ${expected_balance}    ${wallet_name}=${EMPTY}    ${check_default_wallet}=${False}
    IF    '${wallet_name}' == '${EMPTY}'
        ${wallet_actual_balance}    User Total Walelt Balances    ${user_id}
        Should Be Equal As Integers
        ...    ${wallet_actual_balance['total_balance']}
        ...    ${expected_balance}
        IF    ${check_default_wallet} == ${True}
            FOR    ${wallet_balance}    IN    @{wallet_actual_balance['balance_list']}
                IF    '${wallet_balance['walletName']}' == 'default'
                    Should Be Equal As Integers
                    ...    ${wallet_balance['nonCashoutableBalance']}
                    ...    ${expected_balance}
                END
            END
        END
    ELSE
        ${wallet_actual_balance}    User Wallet Balance
        ...    ${user_id}
        ...    ${wallet_name}
        Should Be Equal As Integers
        ...    ${wallet_actual_balance['balance']}
        ...    ${expected_balance}
    END

Business Wallet Amount Should Be Increased
    [Arguments]    ${business_id}    ${business_wallet_name}    ${expected_amount}
    Compare Business Balances With Expected Balance    ${business_id}    ${business_wallet_name}    ${expected_amount}

Business Wallet Amount Should Not Be Increased
    [Arguments]    ${business_id}    ${business_wallet_name}    ${expected_amount}=0
    Compare Business Balances With Expected Balance    ${business_id}    ${business_wallet_name}    ${expected_amount}

Compare Business Balances With Expected Balance
    [Arguments]    ${business_id}    ${business_wallet_name}    ${expected_amount}
    ${result}    GET Wallets Businesses Balance    ${MICROSERVICE_SIDE}    ${business_id}    ${business_wallet_name}
    Should Be Equal As Integers
    ...    ${result['body']['balance']}
    ...    ${expected_amount}
    ...    msg=The Blanace of Business Wallet: ${business_wallet_name} Expected to: ${expected_amount} but found: ${result['body']['balance']}

Legacy Pay And Verify
    [Tags]    robot:private
    [Arguments]
    ...    ${spend_amount}
    ...    ${source_user_id}
    ...    ${business_id}
    ...    ${tracking_code}

    ${pay_result}    POST Wallets Spend
    ...    ${MICROSERVICE_SIDE}
    ...    ${spend_amount}
    ...    ${source_user_id}
    ...    ${business_id}
    ...    ${tracking_code}

    ${verify_result}    POST Wallets Spend Verify
    ...    ${MICROSERVICE_SIDE}
    ...    ${tracking_code}
    ...    ${pay_result['body']['token']}

    RETURN    ${pay_result}

Verify Spend Transaction With
    [Arguments]    ${tracking_code}    ${confirmation_code}
    ${verify_result}    POST Transactions Spend Verify
    ...    ${MICROSERVICE_SIDE}
    ...    ${tracking_code}
    ...    ${confirmation_code}
    IF    ${verify_result['status_code']} != 200
        ${VERIFY_FAILURE_CONTENT}    Set Variable    ${verify_result['body']}
        Set Test Variable    ${VERIFY_FAILURE_CONTENT}
    END

User Total Walelt Balances
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

User Wallet Balance
    [Tags]    robot:private
    [Arguments]    ${wallet_user_id}    ${wallet_name}

    ${response}    GET Wallets Users Balance    ${MICROSERVICE_SIDE}    ${wallet_user_id}    ${wallet_name}
    RETURN    ${response['body']}

Spend Should Be Failed With
    [Arguments]    ${failure_content}
    Dictionaries Should Be Equal    ${SPEND_FAILURE_CONTENT['result']}    ${failure_content}

Verify Should Be Failed With
    [Arguments]    ${failure_content}
    Dictionaries Should Be Equal    ${VERIFY_FAILURE_CONTENT['result']}    ${failure_content}

Wait For Spend Pay Transaction Expired
    Sleep    ${SPEND_PAY_MAX_DELAY_EXPIRATION_SECONDS}

Legacy Spend Inquiry Status Should Be
    [Arguments]    ${expected_inquiry_status}
    ${result}    GET Wallets Spend Inquiry    ${MICROSERVICE_SIDE}    ${SPEND_PAY_TRACKING_CODE}
    Should Be Equal As Strings
    ...    ${result['body']['status']}
    ...    ${expected_inquiry_status}
    ...    msg=Inquiry status should be ${expected_inquiry_status} but found: ${result['body']['status']}.
    Should Be Equal As Integers
    ...    ${result['body']['amount']}
    ...    ${EXPECTED_WALLET_SPEND_AMOUNT}
    ...    msg=Inquiry amount should be same as spend amount but found: ${result['body']['amount']}

Spend Inquiry Status Should Be
    [Arguments]    ${expected_inquiry_status}
    ${result}    GET Transactions Spend    ${MICROSERVICE_SIDE}    ${SPEND_PAY_TRACKING_CODE}
    Should Be Equal As Strings
    ...    ${result['body']['status']}
    ...    ${expected_inquiry_status}
    ...    msg=Inquiry status should be ${expected_inquiry_status} but found: ${result['body']['status']}.
    Should Be Equal As Integers
    ...    ${result['body']['amount']}
    ...    ${EXPECTED_WALLET_SPEND_AMOUNT}
    ...    msg=Inquiry amount should be same as spend amount but found: ${result['body']['amount']}
    Should Be Equal As Integers
    ...    ${result['body']['confirmationCode']}
    ...    ${SPEND_PAY_CONFIRMATION_CODE}
    ...    msg=Inquiry amount should be same as spend amount but found: ${result['body']['confirmationCode']}
