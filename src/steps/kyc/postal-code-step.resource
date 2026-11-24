*** Settings ***
Resource        apis/kyc/admin/get-kyc-settings-address-provider.resource
Resource        apis/kyc/admin/post-kyc-settings-address-provider.resource
Resource        apis/kyc/addresses/postal-code.resource
Resource        services/db/mongo-db-service.resource
Resource        services/backend/auth-service.resource
Variables       data/kyc/postal-code-variables.yml


*** Keywords ***
Get Provider Weight
    [Documentation]    Get provider weights. After test we set this settings again.

    ${result}    GET Admin Kyc Setting Address Provider

    Should Be Equal As Integers    ${result['status_code']}    200

    &{PROVIDERS_SETTINGS}    Create Dictionary
    ...    settingDetail=${result['body']['settingDetail']}
    Set Suite Variable    ${PROVIDERS_SETTINGS}

Post Provider Weight
    [Documentation]    Set provider that we want call address API with it.

    ${result}    POST Admin Kyc Setting Address Provider
    ...    ${MICROSERVICE_SIDE}
    ...    ${PROVIDERS_SETTINGS}

    Should Be Equal As Integers    ${result['status_code']}    200

Set Address Provider
    [Documentation]    Set provider that we want call address API with it.
    [Arguments]    ${index}

    @{providerSettings}    Create List
    &{providers_weight}    Create Dictionary
    &{settingDetail}    Create Dictionary

    FOR    ${i}    IN RANGE    0    3
        &{provider}    Create Dictionary    &{EMPTY}
        Set To Dictionary    ${provider}    providerName    ${i}
        IF    ${i} == ${index}
            Set To Dictionary    ${provider}    weight    1.0
            Append To List    ${providerSettings}    ${provider}
        ELSE
            Set To Dictionary    ${provider}    weight    0.0
            Append To List    ${providerSettings}    ${provider}
        END
    END
    Set To Dictionary    ${settingDetail}    providerSettings    ${providerSettings}
    Set To Dictionary    ${providers_weight}    settingDetail    ${settingDetail}

    ${result}    POST Admin Kyc Setting Address Provider
    ...    ${MICROSERVICE_SIDE}
    ...    ${providers_weight}

    Should Be Equal As Integers    ${result['status_code']}    200

Check DataBase And Delete All Record With This Postal Code
    [Documentation]    In this step we check '${POSTAL_CODE}' in database. If postal code exist we delete it.

    ${postal_code}    Convert To String    ${POSTAL_CODE}

    &{query}    Create Dictionary    &{EMPTY}
    Set To Dictionary    ${query}    postalCode    ${postal_code}

    ${sort_value}    Convert To Integer    -1

    @{sort_item}    Create List
    ...    date
    ...    ${sort_value}

    @{sort}    Create List

    Append To List    ${sort}    ${sort_item}

    ${get_data_result}    Mongo Db Find
    ...    ${POSTAL_CODE_MONGO_DATA['db_name']}
    ...    ${POSTAL_CODE_MONGO_DATA['collection_name']}
    ...    ${query}
    ...    ${sort}

    ${get_data_result}    Set Variable    ${get_data_result['body']}

    ${delete_data_result}    Mongo Db Delete Many
    ...    ${POSTAL_CODE_MONGO_DATA['db_name']}
    ...    ${POSTAL_CODE_MONGO_DATA['collection_name']}
    ...    ${query}

    ${delete_data_result}    Set Variable    ${delete_data_result['body']}
    ${deleted_count}    Set Variable    ${delete_data_result['deleted_count']}

    ${length_get_data_result}    Get Length    ${get_data_result}
    Should Be Equal    ${deleted_count}    ${length_get_data_result}

Get Inquiry From Address
    [Arguments]    ${postal_code}

    &{ADDRESS_RESPONSE}    GET Addresses Postal Code
    ...    ${MICROSERVICE_SIDE}
    ...    ${REQUESTER_APP_NAME}
    ...    ${USER_ID}
    ...    ${postal_code}

    Set Test Variable    &{ADDRESS_RESPONSE}

Get Inquiry From Address AFter Set Jibit Provider
    [Arguments]    ${postal_code}

    Set Address Provider    ${JIBIT}
    Get Inquiry From Address    ${postal_code}
    We Should See Success Result In Response
    We Should See Address Detail Of Postal Code In Response For Jibit Provider
    We Should See Address Detail In Database For Jibit Provider

We Should See Success Result In Response
    Should Be Equal
    ...    ${ADDRESS_RESPONSE['body']['result']}
    ...    ${SUCCESS_RESPONSE['result']}

We Should See Address Detail Of Postal Code In Response For Jibit Provider
    Should Be Equal
    ...    ${ADDRESS_RESPONSE['body']['address']}
    ...    ${ADDRESS_SUCCESS_RESPONSE_FOR_JIBIT['address']}

We Should See Address Detail In Database For Jibit Provider
    ${false_deleted}    Convert To Boolean    false

    ${postal_code}    Convert To String    ${POSTAL_CODE}

    &{query}    Create Dictionary
    ...    postalCode    ${postal_code}
    ...    fetchedFromCache    ${false_deleted}

    ${sort_value}    Convert To Integer    -1

    @{sort_item}    Create List
    ...    date
    ...    ${sort_value}

    @{sort}    Create List

    Append To List    ${sort}    ${sort_item}

    ${result}    Mongo Db Find One
    ...    ${POSTAL_CODE_MONGO_DATA['db_name']}
    ...    ${POSTAL_CODE_MONGO_DATA['collection_name']}
    ...    ${query}
    ...    ${sort}

    Should Be Equal As Strings    ${result['body']['postalCode']}    ${POSTAL_CODE}
    Should Be Equal As Strings    ${result['body']['status']}    SUCCESS
    Should Be Equal As Strings    ${result['body']['provider']}    JIBIT
    Should Be Equal As Strings    ${result['body']['resultStatus']}    SUCCESS
    Should Be Equal As Strings    ${result['body']['audit']['postalCode']}    ${POSTAL_CODE}
    Should Be Equal As Strings
    ...    ${result['body']['audit']['province']}
    ...    ${ADDRESS_SUCCESS_RESPONSE_FOR_JIBIT['address']['province']}
    Should Be Equal As Strings
    ...    ${result['body']['audit']['townShip']}
    ...    ${ADDRESS_SUCCESS_RESPONSE_FOR_JIBIT['address']['townShip']}
    Should Be Equal As Strings
    ...    ${result['body']['audit']['district']}
    ...    ${ADDRESS_SUCCESS_RESPONSE_FOR_JIBIT['address']['district']}
    Should Be Equal As Strings
    ...    ${result['body']['audit']['localityName']}
    ...    ${ADDRESS_SUCCESS_RESPONSE_FOR_JIBIT['address']['localityName']}
    Should Be Equal As Strings
    ...    ${result['body']['audit']['subLocality']}
    ...    ${ADDRESS_SUCCESS_RESPONSE_FOR_JIBIT['address']['subLocality']}
    Should Be Equal As Strings
    ...    ${result['body']['audit']['street']}
    ...    ${ADDRESS_SUCCESS_RESPONSE_FOR_JIBIT['address']['street']}
    Should Be Equal As Strings
    ...    ${result['body']['audit']['street2']}
    ...    ${ADDRESS_SUCCESS_RESPONSE_FOR_JIBIT['address']['street2']}
    Should Be Equal As Strings
    ...    ${result['body']['audit']['houseNo']}
    ...    ${ADDRESS_SUCCESS_RESPONSE_FOR_JIBIT['address']['houseNo']}
    ${house_no_str}    Convert To Number    ${ADDRESS_SUCCESS_RESPONSE_FOR_JIBIT['address']['houseNumber']}
    ${house_no_str}    Convert To String    ${house_no_str}
    Should Be Equal As Strings    ${result['body']['audit']['houseNoStr']}    ${house_no_str}
    Should Be Equal As Strings
    ...    ${result['body']['audit']['floor']}
    ...    ${ADDRESS_SUCCESS_RESPONSE_FOR_JIBIT['address']['floor']}

We Should See Address Detail Of Postal Code In Response For Sitaad Provider
    Should Be Equal
    ...    ${ADDRESS_RESPONSE['body']['address']}
    ...    ${ADDRESS_SUCCESS_RESPONSE_FOR_SITAAD['address']}

We Should See Address Detail In Database For Sitaad Provider
    ${false_deleted}    Convert To Boolean    false

    ${postal_code}    Convert To String    ${POSTAL_CODE}

    &{query}    Create Dictionary
    ...    postalCode    ${postal_code}
    ...    fetchedFromCache    ${false_deleted}

    ${sort_value}    Convert To Integer    -1

    @{sort_item}    Create List
    ...    date
    ...    ${sort_value}

    @{sort}    Create List

    Append To List    ${sort}    ${sort_item}

    ${result}    Mongo Db Find One
    ...    ${POSTAL_CODE_MONGO_DATA['db_name']}
    ...    ${POSTAL_CODE_MONGO_DATA['collection_name']}
    ...    ${query}
    ...    ${sort}

    Should Be Equal As Strings    ${result['body']['postalCode']}    ${POSTAL_CODE}
    Should Be Equal As Strings    ${result['body']['status']}    SUCCESS
    Should Be Equal As Strings    ${result['body']['provider']}    SITAAD
    Should Be Equal As Strings    ${result['body']['resultStatus']}    SUCCESS
    Should Be Equal As Strings    ${result['body']['audit']['postalCode']}    ${POSTAL_CODE}
    Should Be Equal As Strings
    ...    ${result['body']['audit']['province']}
    ...    ${ADDRESS_SUCCESS_RESPONSE_FOR_SITAAD['address']['province']}
    Should Be Equal As Strings
    ...    ${result['body']['audit']['townShip']}
    ...    ${ADDRESS_SUCCESS_RESPONSE_FOR_SITAAD['address']['townShip']}
    Should Be Equal As Strings
    ...    ${result['body']['audit']['district']}
    ...    ${ADDRESS_SUCCESS_RESPONSE_FOR_SITAAD['address']['district']}
    Should Be Equal As Strings
    ...    ${result['body']['audit']['village']}
    ...    ${ADDRESS_SUCCESS_RESPONSE_FOR_SITAAD['address']['village']}
    Should Be Equal As Strings
    ...    ${result['body']['audit']['localityName']}
    ...    ${ADDRESS_SUCCESS_RESPONSE_FOR_SITAAD['address']['localityName']}
    Should Be Equal As Integers
    ...    ${result['body']['audit']['localityCode']}
    ...    ${ADDRESS_SUCCESS_RESPONSE_FOR_SITAAD['address']['localityCode']}
    Should Be Equal As Strings
    ...    ${result['body']['audit']['subLocality']}
    ...    ${ADDRESS_SUCCESS_RESPONSE_FOR_SITAAD['address']['subLocality']}
    Should Be Equal As Strings
    ...    ${result['body']['audit']['street']}
    ...    ${ADDRESS_SUCCESS_RESPONSE_FOR_SITAAD['address']['street']}
    Should Be Equal As Strings
    ...    ${result['body']['audit']['street2']}
    ...    ${ADDRESS_SUCCESS_RESPONSE_FOR_SITAAD['address']['street2']}
    ${house_no_str}    Convert To Number    ${ADDRESS_SUCCESS_RESPONSE_FOR_SITAAD['address']['houseNumber']}
    ${house_no_str}    Convert To String    ${house_no_str}
    Should Be Equal As Strings    ${result['body']['audit']['houseNo']}    ${house_no_str}
    Should Be Equal As Strings
    ...    ${result['body']['audit']['floor']}
    ...    ${ADDRESS_SUCCESS_RESPONSE_FOR_SITAAD['address']['floor']}
    Should Be Equal As Strings
    ...    ${result['body']['audit']['buildingName']}
    ...    ${ADDRESS_SUCCESS_RESPONSE_FOR_SITAAD['address']['buildingName']}
    Should Be Equal As Strings
    ...    ${result['body']['audit']['description']}
    ...    ${ADDRESS_SUCCESS_RESPONSE_FOR_SITAAD['address']['description']}
    Should Be Equal As Strings
    ...    ${result['body']['audit']['sideFloor']}
    ...    ${ADDRESS_SUCCESS_RESPONSE_FOR_SITAAD['address']['sideFloor']}

We Should See KYC Identity Not Found Result In Response
    Should Be Equal
    ...    ${ADDRESS_RESPONSE['body']}
    ...    ${KYC_IDENTITY_NOT_FOUND}

We Should See Address Failure Result For Jibit In Database
    ${false_deleted}    Convert To Boolean    false

    ${postal_code}    Convert To String    ${WRONG_POSTAL_CODE}

    &{query}    Create Dictionary
    ...    postalCode    ${postal_code}
    ...    fetchedFromCache    ${false_deleted}

    ${sort_value}    Convert To Integer    -1

    @{sort_item}    Create List
    ...    date
    ...    ${sort_value}

    @{sort}    Create List

    Append To List    ${sort}    ${sort_item}

    ${result}    Mongo Db Find One
    ...    ${POSTAL_CODE_MONGO_DATA['db_name']}
    ...    ${POSTAL_CODE_MONGO_DATA['collection_name']}
    ...    ${query}
    ...    ${sort}

    Should Be Equal As Strings    ${result['body']['postalCode']}    ${POSTAL_CODE}
    Should Be Equal As Strings    ${result['body']['status']}    FAILURE
    Should Be Equal As Strings    ${result['body']['provider']}    JIBIT
    Should Be Equal As Strings    ${result['body']['resultStatus']}    KYC_IDENTITY_NOT_FOUND

We Should See Address Failure Result For Sitaad In Database
    ${false_deleted}    Convert To Boolean    false

    ${postal_code}    Convert To String    ${WRONG_POSTAL_CODE}

    &{query}    Create Dictionary
    ...    postalCode    ${postal_code}
    ...    fetchedFromCache    ${false_deleted}

    ${sort_value}    Convert To Integer    -1

    @{sort_item}    Create List
    ...    date
    ...    ${sort_value}

    @{sort}    Create List

    Append To List    ${sort}    ${sort_item}

    ${result}    Mongo Db Find One
    ...    ${POSTAL_CODE_MONGO_DATA['db_name']}
    ...    ${POSTAL_CODE_MONGO_DATA['collection_name']}
    ...    ${query}
    ...    ${sort}

    Should Be Equal As Strings    ${result['body']['postalCode']}    ${POSTAL_CODE}
    Should Be Equal As Strings    ${result['body']['status']}    FAILURE
    Should Be Equal As Strings    ${result['body']['provider']}    SITAAD
    Should Be Equal As Strings    ${result['body']['resultStatus']}    KYC_IDENTITY_NOT_FOUND

We Should See Invalid Parameter Result In Response
    Should Be Equal
    ...    ${ADDRESS_RESPONSE['body']}
    ...    ${INVALID_PARAMETER}

We Should See Address Detail In Database For Jibit Provider With Fetched From Cache True
    ${postal_code}    Convert To String    ${POSTAL_CODE}

    &{query}    Create Dictionary
    ...    postalCode    ${postal_code}

    ${sort_value}    Convert To Integer    -1

    @{sort_item}    Create List
    ...    date
    ...    ${sort_value}

    @{sort}    Create List

    Append To List    ${sort}    ${sort_item}

    ${result}    Mongo Db Find One
    ...    ${POSTAL_CODE_MONGO_DATA['db_name']}
    ...    ${POSTAL_CODE_MONGO_DATA['collection_name']}
    ...    ${query}
    ...    ${sort}

    Should Be Equal As Strings    ${result['body']['postalCode']}    ${POSTAL_CODE}
    Should Be Equal As Strings    ${result['body']['status']}    SUCCESS
    Should Be Equal As Strings    ${result['body']['provider']}    JIBIT
    Should Be Equal As Strings    ${result['body']['resultStatus']}    SUCCESS
    Should Be True    ${result['body']['fetchedFromCache']}
    Should Be Equal As Strings    ${result['body']['audit']['postalCode']}    ${POSTAL_CODE}
    Should Be Equal As Strings
    ...    ${result['body']['audit']['province']}
    ...    ${ADDRESS_SUCCESS_RESPONSE_FOR_JIBIT['address']['province']}
    Should Be Equal As Strings
    ...    ${result['body']['audit']['townShip']}
    ...    ${ADDRESS_SUCCESS_RESPONSE_FOR_JIBIT['address']['townShip']}
    Should Be Equal As Strings
    ...    ${result['body']['audit']['district']}
    ...    ${ADDRESS_SUCCESS_RESPONSE_FOR_JIBIT['address']['district']}
    Should Be Equal As Strings
    ...    ${result['body']['audit']['localityName']}
    ...    ${ADDRESS_SUCCESS_RESPONSE_FOR_JIBIT['address']['localityName']}
    Should Be Equal As Strings
    ...    ${result['body']['audit']['subLocality']}
    ...    ${ADDRESS_SUCCESS_RESPONSE_FOR_JIBIT['address']['subLocality']}
    Should Be Equal As Strings
    ...    ${result['body']['audit']['street']}
    ...    ${ADDRESS_SUCCESS_RESPONSE_FOR_JIBIT['address']['street']}
    Should Be Equal As Strings
    ...    ${result['body']['audit']['street2']}
    ...    ${ADDRESS_SUCCESS_RESPONSE_FOR_JIBIT['address']['street2']}
    Should Be Equal As Strings
    ...    ${result['body']['audit']['houseNo']}
    ...    ${ADDRESS_SUCCESS_RESPONSE_FOR_JIBIT['address']['houseNo']}
    ${house_no_str}    Convert To Number    ${ADDRESS_SUCCESS_RESPONSE_FOR_JIBIT['address']['houseNumber']}
    ${house_no_str}    Convert To String    ${house_no_str}
    Should Be Equal As Strings    ${result['body']['audit']['houseNoStr']}    ${house_no_str}
    Should Be Equal As Strings
    ...    ${result['body']['audit']['floor']}
    ...    ${ADDRESS_SUCCESS_RESPONSE_FOR_JIBIT['address']['floor']}

Set Provider Weight More than 1
    @{providerSettings}    Create List
    &{providers_weight}    Create Dictionary
    &{settingDetail}    Create Dictionary

    FOR    ${i}    IN RANGE    0    3
        &{provider}    Create Dictionary    &{EMPTY}
        Set To Dictionary    ${provider}    providerName    ${i}
        Set To Dictionary    ${provider}    weight    1.1
        Append To List    ${providerSettings}    ${provider}
    END
    Set To Dictionary    ${settingDetail}    providerSettings    ${providerSettings}
    Set To Dictionary    ${providers_weight}    settingDetail    ${settingDetail}

    ${result}    POST Admin Kyc Setting Address Provider
    ...    ${MICROSERVICE_SIDE}
    ...    ${providers_weight}

    Should Be Equal As Integers    ${result['status_code']}    422

    ${PROVIDER_RESPONSE}    Set Variable
    Set Test Variable    ${PROVIDER_RESPONSE}    ${result}

We Should See Exception Invalid Parameters
    Dictionaries Should Be Equal    ${PROVIDER_RESPONSE['body']}    ${INVALID_PARAMETER_FOR_PROVIDER_SETIINGS}

Set Provider Weight Less than 1
    @{providerSettings}    Create List
    &{providers_weight}    Create Dictionary
    &{settingDetail}    Create Dictionary

    FOR    ${i}    IN RANGE    0    3
        &{provider}    Create Dictionary    &{EMPTY}
        Set To Dictionary    ${provider}    providerName    ${i}
        Set To Dictionary    ${provider}    weight    0.1
        Append To List    ${providerSettings}    ${provider}
    END
    Set To Dictionary    ${settingDetail}    providerSettings    ${providerSettings}
    Set To Dictionary    ${providers_weight}    settingDetail    ${settingDetail}

    ${result}    POST Admin Kyc Setting Address Provider
    ...    ${MICROSERVICE_SIDE}
    ...    ${providers_weight}

    Should Be Equal As Integers    ${result['status_code']}    422

    ${PROVIDER_RESPONSE}    Set Variable
    Set Test Variable    ${PROVIDER_RESPONSE}    ${result}

We Should See Exception Kyc Setting Validation Error
    Dictionaries Should Be Equal    ${PROVIDER_RESPONSE['body']}    ${KYC_SETTING_VALIDATION_ERROR}

Set Provider Weight That Sum Of Them Is Less Than 1
    @{sum_list}    Create List    0.01    0.02    0.03

    @{providerSettings}    Create List
    &{providers_weight}    Create Dictionary
    &{settingDetail}    Create Dictionary

    FOR    ${i}    IN RANGE    0    3
        &{provider}    Create Dictionary    &{EMPTY}
        Set To Dictionary    ${provider}    providerName    ${i}
        Set To Dictionary    ${provider}    weight    ${sum_list[${i}]}
        Append To List    ${providerSettings}    ${provider}
    END
    Set To Dictionary    ${settingDetail}    providerSettings    ${providerSettings}
    Set To Dictionary    ${providers_weight}    settingDetail    ${settingDetail}

    ${result}    POST Admin Kyc Setting Address Provider
    ...    ${MICROSERVICE_SIDE}
    ...    ${providers_weight}

    Should Be Equal As Integers    ${result['status_code']}    422

    ${PROVIDER_RESPONSE}    Set Variable
    Set Test Variable    ${PROVIDER_RESPONSE}    ${result}

Set Provider Weight That Sum Of Them Is More Than 1
    @{sum_list}    Create List    0.2    0.7    0.4

    @{providerSettings}    Create List
    &{providers_weight}    Create Dictionary
    &{settingDetail}    Create Dictionary

    FOR    ${i}    IN RANGE    0    3
        &{provider}    Create Dictionary    &{EMPTY}
        Set To Dictionary    ${provider}    providerName    ${i}
        Set To Dictionary    ${provider}    weight    ${sum_list[${i}]}
        Append To List    ${providerSettings}    ${provider}
    END
    Set To Dictionary    ${settingDetail}    providerSettings    ${providerSettings}
    Set To Dictionary    ${providers_weight}    settingDetail    ${settingDetail}

    ${result}    POST Admin Kyc Setting Address Provider
    ...    ${MICROSERVICE_SIDE}
    ...    ${providers_weight}

    Should Be Equal As Integers    ${result['status_code']}    422

    ${PROVIDER_RESPONSE}    Set Variable
    Set Test Variable    ${PROVIDER_RESPONSE}    ${result}

Set All Providers Weight To 0
    @{providerSettings}    Create List
    &{providers_weight}    Create Dictionary
    &{settingDetail}    Create Dictionary

    FOR    ${i}    IN RANGE    0    3
        &{provider}    Create Dictionary    &{EMPTY}
        Set To Dictionary    ${provider}    providerName    ${i}
        Set To Dictionary    ${provider}    weight    0.0
        Append To List    ${providerSettings}    ${provider}
    END
    Set To Dictionary    ${settingDetail}    providerSettings    ${providerSettings}
    Set To Dictionary    ${providers_weight}    settingDetail    ${settingDetail}

    ${result}    POST Admin Kyc Setting Address Provider
    ...    ${MICROSERVICE_SIDE}
    ...    ${providers_weight}

    Should Be Equal As Integers    ${result['status_code']}    422

    ${PROVIDER_RESPONSE}    Set Variable
    Set Test Variable    ${PROVIDER_RESPONSE}    ${result}
