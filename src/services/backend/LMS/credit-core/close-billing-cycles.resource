*** Settings ***
Library     DateTime
Library     Collections
Resource    services/db/mongo-db-service.resource


*** Keywords ***
Close billing cycles
    [Arguments]    ${credit_id}=${credit_ids}[0]
    ${current_date}    Get Time    epoch
    ${yesterday}    Add Time To Date    ${current_date}    -1 days    epoch
    ${yesterday}    Evaluate    int(${yesterday} * 1000)
    ${filter_query}    Create Dictionary    creditId=${credit_id}
    ${update_value}    Create Dictionary    endDate=${yesterday}
    ${update_query}    Create Dictionary    $set=${update_value}
    ${billing_cycle_result}    Mongo Db Update Many
    ...    credit_mng_db
    ...    billing_cycles
    ...    ${filter_query}
    ...    ${update_query}
    IF    '${billing_cycle_result}[body][matched_count]' == '0'
        Fail    Failed to set endDate of billing cycle for creditId: ${credit_id}
    END

    ${find_filter_query}    Create Dictionary
    ...    creditId=${credit_id}
    ${billing_cycles}    Mongo Db Find
    ...    credit_mng_db
    ...    billing_cycles
    ...    ${find_filter_query}
    ${billing_cycles_length}    Get Length    ${billing_cycles}[body]
    IF    ${billing_cycles_length} != 0
        Should Be Equal As Numbers    ${billing_cycles['body'][0]['status']}    1
    END

Check billing cycles status
    [Tags]    robot:private
    [Arguments]    ${credit_id}
    ${find_dic}    Create Dictionary    creditId=${credit_id}
    ${billing_cycles}    Mongo Db Find    credit_mng_db    billing_cycles    ${find_dic}
    ${billing_cycles_status}    Set Variable    ${billing_cycles}[body][0][status]
    IF    '${billing_cycles_status}' == '0'    Fail
    RETURN    ${billing_cycles_status}

Update unassigned purchases status To Expired
    [Arguments]    ${credit_id}
    ${find_query}    Evaluate
    ...    {"$or": [{"status": "INITIATED", "paymentChannel": 2, "billingCycleAssigned": False, "creditId": "${credit_id}"}, {"status": "INITIATED", "paymentChannel": 4, "billingCycleAssigned": False, "creditId": "${credit_id}"}, {"status": "INITIATED", "paymentChannel": 5, "billingCycleAssigned": False, "creditId": "${credit_id}"}, {"status": "INITIATED", "paymentChannel": 6, "billingCycleAssigned": False, "creditId": "${credit_id}"}]}
    ...    json
    ${update_query}    Evaluate    {"$set": {"status": "EXPIRED"}}
    ${result}    Mongo Db Update Many
    ...    db_name=credit_mng_db
    ...    collection_name=purchases
    ...    filter_query=${find_query}
    ...    update_data=${update_query}
    RETURN    ${result}
