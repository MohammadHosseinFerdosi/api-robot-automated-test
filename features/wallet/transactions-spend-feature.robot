*** Settings ***
Resource        steps/wallet/transactions/transactions-spend-step.resource
Resource        steps/wallet/transactions/transactions-spend-initialization.resource

Suite Setup     Initialize Business And User


*** Test Cases ***
Spend From Multi Types Wallets
    [Tags]    severity:high  robot:skip
    When Spend From User To Business
    ...    ${USER_ID_MULTI_TYPE_WALLET}
    ...    ${MULTI_TYPE_WALLET_USER_ALL_INIT_BALANCE['total_balance']}
    ...    ${INIT_BUSINESS_ID}
    ...    ${B_WALLET_FOR_SPEND_MULTI_TYPE}
    Then User Unexpired Wallet And Default Wallet Amount Should Be Decreased
    ...    ${USER_ID_MULTI_TYPE_WALLET}
    And Wallet Amount Should Not Be Decreased
    ...    ${USER_ID_MULTI_TYPE_WALLET}
    ...    ${MULTI_TYPE_USER_EXPIRED_WALLET_NAME}
    ...    ${MULTI_TYPE_WALLET_USER_EXPIRED_WALLET_INIT_BALANCE['balance']}
    And Business Wallet Amount Should Be Increased
    ...    ${INIT_BUSINESS_ID}
    ...    ${B_WALLET_FOR_SPEND_MULTI_TYPE}
    ...    ${EXPECTED_WALLET_SPEND_AMOUNT}
    And Spend Inquiry Status Should Be    ${INQUIRY_SUCCESS_STATE}

Spend To Multi Businesses
    [Tags]    severity:high  robot:skip
    When Spend From User Wallet To Multi Business
    ...    ${USER_ID_FOR_SPLIT_SPEND}
    ...    ${SPLIT_SPEND_WALLET_USER_ALL_INIT_BALANCE}
    ...    ${INIT_BUSINESS_ID}
    ...    ${B_WALLET_FOR_SPLIT_SPEND_BUSINESS}
    ...    ${BUSINESS_ID_FOR_SPLIT_SPEND}
    ...    ${B_WALLET_FOR_SPLIT_SPEND_BUSINESS}
    Then User Unexpired Wallet And Default Wallet Amount Should Be Decreased
    ...    ${USER_ID_FOR_SPLIT_SPEND}
    And Business Wallet Amount Should Be Increased
    ...    ${INIT_BUSINESS_ID}
    ...    ${B_WALLET_FOR_SPLIT_SPEND_BUSINESS}
    ...    ${MAIN_BUSINESS_SPEND_AMOUNT}
    And Business Wallet Amount Should Be Increased
    ...    ${BUSINESS_ID_FOR_SPLIT_SPEND}
    ...    ${B_WALLET_FOR_SPLIT_SPEND_BUSINESS}
    ...    ${SECOND_BUSINESS_SPEND_AMOUNT}
    And Spend Inquiry Status Should Be    ${INQUIRY_SUCCESS_STATE}

Spend From User With Only Gift Type Wallet
    [Tags]    severity:high   robot:skip
    When Spend From User To Business
    ...    ${USER_ID_ONLY_GIFT_WALLET}
    ...    ${GIFT_ONLY_WALLET_USER_ALL_INIT_BALANCE['total_balance']}
    ...    ${INIT_BUSINESS_ID}
    ...    ${B_WALLET_FOR_SPEND_GIFT_ONLY_TYPE}
    Then All Wallet Amount Should Be Decreased
    ...    ${USER_ID_ONLY_GIFT_WALLET}
    ...    ${EXPECTED_REMAINING_BALANCE}
    And Business Wallet Amount Should Be Increased
    ...    ${INIT_BUSINESS_ID}
    ...    ${B_WALLET_FOR_SPEND_GIFT_ONLY_TYPE}
    ...    ${EXPECTED_WALLET_SPEND_AMOUNT}

Spend All Amount From User
    [Tags]    severity:high   robot:skip
    When Spend From User To Business
    ...    ${USER_ID_MULTI_TYPE_WALLET_SPEND_ALL}
    ...    ${SPEND_ALL_WALLET_USER_ALL_INIT_BALANCE['total_balance']}
    ...    ${INIT_BUSINESS_ID}
    ...    ${B_WALLET_FOR_SPEND_ALL_AMOUNT}
    ...    spend_all_amount=${True}
    Then All Wallet Amount Should Be Decreased
    ...    ${USER_ID_MULTI_TYPE_WALLET_SPEND_ALL}
    ...    0
    And Business Wallet Amount Should Be Increased
    ...    ${INIT_BUSINESS_ID}
    ...    ${B_WALLET_FOR_SPEND_ALL_AMOUNT}
    ...    ${EXPECTED_WALLET_SPEND_AMOUNT}

Spend From Default Wallet
    [Tags]    severity:high   robot:skip
    When Spend From User To Business
    ...    ${USER_ID_WITH_DEFAULT_WALLET}
    ...    ${ONLY_DEFAULT_WALLET_USER_ALL_INIT_BALANCE['total_balance']}
    ...    ${INIT_BUSINESS_ID}
    ...    ${B_WALLET_FOR_SPEND_DEFAULT_WALLET}
    Then User Unexpired Wallet And Default Wallet Amount Should Be Decreased
    ...    ${USER_ID_WITH_DEFAULT_WALLET}
    And Business Wallet Amount Should Be Increased
    ...    ${INIT_BUSINESS_ID}
    ...    ${B_WALLET_FOR_SPEND_DEFAULT_WALLET}
    ...    ${EXPECTED_WALLET_SPEND_AMOUNT}

Spend From Default Wallet Only With Non-Cashoutable
    [Tags]    severity:high   robot:skip
    When Spend From User To Business
    ...    ${USER_ID_WITH_DEFAULT_ONLY_NON_CASHOUTABLE_WALLET}
    ...    ${ONLY_NON_CASHOUTABLE_WALLET_USER_ALL_INIT_BALANCE['total_balance']}
    ...    ${INIT_BUSINESS_ID}
    ...    ${B_WALLET_FOR_SPEND_DEFAULT_NONCASHOUTABLE}
    Then Wallet Amount Should Be Decreased
    ...    ${USER_ID_WITH_DEFAULT_ONLY_NON_CASHOUTABLE_WALLET}
    ...    ${USER_DEFAULT_WALLET}
    ...    ${EXPECTED_REMAINING_BALANCE}
    And Business Wallet Amount Should Be Increased
    ...    ${INIT_BUSINESS_ID}
    ...    ${B_WALLET_FOR_SPEND_DEFAULT_NONCASHOUTABLE}
    ...    ${EXPECTED_WALLET_SPEND_AMOUNT}

Spend From Default Wallet Only With Cashoutable
    [Tags]    severity:high   robot:skip
    When Spend From User To Business
    ...    ${USER_ID_WITH_DEFAULT_ONLY_CASHOUTABLE_WALLET}
    ...    ${ONLY_CASHOUTABLE_WALLET_USER_ALL_INIT_BALANCE['total_balance']}
    ...    ${INIT_BUSINESS_ID}
    ...    ${B_WALLET_FOR_SPEND_DEFAULT_CASHOUTABLE}
    Then Wallet Amount Should Be Decreased
    ...    ${USER_ID_WITH_DEFAULT_ONLY_CASHOUTABLE_WALLET}
    ...    ${USER_DEFAULT_WALLET}
    ...    ${EXPECTED_REMAINING_BALANCE}
    And Business Wallet Amount Should Be Increased
    ...    ${INIT_BUSINESS_ID}
    ...    ${B_WALLET_FOR_SPEND_DEFAULT_CASHOUTABLE}
    ...    ${EXPECTED_WALLET_SPEND_AMOUNT}

Spend From Only expired Time-Bound Wallet
    [Tags]    severity:high   robot:skip
    When Spend From User To Business
    ...    ${USER_ID_ONLY_EXPIRED_WALLET}
    ...    ${ONLY_EXPIRED_WALLET_USER_ALL_INIT_BALANCE['balance']}
    ...    ${INIT_BUSINESS_ID}
    ...    ${B_WALLET_FOR_SPEND_EXPIRED_WALLET}
    Then Spend Should Be Failed With    ${SPEND_WALLET_USER_NOT_FOUND_WALLET_FAILURE_CONTENT}
    And Wallet Amount Should Not Be Decreased
    ...    ${USER_ID_ONLY_EXPIRED_WALLET}
    ...    ${ONLY_EXPIRED_WALLET_USER_WALLET_NAME}
    ...    ${ONLY_EXPIRED_WALLET_USER_ALL_INIT_BALANCE['balance']}
    And Business Wallet Amount Should Not Be Increased
    ...    ${INIT_BUSINESS_ID}
    ...    ${B_WALLET_FOR_SPEND_EXPIRED_WALLET}

Spend From A User Without Wallet
    [Tags]    severity:high   robot:skip
    When Spend From User To Business
    ...    ${USER_ID_WITHOUT_WALLET}
    ...    ${INVALID_TOTAL_BALANCE}
    ...    ${INIT_BUSINESS_ID}
    ...    ${B_WALLET_FOR_SPEND_INVALID_SCENARIO}
    Then Spend Should Be Failed With    ${SPEND_WALLET_USER_NOT_FOUND_WALLET_FAILURE_CONTENT}
    And Business Wallet Amount Should Not Be Increased
    ...    ${INIT_BUSINESS_ID}
    ...    ${B_WALLET_FOR_SPEND_INVALID_SCENARIO}

Spend From Undefined User
    [Tags]    severity:medium   robot:skip
    When Spend From User To Business
    ...    ${INVALID_USER_ID}
    ...    ${INVALID_TOTAL_BALANCE}
    ...    ${INIT_BUSINESS_ID}
    ...    ${B_WALLET_FOR_SPEND_INVALID_SCENARIO}
    Then Spend Should Be Failed With    ${SPEND_WALLET_USER_NOT_FOUND_WALLET_FAILURE_CONTENT}
    And Business Wallet Amount Should Not Be Increased
    ...    ${INIT_BUSINESS_ID}
    ...    ${B_WALLET_FOR_SPEND_INVALID_SCENARIO}

Spend To Undefined Business
    [Tags]    severity:medium   robot:skip
    When Spend From User To Business
    ...    ${USER_ID_FOR_INVALID_SCENARIO}
    ...    ${USER_WALLET_FOR_INVALID_SCENARIO_ALL_INIT_BALANCE['total_balance']}
    ...    ${INVALID_BUSINESS_ID}
    ...    ${B_WALLET_FOR_SPEND_INVALID_SCENARIO}
    Then Spend Should Be Failed With    ${SPEND_WALLET_USER_NOT_FOUND_WALLET_FAILURE_CONTENT}
    And All Wallet Amount Should Be Decreased
    ...    ${USER_ID_FOR_INVALID_SCENARIO}
    ...    ${USER_WALLET_FOR_INVALID_SCENARIO_ALL_INIT_BALANCE['total_balance']}

Spend To Undefined Business Wallet
    [Tags]    severity:medium   robot:skip
    When Spend From User To Business
    ...    ${USER_ID_FOR_INVALID_SCENARIO}
    ...    ${USER_WALLET_FOR_INVALID_SCENARIO_ALL_INIT_BALANCE['total_balance']}
    ...    ${INIT_BUSINESS_ID}
    ...    ${INVALID_BUSINESS_WALLET_NAME}
    Then Spend Should Be Failed With    ${SPEND_WALLET_USER_NOT_FOUND_WALLET_FAILURE_CONTENT}
    And All Wallet Amount Should Be Decreased
    ...    ${USER_ID_FOR_INVALID_SCENARIO}
    ...    ${USER_WALLET_FOR_INVALID_SCENARIO_ALL_INIT_BALANCE['total_balance']}

Spend To Multi Business With A Undefined Main Business In Splited Section
    [Tags]    severity:medium   robot:skip
    When Spend From User Wallet To Multi Business
    ...    ${USER_ID_FOR_INVALID_SCENARIO}
    ...    ${USER_WALLET_FOR_INVALID_SCENARIO_ALL_INIT_BALANCE}
    ...    ${INVALID_BUSINESS_ID}
    ...    ${B_WALLET_FOR_SPEND_INVALID_SCENARIO}
    ...    ${BUSINESS_ID_FOR_SPLIT_SPEND}
    ...    ${B_WALLET_FOR_SPEND_INVALID_SCENARIO}
    Then Spend Should Be Failed With    ${SPEND_WALLET_USER_NOT_FOUND_WALLET_FAILURE_CONTENT}
    And Business Wallet Amount Should Not Be Increased
    ...    ${INIT_BUSINESS_ID}
    ...    ${B_WALLET_FOR_SPEND_INVALID_SCENARIO}
    And Business Wallet Amount Should Not Be Increased
    ...    ${BUSINESS_ID_FOR_SPLIT_SPEND}
    ...    ${B_WALLET_FOR_SPEND_INVALID_SCENARIO}
    And All Wallet Amount Should Not Be Decreased
    ...    ${USER_ID_FOR_INVALID_SCENARIO}
    ...    ${USER_WALLET_FOR_INVALID_SCENARIO_ALL_INIT_BALANCE['total_balance']}

Spend To Multi Business With A Undefined Other Business In Splited Section
    [Tags]    severity:medium   robot:skip
    When Spend From User Wallet To Multi Business
    ...    ${USER_ID_FOR_INVALID_SCENARIO}
    ...    ${USER_WALLET_FOR_INVALID_SCENARIO_ALL_INIT_BALANCE}
    ...    ${INIT_BUSINESS_ID}
    ...    ${B_WALLET_FOR_SPEND_INVALID_SCENARIO}
    ...    ${INVALID_BUSINESS_ID}
    ...    ${B_WALLET_FOR_SPEND_INVALID_SCENARIO}
    Then Spend Should Be Failed With    ${SPEND_WALLET_USER_NOT_FOUND_WALLET_FAILURE_CONTENT}
    And Business Wallet Amount Should Not Be Increased
    ...    ${INIT_BUSINESS_ID}
    ...    ${B_WALLET_FOR_SPEND_INVALID_SCENARIO}
    And All Wallet Amount Should Not Be Decreased
    ...    ${USER_ID_FOR_INVALID_SCENARIO}
    ...    ${USER_WALLET_FOR_INVALID_SCENARIO_ALL_INIT_BALANCE['total_balance']}

Spend To Multi Business With A Undefined Main Business
    [Tags]    severity:medium   robot:skip
    When Spend From User Wallet To Multi Business
    ...    ${USER_ID_FOR_INVALID_SCENARIO}
    ...    ${USER_WALLET_FOR_INVALID_SCENARIO_ALL_INIT_BALANCE}
    ...    ${INVALID_BUSINESS_ID}
    ...    ${B_WALLET_FOR_SPEND_INVALID_SCENARIO}
    ...    ${BUSINESS_ID_FOR_SPLIT_SPEND}
    ...    ${B_WALLET_FOR_SPEND_INVALID_SCENARIO}
    Then Spend Should Be Failed With    ${SPEND_WALLET_USER_NOT_FOUND_WALLET_FAILURE_CONTENT}
    And Business Wallet Amount Should Not Be Increased
    ...    ${INIT_BUSINESS_ID}
    ...    ${B_WALLET_FOR_SPEND_INVALID_SCENARIO}
    And Business Wallet Amount Should Not Be Increased
    ...    ${BUSINESS_ID_FOR_SPLIT_SPEND}
    ...    ${B_WALLET_FOR_SPEND_INVALID_SCENARIO}
    And All Wallet Amount Should Not Be Decreased
    ...    ${USER_ID_FOR_INVALID_SCENARIO}
    ...    ${USER_WALLET_FOR_INVALID_SCENARIO_ALL_INIT_BALANCE['total_balance']}

Spend To Multi Business With Amount Of Main Business In Split Section Upper Than Spend Amount
    [Tags]    severity:medium   robot:skip
    When Spend From User Wallet To Multi Business
    ...    ${USER_ID_FOR_INVALID_SCENARIO}
    ...    ${USER_WALLET_FOR_INVALID_SCENARIO_ALL_INIT_BALANCE}
    ...    ${INIT_BUSINESS_ID}
    ...    ${B_WALLET_FOR_SPEND_INVALID_SCENARIO}
    ...    ${BUSINESS_ID_FOR_SPLIT_SPEND}
    ...    ${B_WALLET_FOR_SPEND_INVALID_SCENARIO}
    ...    main_splited_business_amount=${SPEND_AMOUNT_UPPER_THAN_TOTAL_AMOUNT}
    Then Spend Should Be Failed With
    ...    ${SPEND_AMOUNT_UPPER_THAN_TOTAL_AMOUNT_FAILURE_CONTENT}
    And Business Wallet Amount Should Not Be Increased
    ...    ${INIT_BUSINESS_ID}
    ...    ${B_WALLET_FOR_SPEND_INVALID_SCENARIO}
    And Business Wallet Amount Should Not Be Increased
    ...    ${BUSINESS_ID_FOR_SPLIT_SPEND}
    ...    ${B_WALLET_FOR_SPEND_INVALID_SCENARIO}
    And All Wallet Amount Should Not Be Decreased
    ...    ${USER_ID_FOR_INVALID_SCENARIO}
    ...    ${USER_WALLET_FOR_INVALID_SCENARIO_ALL_INIT_BALANCE['total_balance']}

Spend To Multi Business With Amount Of Other Business In Split Section Upper Than Spend Amount
    [Tags]    severity:medium   robot:skip
    When Spend From User Wallet To Multi Business
    ...    ${USER_ID_FOR_INVALID_SCENARIO}
    ...    ${USER_WALLET_FOR_INVALID_SCENARIO_ALL_INIT_BALANCE}
    ...    ${INIT_BUSINESS_ID}
    ...    ${B_WALLET_FOR_SPEND_INVALID_SCENARIO}
    ...    ${BUSINESS_ID_FOR_SPLIT_SPEND}
    ...    ${B_WALLET_FOR_SPEND_INVALID_SCENARIO}
    ...    second_splited_business_amount=${SPEND_AMOUNT_UPPER_THAN_TOTAL_AMOUNT}
    Then Spend Should Be Failed With    ${SPEND_AMOUNT_UPPER_THAN_TOTAL_AMOUNT_FAILURE_CONTENT}
    And Business Wallet Amount Should Not Be Increased
    ...    ${INIT_BUSINESS_ID}
    ...    ${B_WALLET_FOR_SPEND_INVALID_SCENARIO}
    And Business Wallet Amount Should Not Be Increased
    ...    ${BUSINESS_ID_FOR_SPLIT_SPEND}
    ...    ${B_WALLET_FOR_SPEND_INVALID_SCENARIO}
    And All Wallet Amount Should Not Be Decreased
    ...    ${USER_ID_FOR_INVALID_SCENARIO}
    ...    ${USER_WALLET_FOR_INVALID_SCENARIO_ALL_INIT_BALANCE['total_balance']}

Spend From User With Upper Amount Of Total Balance
    [Tags]    severity:medium   robot:skip
    When Spend From User To Business
    ...    ${USER_ID_FOR_INVALID_SCENARIO}
    ...    ${SPEND_AMOUNT_UPPER_THAN_TOTAL_AMOUNT}
    ...    ${INIT_BUSINESS_ID}
    ...    ${B_WALLET_FOR_SPEND_INVALID_SCENARIO}
    Then Spend Should Be Failed With    ${SPEND_AMOUNT_UPPER_THAN_TOTAL_AMOUNT_FAILURE_CONTENT}
    And Business Wallet Amount Should Not Be Increased
    ...    ${INIT_BUSINESS_ID}
    ...    ${B_WALLET_FOR_SPEND_INVALID_SCENARIO}
    And All Wallet Amount Should Not Be Decreased
    ...    ${USER_ID_FOR_INVALID_SCENARIO}
    ...    ${USER_WALLET_FOR_INVALID_SCENARIO_ALL_INIT_BALANCE['total_balance']}

Reverse From Multi Type Wallet User To Multi Businesses And Verify After Pay Expired
    [Tags]    severity:high   robot:skip
    When Spend Without Verify From User Wallet To Multi Business
    ...    ${USER_ID_MULTI_TYPE_WALLET_FOR_REVERSE}
    ...    ${MULTI_TYPE_WALLET_USER_FOR_REVERSE_ALL_INIT_BALANCE}
    ...    ${INIT_BUSINESS_ID}
    ...    ${B_WALLET_FOR_SPEND_AND_REVERSE}
    ...    ${BUSINESS_ID_FOR_SPLIT_SPEND}
    ...    ${B_WALLET_FOR_SPEND_AND_REVERSE}
    Then User Unexpired Wallet And Default Wallet Amount Should Be Decreased
    ...    ${USER_ID_MULTI_TYPE_WALLET_FOR_REVERSE}
    And Spend Inquiry Status Should Be    ${INQUITY_PENDING_STATE}
    And Legacy Spend Inquiry Status Should Be    ${LEGACY_INQUITY_PENDING_STATE}
    When Wait For Spend Pay Transaction Expired
    And Spend Inquiry Status Should Be    ${INQUITY_FAILED_STATE}
    And Legacy Spend Inquiry Status Should Be    ${LEGACY_INQUITY_FAILED_STATE}
    And All Wallet Amount Should Not Be Decreased
    ...    ${USER_ID_MULTI_TYPE_WALLET_FOR_REVERSE}
    ...    ${MULTI_TYPE_WALLET_USER_FOR_REVERSE_ALL_INIT_BALANCE['total_balance']}
    And Wallet Amount Should Not Be Decreased
    ...    ${USER_ID_MULTI_TYPE_WALLET_FOR_REVERSE}
    ...    ${MULTI_TYPE_USER_EXPIRED_WALLET_NAME_FOR_REVERSE}
    ...    ${MULTI_TYPE_WALLET_USER_EXPIRED_WALLET_FOR_REVERSE_INIT_BALANCE['balance']}
    And Business Wallet Amount Should Not Be Increased
    ...    ${INIT_BUSINESS_ID}
    ...    ${B_WALLET_FOR_SPEND_AND_REVERSE}
    And Business Wallet Amount Should Not Be Increased
    ...    ${BUSINESS_ID_FOR_SPLIT_SPEND}
    ...    ${B_WALLET_FOR_SPEND_AND_REVERSE}
    When Verify Spend Transaction With
    ...    ${SPEND_PAY_TRACKING_CODE}
    ...    ${SPEND_PAY_CONFIRMATION_CODE}
    Then Verify Should Be Failed With
    ...    ${VERIFY_AFTER_PAY_EXPIRED_FAILURE_CONTENT}
    And Spend Inquiry Status Should Be    ${INQUITY_FAILED_STATE}
    And Legacy Spend Inquiry Status Should Be    ${LEGACY_INQUITY_FAILED_STATE}
    And Business Wallet Amount Should Not Be Increased
    ...    ${INIT_BUSINESS_ID}
    ...    ${B_WALLET_FOR_SPEND_AND_REVERSE}

    And Business Wallet Amount Should Not Be Increased
    ...    ${BUSINESS_ID_FOR_SPLIT_SPEND}
    ...    ${B_WALLET_FOR_SPEND_AND_REVERSE}

Spend With Old API From Multi Types Wallets
    [Tags]    severity:high   robot:skip
    When Legacy Spend From User To Business
    ...    ${USER_ID_OLD_API_SCENARIO}
    ...    ${OLD_API_SCENARIO_USER_ALL_INIT_BALANCE['total_balance']}
    ...    ${INIT_BUSINESS_ID}
    Then User Unexpired Wallet And Default Wallet Amount Should Be Decreased
    ...    ${USER_ID_OLD_API_SCENARIO}
    And Legacy Spend Inquiry Status Should Be    ${LEGACY_INQUIRY_SUCCESS_STATE}
    And Business Wallet Amount Should Be Increased
    ...    ${INIT_BUSINESS_ID}
    ...    ${B_WALLET_FOR_SPEND_OLD_API}
    ...    ${EXPECTED_WALLET_SPEND_AMOUNT}

Verify Spend Transaction With Invalid Tracking Code And Confirmation Code
    [Tags]    severity:medium   robot:skip
    Given Spend Without Verify From User To Business
    ...    ${USER_ID_VERIFY_SCENARIO}
    ...    ${VERIFY_SCENARIO_USER_ALL_INIT_BALANCE['total_balance']}
    ...    ${INIT_BUSINESS_ID}
    ...    ${B_WALLET_FOR_SPEND_INVALID_SCENARIO}
    When Verify Spend Transaction With
    ...    ${INVALID_TRACKING_CODE}
    ...    ${SPEND_PAY_CONFIRMATION_CODE}
    Then Verify Should Be Failed With
    ...    ${VERIFY_WITH_INVALID_TRACKING_CODE_FAILURE_CONTENT}
    And Business Wallet Amount Should Not Be Increased
    ...    ${INIT_BUSINESS_ID}
    ...    ${B_WALLET_FOR_SPEND_INVALID_SCENARIO}
    When Verify Spend Transaction With
    ...    ${SPEND_PAY_TRACKING_CODE}
    ...    ${INVALID_CONFIRMATION_CODE}
    Then Verify Should Be Failed With
    ...    ${VERIFY_WITH_INVALID_CONFIRMATION_CODE_FAILURE_CONTENT}
    And Spend Inquiry Status Should Be    ${INQUITY_PENDING_STATE}
    And Business Wallet Amount Should Not Be Increased
    ...    ${INIT_BUSINESS_ID}
    ...    ${B_WALLET_FOR_SPEND_INVALID_SCENARIO}

Repetitive Verify Spend Transaction Before Pay Expired
    [Tags]    severity:low   robot:skip
    Given Spend Without Verify From User To Business
    ...    ${USER_ID_REPEATED_VERIFY_SCENARIO}
    ...    ${REPEATED_VERIFY_SCENARIO_USER_ALL_INIT_BALANCE['total_balance']}
    ...    ${INIT_BUSINESS_ID}
    ...    ${B_WALLET_FOR_VERIFY_SCENARIO}
    And Verify Spend Transaction With
    ...    ${SPEND_PAY_TRACKING_CODE}
    ...    ${SPEND_PAY_CONFIRMATION_CODE}
    And Spend Inquiry Status Should Be    ${INQUIRY_SUCCESS_STATE}
    And Business Wallet Amount Should Be Increased
    ...    ${INIT_BUSINESS_ID}
    ...    ${B_WALLET_FOR_VERIFY_SCENARIO}
    ...    expected_amount=${EXPECTED_WALLET_SPEND_AMOUNT}
    When Verify Spend Transaction With
    ...    ${SPEND_PAY_TRACKING_CODE}
    ...    ${SPEND_PAY_CONFIRMATION_CODE}
    Then Business Wallet Amount Should Not Be Increased
    ...    ${INIT_BUSINESS_ID}
    ...    ${B_WALLET_FOR_VERIFY_SCENARIO}
    ...    expected_amount=${EXPECTED_WALLET_SPEND_AMOUNT}
    And Spend Inquiry Status Should Be    ${INQUIRY_SUCCESS_STATE}
