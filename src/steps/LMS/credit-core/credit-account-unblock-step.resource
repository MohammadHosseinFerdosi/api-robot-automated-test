*** Settings ***
Library     library/faker_utils.py    WITH NAME    FakerLibrary
Library     RequestsLibrary
Resource    apis/lms/credit-core/post-admin-credit-accounts-unblock.resource
Resource    apis/lms/credit-core/post-admin-credit-accounts-block.resource
Resource    services/backend/import-allocation.resource
Resource    services/backend/user-wallet-initializer-service.resource


*** Keywords ***
Reproduce Amount
    [Documentation]    Reproduces the businessId wallets. This is a ```Test Teardown```
    [Arguments]    ${additional_user_lists}=${ALLOCATION_USER_LIST}    ${user_object}=${user_object}

    Collect All Amount For Tear Down    additional_user_lists=${additional_user_lists}

Unblock Credit Account
    [Arguments]
    ...    ${credit_id}=${credit_ids}[0]

    ${response}    Post Admin Credit Accounts Unblock
    ...    ${MICROSERVICE_SIDE}
    ...    ${credit_id}
    ...    ${DASHBOARD_USERNAME}

    Should Be Equal As Integers    ${response['status_code']}
    ...    200
    ...    msg="Expected status code for Credit Accounts Unblock API should be 200, and got" ${response['status_code']}

Account Status Must Not Be Blocked
    [Arguments]
    ...    ${credit_id}=${credit_ids}[0]
    ${find_dic}    Create Dictionary    creditId=${credit_id}
    ${credit_account}    Mongo Db Find    credit-account-mng_db    accounts    ${find_dic}
    ${credit_account_status}    Set Variable    ${credit_account}[body][0][status]

    Should Be Equal As Strings
    ...    first=${credit_account_status}
    ...    second=0
    ...    msg=Expected the account status to be 0, but got ${credit_account_status}

Blocking Detail Must Be Removed
    [Arguments]    ${credit_id}=${credit_ids}[0]

    ${find_dic}    Create Dictionary    creditId=${credit_id}
    ${block_details}    Mongo Db Find    credit-account-mng_db    accounts    ${find_dic}

    Should Not Contain    ${block_details}[body][0]    blockingDetail
    ...    msg=Expected blocking detail to be removed, but found it in the response

Credit Allocation
    [Arguments]    ${types}    ${set_variables_as}=TEST    &{optional_arguments}

    ${user_object}    Activate Account
    ...    types=${types}
    ...    &{optional_arguments}

    ${cell_number}    Set Variable    ${user_object['user_cell_number']}
    ${user_id}    Set Variable    ${user_object['user_id']}
    ${credit_ids}    Set Variable    ${user_object['user_credit_ids']}
    &{user_data}    Create Dictionary    user_id=${user_id}    type=${CUSTOMER_TYPE}
    ${ALLOCATION_USER_LIST}    Create List    ${user_data}

    IF    '${set_variables_as}'=='TEST'
        Set Test Variable    ${cell_number}
        Set Test Variable    ${user_id}
        Set Test Variable    ${credit_ids}
        Set Test Variable    ${user_object}
        Set Test Variable    ${ALLOCATION_USER_LIST}
    END
    IF    '${set_variables_as}'=='SUITE'
        Set Suite Variable    ${cell_number}
        Set Suite Variable    ${user_id}
        Set Suite Variable    ${credit_ids}
        Set Suite Variable    ${user_object}
        Set Suite Variable    ${ALLOCATION_USER_LIST}
    END

Block Credit Account
    [Arguments]
    ...    ${credit_id}=${credit_ids}[0]
    ...    ${BLOCK_REASON}=${LMS_BLOCK_REASON.ORGANIZATION_REQUEST}

    ${response}    Post Admin Credit Accounts Block
    ...    ${MICROSERVICE_SIDE}
    ...    ${credit_id}
    ...    ${BLOCK_REASON}
    ...    ${DASHBOARD_USERNAME}

    Should Be Equal As Integers    ${response['status_code']}
    ...    200
    ...    msg="Expected status code for Credit Accounts Block API should be 200, and got" ${response['status_code']}
