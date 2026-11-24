*** Settings ***
Library     String
Resource    apis/merchant-credit/settlement/post-settlements-preview.resource
Resource    apis/merchant-credit/settlement/get-settlements-rules-fund-provider.resource
Resource    apis/merchant-credit/settlement/put-settlements-fee-init.resource
Resource    apis/merchant-credit/settlement/get-merchant-credit-settlements-config.resource
Resource    steps/merchant-credit/utilities/get-merchant-credit-db-data.resource
Resource    steps/merchant-credit/utilities/settlement-utilities.resource


*** Keywords ***
The User Submit Early Settlement
    GET Settlements Rules Fund Provider
    ...    ${WEB_SIDE}
    ...    ${REGISTRATION_ID}
    ...    ${TRACKING_CODE_SETTLEMENT}

    GET Merchant Credit Settlements Config
    ...    ${WEB_SIDE}
    ...    ${TRACKING_CODE_SETTLEMENT}
    ...    ${IRAN_VENEZULEA_INDIVIDUAL_RULE_ID}

The User Enters Request Amount
    [Arguments]    ${request_amount}

    ${preview_response}    POST Settlements Preview
    ...    ${WEB_SIDE}
    ...    ${request_amount}
    ...    ${IRAN_VENEZULEA_INDIVIDUAL_RULE_ID}

    Set Test Variable    ${creditAllocationDetail}    ${preview_response}[response][creditAllocationDetail]

    Put Settlements Fee Init    ${WEB_SIDE}    ${request_amount}    ${IRAN_VENEZULEA_INDIVIDUAL_RULE_ID}

Check Final Amount That User Can Be Received Is Correct
    [Arguments]    ${request_amount}
    ${EXPECTED_SETTLEMENT_AMOUNT}    Calculate Expected Settlement Amount
    ...    iran-venezuela
    ...    ${request_amount}
    ...    ${TRACKING_CODE_SETTLEMENT}
    Set Suite Variable    ${EXPECTED_SETTLEMENT_AMOUNT}
    Should Be Equal    ${EXPECTED_SETTLEMENT_AMOUNT}    ${creditAllocationDetail}[settlementAmount]

Check Platform Fee Is Correct
    [Arguments]    ${request_amount}
    ${expected_platform_fee}    Calculate Expected Platform Fee
    ...    iran-venezuela
    ...    ${request_amount}
    ...    ${TRACKING_CODE_SETTLEMENT}
    Should Be Equal    ${expected_platform_fee}    ${creditAllocationDetail}[platformFee]

Check Fund Provider Fee Is Correct
    [Arguments]    ${request_amount}
    ${expected_fund_provider_fee}    Calculate Expected Fund Provider Fee
    ...    iran-venezuela
    ...    ${request_amount}
    ...    ${TRACKING_CODE_SETTLEMENT}
    Should Be Equal    ${expected_fund_provider_fee}    ${creditAllocationDetail}[fundProviderFee]

Check Fund Provider Interest Is Correct
    [Arguments]    ${request_amount}
    ${fund_provider_interest}    Evaluate    ${request_amount} - ${EXPECTED_SETTLEMENT_AMOUNT}
    Should Be Equal    ${fund_provider_interest}    ${creditAllocationDetail}[fundProviderInterest]
