*** Settings ***
Resource    apis/merchant-credit/settlement/get-merchant-credit-settlements-config.resource
Resource    steps/merchant-credit/settlements-init-kosar-file-step.resource
Resource    services/backend/value-handler.resource


*** Keywords ***
User Selects Fund Provider And Show Max Credit Amount
    [Documentation]    This Keyword Call Config Api And Set Response to ${config_result} Variable
    ${config_result}=    GET Merchant Credit Settlements Config
    ...    ${GENERAL_SIDE}
    ...    ${trackingCode_settlement}
    ...    ${IRAN_VENEZULEA_INDIVIDUAL_RULE_ID}
    Set Test Variable    ${config_result}    ${config_result}[body]

Find User's Approved Fund Providers
    [Documentation]    This keywords return a list of the user's approved fund providers from database
    ${all_fund_provider}=    Get Merchant Credit Data By Specific Field
    ...    merchants
    ...    fundProvider
    ...    registrationId=${REGISTRATION_ID}    status=${MERCHANT_APPROVE_STATUS}

    @{approved_fund_providers}=    Create List
    Append To List    ${approved_fund_providers}    ${all_fund_provider}
    Set Suite Variable    ${approved_fund_providers}

Check Validation Invoice Amount
    [Documentation]    This Keyword Check Validation In Config Api Response Based Invoice Amount And Max Settelement Percentage
    [Arguments]    ${invoce_amount}
    Find User's Approved Fund Providers
    ${min_amount_per_fund_provider_business}=    Get Min Amount Per Fund Provider    ${approved_fund_providers}
    ${max_request_amount}=    Evaluate    ${invoce_amount}*${MAX-SETTLEMENT-PERCENTAGE}

    FOR    ${fund_provider_name}    IN    @{min_amount_per_fund_provider_business}
        ${min_amount_value}=    Get From Dictionary
        ...    ${min_amount_per_fund_provider_business}
        ...    ${fund_provider_name}
        ${min_amount_value}=    Value Handler    ${min_amount_value}
        ${min_amount_value}=    Convert To Number    ${min_amount_value}
        IF    ${max_request_amount} > ${min_amount_value}
            Should Be Equal As Strings    ${config_result}[result][message]    عملیات با موفقیت انجام شد
            Should Be Equal As Integers    ${config_result}[result][status]    0
            Should Be Equal As Strings    ${config_result}[result][title]    SUCCESS
            Should Be Equal As Strings    ${config_result}[result][level]    INFO
        ELSE
            Should Be Equal As Strings
            ...    ${config_result}[result][message]
            ...    مبلغ تسویه زودتر از موعد از حداقل مبلغ مجاز کمتر هست.
            Should Be Equal As Integers    ${config_result}[result][status]    15624
            Should Be Equal As Strings
            ...    ${config_result}[result][title]
            ...    MERCHANT_CREDIT_INVALID_SETTLEMENT_MIN_AMOUNT
            Should Be Equal As Strings    ${config_result}[result][level]    WARN
        END
    END

Check Max Credit Amount Based On Balance Amount
    [Documentation]    This Keyword Checks Max Credit Amount Value In Config Api Response With Attention To Balanced Value

    ${max_credit_amount}=    Evaluate    ${invoice_amount}*${MAX-SETTLEMENT-PERCENTAGE}
    ${max_credit_amount}=    Convert To Integer    ${max_credit_amount}
    ${balanced}=    Get Merchant Credit Data By Specific Field
    ...    merchant_ticket_infos
    ...    balances
    ...    nationalCode=${NATIONAL_CODE_LEGAL}
    ${balanced}=    Set Variable    ${balanced}[0][amount]
    ${balenced_amount}=    Convert To Integer    ${balanced}

    IF    ${max_credit_amount} <= ${balenced_amount}
        Should Be Equal    ${config_result}[maxCreditAmount]    ${max_credit_amount}
    ELSE
        Should Be Equal    ${config_result}[maxCreditAmount]    ${balenced_amount}
    END

Check Max Credit Amount Based On Invoice Amount
    [Documentation]    This Keyword Checks Max Credit Amount Value In Config Api Response With Attention To Invoice Amount And Max Settelement Percentage
    [Arguments]    ${invoice_amount}

    ${max_credit_amount}=    Evaluate    ${invoice_amount}*${MAX-SETTLEMENT-PERCENTAGE}
    ${max_credit_amount}=    Convert To Integer    ${max_credit_amount}
    Should Be Equal    ${config_result}[maxCreditAmount]    ${max_credit_amount}
