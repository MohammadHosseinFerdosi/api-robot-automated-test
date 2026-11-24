*** Settings ***
Resource    steps/merchant-credit/settlements-rules-step.resource


*** Keywords ***
Call Settlement Api By Determining Buffer To Due Date
    [Documentation]    This Keyword Calculates The Due Date And Calling Init Settlement API
    [Arguments]
    ...    ${time_gap}
    Find User's Approved Fund Providers
    ${fund_provider_due_date}=    Calculate Min Due Date And Delay Per Fund Provider    ${approved_fund_providers}
    ${value}=    Get Dictionary Values    ${fund_provider_due_date}
    ${BUFFER_TO_DUE_DATE}=    Evaluate    ${value}[0]+${time_gap}
    Set Suite Variable    ${BUFFER_TO_DUE_DATE}
    ${result}=    Create Settlement    ${REGISTRATION_ID}    ${BUFFER_TO_DUE_DATE}    200000000

Assert Fund providers Based On Due Date
    [Documentation]    This Keyword Compares The List Resulting From The Rules API Call And
    ...    A List Of Fund Provider Whose Sum Of Delay And MinDueDate Matches The Due Date Of The User's Invoice. Both Lists Must Be Equal.

    ${fund_provider_due_date}=    calculate min due date and delay per fund provider
    ...    approved_fund_providers=${approved_fund_providers}

    ${dispaly_fund_provider}=    Create List
    FOR    ${fund_provider_name}    IN    @{approved_fund_providers}
        ${due_date_per_fund_provider}=    Get From Dictionary    ${fund_provider_due_date}    ${fund_provider_name}

        IF    ${BUFFER_TO_DUE_DATE} >= ${due_date_per_fund_provider}
            Append To List    ${dispaly_fund_provider}    ${fund_provider_name}
        END
    END
    ${all_fund_provider_name}=    Fund Provider Displayed Equal To All User's Approved Fund Provider
    Should Be Equal    ${dispaly_fund_provider}    ${all_fund_provider_name}
