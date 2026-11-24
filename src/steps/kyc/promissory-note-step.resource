*** Settings ***
Library         library/faker_utils.py    WITH NAME    FakerLibrary
Resource        apis/kyc/promissory-note/inquiry.resource
Resource        apis/kyc/promissory-note/route.resource
Resource        apis/kyc/promissory-note/initiate.resource
Resource        apis/kyc/promissory-note/refund.resource
Resource        apis/kyc/admin/post-promissory-notes-settings-provider.resource
Resource        apis/kyc/admin/get-promissory-notes-settings-provider.resource
Resource        apis/kyc/admin/post-promissory-notes-cancel.resource
Resource        services/db/mongo-db-service.resource
Resource        services/backend/auth-service.resource
Variables       data/kyc/promissory-note-variables.yml


*** Keywords ***
Get Provider Weight
    [Documentation]    Get provider weights. After test we set this settings again.

    ${result}    GET Admin Promissory Notes Setting Provider

    Should Be Equal As Integers    ${result['status_code']}    200

    &{PROVIDERS_WEIGHTS}    Create Dictionary
    ...    recipientDtos=${result['body']['settingDetail']['recipientDtos']}

    Set Suite Variable    ${PROVIDERS_WEIGHTS}

Post Default Provider Weight
    [Arguments]
    ...    ${promissory_note_setting}

    FOR    ${i}    IN    ${promissory_note_setting}
        Post Provider Weight    ${i}
    END
    

Post Provider Weight
    [Documentation]    Set provider that we want call shahkar API with it.
    [Arguments]
    ...    ${promissory_note_setting}

    ${PROVIDER_RESULT_RESPONSE}    POST Admin Promissory Notes Setting Provider
    ...    ${MICROSERVICE_SIDE}
    ...    ${promissory_note_setting}

    Set Suite Variable    ${PROVIDER_RESULT_RESPONSE}

Set Promissory Note Provider
    [Arguments]
    ...    ${active_auto_weighting}
    ...    ${recipient_code}
    ...    ${provider_enum}
    
    &{recipientDtos}    Create Dictionary
    &{promissory_note_settings}    Create Dictionary
    @{providersDto}    Create List

    FOR    ${provider_index}    IN RANGE    0    4
        &{provider}    Create Dictionary    &{EMPTY}
        Set To Dictionary    ${provider}    providerName    ${provider_index}
        IF    ${provider_index} == ${provider_enum}
            Set To Dictionary    ${provider}    weight    1.0
            Set To Dictionary    ${provider}    active    true
            Set To Dictionary    ${provider}    priority    1
            Append To List    ${providersDto}    ${provider}
        ELSE
            Set To Dictionary    ${provider}    weight    0.0
            Set To Dictionary    ${provider}    active    false
            Set To Dictionary    ${provider}    priority    1
            Append To List    ${providersDto}    ${provider}
        END
    END
    Set To Dictionary    ${recipientDtos}    recipient    ${recipient_code}
    Set To Dictionary    ${recipientDtos}    providersDto    ${providersDto}
    Set To Dictionary    ${promissory_note_settings}    recipientDto    ${recipientDtos}
    
    Post Provider Weight    ${promissory_note_settings}

Initiate Promissory Note
    [Documentation]    In this step after inquiry new '${tracking_code}' and route it, we post '${tracking_code}' and
    ...    user data to initiate a promissory note.
    [Arguments]
    ...    ${recepiant_code}
    ...    ${provider_response_sample}

    Post Tracking Code Of Promissory Note To Inquiry API
    Post Tracking Code To Route API    ${recepiant_code}
    We should See Route Reponse From Provider    ${provider_response_sample}

    ${INITIATE_RESPONSE}    POST Promissory Notes Init
    ...    ${MICROSERVICE_SIDE}
    ...    ${REQUESTER_APP_NAME}
    ...    ${TEST_TRACKING_CODE}
    ...    ${PROMISSORY_NOTE_USER_DATA}
    ...    ${recepiant_code}

    Should Be Equal As Integers    ${INITIATE_RESPONSE['status_code']}    200

    Set Test Variable    &{INITIATE_RESPONSE}

Post Tracking Code Of Promissory Note To Inquiry API
    [Documentation]    In this step we post '${tracking_code}' of promissory note for get detail of promissory note.
    [Arguments]
    ...    ${tracking_code}=${EMPTY}

    IF    '${tracking_code}' == '${EMPTY}'
        ${tracking_code}    Generate Random String    18    [NUMBERS]

        ${INQUIRY_RESPONSE}    POST Promissory Notes Inquiry
        ...    ${MICROSERVICE_SIDE}
        ...    ${tracking_code}

        Set Test Variable    ${INQUIRY_RESPONSE}
        Should Be Equal As Integers    ${INQUIRY_RESPONSE['status_code']}    422
    ELSE
        ${INQUIRY_RESPONSE}    POST Promissory Notes Inquiry
        ...    ${MICROSERVICE_SIDE}
        ...    ${tracking_code}

        Set Test Variable    ${INQUIRY_RESPONSE}
        Should Be Equal As Integers    ${INQUIRY_RESPONSE['status_code']}    200
    END

    Set Test Variable    ${TEST_TRACKING_CODE}    ${tracking_code}

Post Tracking Code To Route API
    [Documentation]    We post '${tracking_code}' to set provider for promissory note and see steps and detalis.
    [Arguments]
    ...    ${recipient_code}

    ${ROUTE_RESPONSE}    POST Promissory Notes Route
    ...    ${MICROSERVICE_SIDE}
    ...    ${REQUESTER_APP_NAME}
    ...    ${TEST_TRACKING_CODE}
    ...    ${recipient_code}

    Should Be Equal As Integers    ${ROUTE_RESPONSE['status_code']}    200

    Set Test Variable    ${ROUTE_RESPONSE}

Change Status Of Promissory Note To 30 Manualy
    &{query}    Create Dictionary    trackingCode    ${TEST_TRACKING_CODE}

    ${pay_status}    Set Variable    30
    ${pay_status}    Convert To Integer    ${pay_status}

    FOR    ${i}    IN RANGE    10
        IF    $i == 9
            Fail
            ...    msg=We have issue in change manualy status of promissory note with tracking code: ${TEST_TRACKING_CODE} and status is: ${result[0]['status']}
        ELSE
            ${result}    Mongo Db Find
            ...    ${MONGO_DATA['db_name']}
            ...    ${MONGO_DATA['promissory_notes_collection']}
            ...    ${query}

            ${result}    Set Variable    ${result['body']}

            IF    ${result[0]['status']} == 70
                Fail    msg=promissory note canceled.
            ELSE IF    ${result[0]['status']} == 80
                Fail    msg=promissory note canceled.
            ELSE IF    ${result[0]['status']} == 20
                &{update_status}    Create Dictionary    &{EMPTY}
                Set To Dictionary    ${update_status}    status    ${pay_status}

                &{update_query}    Create Dictionary    &{EMPTY}
                Set To Dictionary    ${update_query}    $set    ${update_status}

                ${update_result}    Mongo Db Update Many
                ...    db_name=${MONGO_DATA['db_name']}
                ...    collection_name=${MONGO_DATA['promissory_notes_collection']}
                ...    filter_query=${query}
                ...    update_data=${update_query}

                ${update_result}    Set Variable    ${update_result['body']}

                BREAK
            ELSE
                Sleep    5s
                CONTINUE
            END
        END
    END

    Should Be Equal As Integers    ${update_result['modified_count']}    1

Post Tracking Code To Cancel
    [Documentation]    We post '${tracking_code}' to cancel and delete promissory note.

    ${CANCEL_RESPONSE}    POST Promissory Notes Cancel
    ...    ${MICROSERVICE_SIDE}
    ...    ${TEST_TRACKING_CODE}

    Should Be Equal As Integers    ${CANCEL_RESPONSE['status_code']}    200

    Set Test Variable    ${CANCEL_RESPONSE}

Initiate New Promissory Note For User That Has Promissory Note With Status 20
    [Arguments]
    ...    ${recipient_code}
    ...    ${provider_response_sample}

    Set Test Variable    ${OLD_TRACKING_CODE}    ${TEST_TRACKING_CODE}
    Initiate Promissory Note    ${recipient_code}    ${provider_response_sample}

Post Tracking Code To Refund User Payment
    [Documentation]    We post '${tracking_code}' to cancel and refund user payment.

    ${REFUND_RESPONSE}    POST Promissory Notes Refund
    ...    ${MICROSERVICE_SIDE}
    ...    ${REQUESTER_APP_NAME}
    ...    ${TEST_TRACKING_CODE}

    Set Test Variable    ${REFUND_RESPONSE}

Set Provider Weight More than 1
    [Arguments]
    ...    ${active_auto_weighting}
    ...    ${recipient_code}
    
    &{recipientDtos}    Create Dictionary
    &{promissory_note_settings}    Create Dictionary
    @{providersDto}    Create List

    FOR    ${provider_index}    IN RANGE    0    4
        &{provider}    Create Dictionary    &{EMPTY}
        Set To Dictionary    ${provider}    providerName    ${provider_index}
        Set To Dictionary    ${provider}    weight    1.1
        Set To Dictionary    ${provider}    active    true
        Set To Dictionary    ${provider}    priority    1
        Append To List    ${providersDto}    ${provider}

    END
    Set To Dictionary    ${recipientDtos}    recipient    ${recipient_code}
    Set To Dictionary    ${recipientDtos}    providersDto    ${providersDto}
    Set To Dictionary    ${promissory_note_settings}    recipientDto    ${recipientDtos}
    
    Post Provider Weight    ${promissory_note_settings}

Set Provider Weight Less than 1
    [Arguments]
    ...    ${active_auto_weighting}
    ...    ${recipient_code}
    
    &{recipientDtos}    Create Dictionary
    &{promissory_note_settings}    Create Dictionary
    @{providersDto}    Create List

    FOR    ${provider_index}    IN RANGE    0    4
        &{provider}    Create Dictionary    &{EMPTY}
        Set To Dictionary    ${provider}    providerName    ${provider_index}
        Set To Dictionary    ${provider}    weight    0.1
        Set To Dictionary    ${provider}    active    true
        Set To Dictionary    ${provider}    priority    1
        Append To List    ${providersDto}    ${provider}

    END
    Set To Dictionary    ${recipientDtos}    recipient    ${recipient_code}
    Set To Dictionary    ${recipientDtos}    providersDto    ${providersDto}
    Set To Dictionary    ${promissory_note_settings}    recipientDto    ${recipientDtos}
    
    Post Provider Weight    ${promissory_note_settings}

Set Provider Weight That Sum Of Them Is Less Than 1
    [Arguments]
    ...    ${active_auto_weighting}
    ...    ${recipient_code}
    
    &{recipientDtos}    Create Dictionary
    &{promissory_note_settings}    Create Dictionary
    @{providersDto}    Create List

    @{sum_list}    Create List    0.01    0.005    0.002    0.003

    FOR    ${provider_index}    IN RANGE    0    4
        &{provider}    Create Dictionary    &{EMPTY}
        Set To Dictionary    ${provider}    providerName    ${provider_index}
        Set To Dictionary    ${provider}    weight    ${sum_list[${provider_index}]}
        Set To Dictionary    ${provider}    active    true
        Set To Dictionary    ${provider}    priority    1
        Append To List    ${providersDto}    ${provider}

    END
    Set To Dictionary    ${recipientDtos}    recipient    ${recipient_code}
    Set To Dictionary    ${recipientDtos}    providersDto    ${providersDto}
    Set To Dictionary    ${promissory_note_settings}    recipientDto    ${recipientDtos}
    
    Post Provider Weight    ${promissory_note_settings}

Set Provider Weight That Sum Of Them Is More Than 1
    [Arguments]
    ...    ${active_auto_weighting}
    ...    ${recipient_code}
    
    &{recipientDtos}    Create Dictionary
    &{promissory_note_settings}    Create Dictionary
    @{providersDto}    Create List

    @{sum_list}    Create List    0.5    0.6    0.43    0.73    0.18

    FOR    ${provider_index}    IN RANGE    0    4
        &{provider}    Create Dictionary    &{EMPTY}
        Set To Dictionary    ${provider}    providerName    ${provider_index}
        Set To Dictionary    ${provider}    weight    ${sum_list[${provider_index}]}
        Set To Dictionary    ${provider}    active    true
        Set To Dictionary    ${provider}    priority    1
        Append To List    ${providersDto}    ${provider}

    END
    Set To Dictionary    ${recipientDtos}    recipient    ${recipient_code}
    Set To Dictionary    ${recipientDtos}    providersDto    ${providersDto}
    Set To Dictionary    ${promissory_note_settings}    recipientDto    ${recipientDtos}
    
    Post Provider Weight    ${promissory_note_settings}

Set All Providers Weight To 0
    [Arguments]
    ...    ${active_auto_weighting}
    ...    ${recipient_code}
    
    &{recipientDtos}    Create Dictionary
    &{promissory_note_settings}    Create Dictionary
    @{providersDto}    Create List

    FOR    ${provider_index}    IN RANGE    0    4
        &{provider}    Create Dictionary    &{EMPTY}
        Set To Dictionary    ${provider}    providerName    ${provider_index}
        Set To Dictionary    ${provider}    weight    0
        Set To Dictionary    ${provider}    active    true
        Set To Dictionary    ${provider}    priority    1
        Append To List    ${providersDto}    ${provider}

    END
    Set To Dictionary    ${recipientDtos}    recipient    ${recipient_code}
    Set To Dictionary    ${recipientDtos}    providersDto    ${providersDto}
    Set To Dictionary    ${promissory_note_settings}    recipientDto    ${recipientDtos}
    
    Post Provider Weight    ${promissory_note_settings}

Set All Providers Active Field To false
    [Arguments]
    ...    ${active_auto_weighting}
    ...    ${recipient_code}
    
    &{recipientDtos}    Create Dictionary
    &{promissory_note_settings}    Create Dictionary
    @{providersDto}    Create List

    FOR    ${provider_index}    IN RANGE    0    4
        &{provider}    Create Dictionary    &{EMPTY}
        Set To Dictionary    ${provider}    providerName    ${provider_index}
        Set To Dictionary    ${provider}    weight    0.1
        Set To Dictionary    ${provider}    active    false
        Set To Dictionary    ${provider}    priority    1
        Append To List    ${providersDto}    ${provider}

    END
    Set To Dictionary    ${recipientDtos}    recipient    ${recipient_code}
    Set To Dictionary    ${recipientDtos}    providersDto    ${providersDto}
    Set To Dictionary    ${promissory_note_settings}    recipientDto    ${recipientDtos}
    
    Post Provider Weight    ${promissory_note_settings}

We should See Route Reponse From Provider
    [Arguments]    ${Provider_response}

    Dictionaries Should Be Equal    ${ROUTE_RESPONSE['body']}    ${Provider_response}

    &{query}    Create Dictionary    trackingCode    ${TEST_TRACKING_CODE}

    ${result}    Mongo Db Find
    ...    ${MONGO_DATA['db_name']}
    ...    ${MONGO_DATA['promissory_notes_collection']}
    ...    ${query}

    ${result}    Set Variable    ${result['body']}

    Should Be Equal As Integers    ${result[0]['status']}    -10

We Should See Promissory Note Not Found Response
    [Documentation]    If tracking code that we post in inquiry API not found, we should promissory note not found
    ...    message.

    Dictionaries Should Be Equal    ${INQUIRY_RESPONSE['body']}    ${PROMISSORY_NOTE_NOT_FOUND_RESPONSE}

 We should See Initiated Promissory Note With Status 20
    [Documentation]    If promissory note genrated, we should see status = 20

    &{query}    Create Dictionary    trackingCode    ${TEST_TRACKING_CODE}

    FOR    ${i}    IN RANGE    10
        IF    $i == 9
            Fail
            ...    msg=We have issue in initiate promissory note with tracking code: ${TEST_TRACKING_CODE} and status is: ${result[0]['status']}
        ELSE
            ${result}    Mongo Db Find
            ...    ${MONGO_DATA['db_name']}
            ...    ${MONGO_DATA['promissory_notes_collection']}
            ...    ${query}

            ${result}    Set Variable    ${result['body']}

            IF    ${result[0]['status']} == 70
                Fail    msg=promissory note canceled.
            ELSE IF    ${result[0]['status']} == 80
                Fail    msg=promissory note canceled.
            ELSE IF    ${result[0]['status']} == 20
                Should Be Equal As Integers    ${result[0]['status']}    20
                Should Be True    ${result[0]['generateRelay']}
                BREAK
            ELSE
                Sleep    5s
                CONTINUE
            END
        END
    END

We Should See Recepiant Code is 1 and Provider Code Is 4
    &{query}    Create Dictionary    trackingCode    ${TEST_TRACKING_CODE}

    ${DATABASE_RESULT}    Mongo Db Find
    ...    ${MONGO_DATA['db_name']}
    ...    ${MONGO_DATA['promissory_notes_collection']}
    ...    ${query}

    ${DATABASE_RESULT}    Set Variable    ${DATABASE_RESULT['body']}

    Should Be Equal As Integers    ${DATABASE_RESULT[0]['recipientCode']}    1
    Should Be Equal As Integers    ${DATABASE_RESULT[0]['providerInfo']['provider']}    4

    Set Test Variable    ${DATABASE_RESULT}

We Should See Recepiant Code is 0 and Provider Code Is 1
    &{query}    Create Dictionary    trackingCode    ${TEST_TRACKING_CODE}

    ${DATABASE_RESULT}    Mongo Db Find
    ...    ${MONGO_DATA['db_name']}
    ...    ${MONGO_DATA['promissory_notes_collection']}
    ...    ${query}

    ${DATABASE_RESULT}    Set Variable    ${DATABASE_RESULT['body']}

    Should Be Equal As Integers    ${DATABASE_RESULT[0]['recipientCode']}    0
    Should Be Equal As Integers    ${DATABASE_RESULT[0]['providerInfo']['provider']}    1


    Set Test Variable    ${DATABASE_RESULT}

Check Database With User Data That We Post
    Dictionaries Should Be Equal
    ...    ${DATABASE_RESULT[0]['owner']}
    ...    ${PROMISSORY_NOTE_USER_DATA['owner']}
    Should Be Equal As Strings
    ...    ${DATABASE_RESULT[0]['iban']}
    ...    ${PROMISSORY_NOTE_USER_DATA['iban']}
    ${amount}    Set Variable    ${DATABASE_RESULT[0]['amount']}
    Should Be Equal As Integers
    ...    ${amount}
    ...    ${PROMISSORY_NOTE_USER_DATA['amount']}
    Should Be Equal As Integers
    ...    ${DATABASE_RESULT[0]['dueType']}
    ...    ${PROMISSORY_NOTE_USER_DATA['dueType']}
    Should Be Equal As Integers
    ...    ${DATABASE_RESULT[0]['dueOffsetInYears']}
    ...    ${PROMISSORY_NOTE_USER_DATA['dueOffsetInYears']}
    Should Be Equal As Strings
    ...    ${DATABASE_RESULT[0]['recipient']}
    ...    ${PROMISSORY_NOTE_USER_DATA['recipientId']}
    Should Be Equal As Strings
    ...    ${DATABASE_RESULT[0]['description']}
    ...    ${PROMISSORY_NOTE_USER_DATA['description']}

We should See Paied Promissory Note With Status 30
    [Documentation]    after pay promissory note we should see status 30

    &{query}    Create Dictionary    trackingCode    ${TEST_TRACKING_CODE}

    ${result}    Mongo Db Find
    ...    ${MONGO_DATA['db_name']}
    ...    ${MONGO_DATA['promissory_notes_collection']}
    ...    ${query}

    ${result}    Set Variable    ${result['body']}

    Should Be Equal As Integers    ${result[0]['status']}    30

We should See Deleted Promissory Note With Status 80
    [Documentation]    If promissory note cancel, we should see status = 80

    Dictionaries Should Be Equal    ${CANCEL_RESPONSE['body']}    ${PROMISSORY_NOTE_SUCCESS_RESPONSE}

    &{query}    Create Dictionary    trackingCode    ${TEST_TRACKING_CODE}

    ${result}    Mongo Db Find
    ...    ${MONGO_DATA['db_name']}
    ...    ${MONGO_DATA['promissory_notes_collection']}
    ...    ${query}

    ${result}    Set Variable    ${result['body']}

    Should Be Equal As Integers    ${result[0]['status']}    80

We should See Deleted Previous Promissory Note With Status 80
    &{query}    Create Dictionary    trackingCode    ${OLD_TRACKING_CODE}

    ${result}    Mongo Db Find
    ...    ${MONGO_DATA['db_name']}
    ...    ${MONGO_DATA['promissory_notes_collection']}
    ...    ${query}

    ${result}    Set Variable    ${result['body']}

    Should Be Equal As Integers    ${result[0]['status']}    80

We should Success Result
    [Documentation]    If promissory note genrated, we should see status = 20

    Dictionaries Should Be Equal    ${REFUND_RESPONSE['body']}    ${PROMISSORY_NOTE_SUCCESS_RESPONSE}

We Should See Refund Status = 2 With Status 80 In Database
    Should Be Equal As Integers    ${REFUND_RESPONSE['status_code']}    200

    &{query}    Create Dictionary    trackingCode    ${TEST_TRACKING_CODE}

    ${result}    Mongo Db Find
    ...    ${MONGO_DATA['db_name']}
    ...    ${MONGO_DATA['promissory_notes_collection']}
    ...    ${query}

    ${result}    Set Variable    ${result['body']}

    Should Be Equal As Integers    ${result[0]['status']}    80
    Should Be Equal As Integers    ${result[0]['refundStatus']}    2

We Should See Promissory Note Invalid Refund Status
    Should Be Equal As Integers    ${REFUND_RESPONSE['status_code']}    422
    Dictionaries Should Be Equal    ${REFUND_RESPONSE['body']}    ${PROMISSORY_NOTE_INVALID_REFUND_STATUS}

We Should See Payment Not Found
    Should Be Equal As Integers    ${REFUND_RESPONSE['status_code']}    422
    Dictionaries Should Be Equal    ${REFUND_RESPONSE['body']}    ${PAYMENT_NOT_FOUND}

We Should See Exception Invalid Parameters
    Should Be Equal As Integers    ${PROVIDER_RESULT_RESPONSE['status_code']}    422
    Dictionaries Should Be Equal    ${PROVIDER_RESULT_RESPONSE['body']}    ${INVALID_PARAMETER}

We Should See Exception Failure
    Should Be Equal As Integers    ${PROVIDER_RESULT_RESPONSE['status_code']}    422
    Dictionaries Should Be Equal    ${PROVIDER_RESULT_RESPONSE['body']}    ${FAILRE_RESPONSE}