*** Settings ***
Library         library/faker_utils.py    WITH NAME    FakerLibrary
Resource        apis/uaa/post-admin-businesses.resource
Resource        services/backend/auth-service.resource
Resource        apis/wallet-provider/wallets/post-wallets-users.resource
Resource        apis/nemo/admin/admin-wallets-businesses-cash-in.resource
Resource        apis/report-mng/post-admin-activities-dashboard-search.resource
Resource        apis/wallet-provider/admin/admin-wallets-businesses.resource
Resource        apis/nemo/admin/post-admin-wallets-businesses-config.resource
Resource        apis/wallet-provider/wallets/get-wallets-businesses-balance.resource
Variables       data/wallet/business-transfer-auto-variables.yaml


*** Keywords ***
Initalize A Business And Wallets
    Login To Dashboard    ${DASHBOARD_USERNAME}    ${DASHBOARD_PASSWORD}
    ${MAIN_BUSINESS_ID}    Create Business
    Create Business Wallet    ${MAIN_BUSINESS_ID}    ${B_WALLET_FOR_INTERNAL_TRANSFER_SOURCE}
    Create Business Wallet    ${MAIN_BUSINESS_ID}    ${B_WALLET_FOR_INTERNAL_TRANSFER_DESTINATION}
    Create Business Wallet    ${MAIN_BUSINESS_ID}    ${B_WALLET_FOR_EXTERNAL_TRANSFER_DESTINATION}
    ${INIT_AMOUNT_INTERNAL_TRANSFER_SOURCE}    Random Int    100    200
    Cash-in To Business Wallet
    ...    ${MAIN_BUSINESS_ID}
    ...    ${B_WALLET_FOR_INTERNAL_TRANSFER_SOURCE}
    ...    ${INIT_AMOUNT_INTERNAL_TRANSFER_SOURCE}

    ${SECOND_BUSINESS_ID}    Create Business
    ${INIT_AMOUNT_EXTERNAL_TRANSFER_SOURCE}    Random Int    100    200
    Create Business Wallet    ${SECOND_BUSINESS_ID}    ${B_WALLET_FOR_EXTERNAL_TRANSFER_SOURCE}
    Cash-in To Business Wallet
    ...    ${SECOND_BUSINESS_ID}
    ...    ${B_WALLET_FOR_EXTERNAL_TRANSFER_SOURCE}
    ...    ${INIT_AMOUNT_EXTERNAL_TRANSFER_SOURCE}

    Set Test Variable    ${MAIN_BUSINESS_ID}
    Set Test Variable    ${INIT_AMOUNT_INTERNAL_TRANSFER_SOURCE}
    Set Test Variable    ${SECOND_BUSINESS_ID}
    Set Test Variable    ${INIT_AMOUNT_EXTERNAL_TRANSFER_SOURCE}

Create Business
    [Tags]    robot:private
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
    [Tags]    robot:private
    [Arguments]    ${business_id}    ${wallet_name}
    ${is_wallet_added}    POST Admin Wallets Businesses
    ...    ${DASHBOARD_SIDE}
    ...    ${business_id}
    ...    ${wallet_name}
    ...    ${CURRENCY_IRR}
    Should Be True    ${is_wallet_added}    msg=Wallet Not Added in Busienss.

Cash-in To Business Wallet
    [Tags]    robot:private
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

Set Auto Transfer Configuration For Internal Transfer
    ${TRANSFER_AMOUNT}    Evaluate    ${INIT_AMOUNT_INTERNAL_TRANSFER_SOURCE} - 10
    ${auto_transfer_config}    Create Dictionary
    ...    minAmount=1
    ...    transferAmount=${TRANSFER_AMOUNT}
    ...    sourceWallet=${B_WALLET_FOR_INTERNAL_TRANSFER_SOURCE}

    ${destination_wallet_config}    Create Dictionary
    ...    walletName=${B_WALLET_FOR_INTERNAL_TRANSFER_DESTINATION}
    ...    strategy=0
    ...    blockedBalance=1
    ...    minSettlementAmount=1
    ...    autoTransferConfig=${auto_transfer_config}

    @{wallets_list}    Create List
    Append To List    ${wallets_list}    ${destination_wallet_config}

    ${response}    POST Admin Wallets businesses config
    ...    ${DASHBOARD_SIDE}
    ...    ${MAIN_BUSINESS_ID}
    ...    ${wallets_list}

    Should Be Equal As Integers
    ...    ${response['status_code']}
    ...    200
    ...    msg=Set config should be successfull but found: ${response['body']['result']}

    Set Test Variable    ${TRANSFER_AMOUNT}

Set Auto Transfer Configuration With Different Source Business
    ${TRANSFER_AMOUNT}    Evaluate    ${INIT_AMOUNT_EXTERNAL_TRANSFER_SOURCE} - 10
    ${auto_transfer_config}    Create Dictionary
    ...    minAmount=1
    ...    transferAmount=${TRANSFER_AMOUNT}
    ...    sourceWallet=${B_WALLET_FOR_EXTERNAL_TRANSFER_SOURCE}
    ...    sourceBusinessId=${SECOND_BUSINESS_ID}

    ${destination_wallet_config}    Create Dictionary
    ...    walletName=${B_WALLET_FOR_EXTERNAL_TRANSFER_DESTINATION}
    ...    strategy=0
    ...    blockedBalance=1
    ...    minSettlementAmount=1
    ...    autoTransferConfig=${auto_transfer_config}

    @{wallets_list}    Create List
    Append To List    ${wallets_list}    ${destination_wallet_config}

    ${response}    POST Admin Wallets businesses config
    ...    ${DASHBOARD_SIDE}
    ...    ${MAIN_BUSINESS_ID}
    ...    ${wallets_list}

    Should Be Equal As Integers
    ...    ${response['status_code']}
    ...    200
    ...    msg=Set config should be successfull but found: ${response['body']['result']}

    Set Test Variable    ${TRANSFER_AMOUNT}

Set Auto Transfer Configuration For A Business With Same Wallets
    ${TRANSFER_AMOUNT}    Evaluate    ${INIT_AMOUNT_INTERNAL_TRANSFER_SOURCE} - 10
    ${auto_transfer_config}    Create Dictionary
    ...    minAmount=1
    ...    transferAmount=${TRANSFER_AMOUNT}
    ...    sourceWallet=${B_WALLET_FOR_INTERNAL_TRANSFER_SOURCE}

    ${destination_wallet_config}    Create Dictionary
    ...    walletName=${B_WALLET_FOR_INTERNAL_TRANSFER_SOURCE}
    ...    strategy=0
    ...    blockedBalance=1
    ...    minSettlementAmount=1
    ...    autoTransferConfig=${auto_transfer_config}

    @{wallets_list}    Create List
    Append To List    ${wallets_list}    ${destination_wallet_config}

    ${response}    POST Admin Wallets businesses config
    ...    ${DASHBOARD_SIDE}
    ...    ${MAIN_BUSINESS_ID}
    ...    ${wallets_list}

    Should Be Equal As Integers
    ...    ${response['status_code']}
    ...    200
    ...    msg=Set config should be successfull but found: ${response['body']['result']}

    Set Test Variable    ${TRANSFER_AMOUNT}

Wait For Business Transfer Scheduler
    Sleep    ${TRANSFER_SCHEDULER_WAIT_TIME}

External Source Wallet Should Be Decreased
    ${expected_amount}    Evaluate    ${INIT_AMOUNT_EXTERNAL_TRANSFER_SOURCE} - ${TRANSFER_AMOUNT}
    Compare Business Balances With Expected Balance
    ...    ${SECOND_BUSINESS_ID}
    ...    ${B_WALLET_FOR_EXTERNAL_TRANSFER_SOURCE}
    ...    ${expected_amount}

Source Wallet Should Be Decreased
    ${expected_amount}    Evaluate    ${INIT_AMOUNT_INTERNAL_TRANSFER_SOURCE} - ${TRANSFER_AMOUNT}
    Compare Business Balances With Expected Balance
    ...    ${MAIN_BUSINESS_ID}
    ...    ${B_WALLET_FOR_INTERNAL_TRANSFER_SOURCE}
    ...    ${expected_amount}

Internal Destination Wallet Should Be Increased
    Compare Business Balances With Expected Balance
    ...    ${MAIN_BUSINESS_ID}
    ...    ${B_WALLET_FOR_EXTERNAL_TRANSFER_DESTINATION}
    ...    ${TRANSFER_AMOUNT}

Destination Wallet Should Be Increased
    Compare Business Balances With Expected Balance
    ...    ${MAIN_BUSINESS_ID}
    ...    ${B_WALLET_FOR_INTERNAL_TRANSFER_DESTINATION}
    ...    ${TRANSFER_AMOUNT}

Compare Business Balances With Expected Balance
    [Arguments]    ${business_id}    ${business_wallet_name}    ${expected_amount}
    ${result}    GET Wallets Businesses Balance    ${MICROSERVICE_SIDE}    ${business_id}    ${business_wallet_name}
    Should Be Equal As Integers
    ...    ${result['body']['balance']}
    ...    ${expected_amount}
    ...    msg=The Blanace of Business Wallet: ${business_wallet_name} Expected to: ${expected_amount} but found: ${result['body']['balance']}

Get Transaction Report
    [Tags]    robot:private
    ${current_time}    Get Time    epoch
    ${min_time}    Evaluate    (${current_time} * 1000) - 600000
    ${max_time}    Evaluate    (${current_time} * 1000) + 600000
    ${creation_date}    Create Dictionary
    ...    type=range
    ...    field=creationDate
    ...    minValue=${min_time}
    ...    maxValue=${max_time}

    ${transfer_type}    Set Variable    50
    ${transfer_type}    Convert To Integer    ${transfer_type}
    @{business_transfer_type}    Create List    ${transfer_type}

    ${transaction_type}    Create Dictionary    type=collection    field=type    values=${business_transfer_type}

    @{destination_business_id}    Create List    ${MAIN_BUSINESS_ID}
    ${transaction_destination}    Create Dictionary
    ...    type=collection
    ...    field=destination.user.userId
    ...    values=${destination_business_id}

    ${status}    Set Variable    0
    ${status}    Convert To Integer    ${status}
    @{success_transaction_status}    Create List    ${status}
    ${transaction_status}    Create Dictionary
    ...    type=collection
    ...    field=status
    ...    values=${success_transaction_status}

    @{restrictions}    Create List
    ...    ${creation_date}
    ...    ${transaction_type}
    ...    ${transaction_destination}
    ...    ${transaction_status}

    ${sort_by}    Create Dictionary    field=creationDate    order=desc
    @{orders}    Create List    ${sort_by}
    ${result}    POST Admin Activities Dashboard Search    ${DASHBOARD_SIDE}    ${restrictions}    ${orders}
    Should Be Equal As Integers    ${result['status_code']}    200    msg=Report Result Failed. ${result['body']}
    RETURN    ${result['body']}

Report With Valid Data For Internal Transfer Should Be Find In Activity
    ${report_result}    Get Transaction Report
    FOR    ${activity}    IN    @{report_result['activities']}
        IF    ${activity['amount']} == ${TRANSFER_AMOUNT}
            Should Be Equal As Strings
            ...    ${activity['source']['user']['userId']}
            ...    ${MAIN_BUSINESS_ID}
            ...    msg=Transfer with valid amount founded but source business id did't match with expected business id.
        ELSE
            Fail    msg=Transfer report with expected amount not found.
        END
    END

Report With Valid Data For External Transfer Should Be Find In Activity
    ${report_result}    Get Transaction Report
    FOR    ${activity}    IN    @{report_result['activities']}
        IF    ${activity['amount']} == ${TRANSFER_AMOUNT}
            Should Be Equal As Strings
            ...    ${activity['source']['user']['userId']}
            ...    ${SECOND_BUSINESS_ID}
            ...    msg=Transfer with valid amount founded but source business id did't match with expected business id.
        ELSE
            Fail    msg=Transfer report with expected amount not found.
        END
    END
