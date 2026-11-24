*** Settings ***
Resource    services/backend/LMS/credit-core/close-account.resource
Resource    services/backend/import-allocation.resource
Resource    services/backend/clean-data.resource


*** Tasks ***
Close Account By Credit Id
    [Documentation]    Uses the close account services to close an account associated with the Credit Id.
    ...
    ...    To run please use this format:
    ...
    ...    ```robot --variable creditId:YOUR_CREDIT_ID --task "Close Account By Credit Id" PATH_TO_SCRIPTS\scripts.robot```
    Close Account    credit_id=${creditId}

Close Account By Cell Number
    [Documentation]    Uses the closes account services to close all the accounts associated with the Cell Number.
    ...
    ...    To run please use this format:
    ...
    ...    ```robot --variable cellNumber:YOUR_CELL_NUMBER --task "Close Account By Cell Number" PATH_TO_SCRIPTS\scripts.robot```

    ${user_id}    Find User Id by Cell Number    cell_number=${cellNumber}
    Close User Accounts    user_id=${user_id}

Allocate Account
    [Documentation]    Uses the import allocation services to allocate an account based on the information that was provided.
    ...
    ...    To run please use this format:
    ...
    ...    ```robot --variable allocationConfig:YOUR_JSON_FILE --task "Allocate Account" PATH_TO_SCRIPTS\scripts.robot```

    ${allocationConfig}    Evaluate    ${allocationConfig}

    ${cell_number}    Set Variable    ${allocationConfig['cellNumber']}
    ${national_code}    Set Variable    ${allocationConfig['nationalCode']}
    ${allocation_list}    Set Variable    ${allocationConfig['allocationList']}
    ${num_allocations}    Get Length    ${allocation_list}
    FOR    ${i}    IN RANGE    ${0}    ${num_allocations}    ${1}
        ${configs}    Set Variable    ${allocation_list}[${i}]
        ${type}    Set Variable    ${configs['allocationType']}
        ${fp}    Set Variable    ${configs['fundProviders']}
        ${fee}    Set Variable    ${configs['feeTypes']}
        ${amount}    Set Variable    ${configs['amount']}

        Activate Account
        ...    types=${{['${type}']}}
        ...    fund_providers=${{['${fp}']}}
        ...    fee_types=${{['${fee}']}}
        ...    default_amount=${amount}
        ...    national_code=${national_code}
        ...    cell_number=${cell_number}
        ...    request_origin=${CORTEX_APP}

        Sleep    time_=1sec    reason=Do Not Parallelize!
    END

Clean Bad Data
    [Documentation]    Cleans all database records related to a specific user ID.
    ...    Validates that the provided bad_user_id is safe before running any deletion or cleanup steps.
    ...    This prevents dangerous values (e.g. empty strings, '*', or malformed IDs) that could cause
    ...    unintended mass deletions.
    ...
    ...    To run, please use the following format:
    ...
    ...    robot --variable bad_user_id:YOUR_USER_ID --task "Clean Bad Data" PATH_TO_SCRIPTS\scripts.robot

    Clean User Account    bad_user_id=${bad_user_id}


*** Keywords ***
Find User Id by Cell Number
    [Documentation]    Finds the ${user_id} of a cell number and returns it.
    [Arguments]    ${cell_number}

    ${search_query}    Set Variable    SELECT * FROM switch_credit_db.users WHERE cell_number = '${cell_number}'
    ${result}    MySQL Fetch All    db_name=switch_credit_db    query=${search_query}
    Should Be Equal As Strings    '${result['status_code']}'    '0'
    ${body}    Set Variable    ${result['body']}
    ${user_id}    Set Variable    ${body[0]['user_id']}
    RETURN    ${user_id}
