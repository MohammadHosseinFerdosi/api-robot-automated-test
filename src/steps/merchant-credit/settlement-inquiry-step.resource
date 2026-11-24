*** Settings ***
Resource    apis/merchant-credit/settlement/get-settlements-inquiry.resource
Resource    steps/merchant-credit/utilities/get-merchant-credit-db-data.resource
Resource    apis/merchant-credit/settlement/get-merchant-credit-settlements-config.resource
Resource    apis/merchant-credit/settlement/post-settlements-preview.resource
Resource    apis/merchant-credit/settlement/get-settlements-rules-fund-provider.resource
Resource    apis/merchant-credit/settlement/put-settlements-fee-init.resource
Resource    services/db/mongo-db-service.resource
Resource    services/backend/value-handler.resource


*** Keywords ***
Update Settlement Status
    [Arguments]    ${status}

    &{find_dic}    Create Dictionary    trackingCode=${TRACKING_CODE_SETTLEMENT}
    ${status}    Convert To Integer    ${status}
    &{update_query}    Create Dictionary    status=${status}
    &{set}    Create Dictionary    $set=&{update_query}
    Mongo Db Update One
    ...    db_name=merchant_credit_db
    ...    collection_name=settlements
    ...    filter_query=${find_dic}
    ...    update_data=${set}

User Enter Requested Amount
    GET Settlements Rules Fund Provider
    ...    ${WEB_SIDE}
    ...    ${REGISTRATION_ID}
    ...    ${TRACKING_CODE_SETTLEMENT}

    GET Merchant Credit Settlements Config
    ...    ${WEB_SIDE}
    ...    ${TRACKING_CODE_SETTLEMENT}
    ...    ${IRAN_VENEZULEA_INDIVIDUAL_RULE_ID}

    ${preview_response}    POST Settlements Preview
    ...    ${WEB_SIDE}
    ...    15000000
    ...    ${IRAN_VENEZULEA_INDIVIDUAL_RULE_ID}

    Put Settlements Fee Init    ${WEB_SIDE}    15000000    ${IRAN_VENEZULEA_INDIVIDUAL_RULE_ID}

Business Get Inquiry
    [Arguments]    ${status}

    Update Settlement Status    ${status}

    ${inquiry_result}    GET Settlements Inquiry    ${GENERAL_SIDE}    ${TRACKING_CODE_SETTLEMENT}
    Set Test Variable    ${inquiry_result}    ${inquiry_result}[body]

    ${settlements_db_result}    Get Merchant Credit Data By Specific Field
    ...    settlements
    ...    trackingCode=${TRACKING_CODE_SETTLEMENT}
    ...    businessId=${BUSINESS_ID}
    Set Test Variable    ${settlements_db_result}
    ${settlement_db_dueDate}    Value Handler    ${settlements_db_result['dueDate']}
    ${dueDate}    Convert To Integer    ${settlement_db_dueDate}
    Set Test Variable    ${dueDate}

Receive Response With Shoulde Be Status 0
    Should Be Equal    ${inquiry_result}[status]    ${0}
    Should Be Equal    ${inquiry_result}[dueDate]    ${dueDate}

The User Paid Fee And Business Get Inquiry
    [Arguments]    ${status}

    User Enter Requested Amount
    Update Settlement Status    ${status}

    ${inquiry_result}    GET Settlements Inquiry    ${GENERAL_SIDE}    ${TRACKING_CODE_SETTLEMENT}
    Set Test Variable    ${inquiry_result}    ${inquiry_result}[body]

    ${settlements_db_result}    Get Merchant Credit Data By Specific Field
    ...    settlements
    ...    trackingCode=${TRACKING_CODE_SETTLEMENT}

    Set Test Variable    ${settlements_db_result}
    ${settlement_db_dueDate}    Value Handler    ${settlements_db_result['dueDate']}
    ${dueDate}    Convert To Integer    ${settlement_db_dueDate}

    ${settlement_db_expected_credit_allocation}    Set Variable
    ...    ${settlements_db_result['expectedCreditAllocations']}[0]
    ${settlement_db_amount}    Value Handler    ${settlement_db_expected_credit_allocation['settlementAmount']}
    ${settlement_db_fp_interest}    Value Handler
    ...    ${settlement_db_expected_credit_allocation['fundProviderInterest']}
    ${settlement_db_date}    Value Handler    ${settlement_db_expected_credit_allocation['settlementDate']}

    ${settlementAmount}    Convert To Integer
    ...    ${settlement_db_amount}
    ${fundProviderInterest}    Convert To Integer
    ...    ${settlement_db_fp_interest}
    ${settlementDate}    Convert To Integer
    ...    ${settlement_db_date}
    Set Test Variable    ${settlementDate}
    Set Test Variable    ${dueDate}
    Set Test Variable    ${fundProviderInterest}
    Set Test Variable    ${settlementAmount}

    ${requestedAmount}    Evaluate    ${settlementAmount} + ${fundProviderInterest}
    Set Test Variable    ${requestedAmount}

Receive Response With Shoulde Be Status 1
    Should Be Equal    ${inquiry_result}[status]    ${1}
    Should Be Equal    ${inquiry_result}[dueDate]    ${dueDate}
    Should Be Equal    ${inquiry_result}[fundProviderCode]    ${settlements_db_result}[fundProvider]
    Should Be Equal    ${inquiry_result}[requestedAmount]    ${requestedAmount}
    Should Be Equal    ${inquiry_result}[allocatedAmount]    ${settlementAmount}
    Should Be Equal    ${inquiry_result}[settlementDate]    ${settlementDate}

Receive Response With Shoulde Be Status 3
    Should Be Equal    ${inquiry_result}[status]    ${3}
    Should Be Equal    ${inquiry_result}[dueDate]    ${dueDate}
    Should Be Equal    ${inquiry_result}[fundProviderCode]    ${settlements_db_result}[fundProvider]
    Should Be Equal    ${inquiry_result}[requestedAmount]    ${requestedAmount}
    Should Be Equal    ${inquiry_result}[allocatedAmount]    ${settlementAmount}
    Should Be Equal    ${inquiry_result}[settlementDate]    ${settlementDate}
