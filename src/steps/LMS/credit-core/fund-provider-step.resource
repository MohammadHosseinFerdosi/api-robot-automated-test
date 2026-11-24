*** Settings ***
Resource    apis/lms/credit-core/post-admin-credit-fund-providers.resource
Resource    services/backend/LMS/credit-core/fund-provider.resource


*** Keywords ***
Create Fund Provider With Valid Data
    [Documentation]    Test case to validate successful Fund Provider creation and database entries.
    [Arguments]
    ...    ${business_id}=TESTAUTOMATION
    ...    ${code}=${EMPTY}
    ...    ${name}=TEST_AUTOMATION
    ...    ${english_name}=TEST_AUTOMATION
    ...    ${crn}=Random Number
    ...    ${type}=1
    ...    ${active}=true
    ...    ${relay_cutoff_start_time}=23:00
    ...    ${relay_cutoff_end_time}=23:59
    ...    ${payment_cutoff_start_time}=23:00
    ...    ${payment_cutoff_end_time}=23:59
    ...    ${payment_flow}=0
    ...    ${product_types}=1
    ...    ${minimum_credit_amount}=Random Number
    ...    ${instant_finalization}=true
    ...    ${whitelist_merchants}=${COMPANY_USER_ID}
    ...    ${payment_strategy}=4
    ...    ${final_refund_strategy}=0
    ...    ${draft_refund_strategy}=0
    ...    ${user_id}=${DASHBOARD_USERNAME}
    Wait Until Keyword Succeeds    50x    1s    Generate Unique Code    ${code}
    ${find_dic}=    Create Dictionary    business_id=${business_id}
    ${random_uuid}=    Generate Random String    36    [LETTERS][NUMBERS]
    ${business_id}=    Set Variable    ${business_id}${random_uuid}
    Set Test Variable    ${business_id}    ${business_id}
    ${name}=    Set Variable    ${name}_${random_uuid}
    ${english_name}=    Set Variable    ${english_name}_${random_uuid}
    ${crn}=    Generate Random String    9    [NUMBERS]
    ${minimum_credit_amount}=    Generate Random String    1    [NUMBERS]
    ${fund_provider_mng_db}=    Mongo Db Find    fund_provider_mng_db    fund_providers    ${find_dic}
    IF    len(${fund_provider_mng_db['body']})!=0
        IF    '${business_id}'=='${fund_provider_mng_db['body'][0]['business_id']}'
            ${random_uuid}=    Generate Random String    4    [LETTERS][NUMBERS]
            ${business_id}=    Set Variable    ${business_id}${random_uuid}
        END
        IF    '${code}'=='${fund_provider_mng_db['body'][0]['code']}'
            ${random_uuid}=    Generate Random String    2    [NUMBERS]
            ${code}=    Evaluate    ${code}-${random_uuid}
        END
        IF    '${name}'=='${fund_provider_mng_db['body'][0]['name']}'
            ${random_uuid}=    Generate Random String    4    [LETTERS][NUMBERS]
            ${name}=    Set Variable    ${name}_${random_uuid}
        END
        IF    '${crn}'=='${fund_provider_mng_db['body'][0]['crn']}'
            ${random_uuid}=    Generate Random String    2    [NUMBERS]
            ${crn}=    Evaluate    ${crn}+${random_uuid}
        END
        IF    '${english_name}'=='${fund_provider_mng_db['body'][0]['${english_name}']}'
            ${random_uuid}=    Generate Random String    36    [LETTERS][NUMBERS]
            ${english_name}=    Set Variable    ${english_name}_${random_uuid}
        END
    END
    ${fund_provider_data}=    Create Dictionary
    ...    business_id=${business_id}
    ...    code=${code}
    ...    name=${name}
    ...    english_name=${english_name}
    ...    crn=${crn}
    ...    type=${type}
    ...    active=${active}
    ...    relay_cutoff_start_time=${relay_cutoff_start_time}
    ...    relay_cutoff_end_time=${relay_cutoff_end_time}
    ...    payment_cutoff_start_time=${payment_cutoff_start_time}
    ...    payment_cutoff_end_time=${payment_cutoff_end_time}
    ...    payment_flow=${payment_flow}
    ...    product_types=${product_types}
    ...    minimum_credit_amount=${minimum_credit_amount}
    ...    instant_finalization=${instant_finalization}
    ...    whitelist_merchants=${whitelist_merchants}
    ...    payment_strategy=${payment_strategy}
    ...    final_refund_strategy=${final_refund_strategy}
    ...    draft_refund_strategy=${draft_refund_strategy}
    ...    user_id=${user_id}
    ${response}=    Create Fund Provider    ${fund_provider_data}
    ${response}=    Set Test Variable    ${response}

Generate Unique Code
    [Arguments]    ${code}
    ${code}=    Generate Random String    4    [NUMBERS]
    Set Test Variable    ${code}    ${code}
    ${find_code}=    Create Dictionary    code=${code}
    ${FP_CODE_RESULT}=    Mongo Db Find    fund_provider_mng_db    fund_providers    ${find_code}
    IF    len(${FP_CODE_RESULT['body']})!=0
        Fail    Duplicate code found.
    END

Fund Provider Creation Should Succeed
    [Documentation]    Test case to validate successful fund provider creation and database entries.
    Should Be Equal As Numbers    ${response['status_code']}    200
    ${result}=    Set Variable    ${response['body']['result']}
    Should Be Equal As Strings    ${result['title']}    SUCCESS
    Should Be Equal As Strings    ${result['message']}    عملیات با موفقیت انجام شد
    ${fund_provider}=    Set Variable    ${response['body']}
    Should Be Equal As Strings    ${fund_provider['businessId']}    ${business_id}

Fund Provider Creation Should Fail With Duplicate business id
    [Documentation]    Test case to validate that fund provider creation fails with duplicate tag.
    Should Be Equal As Numbers    ${response['status_code']}    400
    ${error_fields}=    Set Variable    ${response['body']['errorFields']}
    Should Contain    ${error_fields[0]['field']}    fund_provider.business_id
    Should Be Equal As Strings
    ...    ${error_fields[0]['message']}
    ...    تامین کننده مالی با این businessId قبلا ثبت شده است.

Fund Provider Creation Should Fail
    [Documentation]    Test case to validate that fund provider creation fails with proper error response.
    Should Be Equal As Numbers    ${response['status_code']}    400
    ${result}=    Set Variable    ${response['body']['result']}
    Should Be Equal As Strings    ${result['title']}    FAILURE
    Should Be Equal As Numbers    ${result['status']}    1000
    Should Be Equal As Strings    ${result['message']}    عملیات ناموفق بود لطفا مجددا تلاش کنید
    Should Be Equal As Strings    ${result['level']}    BLOCKER
