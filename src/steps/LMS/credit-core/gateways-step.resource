*** Settings ***
Library         library/faker_utils.py    WITH NAME    FakerLibrary
Library         RequestsLibrary
Library         DateTime
Resource        apis/lms/credit-core/post-credit-gateway-activate.resource
Resource        apis/lms/credit-core/post-credit-gateways-disable.resource
Resource        services/backend/user-wallet-initializer-service.resource
Resource        services/backend/value-handler.resource
Variables       config/environment-stage.yaml


*** Keywords ***
############################################################################################################################################################################
# Merchant Initialization
Initialize Merchant
    [Documentation]    This is a ```Test Setup``` that generated a merchant that can be used to perform a purchases on and validate the API
    [Arguments]    ${BUSINESS_ID_FOR_CHARGE_TEST_WALLETS}=${BUSINESS_ID_FOR_CHARGE_TEST_WALLETS}

    ${spend_wallet_for_business_1}    Create Dictionary
    ...    definition=${B_WALLET_SPEND_DEFINITION}
    ...    wallet_charge_amount=0
    ...    currency=${CURRENCY_IRR}

    ${credit_spend_wallet_for_business_1}    Create Dictionary
    ...    definition=${B_WALLET_CREDIT_SPEND_DEFINITION}
    ...    wallet_charge_amount=0
    ...    currency=${CURRENCY_CRR}

    ${debit_settlement_wallet_for_business_1}    Create Dictionary
    ...    definition=${B_WALLET_DEBIT_SETTLEMENT_DEFINITION}
    ...    wallet_charge_amount=0
    ...    currency=${CURRENCY_IRR}

    ${credit_settlement_wallet_for_business_1}    Create Dictionary
    ...    definition=${B_WALLET_CREDIT_SETTLEMENT_DEFINITION}
    ...    wallet_charge_amount=0
    ...    currency=${CURRENCY_CRR}

    @{role_list}    Create List    merchant-business

    @{wallet_setup_list_1}    Create List
    ...    ${spend_wallet_for_business_1}
    ...    ${credit_spend_wallet_for_business_1}
    ...    ${debit_settlement_wallet_for_business_1}
    ...    ${credit_settlement_wallet_for_business_1}

    ${INIT_BUSINESS_OBJ_1}    Get Initialized Business With Charged Wallet Based On Configuration
    ...    ${wallet_setup_list_1}

    ${LMS_AUTOMATION_BUSINESS_ID}    Set Variable    ${INIT_BUSINESS_OBJ_1['business_id']}
    Set Test Variable    ${LMS_AUTOMATION_BUSINESS_ID}

# Set channel, repayment option and payment gateway Configs

The Gateway RepaymentOption Is Set To 1pay
    @{REPAYMENT_OPTIONS}    Create List    ${LMS_REPAYMENT_OPTION.ONEPAY}
    Set Test Variable    ${REPAYMENT_OPTIONS}

The Gateway RepaymentOption Is Set To Xpay
    @{REPAYMENT_OPTIONS}    Create List    ${LMS_REPAYMENT_OPTION.XPAY}
    Set Test Variable    ${REPAYMENT_OPTIONS}

The Gateway RepaymentOption Is Set To 1pay And Xpay
    @{REPAYMENT_OPTIONS}    Create List    ${LMS_REPAYMENT_OPTION.ONEPAY}    ${LMS_REPAYMENT_OPTION.XPAY}
    Set Test Variable    ${REPAYMENT_OPTIONS}

The Channel Is Set To API
    Set Test Variable    ${PAYMENT_CHANNEL}    ${CHANNEL.API}

The Channel Is Set To UPG
    Set Test Variable    ${PAYMENT_CHANNEL}    ${CHANNEL.UPG}

The Channel Is Set To Smart POS
    Set Test Variable    ${PAYMENT_CHANNEL}    ${CHANNEL.SMART_POS}

The Channel Is Set To QR
    Set Test Variable    ${PAYMENT_CHANNEL}    ${CHANNEL.QR}

The Channel Is Set To Escrow
    Set Test Variable    ${PAYMENT_CHANNEL}    ${CHANNEL.ESCROW}

The Channel Is Set To Barcode
    Set Test Variable    ${PAYMENT_CHANNEL}    ${CHANNEL.BARCODE}

The Channel Is Set To Linux POS
    Set Test Variable    ${PAYMENT_CHANNEL}    ${CHANNEL.LINUX_POS}

The Payment Gateway Is Set To BPG
    Set Test Variable    ${PAYMENT_GATEWAY}    ${LMS_PAYMENT_GATEWAY.BPG}

The Payment Gateway Is Set To CPG
    Set Test Variable    ${PAYMENT_GATEWAY}    ${LMS_PAYMENT_GATEWAY.CPG}

The Payment Gateway Is Set To ISPG
    Set Test Variable    ${PAYMENT_GATEWAY}    ${LMS_PAYMENT_GATEWAY.ISPG}

############################################################################################################################################################################
# Disable And Enable Gateways

The Gateway Is Activated
    ${disable_response}    POST Credit Gateway Disable
    ...    ${MICROSERVICE_SIDE}
    ...    ${LMS_AUTOMATION_BUSINESS_ID}
    ...    ${PAYMENT_CHANNEL}
    ...    ${PAYMENT_GATEWAY}
    ${activate_response}    POST Credit Gateway Activate
    ...    ${MICROSERVICE_SIDE}
    ...    ${LMS_AUTOMATION_BUSINESS_ID}
    ...    ${PAYMENT_CHANNEL}
    ...    ${PAYMENT_GATEWAY}
    ...    0
    ...    ${DASHBOARD_USERNAME}
    ...    ${REPAYMENT_OPTIONS}
    Set Test Variable    ${response_status_code}    ${activate_response}[status_code]

The Gateway Is Disabled
    ${disable_response}    POST Credit Gateway Disable
    ...    ${MICROSERVICE_SIDE}
    ...    ${LMS_AUTOMATION_BUSINESS_ID}
    ...    ${PAYMENT_CHANNEL}
    ...    ${PAYMENT_GATEWAY}

    Should Be Equal As Integers
    ...    ${disable_response['status_code']}
    ...    200
    ...    msg="Expected status code for Credit Gateway Disable API should be 200, and got" ${disable_response['status_code']}

# Status Code    Assertions

Status Code Must Be 200
    [Documentation]    Check the Status Code Of The Inquiry API
    [Arguments]    ${status_code}=${response_status_code}
    Should Be Equal As Integers
    ...    first=${status_code}
    ...    second=200
    ...    msg=Expected The Status Code to be 200 but got ${status_code}

Status Code Must Be 422
    [Documentation]    Check the Status Code Of The Inquiry API
    [Arguments]    ${status_code}=${response_status_code}
    Should Be Equal As Integers
    ...    first=${status_code}
    ...    second=422
    ...    msg=Expected The Status Code to be 422 but got ${status_code}

# Check Credit Merchant Mng Database

Check Gateways Collection In Credit Merchant Mng
    [Arguments]
    ...    ${business_id}=${LMS_AUTOMATION_BUSINESS_ID}
    ...    ${channel}=${PAYMENT_CHANNEL}
    ...    ${payment_gateway}=${PAYMENT_GATEWAY}
    ${find_query}    Create Dictionary    businessId=${LMS_AUTOMATION_BUSINESS_ID}
    ${gateways}    Mongo Db Find
    ...    credit_merchant_mng_db
    ...    gateways
    ...    ${find_query}

    IF    '${gateways}[body][0][channel]' != '${PAYMENT_CHANNEL}' and '${gateways}[body][0][paymentGateway]' != '${PAYMENT_GATEWAY}'
        Fail
        ...    msg=Expected the '${gateways}[body][0][channel]' != '${PAYMENT_CHANNEL}' and '${gateways}[body][0][paymentGateway]' != '${PAYMENT_GATEWAY}' but it failed!
    END

Check Gateway Configs Collection In Credit Merchant Mng
    [Arguments]
    ...    ${business_id}=${LMS_AUTOMATION_BUSINESS_ID}
    ...    ${channel}=${PAYMENT_CHANNEL}
    ...    ${payment_gateway}=${PAYMENT_GATEWAY}

    ${find_query}    Create Dictionary    businessId=${LMS_AUTOMATION_BUSINESS_ID}

    ${gateway_configs}    Mongo Db Find
    ...    credit_merchant_mng_db
    ...    gateway_configs
    ...    ${find_query}

    IF    len(${gateway_configs['body']}) != len(${REPAYMENT_OPTIONS})
        Fail    msg=Expected the len(${gateway_configs['body']}) != len(${REPAYMENT_OPTIONS}) but it failed!
    END
    IF    '${gateway_configs}[body][0][channel]' != '${PAYMENT_CHANNEL}'
        Fail    msg=Expected the '${gateway_configs}[body][0][channel]' != '${PAYMENT_CHANNEL}' but it failed!
    END
