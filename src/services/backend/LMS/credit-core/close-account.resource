*** Settings ***
Library     DateTime
Library     RequestsLibrary
Library     Collections
Library     JSONLibrary
Resource    services/db/mongo-db-service.resource
Resource    services/db/mysql-db-service.resource
Resource    apis/los/post-admin-credit-activation-close-review.resource
Resource    services/backend/LMS/credit-core/close-billing-cycles.resource
Resource    services/backend/LMS/credit-core/expire-credit-account.resource


*** Keywords ***
Update installment contract status
    [Tags]    robot:private
    [Arguments]    ${credit_id}
    ${query}    Set Variable    SELECT * FROM installment_db.accounts WHERE credit_id=${credit_id}
    ${result_installment_accounts}    MySQL Fetch All    db_name=installment_db    query=${query}
    ${result_installment_accounts_length}    Get length    ${result_installment_accounts}[body]
    IF    ${result_installment_accounts_length} == 0    Fail
    ${contain_account_id}    Evaluate    "id" in ${result_installment_accounts}[body][0]
    IF    '${contain_account_id}' == 'False'    Fail
    IF    ${contain_account_id}
        ${installment_account_id}    Set Variable    ${result_installment_accounts}[body][0][id]
        ${query}    Set Variable
        ...    UPDATE installment_db.contracts SET status=2 WHERE account_id=${installment_account_id};
        ${result_contract}    MySQL Execute Query    db_name=installment_db    query=${query}
        RETURN    ${result_contract}
    END

Change initial balance to balance on expiration
    [Tags]    robot:private
    [Arguments]    ${credit_id}
    ${query}    Create Dictionary    creditId=${credit_id}
    ${response}    Mongo Db Find    credit-account-mng_db    accounts    ${query}
    @{records}    Get From Dictionary    ${response}    body
    ${balance_on_expiration}    Get From Dictionary    ${records[0]}    balanceOnExpiration
    &{update_initial_balance}    Create Dictionary    initialBalance=${balance_on_expiration}
    &{set_balance_on_expiration_to_initial_balance}    Create Dictionary    $set=&{update_initial_balance}
    &{find_dic}    Create Dictionary    creditId=${credit_id}
    ${result_credit_account}    Mongo Db Update One
    ...    db_name=credit-account-mng_db
    ...    collection_name=accounts
    ...    filter_query=${find_dic}
    ...    update_data=${set_balance_on_expiration_to_initial_balance}
    IF    '${result_credit_account}[body][matched_count]' == '0'    Fail
    RETURN    ${result_credit_account}

Check credit account status
    [Tags]    robot:private
    [Arguments]    ${credit_id}
    ${find_dic}    Create Dictionary    creditId=${credit_id}
    ${account}    Mongo Db Find    credit-account-mng_db    accounts    ${find_dic}
    ${status_credit_account_mng}    Set Variable    ${account}[body][0][status]
    IF    '${status_credit_account_mng}' == '0'    Fail
    RETURN    ${status_credit_account_mng}

Call Close API
    [Tags]    robot:private
    [Arguments]    ${credit_id}
    ${find_dic}    Create Dictionary    creditId=${credit_id}
    ${account}    Mongo Db Find    switch_credit_db    activations    ${find_dic}
    ${status_switch_credit}    Set Variable    ${account}[body][0][status]
    IF    '${status_switch_credit}' == 'ACTIVE'    Fail
    IF    '${status_switch_credit}' == 'READY_TO_CLOSE'
        ${response}    Post Admin Credit Activations Close Review    api_call_side=${MICROSERVICE_SIDE}    credit_id=${credit_id}    user_id=${user_id}
        RETURN    ${response}
    END
    RETURN    ${status_switch_credit}

Check contract generation type
    [Tags]    robot:private
    [Arguments]    ${credit_id}
    ${find_dic}    Create Dictionary    creditId=${credit_id}
    ${account}    Mongo Db Find    credit-account-mng_db    accounts    ${find_dic}
    ${contract_generation_type}    Set Variable    ${account}[body][0][profile][contractGenerationType]
    RETURN    ${contract_generation_type}

Close Account
    [Arguments]    ${credit_id}
    ${find_dic}    Create Dictionary    creditId=${credit_id}
    ${account}    Mongo Db Find    switch_credit_db    activations    ${find_dic}
    ${status_switch_credit}    Set Variable    ${account}[body][0][status]
    IF    '${status_switch_credit}' == 'ACTIVE'
        ${find_filter_query}    Create Dictionary
        ...    creditId=${credit_id}
        ${billing_cycles}    Mongo Db Find
        ...    credit_mng_db
        ...    billing_cycles
        ...    ${find_filter_query}
        ${billing_cycles_length}    Get Length    ${billing_cycles}[body]
        ${billing_cycles_status}    Set Variable    0
        IF    ${billing_cycles_length} != 0
            ${billing_cycles_status}    Close billing cycles    ${credit_id}
        END
        ${contract_generation_type}    Check contract generation type    ${credit_id}
        IF    ('${billing_cycles_status}' == '1') or ('${contract_generation_type}' != 'PER_BILLING_CYCLE')
            Wait Until Keyword Succeeds    30x    10 s    Update installment contract status    ${credit_id}
        END
        Wait Until Keyword Succeeds    30x    10 s    Expire credit account    ${credit_id}    True
        Wait Until Keyword Succeeds    30x    10 s    Change initial balance to balance on expiration    ${credit_id}
        Wait Until Keyword Succeeds    30x    10 s    Call Close API    ${credit_id}
    ELSE IF    '${status_switch_credit}' == 'READY_TO_CLOSE'
        Call Close API    ${credit_id}
    END

Close User Accounts    [Arguments]    ${user_id}
    ${find_dic}    Create Dictionary    userId=${user_id}
    ${accounts}    Mongo Db Find    switch_credit_db    activations    ${find_dic}
    ${length}    Get Length    ${accounts['body']}
    ${index}    Set Variable    0
    WHILE    ${index} < ${length}
        ${creditId}    Set Variable    ${accounts}[body][${index}][creditId]
        Close Account    ${creditId}
        ${index}    Evaluate    ${index} + 1
    END
