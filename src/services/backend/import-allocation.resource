*** Settings ***
Library         library/allocate_utils.py
Resource        apis/los/post-credit-users-admin-upload.resource
Resource        services/db/mongo-db-service.resource
Resource        services/db/mysql-db-service.resource
Resource        services/backend/fresh-user-initializer-service.resource
Resource        apis/lms/credit-core/post-admin-credit-accounts-unblock.resource
Resource        services/backend/LMS/credit-core/credit-offline-purchase.resource
Resource        services/backend/LMS/installment/installment-initialization.resource
Variables       data/los/default-configs.yaml
Variables       data/lms/initiate-installment-config.yaml


*** Variables ***
${default_path_location}    src/data/los


*** Keywords ***
Delete File Account Name
    [Documentation]    Delete the uploaded file from switch_credit_db -> user_bulk    so that the same
    ...    file name can be uploaded again.
    [Tags]    robot:private
    [Arguments]    ${file_name}

    ${filter_query}    Create Dictionary    name=${file_name}
    Mongo Db Delete One    switch_credit_db    user_bulk    ${filter_query}

Find Status by Credit Id
    [Documentation]    Find the ${status} of a credit Id and returns it.
    [Tags]    robot:private
    [Arguments]    ${credit_id}

    ${filter_query}    Create Dictionary    creditId=${credit_id}

    ${result}    Mongo Db Find    switch_credit_db    activations    ${filter_query}
    ${status}    Set Variable    ${result['body'][0]['status']}
    RETURN    ${status}

Find Service Type by Credit Id
    [Documentation]    Find the ${service_type} of a credit Id and returns it.
    [Tags]    robot:private
    [Arguments]    ${credit_id}

    ${filter_query}    Create Dictionary    creditId=${credit_id}

    ${result}    Mongo Db Find    switch_credit_db    activations    ${filter_query}
    ${service_type}    Set Variable    ${result['body'][0]['serviceType']}
    RETURN    ${service_type}

Find User Id by Credit Id
    [Documentation]    Find the ${user_id} of a credit Id and returns it.
    [Tags]    robot:private
    [Arguments]    ${credit_id}

    ${filter_query}    Create Dictionary    creditId=${credit_id}
    ${result}    Mongo Db Find    switch_credit_db    activations    ${filter_query}
    ${user_id}    Set Variable    ${result['body'][0]['userId']}
    RETURN    ${user_id}

Find Credit Ids by Cell Number
    [Documentation]    Find the credit Ids for a ${cell_number} that are ACTIVE.
    ...    Can be filtered to return the ${credit_id} for a specific allocation based on the ${group_id}.
    [Tags]    robot:private
    [Arguments]    ${cell_number}    ${group_id}=${EMPTY}

    IF    '${group_id}'=='${EMPTY}'
        ${filter_query}    Create Dictionary    cellNumber=${cell_number}    status=ACTIVE
        ${result}    Mongo Db Find    switch_credit_db    activations    ${filter_query}
    ELSE
        ${filter_query}    Create Dictionary    cellNumber=${cell_number}    group.groupId=${group_id}    status=ACTIVE
        ${result}    Mongo Db Find    switch_credit_db    activations    ${filter_query}
    END

    ${credit_ids}    Create List
    ${length}    Get Length    ${result['body']}

    FOR    ${i}    IN RANGE    ${0}    ${length}    ${1}
        Append To List    ${credit_ids}    ${result['body'][${i}]['creditId']}
    END

    RETURN    ${credit_ids}

Credit Ids Exist In Account Management
    [Documentation]    Checks whether a list of credit ids exist in credit account mng or not, fails if they are not there
    [Tags]    robot:private
    [Arguments]    ${credit_ids}
    ${length}    Get Length    ${credit_ids}
    FOR    ${i}    IN RANGE    ${0}    ${length}    ${1}
        ${filter_query}    Create Dictionary    creditId=${credit_ids}[${i}]    status=${0}
        ${result}    Mongo Db Find    credit-account-mng_db    accounts    ${filter_query}
        Should Be Equal As Strings
        ...    ${result['status_code']}
        ...    0
        ...    msg=Expected the credit_account_mng connection to return status code 0 but got ${result['status_code']}
        ${found_account}    Get Length    ${result['body']}
        Should Be Equal As Strings
        ...    ${found_account}
        ...    1
        ...    msg=Expected to find only 1 account, but found ${found_account}
    END

Is Allocation Complete
    [Documentation]    This function/keyword search the switch_credit_db to make sure that the allocation was indeed successful.
    ...    Fails if it could not find an active plan according to the group_id.
    ...
    ...    Input arguments are ${cell_number} and ${group_id}.
    ...
    ...    Returns the ${credit_id} of the successful allocation
    [Tags]    robot:private
    [Arguments]    ${cell_number}    ${group_id}

    ${credit_ids}    Find Credit Ids by Cell Number    cell_number=${cell_number}    group_id=${group_id}
    ${length}    Get Length    ${credit_ids}
    IF    ${length}==0
        Fail
        ...    Allocation failed. Please check the dashboard via groupId: ${group_id} and investigate the reason. Or this might have been caused due to latency issues.
    END
    Wait Until Keyword Succeeds
    ...    1 minute
    ...    2 s
    ...    Credit Ids Exist In Account Management
    ...    ${credit_ids}
    RETURN    ${credit_ids}[0]

Upload File For User
    [Documentation]    Logins to dashboard via
    ...    username: ${DASHBOARD_CREDIT_USERNAME} and password: ${DASHBOARD_CREDIT_PASSWORD}.
    ...    If login was successful, first delete the ${file_name} from ${database_name}->${delete_from_collection}
    ...    and then upload a user's template to be allocated on groupId: ${group_id}. ${filename} is just the name.
    ...
    ...    Input Arguments are ${group_id} and ${file_name}.
    ...
    ...    ${group_id} can be any valid group_id that has been Activated.
    ...
    ...    ${file_name} is the name of the file/template that is being uploaded to the dashboard, into the ${group_id}.
    ...
    ...    ${cell_number} is the cell_number of the user that is being activated.
    ...    It is used to filter whether allocation was a success or not. This is a mandatory input, but the "Upload File For User"
    ...    can still perform without it . Remember that in your automation, you should always include the ${cell_number} to avoid
    ...    false alarms. However, if you are only using this function to just upload a bulk user allocation into a specific group,
    ...    then feel free to skip the ${cell_number}.
    ...
    ...
    ...    **--Note**: If the upload fails, which might fail due to invalid ${cell_number},    ${natioanl_code},
    ...    or unnecessary fields; Your test will fail.
    ...    However, if your template includes incorrect information such as incorrect ${inst_counts}, the allocation will fail
    ...    but the test will be marked as a pass. This is an internal feature with the response of the API responsible for the
    ...    user's file upload to the dashboard.
    ...
    ...    These cases are handled with a new the feature ${cell_number}; By indicating the ${cell_number} of the allocation-user
    ...    The function will then look into the database to see whether the allocation was a success or not and will Fail if it
    ...    could not find the record. This happens when the return result of the "Find Credit Ids by Cell Number" has length 0
    ...    or the status is anything but ACTIVE.
    ...
    ...    Remember that if the user has an identical allocation plan, this layer does not fail it;
    ...    but it is going to fail on the API level.
    [Arguments]    ${group_id}    ${file_name}    ${cell_number}=${EMPTY}    ${api_call_side}=${MICROSERVICE_SIDE}

    ${file}    Get File For Streaming Upload    ${default_path_location}/${file_name}

    IF    '${api_call_side}'=='${DASHBOARD_SIDE}'
        Wait Until Keyword Succeeds
        ...    1 minute
        ...    1 s
        ...    Login To Dashboard
        ...    username=${DASHBOARD_CREDIT_USERNAME}
        ...    password=${DASHBOARD_CREDIT_PASSWORD}
    END

    ${response_upload}    POST Credit Users Admin Upload
    ...    ${api_call_side}
    ...    ${group_id}
    ...    ${file}
    ...    ${DASHBOARD_USERNAME}

    IF    '${cell_number}'!='${EMPTY}'
        ${credit_id}    Wait Until Keyword Succeeds
        ...    1 minute
        ...    1 s
        ...    Is Allocation Complete
        ...    cell_number=${cell_number}
        ...    group_id=${group_id}
        RETURN    ${credit_id}
    END

Find Rule Id via Group Id
    [Documentation]    Find the ${rule_id} of a group_id and returns it.
    [Tags]    robot:private
    [Arguments]    ${group_id}

    ${result}    MySQL Fetch All
    ...    db_name=switch_credit_db
    ...    query=SELECT * FROM switch_credit_db.groups WHERE group_id = "${group_id}"
    ${rule_id}    Set Variable    ${result['body'][0]['rule_id']}

    RETURN    ${rule_id}

Find Profile Id via Rule Id
    [Documentation]    Find the ${profile_id} of a rule_id and returns it.
    [Tags]    robot:private
    [Arguments]    ${rule_id}
    ${filter_query}    Create Dictionary    ruleId=${rule_id}
    ${result}    Mongo Db Find    switch_credit_db    rules    ${filter_query}

    ${profile_id}    Set Variable    ${result['body'][0]['profileId']}
    RETURN    ${profile_id}

Find Installment Count via Group Id
    [Documentation]    Find the minimum ${installment_count} of a group_id and returns it.
    ...    Can also work, if the ${rule_id} is directly given as an input
    [Tags]    robot:private
    [Arguments]    ${group_id}    ${rule_id}=${EMPTY}

    IF    '${rule_id}'=='${EMPTY}'
        ${rule_id}    Find Rule Id via Group Id    group_id=${group_id}
        ${filter_query}    Create Dictionary    ruleId=${rule_id}
        ${result}    Mongo Db Find    switch_credit_db    rules    ${filter_query}
        ${installment_count}    Set Variable    ${result['body'][0]['installmentCount']['min']}
        RETURN    ${installment_count}
    ELSE
        ${filter_query}    Create Dictionary    ruleId=${rule_id}
        ${result}    Mongo Db Find    switch_credit_db    rules    ${filter_query}
        ${installment_count}    Set Variable    ${result['body'][0]['installmentCount']['min']}
        RETURN    ${installment_count}
    END

Find CRN via Group Id
    [Documentation]    Find the ${crn} of a group_id and returns it.
    [Tags]    robot:private
    [Arguments]    ${group_id}

    ${result_groups}    MySQL Fetch All
    ...    db_name=switch_credit_db
    ...    query=SELECT * FROM switch_credit_db.groups WHERE group_id = "${group_id}"
    ${organization_id}    Set Variable    ${result_groups['body'][0]['organization_id']}
    IF    ${organization_id}==None
        ${crn}    Set Variable    None
        RETURN    ${crn}
    ELSE
        ${result_organizations}    MySQL Fetch All    db_name=switch_credit_db
        ...    query=SELECT * FROM switch_credit_db.organizations WHERE id = "${organization_id}"
        ${crn}    Set Variable    ${result_organizations['body'][0]['crn']}
        RETURN    ${crn}
    END

Find Fund Provider Code via Group Id
    [Documentation]    Find the    ${fund_provider_code} of a group_id and returns it.
    [Tags]    robot:private
    [Arguments]    ${group_id}

    ${rule_id}    Find Rule Id via Group Id    group_id=${group_id}
    ${filter_query}    Create Dictionary    ruleId=${rule_id}
    ${result}    Mongo Db Find    switch_credit_db    rules    ${filter_query}
    ${fund_provider_code}    Set Variable    ${result['body'][0]['fundProvider']['code']}

    RETURN    ${fund_provider_code}

Find Installment Generation Type via Group Id
    [Documentation]    Find the ${contract_generation_type} of a group_id and returns it. Can return BOOLEAN values or categorical values based on ${categorize}.
    [Tags]    robot:private
    [Arguments]    ${group_id}    ${categorize}=True

    ${rule_id}    Find Rule Id via Group Id    group_id=${group_id}
    ${profile_id}    Find Profile Id via Rule Id    rule_id=${rule_id}
    ${filter_query}    Create Dictionary    profileId=${profile_id}
    ${result}    Mongo Db Find    credit-account-mng_db    profiles    ${filter_query}
    ${contract_generation_type}    Set Variable    ${result['body'][0]['contractGenerationType']}

    IF    ${categorize}
        IF    '${contract_generation_type}'=='0'    RETURN    PER_BILLING_CYCLE
        IF    '${contract_generation_type}'=='1'    RETURN    ON_ALLOCATION
    ELSE
        RETURN    ${contract_generation_type}
    END

Generate multi allocation
    [Documentation]    Generate a random user and then allocate it on multiple groupId: ${group_id}; Returns the ${cell_number} of
    ...    the generated user as well as the list of @{credit_ids} that are allocated and the ${user_id}.
    ...
    ...
    ...    The mandatory function inputs are/is :
    ...
    ...    1.@{group_ids} : A list of group_ids. Can include only 1 item or multiple.
    ...
    ...
    ...    The Optional function inputs are/is :
    ...
    ...    1. @{inst_counts} : A list of installment counts for each of the group_ids that are provided.
    ...    If is not given, then the allocation automatically searches the databases and sets the appropriate values for the installment counts.
    ...
    ...    2. @{amounts} : A list of amounts to be allocated.    If non given, then a default amount is set for all of the allocations
    ...
    ...    3. ${default_amount} : The default amount value. If no amount is given, then this default value is set. If no default value is given,
    ...    then a pre-defined default value is set.
    ...
    ...    4. @{file_names} : A list of file names. These are used to generate the templates which are going to be uploaded to the dashboard. If none is given,
    ...    then a some pre-defined names are going to be used.
    ...
    ...    5. @{CRNs} : A list of CRNs for the allocation. If none is given, then the CRN is going to be extracted from the databases and then replaced.
    ...
    ...    6. ${cell_number} : The cell    number of the user to be allocated. If none is given, then a random cell_number is generated.
    ...
    ...    7. ${national_code} : The national code of the user to be allocated. If none is given, then a random national_code is generated .
    ...    **--Note**: Make sure you include either both ${cell_number} and ${national_code} or none of them as the allocation will Fail if you include only one.
    ...
    ...    8. @{delete_templates} : A list of boolean values to indicate whether to delete the generated templates from the local device or not. If none is given,
    ...    then all of of the generated templates are going to be deleted.
    ...
    ...    9. ${pin_code} : A string,    The pin code of the user which is used to login.
    ...    Needed for the pre-defined allocations with users containing pin_code for their login. Since users with a ${pin_code} have had their users already created,
    ...    the step where we have to login to generate a user record in the users_db.users table is skipped.
    ...
    ...
    ...    The Allocation will then return the ${cell_number} , list of @{credit_ids}, and ${user_id} of the allocated.
    ...
    ...
    ...    Bellow are some example cases of this service :
    ...
    ...    @{group_ids}    Create List    ${LOS_DP-1INST-NOFEE-SOFTPENALTY-NOACTION-USERPAYS}
    ...
    ...
    ...    ${cell_number}    @{credit_ids}    ${user_id}    ${additional_info}    Generate multi allocation    group_ids=${group_ids}
    ...
    ...
    ...    @{group_ids}    Create List    ${LOS_DP-1INST-NOFEE-SOFTPENALTY-NOACTION-USERPAYS}
    ...
    ...
    ...    ${cell_number}    @{credit_ids}    ${user_id}    ${additional_info}    Generate multi allocation    group_ids=${group_ids}    cell_number=09911772110    natioanl_code=3242015444    default_amount=123456
    ...
    ...
    ...    --NOTE: ${additional_info} includes all the information about the allocated account,
    ...    this variable is meant to be used to add relevant information to the output of allocation,
    ...    if they are needed in your tests. It is a "dictionary" of dictionaries.
    [Arguments]    ${save_dump}=False
    ...    ${dump_path}=src/data/los/
    ...    &{configs}

    ${contained_request_origin}    Evaluate    "request_origin" in ${configs}
    IF    ${contained_request_origin}!=True
        ${request_origin}    Set Variable    ${ROBOT_AUTOMATION}
    ELSE
        ${request_origin}    Set Variable    ${configs["request_origin"]}
    END

    ${contained_default_amount}    Evaluate    "default_amount" in ${configs}

    IF    ${contained_default_amount}!=True
        ${default_amount}    Set Variable    ${DEFAULT_ALLOCATION_AMOUNT}
    ELSE
        ${default_amount}    Set Variable    ${configs["default_amount"]}
    END

    ${length}    Get Length    ${configs["group_ids"]}

    IF    '${length}'=='0'    Fail    msg=group_ids can not be empty.

    ${contained_inst_counts}    Evaluate    "inst_counts" in ${configs}
    ${contained_amounts}    Evaluate    "amounts" in ${configs}
    ${contained_file_names}    Evaluate    "file_names" in ${configs}
    ${contained_CRNs}    Evaluate    "CRNs" in ${configs}
    ${contained_cell_number}    Evaluate    "cell_number" in ${configs}
    ${contained_national_code}    Evaluate    "national_code" in ${configs}
    ${contained_delete_templates}    Evaluate    "delete_templates" in ${configs}
    ${contained_pin_code}    Evaluate    "pin_code" in ${configs}
    ${contained_installment_initiation}    Evaluate    "initiate_installment" in ${configs}

    ${groups}    Set Variable    ${configs["group_ids"]}

    IF    ${contained_cell_number}!=True
        IF    ${contained_national_code}==True
            Fail    XNOR exception : Either both cell_number and national_code are given or none of them.
        END
    ELSE
        IF    ${contained_national_code}!=True
            Fail    XNOR exception : Either both cell_number and national_code are given or none of them.
        ELSE
            ${national_code}    Set Variable    ${configs["national_code"]}
            ${cell_number}    Set Variable    ${configs["cell_number"]}
        END
    END

    IF    ${contained_pin_code}!=True
        ${pin_code}    Set Variable    ${EMPTY}
    ELSE
        ${pin_code}    Set Variable    ${configs["pin_code"]}
    END

    IF    ${contained_installment_initiation}!=True
        ${initiate_installment}    Set Variable    ${True}
    ELSE
        ${initiate_installment}    Set Variable    ${configs["initiate_installment"]}
    END

    IF    ${contained_cell_number}
        ${user_info}    Generate A Predefined User
        ...    cell_number=${cell_number}
        ...    national_code=${national_code}

        ${user_id}    Set Variable    ${user_info['user_id']}
        ${cell_number}    Set Variable    ${user_info['user_cell_number']}
        ${national_code}    Set Variable    ${user_info['user_national_code']}
    ELSE
        ${user_info}    Generate A Fresh User

        ${user_id}    Set Variable    ${user_info['user_id']}
        ${cell_number}    Set Variable    ${user_info['user_cell_number']}
        ${national_code}    Set Variable    ${user_info['user_national_code']}
    END

    IF    ${contained_inst_counts}!=True
        ${inst_counts}    Create List
        FOR    ${i}    IN RANGE    ${0}    ${length}    ${1}
            ${inst_count}    Find Installment Count via Group ID    group_id=${groups}[${i}]
            Append To List    ${inst_counts}    ${inst_count}
        END
    ELSE
        ${inst_counts}    Set Variable    ${configs["inst_counts"]}
    END
    IF    ${contained_amounts}!=True
        ${amounts}    Create List
        FOR    ${i}    IN RANGE    ${0}    ${length}    ${1}
            Append To List    ${amounts}    ${default_amount}
        END
    ELSE
        ${amounts}    Set Variable    ${configs["amounts"]}
    END
    IF    ${contained_file_names}!=True
        ${file_names}    Create List
        FOR    ${i}    IN RANGE    ${0}    ${length}    ${1}
            ${postfix}    Generate Random String    length=11    chars=abcdefghijklmnopqrstuvwxyz1234567890
            Append To List    ${file_names}    allocation-template-${postfix}.xlsx
        END
    ELSE
        ${file_names}    Set Variable    ${configs["file_names"]}
    END
    IF    ${contained_delete_templates}!=True
        ${delete_templates}    Create List
        FOR    ${i}    IN RANGE    ${0}    ${length}    ${1}
            Append To List    ${delete_templates}    True
        END
    ELSE
        ${delete_templates}    Set Variable    ${configs["delete_templates"]}
    END
    IF    ${contained_CRNs}!=True
        ${CRNs}    Create List
        FOR    ${i}    IN RANGE    ${0}    ${length}    ${1}
            ${crn}    Find CRN via Group Id    group_id=${groups}[${i}]
            Append To List    ${CRNs}    ${crn}
        END
    ELSE
        ${CRNs}    Set Variable    ${configs["CRNs"]}
    END

    ${credit_ids}    Create List
    ${additional_info}    Create Dictionary
    FOR    ${i}    IN RANGE    ${0}    ${length}    ${1}
        Create Template    inst_count=${inst_counts}[${i}]
        ...    amount=${amounts}[${i}]
        ...    save_path=${default_path_location}/${file_names}[${i}]
        ...    default_information=${default_path_location}/${DEFAULT_ALLOCATION_INFORMATION_PATH}
        ...    CRN=${CRNs}[${i}]
        ...    cell_number=${cell_number}
        ...    national_code=${national_code}
        ...    &{configs}

        ${credit_id}    Upload File For User    ${groups}[${i}]    ${file_names}[${i}]    ${cell_number}
        Append To List    ${credit_ids}    ${credit_id}
        ${user_id}    Find User Id by Credit Id    credit_id=${credit_id}
        IF    ${initiate_installment}==True
            ${filter_query}    Create Dictionary    creditId=${credit_id}
            ${result}    Mongo Db Find    switch_credit_db    activations    ${filter_query}
            ${group_id}    Set Variable    ${result['body'][0]['group']['groupId']}
            ${fp_code}    Find Fund Provider Code via Group Id    group_id=${group_id}
            Initiate Installment
            ...    credit_id=${credit_id}
            ...    fp_code=${fp_code}
            ...    national_code=${national_code}
            ...    request_origin=${request_origin}
            ...    custom_ECN=${LMS_TB_Init_Installment_ECN_AUTOMATION}
            ...    custom_FBAN=${LMS_TB_Init_Installment_FBAN_AUTOMATION}
        END
        IF    ${delete_templates}[${i}]
            Delete Template    ${default_path_location}/${file_names}[${i}]
        END
        IF    ${save_dump}
            ${fp_code}    Find Fund Provider Code via Group Id    group_id=${groups}[${i}]
            ${dump_values}    Create List    ${cell_number}
            ...    ${national_code}
            ...    ${credit_id}
            ...    ${user_id}
            ...    ${amounts}[${i}]
            ...    ${inst_counts}[${i}]
            ...    ${fp_code}
            ${headers}    Create List
            ...    cell_number
            ...    national_code
            ...    credit_id
            ...    user_id
            ...    amount
            ...    inst_count
            ...    fp_code

            Create Dump    values=${dump_values}    save_path=${dump_path}    headers=${headers}
        END

        ${rule_id}    Find Rule Id via Group Id    group_id=${groups}[${i}]
        ${profile_id}    Find Profile Id via Rule Id    rule_id=${rule_id}
        ${service_type}    Find Service Type by Credit Id    ${credit_id}
        ${fund_provider_code}    Find Fund Provider Code via Group Id    group_id=${groups}[${i}]
        ${installment_generation_type}    Find Installment Generation Type via Group Id    group_id=${groups}[${i}]

        ${info}    Create Dictionary
        ...    amount=${amounts}[${i}]
        ...    inst_count=${inst_counts}[${i}]
        ...    CRN=${CRNs}[${i}]
        ...    rule_id=${rule_id}
        ...    profile_id=${profile_id}
        ...    service_type=${service_type}
        ...    fund_provider_code=${fund_provider_code}
        ...    installment_generation_type=${installment_generation_type}

        Set To Dictionary    ${additional_info}    ${i}    ${info}

        Delete File Account Name    file_name=${file_names}[${i}]
    END

    ${user_object}    Create Dictionary
    ...    user_id=${user_id}
    ...    user_cell_number=${cell_number}
    ...    user_credit_ids=${credit_ids}
    ...    national_code=${national_code}
    ...    user_additional_info=${additional_info}

    RETURN    ${user_object}

1PAY Handler
    [Documentation]    If the allocation type is ${LMS_Account_Type_1PAY}, handles the request and returns the ${group_id} to be used in the allocation.
    ...    Will only work if the ${fund_provider} is set as ${LMS_FP_PLATFORM}, and the ${fee_type} as any of ${LMS_ZERO_FEE}, ${LMS_ZERO_FEE_AND_MANUAL_SETTLE}, or ${LMS_ZERO_FEE_AND_MANUAL_OVERDUE};
    ...    Otherwise it will return ${NOT_SUPPORTED}.
    [Tags]    robot:private
    [Arguments]    ${fund_provider}    ${fee_type}
    ${NOT_SUPPORTED}    Set Variable    NOT_SUPPORTED

    IF    '${fund_provider}'=='${LMS_FP_PLATFORM}'
        IF    '${fee_type}'=='${LMS_ZERO_FEE}'
            RETURN    ${LOS_DP-1INST-NOFEE-SOFTPENALTY-NOACTION-USERPAYS}
        END
        IF    '${fee_type}'=='${LMS_ZERO_FEE_AND_MANUAL_SETTLE}'
            RETURN    ${LOS_DP-1INST-noFee-justPenalty-manualSettle-underwriterPays}
        END
        IF    '${fee_type}'=='${LMS_ZERO_FEE_AND_MANUAL_OVERDUE}'
            RETURN    ${LOS_DP-1INST-noFee-justPenalty-manualOverdue-underwriterPays}
        END
        IF    '${fee_type}'=='${LMS_FEE_ON_PURCHASE}'
            RETURN    ${LOS_DP-1INST-noFee-justPenalty-manualOverdue-underwriterPays}
        END
    END
    RETURN    ${NOT_SUPPORTED}

INSTALLMENT SALE Handler
    [Documentation]    If the allocation type is ${LMS_Account_Type_INSTALLMENT_SALE}, handles the request and returns the ${group_id} to be used in the allocation.
    ...    Will only work if the ${fund_provider} is set as ${LMS_FP_PLATFORM}, and the ${fee_type} as ${LMS_FEE_ON_PURCHASE};
    ...    Otherwise it will return ${NOT_SUPPORTED}.
    [Tags]    robot:private
    [Arguments]    ${fund_provider}    ${fee_type}

    ${NOT_SUPPORTED}    Set Variable    NOT_SUPPORTED

    IF    '${fund_provider}'=='${LMS_FP_PLATFORM}'
        IF    '${fee_type}'=='${LMS_ZERO_FEE}'
            RETURN    ${LOS_DP-4INST-InstSales-noFee}
        END
        IF    '${fee_type}'=='${LMS_FEE_ON_INSTALLMENT}'
            RETURN    ${LOS_DP-4INST-InstSales-installmentFee}
        END
        IF    '${fee_type}'=='${LMS_FEE_ON_PURCHASE}'
            RETURN    ${LOS_DP-4INST-InstSales-purchaseFee}
        END
        IF    '${fee_type}'=='${LMS_FEE_ON_ALLOCATION}'
            RETURN    ${LOS_DP-4INST-InstSales-allocationFee}
        END
        IF    '${fee_type}'=='${LMS_ZERO_FEE_AND_MANUAL_SETTLE}'
            RETURN    ${LOS_DP-4INST-InstSales-noFee-manualSettle}
        END
        IF    '${fee_type}'=='${LMS_ZERO_FEE_AND_MANUAL_OVERDUE}'
            RETURN    ${LOS_DP-4INST-InstSales-noFee-manualOverdue}
        END
    END
    RETURN    ${NOT_SUPPORTED}

XPAY Handler
    [Documentation]    If the allocation type is ${LMS_Account_Type_XPAY}, handles the request and returns the ${group_id} to be used in the allocation.
    ...    Based on the ${fee_type} argument, will decide which type of ${LMS_Account_Type_XPAY} is going to be allocated.
    ...    By default it is going to allocate on a ${LMS_ZERO_FEE} account.
    ...    Will not work (returns ${NOT_SUPPORTED}) if the    ${fund_provider} is anything but ${LMS_FP_PLATFORM} or the ${fee_type} does not exist.
    [Tags]    robot:private
    [Arguments]    ${fund_provider}    ${fee_type}

    ${NOT_SUPPORTED}    Set Variable    NOT_SUPPORTED

    IF    '${fund_provider}'=='${LMS_FP_PLATFORM}'
        IF    '${fee_type}'=='${LMS_ZERO_FEE}'
            RETURN    ${LOS_DP-3INST-NOFEE-JUSTPENALTY-NOACTION-USERPAYS}
        END
        IF    '${fee_type}'=='${LMS_FEE_ON_INSTALLMENT}'
            RETURN    ${LOS_DP-3INST-INSTFEE-SOFTPENALTY-NOACTION-USERPAYS-STARTIN3MONTHS}
        END
        IF    '${fee_type}'=='${LMS_FEE_ON_INSTALLMENT_AND_MANUAL_SETTLE}'
            RETURN    ${LOS_DP-3INST-INSTFEE-HARDPENALTY-MANUALSETTLE-UNDERWRITER-CRN}
        END
        IF    '${fee_type}'=='${LMS_FEE_ON_INSTALLMENT_AND_MANUAL_OVERDUE}'
            RETURN    ${LOS_DP-3INST-INSTFEE-HARDPENALTY-MANUALOVERDUE-UNDERWRITER-CRN}
        END
        IF    '${fee_type}'=='${LMS_FEE_ON_PURCHASE}'
            RETURN    ${LOS_DP-3INST-PURCHASEFEE-HARDPENALTY-NOACTION-USERPAYS}
        END
        IF    '${fee_type}'=='${LMS_FEE_ON_ALLOCATION}'
            RETURN    ${LOS_DP-3INST-FeeOnAllocation-justPenalty-noAction-userPays}
        END
    END

    RETURN    ${NOT_SUPPORTED}

3PAY Handler
    [Documentation]    If the allocation type is ${LMS_Account_Type_3PAY}, handles the request and returns the ${group_id} to be used in the allocation.
    ...    Based on the ${fee_type} argument, will decide which type of ${LMS_Account_Type_3PAY} is going to be allocated.
    ...    By default it is going to allocate on a ${LMS_ZERO_FEE} account.
    ...    Will not work (returns ${NOT_SUPPORTED}) if the    ${fund_provider} is anything but ${LMS_FP_PLATFORM} or
    ...    the ${fee_type} is anything other that ${LMS_ZERO_FEE}, ${LMS_ZERO_FEE_AND_MANUAL_SETTLE}, or ${LMS_ZERO_FEE_AND_MANUAL_OVERDUE}.
    [Tags]    robot:private
    [Arguments]    ${fund_provider}    ${fee_type}

    ${NOT_SUPPORTED}    Set Variable    NOT_SUPPORTED

    IF    '${fund_provider}'=='${LMS_FP_PLATFORM}'
        IF    '${fee_type}'=='${LMS_ZERO_FEE}'
            RETURN    ${LOS_DP-3INST-noFee-justPenalty-noAction-userPays-3PAY}
        END
        IF    '${fee_type}'=='${LMS_ZERO_FEE_AND_MANUAL_SETTLE}'
            RETURN    ${LOS_DP-3INST-noFee-justPenalty-manualSettle-underwriterPays-3PAY}
        END
        IF    '${fee_type}'=='${LMS_ZERO_FEE_AND_MANUAL_OVERDUE}'
            RETURN    ${LOS_DP-3INST-noFee-justPenalty-manualOverdue-underwriterPays-3PAY}
        END
    END

    RETURN    ${NOT_SUPPORTED}

CREDIT Handler
    [Documentation]    If the allocation type is ${LMS_Account_Type_CREDIT}, handles the request and returns the ${group_id} to be used in the allocation.
    ...    Based on the ${fee_type} argument and ${fund_provider} argument, will decide which type of ${LMS_Account_Type_CREDIT} is going to be allocated.
    ...    By default it is going to allocate on a ${LMS_ZERO_FEE} - ${LMS_FP_TEJARAT} account.
    ...
    ...    Will not work (returns ${NOT_SUPPORTED}) if:
    ...
    ...    1. ${fund_provider} does not exist or is ${LMS_FP_PLATFORM}
    ...    2. ${fee_type} does not exist or is ${LMS_FEE_ON_PURCHASE} when the ${fund_provider} is not ${LMS_FP_COMPANY}
    ...    3. ${fee_type} does not exist or is anything but ${LMS_FEE_ON_PURCHASE} when the ${fund_provider} is ${LMS_FP_COMPANY}
    [Tags]    robot:private
    [Arguments]    ${fund_provider}    ${fee_type}

    ${NOT_SUPPORTED}    Set Variable    NOT_SUPPORTED

    IF    '${fund_provider}'=='${LMS_FP_TEJARAT}'
        IF    '${fee_type}'=='${LMS_ZERO_FEE}'
            RETURN    ${LOS_TB-6INST-NOFEE-JUSTPENALTY-NOACTION-USERPAYS}
        END
        IF    '${fee_type}'=='${LMS_FEE_ON_INSTALLMENT}'
            RETURN    ${LOS_TB-6INST-INSTFEE-JUSTPENALTY-NOACTION-USERPAYS-STARTIN3MONTHS}
        END
        IF    '${fee_type}'=='${LMS_FEE_ON_INSTALLMENT_AND_MANUAL_SETTLE}'
            RETURN    ${LOS_TB-6INST-INSTFEE-JUSTPENALTY-MANUALSETTLE-UNDERWRITER-CRN}
        END
        IF    '${fee_type}'=='${LMS_FEE_ON_INSTALLMENT_AND_MANUAL_OVERDUE}'
            RETURN    ${LOS_TB-6INST-INSTFEE-JUSTPENALTY-MANUALOVERDUE-UNDERWRITER-CRN}
        END
        IF    '${fee_type}'=='${LMS_FEE_ON_PURCHASE}'
            RETURN    ${LOS_TB-6INST-FeeOnPurchase-justPenalty-noAction-userPays}
        END
        IF    '${fee_type}'=='${LMS_FEE_ON_ALLOCATION}'
            RETURN    ${LOS_TB-6INST-FeeOnAllocation-justPenalty-noAction-userPays}
        END
        IF    '${fee_type}'=='${LMS_HYBRID_FEE_CREDIT_INTEREST}'
            RETURN    ${LOS_TB-6INST-FeeHybric-CreditInterest-justPenalty-noAction-userPays}
        END
    END
    IF    '${fund_provider}'=='${LMS_FP_MELLAT}'
        IF    '${fee_type}'=='${LMS_ZERO_FEE}'
            RETURN    ${LOS_MLT-6INST-NOFEE-JUSTPENALTY-NOACTION-USERPAYS}
        END
        IF    '${fee_type}'=='${LMS_FEE_ON_INSTALLMENT}'
            RETURN    ${LOS_MLT-6INST-INSTFEE-JUSTPENALTY-NOACTION-USERPAYS-STARTIN3MONTHS}
        END
        IF    '${fee_type}'=='${LMS_FEE_ON_INSTALLMENT_AND_MANUAL_SETTLE}'
            RETURN    ${LOS_MLT-6INST-INSTFEE-JUSTPENALTY-MANUALSETTLE-UNDERWRITER-CRN}
        END
        IF    '${fee_type}'=='${LMS_FEE_ON_INSTALLMENT_AND_MANUAL_OVERDUE}'
            RETURN    ${LOS_MLT-6INST-INSTFEE-JUSTPENALTY-MANUALOVERDUE-UNDERWRITER-CRN}
        END
        IF    '${fee_type}'=='${LMS_FEE_ON_PURCHASE}'
            RETURN    ${LOS_MLT-6INST-FeeOnPurchase-justPenalty-noAction-userPays}
        END
        IF    '${fee_type}'=='${LMS_FEE_ON_ALLOCATION}'
            RETURN    ${LOS_MLT-6INST-FeeOnAllocation-justPenalty-noAction-userPays}
        END
        IF    '${fee_type}'=='${LMS_HYBRID_FEE_CREDIT_INTEREST}'
            RETURN    ${LOS_MLT-6INST-FeeHybric-CreditInterest-justPenalty-noAction-userPays}
        END
    END
    IF    '${fund_provider}'=='${LMS_FP_SADERAT}'
        IF    '${fee_type}'=='${LMS_ZERO_FEE}'
            RETURN    ${LOS_SD-6INST-NOFEE-JUSTPENALTY-NOACTION-USERPAYS}
        END
        IF    '${fee_type}'=='${LMS_FEE_ON_INSTALLMENT}'
            RETURN    ${LOS_SD-6INST-INSTFEE-JUSTPENALTY-NOACTION-USERPAYS-STARTIN3MONTHS}
        END
        IF    '${fee_type}'=='${LMS_FEE_ON_INSTALLMENT_AND_MANUAL_SETTLE}'
            RETURN    ${LOS_SD-6INST-INSTFEE-JUSTPENALTY-MANUALSETTLE-UNDERWRITER-CRN}
        END
        IF    '${fee_type}'=='${LMS_FEE_ON_INSTALLMENT_AND_MANUAL_OVERDUE}'
            RETURN    ${LOS_SD-6INST-INSTFEE-JUSTPENALTY-MANUALOVERDUE-UNDERWRITER-CRN}
        END
        IF    '${fee_type}'=='${LMS_FEE_ON_PURCHASE}'
            RETURN    ${LOS_SD-6INST-FeeOnPurchase-justPenalty-noAction-userPays}
        END
        IF    '${fee_type}'=='${LMS_FEE_ON_ALLOCATION}'
            RETURN    ${LOS_SD-6INST-FeeOnAllocation-justPenalty-noAction-userPays}
        END
        IF    '${fee_type}'=='${LMS_HYBRID_FEE_CREDIT_INTEREST}'
            RETURN    ${LOS_SD-6INST-FeeHybric-CreditInterest-justPenalty-noAction-userPays}
        END
    END
    IF    '${fund_provider}'=='${LMS_FP_GARDESHGARI}'
        IF    '${fee_type}'=='${LMS_ZERO_FEE}'
            RETURN    ${LOS_GR-6INST-NOFEE-JUSTPENALTY-NOACTION-USERPAYS}
        END
        IF    '${fee_type}'=='${LMS_FEE_ON_INSTALLMENT}'
            RETURN    ${LOS_GR-6INST-INSTFEE-JUSTPENALTY-NOACTION-USERPAYS-STARTIN3MONTHS}
        END
        IF    '${fee_type}'=='${LMS_FEE_ON_INSTALLMENT_AND_MANUAL_SETTLE}'
            RETURN    ${LOS_GR-6INST-INSTFEE-JUSTPENALTY-MANUALSETTLE-UNDERWRITER-CRN}
        END
        IF    '${fee_type}'=='${LMS_FEE_ON_INSTALLMENT_AND_MANUAL_OVERDUE}'
            RETURN    ${LOS_GR-6INST-INSTFEE-JUSTPENALTY-MANUALOVERDUE-UNDERWRITER-CRN}
        END
        IF    '${fee_type}'=='${LMS_FEE_ON_PURCHASE}'
            RETURN    ${LOS_GR-6INST-FeeOnPurchase-justPenalty-noAction-userPays}
        END
        IF    '${fee_type}'=='${LMS_FEE_ON_ALLOCATION}'
            RETURN    ${LOS_GR-6INST-FeeOnAllocation-justPenalty-noAction-userPays}
        END
        IF    '${fee_type}'=='${LMS_HYBRID_FEE_CREDIT_INTEREST}'
            RETURN    ${LOS_GR-6INST-FeeHybric-CreditInterest-justPenalty-noAction-userPays}
        END
    END
    IF    '${fund_provider}'=='${LMS_FP_COMPANY}'
        IF    '${fee_type}'=='${LMS_FEE_ON_PURCHASE}'
            RETURN    ${LOS_CO-6INST-PURCHASEFEE-JUSTPENALTY-NOACTION-USERPAYS-30DAYS}
        END
    END

    RETURN    ${NOT_SUPPORTED}

Fund Provider Default Handler
    [Documentation]    Given a list of types, Returns the default ${fund_providers} for each of the items included in the list of types.
    [Tags]    robot:private
    [Arguments]    ${types}

    ${length}    Get Length    ${types}
    ${fund_providers}    Create List
    FOR    ${i}    IN RANGE    ${0}    ${length}    ${1}
        IF    '${types}[${i}]'=='${LMS_Account_Type_1PAY}'
            Append To List    ${fund_providers}    ${LMS_FP_PLATFORM}
        END
        IF    '${types}[${i}]'=='${LMS_Account_Type_XPAY}'
            Append To List    ${fund_providers}    ${LMS_FP_PLATFORM}
        END
        IF    '${types}[${i}]'=='${LMS_Account_Type_3PAY}'
            Append To List    ${fund_providers}    ${LMS_FP_PLATFORM}
        END
        IF    '${types}[${i}]'=='${LMS_Account_Type_INSTALLMENT_SALE}'
            Append To List    ${fund_providers}    ${LMS_FP_PLATFORM}
        END
        IF    '${types}[${i}]'=='${LMS_Account_Type_CREDIT}'
            Append To List    ${fund_providers}    ${LMS_FP_TEJARAT}
        END
    END

    RETURN    ${fund_providers}

Fee Types Default Handler
    [Documentation]    Given a list of ${types} and the list of ${fund_providers}, Returns the default ${fee_types} for each of the items included in the list of types.
    [Tags]    robot:private
    [Arguments]    ${types}    ${fund_providers}

    ${length}    Get Length    ${types}
    ${fee_types}    Create List
    FOR    ${i}    IN RANGE    ${0}    ${length}    ${1}
        IF    '${types}[${i}]'=='${LMS_Account_Type_1PAY}'
            Append To List    ${fee_types}    ${LMS_ZERO_FEE}
        END
        IF    '${types}[${i}]'=='${LMS_Account_Type_XPAY}'
            Append To List    ${fee_types}    ${LMS_ZERO_FEE}
        END
        IF    '${types}[${i}]'=='${LMS_Account_Type_3PAY}'
            Append To List    ${fee_types}    ${LMS_ZERO_FEE}
        END
        IF    '${types}[${i}]'=='${LMS_Account_Type_INSTALLMENT_SALE}'
            Append To List    ${fee_types}    ${LMS_FEE_ON_PURCHASE}
        END
        IF    '${types}[${i}]'=='${LMS_Account_Type_CREDIT}'
            IF    '${fund_providers}[${i}]'=='${LMS_FP_COMPANY}'
                Append To List    ${fee_types}    ${LMS_FEE_ON_PURCHASE}
            ELSE
                Append To List    ${fee_types}    ${LMS_ZERO_FEE}
            END
        END
    END

    RETURN    ${fee_types}

Activate Account
    [Documentation]    Based on the input variables, Allocate a user or a randomly generated user on the ${group_ids}.
    ...    You should specify the Service-Type/Credit-Type of the allocation and if any of require extra options.
    ...
    ...    Input Argument is :
    ...
    ...    1. ${types} : A List.
    ...    Valid inputs are :
    ...    -    1PAY,
    ...    -    XPAY,
    ...    -    CREDIT,
    ...    -    INSTALLMENT_SALE
    ...
    ...    Optional Arguments are :
    ...
    ...    1.    ${fund_providers} :    A List    of fund_providers for the    account.
    ...    Valid inputs are : TB, SD, MLT, CO, and DP
    ...    Note: Only 1 CREDIT can be active with the exception of Company CREDIT.
    ...    -    TB : Tejarat Bank; Only accessible to CREDIT
    ...    -    SD : Saderat; Only accessible to CREDIT
    ...    -    MLT : Mellat; Only accessible to CREDIT
    ...    -    GR : Gardeshgari; Only accessible to CREDIT
    ...    -    CO : Company; Only accessible to CREDIT
    ...    -    DP: Platform; Only accessible to 1PAY, XPAY, and INSTALLMENT_SALE
    ...
    ...    2. ${fee_type} : A List of fee types for the given allocation.
    ...    Valid input for 1PAY are:
    ...    -    ZERO_FEE
    ...    -    ZERO_FEE_AND_MANUAL_SETTLE
    ...    -    ZERO_FEE_AND_MANUAL_OVERDUE
    ...    Valid inputs for XPAY are:
    ...    -    FEE_ON_INSTALLMENT
    ...    -    FEE_ON_INSTALLMENT_AND_MANUAL_SETTLE
    ...    -    FEE_ON_INSTALLMENT_AND_MANUAL_OVERDUE
    ...    -    FEE_ON_PURCHASE
    ...    -    ZERO_FEE
    ...    -    FEE_ON_ALLOCATION
    ...    Valid inputs for CREDIT are:
    ...    -    FEE_ON_INSTALLMENT
    ...    -    FEE_ON_INSTALLMENT_AND_MANUAL_SETTLE
    ...    -    FEE_ON_INSTALLMENT_AND_MANUAL_OVERDUE
    ...    -    FEE_ON_PURCHASE
    ...    -    ZERO_FEE
    ...    -    FEE_ON_ALLOCATION
    ...    -    LMS_HYBRID_FEE_CREDIT_INTEREST
    ...    Valid inpurt for INSTALLMENT_SALE are:
    ...    -    ZERO_FEE
    ...    -    FEE_ON_PURCHASE
    ...    -    FEE_ON_INSTALLMENT
    ...    -    FEE_ON_ALLOCATION
    ...    -    ZERO_FEE_AND_MANUAL_SETTLE
    ...    -    ZERO_FEE_AND_MANUAL_OVERDUE
    ...
    ...    3. Other optional arguments include the configs passed to the "Generate multi allocation" Service.
    ...    For further instructions, please check the service's documentation. For example: For a specific user allocation,
    ...    include both ${cell_number} and ${national_code}; for a specific allocation amount, use ${default_amount}.
    ...
    ...    -- Note :    If you want to do the allocation for a specific user, make sure you input **BOTH** ${cell_number} and ${national_code},
    ...    otherwise the test will Fail.
    ...
    ...    If a combination is invalid, the group id will be set as ${NOT_SUPPORTED}
    [Arguments]    ${types}    &{optional_arguments}

    ${length}    Get Length    ${types}

    ${contained_fee_type}    Evaluate    "fee_types" in ${optional_arguments}
    ${contained_fund_providers}    Evaluate    "fund_providers" in ${optional_arguments}

    IF    ${contained_fund_providers}!=True
        ${fund_providers}    Fund Provider Default Handler    types=${types}
    ELSE
        ${fund_providers}    Set Variable    ${optional_arguments["fund_providers"]}
    END

    IF    ${contained_fee_type}!=True
        ${fee_types}    Fee Types Default Handler    types=${types}    fund_providers=${fund_providers}
    ELSE
        ${fee_types}    Set Variable    ${optional_arguments["fee_types"]}
    END

    ${group_ids}    Create List
    FOR    ${i}    IN RANGE    ${0}    ${length}    ${1}
        IF    '${types}[${i}]'=='${LMS_Account_Type_INSTALLMENT_SALE}'
            ${group_id}    INSTALLMENT SALE Handler
            ...    fund_provider=${fund_providers}[${i}]
            ...    fee_type=${fee_types}[${i}]
            Append To List    ${group_ids}    ${group_id}
        END
        IF    '${types}[${i}]'=='${LMS_Account_Type_1PAY}'
            ${group_id}    1PAY Handler    fund_provider=${fund_providers}[${i}]    fee_type=${fee_types}[${i}]
            Append To List    ${group_ids}    ${group_id}
        END
        IF    '${types}[${i}]'=='${LMS_Account_Type_XPAY}'
            ${group_id}    XPAY Handler    fund_provider=${fund_providers}[${i}]    fee_type=${fee_types}[${i}]
            Append To List    ${group_ids}    ${group_id}
        END
        IF    '${types}[${i}]'=='${LMS_Account_Type_3PAY}'
            ${group_id}    3PAY Handler    fund_provider=${fund_providers}[${i}]    fee_type=${fee_types}[${i}]
            Append To List    ${group_ids}    ${group_id}
        END
        IF    '${types}[${i}]'=='${LMS_Account_Type_CREDIT}'
            ${group_id}    CREDIT Handler    fund_provider=${fund_providers}[${i}]    fee_type=${fee_types}[${i}]
            Append To List    ${group_ids}    ${group_id}
        END
    END

    ${user_object}    Generate multi allocation
    ...    group_ids=${group_ids}
    ...    &{optional_arguments}

    RETURN    ${user_object}

Filter Credit Ids List To Inlcude Only Those With Residue
    [Documentation]    Given a ${user_object} -> ${credit_ids} list, filters it and returns a new list that includes only the ${credit_id}s
    ...    that are associated with a ${profile_id} that has residue capabilities.
    ...
    ...    Returns a list of ${credit_ids_filtered}
    [Tags]    robot:private
    [Arguments]    ${user_object}

    ${credit_ids}    Set Variable    ${user_object['user_credit_ids']}
    ${credit_ids_filtered}    Create List
    ${credit_ids_length}    Get Length    ${credit_ids}

    FOR    ${i}    IN RANGE    ${0}    ${credit_ids_length}    ${1}
        ${profile_id}    Set Variable    ${user_object['user_additional_info'][${i}]['profile_id']}
        ${filter_query}    Create Dictionary    profileId=${profile_id}
        ${result}    Mongo Db Find    credit_profile_mng_db    profiles    ${filter_query}
        ${body}    Set Variable    ${result['body']}[0]
        ${has_residue}    Set Variable    ${body['hasResidue']}
        IF    ${has_residue}==True
            Append To List    ${credit_ids_filtered}    ${credit_ids}[${i}]
        END
    END

    RETURN    ${credit_ids_filtered}

Amount Handler
    [Documentation]    This handler returns the remaining balance for a ${credit_id}.
    ...
    ...
    ...    Returns the ${total_balance} for a ${credit_id}
    [Tags]    robot:private
    [Arguments]    ${credit_id}

    ${wallet_name}    Set Variable    credit_${credit_id}
    ${filter_query}    Create Dictionary    walletName=${wallet_name}
    ${result}    Mongo Db Find    wallet_provider_db    wallets    ${filter_query}
    ${body}    Set Variable    ${result['body']}[0]
    ${wallet_id}    Set Variable    ${body['walletId']}

    ${query}    Set Variable    SELECT * FROM accounts WHERE wallet_id = "${wallet_id}"
    ${result}    MySQL Fetch All    db_name=wallet_provider_db    query=${query}

    ${body}    Set Variable    ${result['body']}
    ${number_of_wallets}    Get Length    ${body}
    ${total_balance}    Set Variable    0
    FOR    ${i}    IN RANGE    ${0}    ${number_of_wallets}    ${1}
        ${wallet_i}    Set Variable    ${body}[${i}]
        ${wallet_i_balance}    Set Variable    ${wallet_i['balance']}
        ${total_balance}    Evaluate    ${total_balance}+${wallet_i_balance}
    END

    ${total_balance}    Evaluate    round(${total_balance})

    RETURN    ${total_balance}

Wait For The Purchase To Be Assigned
    [Tags]    robot:private
    [Arguments]    ${tracking_code}

    ${filter_query}    Create Dictionary    trackingCode=${tracking_code}
    ${result}    Mongo Db Find
    ...    credit_mng_db
    ...    purchases
    ...    ${filter_query}
    @{records}    Get From Dictionary    ${result}    body
    ${result_object}    Set Variable    ${records}[0]
    Should Be Equal As Strings    ${result_object['billingCycleAssigned']}    True

Collect All User Collectable Balance For Tear Down
    [Documentation]    Given a ${user_object}, this function iteraties through all `ACTIVE`
    ...    ${credit_ids} associated with the ${user_id} and if a ${profile_id} associated with a ${credit_id} has `residue`,
    ...    then a purchase is carried out to empty the credit_${credit_id} wallets of the user. The money is then collected through
    ...    the merchant that has performed the action.
    ...
    ...    Makes sure that the account is active (activates the account in case it is blocked).
    ...
    ...    Must be called before expiration of the accounts with residue.
    ...
    ...    If a list of @{credit_ids} is given, that is it is not @{EMPTY}, then the Collection is only applied to the items inside that list @{credit_id}.
    [Arguments]    ${user_object}

    ${credit_ids}    Filter Credit Ids List To Inlcude Only Those With Residue    user_object=${user_object}
    ${credit_ids_length}    Get Length    ${credit_ids}
    ${user_id}    Set Variable    ${user_object['user_id']}

    FOR    ${i}    IN RANGE    ${0}    ${credit_ids_length}    ${1}
        ${filter_query}    Create Dictionary    creditId=${credit_ids}[${i}]
        ${credit_account}    Mongo Db Find    credit-account-mng_db    accounts    ${filter_query}
        ${credit_account_status}    Set Variable    ${credit_account}[body][0][status]

        IF    '${credit_account_status}'=='3'
            ${response}    Post Admin Credit Accounts Unblock
            ...    ${MICROSERVICE_SIDE}
            ...    ${credit_ids}[${i}]
            ...    ${DASHBOARD_USERNAME}
            Should Be Equal As Integers
            ...    ${response['status_code']}
            ...    200
            ...    msg="Expected status code for Credit Accounts Unblock API to be 200, but got" ${response['status_code']}
        END

        ${amount}    Amount Handler    ${credit_ids}[${i}]
        IF    '${amount}'=='0'
            CONTINUE
        ELSE
            ${amount}    Evaluate    ${amount}*2
        END

        IF    ${amount} < ${MIN_AMOUNT}    CONTINUE

        ${tracking_code}    Perform A Complete Offline Purchase
        ...    user_id=${user_id}
        ...    credit_id=${credit_ids}[${i}]
        ...    channel=${CHANNEL.SMART_POS}
        ...    business_id=${COMPANY_USER_ID}
        ...    amount=${amount}

        IF    '${tracking_code}'=='None'
            Fail    msg=Could not generate a valid purchase tracking code and the tear down has Failed!
        END

        Wait Until Keyword Succeeds
        ...    1 minute
        ...    10 s
        ...    Wait For The Purchase To Be Assigned
        ...    tracking_code=${tracking_code}
    END
