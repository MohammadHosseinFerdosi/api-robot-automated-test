*** Settings ***
Resource    apis/merchant-credit/registration/post-register.resource
Resource    apis/merchant-credit/registration/post-assign-rule.resource
Resource    apis/merchant-credit/registration/put-max-amount.resource
Resource    apis/merchant-credit/admin/put-admin-merchants.resource
Resource    steps/merchant-credit/utilities/settlement-utilities.resource
Library     library/type_converters.py


*** Variables ***
${binary}       AQADAUlERU5USVRZX0VWQUxVQVRJT84AAQBvcmcuc3ByaW5nZnJhbWV3b3JrLnN0YXRlbWFjaGluZS5zdXBwb3J0Lk9ic2VydmFibGVNYfABAAEBamF2YS51dGlsLkFycmF5TGlz9AEAAQJqYXZhLnV0aWwuSGFzaE1h8AEAAwFtZXJjaGFudC1yZWdpc3RyYXRpb24taW5kaXZpZHVhbC1zdGF0ZS1tYWNoaW7lAQEBAA==


*** Keywords ***
Create Merchant
    [Arguments]
    ...    ${api_call_side}
    ...    ${type}
    ...    ${settlement_bucket}
    ...    ${name}
    ...    ${national_code}
    ...    ${cell_number}
    ...    ${register_cell_number}
    ...    ${rule_id}
    ...    ${max_amount}

    # Login For Business    ${DG_USERNAME}    ${DG_PASSWORD}
    ${BUSINESS_ID}    Login Per Business And Set Business Id    ${DG_USERNAME}
    Set Suite Variable    ${BUSINESS_ID}

# Call Register Api And Start Registration Journey
    ${RESULTS}    POST Merchant Register
    ...    ${GENERAL_SIDE}
    ...    ${type}
    ...    ${settlement_bucket}
    ...    ${name}
    ...    ${national_code}
    ...    ${cell_number}
    ...    ${register_cell_number}

    Should Be Equal As Integers
    ...    ${RESULTS.status_code}
    ...    200
    ...    msg= There is a problem about calling the POST Merchant Register then new merchant doesn't create

    ${REGISTRATION_ID}    Set Variable    ${RESULTS.body.registrationId}
    Set Suite Variable    ${Rticket}    ${RESULTS.body.ticket}
    Set Suite Variable    ${REGISTRATION_ID}

# Set Assign Rule Provider
    POST Assign Rule    ${Rticket}    ${GENERAL_SIDE}    ${rule_id}    ${REGISTRATION_ID}

    ${Credit_id}    Wait Until Keyword Succeeds
    ...    1min
    ...    5sec
    ...    Get Merchant Credit Data By Specific Field
    ...    merchants
    ...    creditId
    ...    nationalCode=${national_code}
    Set Suite Variable    ${CREDIT_ID}    ${Credit_id}

# Set MaxCredit Amount Revise
    PUT Max Amount    ${Rticket}    ${GENERAL_SIDE}    ${max_amount}    ${CREDIT_ID}

# Get Dashboard Token
    Login To Dashboard    ${DASHBOARD_USERNAME}    ${DASHBOARD_PASSWORD}

# Check if merchant type is INDIVIDUAL
    IF    '${type}'== '0'
        # Update merchant document to IDENTITY_EVALUATION
        ${get_Current_Date}    Get Time    epoch
        &{find_dic}    Create Dictionary    creditId=${CREDIT_ID}
        &{update_query}    Create Dictionary
        ...    state=${4}
        ...    currentState=IDENTITY_EVALUATION
        ...    journals.3.state=IDENTITY_EVALUATION
        ...    journals.3.date=${${get_Current_Date}*1000}
        &{set}    Create Dictionary    $set=&{update_query}

        Mongo Db Update One
        ...    db_name=merchant_credit_db
        ...    collection_name=merchants
        ...    filter_query=${find_dic}
        ...    update_data=${set}

        # update StateMachine
        &{find_dic}    Create Dictionary    _id=${CREDIT_ID}
        ${state_machine_context_binary}    Binary From Base64    b64_string=${binary}    subtype=00     
        &{update_query}    Create Dictionary    state=IDENTITY_EVALUATION
        Set To Dictionary    ${update_query}    stateMachineContext=${state_machine_context_binary}
        &{set}    Create Dictionary    $set=&{update_query}

        Mongo Db Update One
        ...    db_name=merchant_credit_db
        ...    collection_name=MongoDbRepositoryStateMachine
        ...    filter_query=${find_dic}
        ...    update_data=&{set}
    END
# Check if merchant type is LEGAL
    IF    '${type}'== '1'
        PUT Admin Merchants    ${DASHBOARD_SIDE}    ${Credit_id}    APPROVE
    END

# Update merchant status to FUND_PROVIDER_ACTIVATION
    PUT Admin Merchants
    ...    ${DASHBOARD_SIDE}
    ...    ${Credit_id}
    ...    FUND_PROVIDER_ACTIVATION

# Update merchant status to APPROVE
    &{bank_account}    Create Dictionary
    ...    accountNumber=1234
    ...    customerNumber=1234
    ...    iban=IR370550190580005749240001
    ...    Type=305

    PUT Admin Merchants
    ...    ${DASHBOARD_SIDE}
    ...    ${Credit_id}
    ...    APPROVE
    ...    bank_account=${bank_account}

Delete Merchant
    [Documentation]    This keyword deletes the merchant via the national code, the "delete_settlement" argument is true, this merchant's settlement is also deleted.
    [Arguments]
    ...    ${national_code}
    ...    ${delete_settlement}=${False}
    ${filter_query}    Create Dictionary    nationalCode=${national_code}

    ${RESULTS}    Mongo Db Delete One    merchant_credit_db    merchants    ${filter_query}
    ${RESULTS}    Mongo Db Delete One
    ...    merchant_credit_db
    ...    merchant_ticket_infos
    ...    ${filter_query}

    IF    '${delete_settlement}' == '${True}'
        Run Keyword    Delete Settlement    ${national_code}
    END

    ${result}    Get Merchant Credit Counter Document By Specific Field
    ...    merchants
    ...    creditId
    ...    nationalCode=${national_code}

# Convert ${result} to an integer to ensure proper comparison
    ${result_as_int}    Evaluate    int(${result})
    IF    ${result_as_int} != 0
        Delete Merchant    ${NATIONAL_CODE_LEGAL}    ${True}
    END
