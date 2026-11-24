*** Settings ***
Library     library/faker_utils.py    WITH NAME    FakerLibrary
Resource    apis/uaa/post-admin-businesses.resource


*** Keywords ***
Generate A Fake Business
    [Documentation]    Generates a fake business config
    [Tags]    robot:private

    ${random_color}    FakerLibrary.Color Name
    ${random_name}    FakerLibrary.First Name
    ${country}    FakerLibrary.country
    ${email}    FakerLibrary.email
    ${username}    Catenate    Test-${random_color}-${random_name}-${country}-${email}
    ${name}    Set Variable    ${username}
    ${password}    FakerLibrary.Password

    RETURN    ${username}    ${name}    ${password}

Generate A Fresh Business
    [Documentation]    Generates a fresh business. Retries for ${max_retry}.
    ...    Fails if it could not generate a fresh business after that.
    [Arguments]    ${role_list}=${EMPTY}    ${zone}=${EMPTY}    ${max_retry}=60

    ${generated_business_info}    Create Dictionary
    ...    business_id=${EMPTY}
    ...    business_name=${EMPTY}
    ...    user_name=${EMPTY}
    ...    password=${EMPTY}

    ${role_list_length}    Get Length    ${role_list}
    IF    ${role_list_length} == 0
        @{role_list}    Create List    BUSINESS_ADMIN
    ELSE
        @{role_list}    Set Variable    ${role_list}
    END

    FOR    ${i}    IN RANGE    ${0}    ${max_retry}    ${1}
        ${username}    ${name}    ${password}    Generate A Fake Business

        ${response}    POST Admin Businesses
        ...    ${MICROSERVICE_SIDE}
        ...    ${name}
        ...    ${username}
        ...    ${password}
        ...    ${role_list}
        ...    ${zone}
        ${status_code}    Set Variable    ${response['status_code']}
        IF    '${status_code}'=='200'
            ${generated_business_info}    Create Dictionary
            ...    business_id=${response['business_id']}
            ...    business_name=${name}
            ...    user_name=${username}
            ...    password=${password}
            BREAK
        END
    END
    IF    '${status_code}'!='200'
        Fail    msg=Business initialization failed with status code: ${response['status_code']}
    END

    RETURN    ${generated_business_info}
