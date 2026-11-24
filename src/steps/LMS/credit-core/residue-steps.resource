*** Settings ***
Resource    services/db/mongo-db-service.resource
Resource    apis/lms/credit-core/post-credit-purchases-refunds.resource
Resource    services/backend/LMS/credit-core/credit-offline-purchase.resource
Resource    services/backend/LMS/credit-core/credit-online-purchase.resource
Resource    services/backend/import-allocation.resource
Resource    services/backend/user-wallet-initializer-service.resource
Resource    services/backend/value-handler.resource
Resource    services/backend/LMS/credit-core/close-account.resource


*** Keywords ***
Reproduce Amount
    [Documentation]    Reproduces the businessId wallets. This is a ```Test Teardown```
    [Arguments]    ${additional_user_lists}=${ALLOCATION_USER_LIST}

    Collect All Amount For Tear Down    additional_user_lists=${additional_user_lists}

Allocate No Fee BNPL Account
    [Documentation]    Allocates a no fee bnpl account on a random user
    ${user_object}    Activate Account
    ...    types=${{['${LMS_Account_Type_1PAY}']}}
    ...    fee_types=${{['${LMS_ZERO_FEE}']}}
    ...    default_amount=60000

    ${cell_number}    Set Variable    ${user_object['user_cell_number']}
    ${user_id}    Set Variable    ${user_object['user_id']}
    ${credit_ids}    Set Variable    ${user_object['user_credit_ids']}
    &{user_data}    Create Dictionary    user_id=${user_id}    type=${CUSTOMER_TYPE}
    ${ALLOCATION_USER_LIST}    Create List    ${user_data}

    Set Test Variable    ${cell_number}
    Set Test Variable    ${user_id}
    Set Test Variable    ${credit_ids}
    Set Test Variable    ${user_object}
    Set Test Variable    ${ALLOCATION_USER_LIST}

Allocate No Fee CCREDIT Account
    [Documentation]    Allocates a no fee c_credit account on a random user
    ${user_object}    Activate Account
    ...    types=${{['${LMS_Account_Type_CREDIT}']}}
    ...    fee_types=${{['${LMS_ZERO_FEE}']}}
    ...    fund_providers=${{['${LMS_FP_MELLAT}']}}
    ...    default_amount=60000

    ${cell_number}    Set Variable    ${user_object['user_cell_number']}
    ${user_id}    Set Variable    ${user_object['user_id']}
    ${credit_ids}    Set Variable    ${user_object['user_credit_ids']}
    &{user_data}    Create Dictionary    user_id=${user_id}    type=${CUSTOMER_TYPE}
    ${ALLOCATION_USER_LIST}    Create List    ${user_data}

    Set Test Variable    ${cell_number}
    Set Test Variable    ${user_id}
    Set Test Variable    ${credit_ids}
    Set Test Variable    ${user_object}
    Set Test Variable    ${ALLOCATION_USER_LIST}

Allocate Fee On Purchase CCREDIT Account
    [Documentation]    Allocates a fee on purchase c_credit account on a random user
    ${user_object}    Activate Account
    ...    types=${{['${LMS_Account_Type_CREDIT}']}}
    ...    fee_types=${{['${LMS_FEE_ON_PURCHASE}']}}
    ...    fund_providers=${{['${LMS_FP_MELLAT}']}}
    ...    default_amount=60000

    ${cell_number}    Set Variable    ${user_object['user_cell_number']}
    ${user_id}    Set Variable    ${user_object['user_id']}
    ${credit_ids}    Set Variable    ${user_object['user_credit_ids']}
    &{user_data}    Create Dictionary    user_id=${user_id}    type=${CUSTOMER_TYPE}
    ${ALLOCATION_USER_LIST}    Create List    ${user_data}

    Set Test Variable    ${cell_number}
    Set Test Variable    ${user_id}
    Set Test Variable    ${credit_ids}
    Set Test Variable    ${user_object}
    Set Test Variable    ${ALLOCATION_USER_LIST}

Allocate Fee On Installment CCREDIT Account
    [Documentation]    Allocates a fee on installment c_credit account on a random user
    ${user_object}    Activate Account
    ...    types=${{['${LMS_Account_Type_CREDIT}']}}
    ...    fee_types=${{['${LMS_FEE_ON_INSTALLMENT}']}}
    ...    fund_providers=${{['${LMS_FP_MELLAT}']}}
    ...    default_amount=60000

    ${cell_number}    Set Variable    ${user_object['user_cell_number']}
    ${user_id}    Set Variable    ${user_object['user_id']}
    ${credit_ids}    Set Variable    ${user_object['user_credit_ids']}
    &{user_data}    Create Dictionary    user_id=${user_id}    type=${CUSTOMER_TYPE}
    ${ALLOCATION_USER_LIST}    Create List    ${user_data}

    Set Test Variable    ${cell_number}
    Set Test Variable    ${user_id}
    Set Test Variable    ${credit_ids}
    Set Test Variable    ${user_object}
    Set Test Variable    ${ALLOCATION_USER_LIST}

Allocate Fee On Allocation CCREDIT Account
    [Documentation]    Allocates a fee on allocation c_credit account on a random user
    ${user_object}    Activate Account
    ...    types=${{['${LMS_Account_Type_CREDIT}']}}
    ...    fee_types=${{['${LMS_FEE_ON_ALLOCATION}']}}
    ...    fund_providers=${{['${LMS_FP_MELLAT}']}}
    ...    default_amount=60000

    ${cell_number}    Set Variable    ${user_object['user_cell_number']}
    ${user_id}    Set Variable    ${user_object['user_id']}
    ${credit_ids}    Set Variable    ${user_object['user_credit_ids']}
    &{user_data}    Create Dictionary    user_id=${user_id}    type=${CUSTOMER_TYPE}
    ${ALLOCATION_USER_LIST}    Create List    ${user_data}

    Set Test Variable    ${cell_number}
    Set Test Variable    ${user_id}
    Set Test Variable    ${credit_ids}
    Set Test Variable    ${user_object}
    Set Test Variable    ${ALLOCATION_USER_LIST}

Allocate No Fee INSTALLMENT SALE Account
    [Documentation]    Allocates a no fee installment_sale account on a random user
    ${user_object}    Activate Account
    ...    types=${{['${LMS_Account_Type_INSTALLMENT_SALE}']}}
    ...    fee_types=${{['${LMS_ZERO_FEE}']}}
    ...    default_amount=60000

    ${cell_number}    Set Variable    ${user_object['user_cell_number']}
    ${user_id}    Set Variable    ${user_object['user_id']}
    ${credit_ids}    Set Variable    ${user_object['user_credit_ids']}
    &{user_data}    Create Dictionary    user_id=${user_id}    type=${CUSTOMER_TYPE}
    ${ALLOCATION_USER_LIST}    Create List    ${user_data}

    Set Test Variable    ${cell_number}
    Set Test Variable    ${user_id}
    Set Test Variable    ${credit_ids}
    Set Test Variable    ${user_object}
    Set Test Variable    ${ALLOCATION_USER_LIST}

Allocate Fee On Purchase INSTALLMENT SALE Account
    [Documentation]    Allocates a fee on purchase installment_sale account on a random user
    ${user_object}    Activate Account
    ...    types=${{['${LMS_Account_Type_INSTALLMENT_SALE}']}}
    ...    fee_types=${{['${LMS_FEE_ON_PURCHASE}']}}
    ...    default_amount=60000

    ${cell_number}    Set Variable    ${user_object['user_cell_number']}
    ${user_id}    Set Variable    ${user_object['user_id']}
    ${credit_ids}    Set Variable    ${user_object['user_credit_ids']}
    &{user_data}    Create Dictionary    user_id=${user_id}    type=${CUSTOMER_TYPE}
    ${ALLOCATION_USER_LIST}    Create List    ${user_data}

    Set Test Variable    ${cell_number}
    Set Test Variable    ${user_id}
    Set Test Variable    ${credit_ids}
    Set Test Variable    ${user_object}
    Set Test Variable    ${ALLOCATION_USER_LIST}

Allocate Fee On Installment INSTALLMENT SALE Account
    [Documentation]    Allocates a fee on installment installment_sale account on a random user
    ${user_object}    Activate Account
    ...    types=${{['${LMS_Account_Type_INSTALLMENT_SALE}']}}
    ...    fee_types=${{['${LMS_FEE_ON_INSTALLMENT}']}}
    ...    default_amount=60000

    ${cell_number}    Set Variable    ${user_object['user_cell_number']}
    ${user_id}    Set Variable    ${user_object['user_id']}
    ${credit_ids}    Set Variable    ${user_object['user_credit_ids']}
    &{user_data}    Create Dictionary    user_id=${user_id}    type=${CUSTOMER_TYPE}
    ${ALLOCATION_USER_LIST}    Create List    ${user_data}

    Set Test Variable    ${cell_number}
    Set Test Variable    ${user_id}
    Set Test Variable    ${credit_ids}
    Set Test Variable    ${user_object}
    Set Test Variable    ${ALLOCATION_USER_LIST}

Allocate Fee On Allocation INSTALLMENT SALE Account
    [Documentation]    Allocates a fee on allocation installment_sale account on a random user
    ${user_object}    Activate Account
    ...    types=${{['${LMS_Account_Type_INSTALLMENT_SALE}']}}
    ...    fee_types=${{['${LMS_FEE_ON_ALLOCATION}']}}
    ...    default_amount=60000

    ${cell_number}    Set Variable    ${user_object['user_cell_number']}
    ${user_id}    Set Variable    ${user_object['user_id']}
    ${credit_ids}    Set Variable    ${user_object['user_credit_ids']}
    &{user_data}    Create Dictionary    user_id=${user_id}    type=${CUSTOMER_TYPE}
    ${ALLOCATION_USER_LIST}    Create List    ${user_data}

    Set Test Variable    ${cell_number}
    Set Test Variable    ${user_id}
    Set Test Variable    ${credit_ids}
    Set Test Variable    ${user_object}
    Set Test Variable    ${ALLOCATION_USER_LIST}

Find profile Id By Credit Id
    [Documentation]    This function, traverse the credit-account-mng database -> accounts collection
    ...    and returns the profileId associated with the allocated credit id
    [Arguments]    ${credit_id}
    ${filter_query}    Create Dictionary    creditId=${credit_id}
    ${result}    Mongo Db Find    credit-account-mng_db    accounts    ${filter_query}
    ${body}    Set Variable    ${result['body']}[0]
    ${profile}    Set Variable    ${body['profile']}
    ${profile_id}    Set Variable    ${profile['profileId']}
    RETURN    ${profile_id}

Find Fee Values By Credit Id
    [Documentation]    This function, traverse the credit_mng database -> profiles
    ...    and extract the fee information of the profile associated with the creditId and
    ...    returns these information as a ${fee_info} dictionary.
    ...
    ...    The ${fee_info} dictionary contains two keys 'feeCharge' and 'fpFeeCharge'.
    ...    They may have non-zero values,
    ...    can be zero,
    ...    and if they did not exist in the profile record in the credit-mng, they will be None
    [Arguments]    ${credit_id}

    ${profile_id}    Find profile Id By Credit Id    credit_id=${credit_id}
    ${filter_query}    Create Dictionary    profileId=${profile_id}
    ${result}    Mongo Db Find    credit_mng_db    profiles    ${filter_query}
    ${body}    Set Variable    ${result['body']}[0]

    ${fee_info}    Create Dictionary    feeCharge=None    fpFeeCharge=None

    ${contains_payment_term}    Evaluate    "paymentTerm" in ${body}
    IF    ${contains_payment_term}!=True    RETURN    ${fee_info}

    ${payment_term}    Set Variable    ${body['paymentTerm']}
    ${contains_fee_charge}    Evaluate    "feeCharge" in ${payment_term}
    ${contains_fp_fee_charge}    Evaluate    "fpFeeCharge" in ${payment_term}

    IF    ${contains_fee_charge}==True
        ${fee_charge}    Set Variable    ${payment_term['feeCharge']}
        ${fee_charge}    Set Variable    ${fee_charge['value']}
        ${fee_charge}    Value Handler    ${fee_charge}
        Set To Dictionary    ${fee_info}    feeCharge=${fee_charge}
    END
    IF    ${contains_fp_fee_charge}==True
        ${fp_fee_charge}    Set Variable    ${payment_term['fpFeeCharge']}
        ${fp_fee_charge}    Set Variable    ${fp_fee_charge['value']}
        ${fp_fee_charge}    Value Handler    ${fp_fee_charge}
        Set To Dictionary    ${fee_info}    fpFeeCharge=${fp_fee_charge}
    END
    RETURN    ${fee_info}

Find Residue Ability By Credit Id
    [Documentation]    This function, first finds the profile id associated with the allocated credit id
    ...    and then traverses the credit_profile_mng database -> profiles collection
    ...    and returns the boolean value of hasResidue field.
    [Arguments]    ${credit_id}

    ${profile_id}    Find profile Id By Credit Id    credit_id=${credit_id}
    ${filter_query}    Create Dictionary    profileId=${profile_id}
    ${result}    Mongo Db Find    credit_profile_mng_db    profiles    ${filter_query}
    ${body}    Set Variable    ${result['body']}[0]
    ${has_residue}    Set Variable    ${body['hasResidue']}
    RETURN    ${has_residue}

Check Residue Profiles Credibility By Credit Id
    [Documentation]    This functions checks the values presented in the residue_mng database -> profiles collection
    ...    to match the information from credit mng microservice. The Test will fail if the profiles did not match.
    ...    Incase the credit id is associated with a profile without residue ability, then this step will be ignored.
    ...
    ...    It will set the following as ```TEST``` Variable:
    ...
    ...    1. ${has_residue}: A boolean variable to define whether the profile associated with the credit id has residue or not.
    ...
    ...    2. ${prepayment}: Should be equal to fpFeeCharge.
    ...    If ${has_residue} is ```False``` or fpFeeCharge is 'None', will be set as 'None.
    ...
    ...    3. ${feeCharge}: Should be equal to feeCharge.
    ...    If ${has_residue} is ```False``` or fpFeeCharge is 'None', will be set as 'None.
    ...
    ...    4. ${service_type}: Service type. BNPL is 0, CREDIT is 1, and INSTALLMENT_SALE is 2
    ...
    ...    Returns ${has_residue}, ${prepayment}, ${feeCharge}, and ${service_type} values.
    [Arguments]    ${credit_id}=${credit_ids}[0]

    ${profile_id}    Find profile Id By Credit Id    credit_id=${credit_id}
    ${fee_info}    Find Fee Values By Credit Id    credit_id=${credit_id}

    ${has_residue}    Find Residue Ability By Credit Id    credit_id=${credit_id}

    ${prepayment}    Set Variable    None
    ${feeCharge}    Set Variable    None
    ${service_type}    Set Variable    None

    IF    ${has_residue}!=True
        Set Test Variable    ${has_residue}
        Set Test Variable    ${prepayment}
        Set Test Variable    ${feeCharge}
        Set Test Variable    ${service_type}
        RETURN    ${has_residue}    ${prepayment}    ${feeCharge}    ${service_type}
    END
    ${filter_query}    Create Dictionary    profileId=${profile_id}
    ${result}    Mongo Db Find    residue_mng_db    profiles    ${filter_query}
    ${body}    Set Variable    ${result['body']}[0]

    ${service_type}    Set Variable    ${body['serviceType']}

    ${contains_payment_term}    Evaluate    "paymentTerm" in ${body}
    IF    ${contains_payment_term}!=True
        IF    '${fee_info['feeCharge']}'=='None'
            IF    '${fee_info['fpFeeCharge']}'=='None'
                Set Test Variable    ${has_residue}
                Set Test Variable    ${prepayment}
                Set Test Variable    ${feeCharge}
                Set Test Variable    ${service_type}
                RETURN    ${has_residue}    ${prepayment}    ${feeCharge}    ${service_type}
            ELSE
                Fail
                ...    msg=Found fpFeeCharge ${fee_info['fpFeeCharge']} but did not find a paymentTerm record for the profileId ${profile_id}
            END
        ELSE
            Fail
            ...    msg=Found feeCharge ${fee_info['feeCharge']} but did not find a paymentTerm record for the profileId ${profile_id}
        END
    END

    ${payment_term}    Set Variable    ${body['paymentTerm']}
    ${contains_prepayment}    Evaluate    "prepayment" in ${payment_term}
    ${contains_fee_charge}    Evaluate    "feeCharge" in ${payment_term}

    IF    ${contains_prepayment}!=True
        IF    '${fee_info['fpFeeCharge']}'!='None'
            Fail    msg=Found fpFeeCharge ${fee_info['fpFeeCharge']} but did not find a prepayment item
        END
    ELSE
        ${prepayment}    Set Variable    ${payment_term['prepayment']}
        ${prepayment}    Set Variable    ${prepayment['value']}
        ${prepayment}    Value Handler    ${prepayment}
        IF    '${fee_info['fpFeeCharge']}'!='${prepayment}'
            Fail
            ...    msg=Found fpFeeCharge ${fee_info['fpFeeCharge']} which does not match with the found prepayment ${prepayment}
        END
    END

    IF    ${contains_fee_charge}!=True
        IF    '${fee_info['feeCharge']}'!='None'
            Fail    msg=Found feeCharge ${fee_info['feeCharge']} but did not find a feeCharge item
        END
    ELSE
        ${feeCharge}    Set Variable    ${payment_term['feeCharge']}
        ${feeCharge}    Set Variable    ${feeCharge['value']}
        ${feeCharge}    Value Handler    ${feeCharge}
        IF    '${fee_info['feeCharge']}'!='${feeCharge}'
            Fail
            ...    msg=Found feeCharge ${fee_info['feeCharge']} which does not match with the found feeCharge ${feeCharge}
        END
    END

    Set Test Variable    ${has_residue}
    Set Test Variable    ${prepayment}
    Set Test Variable    ${feeCharge}
    Set Test Variable    ${service_type}
    RETURN    ${has_residue}    ${prepayment}    ${feeCharge}    ${service_type}

Retrieve Balance On Expiration
    [Documentation]    This function, attempts to retrieve the balanceOnExpiration value of a ${credit_id},
    ...    given that it has been expired. This keywords is designed to run
    ...    multiple times in order to capture the ${balance_on_expiration} when the credit expires
    [Arguments]    ${credit_id}

    ${filter_query}    Create Dictionary    creditId=${credit_id}
    ${result}    Mongo Db Find    credit-account-mng_db    accounts    ${filter_query}
    ${body}    Set Variable    ${result['body']}[0]
    ${balance_on_expiration}    Set Variable    ${body['balanceOnExpiration']}
    ${balance_on_expiration}    Value Handler    ${balance_on_expiration}
    RETURN    ${balance_on_expiration}

Just Expire credit account
    [Documentation]    Wrapper for the Expiration Service. Forces the default strategy as the scheduler takes 15 minutes to pick the credit id to expire.
    [Arguments]    ${credit_id}=${credit_ids}[0]

    Expiration Time Setter    credit_id=${credit_id}    force_default=True

Expire Account And Retrieve Balance On Expiration
    [Documentation]    This function, uses the ${credit_id} to expire the account associated
    ...    with that id in the credit-account-mng database -> accounts collection
    ...    and returns the ${initial_balance} as well as the ${balance_on_expiration}.
    ...    Set the returns to ```TEST``` Variables as well.
    [Arguments]    ${credit_id}=${credit_ids}[0]

    ${filter_query}    Create Dictionary    creditId=${credit_id}
    ${result}    Mongo Db Find    credit-account-mng_db    accounts    ${filter_query}
    ${body}    Set Variable    ${result['body']}[0]
    ${initial_balance}    Set Variable    ${body['initialBalance']}

    Just Expire credit account    credit_id=${credit_id}

    ${balance_on_expiration}    Wait Until Keyword Succeeds
    ...    10 minute
    ...    5 s
    ...    Retrieve Balance On Expiration
    ...    credit_id=${credit_id}

    ${initial_balance}    Value Handler    ${initial_balance}
    ${balance_on_expiration}    Value Handler    ${balance_on_expiration}

    Set Test Variable    ${initial_balance}
    Set Test Variable    ${balance_on_expiration}
    RETURN    ${initial_balance}    ${balance_on_expiration}

Check Residue Record Success and Retrieval By Credit Id
    [Documentation]    This function, first checks the residue_mng database -> credit_residues collection
    ...    to see if a record exist that has the creditId ${credit_id} and status ```SUCCESS```.
    ...    Then it will return the values for the following fields:
    ...
    ...    1. ${residue_gross_amount}
    ...    2. ${residue_fee_charge}
    ...    3. ${residue_initial_balance}
    ...    4. ${residue_net_amount}
    ...    5. ${residue_prepayment}
    [Arguments]    ${credit_id}

    ${filter_query}    Create Dictionary    creditId=${credit_id}    status=SUCCESS
    ${result}    Mongo Db Find
    ...    residue_mng_db
    ...    credit_residues
    ...    ${filter_query}

    ${body}    Set Variable    ${result['body']}[0]

    ${residue_gross_amount}    Set Variable    ${body['grossAmount']}
    ${residue_gross_amount}    Value Handler    ${residue_gross_amount}

    ${residue_fee_charge}    Set Variable    ${body['feeCharge']}
    ${residue_fee_charge}    Value Handler    ${residue_fee_charge}

    ${residue_initial_balance}    Set Variable    ${body['initialBalance']}
    ${residue_initial_balance}    Value Handler    ${residue_initial_balance}

    ${residue_net_amount}    Set Variable    ${body['netAmount']}
    ${residue_net_amount}    Value Handler    ${residue_net_amount}

    ${residue_prepayment}    Set Variable    ${body['prepayment']}
    ${residue_prepayment}    Value Handler    ${residue_prepayment}

    ${report}    Create Dictionary
    ...    residue_gross_amount=${residue_gross_amount}
    ...    residue_fee_charge=${residue_fee_charge}
    ...    residue_initial_balance=${residue_initial_balance}
    ...    residue_net_amount=${residue_net_amount}
    ...    residue_prepayment=${residue_prepayment}

    RETURN    ${report}

Residue Record Handler
    [Documentation]    This is a handler function, the primary use of this function is to provide
    ...    a utility for the residue steps to pass on fails. To elaborate on this,
    ...    assume a profileId that does not have the ability to provide residue,
    ...    after the wait on record generation, if the record did not exist,
    ...    then the status would be ```False``` and the test would have been failed;
    ...    Whereas in this utility, we have the option to pass the test because the profile
    ...    did have the residue capability to begin with.
    [Arguments]    ${credit_id}

    Wait Until Keyword Succeeds
    ...    1 minute
    ...    10 s
    ...    Check Residue Record Success and Retrieval By Credit Id    credit_id=${credit_id}

Installment Sale No Purchase Handler
    [Documentation]    Given the business constraints, if a installment sale account is expired without
    ...    having any purchase (that is balance on expiration is equal to the initial balance), the record in residue_mng_db -> credit_residues
    ...    will not be generated and checking the credit_residue_collection would suffice.
    [Arguments]    ${credit_id}

    ${filter_query}    Create Dictionary    creditId=${credit_id}
    ${result}    Mongo Db Find    residue_mng_db    credit_residue_collections    ${filter_query}
    ${body}    Set Variable    ${result['body']}[0]
    ${status}    Set Variable    ${body['status']}
    IF    '${status}'!='1'
        Fail    msg=Found status ${status}, Expected status 1 (At residue_mng_db -> credit_residue_collections)
    END

SMS Handler
    [Documentation]    This handler function, evaluates the SMS sent to the user on a successful residue operation.
    ...    If the residue component has a non-zero prepayment or feeCharge, the SMS will be
    ...    "کاربر گرامی، باقیمانده اعتبارتان، به کیف پول کمپانی‌پی شما منتقل شد. https://dgpy.ir/1d5"
    ...    otherwise it will be
    ...    "کاربر گرامی، باقیمانده اعتبارتان، پس از کسر کارمزد به کیف پول کمپانی‌پی شما منتقل شد. https://dgpy.ir/1d5"
    [Arguments]    ${cell_number}    ${prepayment}    ${fee_charge}

    ${filter_query}    Create Dictionary    recipient=${cell_number}
    ${result}    Mongo Db Find    notification_db    sms_journals    ${filter_query}
    ${body}    Set Variable    ${result['body']}
    ${length}    Get Length    ${body}
    ${flag_type1}    Set Variable    False
    ${flag_type2}    Set Variable    False

    ${item1}    Set Variable    اعتبارتان،
    ${item2}    Set Variable    کسر
    ${item3}    Set Variable    کارمزد

    FOR    ${i}    IN RANGE    ${0}    ${length}    ${1}
        ${record_i}    Set Variable    ${body}[${i}]
        ${msg_list}    Split String    string=${record_i['body']}    separator=${EMPTY}
        ${contained_item1}    Evaluate    '${item1}' in ${msg_list}
        ${contained_item2}    Evaluate    '${item2}' in ${msg_list}
        ${contained_item3}    Evaluate    '${item3}' in ${msg_list}

        IF    ${contained_item1}==True
            IF    ${contained_item2}==True
                IF    ${contained_item3}==True
                    ${flag_type1}    Set Variable    True
                END
            END
        END
        IF    ${contained_item1}==True
            IF    ${contained_item2}==False
                IF    ${contained_item3}==False
                    ${flag_type2}    Set Variable    True
                END
            END
        END
    END

    IF    ${flag_type1}==${flag_type2}
        Fail    msg= In-consistent SMS messages were found. Please investigate the notifications by ${cell_number}
    END

    ${has_prepayment}    Evaluate    ${prepayment}!=0
    ${has_fee_charge}    Evaluate    ${fee_charge}!=0

    IF    ${has_fee_charge}==True
        IF    ${flag_type1}==False
            Fail
            ...    msg=Expected to deduce the fee from the allocated credit, but the SMS was inconsistent with our expectations
        END
    END

    IF    ${has_prepayment}==True
        IF    ${flag_type1}==False
            Fail
            ...    msg=Expected to deduce the fee from the allocated credit, but the SMS was inconsistent with our expectations
        END
    END

    IF    ${has_prepayment}==False
        IF    ${has_fee_charge}==False
            IF    ${flag_type2}==False
                Fail    msg=Expected to send the generic message, but the SMS was inconsistent with our expectations
            END
        END
    END

Check Residue Credit Credibility By Credit Id
    [Documentation]    This function, checks the residue credibility of a credit id.
    ...    First a handler is used find the associated records for this ${credit_id} in the residue mng,
    ...    then if the credit was capable of having a residue account and no record was found,
    ...    test would fail, otherwise the values includes in that record are compared to their ground truth.
    ...
    ...    This include, the correct calculation of fee and prepayments as well as the netAmount and other relevant fields.
    ...
    ...    The inputs include:
    ...
    ...    1. ${credit_id}: The credit id of the account
    ...
    ...    2. ${has_residue}: whether the account is able to have residue or not
    ...
    ...    3. ${prepayment}: The percentage of the prepayment (here is the fund provider fee percentage or fpFeeCharge)
    ...
    ...    4. ${fee_charge}: The percentage of the feeCharge (here is the platform fee percentage or feeCharge)
    ...
    ...    5. ${balance_on_expiration}: Should be equal to the grossAmount
    ...
    ...    6. ${initial_balance}: The initial balance of the loan
    ...
    ...    7. ${service_type}: The service type of the account
    ...
    ...    8. ${cell_number}: Is the cell number of the allocated user; Used to evaluate the sent SMS.
    ...
    ...    --Note: Using previous steps such as ```Check Residue Profiles Credibility By Credit Id``` and ```Expire Account```
    ...    will guarantee the default values existence
    [Arguments]    ${credit_id}=${credit_ids}[0]
    ...    ${has_residue}=${has_residue}
    ...    ${prepayment}=${prepayment}
    ...    ${fee_charge}=${feeCharge}
    ...    ${balance_on_expiration}=${balance_on_expiration}
    ...    ${initial_balance}=${initial_balance}
    ...    ${service_type}=${service_type}
    ...    ${cell_number}=${cell_number}

    ${status}    Run Keyword And Return Status    Residue Record Handler    credit_id=${credit_id}

    IF    '${fee_charge}'=='None'
        ${fee_charge}    Set Variable    0
    END

    IF    '${prepayment}'=='None'
        ${prepayment}    Set Variable    0
    END

    IF    ${has_residue}==True
        IF    ${status}==False
            IF    '${service_type}'=='2'
                IF    '${initial_balance}'!='${balance_on_expiration}'
                    IF    ${balance_on_expiration}!=0
                        Fail
                        ...    msg=The profile associate withe the ${credit_id} has residue capabilities but the residue record was not found in residue_mng database.
                    END
                ELSE
                    Wait Until Keyword Succeeds
                    ...    1 minute
                    ...    10 s
                    ...    Installment Sale No Purchase Handler
                    ...    credit_id=${credit_id}
                END
            ELSE
                IF    ${balance_on_expiration}!=0
                    Fail
                    ...    msg=The profile associate withe the ${credit_id} has residue capabilities but the residue record was not found in residue_mng database.
                END
            END
        ELSE
            ${report}    Check Residue Record Success and Retrieval By Credit Id    credit_id=${credit_id}

            IF    '${report['residue_initial_balance']}'!='${initial_balance}'
                Fail
                ...    msg=Found initialBalance ${initial_balance} in credit-account-mng_db but the initialBalance in residue_mng_db is ${report['residue_initial_balance']}
            END

            IF    '${report['residue_gross_amount']}'!='${balance_on_expiration}'
                Fail
                ...    msg=Found balanceOnExpiration ${balance_on_expiration} in credit-account-mng_db but the grossAmount in residue_mng_db is ${report['residue_gross_amount']}
            END

            ${calculate_fee_charge}    Evaluate    round(${report['residue_gross_amount']} * ${fee_charge} / 100)
            IF    '${report['residue_fee_charge']}'!='${calculate_fee_charge}'
                Fail
                ...    msg=Expected feeCharge ${calculate_fee_charge} = ${fee_charge} x ${balance_on_expiration} / 100 but got ${report['residue_fee_charge']}
            END

            ${calculate_prepayment}    Evaluate    round(${report['residue_gross_amount']} * ${prepayment} / 100)
            IF    '${report['residue_prepayment']}'!='${calculate_prepayment}'
                Fail
                ...    msg=Expected feeCharge ${calculate_prepayment} = ${prepayment} x ${balance_on_expiration} / 100 but got ${report['residue_prepayment']}
            END

            ${calculate_net_amount}    Evaluate
            ...    round(${report['residue_gross_amount']} - ${calculate_fee_charge} - ${calculate_prepayment})
            IF    '${report['residue_net_amount']}'!='${calculate_net_amount}'
                Fail
                ...    msg=Expected feeCharge ${calculate_net_amount} = ${report['residue_gross_amount']} - ${calculate_fee_charge} - ${calculate_prepayment} but got ${report['residue_net_amount']}
            END

            Wait Until Keyword Succeeds
            ...    1 minute
            ...    10 s
            ...    SMS Handler
            ...    cell_number=${cell_number}
            ...    prepayment=${calculate_prepayment}
            ...    fee_charge=${calculate_fee_charge}
        END
    ELSE
        IF    ${status}==True
            Fail
            ...    msg=The profile associate with the ${credit_id} does not have residue capabilities but a residue record was found in residue_mng database.
        END
    END

Purchase Status Must Be CONFIRMED Or DELIVERED
    [Arguments]    ${tracking_code}=${tracking_code}
    ${filter_query}    Create Dictionary    trackingCode=${tracking_code}
    ${result}    Mongo Db Find
    ...    credit_mng_db
    ...    purchases
    ...    ${filter_query}
    @{records}    Get From Dictionary    ${result}    body
    ${result_object}    Set Variable    ${records}[0]
    IF    '${result_object['status']}'!= 'CONFIRMED'
        IF    '${result_object['status']}' != 'DELIVERED'
            Fail
            ...    msg=Expected the status for the purchase to be either CONFIRMED or DELIVERED but got ${result_object['status']}!
        END
    END

Purchase Should Be Assigned To The Billing Cycle
    [Arguments]    ${tracking_code}=${tracking_code}
    ${filter_query}    Create Dictionary    trackingCode=${tracking_code}
    ${result}    Mongo Db Find
    ...    credit_mng_db
    ...    purchases
    ...    ${filter_query}
    @{records}    Get From Dictionary    ${result}    body
    ${result_object}    Set Variable    ${records}[0]
    Should Be Equal As Strings    ${result_object['billingCycleAssigned']}    True

A Full Offline Purchase
    [Documentation]    This step, is used to perform a full offline purchase.
    ...    A full offline purchase is crucial for the scenarios where the residue can only exist if the account has been used.
    ...
    ...    Input variables include:
    ...
    ...    1. ${has_cash}: A boolean variable, which defines whether we should pay some part of purchase as cash or not.
    ...
    ...    2. ${type}: The type of the purchase
    ...
    ...    2. ${user_id}: The user id of the allocated user. If the allocation was successful, it will use its ```TEST``` variables as this input.
    ...
    ...    3. ${credit_id}: This is the creditId of the account the purchase is going to be carried out on.
    ...    If the allocation was successful, it will use its ```TEST``` variables as this input.
    ...    **Note**: make sure that you only use single account allocations as the default value for this argument is going to be the first item in the list.
    ...
    ...    4. ${amount}: The amount of purchase. To do a full purchase, we will use the default allocation amount which is ```30000```.
    ...
    ...    --NOTE: Make sure you have already logged in for businesses as it uses the token generated by the the utilities it provides.
    [Arguments]
    ...    ${has_cash}
    ...    ${type}
    ...    ${user_id}=${user_id}
    ...    ${credit_id}=${credit_ids}[0]
    ...    ${amount}=${DEFAULT_ALLOCATION_AMOUNT}

    ${tracking_code}    Perform A Complete Offline Purchase
    ...    user_id=${user_id}
    ...    credit_id=${credit_id}
    ...    amount=${amount}

    Purchase Status Must Be CONFIRMED Or DELIVERED    tracking_code=${tracking_code}
    Wait Until Keyword Succeeds
    ...    2 minute
    ...    10 s
    ...    Purchase Should Be Assigned To The Billing Cycle
    ...    tracking_code=${tracking_code}

    Set Test Variable    ${tracking_code}

A Full Online Purchase
    [Documentation]    This step, is used to perform a full online purchase.
    ...    A full online purchase is crucial as no refund can be done without a confirmed purchase
    [Arguments]
    ...    ${type}
    ...    ${amount}
    ...    ${cell_number}=${cell_number}
    ...    ${credit_id}=${credit_ids}[0]
    ...    ${user_id}=${user_id}

    ${ticket}    ${tracking_code}    Perform A Complete Online Credit Purchase
    ...    user_id=${user_id}
    ...    credit_id=${credit_id}
    ...    amount=${amount}
    ...    type=${type}
    ...    cell_number=${cell_number}

    Purchase Status Must Be CONFIRMED Or DELIVERED    tracking_code=${tracking_code}
    Wait Until Keyword Succeeds
    ...    2 minute
    ...    10 s
    ...    Purchase Should Be Assigned To The Billing Cycle
    ...    tracking_code=${tracking_code}

    Set Test Variable    ${tracking_code}

A Partial Refund
    [Documentation]    This step, performs a partial refund. Given a ${tracking_Code}, for a residue it is crucial to have some part of credit still un-touched.
    ...    Because INSTALLMENT_SALES purchases have to be carried out in FULL, a partial step is needed to generate a residue record.
    ...
    ...    Input variables include:
    ...
    ...    1. ${sale_tracking_code}: Which is the purchase tracking code of the purchase we wish to refund
    ...
    ...    2. ${amount}: The amount which are going to refund
    ...
    ...    3. ${type}: The type of the purchase
    ...
    ...
    ...    --NOTE: Make sure you have already logged in for businesses as it uses the token generated by the the utilities it provides.
    [Arguments]
    ...    ${amount}
    ...    ${type}
    ...    ${sale_tracking_code}

    ${provider_id}    Generate Random String    15    123456789
    ${result}    POST Credit Purchases Refunds
    ...    api_call_side=${MICROSERVICE_SIDE}
    ...    sale_tracking_code=${sale_tracking_code}
    ...    amount=${amount}
    ...    type=${type}
    ...    provider_id=${provider_id}
    ...    description=LMS AUTOMATED REFUND
    ...    user_id=${COMPANY_USER_ID}
    IF    '${result['status_code']}'!='200'
        Fail    msg=Expected the status code to be 200, but got ${result['status_code']}!
    END

Refund Should Be Successful
    [Documentation]    An Assertion on the refund to make sure it has been successful
    [Arguments]    ${sale_tracking_code}

    ${filter_query}    Create Dictionary    purchaseTrackingCode=${sale_tracking_code}
    ${result}    Mongo Db Find    credit_mng_db    refunds    ${filter_query}
    ${body}    Set Variable    ${result['body']}
    ${length}    Get Length    ${body}
    FOR    ${i}    IN RANGE    ${0}    ${length}    ${1}
        ${record_i}    Set Variable    ${body}[${i}]
        ${status}    Set Variable    ${record_i['status']}
        Should Be Equal As Strings    first=${status}    second=SUCCESS    msg=Refund is ${status}!
    END

Perform A Partial Refund
    [Documentation]    Simply Retries the refund API until it successes
    [Arguments]
    ...    ${amount}
    ...    ${type}
    ...    ${sale_tracking_code}=${tracking_code}

    Wait Until Keyword Succeeds
    ...    2 minute
    ...    10 s
    ...    A Partial Refund
    ...    sale_tracking_code=${sale_tracking_code}
    ...    amount=${amount}
    ...    type=${type}

    Wait Until Keyword Succeeds
    ...    2 minute
    ...    10 s
    ...    Refund Should Be Successful
    ...    sale_tracking_code=${sale_tracking_code}
