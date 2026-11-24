*** Settings ***
Resource    apis/lms/credit-core/get-accounts-creditId-eligibility-close.resource
Resource    services/backend/import-allocation.resource
Resource    services/backend/user-wallet-initializer-service.resource


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

Account Should Be Eligible To Close
    [Documentation]    This step, check the eligibility of the account and Fails the test if it is found not eligible
    [Arguments]    ${creditId}

    ${response}    GET Accounts CreditId Eligibility Close
    ...    api_call_side=${MICROSERVICE_SIDE}
    ...    creditId=${creditId}

    Should Be Equal As Numbers
    ...    first=${response['status_code']}
    ...    second=200
    ...    msg=Expected status code to be 200, got ${response['status_code']} instead.

    ${eligibility}    Set Variable    ${response['body']['isAccountClosable']}

    Should Be Equal As Strings
    ...    first='${eligibility}'
    ...    second='True'
    ...    msg=Expected isAccountClosable to be True, got ${eligibility}

Account Should Not Be Eligible To Close
    [Documentation]    This step, check the eligibility of the account and Fails the test if it is found eligible
    [Arguments]    ${creditId}

    ${response}    GET Accounts CreditId Eligibility Close
    ...    api_call_side=${MICROSERVICE_SIDE}
    ...    creditId=${creditId}

    Should Be Equal As Numbers
    ...    first=${response['status_code']}
    ...    second=200
    ...    msg=Expected status code to be 200, got ${response['status_code']} instead.

    ${eligibility}    Set Variable    ${response['body']['isAccountClosable']}

    Should Be Equal As Strings
    ...    first='${eligibility}'
    ...    second='False'
    ...    msg=Expected isAccountClosable to be False, got ${eligibility}
