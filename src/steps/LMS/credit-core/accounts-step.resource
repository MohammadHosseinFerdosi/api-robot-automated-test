*** Settings ***
Library     library/faker_utils.py    WITH NAME    FakerLibrary
Library     RequestsLibrary
Resource    apis/lms/credit-core/post-admin-credit-accounts-block.resource
Resource    services/backend/import-allocation.resource
Resource    services/backend/user-wallet-initializer-service.resource
Resource    apis/lms/credit-core/get-credit-account-mng-accounts.resource
Resource    apis/lms/credit-core/post-credit-accounts-schedule-close.resource


*** Keywords ***
Reproduce Amount
    [Documentation]    Reproduces the businessId wallets. This is a ```Test Teardown```
    [Arguments]    ${additional_user_lists}=${ALLOCATION_USER_LIST}

    Collect All Amount For Tear Down    additional_user_lists=${additional_user_lists}

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

Set Block Reason
    [Arguments]    ${reason}=${LMS_BLOCK_REASON.ORGANIZATION_REQUEST}
    Set Test Variable    ${BLOCK_REASON}    ${reason}

Call Schedule Close API
    [Documentation]    Checks if the response status code is 200
    [Arguments]    ${credit_id}=${credit_ids}[0]
    ${schedule_close_response}    Post Credit Accounts Schedule Close
    ...    ${MICROSERVICE_SIDE}
    ...    ${credit_ids}[0]
    ...    ${LMS_BLOCK_REASON.ORGANIZATION_REQUEST}
    ...    ${DASHBOARD_USERNAME}
    Set Test Variable    ${schedule_close_response}

Block Credit Account
    [Arguments]
    ...    ${credit_id}=${credit_ids}[0]

    ${response}    Post Admin Credit Accounts Block
    ...    ${MICROSERVICE_SIDE}
    ...    ${credit_id}
    ...    ${BLOCK_REASON}
    ...    ${DASHBOARD_USERNAME}
    Set Test Variable    ${response}

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

Account Information
    [Arguments]    ${creditId}
    ${response}    GET Account Info CreditId From CreditAccount Management
    ...    api_call_side=${MICROSERVICE_SIDE}
    ...    creditId=${creditId}

    ${body}    Set Variable    ${response['body']}
    Set Test Variable    ${body}

    Should Be Equal As Numbers
    ...    first=${response['status_code']}
    ...    second=200
    ...    msg=Expected status code to be 200, got ${response['status_code']} instead.

    #### Assertion ####

Checking BlockingDetail On Account Info
    IF    ${body['status']} == 3
        Should Contain    ${body}    blockingDetail
        Should Contain    ${body['blockingDetail']}    reason
        Should Contain    ${body['blockingDetail']}    applicant
        Should Contain    ${body['blockingDetail']}    time
    ELSE
        Should Not Contain    ${body}    blockingDetail
    END

Checking BlockingDetail On Account Info without Reason
    IF    ${body['status']} == 3
        Should Not Contain    ${body['blockingDetail']}    reason
    ELSE
        Should Not Contain    ${body}    blockingDetail
    END

Checking The ORGANIZATION_REQUEST For Response
    Should Be Equal As Strings    ${body['blockingDetail']['reason']}    0

Checking The USER_VIOLATION For Response
    Should Be Equal As Strings    ${body['blockingDetail']['reason']}    1

Checking The BAD_USER For Response
    Should Be Equal As Strings    ${body['blockingDetail']['reason']}    2

Return the Credit RemainingBalance
    Should Contain    ${body}    remainBalance
