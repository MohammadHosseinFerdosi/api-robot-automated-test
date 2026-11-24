*** Settings ***
Library     String
Library     Collections
Library     RequestsLibrary
Resource    services/backend/session-service.resource
Resource    services/backend/auth-service.resource


*** Keywords ***
POST Admin Profiles
    [Documentation]
    ...    Sends a request to the Admin Profiles API with the specified parameters.
    ...    This API is used to create profiles in the system.
    ...    It accepts various parameters such as profile configurations and settings
    ...    to define the admin profile appropriately.
    [Arguments]
    ...    ${api_call_side}
    ...    ${expiration_type}
    ...    ${expiration_value}
    ...    ${billing_cycle_type}
    ...    ${consumption_count}
    ...    ${contract_generation_type}
    ...    ${grace_period_type}
    ...    ${grace_period_value}
    ...    ${has_credit_agreement}
    ...    ${has_residue}
    ...    ${has_revolve}
    ...    ${installment_due_date_type}
    ...    ${installment_due_date_value}
    ...    ${manual_settlement_action}
    ...    ${manual_settlement_day}
    ...    ${manual_settlement_offset}
    ...    ${manual_settlement_payment_method}
    ...    ${down_payment_percentage}
    ...    ${interest_percentage}
    ...    ${penalty_percentage}
    ...    ${installment_count_list}
    ...    ${payment_plan}
    ...    ${payment_method}
    ...    ${fund_provider_fee_list}
    ...    ${platform_fee_list}
    ...    ${repayment_option}
    ...    ${service_type}
    ...    ${status}
    ...    ${tag}
    ...    ${user_id}

    ${api_path}=    Set Variable    /admin/profiles

    IF    '${api_call_side}'=='${MICROSERVICE_SIDE}'
        ${api_path}=    Set Variable    ${MS_CREDIT_PROFILE_MNG_PATH}${api_path}
    END

    ${headers}=    Create Dictionary
    ...    accept=application/json
    ...    User-Id=${user_id}
    ...    Content-Type=application/json

    ${expiration}=    Create Dictionary    type=${expiration_type}    value=${expiration_value}
    ${billing_cycle_profile}=    Create Dictionary    type=${billing_cycle_type}
    ${consumption_period}=    Create Dictionary
    ...    billingCycleProfile=${billing_cycle_profile}
    ...    count=${consumption_count}
    ${grace_period}=    Create Dictionary    type=${grace_period_type}    value=${grace_period_value}
    ${installment_due_date}=    Create Dictionary
    ...    type=${installment_due_date_type}
    ...    value=${installment_due_date_value}
    ${manual_settlement}=    Create Dictionary
    ...    action=${manual_settlement_action}
    ...    day=${manual_settlement_day}
    ...    offset=${manual_settlement_offset}
    ...    paymentMethod=${manual_settlement_payment_method}

    ${payment_term}=    Create Dictionary
    ...    interestPercentage=${interest_percentage}
    ...    downPaymentPercentage=${down_payment_percentage}
    ...    penaltyPercentage=${penalty_percentage}
    ...    installmentCount=${installment_count_list}
    ...    paymentPlan=${payment_plan}
    ...    paymentMethod=${payment_method}
    ...    fundProviderFee=${fund_provider_fee_list}
    ...    platformFee=${platform_fee_list}

    ${account}=    Create Dictionary    expiration=${expiration}

    ${profile}=    Create Dictionary
    ...    account=${account}
    ...    consumptionPeriod=${consumption_period}
    ...    contractGenerationType=${contract_generation_type}
    ...    gracePeriod=${grace_period}
    ...    hasCreditAgreement=${has_credit_agreement}
    ...    hasResidue=${has_residue}
    ...    hasRevolve=${has_revolve}
    ...    installmentDueDate=${installment_due_date}
    ...    manualSettlement=${manual_settlement}
    ...    paymentTerm=${payment_term}
    ...    repaymentOption=${repayment_option}
    ...    serviceType=${service_type}
    ...    status=${status}
    ...    tag=${tag}

    ${body}=    Create Dictionary    profile=${profile}

    ${session}=    Create A Session    ${api_call_side}

    ${response}=    POST On Session
    ...    ${session}
    ...    ${api_path}
    ...    json=${body}
    ...    headers=${headers}
    ...    expected_status=any

    ${result}=    Create Dictionary    status_code=${response.status_code}    body=${response.json()}
    RETURN    ${result}

    [Teardown]    Delete A Session    ${session}
