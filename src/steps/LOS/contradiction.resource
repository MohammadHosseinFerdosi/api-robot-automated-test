*** Settings ***
Variables    data/los/credit.yaml
Variables    config/environment-stage.yaml
Library      Process
Library      RequestsLibrary
Library      DateTime
Library      String
Library      Collections
Resource     services/db/mysql-db-service.resource
Resource     services/db/mongo-db-service.resource
Resource     services/backend/LMS/credit-core/close-account.resource
Resource     apis/los/dashboard/post-credit-admin-allocation-contradictions-search.resource
Resource     apis/los/dashboard/post-credit-admin-allocation-contradiction-journal-search.resource
Resource     apis/los/dashboard/get-credit-admin-allocation-contradictions.resource
Resource     apis/los/dashboard/post-credit-admin-allocation-contradictions-batch-inquiry.resource

*** Keywords ***
Admin Searches Allocation Contradictions Successfully
    Admin Searches Allocation Contradictions
    Admin Selects Allocation Contradiction Candidate By Index    0

Admin Searches Allocation Contradiction Journal Successfully
    [Arguments]    ${max_retry}=5
    Admin Searches Allocation Contradiction Journal Successfully With Retry    ${max_retry}

Admin Batch Inquires Allocation Contradictions Successfully
    Admin Batch Inquires Allocation Contradictions
    Admin Finds Batch Inquiry Result In Mongo

Admin Searches Allocation Contradiction Journal Successfully With Retry
    [Arguments]    ${max_retry}=5
    Admin Clears Selected Allocation Contradiction Candidate
    Admin Selects Allocation Contradiction Candidate By Index    0
    Admin Searches Allocation Contradiction Journal For Current Credit
    Admin Corrupts Allocation Contradiction Credit Id In Mongo For Current Credit
    Admin Inquires Allocation Contradiction For Current Credit
    Admin Restores Allocation Contradiction Credit Id In Mongo For Current Credit
    ${status}=    Set Variable    ${ALLOCATION_CONTRADICTION_INQUIRY_RESPONSE.status_code}
    Return From Keyword If    ${status} == 200 or ${status} == 202
    FOR    ${i}    IN RANGE    1    ${max_retry}
        Exit For Loop If    ${{ len($ALLOCATION_CONTRADICTIONS_CREDIT_ID_LIST) < 2 }}
        Admin Selects Next Allocation Contradiction Candidate (Shift)
        Admin Searches Allocation Contradiction Journal For Current Credit
        Admin Inquires Allocation Contradiction For Current Credit
        ${status}=    Set Variable    ${ALLOCATION_CONTRADICTION_INQUIRY_RESPONSE.status_code}
        Return From Keyword If    ${status} == 200 or ${status} == 202
    END
    Fail
    ...    Allocation Contradiction inquiry did not succeed with 200/202 after ${max_retry} attempts.
    ...    Last status=${ALLOCATION_CONTRADICTION_INQUIRY_RESPONSE.status_code}
    ...    Last creditId=${CURRENT_ALLOCATION_CONTRADICTION_CREDIT_ID}
    ...    Last fundProviderCode=${CURRENT_ALLOCATION_CONTRADICTION_FUND_PROVIDER_CODE}

Admin Clears Selected Allocation Contradiction Candidate
    Set Test Variable    ${SELECTED_ALLOCATION_CONTRADICTION_CREDIT_ID}    ${EMPTY}

Admin Searches Allocation Contradictions
    ${fund_provider_codes}=    Create List    ${CREDIT_PARSIAN_FP_CODE}    ${CREDIT_SADERAT_FP_CODE}
    ${restriction}=    Create Dictionary    type=collection    field=fundProviderCode    values=${fund_provider_codes}
    ${restrictions}=    Create List    ${restriction}
    ${orders}=    Create List
    ${result}=    POST Credit Admin Allocation Contradictions Search
    ...    user_id=${ADMIN_USER_ID}
    ...    page=${PAGE}
    ...    size=${SIZE}
    ...    restrictions=${restrictions}
    ...    orders=${orders}
    Set Test Variable    ${ALLOCATION_CONTRADICTIONS_SEARCH_RESPONSE}    ${result}
    Should Be Equal As Numbers    ${ALLOCATION_CONTRADICTIONS_SEARCH_RESPONSE.status_code}    200
    ${response_json}=    Set Variable    ${result.json()}
    ${data_list}=    Get From Dictionary    ${response_json}    data
    ${data_count}=    Get Length    ${data_list}
    Run Keyword If    ${data_count} == 0    Fail
    ...    No allocation contradiction candidates found. Search returned empty data for fundProviderCode(s)=${fund_provider_codes}, page=${PAGE}, size=${SIZE}.
    ${credit_id_list}=    Create List
    ${credit_id_to_fund_provider_code}=    Create Dictionary
    FOR    ${item}    IN    @{data_list}
        ${credit_id}=    Get From Dictionary    ${item}    creditId
        ${fund_provider_code}=    Get From Dictionary    ${item}    fundProviderCode
        Append To List    ${credit_id_list}    ${credit_id}
        Set To Dictionary    ${credit_id_to_fund_provider_code}    ${credit_id}    ${fund_provider_code}
    END
    Set Test Variable    ${ALLOCATION_CONTRADICTIONS_CREDIT_ID_LIST}    ${credit_id_list}
    Set Test Variable    ${ALLOCATION_CONTRADICTIONS_CREDIT_ID_TO_FUND_PROVIDER_CODE}    ${credit_id_to_fund_provider_code}

Admin Selects Allocation Contradiction Candidate By Index
    [Arguments]    ${index}
    ${credit_id}=    Get From List    ${ALLOCATION_CONTRADICTIONS_CREDIT_ID_LIST}    ${index}
    ${fund_provider_code}=    Get From Dictionary    ${ALLOCATION_CONTRADICTIONS_CREDIT_ID_TO_FUND_PROVIDER_CODE}    ${credit_id}
    Set Test Variable    ${CURRENT_ALLOCATION_CONTRADICTION_CREDIT_ID}    ${credit_id}
    Set Test Variable    ${CURRENT_ALLOCATION_CONTRADICTION_FUND_PROVIDER_CODE}    ${fund_provider_code}

Admin Selects Next Allocation Contradiction Candidate (Shift)
    Remove From List    ${ALLOCATION_CONTRADICTIONS_CREDIT_ID_LIST}    0
    Should Not Be Empty    ${ALLOCATION_CONTRADICTIONS_CREDIT_ID_LIST}
    ${credit_id}=    Get From List    ${ALLOCATION_CONTRADICTIONS_CREDIT_ID_LIST}    0
    ${fund_provider_code}=    Get From Dictionary    ${ALLOCATION_CONTRADICTIONS_CREDIT_ID_TO_FUND_PROVIDER_CODE}    ${credit_id}
    Set Test Variable    ${CURRENT_ALLOCATION_CONTRADICTION_CREDIT_ID}    ${credit_id}
    Set Test Variable    ${CURRENT_ALLOCATION_CONTRADICTION_FUND_PROVIDER_CODE}    ${fund_provider_code}

Admin Searches Allocation Contradiction Journal For Current Credit
    ${credit_id_list}=    Create List    ${CURRENT_ALLOCATION_CONTRADICTION_CREDIT_ID}
    ${restriction}=    Create Dictionary    type=collection    field=creditId    values=${credit_id_list}
    ${restrictions}=    Create List    ${restriction}
    ${orders}=    Create List
    ${result}=    POST Credit Admin Allocation Contradiction Journal Search
    ...    user_id=${ADMIN_USER_ID}
    ...    page=${PAGE}
    ...    size=${SIZE}
    ...    restrictions=${restrictions}
    ...    orders=${orders}
    Set Test Variable    ${ALLOCATION_CONTRADICTION_JOURNAL_SEARCH_RESPONSE}    ${result}
    Should Be Equal As Numbers    ${ALLOCATION_CONTRADICTION_JOURNAL_SEARCH_RESPONSE.status_code}    200

Admin Corrupts Allocation Contradiction Credit Id In Mongo For Current Credit
    ${credit_id}=    Set Variable    ${CURRENT_ALLOCATION_CONTRADICTION_CREDIT_ID}
    ${corrupted_credit_id}=    Catenate    SEPARATOR=    ${credit_id}    1
    Set Test Variable    ${CORRUPTED_ALLOCATION_CONTRADICTION_CREDIT_ID}    ${corrupted_credit_id}
    ${filter}=    Create Dictionary    creditId=${credit_id}
    ${update_data}=    Create Dictionary    $set=${{ {'creditId': '${corrupted_credit_id}'} }}
    ${result}=    Mongo Db Update One
    ...    ${SWITCH_CREDIT_DB_NAME}
    ...    allocation_contradictions
    ...    ${filter}
    ...    ${update_data}
    Should Be Equal As Numbers    ${result['status_code']}    0

Admin Restores Allocation Contradiction Credit Id In Mongo For Current Credit
    ${credit_id}=    Set Variable    ${CURRENT_ALLOCATION_CONTRADICTION_CREDIT_ID}
    ${corrupted_credit_id}=    Set Variable    ${CORRUPTED_ALLOCATION_CONTRADICTION_CREDIT_ID}
    ${filter}=    Create Dictionary    creditId=${corrupted_credit_id}
    ${update_data}=    Create Dictionary    $set=${{ {'creditId': '${credit_id}'} }}
    ${result}=    Mongo Db Update One
    ...    ${SWITCH_CREDIT_DB_NAME}
    ...    allocation_contradictions
    ...    ${filter}
    ...    ${update_data}
    Should Be Equal As Numbers    ${result['status_code']}    0

Admin Inquires Allocation Contradiction For Current Credit
    ${credit_id}=    Set Variable    ${CURRENT_ALLOCATION_CONTRADICTION_CREDIT_ID}
    ${fund_provider_code}=    Set Variable    ${CURRENT_ALLOCATION_CONTRADICTION_FUND_PROVIDER_CODE}
    ${result}=    GET Credit Admin Allocation Contradictions By Credit Id
    ...    user_id=${ADMIN_USER_ID}
    ...    credit_id=${credit_id}
    ...    fund_provider_code=${fund_provider_code}
    Set Test Variable    ${ALLOCATION_CONTRADICTION_INQUIRY_RESPONSE}    ${result}
    ${status_code}=    Set Variable    ${ALLOCATION_CONTRADICTION_INQUIRY_RESPONSE.status_code}
    Run Keyword If    ${status_code} == 200 or ${status_code} == 202
    ...    Set Test Variable    ${SELECTED_ALLOCATION_CONTRADICTION_CREDIT_ID}    ${credit_id}

Admin Batch Inquires Allocation Contradictions
    ${now_epoch}=    Get Current Date    result_format=epoch    exclude_millis=yes
    ${to}=    Evaluate    int(${now_epoch}) * 1000
    ${from}=    Evaluate    ${to} - (72 * 60 * 60 * 1000)
    ${fund_provider_code}=    Set Variable    ${CREDIT_SADERAT_FP_CODE}
    ${result}=    POST Credit Admin Allocation Contradictions Batch Inquiry
    ...    user_id=${ADMIN_USER_ID}
    ...    from=${from}
    ...    to=${to}
    ...    fund_provider_code=${fund_provider_code}
    Set Test Variable    ${ALLOCATION_CONTRADICTIONS_BATCH_INQUIRY_RESPONSE}    ${result}
    Should Be Equal As Numbers    ${ALLOCATION_CONTRADICTIONS_BATCH_INQUIRY_RESPONSE.status_code}    200
    ${response_json}=    Set Variable    ${ALLOCATION_CONTRADICTIONS_BATCH_INQUIRY_RESPONSE.json()}
    ${tracking_code}=    Get From Dictionary    ${response_json}    trackingCode
    Should Not Be Empty    ${tracking_code}
    Set Test Variable    ${ALLOCATION_CONTRADICTIONS_BATCH_TRACKING_CODE}    ${tracking_code}

Admin Finds Batch Inquiry Result In Mongo
    ${tracking_code}=    Set Variable    ${ALLOCATION_CONTRADICTIONS_BATCH_TRACKING_CODE}
    Should Not Be Empty    ${tracking_code}
    ${filter}=    Create Dictionary    trackingCode=${tracking_code}
    ${result}=    Mongo Db Find One
    ...    ${SWITCH_CREDIT_DB_NAME}
    ...    contradiction_inquiry_result
    ...    ${filter}
    Should Be Equal As Numbers    ${result['status_code']}    0
    ${document}=    Set Variable    ${result['body']}
    Run Keyword If    not ${document}    Fail
    ...    No record found in mongo collection=contradiction_inquiry_result for tracking_code=${tracking_code}.