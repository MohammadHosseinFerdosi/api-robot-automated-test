*** Settings ***
Library         library/faker_utils.py    WITH NAME    FakerLibrary
Resource        apis/uaa/post-admin-businesses.resource
Resource        services/backend/auth-service.resource
Resource        apis/wallet-provider/wallets/post-wallets-users.resource
Resource        apis/nemo/admin/admin-wallets-businesses-cash-in.resource
Resource        apis/wallet-provider/admin/admin-wallets-businesses.resource
Resource        apis/wallet-provider/wallets/get-wallets-users-balance.resource
Resource        apis/wallet-provider/transactions/post-transactions-payout.resource
Resource        apis/wallet-provider/wallets/post-wallets-definitions-users.resource
Variables       data/wallet/transactions/transactions-collect-variables.yaml
Variables       data/wallet/wallet-transfer-variables.yaml


*** Keywords ***
Initialization Of A User, Business And Their Wallets
    [Documentation]    Initialize a user, user wallet, business and business walet. After initialization a business it cashin to
    ...    business wallet, Then it pay out an amount to user wallet which are created in this proccess.
    [Arguments]    ${source-cellnumber}=${EMPTY}

    ${INIT_BUSINESS_ID}    Create Business
    Create Business Wallet    ${INIT_BUSINESS_ID}    ${B_WALLET_FOR_PAYOUT}

    ${business_wallet_amount}    Convert To Integer    1000
    Cash-in To Business Wallet    ${INIT_BUSINESS_ID}    ${B_WALLET_FOR_PAYOUT}    ${business_wallet_amount}

    ${cell_number}    Set Variable    ${SOURCE_CELLNUMBER}

    IF    '${source-cellnumber}' != '${EMPTY}'
        ${cell_number}    Set Variable    ${source-cellnumber}
    END
    ${USER_ID}    Create User    ${cell_number}
    Set Suite Variable    ${USER_ID}

    ${INIT_WALLET_AMOUNT}    Random Int    200    300
    ${wallet_cashoutable_amount}    Random Int    100    200

    ${user_balance_before_payout}    Get User Current Balance    ${USER_WALLET_NAME}    ${USER_ID}

    Payout To User Wallet
    ...    ${INIT_BUSINESS_ID}
    ...    ${B_WALLET_FOR_PAYOUT}
    ...    ${USER_ID}
    ...    ${USER_WALLET_NAME}
    ...    ${INIT_WALLET_AMOUNT}
    ...    ${wallet_cashoutable_amount}

    ${INIT_USER_BALANCE}    Get User Current Balance    ${USER_WALLET_NAME}    ${USER_ID}
    ${difference_amount}    Evaluate    ${INIT_USER_BALANCE} - ${user_balance_before_payout}
    Should Be Equal As Integers    ${INIT_WALLET_AMOUNT}    ${difference_amount}
    Set Suite Variable    ${INIT_USER_BALANCE}

    ${DEST_USER_RESULT_FROM_MYSQL}    MySQL Fetch All    db_name=uaa_db
    ...    query=SELECT * FROM uaa_db.users WHERE cell_number="${DESTINATION_CELLNUMBER}"
    Should Be Equal As Integers
    ...    ${DEST_USER_RESULT_FROM_MYSQL['status_code']}
    ...    0
    ...    msg=mysql result should be successful but found: ${DEST_USER_RESULT_FROM_MYSQL['body']}

    ${DEST_USER_ID}    Set Variable    ${DEST_USER_RESULT_FROM_MYSQL['body'][0]['user_id']}
    Set Suite Variable    ${DEST_USER_ID}
    ${INIT_DEST_USER_BALANCE}    Get User Current Balance    ${USER_WALLET_NAME}    ${DEST_USER_ID}
    Set Suite Variable    ${INIT_DEST_USER_BALANCE}

Create User
    [Arguments]    ${cell_number}
    ${user_id}    Login To App    ${cell_number}
    RETURN    ${user_id}

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
    ${result}    POST Transactions Payout
    ...    ${MICROSERVICE_SIDE}
    ...    ${amount}
    ...    ${business_id}
    ...    ${business_wallet_name}
    ...    ${user_id}
    ...    ${user_wallet_name}
    ...    ${cashoutable_amount}
    ...    description=${description}

    Should Be Equal As Integers
    ...    ${result['status_code']}
    ...    200
    ...    msg=Failed to payout. result: ${result['body']}

Get User Current Balance
    [Arguments]    ${wallet_name}    ${wallet_user_id}
    ${result}    GET Wallets Users Balance    ${MICROSERVICE_SIDE}    ${wallet_user_id}    ${wallet_name}
    ${balance}    Set Variable    ${result['body']['balance']}
    Convert To Integer    ${balance}
    RETURN    ${balance}
