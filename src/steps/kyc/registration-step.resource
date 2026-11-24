*** Settings ***
Resource        apis/kyc/kyc/identity-registration-inquiry.resource
Resource        apis/kyc/admin/post-kyc-settings-identity-registration-inquiry-provider-search.resource
Resource        apis/kyc/admin/post-kyc-settings-identity-registration-inquiry-provider.resource
Resource        services/db/mongo-db-service.resource
Resource        services/backend/auth-service.resource
Variables       data/kyc/registration-variables.yml


*** Keywords ***
Replace Arabic Ye
    [Arguments]    
    ...    ${text}

    ${ARABIC_Y}    Set Variable    ي    
    ${PERSIAN_Y}    Set Variable   ی

    @{chars}    Create List
    @{letters}=    Evaluate    list('${text}')

    FOR    ${ch}    IN    @{letters}
        IF    '${ch}' == '${ARABIC_Y}'
            ${ch}=    Set Variable    ${PERSIAN_Y}
        END
        Append To List    ${chars}    ${ch}
    END

    ${REPLACE_RESULT}    Evaluate    ''.join(${chars})

    Set Suite Variable    ${REPLACE_RESULT}

    RETURN    ${REPLACE_RESULT}

Get Provider Weight
    ${result}    POST Admin Kyc Settings Identity Registration Inquiry Provider Search
    ...    ${MICROSERVICE_SIDE}

    Should Be Equal As Integers    ${result['status_code']}    200

    &{basic}    Create Dictionary
    ...    inquiryType    0
    ...    providerSettings   ${result['body']['basicProviders']}
    ...    minWeightAutoWeighting    ${result['body']['minWeightAutoWeighting']}
    ...    activeAutoWeighting    ${result['body']['activeAutoWeighting']}

    &{full}    Create Dictionary
    ...    inquiryType    10
    ...    providerSettings   ${result['body']['fullProviders']}
    ...    minWeightAutoWeighting    ${result['body']['minWeightAutoWeighting']}
    ...    activeAutoWeighting    ${result['body']['activeAutoWeighting']}

    @{PROVIDERS_SETTINGS}    Create List
    ...    ${basic}
    ...    ${full}

    Set Suite Variable    ${PROVIDERS_SETTINGS}

Post Provider Weight
    [Arguments]
    ...    ${settings}

    FOR    ${i}    IN RANGE    0    2
        ${result}    POST Admin Kyc Settings Identity Registration Inquiry Provider
        ...    ${MICROSERVICE_SIDE}
        ...    ${settings[${i}]}

        Should Be Equal As Integers    ${result['status_code']}    200
    END

Check DataBase And Delete All Record With This National Code
    @{national_codes}    Create List

    Append To List    ${national_codes}    ${VALID_PERSON['national_code']}    ${INVALID_PERSON['national_code']}    ${PERSON_FOR_KYC_BAD_RESPONSE['national_code']}

    FOR    ${i}    IN RANGE    0    3
        ${national_code}    Set Variable    ${national_codes[${i}]}

        &{query}    Create Dictionary    &{EMPTY}
        Set To Dictionary    ${query}    nationalCode    ${national_code}

        ${get_data_result}    Mongo Db Find
        ...    ${MONGO_DATA['db_name']}
        ...    ${MONGO_DATA['collection_name']}
        ...    ${query}

        ${get_data_result}    Set Variable    ${get_data_result['body']}

        ${delete_data_result}    Mongo Db Delete Many
        ...    ${MONGO_DATA['db_name']}
        ...    ${MONGO_DATA['collection_name']}
        ...    ${query}

        ${delete_data_result}    Set Variable    ${delete_data_result['body']}
        ${deleted_count}    Set Variable    ${delete_data_result['deleted_count']}

        ${length_get_data_result}    Get Length    ${get_data_result}
        Should Be Equal    ${deleted_count}    ${length_get_data_result}
    END
    

    ${national_code}    Convert To String    ${VALID_PERSON['national_code']}

    &{query}    Create Dictionary    &{EMPTY}
    Set To Dictionary    ${query}    nationalCode    ${national_code}

    ${get_data_result}    Mongo Db Find
    ...    ${MONGO_DATA['db_name']}
    ...    ${MONGO_DATA['collection_name']}
    ...    ${query}

    ${get_data_result}    Set Variable    ${get_data_result['body']}

    ${delete_data_result}    Mongo Db Delete Many
    ...    ${MONGO_DATA['db_name']}
    ...    ${MONGO_DATA['collection_name']}
    ...    ${query}

    ${delete_data_result}    Set Variable    ${delete_data_result['body']}
    ${deleted_count}    Set Variable    ${delete_data_result['deleted_count']}

    ${length_get_data_result}    Get Length    ${get_data_result}
    Should Be Equal    ${deleted_count}    ${length_get_data_result}

Set Registration Provider
    [Arguments]
    ...    ${inquiry_type}
    ...    ${active_auto_weighting}
    ...    ${provider_index}

    @{provider_settings}    Create List
    &{providers_weight}    Create Dictionary
    &{setting_detail}    Create Dictionary
    @{enum_list}    Create List

    IF    ${inquiry_type} == ${PROVIDERS['basic']['type']}
        Append To List    ${enum_list}    1    3    4
    ELSE
        Append To List    ${enum_list}    2    5    6
    END
    

    FOR    ${i}    IN RANGE    0    3
        &{provider}    Create Dictionary    &{EMPTY}
        Set To Dictionary    ${provider}    
        ...    providerName    ${enum_list[${i}]}
        ...    priority    1
        IF    ${enum_list[${i}]} == ${provider_index}
            Set To Dictionary    ${provider}    
            ...    weight    1.0
            ...    active    true
            Append To List    ${provider_settings}    ${provider}
        ELSE
            Set To Dictionary    ${provider}    
            ...    weight    0.0
            ...    active    false
            Append To List    ${provider_settings}    ${provider}
        END
    END
    Set To Dictionary    ${setting_detail}    
    ...    inquiryType    ${inquiry_type}
    ...    providerSettings    ${provider_settings}
    ...    activeAutoWeighting    ${active_auto_weighting}
    ...    minWeightAutoWeighting    ${MIN_WEIGHT_AUTO_WEIGHTING}

    ${result}    POST Admin Kyc Settings Identity Registration Inquiry Provider
    ...    ${MICROSERVICE_SIDE}
    ...    ${setting_detail}

    Should Be Equal As Integers    ${result['status_code']}    200

Post User Data For Registration Inquiry
    [Arguments]    
    ...    ${force_inquiry}
    ...    ${strong_validation}
    ...    ${national_code}
    ...    ${birth_date}
    ...    ${inquiry_type}

    &{REGISTRATION_RESPONSE}    POST Kyc Identity Registration Inquiry
    ...    ${MICROSERVICE_SIDE}
    ...    ${REQUESTER_APP_NAME}
    ...    ${force_inquiry}
    ...    ${strong_validation}
    ...    ${national_code}
    ...    ${birth_date}
    ...    ${inquiry_type}

    Set Test Variable    &{REGISTRATION_RESPONSE}

Call Registration Inquiry For Valid User Twice
    [Arguments]
    ...    ${force_inquiry}
    ...    ${strong_validation}
    ...    ${national_code}
    ...    ${birth_date}
    ...    ${inquiry_type}

    Post User Data For Registration Inquiry    ${force_inquiry}    ${strong_validation}    ${national_code}    
    ...    ${birth_date}     ${inquiry_type}
    Post User Data For Registration Inquiry    ${force_inquiry}    ${strong_validation}    ${national_code}    
    ...    ${birth_date}     ${inquiry_type}

We Should See Success Registration With User Identity Data Response

    ${first_name}    Replace Arabic Ye    ${REGISTRATION_RESPONSE['body']['firstName']}
    ${last_name}    Replace Arabic Ye    ${REGISTRATION_RESPONSE['body']['lastName']}
    ${father_name}    Replace Arabic Ye    ${REGISTRATION_RESPONSE['body']['fatherName']}

    Should Be Equal As Strings    ${first_name}    ${REGISTRATION_SUCCESS_WITH_USER_DATA_RESPONSE['firstName']}
    Should Be Equal As Strings    ${last_name}    ${REGISTRATION_SUCCESS_WITH_USER_DATA_RESPONSE['lastName']}
    Should Be Equal As Strings    ${father_name}    ${REGISTRATION_SUCCESS_WITH_USER_DATA_RESPONSE['fatherName']}
    Should Be Equal As Strings    ${REGISTRATION_RESPONSE['body']['nationalCode']}    ${REGISTRATION_SUCCESS_WITH_USER_DATA_RESPONSE['nationalCode']}
    Should Be Equal As Strings    ${REGISTRATION_RESPONSE['body']['birthDate']}    ${REGISTRATION_SUCCESS_WITH_USER_DATA_RESPONSE['birthDate']}
    Should Be Equal As Strings    ${REGISTRATION_RESPONSE['body']['shenasnameSeri']}    ${REGISTRATION_SUCCESS_WITH_USER_DATA_RESPONSE['shenasnameSeri']}
    Should Be Equal As Strings    ${REGISTRATION_RESPONSE['body']['shenasnameSerial']}    ${REGISTRATION_SUCCESS_WITH_USER_DATA_RESPONSE['shenasnameSerial']}
    Should Be Equal As Strings    ${REGISTRATION_RESPONSE['body']['shenasnameNo']}    ${REGISTRATION_SUCCESS_WITH_USER_DATA_RESPONSE['shenasnameNo']}
    Should Be Equal As Strings    ${REGISTRATION_RESPONSE['body']['birthCertificateInfo']['birthCertificateSerial']}    
    ...    ${REGISTRATION_SUCCESS_WITH_USER_DATA_RESPONSE['birthCertificateInfo']['birthCertificateSerial']}
    Should Be Equal As Strings    ${REGISTRATION_RESPONSE['body']['birthCertificateInfo']['birthCertificateNumber']}    
    ...    ${REGISTRATION_SUCCESS_WITH_USER_DATA_RESPONSE['birthCertificateInfo']['birthCertificateNumber']}
    Should Be Equal As Strings    ${REGISTRATION_RESPONSE['body']['birthCertificateInfo']['birthCertificateSeries']}    
    ...    ${REGISTRATION_SUCCESS_WITH_USER_DATA_RESPONSE['birthCertificateInfo']['birthCertificateSeries']}
    Should Be Equal As Integers    ${REGISTRATION_RESPONSE['body']['deathStatus']}    ${REGISTRATION_SUCCESS_WITH_USER_DATA_RESPONSE['deathStatus']}
    Should Be Equal As Integers    ${REGISTRATION_RESPONSE['body']['gender']}    ${REGISTRATION_SUCCESS_WITH_USER_DATA_RESPONSE['gender']}

We Should See Success Registration With Dead User Identity Data Response

    ${first_name}    Replace Arabic Ye    ${REGISTRATION_RESPONSE['body']['firstName']}
    ${last_name}    Replace Arabic Ye    ${REGISTRATION_RESPONSE['body']['lastName']}
    ${father_name}    Replace Arabic Ye    ${REGISTRATION_RESPONSE['body']['fatherName']}

    Should Be Equal As Strings    ${first_name}    ${REGISTRATION_SUCCESS_WITH_DEAD_USER_DATA_RESPONSE['firstName']}
    Should Be Equal As Strings    ${last_name}    ${REGISTRATION_SUCCESS_WITH_DEAD_USER_DATA_RESPONSE['lastName']}
    Should Be Equal As Strings    ${father_name}    ${REGISTRATION_SUCCESS_WITH_DEAD_USER_DATA_RESPONSE['fatherName']}
    Should Be Equal As Strings    ${REGISTRATION_RESPONSE['body']['nationalCode']}    ${REGISTRATION_SUCCESS_WITH_DEAD_USER_DATA_RESPONSE['nationalCode']}
    Should Be Equal As Strings    ${REGISTRATION_RESPONSE['body']['birthDate']}    ${REGISTRATION_SUCCESS_WITH_DEAD_USER_DATA_RESPONSE['birthDate']}
    Should Be Equal As Strings    ${REGISTRATION_RESPONSE['body']['shenasnameSeri']}    ${REGISTRATION_SUCCESS_WITH_DEAD_USER_DATA_RESPONSE['shenasnameSeri']}
    Should Be Equal As Strings    ${REGISTRATION_RESPONSE['body']['shenasnameSerial']}    ${REGISTRATION_SUCCESS_WITH_DEAD_USER_DATA_RESPONSE['shenasnameSerial']}
    Should Be Equal As Strings    ${REGISTRATION_RESPONSE['body']['shenasnameNo']}    ${REGISTRATION_SUCCESS_WITH_DEAD_USER_DATA_RESPONSE['shenasnameNo']}
    Should Be Equal As Strings    ${REGISTRATION_RESPONSE['body']['birthCertificateInfo']['birthCertificateSerial']}    
    ...    ${REGISTRATION_SUCCESS_WITH_DEAD_USER_DATA_RESPONSE['birthCertificateInfo']['birthCertificateSerial']}
    Should Be Equal As Strings    ${REGISTRATION_RESPONSE['body']['birthCertificateInfo']['birthCertificateNumber']}    
    ...    ${REGISTRATION_SUCCESS_WITH_DEAD_USER_DATA_RESPONSE['birthCertificateInfo']['birthCertificateNumber']}
    Should Be Equal As Strings    ${REGISTRATION_RESPONSE['body']['birthCertificateInfo']['birthCertificateSeries']}    
    ...    ${REGISTRATION_SUCCESS_WITH_DEAD_USER_DATA_RESPONSE['birthCertificateInfo']['birthCertificateSeries']}
    Should Be Equal As Integers    ${REGISTRATION_RESPONSE['body']['deathStatus']}    ${REGISTRATION_SUCCESS_WITH_DEAD_USER_DATA_RESPONSE['deathStatus']}
    Should Be Equal As Integers    ${REGISTRATION_RESPONSE['body']['gender']}    ${REGISTRATION_SUCCESS_WITH_DEAD_USER_DATA_RESPONSE['gender']}




We Should See Success Registration With User Identity Data With Birth Place Field Response

    ${first_name}    Replace Arabic Ye    ${REGISTRATION_RESPONSE['body']['firstName']}
    ${last_name}    Replace Arabic Ye    ${REGISTRATION_RESPONSE['body']['lastName']}
    ${father_name}    Replace Arabic Ye    ${REGISTRATION_RESPONSE['body']['fatherName']}

    Should Be Equal As Strings    ${first_name}    ${REGISTRATION_SUCCESS_WITH_USER_FULL_DATA_RESPONSE['firstName']}
    Should Be Equal As Strings    ${last_name}    ${REGISTRATION_SUCCESS_WITH_USER_FULL_DATA_RESPONSE['lastName']}
    Should Be Equal As Strings    ${father_name}    ${REGISTRATION_SUCCESS_WITH_USER_FULL_DATA_RESPONSE['fatherName']}
    Should Be Equal As Strings    ${REGISTRATION_RESPONSE['body']['nationalCode']}    ${REGISTRATION_SUCCESS_WITH_USER_FULL_DATA_RESPONSE['nationalCode']}
    Should Be Equal As Strings    ${REGISTRATION_RESPONSE['body']['birthDate']}    ${REGISTRATION_SUCCESS_WITH_USER_FULL_DATA_RESPONSE['birthDate']}
    Should Be Equal As Strings    ${REGISTRATION_RESPONSE['body']['birthPlace']}    ${REGISTRATION_SUCCESS_WITH_USER_FULL_DATA_RESPONSE['birthPlace']}
    Should Be Equal As Strings    ${REGISTRATION_RESPONSE['body']['shenasnameSeri']}    ${REGISTRATION_SUCCESS_WITH_USER_FULL_DATA_RESPONSE['shenasnameSeri']}
    Should Be Equal As Strings    ${REGISTRATION_RESPONSE['body']['shenasnameSerial']}    ${REGISTRATION_SUCCESS_WITH_USER_FULL_DATA_RESPONSE['shenasnameSerial']}
    Should Be Equal As Strings    ${REGISTRATION_RESPONSE['body']['shenasnameNo']}    ${REGISTRATION_SUCCESS_WITH_USER_FULL_DATA_RESPONSE['shenasnameNo']}
    Should Be Equal As Strings    ${REGISTRATION_RESPONSE['body']['birthCertificateInfo']['birthCertificateSerial']}    
    ...    ${REGISTRATION_SUCCESS_WITH_USER_FULL_DATA_RESPONSE['birthCertificateInfo']['birthCertificateSerial']}
    Should Be Equal As Strings    ${REGISTRATION_RESPONSE['body']['birthCertificateInfo']['birthCertificateNumber']}    
    ...    ${REGISTRATION_SUCCESS_WITH_USER_FULL_DATA_RESPONSE['birthCertificateInfo']['birthCertificateNumber']}
    Should Be Equal As Strings    ${REGISTRATION_RESPONSE['body']['birthCertificateInfo']['birthCertificateSeries']}    
    ...    ${REGISTRATION_SUCCESS_WITH_USER_FULL_DATA_RESPONSE['birthCertificateInfo']['birthCertificateSeries']}
    Should Be Equal As Integers    ${REGISTRATION_RESPONSE['body']['deathStatus']}    ${REGISTRATION_SUCCESS_WITH_USER_FULL_DATA_RESPONSE['deathStatus']}
    Should Be Equal As Integers    ${REGISTRATION_RESPONSE['body']['gender']}    ${REGISTRATION_SUCCESS_WITH_USER_FULL_DATA_RESPONSE['gender']}

We Should See Success Registration With Dead User Identity Data With Birth Place Field Response

    ${first_name}    Replace Arabic Ye    ${REGISTRATION_RESPONSE['body']['firstName']}
    ${last_name}    Replace Arabic Ye    ${REGISTRATION_RESPONSE['body']['lastName']}
    ${father_name}    Replace Arabic Ye    ${REGISTRATION_RESPONSE['body']['fatherName']}

    Should Be Equal As Strings    ${first_name}    ${REGISTRATION_SUCCESS_WITH_DEAD_USER_FULL_DATA_RESPONSE['firstName']}
    Should Be Equal As Strings    ${last_name}    ${REGISTRATION_SUCCESS_WITH_DEAD_USER_FULL_DATA_RESPONSE['lastName']}
    Should Be Equal As Strings    ${father_name}    ${REGISTRATION_SUCCESS_WITH_DEAD_USER_FULL_DATA_RESPONSE['fatherName']}
    Should Be Equal As Strings    ${REGISTRATION_RESPONSE['body']['nationalCode']}    ${REGISTRATION_SUCCESS_WITH_DEAD_USER_FULL_DATA_RESPONSE['nationalCode']}
    Should Be Equal As Strings    ${REGISTRATION_RESPONSE['body']['birthDate']}    ${REGISTRATION_SUCCESS_WITH_DEAD_USER_FULL_DATA_RESPONSE['birthDate']}
    Should Be Equal As Strings    ${REGISTRATION_RESPONSE['body']['birthPlace']}    ${REGISTRATION_SUCCESS_WITH_DEAD_USER_FULL_DATA_RESPONSE['birthPlace']}
    Should Be Equal As Strings    ${REGISTRATION_RESPONSE['body']['shenasnameSeri']}    ${REGISTRATION_SUCCESS_WITH_DEAD_USER_FULL_DATA_RESPONSE['shenasnameSeri']}
    Should Be Equal As Strings    ${REGISTRATION_RESPONSE['body']['shenasnameSerial']}    ${REGISTRATION_SUCCESS_WITH_DEAD_USER_FULL_DATA_RESPONSE['shenasnameSerial']}
    Should Be Equal As Strings    ${REGISTRATION_RESPONSE['body']['shenasnameNo']}    ${REGISTRATION_SUCCESS_WITH_DEAD_USER_FULL_DATA_RESPONSE['shenasnameNo']}
    Should Be Equal As Strings    ${REGISTRATION_RESPONSE['body']['birthCertificateInfo']['birthCertificateSerial']}    
    ...    ${REGISTRATION_SUCCESS_WITH_DEAD_USER_FULL_DATA_RESPONSE['birthCertificateInfo']['birthCertificateSerial']}
    Should Be Equal As Strings    ${REGISTRATION_RESPONSE['body']['birthCertificateInfo']['birthCertificateNumber']}    
    ...    ${REGISTRATION_SUCCESS_WITH_DEAD_USER_FULL_DATA_RESPONSE['birthCertificateInfo']['birthCertificateNumber']}
    Should Be Equal As Strings    ${REGISTRATION_RESPONSE['body']['birthCertificateInfo']['birthCertificateSeries']}    
    ...    ${REGISTRATION_SUCCESS_WITH_DEAD_USER_FULL_DATA_RESPONSE['birthCertificateInfo']['birthCertificateSeries']}
    Should Be Equal As Integers    ${REGISTRATION_RESPONSE['body']['deathStatus']}    ${REGISTRATION_SUCCESS_WITH_DEAD_USER_FULL_DATA_RESPONSE['deathStatus']}
    Should Be Equal As Integers    ${REGISTRATION_RESPONSE['body']['gender']}    ${REGISTRATION_SUCCESS_WITH_DEAD_USER_FULL_DATA_RESPONSE['gender']}

We Should See Success Registration With User Identity Data Without Birth Place Field Response

    ${first_name}    Replace Arabic Ye    ${REGISTRATION_RESPONSE['body']['firstName']}
    ${last_name}    Replace Arabic Ye    ${REGISTRATION_RESPONSE['body']['lastName']}
    ${father_name}    Replace Arabic Ye    ${REGISTRATION_RESPONSE['body']['fatherName']}

    Should Be Equal As Strings    ${first_name}    ${REGISTRATION_SUCCESS_WITHOUT_USER_FULL_DATA_RESPONSE['firstName']}
    Should Be Equal As Strings    ${last_name}    ${REGISTRATION_SUCCESS_WITHOUT_USER_FULL_DATA_RESPONSE['lastName']}
    Should Be Equal As Strings    ${father_name}    ${REGISTRATION_SUCCESS_WITHOUT_USER_FULL_DATA_RESPONSE['fatherName']}
    Should Be Equal As Strings    ${REGISTRATION_RESPONSE['body']['nationalCode']}    ${REGISTRATION_SUCCESS_WITHOUT_USER_FULL_DATA_RESPONSE['nationalCode']}
    Should Be Equal As Strings    ${REGISTRATION_RESPONSE['body']['birthDate']}    ${REGISTRATION_SUCCESS_WITHOUT_USER_FULL_DATA_RESPONSE['birthDate']}
    Should Be Equal As Strings    ${REGISTRATION_RESPONSE['body']['birthPlace']}    ${REGISTRATION_SUCCESS_WITHOUT_USER_FULL_DATA_RESPONSE['birthPlace']}
    Should Be Equal As Strings    ${REGISTRATION_RESPONSE['body']['shenasnameSeri']}    ${REGISTRATION_SUCCESS_WITHOUT_USER_FULL_DATA_RESPONSE['shenasnameSeri']}
    Should Be Equal As Strings    ${REGISTRATION_RESPONSE['body']['shenasnameSerial']}    ${REGISTRATION_SUCCESS_WITHOUT_USER_FULL_DATA_RESPONSE['shenasnameSerial']}
    Should Be Equal As Strings    ${REGISTRATION_RESPONSE['body']['shenasnameNo']}    ${REGISTRATION_SUCCESS_WITHOUT_USER_FULL_DATA_RESPONSE['shenasnameNo']}
    Should Be Equal As Strings    ${REGISTRATION_RESPONSE['body']['birthCertificateInfo']['birthCertificateSerial']}    
    ...    ${REGISTRATION_SUCCESS_WITHOUT_USER_FULL_DATA_RESPONSE['birthCertificateInfo']['birthCertificateSerial']}
    Should Be Equal As Strings    ${REGISTRATION_RESPONSE['body']['birthCertificateInfo']['birthCertificateNumber']}    
    ...    ${REGISTRATION_SUCCESS_WITHOUT_USER_FULL_DATA_RESPONSE['birthCertificateInfo']['birthCertificateNumber']}
    Should Be Equal As Strings    ${REGISTRATION_RESPONSE['body']['birthCertificateInfo']['birthCertificateSeries']}    
    ...    ${REGISTRATION_SUCCESS_WITHOUT_USER_FULL_DATA_RESPONSE['birthCertificateInfo']['birthCertificateSeries']}
    Should Be Equal As Integers    ${REGISTRATION_RESPONSE['body']['deathStatus']}    ${REGISTRATION_SUCCESS_WITHOUT_USER_FULL_DATA_RESPONSE['deathStatus']}
    Should Be Equal As Integers    ${REGISTRATION_RESPONSE['body']['gender']}    ${REGISTRATION_SUCCESS_WITHOUT_USER_FULL_DATA_RESPONSE['gender']}

We Should See KYC Identity Not Found In Response

    Dictionaries Should Be Equal    ${REGISTRATION_RESPONSE['body']}    ${KYC_IDENTITY_NOT_FOUND}

We Should See Invalid Parameter In Response

    Dictionaries Should Be Equal    ${REGISTRATION_RESPONSE['body']}    ${INVALID_PARAMETER}

We Should See KYC Bad Response In Response

    Dictionaries Should Be Equal    ${REGISTRATION_RESPONSE['body']}    ${KYC_BAD_RESPONSE}
    
We Should See Invalid Parameter In Response For Setting Provider

    Dictionaries Should Be Equal    ${REGISTRATION_RESULT_RESPONSE['body']}    ${INVALID_PARAMETER_FOR_SETTING_PROVIDER}

We Should See Exception KYC Setting Validation Error

    Dictionaries Should Be Equal    ${REGISTRATION_RESULT_RESPONSE['body']}    ${KYC_SETTING_VALIDATION_ERROR}

We Should See User Identity Data In Database With Fetched From Cache False
    [Arguments]
    ...    ${user_national_code}
    ...    ${provider_type}
    ...    ${provider_name}

    ${national_code}    Convert To String    ${user_national_code}

    &{query}    Create Dictionary
    ...    nationalCode    ${national_code}

    ${sort_value}    Convert To Integer    -1

    @{sort_item}    Create List
    ...    date
    ...    ${sort_value}

    @{sort}    Create List

    Append To List    ${sort}    ${sort_item}

    ${result}    Mongo Db Find One
    ...    ${MONGO_DATA['db_name']}
    ...    ${MONGO_DATA['collection_name']}
    ...    ${query}
    ...    ${sort}

    ${first_name}    Replace Arabic Ye    ${result['body']['audit']['firstName']}
    ${last_name}    Replace Arabic Ye    ${result['body']['audit']['lastName']}
    ${father_name}    Replace Arabic Ye    ${result['body']['audit']['fatherName']}

    Should Be Equal As Strings    ${result['body']['nationalCode']}    ${VALID_PERSON['national_code']}
    Should Be Equal As Strings    ${result['body']['birthDate']}    ${VALID_PERSON['birth_date_timestamp']}
    Should Be Equal As Strings    ${result['body']['status']}    SUCCESS
    Should Be Equal As Strings    ${result['body']['provider']}    ${provider_name}
    Should Be Equal As Strings    ${result['body']['type']}    ${provider_type}
    Should Be True    ${result['body']['glRelay']}
    Should Be True    ${result['body']['strongValidation']}
    Should Be Equal As Strings    ${result['body']['resultStatus']}    SUCCESS
    Should Be Equal As Strings    ${result['body']['audit']['nationalCode']}    ${VALID_PERSON['national_code']}
    Should Be Equal As Strings    ${result['body']['audit']['birthDate']}    ${VALID_PERSON['persian_birth_date']}
    Should Be Equal As Strings    ${first_name}    ${VALID_PERSON_DATA_RESPONSE['firstName']}
    Should Be Equal As Strings    ${last_name}    ${VALID_PERSON_DATA_RESPONSE['lastName']}
    Should Be Equal As Strings    ${father_name}    ${VALID_PERSON_DATA_RESPONSE['fatherName']}
    Should Be Equal As Strings    ${result['body']['audit']['deathStatus']}    ALIVE
    Should Be Equal As Strings    ${result['body']['audit']['gender']}    MALE
    Should Be Equal As Strings    ${result['body']['audit']['birthCertificateNumber']}    ${VALID_PERSON_DATA_RESPONSE['birthCertificateInfo']['birthCertificateNumber']}
    Should Be Equal As Strings    ${result['body']['audit']['birthCertificateSeries']}    ${VALID_PERSON_DATA_RESPONSE['birthCertificateInfo']['birthCertificateSeries']}
    Should Be Equal As Strings    ${result['body']['audit']['birthCertificateSerial']}    ${VALID_PERSON_DATA_RESPONSE['birthCertificateInfo']['birthCertificateSerial']}
    Should Not Be True    ${result['body']['fetchedFromCache']}

We Should See Dead User Identity Data In Database With Fetched From Cache False
    [Arguments]
    ...    ${user_national_code}
    ...    ${provider_type}
    ...    ${provider_name}

    ${national_code}    Convert To String    ${user_national_code}

    &{query}    Create Dictionary
    ...    nationalCode    ${national_code}

    ${sort_value}    Convert To Integer    -1

    @{sort_item}    Create List
    ...    date
    ...    ${sort_value}

    @{sort}    Create List

    Append To List    ${sort}    ${sort_item}

    ${result}    Mongo Db Find One
    ...    ${MONGO_DATA['db_name']}
    ...    ${MONGO_DATA['collection_name']}
    ...    ${query}
    ...    ${sort}

    ${first_name}    Replace Arabic Ye    ${result['body']['audit']['firstName']}
    ${last_name}    Replace Arabic Ye    ${result['body']['audit']['lastName']}
    ${father_name}    Replace Arabic Ye    ${result['body']['audit']['fatherName']}

    Should Be Equal As Strings    ${result['body']['nationalCode']}    ${DEAD_PERSON['national_code']}
    Should Be Equal As Strings    ${result['body']['birthDate']}    ${DEAD_PERSON['birth_date_timestamp']}
    Should Be Equal As Strings    ${result['body']['status']}    SUCCESS
    Should Be Equal As Strings    ${result['body']['provider']}    ${provider_name}
    Should Be Equal As Strings    ${result['body']['type']}    ${provider_type}
    Should Be True    ${result['body']['glRelay']}
    Should Be True    ${result['body']['strongValidation']}
    Should Be Equal As Strings    ${result['body']['resultStatus']}    SUCCESS
    Should Be Equal As Strings    ${result['body']['audit']['nationalCode']}    ${DEAD_PERSON['national_code']}
    Should Be Equal As Strings    ${result['body']['audit']['birthDate']}    ${DEAD_PERSON['persian_birth_date']}
    Should Be Equal As Strings    ${first_name}    ${DEAD_PERSON_DATA_RESPONSE['firstName']}
    Should Be Equal As Strings    ${last_name}    ${DEAD_PERSON_DATA_RESPONSE['lastName']}
    Should Be Equal As Strings    ${father_name}    ${DEAD_PERSON_DATA_RESPONSE['fatherName']}
    Should Be Equal As Strings    ${result['body']['audit']['deathStatus']}    DEAD
    Should Be Equal As Strings    ${result['body']['audit']['gender']}    MALE
    Should Be Equal As Strings    ${result['body']['audit']['birthCertificateNumber']}    ${DEAD_PERSON_DATA_RESPONSE['birthCertificateInfo']['birthCertificateNumber']}
    Should Be Equal As Strings    ${result['body']['audit']['birthCertificateSeries']}    ${DEAD_PERSON_DATA_RESPONSE['birthCertificateInfo']['birthCertificateSeries']}
    Should Be Equal As Strings    ${result['body']['audit']['birthCertificateSerial']}    ${DEAD_PERSON_DATA_RESPONSE['birthCertificateInfo']['birthCertificateSerial']}
    Should Not Be True    ${result['body']['fetchedFromCache']}


We Should See User Identity Data With Birth Place In Database With Fetched From Cache False
    [Arguments]
    ...    ${user_national_code}
    ...    ${provider_type}
    ...    ${provider_name}

    ${national_code}    Convert To String    ${user_national_code}

    &{query}    Create Dictionary
    ...    nationalCode    ${national_code}

    ${sort_value}    Convert To Integer    -1

    @{sort_item}    Create List
    ...    date
    ...    ${sort_value}

    @{sort}    Create List

    Append To List    ${sort}    ${sort_item}

    ${result}    Mongo Db Find One
    ...    ${MONGO_DATA['db_name']}
    ...    ${MONGO_DATA['collection_name']}
    ...    ${query}
    ...    ${sort}

    ${first_name}    Replace Arabic Ye    ${result['body']['audit']['firstName']}
    ${last_name}    Replace Arabic Ye    ${result['body']['audit']['lastName']}
    ${father_name}    Replace Arabic Ye    ${result['body']['audit']['fatherName']}

    Should Be Equal As Strings    ${result['body']['nationalCode']}    ${VALID_PERSON['national_code']}
    Should Be Equal As Strings    ${result['body']['birthDate']}    ${VALID_PERSON['birth_date_timestamp']}
    Should Be Equal As Strings    ${result['body']['status']}    SUCCESS
    Should Be Equal As Strings    ${result['body']['provider']}    ${provider_name}
    Should Be Equal As Strings    ${result['body']['type']}    ${provider_type}
    Should Be True    ${result['body']['glRelay']}
    Should Be True    ${result['body']['strongValidation']}
    Should Be Equal As Strings    ${result['body']['resultStatus']}    SUCCESS
    Should Be Equal As Strings    ${result['body']['audit']['nationalCode']}    ${VALID_PERSON['national_code']}
    Should Be Equal As Strings    ${result['body']['audit']['birthDate']}    ${VALID_PERSON['persian_birth_date']}
    Should Be Equal As Strings    ${first_name}    ${VALID_PERSON_FULL_DATA_RESPONSE['firstName']}
    Should Be Equal As Strings    ${last_name}    ${VALID_PERSON_FULL_DATA_RESPONSE['lastName']}
    Should Be Equal As Strings    ${father_name}    ${VALID_PERSON_FULL_DATA_RESPONSE['fatherName']}
    Should Be Equal As Strings    ${result['body']['audit']['birthPlace']}    ${VALID_PERSON_FULL_DATA_RESPONSE['birthPlace']}
    Should Be Equal As Strings    ${result['body']['audit']['deathStatus']}    ALIVE
    Should Be Equal As Strings    ${result['body']['audit']['gender']}    MALE
    Should Be Equal As Strings    ${result['body']['audit']['birthCertificateNumber']}    ${VALID_PERSON_FULL_DATA_RESPONSE['birthCertificateInfo']['birthCertificateNumber']}
    Should Be Equal As Strings    ${result['body']['audit']['birthCertificateSeries']}    ${VALID_PERSON_FULL_DATA_RESPONSE['birthCertificateInfo']['birthCertificateSeries']}
    Should Be Equal As Strings    ${result['body']['audit']['birthCertificateSerial']}    ${VALID_PERSON_FULL_DATA_RESPONSE['birthCertificateInfo']['birthCertificateSerial']}
    Should Not Be True    ${result['body']['fetchedFromCache']}

We Should See Dead User Identity Data With Birth Place In Database With Fetched From Cache False
    [Arguments]
    ...    ${user_national_code}
    ...    ${provider_type}
    ...    ${provider_name}

    ${national_code}    Convert To String    ${user_national_code}

    &{query}    Create Dictionary
    ...    nationalCode    ${national_code}

    ${sort_value}    Convert To Integer    -1

    @{sort_item}    Create List
    ...    date
    ...    ${sort_value}

    @{sort}    Create List

    Append To List    ${sort}    ${sort_item}

    ${result}    Mongo Db Find One
    ...    ${MONGO_DATA['db_name']}
    ...    ${MONGO_DATA['collection_name']}
    ...    ${query}
    ...    ${sort}

    ${first_name}    Replace Arabic Ye    ${result['body']['audit']['firstName']}
    ${last_name}    Replace Arabic Ye    ${result['body']['audit']['lastName']}
    ${father_name}    Replace Arabic Ye    ${result['body']['audit']['fatherName']}

    Should Be Equal As Strings    ${result['body']['nationalCode']}    ${DEAD_PERSON['national_code']}
    Should Be Equal As Strings    ${result['body']['birthDate']}    ${DEAD_PERSON['birth_date_timestamp']}
    Should Be Equal As Strings    ${result['body']['status']}    SUCCESS
    Should Be Equal As Strings    ${result['body']['provider']}    ${provider_name}
    Should Be Equal As Strings    ${result['body']['type']}    ${provider_type}
    Should Be True    ${result['body']['glRelay']}
    Should Be True    ${result['body']['strongValidation']}
    Should Be Equal As Strings    ${result['body']['resultStatus']}    SUCCESS
    Should Be Equal As Strings    ${result['body']['audit']['nationalCode']}    ${DEAD_PERSON['national_code']}
    Should Be Equal As Strings    ${result['body']['audit']['birthDate']}    ${DEAD_PERSON['persian_birth_date']}
    Should Be Equal As Strings    ${first_name}    ${DEAD_PERSON_FULL_DATA_RESPONSE['firstName']}
    Should Be Equal As Strings    ${last_name}    ${DEAD_PERSON_FULL_DATA_RESPONSE['lastName']}
    Should Be Equal As Strings    ${father_name}    ${DEAD_PERSON_FULL_DATA_RESPONSE['fatherName']}
    Should Be Equal As Strings    ${result['body']['audit']['birthPlace']}    ${DEAD_PERSON_FULL_DATA_RESPONSE['birthPlace']}
    Should Be Equal As Strings    ${result['body']['audit']['deathStatus']}    DEAD
    Should Be Equal As Strings    ${result['body']['audit']['gender']}    MALE
    Should Be Equal As Strings    ${result['body']['audit']['birthCertificateNumber']}    ${DEAD_PERSON_FULL_DATA_RESPONSE['birthCertificateInfo']['birthCertificateNumber']}
    Should Be Equal As Strings    ${result['body']['audit']['birthCertificateSeries']}    ${DEAD_PERSON_FULL_DATA_RESPONSE['birthCertificateInfo']['birthCertificateSeries']}
    Should Be Equal As Strings    ${result['body']['audit']['birthCertificateSerial']}    ${DEAD_PERSON_FULL_DATA_RESPONSE['birthCertificateInfo']['birthCertificateSerial']}
    Should Not Be True    ${result['body']['fetchedFromCache']}



We Should See User Identity Data In Database With Fetched From Cache True
    [Arguments]
    ...    ${user_national_code}
    ...    ${provider_type}
    ...    ${provider_name}

    ${national_code}    Convert To String    ${user_national_code}

    &{query}    Create Dictionary
    ...    nationalCode    ${national_code}

    ${sort_value}    Convert To Integer    -1

    @{sort_item}    Create List
    ...    date
    ...    ${sort_value}

    @{sort}    Create List

    Append To List    ${sort}    ${sort_item}

    ${result}    Mongo Db Find One
    ...    ${MONGO_DATA['db_name']}
    ...    ${MONGO_DATA['collection_name']}
    ...    ${query}
    ...    ${sort}

    ${first_name}    Replace Arabic Ye    ${result['body']['audit']['firstName']}
    ${last_name}    Replace Arabic Ye    ${result['body']['audit']['lastName']}
    ${father_name}    Replace Arabic Ye    ${result['body']['audit']['fatherName']}

    Should Be Equal As Strings    ${result['body']['nationalCode']}    ${VALID_PERSON['national_code']}
    Should Be Equal As Strings    ${result['body']['birthDate']}    ${VALID_PERSON['birth_date_timestamp']}
    Should Be Equal As Strings    ${result['body']['status']}    SUCCESS
    Should Be Equal As Strings    ${result['body']['provider']}    ${provider_name}
    Should Be Equal As Strings    ${result['body']['type']}    ${provider_type}
    Should Be True    ${result['body']['glRelay']}
    Should Not Be True    ${result['body']['strongValidation']}
    Should Be Equal As Strings    ${result['body']['resultStatus']}    SUCCESS
    Should Be Equal As Strings    ${result['body']['audit']['nationalCode']}    ${VALID_PERSON['national_code']}
    Should Be Equal As Strings    ${result['body']['audit']['birthDate']}    ${VALID_PERSON['persian_birth_date']}
    Should Be Equal As Strings    ${first_name}    ${VALID_PERSON_DATA_RESPONSE['firstName']}
    Should Be Equal As Strings    ${last_name}    ${VALID_PERSON_DATA_RESPONSE['lastName']}
    Should Be Equal As Strings    ${father_name}    ${VALID_PERSON_DATA_RESPONSE['fatherName']}
    Should Be Equal As Strings    ${result['body']['audit']['deathStatus']}    ALIVE
    Should Be Equal As Strings    ${result['body']['audit']['gender']}    MALE
    Should Be Equal As Strings    ${result['body']['audit']['birthCertificateNumber']}    ${VALID_PERSON_DATA_RESPONSE['birthCertificateInfo']['birthCertificateNumber']}
    Should Be Equal As Strings    ${result['body']['audit']['birthCertificateSeries']}    ${VALID_PERSON_DATA_RESPONSE['birthCertificateInfo']['birthCertificateSeries']}
    Should Be Equal As Strings    ${result['body']['audit']['birthCertificateSerial']}    ${VALID_PERSON_DATA_RESPONSE['birthCertificateInfo']['birthCertificateSerial']}
    Should Be True    ${result['body']['fetchedFromCache']}

We Should See User Identity Data With Birth Place In Database With Fetched From Cache True
    [Arguments]
    ...    ${user_national_code}
    ...    ${provider_type}
    ...    ${provider_name}

    ${national_code}    Convert To String    ${user_national_code}

    &{query}    Create Dictionary
    ...    nationalCode    ${national_code}

    ${sort_value}    Convert To Integer    -1

    @{sort_item}    Create List
    ...    date
    ...    ${sort_value}

    @{sort}    Create List

    Append To List    ${sort}    ${sort_item}

    ${result}    Mongo Db Find One
    ...    ${MONGO_DATA['db_name']}
    ...    ${MONGO_DATA['collection_name']}
    ...    ${query}
    ...    ${sort}

    ${first_name}    Replace Arabic Ye    ${result['body']['audit']['firstName']}
    ${last_name}    Replace Arabic Ye    ${result['body']['audit']['lastName']}
    ${father_name}    Replace Arabic Ye    ${result['body']['audit']['fatherName']}

    Should Be Equal As Strings    ${result['body']['nationalCode']}    ${VALID_PERSON['national_code']}
    Should Be Equal As Strings    ${result['body']['birthDate']}    ${VALID_PERSON['birth_date_timestamp']}
    Should Be Equal As Strings    ${result['body']['status']}    SUCCESS
    Should Be Equal As Strings    ${result['body']['provider']}    ${provider_name}
    Should Be Equal As Strings    ${result['body']['type']}    ${provider_type}
    Should Be True    ${result['body']['glRelay']}
    Should Not Be True    ${result['body']['strongValidation']}
    Should Be Equal As Strings    ${result['body']['resultStatus']}    SUCCESS
    Should Be Equal As Strings    ${result['body']['audit']['nationalCode']}    ${VALID_PERSON['national_code']}
    Should Be Equal As Strings    ${result['body']['audit']['birthDate']}    ${VALID_PERSON['persian_birth_date']}
    Should Be Equal As Strings    ${first_name}    ${VALID_PERSON_DATA_RESPONSE['firstName']}
    Should Be Equal As Strings    ${last_name}    ${VALID_PERSON_DATA_RESPONSE['lastName']}
    Should Be Equal As Strings    ${father_name}    ${VALID_PERSON_DATA_RESPONSE['fatherName']}
    Should Be Equal As Strings    ${result['body']['audit']['deathStatus']}    ALIVE
    Should Be Equal As Strings    ${result['body']['audit']['gender']}    MALE
    Should Be Equal As Strings    ${result['body']['audit']['birthCertificateNumber']}    ${VALID_PERSON_DATA_RESPONSE['birthCertificateInfo']['birthCertificateNumber']}
    Should Be Equal As Strings    ${result['body']['audit']['birthCertificateSeries']}    ${VALID_PERSON_DATA_RESPONSE['birthCertificateInfo']['birthCertificateSeries']}
    Should Be Equal As Strings    ${result['body']['audit']['birthCertificateSerial']}    ${VALID_PERSON_DATA_RESPONSE['birthCertificateInfo']['birthCertificateSerial']}
    Should Be True    ${result['body']['fetchedFromCache']}

We Should See User Identity Data Without Birth Place In Database With Fetched From Cache False
    [Arguments]
    ...    ${user_national_code}
    ...    ${provider_type}
    ...    ${provider_name}

    ${national_code}    Convert To String    ${user_national_code}

    &{query}    Create Dictionary
    ...    nationalCode    ${national_code}

    ${sort_value}    Convert To Integer    -1

    @{sort_item}    Create List
    ...    date
    ...    ${sort_value}

    @{sort}    Create List

    Append To List    ${sort}    ${sort_item}

    ${result}    Mongo Db Find One
    ...    ${MONGO_DATA['db_name']}
    ...    ${MONGO_DATA['collection_name']}
    ...    ${query}
    ...    ${sort}

    ${first_name}    Replace Arabic Ye    ${result['body']['audit']['firstName']}
    ${last_name}    Replace Arabic Ye    ${result['body']['audit']['lastName']}
    ${father_name}    Replace Arabic Ye    ${result['body']['audit']['fatherName']}

    Should Be Equal As Strings    ${result['body']['nationalCode']}    ${PERSON_FOR_KYC_BAD_RESPONSE['national_code']}
    Should Be Equal As Strings    ${result['body']['birthDate']}    ${PERSON_FOR_KYC_BAD_RESPONSE['birth_date_timestamp']}
    Should Be Equal As Strings    ${result['body']['status']}    SUCCESS
    Should Be Equal As Strings    ${result['body']['provider']}    ${provider_name}
    Should Be Equal As Strings    ${result['body']['type']}    ${provider_type}
    Should Be True    ${result['body']['glRelay']}
    Should Be True    ${result['body']['strongValidation']}
    Should Be Equal As Strings    ${result['body']['resultStatus']}    SUCCESS
    Should Be Equal As Strings    ${result['body']['audit']['nationalCode']}    ${PERSON_FOR_KYC_BAD_RESPONSE['national_code']}
    Should Be Equal As Strings    ${result['body']['audit']['birthDate']}    ${PERSON_FOR_KYC_BAD_RESPONSE['persian_birth_date']}
    Should Be Equal As Strings    ${first_name}    ${PERSON_FOR_KYC_BAD_RESPONSE_FULL_DATA_RESPONSE['firstName']}
    Should Be Equal As Strings    ${last_name}    ${PERSON_FOR_KYC_BAD_RESPONSE_FULL_DATA_RESPONSE['lastName']}
    Should Be Equal As Strings    ${father_name}    ${PERSON_FOR_KYC_BAD_RESPONSE_FULL_DATA_RESPONSE['fatherName']}
    Should Be Empty    ${result['body']['audit']['birthPlace']}
    Should Be Equal As Strings    ${result['body']['audit']['deathStatus']}    ALIVE
    Should Be Equal As Strings    ${result['body']['audit']['gender']}    FEMALE
    Should Be Equal As Strings    ${result['body']['audit']['birthCertificateNumber']}    ${PERSON_FOR_KYC_BAD_RESPONSE_FULL_DATA_RESPONSE['birthCertificateInfo']['birthCertificateNumber']}
    Should Be Equal As Strings    ${result['body']['audit']['birthCertificateSeries']}    ${PERSON_FOR_KYC_BAD_RESPONSE_FULL_DATA_RESPONSE['birthCertificateInfo']['birthCertificateSeries']}
    Should Be Equal As Strings    ${result['body']['audit']['birthCertificateSerial']}    ${PERSON_FOR_KYC_BAD_RESPONSE_FULL_DATA_RESPONSE['birthCertificateInfo']['birthCertificateSerial']}
    Should Not Be True    ${result['body']['fetchedFromCache']}

Set Provider Weight More than 1
    [Arguments]
    ...    ${inquiry_type}
    ...    ${active_auto_weighting}

    @{provider_settings}    Create List
    &{providers_weight}    Create Dictionary
    &{setting_detail}    Create Dictionary
    @{enum_list}    Create List

    IF    ${inquiry_type} == ${PROVIDERS['basic']['type']}
        Append To List    ${enum_list}    1    3    4
    ELSE
        Append To List    ${enum_list}    2    5    6
    END
    

    FOR    ${i}    IN RANGE    0    3
        &{provider}    Create Dictionary    &{EMPTY}
        Set To Dictionary    ${provider}    
        ...    providerName    ${enum_list[${i}]}
        ...    priority    1
        ...    weight    1.1
        ...    active    true
        Append To List    ${provider_settings}    ${provider}
    END
    Set To Dictionary    ${setting_detail}    
    ...    inquiryType    ${inquiry_type}
    ...    providerSettings    ${provider_settings}
    ...    activeAutoWeighting    ${active_auto_weighting}
    ...    minWeightAutoWeighting    ${MIN_WEIGHT_AUTO_WEIGHTING}

    ${REGISTRATION_RESULT_RESPONSE}    POST Admin Kyc Settings Identity Registration Inquiry Provider
    ...    ${MICROSERVICE_SIDE}
    ...    ${setting_detail}

    Set Test Variable    &{REGISTRATION_RESULT_RESPONSE}

Set Provider Weight Less than 1
    [Arguments]
    ...    ${inquiry_type}
    ...    ${active_auto_weighting}

    @{provider_settings}    Create List
    &{providers_weight}    Create Dictionary
    &{setting_detail}    Create Dictionary
    @{enum_list}    Create List

    IF    ${inquiry_type} == ${PROVIDERS['basic']['type']}
        Append To List    ${enum_list}    1    3    4
    ELSE
        Append To List    ${enum_list}    2    5    6
    END
    

    FOR    ${i}    IN RANGE    0    3
        &{provider}    Create Dictionary    &{EMPTY}
        Set To Dictionary    ${provider}    
        ...    providerName    ${enum_list[${i}]}
        ...    priority    1
        ...    weight    0.1
        ...    active    true
        Append To List    ${provider_settings}    ${provider}
    END
    Set To Dictionary    ${setting_detail}    inquiryType    ${inquiry_type}
    Set To Dictionary    ${setting_detail}    providerSettings    ${provider_settings}
    Set To Dictionary    ${setting_detail}    activeAutoWeighting    ${active_auto_weighting}
    Set To Dictionary    ${setting_detail}    minWeightAutoWeighting    ${MIN_WEIGHT_AUTO_WEIGHTING}

    ${REGISTRATION_RESULT_RESPONSE}    POST Admin Kyc Settings Identity Registration Inquiry Provider
    ...    ${MICROSERVICE_SIDE}
    ...    ${setting_detail}

    Set Test Variable    &{REGISTRATION_RESULT_RESPONSE}

Set Provider Weight That Sum Of Them Is Less Than 1
    [Arguments]
    ...    ${inquiry_type}
    ...    ${active_auto_weighting}

    @{provider_settings}    Create List
    &{providers_weight}    Create Dictionary
    &{setting_detail}    Create Dictionary
    @{enum_list}    Create List

    @{sum_list}    Create List    0.01    0.005    0.002    0.003

    IF    ${inquiry_type} == ${PROVIDERS['basic']['type']}
        Append To List    ${enum_list}    1    3    4
    ELSE
        Append To List    ${enum_list}    2    5    6
    END
    

    FOR    ${i}    IN RANGE    0    3
        &{provider}    Create Dictionary    &{EMPTY}
        Set To Dictionary    ${provider}    
        ...    providerName    ${enum_list[${i}]}
        ...    priority    1
        ...    weight    ${sum_list[${i}]}
        ...    active    true
        Append To List    ${provider_settings}    ${provider}
    END
    Set To Dictionary    ${setting_detail}    inquiryType    ${inquiry_type}
    Set To Dictionary    ${setting_detail}    providerSettings    ${provider_settings}
    Set To Dictionary    ${setting_detail}    activeAutoWeighting    ${active_auto_weighting}
    Set To Dictionary    ${setting_detail}    minWeightAutoWeighting    ${MIN_WEIGHT_AUTO_WEIGHTING}

    ${REGISTRATION_RESULT_RESPONSE}    POST Admin Kyc Settings Identity Registration Inquiry Provider
    ...    ${MICROSERVICE_SIDE}
    ...    ${setting_detail}

    Set Test Variable    &{REGISTRATION_RESULT_RESPONSE}

Set Provider Weight That Sum Of Them Is More Than 1
    [Arguments]
    ...    ${inquiry_type}
    ...    ${active_auto_weighting}

    @{provider_settings}    Create List
    &{providers_weight}    Create Dictionary
    &{setting_detail}    Create Dictionary
    @{enum_list}    Create List

    @{sum_list}    Create List    0.5    0.6    0.43    0.73    0.18

    IF    ${inquiry_type} == ${PROVIDERS['basic']['type']}
        Append To List    ${enum_list}    1    3    4
    ELSE
        Append To List    ${enum_list}    2    5    6
    END
    

    FOR    ${i}    IN RANGE    0    3
        &{provider}    Create Dictionary    &{EMPTY}
        Set To Dictionary    ${provider}    
        ...    providerName    ${enum_list[${i}]}
        ...    priority    1
        ...    weight    ${sum_list[${i}]}
        ...    active    true
        Append To List    ${provider_settings}    ${provider}
    END
    Set To Dictionary    ${setting_detail}    inquiryType    ${inquiry_type}
    Set To Dictionary    ${setting_detail}    providerSettings    ${provider_settings}
    Set To Dictionary    ${setting_detail}    activeAutoWeighting    ${active_auto_weighting}
    Set To Dictionary    ${setting_detail}    minWeightAutoWeighting    ${MIN_WEIGHT_AUTO_WEIGHTING}

    ${REGISTRATION_RESULT_RESPONSE}    POST Admin Kyc Settings Identity Registration Inquiry Provider
    ...    ${MICROSERVICE_SIDE}
    ...    ${setting_detail}

    Set Test Variable    &{REGISTRATION_RESULT_RESPONSE}

Set All Providers Weight To 0
    [Arguments]
    ...    ${inquiry_type}
    ...    ${active_auto_weighting}

    @{provider_settings}    Create List
    &{providers_weight}    Create Dictionary
    &{setting_detail}    Create Dictionary
    @{enum_list}    Create List

    IF    ${inquiry_type} == ${PROVIDERS['basic']['type']}
        Append To List    ${enum_list}    1    3    4
    ELSE
        Append To List    ${enum_list}    2    5    6
    END
    

    FOR    ${i}    IN RANGE    0    3
        &{provider}    Create Dictionary    &{EMPTY}
        Set To Dictionary    ${provider}    
        ...    providerName    ${enum_list[${i}]}
        ...    priority    1
        ...    weight    0
        ...    active    true
        Append To List    ${provider_settings}    ${provider}
    END
    Set To Dictionary    ${setting_detail}    inquiryType    ${inquiry_type}
    Set To Dictionary    ${setting_detail}    providerSettings    ${provider_settings}
    Set To Dictionary    ${setting_detail}    activeAutoWeighting    ${active_auto_weighting}
    Set To Dictionary    ${setting_detail}    minWeightAutoWeighting    ${MIN_WEIGHT_AUTO_WEIGHTING}

    ${REGISTRATION_RESULT_RESPONSE}    POST Admin Kyc Settings Identity Registration Inquiry Provider
    ...    ${MICROSERVICE_SIDE}
    ...    ${setting_detail}

    Set Test Variable    &{REGISTRATION_RESULT_RESPONSE}

Set All Providers Active Field To false
    [Arguments]
    ...    ${inquiry_type}
    ...    ${active_auto_weighting}

    @{provider_settings}    Create List
    &{providers_weight}    Create Dictionary
    &{setting_detail}    Create Dictionary
    @{enum_list}    Create List

    IF    ${inquiry_type} == ${PROVIDERS['basic']['type']}
        Append To List    ${enum_list}    1    3    4
    ELSE
        Append To List    ${enum_list}    2    5    6
    END
    

    FOR    ${i}    IN RANGE    0    3
        &{provider}    Create Dictionary    &{EMPTY}
        Set To Dictionary    ${provider}    
        ...    providerName    ${enum_list[${i}]}
        ...    priority    1
        ...    weight    0.1
        ...    active    false
        Append To List    ${provider_settings}    ${provider}
    END
    Set To Dictionary    ${setting_detail}    inquiryType    ${inquiry_type}
    Set To Dictionary    ${setting_detail}    providerSettings    ${provider_settings}
    Set To Dictionary    ${setting_detail}    activeAutoWeighting    ${active_auto_weighting}
    Set To Dictionary    ${setting_detail}    minWeightAutoWeighting    ${MIN_WEIGHT_AUTO_WEIGHTING}

    ${REGISTRATION_RESULT_RESPONSE}    POST Admin Kyc Settings Identity Registration Inquiry Provider
    ...    ${MICROSERVICE_SIDE}
    ...    ${setting_detail}

    Set Test Variable    &{REGISTRATION_RESULT_RESPONSE}