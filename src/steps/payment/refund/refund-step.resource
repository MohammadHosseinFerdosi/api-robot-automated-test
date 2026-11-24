*** Settings ***
Library         library/faker_utils.py    WITH NAME    FakerLibrary
Resource        services/backend/auth-service.resource
Resource        services/backend/user-wallet-initializer-service.resource
Resource        services/backend/purchases.resource
Resource        apis/purchase-mng/refund/post-purchase-refund.resource
Resource        apis/wallet-provider/transactions/get-transactions-payout.resource
Variables       data/payment/purchase/refund.yaml
Resource        services/backend/value-handler.resource


*** Keywords ***
Login For Source Business
    [Documentation]    login by new business and set its access token as test variable for creating a purchase and refund
    Login For Business    ${REFUND_TEST_BUSINESS_USER_NAME}    ${REFUND_TEST_BUSINESS_PASS_WORD}

Create Verified Wallet Purchase
    [Arguments]    ${user_cell_number}    ${purchase_amount}
    ${SALE_TRACKING_CODE}    Create Verified Wallet Purchase For Exsisting User
    ...    ${user_cell_number}
    ...    ${purchase_amount}
    Set Test Variable    ${SALE_TRACKING_CODE}

Auto Refund
    [Documentation]    Auto refund based on purchase sale tracking code
    [Arguments]    ${user_id}    ${refund_amount}

    ${user_balances}    GET Wallets Users Balances    ${MICROSERVICE_SIDE}    ${user_id}
    Set Test Variable    ${USER_WALLET_BALANCE_BEFORE_REFUND}    ${user_balances['body']['balances']}

    ${business_balance}    GET Wallets Businesses Balance
    ...    ${MICROSERVICE_SIDE}
    ...    ${REFUND_TEST_BUSINESS_ID}
    ...    ${B_WALLET_REFUND_DEFINITION}
    Set Test Variable    ${BUSINESS_REFUND_WALLET_BALANCE_BEFORE_REFUND}    ${business_balance['body']['balance']}

    ${provider_id}    Generate Random String    15    0123456789
    ${description}    Set Variable    "Auto refund"

    ${response}    Post Purchase Refund
    ...    ${GENERAL_SIDE}
    ...    amount=${refund_amount}
    ...    business_id=${REFUND_TEST_BUSINESS_ID}
    ...    sale_tracking_code=${SALE_TRACKING_CODE}
    ...    provider_id=${provider_id}
    ...    description=${description}
    ...    type=${REFUND_TYPE}

    Should Be Equal As Integers
    ...    ${response['status_code']}
    ...    200
    ...    msg=Auto refund failed

    Set Test Variable    ${REFUND_PARENT_TRACKING_CODE}    ${response['body']['trackingCode']}

Correct Refund Transaction Log Should Be Founded In Report Service
    [Arguments]    ${refund_amount}
    ${data_response}    Wait Until Keyword Succeeds    120 s    5 s    Find Final Status Code
    Should Be Equal As Integers    ${data_response['status_code']}    0
    Should Not Be Empty    ${data_response['body']}
    # Checking status to be succes
    Should Be Equal As Strings    ${data_response['body'][0]['status']}    0
    IF    ${data_response['body'][0]['type']} == 3
        Should Be Equal As Strings    ${data_response['body'][0]['gateway']}    4
    END
    # Checking amount to be equal to refund amount
    ${data_response_amount}    Value Handler    ${data_response['body'][0]['amount']}
    ${amount}    Evaluate    int(${data_response_amount})
    Should Be Equal As Numbers    ${amount}    ${refund_amount}

Find Final Status Code
    [Documentation]    Wait until database corresponding record's status becomes 'SUCCESS' or timeout occurs
    ${filter_query}    Create Dictionary    trackingCode=${REFUND_PARENT_TRACKING_CODE}
    ${data_response}    Mongo Db Find
    ...    ${REPORT_MNG_DB_NAME}
    ...    ${REPORT_MNG_ACTIVITIES_COLLECTION}
    ...    ${filter_query}
    Should Be Equal As Integers    ${data_response['status_code']}    0
    Should Not Be Empty    ${data_response['body']}
    Should Be Equal As Strings    ${data_response['body'][0]['status']}    0
    RETURN    ${data_response}

Refund Transaction Log Should Be Founded In Refund Management Service
    [Documentation]    find ${REFUND_PARENT_TRACKING_CODE} in redund database and check refundState be 'Succeed'
    Sleep    1 minutes
    ${filter_query}    Create Dictionary    refundData.parentTrackingCode=${REFUND_PARENT_TRACKING_CODE}
    ${data_response}    Mongo Db Find
    ...    ${REFUND_DB_NAME}
    ...    ${REFUND_REFUND_JUORNAL}
    ...    ${filter_query}
    Should Be Equal As Integers    ${data_response['status_code']}    0
    Should Not Be Empty    ${data_response['body']}
    Should Be Equal As Strings    ${data_response['body'][0]['refundState']}    Succeed

Decrease Balance Of Business Refund Wallet By The Refund Amount
    [Arguments]    ${refund_amount}
    ${result}    GET Wallets Businesses Balance
    ...    ${MICROSERVICE_SIDE}
    ...    ${REFUND_TEST_BUSINESS_ID}
    ...    ${B_WALLET_REFUND_DEFINITION}
    Set Test Variable    ${BUSINESS_REFUND_WALLET_BALANCE_AFTER_REFUND}    ${result['body']['balance']}
    ${decreased_amount}    Evaluate
    ...    ${BUSINESS_REFUND_WALLET_BALANCE_BEFORE_REFUND} -${BUSINESS_REFUND_WALLET_BALANCE_AFTER_REFUND}
    Should Be Equal As Integers    ${refund_amount}    ${decreased_amount}

Decrease Balance Of Business Refund-Manual Wallet By The Refund Amount
    [Arguments]    ${refund_amount}
    ${result}    GET Wallets Businesses Balance
    ...    ${MICROSERVICE_SIDE}
    ...    ${REFUND_TEST_BUSINESS_ID}
    ...    ${B_WALLET_REFUND_MANUAL_DEFINITION}
    Set Test Variable    ${BUSINESS_REFUND_MANUAL_WALLET_BALANCE_AFTER_REFUND}    ${result['body']['balance']}
    ${decreased_amount}    Evaluate
    ...    ${BUSINESS_REFUND_MANUAL_WALLET_BALANCE_BEFORE_REFUND} -${BUSINESS_REFUND_MANUAL_WALLET_BALANCE_AFTER_REFUND}
    Should Be Equal As Integers    ${refund_amount}    ${decreased_amount}

Increase Cashoutable Balance Of User Wallet By The Refund Amount
    [Arguments]    ${refund_amount}    ${user_id}
    ${result}    GET Wallets Users Balances    ${MICROSERVICE_SIDE}    ${user_id}
    FOR    ${wallet}    IN    @{result['body']['balances']}
        IF    '${wallet['walletName']}' == 'default'
            ${user_wallet_balance_after_refund}    Set Variable    ${wallet['cashoutableBalance']}
        END
    END
    FOR    ${wallet}    IN    @{USER_WALLET_BALANCE_BEFORE_REFUND}
        IF    '${wallet['walletName']}' == 'default'
            ${user_wallet_balance_before_refund}    Set Variable    ${wallet['cashoutableBalance']}
        END
    END
    Convert To Integer    ${user_wallet_balance_after_refund}
    ${increased_amount}    Evaluate    ${user_wallet_balance_after_refund} - ${user_wallet_balance_before_refund}
    Should Be Equal As Integers    ${refund_amount}    ${increased_amount}

Increase Noncashoutable Balance Of User Wallet By The Refund Amount
    [Arguments]    ${refund_amount}    ${user_id}
    ${result}    GET Wallets Users Balances    ${MICROSERVICE_SIDE}    ${user_id}
    FOR    ${wallet}    IN    @{result['body']['balances']}
        IF    '${wallet['walletName']}' == 'default'
            ${user_wallet_balance_after_refund}    Set Variable    ${wallet['nonCashoutableBalance']}
        END
    END
    FOR    ${wallet}    IN    @{USER_WALLET_BALANCE_BEFORE_REFUND}
        IF    '${wallet['walletName']}' == 'default'
            ${user_wallet_balance_before_refund}    Set Variable    ${wallet['nonCashoutableBalance']}
        END
    END
    Convert To Integer    ${user_wallet_balance_after_refund}
    ${increased_amount}    Evaluate    ${user_wallet_balance_after_refund} - ${user_wallet_balance_before_refund}
    Should Be Equal As Integers    ${refund_amount}    ${increased_amount}

Increase Gift Balance Of User Wallet By The Refund Amount
    [Arguments]    ${refund_amount}    ${user_id}
    ${result}    GET Wallets Users Balances    ${MICROSERVICE_SIDE}    ${user_id}
    FOR    ${wallet}    IN    @{result['body']['balances']}
        IF    '${wallet['walletName']}' != 'default'
            ${user_wallet_balance_after_refund}    Set Variable    ${wallet['nonCashoutableBalance']}
        END
    END
    FOR    ${wallet}    IN    @{USER_WALLET_BALANCE_BEFORE_REFUND}
        IF    '${wallet['walletName']}' != 'default'
            ${user_wallet_balance_before_refund}    Set Variable    ${wallet['nonCashoutableBalance']}
        END
    END
    Convert To Integer    ${user_wallet_balance_after_refund}
    ${increased_amount}    Evaluate    ${user_wallet_balance_after_refund} - ${user_wallet_balance_before_refund}
    Should Be Equal As Integers    ${refund_amount}    ${increased_amount}

Increase Combimation Balance Of User Wallet By The Refund Amount
    [Arguments]    ${refund_amount}    ${user_id}
    ${user_wallet_cashoutable_balance_after_refund}    Set Variable    0
    ${user_wallet_non_cashoutable_balance_after_refund}    Set Variable    0
    ${user_wallet_gift_balance_after_refund}    Set Variable    0
    ${user_wallet_cashoutable_balance_before_refund}    Set Variable    0
    ${user_wallet_non_cashoutable_balance_before_refund}    Set Variable    0
    ${user_wallet_gift_balance_before_refund}    Set Variable    0

    ${result}    GET Wallets Users Balances    ${MICROSERVICE_SIDE}    ${user_id}
    FOR    ${wallet}    IN    @{result['body']['balances']}
        IF    '${wallet['walletName']}' == 'default'
            ${user_wallet_cashoutable_balance_after_refund}    Set Variable    ${wallet['cashoutableBalance']}
            Convert To Integer    ${user_wallet_cashoutable_balance_after_refund}
            ${user_wallet_non_cashoutable_balance_after_refund}    Set Variable    ${wallet['nonCashoutableBalance']}
            Convert To Integer    ${user_wallet_non_cashoutable_balance_after_refund}
        END
        IF    '${wallet['walletName']}' != 'default'
            ${user_wallet_gift_balance_after_refund}    Set Variable    ${wallet['nonCashoutableBalance']}
            Convert To Integer    ${user_wallet_gift_balance_after_refund}
        END
    END
    FOR    ${wallet}    IN    @{USER_WALLET_BALANCE_BEFORE_REFUND}
        IF    '${wallet['walletName']}' == 'default'
            ${user_wallet_cashoutable_balance_before_refund}    Set Variable    ${wallet['cashoutableBalance']}
            ${user_wallet_non_cashoutable_balance_before_refund}    Set Variable    ${wallet['nonCashoutableBalance']}
        END
        IF    '${wallet['walletName']}' != 'default'
            ${user_wallet_gift_balance_before_refund}    Set Variable    ${wallet['nonCashoutableBalance']}
        END
    END

    ${increased_amount}    Evaluate
    ...    ${user_wallet_non_cashoutable_balance_after_refund} - ${user_wallet_non_cashoutable_balance_before_refund} + ${user_wallet_cashoutable_balance_after_refund} - ${user_wallet_cashoutable_balance_before_refund} + ${user_wallet_gift_balance_after_refund} - ${user_wallet_gift_balance_before_refund}
    Should Be Equal As Integers    ${refund_amount}    ${increased_amount}

Manual Refund To Cell Number
    [Documentation]    Manual refund to a cell number without sale tracking code
    [Arguments]    ${cell_number}    ${refund_amount}

    ${user_balances}    GET Wallets Users Balances    ${MICROSERVICE_SIDE}    ${MANUAL_REFUND_USER_ID}
    Set Test Variable    ${USER_WALLET_BALANCE_BEFORE_REFUND}    ${user_balances['body']['balances']}

    ${business_balance_manual}    GET Wallets Businesses Balance
    ...    ${MICROSERVICE_SIDE}
    ...    ${REFUND_TEST_BUSINESS_ID}
    ...    ${B_WALLET_REFUND_MANUAL_DEFINITION}
    Set Test Variable
    ...    ${BUSINESS_REFUND_MANUAL_WALLET_BALANCE_BEFORE_REFUND}
    ...    ${business_balance_manual['body']['balance']}

    ${provider_id}    Generate Random String    15    0123456789
    ${description}    Set Variable    "Manual refund to cell number"

    ${response}    Post Purchase Refund
    ...    ${GENERAL_SIDE}
    ...    amount=${refund_amount}
    ...    business_id=${REFUND_TEST_BUSINESS_ID}
    ...    cell_number=${cell_number}
    ...    provider_id=${provider_id}
    ...    type=${REFUND_TYPE}

    Should Be Equal As Integers
    ...    ${response['status_code']}
    ...    200
    ...    msg=Manual refund failed

    Set Test Variable    ${REFUND_PARENT_TRACKING_CODE}    ${response['body']['trackingCode']}
