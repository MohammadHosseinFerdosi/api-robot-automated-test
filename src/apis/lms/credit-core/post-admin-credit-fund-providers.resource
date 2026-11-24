*** Settings ***
Library     String
Library     Collections
Library     RequestsLibrary
Resource    services/backend/session-service.resource
Resource    services/backend/auth-service.resource


*** Keywords ***
POST Admin Credit Fund Provider
    [Documentation]
    ...    Sends a request to the Admin Fund Provider API with the specified parameters.
    ...    This API is used to create Fund Provider in the system.
    ...    It accepts various parameters such as Fund Provider configurations and settings
    ...    to define the admin Fund Provider appropriately.
    [Arguments]
    ...    ${api_call_side}
    ...    ${business_id}
    ...    ${code}
    ...    ${name}
    ...    ${english_name}
    ...    ${crn}
    ...    ${type}
    ...    ${active}
    ...    ${relay_cutoff_start_time}
    ...    ${relay_cutoff_end_time}
    ...    ${payment_cutoff_start_time}
    ...    ${payment_cutoff_end_time}
    ...    ${payment_flow}
    ...    ${product_types}
    ...    ${minimum_credit_amount}
    ...    ${instant_finalization}
    ...    ${whitelist_merchants}
    ...    ${payment_strategy}
    ...    ${final_refund_strategy}
    ...    ${draft_refund_strategy}
    ...    ${user_id}

    ${api_path}=    Set Variable    /admin/credit/fund-providers

    IF    '${api_call_side}'=='${MICROSERVICE_SIDE}'
        ${api_path}=    Set Variable    ${MS_FUND_PROVIDER_MNG_PATH}${api_path}
    END

    ${product_types}=    Create List    ${product_types}
    ${whitelist_merchants}=    Create List    ${whitelist_merchants}
    ${installmentConfig}=    Create Dictionary
    ...    relayCutoffStartTime=${relay_cutoff_start_time}
    ...    relayCutoffEndTime=${relay_cutoff_end_time}
    ...    paymentCutoffStartTime=${payment_cutoff_start_time}
    ...    paymentCutoffEndTime=${payment_cutoff_end_time}
    ...    paymentFlow=${payment_flow}
    ${purchase_config}=    Create Dictionary
    ...    productTypes=${product_types}
    ...    minimumCreditAmount=${minimum_credit_amount}
    ...    instantFinalization=${instant_finalization}
    ...    whitelistMerchants=${whitelist_merchants}
    ...    paymentStrategy=${payment_strategy}
    ${refund_config}=    Create Dictionary
    ...    finalRefundStrategy=${final_refund_strategy}
    ...    draftRefundStrategy=${draft_refund_strategy}
    ${fund_provider_data}=    Create Dictionary
    ...    businessId=${business_id}
    ...    code=${code}
    ...    name=${name}
    ...    englishName=${english_name}
    ...    crn=${crn}
    ...    type=${type}
    ...    active=${active}
    ...    installmentConfig=${installment_config}
    ...    purchaseConfig=${purchase_config}
    ...    refundConfig=${refund_config}

    ${headers}=    Create Dictionary
    ...    accept=application/json
    ...    User-Id=${user_id}
    ...    Content-Type=application/json

    ${session}=    Create A Session    ${api_call_side}

    ${response}=    POST On Session
    ...    ${session}
    ...    ${api_path}
    ...    json=${fund_provider_data}
    ...    headers=${headers}
    ...    expected_status=any

    ${result}=    Create Dictionary    status_code=${response.status_code}    body=${response.json()}
    RETURN    ${result}

    [Teardown]    Delete A Session    ${session}
