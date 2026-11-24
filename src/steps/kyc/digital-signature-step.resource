*** Settings ***
Library          String
Resource         steps/kyc/liveness-step.resource
Resource         apis/kyc/digital-signatures/initiate-basic.resource
Resource         apis/kyc/digital-signatures/generate.resource
Resource         apis/kyc/digital-signatures/validate-password.resource


*** Keywords ***
Complete Liveness Steps
    Register Native Liveness
    Post User Signature Picture
    Post User Selfie Picture
    Post User Selfie Video
    Wait Until Keyword Succeeds    5 minutes    10 seconds    Liveness Status Api Should Be    ${LIVENESS_STATUS['VERIFY']}

Register And Post Signature
    Register Native Liveness
    Post User Signature Picture

Register Signature And Selfie
    Register And Post Signature
    Post User Selfie Picture

Initiate A Digital Signature Basic
    ${result}    POST Digital Signatures Initiate Basic
    ...    ${MICROSERVICE_SIDE}
    ...    ${REQUESTER_APP_NAME}
    ...    ${USER_ID}
    ...    ${DIGITAL_SIGNATURE_USER_DATA}
    Should Be Equal As Integers    ${result['status_code']}    200
    Set Test Variable    ${PROVIDER_TRACKING_CODE}    ${result['body']['trackingCode']}
    Set Test Variable    ${INITIATE_RESPONSE}    ${result['body']}

Initiate A Digital Signature Basic Without Password
    ${result}    POST Digital Signatures Initiate Basic
    ...    ${MICROSERVICE_SIDE}
    ...    ${REQUESTER_APP_NAME}
    ...    ${USER_ID}
    ...    ${DIGITAL_SIGNATURE_USER_DATA}
    ...    with_password=${False}
    Set Test Variable    ${INITIATE_RESPONSE}    ${result['body']}
    Set Test Variable    ${LAST_ERROR_BODY}    ${result['body']}

Generate Certificate For Native Digital Signature
    ${result}    POST Digital Signatures Generate
    ...    ${MICROSERVICE_SIDE}
    ...    ${REQUESTER_APP_NAME}
    ...    ${USER_ID}
    ...    ${USER_PASSWORD_DATA}
    ...    ${PROVIDER_TRACKING_CODE}
    Should Be Equal As Integers    ${result['status_code']}    200
    Set Test Variable    ${GENERATE_RESPONSE}    ${result['body']}
    Set Test Variable    ${DIGITAL_SIGNATURE_TRACKING_CODE}    ${result['body']['trackingCode']}

Generate Certificate Expecting Error
    ${result}    POST Digital Signatures Generate
    ...    ${MICROSERVICE_SIDE}
    ...    ${REQUESTER_APP_NAME}
    ...    ${USER_ID}
    ...    ${USER_PASSWORD_DATA}
    ...    ${PROVIDER_TRACKING_CODE}
    Set Test Variable    ${GENERATE_RESPONSE}    ${result['body']}
    Set Test Variable    ${LAST_ERROR_BODY}    ${result['body']}

Initiate And Generate New Digital Signature
    Complete Liveness Steps
    Initiate A Digital Signature Basic
    Generate Certificate For Native Digital Signature
    We Should See Success Response For Generate

Validate Password For Digital Signature API
    [Arguments]    ${user_password}=${None}
    IF    $user_password is None
        ${user_password}    Generate Random String    6    [NUMBERS]
    END
    ${result}    POST Digital Signatures Validate Password
    ...    ${MICROSERVICE_SIDE}
    ...    ${REQUESTER_APP_NAME}
    ...    ${USER_ID}
    ...    ${user_password}
    Set Test Variable    ${VALIDATE_PASSWORD_RESPONSE}    ${result['body']}

Call Revoke Digital Signature API
    ${result}    POST Digital Signatures Revoke
    ...    ${MICROSERVICE_SIDE}
    ...    ${REQUESTER_APP_NAME}
    ...    ${USER_ID}
    ...    ${SIGNATURE_TYPE}
    Should Be Equal As Integers    ${result['status_code']}    200
    Set Test Variable    ${REVOKE_RESPONSE}    ${result['body']}

We Should See Success Response For Generate
    Should Be Equal    ${GENERATE_RESPONSE['result']}    ${SUCCESS_RESPONSE_FOR_GENERATE_SIGNATURE['result']}
    Should Be Equal As Strings
    ...    ${GENERATE_RESPONSE['description']}
    ...    ${SUCCESS_RESPONSE_FOR_GENERATE_SIGNATURE['description']}
    Should Be Equal As Strings
    ...    ${GENERATE_RESPONSE['imageId']}
    ...    ${SUCCESS_RESPONSE_FOR_GENERATE_SIGNATURE['imageId']}
    Should Be Equal As Strings
    ...    ${GENERATE_RESPONSE['statusText']}
    ...    ${SUCCESS_RESPONSE_FOR_GENERATE_SIGNATURE['statusText']}

We Should See Digital Signature Incomplete Liveness Error In Response
    Should Be Equal    ${GENERATE_RESPONSE}    ${DIGITAL_SIGNATURE_INCOMPLETE_LIVENESS}

We Should See Bad Request Error In Response
    Should Be Equal    ${LAST_ERROR_BODY}    ${BAD_REQUEST}

We Should See Validate Password Success Response
    Should Be Equal    ${VALIDATE_PASSWORD_RESPONSE}    ${SUCCESS_RESPONSE}

We Should See Digital Signature Not Found Error In Response
    Should Be Equal    ${VALIDATE_PASSWORD_RESPONSE}    ${DIGITAL_SIGNATURE_NOT_FOUND}

We Should See Digital Signature Password Mismatch Error In Response
    Should Be Equal    ${VALIDATE_PASSWORD_RESPONSE}    ${DIGITAL_SIGNATURE_PASSWORD_MISMATCH}

We Should See Revoke Success Response
    Should Be Equal    ${REVOKE_RESPONSE}    ${SUCCESS_RESPONSE}

We Should See User Data With Status 0 In DSP DB
    &{query}    Create Dictionary
    ...    owner.userId=${USER_ID}
    ...    providerInfo.trackingCode=${PROVIDER_TRACKING_CODE}
    ${sort}    Build Desc Sort
    ${result}    Mongo Db Find One
    ...    ${DSP_MONGO_DATA['db_name']}
    ...    ${DSP_MONGO_DATA['digital_signatures_collection']}
    ...    ${query}
    ...    ${sort}
    ${has_doc}    Run Keyword And Return Status    Dictionary Should Contain Key    ${result['body']}    status
    IF    not ${has_doc}
        Fail    no dsp row for providerTrackingCode=${PROVIDER_TRACKING_CODE}
    END
    Should Be Equal As Integers    ${result['body']['status']}    ${DSP_STATUS['PENDING']}
    Should Be Equal As Strings    ${result['body']['initiator']}    ${REQUESTER_APP_NAME}

We Should See User Data With Status 1 In DSP DB
    &{query}    Create Dictionary    trackingCode=${DIGITAL_SIGNATURE_TRACKING_CODE}
    ${sort}    Build Desc Sort
    ${result}    Mongo Db Find One
    ...    ${DSP_MONGO_DATA['db_name']}
    ...    ${DSP_MONGO_DATA['digital_signatures_collection']}
    ...    ${query}
    ...    ${sort}
    ${has_doc}    Run Keyword And Return Status    Dictionary Should Contain Key    ${result['body']}    status
    IF    not ${has_doc}
        Fail    no dsp row for trackingCode=${DIGITAL_SIGNATURE_TRACKING_CODE}
    END
    Should Be Equal As Strings    ${result['body']['owner']['userId']}    ${USER_ID}
    Should Be Equal As Integers    ${result['body']['status']}    ${DSP_STATUS['INITIATED']}
