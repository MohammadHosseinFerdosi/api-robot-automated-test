*** Settings ***
Resource    apis/lms/credit-core/post-admin-profiles.resource
Resource    services/backend/LMS/credit-core/create-profile.resource


*** Keywords ***
Create Profile With Valid Data
    [Documentation]    Test case to validate successful profile creation and database entries.
    [Arguments]
    ...    ${expiration_type}=1
    ...    ${expiration_value}=2061372344000
    ...    ${billing_cycle_type}=4
    ...    ${consumption_count}=1
    ...    ${contract_generation_type}=0
    ...    ${grace_period_type}=2
    ...    ${grace_period_value}=5
    ...    ${has_credit_agreement}=true
    ...    ${has_residue}=true
    ...    ${has_revolve}=true
    ...    ${installment_due_date_type}=0
    ...    ${installment_due_date_value}=1
    ...    ${manual_settlement_action}=1
    ...    ${manual_settlement_day}=6
    ...    ${manual_settlement_offset}=1
    ...    ${manual_settlement_payment_method}=1
    ...    ${down_payment_percentage}=25
    ...    ${interest_percentage}=0.5
    ...    ${penalty_percentage}=86.3
    ...    ${installment_count}=6
    ...    ${payment_plan}=1
    ...    ${payment_method}=0
    ...    ${fund_provider_fee_type}=1
    ...    ${fund_provider_fee_value}=6
    ...    ${fund_provider_fee_pay_type}=1
    ...    ${fund_provider_fee_settlement_type}=2
    ...    ${platform_fee_type}=1
    ...    ${platform_fee_value}=4
    ...    ${platform_fee_pay_type}=1
    ...    ${platform_fee_settlement_type}=3
    ...    ${repayment_option}=1
    ...    ${service_type}=1
    ...    ${status}=0
    ...    ${tag}=AUTOMATION_TEST
    ...    ${user_id}=${DASHBOARD_USERNAME}

    ${find_dic}=    Create Dictionary    tag=${tag}
    ${credit_profile_mng}=    Mongo Db Find    credit_profile_mng_db    profiles    ${find_dic}
    IF    len(${credit_profile_mng['body']})!=0
        IF    '${tag}'=='${credit_profile_mng['body'][0]['tag']}'
            ${random_uuid}=    Generate Random String    36    [LETTERS][NUMBERS]
            ${tag}=    Set Variable    ${tag}_${random_uuid}
        END
    END
    Set Test Variable    ${tag}    ${tag}
    ${installment_count_list}=    Create List    ${installment_count}
    ${fund_provider_fee_items}=    Create Dictionary
    ...    type=${fund_provider_fee_type}
    ...    value=${fund_provider_fee_value}
    ...    payType=${fund_provider_fee_pay_type}
    ...    settlementType=${fund_provider_fee_settlement_type}
    ${fund_provider_fee_list}=    Create List    ${fund_provider_fee_items}
    ${platform_fee_items}=    Create Dictionary
    ...    type=${platform_fee_type}
    ...    value=${platform_fee_value}
    ...    payType=${platform_fee_pay_type}
    ...    settlementType=${platform_fee_settlement_type}
    ${platform_fee_list}=    Create List    ${platform_fee_items}
    ${profile_data}=    Create Dictionary
    ...    expiration_type=${expiration_type}
    ...    expiration_value=${expiration_value}
    ...    billing_cycle_type=${billing_cycle_type}
    ...    consumption_count=${consumption_count}
    ...    contract_generation_type=${contract_generation_type}
    ...    grace_period_type=${grace_period_type}
    ...    grace_period_value=${grace_period_value}
    ...    has_credit_agreement=${has_credit_agreement}
    ...    has_residue=${has_residue}
    ...    has_revolve=${has_revolve}
    ...    installment_due_date_type=${installment_due_date_type}
    ...    installment_due_date_value=${installment_due_date_value}
    ...    manual_settlement_action=${manual_settlement_action}
    ...    manual_settlement_day=${manual_settlement_day}
    ...    manual_settlement_offset=${manual_settlement_offset}
    ...    manual_settlement_payment_method=${manual_settlement_payment_method}
    ...    down_payment_percentage=${down_payment_percentage}
    ...    interest_percentage=${interest_percentage}
    ...    penalty_percentage=${penalty_percentage}
    ...    installment_count_list=${installment_count_list}
    ...    payment_plan=${payment_plan}
    ...    payment_method=${payment_method}
    ...    fund_provider_fee_list=${fund_provider_fee_list}
    ...    platform_fee_list=${platform_fee_list}
    ...    repayment_option=${repayment_option}
    ...    service_type=${service_type}
    ...    status=${status}
    ...    tag=${tag}
    ...    user_id=${user_id}

    ${response}=    Create Profile    ${profile_data}
    ${response}=    Set Test Variable    ${response}

Profile Creation Should Succeed
    [Documentation]    Test case to validate successful profile creation and database entries.
    Should Be Equal As Numbers    ${response['status_code']}    200
    ${result}=    Set Variable    ${response['body']['result']}
    Should Be Equal As Strings    ${result['title']}    SUCCESS
    Should Be Equal As Strings    ${result['message']}    عملیات با موفقیت انجام شد
    ${profile}=    Set Variable    ${response['body']['profile']}
    Should Be Equal As Strings    ${profile['tag']}    ${tag}

Profile Creation Should Fail With Duplicate Tag
    [Documentation]    Test case to validate that profile creation fails with duplicate tag.
    Should Be Equal As Numbers    ${response['status_code']}    400
    ${result}=    Set Variable    ${response['body']['result']}
    Should Be Equal As Strings    ${result['title']}    BAD_REQUEST
    Should Be Equal As Strings    ${result['message']}    درخواست ورودی معتبر نمی باشد
    ${error_fields}=    Set Variable    ${response['body']['errorFields']}
    Should Contain    ${error_fields[0]['field']}    profile.tag
    Should Be Equal As Strings
    ...    ${error_fields[0]['message']}
    ...    نام پروفایل باید یکتا باشد. این نام پیشتر استفاده شده است

Profile Creation Should Fail
    [Documentation]    Test case to validate that profile creation fails with proper error response.
    Should Be Equal As Numbers    ${response['status_code']}    400
    ${result}=    Set Variable    ${response['body']['result']}
    Should Be Equal As Strings    ${result['title']}    FAILURE
    Should Be Equal As Numbers    ${result['status']}    1000
    Should Be Equal As Strings    ${result['message']}    عملیات ناموفق بود لطفا مجددا تلاش کنید
    Should Be Equal As Strings    ${result['level']}    BLOCKER
