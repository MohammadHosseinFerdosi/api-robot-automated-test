*** Settings ***
Library         library/faker_utils.py    WITH NAME    FakerLibrary
Resource        apis/wallet-provider/wallets/get-wallets-users-total-balance.resource
Resource        services/backend/auth-service.resource
Variables       data/wallet/users-total-balance-variables.yaml


*** Keywords ***
Login With A Multi Type Wallet User To App
    Login To App    ${MULTI_TYPE_WALLET_USER_CELL_NUMBER}
    Set Test Variable    ${CURRENT_USER_CELL_NUMBER}    ${MULTI_TYPE_WALLET_USER_CELL_NUMBER}

Login With Only Time-Bound Wallet User To App
    Login To App    ${GIFT_ONLY_WALLET_USER_CELL_NUMBER}
    Set Test Variable    ${CURRENT_USER_CELL_NUMBER}    ${GIFT_ONLY_WALLET_USER_CELL_NUMBER}

Login With Only Expired Time-Bound Wallet User To App
    Login To App    ${ONLY_EXPIRED_WALLET_USER_CELL_NUMBER}
    Set Test Variable    ${CURRENT_USER_CELL_NUMBER}    ${ONLY_EXPIRED_WALLET_USER_CELL_NUMBER}

Login With Only Default Wallet User To App
    Login To App    ${DEFAULT_ONLY_WALLET_USER_CELL_NUMBER}
    Set Test Variable    ${CURRENT_USER_CELL_NUMBER}    ${DEFAULT_ONLY_WALLET_USER_CELL_NUMBER}

Login With Only Default Cashoutable Wallet User To App
    Login To App    ${CASHOUTABLE_ONLY_WALLET_USER_CELL_NUMBER}
    Set Test Variable    ${CURRENT_USER_CELL_NUMBER}    ${CASHOUTABLE_ONLY_WALLET_USER_CELL_NUMBER}

Login With Only Default Non-Cashoutable Wallet User To App
    Login To App    ${NON_CASHOUTABLE_ONLY_WALLET_USER_CELL_NUMBER}
    Set Test Variable    ${CURRENT_USER_CELL_NUMBER}    ${NON_CASHOUTABLE_ONLY_WALLET_USER_CELL_NUMBER}

Login For Without Wallet User To App
    Login To App    ${WITHOUT_WALLET_USER_CELL_NUMBER}
    Set Test Variable    ${CURRENT_USER_CELL_NUMBER}    ${WITHOUT_WALLET_USER_CELL_NUMBER}

Get User Aggregated Balance
    ${response}    GET Wallets Users Total Balance    ${APP_SIDE}
    Should Be Equal As Integers
    ...    ${response['status_code']}
    ...    200
    ...    msg=Get total Balance result should be 200, but found: ${response['status_code']}
    ${AGGREGATED_BALANCE}    Set Variable    ${response['body']}
    Set Test Variable    ${AGGREGATED_BALANCE}

All Unexpired And Default Wallet Amount Should Be Aggregated In Balance Result
    ${expected_non_cashoutable_balance}    Evaluate
    ...    ${MULTI_TYPE_WALLET_USER_DEFAULT_WALLET_ALL_INITIAL_AMOUNT} - ${MULTI_TYPE_WALLET_USER_DEFAULT_WALLET_CASHOUTABLE_INITIAL_AMOUNT}

    ${expected_aggregated_total_balance}    Evaluate
    ...    ${MULTI_TYPE_WALLET_USER_DEFAULT_WALLET_ALL_INITIAL_AMOUNT} + ${MULTI_TYPE_WALLET_USER_UNEXPIRED_WALLET_INITIAL_AMOUNT}

    Should Be Equal As Integers
    ...    ${AGGREGATED_BALANCE['balance']}
    ...    ${expected_aggregated_total_balance}
    Should Be Equal As Integers
    ...    ${AGGREGATED_BALANCE['cashoutableBalance']}
    ...    ${MULTI_TYPE_WALLET_USER_DEFAULT_WALLET_CASHOUTABLE_INITIAL_AMOUNT}
    Should Be Equal As Integers
    ...    ${AGGREGATED_BALANCE['nonCashoutableBalance']}
    ...    ${expected_non_cashoutable_balance}
    Should Be Equal As Integers
    ...    ${AGGREGATED_BALANCE['timeBoundBalance']}
    ...    ${MULTI_TYPE_WALLET_USER_UNEXPIRED_WALLET_INITIAL_AMOUNT}

Just Cashout And Non-Cashout Should Have Value And Time-Bound Balance Should Be Zero
    ${expected_non_cashoutable_balance}    Evaluate
    ...    ${DEFAULT_ONLY_USER_WALLET_ALL_INITIAL_AMOUNT} - ${DEFAULT_ONLY_USER_CASHOUTABLE_INITIAL_AMOUNT}

    Should Be Equal As Integers    ${AGGREGATED_BALANCE['balance']}    ${DEFAULT_ONLY_USER_WALLET_ALL_INITIAL_AMOUNT}
    Should Be Equal As Integers
    ...    ${AGGREGATED_BALANCE['cashoutableBalance']}
    ...    ${DEFAULT_ONLY_USER_CASHOUTABLE_INITIAL_AMOUNT}
    Should Be Equal As Integers
    ...    ${AGGREGATED_BALANCE['nonCashoutableBalance']}
    ...    ${expected_non_cashoutable_balance}
    Should Be Equal As Integers    ${AGGREGATED_BALANCE['timeBoundBalance']}    ${0}

Just Non-Cashout Should Have Value And Time-Bound And Cashout Balance Should Be Zero
    Should Be Equal As Integers
    ...    ${AGGREGATED_BALANCE['balance']}
    ...    ${NON_CASHOUTABLE_ONLY_USER_WALLET_INITIAL_AMOUNT}
    Should Be Equal As Integers    ${AGGREGATED_BALANCE['cashoutableBalance']}    ${0}
    Should Be Equal As Integers
    ...    ${AGGREGATED_BALANCE['nonCashoutableBalance']}
    ...    ${NON_CASHOUTABLE_ONLY_USER_WALLET_INITIAL_AMOUNT}
    Should Be Equal As Integers    ${AGGREGATED_BALANCE['timeBoundBalance']}    ${0}

Just Cashout Should Have Value And Time-Bound And Non-Cashout Balance Should Be Zero
    Should Be Equal As Integers    ${AGGREGATED_BALANCE['balance']}    ${CASHOUTABLE_ONLY_USER_WALLET_INITIAL_AMOUNT}
    Should Be Equal As Integers
    ...    ${AGGREGATED_BALANCE['cashoutableBalance']}
    ...    ${CASHOUTABLE_ONLY_USER_WALLET_INITIAL_AMOUNT}
    Should Be Equal As Integers    ${AGGREGATED_BALANCE['nonCashoutableBalance']}    ${0}
    Should Be Equal As Integers    ${AGGREGATED_BALANCE['timeBoundBalance']}    ${0}

Just Time-Bound Balance Should Have Value And Cashout And Not-Cashout Should Be Zero
    Should Be Equal As Integers
    ...    ${AGGREGATED_BALANCE['balance']}
    ...    ${GIFT_ONLY_USER_UNEXPIRED_WALLET_INITIAL_AMOUNT}
    Should Be Equal As Integers    ${AGGREGATED_BALANCE['cashoutableBalance']}    ${0}
    Should Be Equal As Integers    ${AGGREGATED_BALANCE['nonCashoutableBalance']}    ${0}
    Should Be Equal As Integers
    ...    ${AGGREGATED_BALANCE['timeBoundBalance']}
    ...    ${GIFT_ONLY_USER_UNEXPIRED_WALLET_INITIAL_AMOUNT}

All Balances Should Be Zero
    Should Be Equal As Integers
    ...    ${AGGREGATED_BALANCE['balance']}
    ...    ${0}
    Should Be Equal As Integers
    ...    ${AGGREGATED_BALANCE['cashoutableBalance']}
    ...    ${0}
    Should Be Equal As Integers
    ...    ${AGGREGATED_BALANCE['nonCashoutableBalance']}
    ...    ${0}
    Should Be Equal As Integers
    ...    ${AGGREGATED_BALANCE['timeBoundBalance']}
    ...    ${0}

Get Aggregated Balance With Invalid User
    ${response}    GET Wallets Users Total Balance    ${MICROSERVICE_SIDE}    ${INVALID_USER_ID}
    IF    ${response['status_code']} == 200
        Fail    msg=Get total Balance result should be failed but found 200
    END
    ${FAILURE_CONTENT}    Set Variable    ${response['body']['result']}
    Set Test Variable    ${FAILURE_CONTENT}

Response Should Be Failed With User Not Found Content
    Dictionaries Should Be Equal    ${FAILURE_CONTENT}    ${INVALID_USER_ID_FAILURE_CONTENT}
