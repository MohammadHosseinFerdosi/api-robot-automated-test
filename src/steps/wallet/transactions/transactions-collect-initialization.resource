*** Settings ***
Library         library/faker_utils.py    WITH NAME    FakerLibrary
Resource        apis/uaa/businesses.resource
Resource        services/backend/auth-service.resource
Resource        services/backend/user-wallet-initializer-service.resource
Resource        apis/wallet-provider/wallets/post-wallets-definitions-users.resource
Variables       data/wallet/transactions/transactions-collect-variables.yaml


*** Keywords ***
Initialize A User And Business
    # Create business wallet config
    ${business_wallet_collect_config}    Create Dictionary
    ...    definition=${B_WALLET_REWARD_DEFINITION}
    ...    wallet_charge_amount=0
    ...    currency=${CURRENCY_IRR}
    @{main_business_config}    Create List    ${business_wallet_collect_config}

    ${init_business_obj}    Get Initialized Business With Charged Wallet Based On Configuration
    ...    ${main_business_config}
    ${INIT_BUSINESS_ID}    Set Variable    ${init_business_obj['business_id']}
 # Create user wallet setup configuration
    ${wallet_charge_amount}    Random Int    100    200
    ${default_wallet_cashoutable_amount}    Evaluate    ${wallet_charge_amount} - 50
    ${expired_wallet}    Create Dictionary
    ...    definition=${WALLET_TIME_BOUND_DEFINITION}
    ...    should_be_expired=${True}
    ...    wallet_charge_amount=${wallet_charge_amount}
    ${unexpired_wallet}    Create Dictionary
    ...    definition=${WALLET_TIME_BOUND_DEFINITION}
    ...    wallet_charge_amount=${wallet_charge_amount}
    ${expired_zero_amount_wallet}    Create Dictionary
    ...    definition=${WALLET_TIME_BOUND_DEFINITION}
    ...    should_be_expired=${True}
    ...    wallet_charge_amount=0
    ${default_wallet}    Create Dictionary
    ...    definition=${WALLET_DEFAULT_DEFINITION}
    ...    wallet_charge_amount=${wallet_charge_amount}
    ...    cashoutable_charge_amount=${default_wallet_cashoutable_amount}

    @{wallet_setup_list}    Create List
    ...    ${expired_wallet}
    ...    ${unexpired_wallet}
    ...    ${default_wallet}
    ...    ${expired_zero_amount_wallet}

    ${MULTI_TYPE_WALLET_USER}    Get Initialized User With Charged Wallet Based On Configuration
    ...    ${USER_PHONE_NUMBER_PREFIX}
    ...    ${wallet_setup_list}

    FOR    ${wallet}    IN    @{MULTI_TYPE_WALLET_USER['wallets']}
        IF    '${wallet['type']}' == '${WALLET_TIME_BOUND_DEFINITION}' and 'expired' in ${wallet} and ${wallet['initial_amount']} > ${0}
            ${EXPIRED_WALLET_NAME}    Set Variable    ${wallet['name']}
            CONTINUE
        END
        IF    '${wallet['type']}' == '${WALLET_TIME_BOUND_DEFINITION}' and 'expired' not in ${wallet} and ${wallet['initial_amount']} > ${0}
            ${UNEXPIRED_WALLET_NAME}    Set Variable    ${wallet['name']}
            CONTINUE
        END
        IF    '${wallet['type']}' == '${WALLET_TIME_BOUND_DEFINITION}' and ${wallet['initial_amount']} == ${0}
            ${EXPIRED_WALLET_NAME_ZERO_AMOUNT}    Set Variable    ${wallet['name']}
            CONTINUE
        END
    END

    Sleep    45s    reason=for timebound wallet expiration

    Set Suite Variable    ${USER_DEFAULT_WALLET_INIT_BALANCE}    ${wallet_charge_amount}
    Set Suite Variable    ${INIT_WALLET_AMOUNT}    ${wallet_charge_amount}
    Set Suite Variable    ${USER_ID}    ${MULTI_TYPE_WALLET_USER['user_id']}
    Set Suite Variable    ${EXPIRED_WALLET_NAME}
    Set Suite Variable    ${UNEXPIRED_WALLET_NAME}
    Set Suite Variable    ${EXPIRED_WALLET_NAME_ZERO_AMOUNT}
    Set Suite Variable    ${INIT_BUSINESS_ID}
    Set Suite Variable    ${COLLECT_B_WALLET_EXPECTED_BALANCE}    ${0}
