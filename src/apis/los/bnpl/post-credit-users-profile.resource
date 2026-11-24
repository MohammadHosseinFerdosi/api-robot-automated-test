*** Settings ***
Library    RequestsLibrary
Resource    services/backend/session-service.resource

*** Keywords ***
POST Credit Users Profile
    [Documentation]    Updates user profile with full headers and cookie support.
    [Arguments]
    ...    ${api_call_side}
    ...    ${PLATFORM_VERSION}
    ...    ${agent}
    ...    ${content_type}
    ...    ${postal_code}
    ...    ${city_uid}
    ...    ${province_uid}
    ...    ${address}
    ...    ${address_no}
    ...    ${adress_unit}
    ...    ${phone_number}
    ...    ${birth_place}
    ...    ${education_uid}
    ...    ${job_uid}
    ...    ${creditid}
    ...    ${user_id}
    ...    ${cookie}=${EMPTY}   

    ${basic_auth_param}=    Set Variable    ${EMPTY}

    ${header}    Create Dictionary
    ...    Platform-Version=${PLATFORM_VERSION}
    ...    Agent=${agent}
    ...    Referer=${APP_BASE_URL}/
    ...    User-Id=${user_id}
    ...    Content-Type=${content_type}

    Run Keyword If    '${cookie}' != '${EMPTY}'    Set To Dictionary    ${header}    Cookie=${cookie}

    ${api_path}=    Set Variable    /users/profile/13/${creditid}

    IF    '${api_call_side}' == '${MICROSERVICE_SIDE}'
        ${api_path}=    Set Variable    ${MS_CREDIT_ONBOARDING_PATH}${api_path}
    ELSE
        ${api_path}=    Set Variable    /credit${api_path}
    END

    &{body}=    Create Dictionary
    ...    postalCode=${postal_code}
    ...    cityUid=${city_uid}
    ...    provinceUid=${province_uid}
    ...    address=${address}
    ...    addressNo=${address_no}
    ...    addressUnit=${adress_unit}
    ...    phoneNumber=${phone_number}
    ...    birthPlace=${birth_place}
    ...    educationUid=${education_uid}
    ...    jobUid=${job_uid}

    ${session}    Create A Session    ${api_call_side}    ${basic_auth_param}

    ${response}    POST On Session
    ...    ${session}
    ...    ${api_path}
    ...    headers=${header}
    ...    json=${body}
    ...    expected_status=any

    &{result}=    Create Dictionary    status_code=${response.status_code}    body=${None}

    TRY
        ${json_body}=    Evaluate    json.loads('''${response.text}''')    json
        Set To Dictionary    ${result}    body=${json_body}
    EXCEPT
        Set To Dictionary    ${result}    body=${response.text}
    END

    RETURN    ${result}

    [Teardown]    Delete A Session    ${session}
