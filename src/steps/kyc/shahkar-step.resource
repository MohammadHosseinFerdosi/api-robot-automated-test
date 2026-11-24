*** Settings ***
Resource        apis/kyc/kyc/cell-number-inquiry.resource
Resource        apis/kyc/admin/post-kyc-settings-shahkar-provider-search.resource
Resource        apis/kyc/admin/post-kyc-settings-shahkar-provider.resource
Resource        services/db/mongo-db-service.resource
Resource        services/backend/auth-service.resource
Variables       data/kyc/shahkar-variables.yml


*** Keywords ***
Check DataBase And Delete All Record With This National Code
    [Documentation]    In this step we check '${NATIONAL_CODE}' in database. If national code exist we delete it.

    ${national_code}    Convert To String    ${NATIONAL_CODE}

    &{query}    Create Dictionary    &{EMPTY}
    Set To Dictionary    ${query}    user.nationalCode    ${national_code}

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

Get Inquiry From Shahkar
    [Documentation]    Call shahkar inquiry API with Post '${body}' and '${MICROSERVICE_SIDE}' as '${api_call_side}' and '${REQUESTER_APP_NAME}'
    ...    as 'Requester-App-Name'.
    ...    We get result as a dictionary and put them in '${SHAHKAR_RESPONSE}'.
    [Arguments]    ${cell_number}

    &{SHAHKAR_RESPONSE}    POST Kyc Cell Number Inquiry
    ...    ${MICROSERVICE_SIDE}
    ...    ${REQUESTER_APP_NAME}
    ...    ${NATIONAL_CODE}
    ...    ${cell_number}

    Set Test Variable    &{SHAHKAR_RESPONSE}

    Should Be Equal As Integers    ${SHAHKAR_RESPONSE['status_code']}    200

Get Inquiry From Shahkar Twice
    [Arguments]    ${cell_number}

    Get Inquiry From Shahkar    ${cell_number}
    Get Inquiry From Shahkar    ${cell_number}

Shahkar Response Should Be Verified
    [Documentation]    Check response and result of shahkar inquiry API. It should be true

    Dictionaries Should Be Equal    ${SHAHKAR_RESPONSE['body']}    ${TRUE_SHAHKAR_RESPONSE}

Shahkar Response Should Be Unverified
    [Documentation]    Check response and result of shahkar inquiry API. It should be false

    Dictionaries Should Be Equal    ${SHAHKAR_RESPONSE['body']}    ${FAIL_SHAHKAR_RESPONSE}

Get Inquiry Should Read From Cache
    [Documentation]    In this step we check '${cell_number}' cache field in database. 'fetchedFromCache' field should be true.
    [Arguments]    ${cell_number}

    ${cell_number}    Convert To String    ${cell_number}

    &{query}    Create Dictionary    &{EMPTY}
    Set To Dictionary    ${query}    user.cellNumber    ${cell_number}

    ${result}    Mongo Db Find
    ...    ${MONGO_DATA['db_name']}
    ...    ${MONGO_DATA['collection_name']}
    ...    ${query}

    ${result}    Set Variable    ${result['body']}

    Should Be True    ${result[-1]['fetchedFromCache']}

Set Shahkar Provider
    [Documentation]    Set provider that we want call shahkar API with it.
    [Arguments]
    ...    ${active_auto_weighting}
    ...    ${index}

    @{providerSettings}    Create List
    &{providers_weight}    Create Dictionary
    &{settingDetail}    Create Dictionary

    FOR    ${i}    IN RANGE    0    8
        &{provider}    Create Dictionary    &{EMPTY}
        Set To Dictionary    ${provider}    providerName    ${i}
        IF    ${i} == ${index}
            Set To Dictionary    ${provider}    weight    1.0
            ...    active    true
            Append To List    ${providerSettings}    ${provider}
        ELSE
            Set To Dictionary    ${provider}    weight    0.0
            ...    active    false
            Append To List    ${providerSettings}    ${provider}
        END
    END
    Set To Dictionary    ${settingDetail}    providerSettings    ${providerSettings}
    Set To Dictionary    ${settingDetail}    activeAutoWeighting    ${active_auto_weighting}
    Set To Dictionary    ${settingDetail}    minWeightAutoWeighting    ${MIN_WEIGHT_AUTO_WEIGHTING}
    Set To Dictionary    ${providers_weight}    settingDetail    ${settingDetail}

    ${result}    POST Admin Kyc Setting Shahkar Provider
    ...    ${MICROSERVICE_SIDE}
    ...    ${providers_weight}

    Should Be Equal As Integers    ${result['status_code']}    200

Get Provider Weight
    [Documentation]    Get provider weights. After test we set this settings again.

    ${result}    POST Admin Kyc Setting Shahkar Provider Search
    ...    ${MICROSERVICE_SIDE}

    Should Be Equal As Integers    ${result['status_code']}    200

    &{PROVIDERS_SETTINGS}    Create Dictionary
    ...    settingDetail=${result['body']['settingDetail']}
    Set Suite Variable    ${PROVIDERS_SETTINGS}

Post Provider Weight
    [Documentation]    Set provider that we want call shahkar API with it.

    ${result}    POST Admin Kyc Setting Shahkar Provider
    ...    ${MICROSERVICE_SIDE}
    ...    ${PROVIDERS_SETTINGS}

    Should Be Equal As Integers    ${result['status_code']}    200

Set Provider Weight More than 1
    [Documentation]    Set weight of providers more than 1 for shahkar inquiry.
    [Arguments]
    ...    ${active_auto_weighting}

    @{providerSettings}    Create List
    &{providers_weight}    Create Dictionary
    &{settingDetail}    Create Dictionary

    FOR    ${i}    IN RANGE    0    8
        &{provider}    Create Dictionary    &{EMPTY}
        Set To Dictionary    ${provider}    providerName    ${i}
        Set To Dictionary    ${provider}    weight    1.1
        ...    active    true
        Append To List    ${providerSettings}    ${provider}
    END
    Set To Dictionary    ${settingDetail}    providerSettings    ${providerSettings}
    Set To Dictionary    ${providers_weight}    settingDetail    ${settingDetail}
    Set To Dictionary    ${providers_weight}    activeAutoWeighting    ${active_auto_weighting}
    Set To Dictionary    ${providers_weight}    minWeightAutoWeighting    ${MIN_WEIGHT_AUTO_WEIGHTING}

    ${result}    POST Admin Kyc Setting Shahkar Provider
    ...    ${MICROSERVICE_SIDE}
    ...    ${providers_weight}

    Should Be Equal As Integers    ${result['status_code']}    422

    ${PROVIDER_RESPONSE}    Set Variable
    Set Test Variable    ${PROVIDER_RESPONSE}    ${result}

Set Provider Weight Less than 1
    [Documentation]    Set weight of providers less than 1 for shahkar inquiry.
    [Arguments]
    ...    ${active_auto_weighting}

    @{providerSettings}    Create List
    &{providers_weight}    Create Dictionary
    &{settingDetail}    Create Dictionary

    FOR    ${i}    IN RANGE    0    8
        &{provider}    Create Dictionary    &{EMPTY}
        Set To Dictionary    ${provider}    providerName    ${i}
        Set To Dictionary    ${provider}    weight    0.1
        ...    active    true
        Append To List    ${providerSettings}    ${provider}
    END
    Set To Dictionary    ${settingDetail}    providerSettings    ${providerSettings}
    Set To Dictionary    ${providers_weight}    settingDetail    ${settingDetail}
    Set To Dictionary    ${providers_weight}    activeAutoWeighting    ${active_auto_weighting}
    Set To Dictionary    ${providers_weight}    minWeightAutoWeighting    ${MIN_WEIGHT_AUTO_WEIGHTING}

    ${result}    POST Admin Kyc Setting Shahkar Provider
    ...    ${MICROSERVICE_SIDE}
    ...    ${providers_weight}

    Should Be Equal As Integers    ${result['status_code']}    422

    ${PROVIDER_RESPONSE}    Set Variable
    Set Test Variable    ${PROVIDER_RESPONSE}    ${result}

Set Provider Weight That Sum Of Them Is Less Than 1
    [Documentation]    Set weight of providers that sum of weights less than 1 for shahkar inquiry.
    [Arguments]
    ...    ${active_auto_weighting}

    @{sum_list}    Create List    0.01    0.02    0.03    0.04    0.005    0.002    0.003    0.08

    @{providerSettings}    Create List
    &{providers_weight}    Create Dictionary
    &{settingDetail}    Create Dictionary

    FOR    ${i}    IN RANGE    0    8
        &{provider}    Create Dictionary    &{EMPTY}
        Set To Dictionary    ${provider}    providerName    ${i}
        Set To Dictionary    ${provider}    weight    ${sum_list[${i}]}
        ...    active    true
        Append To List    ${providerSettings}    ${provider}
    END
    Set To Dictionary    ${settingDetail}    providerSettings    ${providerSettings}
    Set To Dictionary    ${providers_weight}    settingDetail    ${settingDetail}
    Set To Dictionary    ${providers_weight}    activeAutoWeighting    ${active_auto_weighting}
    Set To Dictionary    ${providers_weight}    minWeightAutoWeighting    ${MIN_WEIGHT_AUTO_WEIGHTING}

    ${result}    POST Admin Kyc Setting Shahkar Provider
    ...    ${MICROSERVICE_SIDE}
    ...    ${providers_weight}

    Should Be Equal As Integers    ${result['status_code']}    422

    ${PROVIDER_RESPONSE}    Set Variable
    Set Test Variable    ${PROVIDER_RESPONSE}    ${result}

Set Provider Weight That Sum Of Them Is More Than 1
    [Documentation]    Set weight of providers that sum of weights more than 1 for shahkar inquiry.
    [Arguments]
    ...    ${active_auto_weighting}

    @{sum_list}    Create List    0.2    0.3    0.4    0.5    0.6    0.43    0.73    0.18

    @{providerSettings}    Create List
    &{providers_weight}    Create Dictionary
    &{settingDetail}    Create Dictionary

    FOR    ${i}    IN RANGE    0    8
        &{provider}    Create Dictionary    &{EMPTY}
        Set To Dictionary    ${provider}    providerName    ${i}
        Set To Dictionary    ${provider}    weight    ${sum_list[${i}]}
        ...    active    true
        Append To List    ${providerSettings}    ${provider}
    END
    Set To Dictionary    ${settingDetail}    providerSettings    ${providerSettings}
    Set To Dictionary    ${providers_weight}    settingDetail    ${settingDetail}
    Set To Dictionary    ${providers_weight}    activeAutoWeighting    ${active_auto_weighting}
    Set To Dictionary    ${providers_weight}    minWeightAutoWeighting    ${MIN_WEIGHT_AUTO_WEIGHTING}

    ${result}    POST Admin Kyc Setting Shahkar Provider
    ...    ${MICROSERVICE_SIDE}
    ...    ${providers_weight}

    Should Be Equal As Integers    ${result['status_code']}    422

    ${PROVIDER_RESPONSE}    Set Variable
    Set Test Variable    ${PROVIDER_RESPONSE}    ${result}

Set All Providers Weight To 0
    [Documentation]    Set weight of providers 0.
    [Arguments]
    ...    ${active_auto_weighting}

    @{providerSettings}    Create List
    &{providers_weight}    Create Dictionary
    &{settingDetail}    Create Dictionary

    FOR    ${i}    IN RANGE    0    8
        &{provider}    Create Dictionary    &{EMPTY}
        Set To Dictionary    ${provider}    providerName    ${i}
        Set To Dictionary    ${provider}    weight    0.0
        ...    active    true
        Append To List    ${providerSettings}    ${provider}
    END
    Set To Dictionary    ${settingDetail}    providerSettings    ${providerSettings}
    Set To Dictionary    ${providers_weight}    settingDetail    ${settingDetail}
    Set To Dictionary    ${providers_weight}    activeAutoWeighting    ${active_auto_weighting}
    Set To Dictionary    ${providers_weight}    minWeightAutoWeighting    ${MIN_WEIGHT_AUTO_WEIGHTING}

    ${result}    POST Admin Kyc Setting Shahkar Provider
    ...    ${MICROSERVICE_SIDE}
    ...    ${providers_weight}

    Should Be Equal As Integers    ${result['status_code']}    422

    ${PROVIDER_RESPONSE}    Set Variable
    Set Test Variable    ${PROVIDER_RESPONSE}    ${result}

Set All Providers Active Field To false
    [Arguments]
    ...    ${active_auto_weighting}

    @{providerSettings}    Create List
    &{providers_weight}    Create Dictionary
    &{settingDetail}    Create Dictionary

    FOR    ${i}    IN RANGE    0    8
        &{provider}    Create Dictionary    &{EMPTY}
        Set To Dictionary    ${provider}    providerName    ${i}
        Set To Dictionary    ${provider}    weight    0.0
        ...    active    false
        Append To List    ${providerSettings}    ${provider}
    END
    Set To Dictionary    ${settingDetail}    providerSettings    ${providerSettings}
    Set To Dictionary    ${providers_weight}    settingDetail    ${settingDetail}
    Set To Dictionary    ${providers_weight}    activeAutoWeighting    ${active_auto_weighting}
    Set To Dictionary    ${providers_weight}    minWeightAutoWeighting    ${MIN_WEIGHT_AUTO_WEIGHTING}

    ${result}    POST Admin Kyc Setting Shahkar Provider
    ...    ${MICROSERVICE_SIDE}
    ...    ${providers_weight}

    Should Be Equal As Integers    ${result['status_code']}    422

    ${PROVIDER_RESPONSE}    Set Variable
    Set Test Variable    ${PROVIDER_RESPONSE}    ${result}

We Should See Exception Invalid Parameters
    [Documentation]    Check response and result of post setting providers API.

    Dictionaries Should Be Equal    ${PROVIDER_RESPONSE['body']}    ${INVALID_PARAMETER}

We Should See Exception Kyc Setting Validation Error
    [Documentation]    Check response and result of post setting providers API.

    Dictionaries Should Be Equal    ${PROVIDER_RESPONSE['body']}    ${KYC_SETTING_VALIDATION_ERROR}
