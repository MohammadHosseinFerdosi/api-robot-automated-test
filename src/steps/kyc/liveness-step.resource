*** Settings ***
Library          OperatingSystem
Library          library/media_utils.py
Resource         apis/kyc/kyc-liveness/liveness-native-register.resource
Resource         apis/kyc/kyc-liveness/liveness-status.resource
Resource         apis/kyc/kyc-liveness/liveness-native-signature.resource
Resource         apis/kyc/kyc-liveness/liveness-native-selfie.resource
Resource         apis/kyc/kyc-liveness/liveness-native-selfie-video.resource
Resource         apis/kyc/kyc-liveness/liveness-native-remove.resource
Resource         apis/kyc/digital-signatures/revoke.resource
Resource         services/db/mongo-db-service.resource
Variables        data/kyc/digital-signature-variables.yml


*** Keywords ***
Prepare Clean State
    Revoke Active Digital Signature If Any
    Cancel Pending Digital Signatures In Db
    Remove Open Liveness If Any
    Soft Delete Active Liveness In Db

Revoke Active Digital Signature If Any
    &{query}    Create Dictionary    owner.userId=${USER_ID}    status=${DSP_STATUS['INITIATED']}
    ${sort}    Build Desc Sort
    ${result}    Mongo Db Find One
    ...    ${DSP_MONGO_DATA['db_name']}
    ...    ${DSP_MONGO_DATA['digital_signatures_collection']}
    ...    ${query}
    ...    ${sort}
    ${has_doc}    Run Keyword And Return Status    Dictionary Should Contain Key    ${result['body']}    trackingCode
    IF    not ${has_doc}
        RETURN
    END
    POST Digital Signatures Revoke
    ...    ${MICROSERVICE_SIDE}
    ...    ${REQUESTER_APP_NAME}
    ...    ${USER_ID}
    ...    ${SIGNATURE_TYPE}

Cancel Pending Digital Signatures In Db
    &{filter}    Create Dictionary    owner.userId=${USER_ID}    status=${DSP_STATUS['PENDING']}
    ${revoked}    Convert To Integer    ${DSP_STATUS['REVOKED']}
    ${update}    Evaluate    {"$set": {"status": ${revoked}}}
    Mongo Db Update Many
    ...    db_name=${DSP_MONGO_DATA['db_name']}
    ...    collection_name=${DSP_MONGO_DATA['digital_signatures_collection']}
    ...    filter_query=${filter}
    ...    update_data=${update}

Remove Open Liveness If Any
    POST KYC Liveness Native Remove    ${MICROSERVICE_SIDE}    ${USER_ID}    ${SIGNATURE_TYPE}

Soft Delete Active Liveness In Db
    ${false_deleted}    Convert To Boolean    false
    &{filter}    Create Dictionary    userId=${USER_ID}    deleted=${false_deleted}
    ${update}    Evaluate    {"$set": {"deleted": True}}
    Mongo Db Update Many
    ...    db_name=${LIVENESS_MONGO_DATA['db_name']}
    ...    collection_name=${LIVENESS_MONGO_DATA['liveness_collection']}
    ...    filter_query=${filter}
    ...    update_data=${update}

Build Desc Sort
    [Arguments]    ${field}=lastModificationDate
    ${dir}    Convert To Integer    -1
    @{pair}    Create List    ${field}    ${dir}
    @{sort}    Create List    ${pair}
    RETURN    ${sort}

Read Fixture As Base64
    [Arguments]    ${fixture_rel_path}
    ${path}    Join Path    ${CURDIR}    ..    ..    data    kyc    ${fixture_rel_path}
    ${path}    Normalize Path    ${path}
    ${content}    File To Base64    ${path}
    RETURN    ${content}

Register Native Liveness
    ${result}    POST KYC Liveness Native Register
    ...    ${MICROSERVICE_SIDE}
    ...    ${REQUESTER_APP_NAME}
    ...    ${USER_ID}
    ...    ${REGISTER_DATA}
    Should Be Equal As Integers    ${result['status_code']}    200
    Set Test Variable    ${REGISTER_RESPONSE}    ${result['body']}

Post User Signature Picture
    [Arguments]    ${content}=${None}
    IF    $content is None
        ${content}    Read Fixture As Base64    ${FIXTURES['signature']}
    END
    ${result}    POST KYC Liveness Native Signature
    ...    ${MICROSERVICE_SIDE}
    ...    ${REQUESTER_APP_NAME}
    ...    ${USER_ID}
    ...    ${SIGNATURE_DATA}
    ...    ${content}
    Should Be Equal As Integers    ${result['status_code']}    200
    Set Test Variable    ${USER_SIGNATURE_RESPONSE}    ${result['body']}

Post User Signature Picture Expecting Error
    [Arguments]    ${content}=${EMPTY}
    ${result}    POST KYC Liveness Native Signature
    ...    ${MICROSERVICE_SIDE}
    ...    ${REQUESTER_APP_NAME}
    ...    ${USER_ID}
    ...    ${SIGNATURE_DATA}
    ...    ${content}
    Set Test Variable    ${USER_SIGNATURE_RESPONSE}    ${result['body']}

Post User Selfie Picture
    [Arguments]    ${content}=${None}
    IF    $content is None
        ${content}    Read Fixture As Base64    ${FIXTURES['selfie']}
    END
    ${result}    POST KYC Liveness Native Selfie
    ...    ${MICROSERVICE_SIDE}
    ...    ${USER_ID}
    ...    ${SELFIE_DATA}
    ...    ${content}
    Should Be Equal As Integers    ${result['status_code']}    200
    Set Test Variable    ${USER_SELFIE_RESPONSE}    ${result['body']}

Post User Selfie Picture Expecting Error
    [Arguments]    ${content}=${None}
    IF    $content is None
        ${content}    Read Fixture As Base64    ${FIXTURES['selfie']}
    END
    ${result}    POST KYC Liveness Native Selfie
    ...    ${MICROSERVICE_SIDE}
    ...    ${USER_ID}
    ...    ${SELFIE_DATA}
    ...    ${content}
    Set Test Variable    ${USER_SELFIE_RESPONSE}    ${result['body']}

Post Wrong Selfie Picture
    ${content}    Read Fixture As Base64    ${FIXTURES['wrong_selfie']}
    Post User Selfie Picture Expecting Error    ${content}

Post 3 Times Wrong Selfie Picture
    FOR    ${i}    IN RANGE    3
        Post Wrong Selfie Picture
    END

Post User Selfie Video
    [Arguments]    ${content}=${None}
    IF    $content is None
        ${content}    Read Fixture As Base64    ${FIXTURES['video']}
    END
    ${result}    POST KYC Liveness Native Selfie Video
    ...    ${MICROSERVICE_SIDE}
    ...    ${USER_ID}
    ...    ${VIDEO_DATA}
    ...    ${content}
    Should Be Equal As Integers    ${result['status_code']}    200
    Set Test Variable    ${USER_SELFIE_VIDEO_RESPONSE}    ${result['body']}
    Set Test Variable    ${USER_SELFIE_RESPONSE}    ${result['body']}

Post User Selfie Video Expecting Error
    [Arguments]    ${content}=${None}
    IF    $content is None
        ${content}    Read Fixture As Base64    ${FIXTURES['video']}
    END
    ${result}    POST KYC Liveness Native Selfie Video
    ...    ${MICROSERVICE_SIDE}
    ...    ${USER_ID}
    ...    ${VIDEO_DATA}
    ...    ${content}
    Set Test Variable    ${USER_SELFIE_VIDEO_RESPONSE}    ${result['body']}
    Set Test Variable    ${USER_SELFIE_RESPONSE}    ${result['body']}

Post Wrong Selfie Video
    [Arguments]    ${retry_count}=1
    ${content}    Read Fixture As Base64    ${FIXTURES['wrong_video']}
    FOR    ${i}    IN RANGE    ${retry_count}
        Post User Selfie Video Expecting Error    ${content}
    END

We Should See Liveness Status Api Is
    [Arguments]    ${expected_status}    ${timeout}=5 minutes    ${interval}=10 seconds
    Wait Until Keyword Succeeds    ${timeout}    ${interval}    Liveness Status Api Should Be    ${expected_status}

Liveness Status Api Should Be
    [Arguments]    ${expected_status}
    ${result}    GET KYC Liveness Status    ${MICROSERVICE_SIDE}    ${USER_ID}    ${SIGNATURE_TYPE}
    Should Be Equal As Integers    ${result['status_code']}    200
    Should Be Equal As Integers    ${result['body']['livenessStatus']}    ${expected_status}

We Should See User Data With Status 10 In Liveness DB
    We Should See Active Liveness Status In Db    ${LIVENESS_STATUS['REGISTRATION']}

We Should See User Data With Status 20 In Liveness DB
    We Should See Active Liveness Status In Db    ${LIVENESS_STATUS['SAVE_SIGNATURE']}

We Should See User Data With Status 30 In Liveness DB
    We Should See Active Liveness Status In Db    ${LIVENESS_STATUS['SAVE_SELFIE']}

We Should See User Data With Status 50 In Liveness DB
    We Should See Active Liveness Status In Db    ${LIVENESS_STATUS['VERIFY']}

We Should See Active Liveness Status In Db
    [Arguments]    ${expected_status}
    ${false_deleted}    Convert To Boolean    false
    &{query}    Create Dictionary    userId=${USER_ID}    deleted=${false_deleted}
    ${sort}    Build Desc Sort
    ${result}    Mongo Db Find One
    ...    ${LIVENESS_MONGO_DATA['db_name']}
    ...    ${LIVENESS_MONGO_DATA['liveness_collection']}
    ...    ${query}
    ...    ${sort}
    ${has_doc}    Run Keyword And Return Status    Dictionary Should Contain Key    ${result['body']}    status
    IF    not ${has_doc}
        Fail    no active liveness in db for ${USER_ID}
    END
    Should Be Equal As Integers    ${result['body']['status']}    ${expected_status}

We Should See KYC Liveness Invalid Liveness Status Error In Response
    Should Be Equal    ${USER_SELFIE_RESPONSE}    ${KYC_LIVENESS_INVALID_LIVENESS_STATUS}

We Should See KYC Liveness Provider Image Does Not Match Error In Response
    Should Be Equal    ${USER_SELFIE_RESPONSE}    ${KYC_LIVENESS_PROVIDER_IMAGE_DOES_NOT_MATCH}

We Should See KYC Liveness Provider Max Retry Reached Error In Response
    Should Be Equal    ${USER_SELFIE_RESPONSE}    ${KYC_LIVENESS_PROVIDER_MAX_RETRY_REACHED}

We Should See KYC Liveness Provider Process Error For First Time In Response
    Should Be Equal As Strings
    ...    ${USER_SELFIE_RESPONSE['result']['title']}
    ...    ${KYC_LIVENESS_PROVIDER_PROCESS_ERROR['result']['title']}
    Should Be Equal As Integers
    ...    ${USER_SELFIE_RESPONSE['result']['status']}
    ...    ${KYC_LIVENESS_PROVIDER_PROCESS_ERROR['result']['status']}
    Should Be Equal As Strings
    ...    ${USER_SELFIE_RESPONSE['result']['message']}
    ...    ${KYC_LIVENESS_PROVIDER_PROCESS_ERROR['result']['message']}
    Should Be Equal As Strings
    ...    ${USER_SELFIE_RESPONSE['result']['level']}
    ...    ${KYC_LIVENESS_PROVIDER_PROCESS_ERROR['result']['level']}
    Should Be Equal As Strings
    ...    ${USER_SELFIE_RESPONSE['result']['providerMessage']}
    ...    ${PROVIDER_ERROR_MESSAGE_FOR_VIDEO['providerMessage1']}

We Should See KYC Liveness Provider Process Error For Second Time In Response
    Should Be Equal As Strings
    ...    ${USER_SELFIE_RESPONSE['result']['title']}
    ...    ${KYC_LIVENESS_PROVIDER_PROCESS_ERROR['result']['title']}
    Should Be Equal As Integers
    ...    ${USER_SELFIE_RESPONSE['result']['status']}
    ...    ${KYC_LIVENESS_PROVIDER_PROCESS_ERROR['result']['status']}
    Should Be Equal As Strings
    ...    ${USER_SELFIE_RESPONSE['result']['message']}
    ...    ${KYC_LIVENESS_PROVIDER_PROCESS_ERROR['result']['message']}
    Should Be Equal As Strings
    ...    ${USER_SELFIE_RESPONSE['result']['level']}
    ...    ${KYC_LIVENESS_PROVIDER_PROCESS_ERROR['result']['level']}
    Should Be Equal As Strings
    ...    ${USER_SELFIE_RESPONSE['result']['providerMessage']}
    ...    ${PROVIDER_ERROR_MESSAGE_FOR_VIDEO['providerMessage2']}

We Should See KYC Liveness Provider Process Error For Third Time In Response
    Should Be Equal As Strings
    ...    ${USER_SELFIE_RESPONSE['result']['title']}
    ...    ${KYC_LIVENESS_PROVIDER_PROCESS_ERROR['result']['title']}
    Should Be Equal As Integers
    ...    ${USER_SELFIE_RESPONSE['result']['status']}
    ...    ${KYC_LIVENESS_PROVIDER_PROCESS_ERROR['result']['status']}
    Should Be Equal As Strings
    ...    ${USER_SELFIE_RESPONSE['result']['message']}
    ...    ${KYC_LIVENESS_PROVIDER_PROCESS_ERROR['result']['message']}
    Should Be Equal As Strings
    ...    ${USER_SELFIE_RESPONSE['result']['level']}
    ...    ${KYC_LIVENESS_PROVIDER_PROCESS_ERROR['result']['level']}
    Should Be Equal As Strings
    ...    ${USER_SELFIE_RESPONSE['result']['providerMessage']}
    ...    ${PROVIDER_ERROR_MESSAGE_FOR_VIDEO['providerMessage3']}

We Should See Invalid Parameter For Signature File Error In Response
    Should Be Equal    ${USER_SIGNATURE_RESPONSE}    ${INVALID_PARAMETER_FOR_SIGNATURE_FILE}

We Should See Invalid Parameter For Selfie Image File Error In Response
    Should Be Equal    ${USER_SELFIE_RESPONSE}    ${INVALID_PARAMETER_FOR_SELFIE_IMAGE_FILE}

We Should See Invalid Parameter For Selfie Video File Error In Response
    Should Be Equal    ${USER_SELFIE_RESPONSE}    ${INVALID_PARAMETER_FOR_SELFIE_VIDEO_FILE}
