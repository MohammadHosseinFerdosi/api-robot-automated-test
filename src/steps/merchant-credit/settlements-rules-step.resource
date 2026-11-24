*** Settings ***
Resource        apis/merchant-credit/settlement/get-settlements-rules-fund-provider.resource
Resource        steps/merchant-credit/utilities/get-merchant-credit-db-data.resource
Resource        steps/merchant-credit/utilities/settlement-utilities.resource
Resource        services/backend/auth-service.resource
Resource        services/db/mongo-db-service.resource
Resource        steps/merchant-credit/utilities/common-step.resource
Variables       data/lms/purchase-bnpl.yaml
Variables       data/merchant-credit/merchant-credit-variables.yaml
Library         DateTime
Library         BuiltIn


*** Keywords ***
Show Fund Provider To User
    [Documentation]    This keywords call settlement rules API and sets ${registartion_id} and ${trackingcode}
    ${BUSINESS_ID} =    Login Per Business And Set Business Id    ${DG_USERNAME}
    Set Suite Variable    ${BUSINESS_ID}
    ${rules_response} =    GET Settlements Rules Fund Provider
    ...    ${GENERAL_SIDE}
    ...    ${REGISTRATION_ID}
    ...    ${trackingCode_settlement}

    ${RULE_DETAIL} =    Set Variable    ${rules_response.body.ruleDetails}
    Set Suite Variable    ${RULE_DETAIL}

Find User's Approved Fund Providers
    [Documentation]    This keywords return a list of the user's approved fund providers from database
    ${all_fund_provider} =    Get Merchant Credit Data By Specific Field
    ...    merchants
    ...    fundProvider
    ...    registrationId=${REGISTRATION_ID}    status=${MERCHANT_APPROVE_STATUS}

    @{approved_fund_providers} =    Create List
    Append To List    ${approved_fund_providers}    ${all_fund_provider}
    Set Suite Variable    ${approved_fund_providers}

Fund Provider Displayed Equal To All User's Approved Fund Provider
    [Documentation]    This Keyword Compares The List Resulting From The Rules API Call And A List Of The User's Approved Fund Provider Extracted From DataBas.
    ...    Both Lists Must Be Equal.

    @{all_ruleId} =    Create List
    FOR    ${item}    IN    @{RULE_DETAIL}
        Append To List    ${all_ruleId}    ${item.ruleId}
    END

    @{all_fund_provider_name} =    Create List
    FOR    ${rule_Id}    IN    @{all_ruleId}
        ${fund_provider_name} =    Get Merchant Credit Data By Specific Field
        ...    rules
        ...    fundProviderId
        ...    uid=${rule_Id}
        Append To List    ${all_fund_provider_name}    ${fund_provider_name}
    END
    RETURN    ${all_fund_provider_name}
    Should Be Equal    ${all_fund_provider_name}    ${approved_fund_providers}

Find Active Fund Providers Per Business
    [Documentation]    This Keyword Find Active Fund Providers Per Business
    ${all_fund_providers_business} =    Get Merchant Credit Data By Specific Field
    ...    businesses
    ...    foundProviders
    ...    businessId=${BUSINESS_ID}

    @{active_fund_providers_business} =    Create List
    FOR    ${fund_provider}    IN    @{all_fund_providers_business}
        IF    '${fund_provider}[settlementConfig][active]' == 'True'
            Append To List    ${active_fund_providers_business}    ${fund_provider}[fundProviderId]
            Set Suite Variable    ${active_fund_providers_business}
        END
    END

Fund Provider Displayed Equal To All Ative Per Business Fund Provider
    [Documentation]    This Keyword Check Fund Provider Displayed To User With Business's Active Fund Providers
    FOR    ${item}    IN    @{RULE_DETAIL}
        Should Contain    ${active_fund_providers_business}    ${item}[fundProviderId]
    END
