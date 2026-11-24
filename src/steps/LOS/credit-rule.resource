*** Settings ***
Variables   data/los/credit.yaml
Variables   config/environment-stage.yaml
Library     Process
Library     RequestsLibrary
Library     DateTime
Library     String

Resource    services/db/mysql-db-service.resource
Resource    services/db/mongo-db-service.resource
Resource    services/backend/LMS/credit-core/close-account.resource

Resource    apis/los/bnpl/post-credit-activations-profile-in-progress.resource
Resource    apis/los/Journey/post-credit-volunteers-pre-register.resource
Resource    apis/los/bnpl/post-credit-users-profile.resource
Resource    apis/los/bnpl/post-credit-activations-cancel.resource
Resource    apis/los/Journey/post-credit-scores-init.resource
Resource    apis/los/Journey/post-credit-scores-inquiry.resource
Resource    apis/los/Journey/post-credit-cheques-add.resource
Resource    apis/los/Journey/post-credit-documents-upload.resource
Resource    apis/los/Journey/post-credit-cheques-confirm.resource
Resource    apis/los/Journey/get-credit-digital-signatures-actual-signature.resource
Resource    apis/los/Journey/post-credit-digital-signatures-validate-password.resource
Resource    apis/los/dashboard/post-credit-admin-activations-cancel.resource
Resource    apis/los/dashboard/guarantor-cheque/post-credit-admin-cheques-accept.resource
Resource    apis/los/dashboard/guarantor-cheque/post-credit-cheques-received.resource
Resource    apis/los/dashboard/guarantor-cheque/post-credit-admin-cheques-confirm.resource
Resource    apis/los/dashboard/guarantor-cheque/post-admin-collateral-receive.resource
Resource    apis/los/dashboard/guarantor-cheque/post-credit-admin-cheques-reject.resource
Resource    apis/los/Journey/get-credit-activations-signing-documents-start-generation.resource
Resource    apis/los/Journey/post-credit-activations-signing-documents-complete.resource
Resource    apis/los/Journey/get-credit-check-credit-file-inquiry.resource
Resource    apis/los/Journey/get-credit-subscription-initiate.resource
Resource    apis/los/Journey/post-credit-subscription-initiate.resource
Resource    apis/los/dashboard/post-credit-admin-allocation-prepayments-in-progress.resource
Resource    apis/los/dashboard/post-credit-admin-allocation-prepayments-import.resource
Resource    apis/los/dashboard/post-credit-admin-subscription-reject.resource
Resource    apis/los/Journey/get-contents-digital-signature.resource
Resource    apis/los/dashboard/get-admin-contents-digital-signature.resource
Resource    apis/los/dashboard/post_credit_admin_activations_search.resource
Resource    apis/los/dashboard/post-credit-admin-users-upload.resource

*** Keywords ***

User Completes Pre-Registration Phase
    Handle Previous Activations
    The User Pre-registers For A Credit Plan
    ...    group_id=${CREDIT_GROUP_ID}
    ...    plan_id=${CREDIT_PLAN_ID}
    ...    balance=${CREDIT_BALANCE}
    Check Activation Record

Upload Import File
    Handle Previous Activations
    Upload Import File Via Xlsx In Group
    Verify Register Journal Status
    Check Register Journal Status

Bank Scoring Is Processed
    Update ICS Score Cache Timestamp
    Initialize Credit Scores
    Inquire Credit Scores
    Admin Searches Activations

User Updates Profile Information
    Activate Credit Profile In Progress
    Update Credit User Profile

User And Admin Complete The Cheque Workflow
      Prepare Existing Cheque Details Record
      Update Cheque Inquiry Date To Now
      Add Cheque To Credit
      Update Cheque Date & Amount
      Upload Cheque Document
      Confirm Cheque
      Reject Admin Cheque
      Confirm Admin Cheque
      Add Cheque To Credit
      Update Cheque Date & Amount
      Upload Cheque Document
      Confirm Cheque 
      Accept Admin Cheque
      Update Activation Main Status
      Add Journal State To Activation
      Cheque Received  
      Reject Admin Cheque
      Confirm Admin Cheque
      Add Cheque To Credit
      Update Cheque Date & Amount
      Upload Cheque Document
      Confirm Cheque 
      Accept Admin Cheque
      Update Activation Main Status
      Add Journal State To Activation  
      Admin Receives the Cheque by Scanner
      Accept Admin Cheque
      Confirm Admin Cheque
      Update Cheque Details Record
      Update Cheque collateral info

User And Admin Complete The Cheque Workflow-by Scanner
      Prepare Existing Cheque Details Record
      Update Cheque Inquiry Date To Now
      Add Cheque To Credit
      Update Cheque Date & Amount
      Upload Cheque Document
      Confirm Cheque
      Accept Admin Cheque
      Update Activation Main Status
      Add Journal State To Activation       
      Admin Receives the Cheque by Scanner
      Accept Admin Cheque
      Confirm Admin Cheque
      Update Cheque Details Record
      Update Cheque collateral info

User Validates Digital Signature
    Get Actual Digital Signature
    Validate Digital Signature Password
    Update Digital Signature Expiration Date

User Generates And Signs Documents
    Start Signing Documents Generation
    Verify Document Signing Status Ready To Sign
    Get Signing Tracking Code From DB
    Complete Signing Documents
    Get Signing Doc Id From DB
    Download Digital Signature Document-User Side
    Download Digital Signature Document-Admin Side


Credit File Inquiry Is Checked
    Check Credit File Inquiry

User Initiates Credit Subscription
    Update App Subscription Plan Status To USED
    Initiate Subscription
    Initiate Credit Subscription
    Wait Until Allocation Prepayment Exists

Admin Completes Allocation And Prepayments
    Allocation Prepayments In Progress
    Allocation Prepayments In Progress Import
    Wait Until Activation Status Active

Credit Activation Is Closed
    Close All Credit Accounts
    
Admin Rejects And Cancels Credit
    Admin Reject Credit
    Cancel the credit activation successfully

Archive An Unallocated Credit
    Archive the unallocated credit successfully


Handle Previous Activations
    MONGO_DB.Connect To Db
    ...    host=${MONGO_DB_DEFAULT_HOST}
    ...    port=${MONGO_DB_DEFAULT_PORT}
    ...    user=${CREDIT_USER}
    ...    password=${MONGO_DB_DEFAULT_PASS}
    ...    db_name=${CREDIT_DB}

    ${query}=    Create Dictionary    cellNumber=${CREDIT_CELL_NUMBER}
    ${result}=    MONGO_DB.Find Documents    activations    ${query}
    ${count}=    Get Length    ${result['body']}

    Run Keyword If    ${count} == 0    Return From Keyword

    FOR    ${activation}    IN    @{result['body']}
        ${status}=    Set Variable    ${activation['status']}
        ${credit_id}=    Set Variable    ${activation['creditId']}

        Run Keyword If    '${status}' == 'CLOSE'    Continue For Loop

        IF    '${status}' == 'ACTIVE'
            Set Test Variable    ${credit_id}
            Close All Credit Accounts
            Continue For Loop
        END

        ${allowed_statuses}=    Create List
        ...    ALLOCATION_PREPAYMENT_APPROVE_DELAY
        ...    ALLOCATION_PREPAYMENT_READY_TO_APPROVE
        ...    ALLOCATION_PREPAYMENT_ACCEPTED
        ...    PLATFORM_SUBSCRIPTION_SUCCEED
        ...    PLATFORM_SUBSCRIPTION_DELAY
        ...    PLATFORM_SUBSCRIPTION_ACCEPTED
        ...    PLATFORM_SUBSCRIPTION_COMPLETED

        ${is_allowed}=    Evaluate    '${status}' in ${allowed_statuses}

        IF    ${is_allowed}
            ${filter}=    Create Dictionary    creditId=${credit_id}
            ${update_data}=    Create Dictionary    $set=${{ {'status': 'PROFILE_COMPLETED'} }}
            ${result}=    Mongo Db Update One    ${CREDIT_DB}    activations    ${filter}    ${update_data}
            Should Be Equal As Numbers    ${result['status_code']}    0

            Set Test Variable    ${credit_id}
            Cancel the credit activation successfully
            Continue For Loop
        END

        Set Test Variable    ${credit_id}
        Cancel the credit activation successfully

    END

    MONGO_DB.Close Db Connection

The User Pre-registers For A Credit Plan
    [Arguments]    ${group_id}    ${plan_id}    ${balance}
    ${RESULT}=    POST Credit Volunteers Pre Register
    ...    ${MICROSERVICE_SIDE}
    ...    ${CREDIT_PLATFORM_VERSION}
    ...    ${CREDIT_USER_ID}
    ...    ${CREDIT_NATIONAL_CODE}
    ...    ${CREDIT_TIME_STAMP_BIRTH_DATE}
    ...    ${group_id}
    ...    ${plan_id}
    ...    ${CREDIT_CART_RESERVATION_REQUEST}
    ...    ${balance}

    Should Be Equal As Numbers    ${RESULT['status_code']}    200
    ${credit_id}=    Set Variable    ${RESULT['body']['creditId']}
    Set Suite Variable    ${credit_id}


Check Activation Record
    MONGO_DB.Connect To Db
    ...    host=${MONGO_DB_DEFAULT_HOST}
    ...    port=${MONGO_DB_DEFAULT_PORT}
    ...    user=${CREDIT_USER}
    ...    password=${MONGO_DB_DEFAULT_PASS}
    ...    db_name=${CREDIT_DB}

    ${query}=    Create Dictionary    creditId=${credit_id}
    ${result}=    MONGO_DB.Find Documents    activations    ${query}
    ${found}=    Evaluate    len($result['body']) > 0

    IF    ${found} == False
        Sleep    5s
        ${result}=    MONGO_DB.Find Documents    activations    ${query}
        ${found}=    Evaluate    len($result['body']) > 0
    END

    Run Keyword If    ${found} == False
    ...    Fail   برای این کاربر درخواست فعالسازی وجود ندارد. لطفا برای بررسی مشکل کالکشن volunteers را با creditId: "${credit_id}" بررسی بفرمایید

    MONGO_DB.Close Db Connection

Upload Import File Via Xlsx In Group
    ${file_path}=    Set Variable    ${CURDIR}${/}resources${/}files${/}import_file.xlsx
    File Should Exist    ${file_path}

    ${unique_file_name}=    Evaluate    f"import_file_{int(__import__('time').time())}.xlsx"

    ${user_id_str}=    Convert To String    ${ADMIN_USER_ID}
    ${group_id_str}=    Convert To String    ${ADMIN_CREDIT_GROUP_ID}

    ${header}=    Create Dictionary
    ...    User-Id=${user_id_str}
    ...    group-Id=${group_id_str}

    ${file_handle}=    Evaluate    open(r'''${file_path}''', 'rb')

    ${file_tuple}=    Create List
    ...    ${unique_file_name}
    ...    ${file_handle}
    ...    ${None}

    &{files_dict}=    Create Dictionary
    ...    file=${file_tuple}

    ${api_path}=    Set Variable    ${MS_CREDIT_ONBOARDING_PATH}/admin/users/upload?verificationTypes=0%2C1

    ${result}=    POST Credit Admin Users Upload
    ...    ${MICROSERVICE_SIDE}
    ...    ${api_path}
    ...    ${header}
    ...    ${files_dict}

    Evaluate    $file_handle.close()

    Should Be Equal As Numbers    ${result['status_code']}    200

    ${import_tracking_code}=    Set Variable    ${result['body']['trackingCode']}
    Set Suite Variable    ${IMPORT_TRACKING_CODE}    ${import_tracking_code}

Verify Register Journal Status
    Wait Until Keyword Succeeds    5x    5s    Check Register Journal Status

Check Register Journal Status
    ${tracking_code}=    Set Variable    ${IMPORT_TRACKING_CODE}
    ${filter}=    Create Dictionary    trackingCode=${tracking_code}
    ${resp}=      Mongo Db Find One    ${SWITCH_CREDIT_DB_NAME}    register_journals    ${filter}
    Should Be Equal As Numbers    ${resp['status_code']}    0

    ${journal}=    Set Variable    ${resp['body']}
    ${journal_len}=    Get Length    ${journal}
    Run Keyword If    ${journal_len} == 0    Fail    No register_journal found

    ${status}=    Set Variable    ${journal['status']}

    IF    '${status}' == 'SUCCESS'
        ${credit_id}=    Set Variable    ${journal['creditId']}
        Set Suite Variable    ${credit_id}    ${credit_id}
        RETURN
    END

    IF    '${status}' == 'FAILED' or '${status}' == 'INVALID'
        ${errors}=    Get From Dictionary    ${journal}    errorMessages    default=@{EMPTY}
        ${ec}=        Get Length    ${errors}
        IF    ${ec} > 0
            Fatal Error    ${errors[0]}
        ELSE
            Fatal Error    Register journal status is ${status} but errorMessages is empty
        END
    END

    IF    '${status}' == 'INITIATED'
        Fail    Status is INITIATED
    END

    Fatal Error    Unexpected register journal status: ${status}

Handle Register Journal Error
    [Arguments]    ${journal}

    ${errors}=    Set Variable    ${journal['errorMessages']}
    ${error_count}=    Get Length    ${errors}

    IF    ${error_count} > 0
        Fail    Register journal failed with error: ${errors[0]}
    ELSE
        Fail    Register journal failed but errorMessages is empty
    END

Initialize Credit Scores
    ${result}=    POST Credit Scores Init
    ...    ${MICROSERVICE_SIDE}
    ...    ${credit_id}
    ...    ${CREDIT_USER_ID}
    Should Be Equal As Numbers    ${result['status_code']}    200
    ${status}=    Set Variable    ${result['body']['result']['title']}
    Should Be Equal As Strings    ${status}    SUCCESS

Inquire Credit Scores
    ${result}=    POST Credit Scores Inquiry
    ...    ${MICROSERVICE_SIDE}
    ...    ${credit_id}
    ...    ${CREDIT_USER_ID}
    Should Be Equal As Numbers    ${result['status_code']}    200
    ${status}=    Set Variable    ${result['body']['result']['title']}
    Should Be Equal As Strings    ${status}    SUCCESS

Update ICS Score Cache Timestamp
    MONGO_DB.Connect To Db
    ...    host=${MONGO_DB_DEFAULT_HOST}
    ...    port=${MONGO_DB_DEFAULT_PORT}
    ...    user=${SCORE_USER}
    ...    password=${MONGO_DB_DEFAULT_PASS}
    ...    db_name=${SCORE_DB}
    ${find_query}=    Evaluate    {"owner.cellNumber": "${CREDIT_CELL_NUMBER}", "fetchedFromCache": False}
    ${sort}=    Evaluate    [("creationDate", -1)]
    ${latest_score}=    MONGO_DB.Find Documents    ics_scores    ${find_query}    sort=${sort}
    Should Not Be Empty    ${latest_score['body']}    msg=No non-cached ICS score found
    ${record_id}=    Set Variable    ${latest_score['body'][0]['_id']}
    ${current_epoch}=    Get Current Date    result_format=epoch
    ${current_ms}=    Evaluate    int(float(${current_epoch}) * 1000)
    ${update_filter}=    Evaluate    {"_id": bson.ObjectId("${record_id}")}    modules=bson
    ${update_doc}=    Evaluate    {"$set": {"creationDate": ${current_ms}}}
    ${update_result}=    MONGO_DB.Update One    ics_scores    ${update_filter}    ${update_doc}
    Should Be Equal As Numbers    ${update_result['status_code']}    0
    MONGO_DB.Close Db Connection


Admin Searches Activations
    ${now}=    Get Current Date    result_format=epoch    exclude_millis=yes
    ${one_day}=    Evaluate    24 * 60 * 60

    ${min_value}=    Evaluate    (${now} - ${one_day}) * 1000
    ${max_value}=    Evaluate    (${now} + ${one_day}) * 1000

    ${date_restriction}=    Create Dictionary
    ...    type=${ACTIVATION_SEARCH_DATE_TYPE}
    ...    field=${ACTIVATION_SEARCH_DATE_FIELD}
    ...    minValue=${min_value}
    ...    maxValue=${max_value}

    ${credit_id_restriction}=    Create Dictionary
    ...    type=${ACTIVATION_SEARCH_CREDIT_TYPE}
    ...    field=${ACTIVATION_SEARCH_CREDIT_FIELD}
    ...    value=${credit_id}
    ...    operation=${ACTIVATION_SEARCH_CREDIT_OPERATION}

    ${restrictions}=    Create List
    ...    ${date_restriction}
    ...    ${credit_id_restriction}

    ${orders}=    Create List

    ${response}=    POST Credit Admin Activations Search
    ...    ${MICROSERVICE_SIDE}
    ...    ${ADMIN_USER_ID}
    ...    ${restrictions}
    ...    ${orders}

    Set Suite Variable    ${activation_search_response}    ${response}

Activate Credit Profile In Progress
    ${result}=    POST Credit Activations Profile In Progress
    ...    ${MICROSERVICE_SIDE}
    ...    ${credit_id}
    ...    ${CREDIT_USER_ID}
    Should Be Equal As Numbers    ${result['status_code']}    200

Update Credit User Profile
    ${result}=    POST Credit Users Profile
    ...    ${MICROSERVICE_SIDE}
    ...    ${CREDIT_PLATFORM_VERSION}
    ...    ${CREDIT_AGENT}
    ...    ${CREDIT_CONTENT_TYPE}
    ...    ${CREDIT_POSTAL_CODE}
    ...    ${CREDIT_CITY_UUID}
    ...    ${CREDIT_PROVINCE_UUID}
    ...    ${CREDIT_ADDRESS}
    ...    ${CREDIT_ADDRESS_NO}
    ...    ${CREDIT_ADDRESS_UNIT}
    ...    ${CREDIT_PHONE_NUMBER}
    ...    ${CREDIT_BIRTH_PLACE}
    ...    ${CREDIT_EDUCATION_UUID}
    ...    ${CREDIT_JOB_UUID}
    ...    ${credit_id}
    ...    ${CREDIT_USER_ID}
    Should Be Equal As Numbers    ${result['status_code']}    200

Prepare Existing Cheque Details Record
    ${new_cheque_id}=    Set Variable    ${LOS_CHEQUE_ID}00
    ${query}=    Set Variable    UPDATE cheque_details SET cheque_id='${new_cheque_id}' WHERE cheque_id='${LOS_CHEQUE_ID}'
    ${response}=    MySQL Execute Query    ${SWITCH_CREDIT_DB_NAME}    ${query}
    Should Be Equal As Numbers    ${response['status_code']}    0

Update Cheque Inquiry Date To Now
    MONGO_DB.Connect To Db    host=${MONGO_DB_DEFAULT_HOST}    port=${MONGO_DB_DEFAULT_PORT}    user=${KYC_USER}    password=${MONGO_DB_DEFAULT_PASS}    db_name=${KYC_DB}
    ${find_query}=    Evaluate    {"chequeId": "${LOS_CHEQUE_ID}", "status": "SUCCESS", "inquiryType": "CREDIT_INFO", "fetchedFromCache": False}
    ${journals}=    MONGO_DB.Find Documents    cheque_inquiry_journals    ${find_query}
    ${journal}=    Set Variable    ${journals['body'][0]}
    ${record_id}=    Set Variable    ${journal['_id']}
    ${now_ms}=    Get Current Date    result_format=epoch
    ${new_date}=    Evaluate    int(round(${now_ms} * 1000))
    ${update_filter}=    Evaluate    {"_id": bson.ObjectId("${record_id}")}    modules=bson
    ${update_doc}=    Evaluate    {"$set": {"date": ${new_date}}}
    ${update_result}=    MONGO_DB.Update One    cheque_inquiry_journals    ${update_filter}    ${update_doc}
    Should Be Equal As Numbers    ${update_result['status_code']}    0
    MONGO_DB.Close Db Connection

Add Cheque To Credit
    ${body}    Create Dictionary    date=${PER_LOS_CHEQUE_DATE}    amount=${PER_LOS_CHEQUE_AMOUNT}    chequeId=${LOS_CHEQUE_ID}    ownerRelative=${OWNERRELATIVE}   chequeVersion=${CHEQUE_VERSION}
    ${result}    POST Credit Cheques Add
    ...    ${MICROSERVICE_SIDE}
    ...    ${CREDIT_TEJARAT_FP_CODE}
    ...    ${credit_id}
    ...    ${CREDIT_USER_ID}
    ...    ${body}
    Should Be Equal As Numbers    ${result['status_code']}    200
    ${status}    Set Variable    ${result['body']['result']['title']}
    Should Be Equal As Strings    ${status}    SUCCESS

Update Cheque Date & Amount
    ${query}=    Set Variable    UPDATE cheque_details SET date='${LOS_CHEQUE_DATE}', amount='${LOS_CHEQUE_AMOUNT}' WHERE cheque_id='${LOS_CHEQUE_ID}'
    ${response}=    MySQL Execute Query    ${SWITCH_CREDIT_DB_NAME}    ${query}
    Should Be Equal As Numbers    ${response['status_code']}    0

Upload Cheque Document
    ${file_path}=    Set Variable    ${CURDIR}${/}resources${/}files${/}cheque-file.png
    File Should Exist    ${file_path}
    ${file_data}=    Get Binary File    ${file_path}
    ${files}=    Create List    cheque.png    ${file_data}    image/png
    &{files_dict}=    Create Dictionary    file=${files}
    ${api_path}=    Set Variable    /credit-onboarding/platform/api/credit/documents/${CREDIT_TEJARAT_FP_CODE}/${credit_id}/8
    ${header}=    Create Dictionary    Agent=WEB    Platform-Version=${CREDIT_PLATFORM_VERSION}    User-Id=${CREDIT_USER_ID}
    ${result}=    POST Credit Documents Upload    ${MICROSERVICE_BASE_URL}    ${api_path}    ${header}    ${files_dict}
    Should Be Equal As Numbers    ${result['status_code']}    200
    ${UPLOADED_CHEQUE_IMAGE_ID}=    Set Variable    ${result['body']['imageId']}
    Set Global Variable    ${UPLOADED_CHEQUE_IMAGE_ID}

Confirm Cheque
    ${api_path}=    Set Variable    ${MS_CREDIT_ONBOARDING_PATH}/cheques/confirm/${CREDIT_TEJARAT_FP_CODE}/${credit_id}
    ${header}=    Create Dictionary    Agent=WEB    Platform-Version=${CREDIT_PLATFORM_VERSION}    Referer=${APP_BASE_URL}/    User-Id=${CREDIT_USER_ID}    Content-Type=${CREDIT_CONTENT_TYPE}
    ${body}=    Create Dictionary
    ${result}=    POST Credit Cheques Confirm    ${MICROSERVICE_BASE_URL}    ${api_path}    ${header}    ${body}
    Should Be Equal As Numbers    ${result.status_code}    200
    Should Be Equal    ${result.body.result.title}    SUCCESS

Reject Admin Cheque
    ${CORRECT_DOC_ID}=    Get Correct Cheque Document ID
    ${reason}=    Create Dictionary    title=${CHEQUE_REJECT_TITLE}    description=${CHEQUE_REJECT_DESC}
    ${reasons}=    Create List    ${reason}
    ${body}=    Create Dictionary    creditId=${credit_id}    docId=${CORRECT_DOC_ID}    chequeId=${LOS_CHEQUE_ID}    reasons=${reasons}
    ${result}=    POST Credit Admin Cheques Reject    ${MICROSERVICE_SIDE}    ${ADMIN_USER_ID}    ${body}
    Should Be Equal As Numbers    ${result['status_code']}    200
    Wait Until Keyword Succeeds    20x    3s    Verify Cheque Document Status In DB    REJECTED

Accept Admin Cheque
    ${CORRECT_DOC_ID}=    Get Correct Cheque Document ID
    ${reasons}=    Create List
    ${body}=    Create Dictionary    creditId=${credit_id}    docId=${CORRECT_DOC_ID}    chequeId=${LOS_CHEQUE_ID}    reasons=${reasons}
    ${result}=    POST Credit Admin Cheques Accept    ${MICROSERVICE_SIDE}    ${ADMIN_USER_ID}    ${body}
    Should Be Equal As Numbers    ${result['status_code']}    200
    Wait Until Keyword Succeeds    20x    3s    Verify Cheque Document Status In DB    ACCEPTED

Get Correct Cheque Document ID
    ${find_query}=    Create Dictionary    creditId=${credit_id}
    ${mongo_result}=    Mongo Db Find    ${SWITCH_CREDIT_DB_NAME}    activations    ${find_query}
    FOR    ${step}    IN    @{mongo_result['body'][0]['steps']}
        Run Keyword If    '${step['code']}' == 'CHEQUE_UPLOAD'    Exit For Loop
    END
    ${doc_id}=    Set Variable    ${step['documents'][0]['docId']}
    RETURN    ${doc_id}

Verify Cheque Document Status In DB
    [Arguments]    ${expected_status}
    ${find_query}=    Create Dictionary    creditId=${credit_id}
    ${mongo_result}=    Mongo Db Find    ${SWITCH_CREDIT_DB_NAME}    activations    ${find_query}
    FOR    ${step}    IN    @{mongo_result['body'][0]['steps']}
        Run Keyword If    '${step['code']}' == 'CHEQUE_UPLOAD'    Exit For Loop
    END
    ${actual_status}=    Set Variable    ${step['documents'][0]['status']}
    Should Be Equal As Strings    ${actual_status}    ${expected_status}

Update Activation Main Status
    ${filter}=    Create Dictionary    creditId=${credit_id}
    ${update_data}=    Create Dictionary    $set=${{ {'status': 'CHEQUE_UPLOAD_ACCEPTED'} }}
    ${result}=    Mongo Db Update One    ${SWITCH_CREDIT_DB_NAME}    activations    ${filter}    ${update_data}
    Should Be Equal As Numbers    ${result['status_code']}    0

Add Journal State To Activation
    ${epoch_sec}=    Get Current Date    result_format=epoch
    ${change_ms}=    Evaluate    int(float(${epoch_sec}) * 1000)
    ${event_model}=    Create Dictionary    userId=${CREDIT_USER_ID}    fundProviderCode=${CREDIT_TEJARAT_FP_CODE}    creditId=${credit_id}    _class=${journal_state.class_name}
    ${journal_entry}=    Create Dictionary    fromStatus=CHEQUE_UPLOAD_READY_TO_PROCESS    toStatus=CHEQUE_UPLOAD_ACCEPTED    changeStatusTime=${change_ms}    eventModel=${event_model}
    ${filter_dict}=    Evaluate    {"creditId": """${credit_id}"""}
    ${push_dict}=    Evaluate    {"journalState": ${journal_entry}}
    ${update_dict}=    Evaluate    {"$push": ${push_dict}}
    Mongo Db Update One    ${SWITCH_CREDIT_DB_NAME}    activations    ${filter_dict}    ${update_dict}

Cheque Received
    ${admin_user_id}=    Set Variable    8${ADMIN_USER_ID}
    ${result}=    POST Credit Admin Cheques Received
    ...    credit_id=${credit_id}
    ...    user_id=${ADMIN_USER_ID}
    ...    fund_provider_code=${CREDIT_TEJARAT_FP_CODE}
    ...    admin_id=${admin_user_id}
    ...    api_call_side=${MICROSERVICE_SIDE}
    ...    basic_auth_param=${EMPTY} 
    Should Be Equal As Numbers    ${result.status_code}    200

Admin Receives the Cheque by Scanner
    ${doc1}    Create Dictionary    docId=credit-activation/${CREDIT_DOCID1}    tag=8
    ${doc2}    Create Dictionary    docId=credit-activation/${CREDIT_DOCID2}    tag=9

    ${docs}    Create List    ${doc1}    ${doc2}

    ${status_code}    POST Admin Collateral Receive
    ...    ${MICROSERVICE_SIDE}
    ...    ${ADMIN_USER_ID}
    ...    ${LOS_CHEQUE_ID}
    ...    ${docs}
    ...    ${COLLATERALTYPE}
    ...    ${BARCODE}
    ...    ${BANKCODE}
    ...    ${FORCEUPDATE}
    Set Test Variable    ${status_code}    ${status_code.status_code}

Confirm Admin Cheque
    ${api_path}=    Set Variable    /${MS_CREDIT_ONBOARDING_PATH}/admin/cheques/confirm/${credit_id}
    ${headers}=    Create Dictionary    Agent=CONSOLE    Platform-Version=${CREDIT_PLATFORM_VERSION}    Origin=${MICROSERVICE_BASE_URL}    User-Id=${ADMIN_USER_ID}    Content-Type=${CREDIT_CONTENT_TYPE}
    ${body}=    Create Dictionary
    ${result}=    POST Credit Cheques Confirm API    ${api_path}    ${headers}    ${body}
    Should Be Equal As Numbers    ${result.status_code}    200

Get Actual Digital Signature
    Sleep    5s
    ${header}=    Create Dictionary    Agent=WEB    Content-Type=${CREDIT_CONTENT_TYPE}    Referer=${APP_BASE_URL}/    User-Id=${CREDIT_USER_ID}
    ${api_path}=    Set Variable    ${MS_CREDIT_ONBOARDING_PATH}/activations/digital-signatures/actual-signature
    ${result}=    GET Credit Digital Signatures Actual Signature    api_call_side=${MICROSERVICE_SIDE}    api_path=${api_path}    header=${header}    body=${{ {} }}    basic_auth_param=${EMPTY} 
    Should Be Equal As Numbers    ${result.status_code}    200

Validate Digital Signature Password
    Sleep    5s
    ${header}=    Create Dictionary    Platform-Version=${CREDIT_PLATFORM_VERSION}    User-Id=${CREDIT_USER_ID}    Content-Type=${CREDIT_CONTENT_TYPE}    Referer=${APP_BASE_URL}/
    ${body}=    Create Dictionary    password=${DIGITAL-SIGNATURE-PASSWORD}
    ${api_path}=    Catenate    SEPARATOR=    ${MS_CREDIT_ONBOARDING_PATH}/activations/digital-signatures/validate-password/    ${credit_id}
    ${result}=    POST Credit Digital Signatures Validate Password    api_call_side=${MICROSERVICE_SIDE}    api_path=${api_path}    header=${header}    body=${body}    basic_auth_param=${EMPTY}  
    Should Be Equal As Numbers    ${result.status_code}    200

Update Digital Signature Expiration Date
    MONGO_DB.Connect To Db    host=${MONGO_DB_DEFAULT_HOST}    port=${MONGO_DB_DEFAULT_PORT}    user=${DIGITAL_SIGNATURE_USER}    password=${MONGO_DB_DEFAULT_PASS}    db_name=${DIGITAL_SIGNATURE_DB}
    ${find_query}=    Evaluate    {"owner.cellNumber": "${CREDIT_CELL_NUMBER}", "status": 1}
    ${signatures}=    MONGO_DB.Find Documents    digital_signatures    ${find_query}
    ${signature}=    Set Variable    ${signatures['body'][0]}
    ${record_id}=    Set Variable    ${signature['_id']}
    ${now_ms}=    Get Current Date    result_format=epoch
    ${new_expiry}=    Evaluate    int(round(${now_ms} * 1000)) + (365 * 24 * 60 * 60 * 1000)
    ${update_filter}=    Evaluate    {"_id": bson.ObjectId("${record_id}")}    modules=bson
    ${update_doc}=    Evaluate    {"$set": {"expirationDate": ${new_expiry}}}
    ${update_result}=    MONGO_DB.Update One    digital_signatures    ${update_filter}    ${update_doc}
    Should Be Equal As Numbers    ${update_result['status_code']}    0
    MONGO_DB.Close Db Connection

Start Signing Documents Generation
    ${header}=    Create Dictionary    Content-Type=${CREDIT_CONTENT_TYPE}    Referer=${APP_BASE_URL}/    User-Id=${CREDIT_USER_ID}
    ${api_path}=    Set Variable    ${MS_CREDIT_ONBOARDING_PATH}/activations/signing-documents/signable/start-generation/${credit_id}
    ${result}=    GET Credit Activations Signing Documents Start Generation    api_call_side=${MICROSERVICE_SIDE}    api_path=${api_path}    header=${header}    body=${{ {} }}    basic_auth_param=${EMPTY}
    Should Be Equal As Numbers    ${result.status_code}    200

Verify Document Signing Status Ready To Sign
    Wait Until Keyword Succeeds    20x    15s    Check Document Signing Status Is Ready To Sign

Check Document Signing Status Is Ready To Sign
    ${find_query}=    Create Dictionary    creditId=${credit_id}
    ${mongo_result}=    Mongo Db Find    ${SWITCH_CREDIT_DB_NAME}    activations    ${find_query}
    FOR    ${step}    IN    @{mongo_result['body'][0]['steps']}
        Run Keyword If    '${step['code']}' == 'SIGNING_DOCUMENT'    Set Test Variable    ${signing_step}    ${step}
    END
    ${ready_found}=    Set Variable    ${False}
    FOR    ${doc}    IN    @{signing_step['documents']}
        Run Keyword If    '${doc['status']}' == 'READY_TO_SIGN'    Set Test Variable    ${ready_found}    ${True}
    END
    Should Be True    ${ready_found}

Get Signing Tracking Code From DB
    ${find_query}=    Create Dictionary    creditId=${credit_id}
    ${mongo_result}=    Mongo Db Find    ${SWITCH_CREDIT_DB_NAME}    activations    ${find_query}
    FOR    ${step}    IN    @{mongo_result['body'][0]['steps']}
        Run Keyword If    '${step['code']}' == 'SIGNING_DOCUMENT'    Set Test Variable    ${signing_step}    ${step}
    END
    ${tracking_code}=    Convert To String    ${signing_step['documents'][0]['trackingCode']}
    Set Global Variable    ${SIGNING_TRACKING_CODE}    ${tracking_code}

Get Signing Doc Id From DB

    ${find_query}=    Create Dictionary    creditId=${credit_id}
    ${mongo_result}=    Mongo Db Find    ${SWITCH_CREDIT_DB_NAME}    activations    ${find_query}

    FOR    ${step_item}    IN    @{mongo_result['body'][0]['steps']}
        Run Keyword If    '${step_item['code']}' == 'SIGNING_DOCUMENT'    Set Test Variable    ${signing_step}    ${step_item}
    END

    ${full_doc_id}=    Convert To String    ${signing_step['documents'][0]['docId']}
    ${parts}=    Split String    ${full_doc_id}    /
    ${doc_id}=    Set Variable    ${parts[-1]}
    Set Global Variable    ${SIGNING_DOC_ID}    ${doc_id}

Complete Signing Documents
    ${header}=    Create Dictionary    Content-Type=${CREDIT_CONTENT_TYPE}    Platform-Version=2025-01-01    Referer=${APP_BASE_URL}/    User-Id=${CREDIT_USER_ID}
    ${body}=    Create Dictionary    creditId=${credit_id}    trackingCode=${SIGNING_TRACKING_CODE}    password=${DIGITAL-SIGNATURE-PASSWORD}
    ${api_path}=    Set Variable    ${MS_CREDIT_ONBOARDING_PATH}/activations/signing-documents
    ${result}=    POST Credit Activations Signing Documents Complete    api_call_side=${MICROSERVICE_SIDE}    api_path=${api_path}    header=${header}    body=${body}    basic_auth_param=${EMPTY}
    Should Be Equal As Numbers    ${result.status_code}    200

Download Digital Signature Document-User Side
    ${header}=    Create Dictionary
    ...    Content-Type=${CREDIT_CONTENT_TYPE}
    ...    User-Id=${CREDIT_USER_ID}

    ${api_path}=    Catenate
    ...    ${MS_FILE_SERVER_PATH}/contents/digital-signature/${SIGNING_DOC_ID}

    ${result}=    GET Digital Signature Document_User Side 
    ...    api_call_side=${MICROSERVICE_SIDE}
    ...    api_path=${api_path}
    ...    header=${header}
    ...    body=${{ {} }}
    ...    basic_auth_param=${EMPTY}

    Should Be Equal As Numbers    ${result.status_code}    200
    Should Not Be Empty    ${result.body}

Download Digital Signature Document-Admin Side
    ${header}=    Create Dictionary
    ...    Content-Type=${CREDIT_CONTENT_TYPE}
    ...    User-Id=${ADMIN_USER_ID}

    ${current_time}=    Evaluate    int(time.time() * 1000)    modules=time

    ${api_path}=    Set Variable
    ...   ${MS_FILE_SERVER_PATH}/admin/contents/digital-signature/${SIGNING_DOC_ID}?time=${current_time}

    ${result}=    GET Admin Digital Signature Document_Admin Side
    ...    api_call_side=${MICROSERVICE_SIDE}
    ...    api_path=${api_path}
    ...    header=${header}
    ...    body=${{ {} }}
    ...    basic_auth_param=${EMPTY}

    Should Be Equal As Numbers    ${result.status_code}    200
    Should Not Be Empty    ${result.body}

Check Credit File Inquiry
    ${header}=    Create Dictionary    Content-Type=${CREDIT_CONTENT_TYPE}    Referer=${APP_BASE_URL}/    User-Id=${CREDIT_USER_ID}
    ${api_path}=    Set Variable    /credit-onboarding/platform/api/credit/check-credit-file/inquiry/${credit_id}
    ${result}=    GET Credit Check Credit File Inquiry    api_call_side=${MICROSERVICE_SIDE}    api_path=${api_path}    header=${header}    body=${{ {} }}    basic_auth_param=${EMPTY}
    Should Be Equal As Numbers    ${result.status_code}    200

Update App Subscription Plan Status To USED
    MONGO_DB.Connect To Db    host=${MONGO_DB_DEFAULT_HOST}    port=${MONGO_DB_DEFAULT_PORT}    user=${app_subscription_user}    password=${MONGO_DB_DEFAULT_PASS}    db_name=${PP_SUBSCRIPTIO_DB}
    ${find_query}=    Create Dictionary    debtor.userId=${CREDIT_USER_ID}
    ${sort_list}=    Evaluate    [["_id", -1]]
    ${response}=    MONGO_DB.Find Documents    purchases    ${find_query}    ${sort_list}
    ${record_count}=    Get Length    ${response['body']}
    Run Keyword If    ${record_count} == 0    Return From Keyword
    ${latest_record}=    Set Variable    ${response['body'][0]}
    ${status_used}=    Run Keyword And Return Status    Should Be Equal As Strings    ${latest_record.get('plan', {}).get('status')}    USED
    Run Keyword If    ${status_used}    Return From Keyword
    ${record_id}=    Set Variable    ${latest_record['_id']}
    ${filter_dict}=    Evaluate    {"_id": bson.ObjectId("${record_id}")}    modules=bson
    ${update_dict}=    Evaluate    {"$set": {"plan.status": "USED"}}
    ${update_resp}=    MONGO_DB.Update One    purchases    ${filter_dict}    ${update_dict}
    MONGO_DB.Close Db Connection

Initiate Subscription
    ${header}=    Create Dictionary    Content-Type=${CREDIT_CONTENT_TYPE}    Origin=${APP_BASE_URL}    Referer=${APP_BASE_URL}/    User-Id=${CREDIT_USER_ID}
    ${api_path}=    Set Variable    ${MS_CREDIT_ONBOARDING_PATH}/subscription/initiate/${credit_id}
    ${result}=    GET Credit Subscription Initiate    api_call_side=${MICROSERVICE_SIDE}    api_path=${api_path}    header=${header}    body=${{ {} }}    basic_auth_param=${EMPTY}
    Should Be Equal As Numbers    ${result.status_code}    200

Initiate Credit Subscription
    ${header}=    Create Dictionary    Content-Type=${CREDIT_CONTENT_TYPE}    Referer=${APP_BASE_URL}/    User-Id=${CREDIT_USER_ID}
    ${body}=    Create Dictionary    allocationPaymentMethodType=${1}
    ${api_path}=    Set Variable    ${MS_CREDIT_ONBOARDING_PATH}/subscription/initiate/${credit_id}
    ${result}=    POST Credit Subscription Initiate    api_call_side=${MICROSERVICE_SIDE}    api_path=${api_path}    header=${header}    body=${body}    basic_auth_param=${EMPTY}
    Should Be Equal As Numbers    ${result.status_code}    200

Wait Until Allocation Prepayment Exists
    Wait Until Keyword Succeeds    30x    10s    Check Allocation Prepayment Exists

Check Allocation Prepayment Exists
    ${query}=    Create Dictionary    creditId=${credit_id}
    ${response}=    Mongo Db Find    ${SWITCH_CREDIT_DB_NAME}    allocation_prepayment    ${query}
    Should Not Be Empty    ${response['body']}

Allocation Prepayments In Progress
    ${header}=    Create Dictionary
    ...    Content-Type=application/json
    ...    User-Id=${ADMIN_USER_ID}
    
    ${empty_fields}=    Create Dictionary
    ${empty_orders}=    Create List
    
    ${restriction1}=    Create Dictionary
    ...    type=simple
    ...    field=cellNumber
    ...    value=${CREDIT_CELL_NUMBER}
    ...    operation=eq
    
    ${fp_values}=    Create List    ${CREDIT_TEJARAT_FP_CODE}
    ${restriction2}=    Create Dictionary
    ...    type=collection
    ...    field=fundProviderCode
    ...    values=${fp_values}
    
    ${status_values}=    Create List    ${0}
    ${restriction3}=    Create Dictionary
    ...    type=collection
    ...    field=status
    ...    values=${status_values}
    
    ${restrictions}=    Create List    ${restriction1}    ${restriction2}    ${restriction3}
    
    ${body}=    Create Dictionary
    ...    fields=${empty_fields}
    ...    restrictions=${restrictions}
    ...    orders=${empty_orders}
    
    ${api_path}=    Set Variable    ${MS_CREDIT_ONBOARDING_PATH}/admin/allocation-prepayments/in-progress
    
    ${result}=    POST Allocation Prepayments In Progress
    ...    api_call_side=${MICROSERVICE_SIDE}
    ...    api_path=${api_path}
    ...    header=${header}
    ...    body=${body}
    ...    basic_auth_param=${EMPTY}
    
    Should Be Equal As Numbers    ${result.status_code}    200

Allocation Prepayments In Progress Import
    ${today_jalali}=    Get Today Jalali Date
    ${tracking_code}=    Generate Unique Tracking Code
    ${header}=    Create Dictionary    Accept=${CREDIT_CONTENT_TYPE}    Content-Type=${CREDIT_CONTENT_TYPE}    User-Id=${ADMIN_USER_ID}
    ${data_row}=    Create List    ${today_jalali}    ${CREDIT_NATIONAL_CODE}    ${CST_NO}    ${FIRST_NAME}    ${LAST_NAME}    ${CREDIT_CELL_NUMBER}    ${CREDIT_BALANCE}    ${LMS_TB_Init_Installment_FBAN_APP}    ${LMS_TB_Init_Installment_ECN_APP}    ${today_jalali}    ${INISTALLMENTS_COUNT}    ${ALLOCATION_STATUS}
    ${data}=    Create List    ${data_row}
    ${body}=    Create Dictionary    data=${data}    fileName=${FILE_NAME}    fundProviderCode=${CREDIT_TEJARAT_FP_CODE}    trackingCode=${tracking_code}    contractStartDate=${NONE}
    ${api_path}=    Set Variable    ${MS_CREDIT_ONBOARDING_PATH}/admin/allocation-prepayments/import
    ${result}=    POST Credit Admin Allocation Prepayments Import    api_call_side=${MICROSERVICE_SIDE}    api_path=${api_path}    header=${header}    body=${body}    basic_auth_param=${EMPTY}
    Should Be Equal As Numbers    ${result.status_code}    200

Get Today Jalali Date
    ${gregorian}=    Get Current Date    result_format=%Y-%m-%d
    ${jalali}=    Evaluate    jdatetime.date.fromgregorian(date=datetime.datetime.strptime('${gregorian}', '%Y-%m-%d')).strftime('%Y/%m/%d')    modules=jdatetime,datetime
    RETURN    ${jalali}

Generate Unique Tracking Code
    ${timestamp}=    Get Time    epoch
    ${random}=    Generate Random String    10    [NUMBERS]
    ${tracking}=    Catenate    SEPARATOR=    5    ${timestamp}    ${random}
    RETURN    ${tracking}

Wait Until Activation Status Active
    Wait Until Keyword Succeeds    30x    10s    Check Activation Status Is Active

Check Activation Status Is Active
    MONGO_DB.Connect To Db    host=${MONGO_DB_DEFAULT_HOST}    port=${MONGO_DB_DEFAULT_PORT}    user=${CREDIT_USER}    password=${MONGO_DB_DEFAULT_PASS}    db_name=${CREDIT_DB}
    ${query}=    Create Dictionary    creditId=${credit_id}
    ${response}=    MONGO_DB.Find Documents    activations    ${query}
    ${record}=    Set Variable    ${response['body'][0]}
    Should Be Equal As Strings    ${record['status']}    ACTIVE
    MONGO_DB.Close Db Connection

Admin Reject Credit
    ${result}=    POST Credit Admin Reject
    ...    credit_id=${credit_id}
    ...    content_type=${CREDIT_CONTENT_TYPE}
    ...    admin_user_id=${ADMIN_USER_ID}
    ...    api_call_side=${MICROSERVICE_SIDE}

    Should Be Equal As Numbers    ${result['status_code']}    200
    
    ${title}=    Set Variable    ${result['body']['result']['title']}
    Should Be Equal As Strings    ${title}    SUCCESS
    
    ${status}=    Set Variable    ${result['body']['result']['status']}
    Should Be Equal As Numbers    ${status}    0

Close All Credit Accounts
    Set Test Variable    ${user_id}    ${CREDIT_USER_ID}
    Evaluate    exec("import builtins; builtins.ObjectId = lambda *a, **k: None")
    Close User Accounts    user_id=${user_id}

Update Cheque Details Record
    ${query}=    Set Variable    UPDATE cheque_details SET cheque_id='${credit_id}' WHERE cheque_id='${LOS_CHEQUE_ID}'
    ${response}=    MySQL Execute Query    ${SWITCH_CREDIT_DB_NAME}    ${query}
    Should Be Equal As Numbers    ${response['status_code']}    0

Update Cheque collateral info
    ${filter}=    Create Dictionary    creditId=${credit_id}
    ${update_data}=    Create Dictionary    $set=${{ {'collateralId': '${credit_id}'} }}
    ${result}=    Mongo Db Update One    ${SWITCH_CREDIT_DB_NAME}    additional_collateral_info    ${filter}    ${update_data}
    Should Be Equal As Numbers    ${result['status_code']}    0

Cancel the credit activation successfully
    ${result}=    POST Credit Admin Activations Cancel
    ...    fund_provider_code=${CREDIT_TEJARAT_FP_CODE}
    ...    credit_id=${credit_id}
    ...    user_id=${CREDIT_USER_ID}  
    ...    admin_user_id=${ADMIN_USER_ID}
    ...    api_call_side=${MICROSERVICE_SIDE}

    Should Be Equal As Numbers    ${result['status_code']}    200
    ${status}=    Set Variable    ${result['body']['result']['title']}
    Should Be Equal As Strings    ${status}    SUCCESS

Archive the unallocated credit successfully

    ${response}=    POST Credit Activation Cancel
    ...    fund_provider_code=${CREDIT_TEJARAT_FP_CODE}
    ...    credit_id=${credit_id}
    ...    cancel_reason_type=${CREDIT_CANCEL_REASON_TYPE}
    ...    cancel_reason=${CREDIT_CANCEL_REASON}
    ...    api_call_side=${MICROSERVICE_SIDE}
    ...    user_id=${CREDIT_USER_ID}

    Should Be Equal As Strings    ${response['status_code']}    200

    Sleep    5s

    ${find_query}=    Create Dictionary    creditId=${credit_id}
    ${result}=    Mongo Db Find    ${SWITCH_CREDIT_DB_NAME}    activations    ${find_query}
    Should Be Empty    ${result['body']}