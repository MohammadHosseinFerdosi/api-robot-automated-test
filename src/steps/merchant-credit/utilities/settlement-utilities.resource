*** Settings ***
Library         DateTime
Resource        apis/merchant-credit/settlement/post-settlements.resource
Resource        services/backend/date-time-service.resource
Resource        steps/merchant-credit/utilities/get-merchant-credit-db-data.resource
Resource        steps/merchant-credit/settlements-rules-step.resource
Resource        services/backend/value-handler.resource
Variables       data/merchant-credit/merchant-credit-variables.yaml


*** Keywords ***
Create Settlement
    [Arguments]
    ...    ${REGISTRATION_ID}
    ...    ${buffer_to_due_date}
    ...    ${invoice_amount}
    ${random_provider_id}    Generate Random String    5
    ${get_Current_Date}    Get Time    epoch
    ${due_date}    Add Time To Date    ${get_Current_Date}    ${buffer_to_due_date} days    epoch
    ${due_date}    Convert To Integer    ${due_date}
    ${due_date}    evaluate    ${due_date} * 1000
    # Login For Business    ${DG_USERNAME}    ${DG_PASSWORD}
    ${BUSINESS_ID}    Login Per Business And Set Business Id    ${DG_USERNAME}
    Set Suite Variable    ${BUSINESS_ID}
    ${result}    POST Settlements
    ...    ${GENERAL_SIDE}
    ...    ${REGISTRATION_ID}
    ...    ${random_provider_id}
    ...    ${invoice_amount}
    ...    ${due_date}

    IF    '${result.status_code}'== '200'
        Set Suite Variable    ${TRACKING_CODE_SETTLEMENT}    ${result.response.trackingCode}
        Set Suite Variable    ${SETTLEMENT_TICKET}    ${result.response.ticket}
    END

    RETURN    ${result}

Delete Settlement
    [Documentation]    this keyword deletes settlements of merchant by national code.
    ...    this keyword can use singly, also 'delete_settlement' flag in delete-merchant keyword is "true" deletes settlements of this merchant
    [Arguments]    ${national_code}
    ${filter_query}    Create Dictionary    merchant.nationalCode=${national_code}
    ${RESULTS}    Mongo Db Delete One
    ...    merchant_credit_db
    ...    settlements
    ...    ${filter_query}

Counting The Number Of Holidays In a Intervals Time
    [Documentation]    This Keyword Counts The Number Of Holidays In A Time Interval
    ${holidays_count}    Set Variable    0
    ${get_current_date}    Get Time    epoch
    ${current_date_format}    Convert Date    ${get_current_date}    result_format=%Y/%m/%d

    FOR    ${day}    IN RANGE    ${buffer_to_due_date}
        ${date}    Add Time To Date    ${get_current_date}    ${day} days    result_format=%Y-%m-%d
        &{query_find}    Create Dictionary    day=${date}    fundProvider=${IRAN_VENEZUELA_FUND_PROVIDER_NAME}
        ${result}    Mongo Db Count Documents    merchant_credit_db    holidays    ${query_find}
        ${count}    Set Variable    ${result.body.count}
        ${holidays_count}    Evaluate    ${holidays_count}+${count}
    END
    RETURN    ${holidays_count}

Calculate Min Due Date And Delay Per Fund Provider
    [Arguments]
    ...    ${approved_fund_providers}

    ${fund_provider_due_date}    Create Dictionary
    FOR    ${fund_provider_name}    IN    @{approved_fund_providers}
        ${min_due_date}    Get Merchant Credit Data By Specific Field
        ...    fees
        ...    minDueDate
        ...    providerId=${fund_provider_name}

        ${delay}    Get Merchant Credit Data By Specific Field
        ...    fees
        ...    delay
        ...    providerId=${fund_provider_name}

        ${buffer_to_due_date}    Evaluate    ${delay}+${min_due_date}
        Set To Dictionary    ${fund_provider_due_date}    ${fund_provider_name}    ${buffer_to_due_date}
    END
    RETURN    ${fund_provider_due_date}

Calculate Difference Between DueDtate And SettlementDate
    [Arguments]
    ...    ${TRACKING_CODE_SETTLEMENT}

    ${settlement_date}    Get Merchant Credit Data By Specific Field
    ...    settlements
    ...    expectedCreditAllocations
    ...    trackingCode=${TRACKING_CODE_SETTLEMENT}

    ${settlement_date_value}    Set Variable    ${settlement_date}[0]
    ${settlement_date_value}    Value Handler    ${settlement_date_value['settlementDate']}

    Set Test Variable    ${expected_settlement_date}    ${settlement_date_value}

    ${due_date}    Get Merchant Credit Data By Specific Field
    ...    settlements
    ...    dueDate
    ...    trackingCode=${TRACKING_CODE_SETTLEMENT}

    ${due_date}    Value Handler    ${due_date}

    Set Test Variable    ${due_date}    ${due_date}

    ${due_date}    Convert Milliseconds To Second Epoch    ${due_date}
    ${expected_settlement_date}    Convert Milliseconds To Second Epoch    ${expected_settlement_date}

    ${diff_dates}    Subtract Date From Date
    ...    ${due_date}
    ...    ${expected_settlement_date}
    ...    verbose
    ...    exclude_millis=yes
    ${diff_dates}    Get Substring    ${diff_dates}    0    2
    RETURN    ${diff_dates}

Calculate Expected Settlement Amount
    [Documentation]    With this keyword you ability calculate expected settlement amount per fund Provider
    [Arguments]
    ...    ${fund_provider}
    ...    ${request_amount}
    ...    ${TRACKING_CODE_SETTLEMENT}

    ${diff_dates}    Calculate Difference Between DueDtate And SettlementDate    ${TRACKING_CODE_SETTLEMENT}

    IF    '${fund_provider}'=='iran-venezuela'
        ${expected_settlement_amount}    Evaluate
        ...    (${request_amount}*365)/((${diff_dates.strip()} * ${IRAN_VENEZULEA_ANNUAL_INTEREST_PERCENTAGE})+365)
        ${expected_settlement_amount}    Convert To Integer    ${expected_settlement_amount}
        RETURN    ${expected_settlement_amount}
    END

Calculate Expected Platform Fee
    [Arguments]
    ...    ${fund_provider}
    ...    ${request_amount}
    ...    ${TRACKING_CODE_SETTLEMENT}

    ${diff_dates}    Calculate Difference Between DueDtate And SettlementDate    ${TRACKING_CODE_SETTLEMENT}

    IF    '${fund_provider}'=='iran-venezuela'
        ${new_dif_date}    Evaluate    ${diff_dates.strip()} + 1
        ${expected_platform_fee}    Evaluate    (${request_amount}*${new_dif_date}* ${PLATFORM_FEE_PERCENTAGE})/365
        ${expected_platform_fee}    Evaluate    math.ceil(${expected_platform_fee})
        RETURN    ${expected_platform_fee}
    END

Calculate Expected Fund Provider Fee
    [Arguments]
    ...    ${fund_provider}
    ...    ${request_amount}
    ...    ${TRACKING_CODE_SETTLEMENT}

    ${diff_dates}    Calculate Difference Between DueDtate And SettlementDate    ${TRACKING_CODE_SETTLEMENT}

    IF    '${fund_provider}'=='iran-venezuela'
        ${expected_fund_provider_fee}    Evaluate
        ...    (${request_amount}*${diff_dates.strip()}* ${IRAN_VENEZULEA_FEE_PERCENTAGE})/365
        ${expected_fund_provider_fee}    Evaluate    math.ceil(${expected_fund_provider_fee})
        RETURN    ${expected_fund_provider_fee}
    END

Get Min Amount Per Fund Provider
    [Arguments]    ${approved_fund_providers}
    # ${min_amount_per_fund_provider} =    Create Dictionary
    FOR    ${fund_provider_name}    IN    @{approved_fund_providers}
        ${fund_provider_min_amount}    Get Merchant Credit Data By Specific Field
        ...    fees
        ...    minAmount
        ...    providerId=${fund_provider_name}
        ${min_amount_per_fund_provider}    Create Dictionary    ${fund_provider_name}    ${fund_provider_min_amount}
        # Set To Dictionary    ${min_amount_per_fund_provider}    ${fund_provider_name}    ${fund_provider_min_amount}
    END
    RETURN    ${min_amount_per_fund_provider}
