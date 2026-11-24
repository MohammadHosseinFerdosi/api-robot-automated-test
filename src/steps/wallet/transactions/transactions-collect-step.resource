*** Settings ***
Resource        apis/wallet-provider/transactions/post-transactions-collect.resource
Resource        apis/wallet-provider/wallets/get-wallets-businesses-balance.resource
Resource        apis/wallet-provider/wallets/get-wallets-users-balance.resource
Variables       data/wallet/transactions/transactions-collect-variables.yaml


*** Keywords ***
Collect Amount From
    [Arguments]
    ...    ${collect_user_wallet}
    ...    ${collect_user_id}=${EMPTY}
    ...    ${collect_business_id}=${EMPTY}
    ...    ${collect_business_wallet}=${EMPTY}

    IF    '${collect_user_id}' == '${EMPTY}'
        ${collect_user_id}    Set Variable    ${USER_ID}
    END
    IF    '${collect_business_id}' == '${EMPTY}'
        ${collect_business_id}    Set Variable    ${INIT_BUSINESS_ID}
    END
    IF    '${collect_business_wallet}' == '${EMPTY}'
        ${collect_business_wallet}    Set Variable    ${B_WALLET_FOR_COLLECT}
    END

    ${user_wallet_balance}    User Wallet Balance    ${collect_user_wallet}    ${collect_user_id}

    ${result}    POST Transactions Collect
    ...    ${MICROSERVICE_SIDE}
    ...    ${collect_user_id}
    ...    ${collect_user_wallet}
    ...    ${collect_business_id}
    ...    ${collect_business_wallet}

    &{COLLECT_RESULT}    Set Variable    ${result['body']}
    Set Test Variable    ${COLLECT_RESULT}
    IF    ${result['status_code']} == 200
        ${COLLECT_B_WALLET_EXPECTED_BALANCE}    Evaluate
        ...    ${COLLECT_B_WALLET_EXPECTED_BALANCE} + ${user_wallet_balance['body']['balance']}
        Set Suite Variable    ${COLLECT_B_WALLET_EXPECTED_BALANCE}
    END

Amount Should Be Zero For
    [Arguments]    ${user_wallet}
    ${result}    User Wallet Balance    ${user_wallet}    ${USER_ID}
    Should Be Equal As Integers
    ...    ${result['body']['balance']}
    ...    0
    ...    msg=Balance should be zero, but found ${result[ 'body']['balance']}
    Should Be Equal As Integers
    ...    ${result['body']['cashoutableBalance']}
    ...    0
    ...    msg=Cashoutable balance should be zero, but found ${result['body']['cashoutableBalance']}
    Should Be Equal As Integers
    ...    ${result['body']['nonCashoutableBalance']}
    ...    0
    ...    msg=Non cashoutable balance should be zero, but found ${result['body']['cashoutableBalance']}

Business Wallet Should Be Increased BY
    [Arguments]    ${expected_amount}
    Compare Business Balance    ${INIT_BUSINESS_ID}    ${B_WALLET_FOR_COLLECT}    ${expected_amount}

Transaction Should Be Failed With
    [Arguments]    ${failure_content}
    Dictionaries Should Be Equal    ${COLLECT_RESULT['result']}    ${failure_content}

Business Wallet Amount Should Not Be Changed
    Compare Business Balance    ${INIT_BUSINESS_ID}    ${B_WALLET_FOR_COLLECT}    ${COLLECT_B_WALLET_EXPECTED_BALANCE}

User Wallet Amount Should Not Be Changed
    [Arguments]    ${user_wallet}    ${expected_wallet_amount}=${INIT_WALLET_AMOUNT}
    ${result}    User Wallet Balance    ${user_wallet}    ${USER_ID}
    Should Be Equal As Integers
    ...    ${result['body']['balance']}
    ...    ${expected_wallet_amount}
    ...    msg=Balance should be equal: ${INIT_WALLET_AMOUNT}, but found ${result[ 'body']['balance']}

Compare Business Balance
    [Arguments]    ${business_id}    ${wallet_name}    ${expected_amount}
    ${result}    GET Wallets Businesses Balance
    ...    ${MICROSERVICE_SIDE}
    ...    ${business_id}
    ...    ${wallet_name}
    Should Be Equal As Integers    ${result['status_code']}    200    msg=Fail to get business balance.
    ${expected_amount}    Convert To Integer    ${expected_amount}
    Should Be Equal As Integers
    ...    ${result['body']['balance']}
    ...    ${expected_amount}
    ...    msg=Recevied business balance ${result['body']['balance']} not equals to expected amount ${expected_amount}

User Wallet Balance
    [Arguments]    ${user_wallet}    ${wallet_user_id}=${USER_ID}
    ${result}    GET Wallets Users Balance    ${MICROSERVICE_SIDE}    ${wallet_user_id}    ${user_wallet}
    RETURN    ${result}
