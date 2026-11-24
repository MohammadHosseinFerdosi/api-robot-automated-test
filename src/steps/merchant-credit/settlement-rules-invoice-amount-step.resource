*** Settings ***
Resource    steps/merchant-credit/settlements-rules-step.resource
Resource    services/backend/value-handler.resource


*** Keywords ***
Assert Fund providers Based On Invoice Amount
    [Documentation]    This Keyword Checking The List Resulting From The Rules API Call And List Should Not Include The Per Fund Provider
    [Arguments]
    ...    ${amount}
    Find User's Approved Fund Providers
    ${min_amount_per_fund_provider}=    Get Min Amount Per Fund Provider    ${approved_fund_providers}
    ${max_request_amount}=    Evaluate    ${amount}*${MAX-SETTLEMENT-PERCENTAGE}

    ${dispaly_fund_provider}=    Create List
    FOR    ${fund_provider_name}    IN    @{min_amount_per_fund_provider}
        ${min_fee_value}=    Get From Dictionary    ${min_amount_per_fund_provider}    ${fund_provider_name}
        ${min_fee_value}=    Value Handler    ${min_fee_value}
        ${min_fee_value}=    Convert To Number    ${min_fee_value}
        IF    ${max_request_amount} > ${min_fee_value}
            Append To List    ${dispaly_fund_provider}    ${fund_provider_name}
        END
    END
    ${all_fund_provider_name}=    Fund Provider Displayed Equal To All User's Approved Fund Provider
    Should Be Equal    ${dispaly_fund_provider}    ${all_fund_provider_name}
