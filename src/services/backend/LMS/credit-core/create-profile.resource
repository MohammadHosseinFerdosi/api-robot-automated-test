*** Settings ***
Library     DateTime
Library     RequestsLibrary
Library     Collections
Library     JSONLibrary
Resource    services/db/mongo-db-service.resource
Resource    apis/lms/credit-core/post-admin-profiles.resource


*** Keywords ***
Create Profile
    [Documentation]    Test case to validate successful profile creation and database entries.
    [Arguments]    ${profile_data}
    ${response}=    POST Admin Profiles
    ...    ${MICROSERVICE_SIDE}
    ...    expiration_type=${profile_data['expiration_type']}
    ...    expiration_value=${profile_data['expiration_value']}
    ...    billing_cycle_type=${profile_data['billing_cycle_type']}
    ...    consumption_count=${profile_data['consumption_count']}
    ...    contract_generation_type=${profile_data['contract_generation_type']}
    ...    grace_period_type=${profile_data['grace_period_type']}
    ...    grace_period_value=${profile_data['grace_period_value']}
    ...    has_credit_agreement=${profile_data['has_credit_agreement']}
    ...    has_residue=${profile_data['has_residue']}
    ...    has_revolve=${profile_data['has_revolve']}
    ...    installment_due_date_type=${profile_data['installment_due_date_type']}
    ...    installment_due_date_value=${profile_data['installment_due_date_value']}
    ...    manual_settlement_action=${profile_data['manual_settlement_action']}
    ...    manual_settlement_day=${profile_data['manual_settlement_day']}
    ...    manual_settlement_offset=${profile_data['manual_settlement_offset']}
    ...    manual_settlement_payment_method=${profile_data['manual_settlement_payment_method']}
    ...    down_payment_percentage=${profile_data['down_payment_percentage']}
    ...    interest_percentage=${profile_data['interest_percentage']}
    ...    penalty_percentage=${profile_data['penalty_percentage']}
    ...    installment_count_list=${profile_data['installment_count_list']}
    ...    payment_plan=${profile_data['payment_plan']}
    ...    payment_method=${profile_data['payment_method']}
    ...    fund_provider_fee_list=${profile_data['fund_provider_fee_list']}
    ...    platform_fee_list=${profile_data['platform_fee_list']}
    ...    repayment_option=${profile_data['repayment_option']}
    ...    service_type=${profile_data['service_type']}
    ...    status=${profile_data['status']}
    ...    tag=${profile_data['tag']}
    ...    user_id=${profile_data['user_id']}

    IF    '${response['status_code']}' != '200'
        Fail    API call failed with status code: ${response['status_code']}
    END

    ${find_dic}=    Create Dictionary    profileId=${response['body']['profile']['profileId']}

    # Retry mechanism to check databases
    ${max_retries}=    Set Variable    300
    ${retry_interval}=    Set Variable    5
    FOR    ${i}    IN RANGE    ${max_retries}
        ${db_check_passed}=    Run Keyword And Return Status    Check Databases    ${find_dic}    ${profile_data}
        IF    ${db_check_passed}    BREAK
        Sleep    ${retry_interval}
    END

    IF    not ${db_check_passed}
        Fail    Database checks failed after ${max_retries} attempts.
    END

    RETURN    ${response}

Check Databases
    [Arguments]    ${find_dic}    ${profile_data}

    ${credit_profile_mng_db}=    Mongo Db Find    credit_profile_mng_db    profiles    ${find_dic}
    IF    len(${credit_profile_mng_db['body']}) != 0
        IF    '${credit_profile_mng_db['body'][0]['publishEventStatus']}' != 'PUBLISHED'
            Fail    msg=Profile not found in credit_profile_mng_db
        END
    ELSE
        Fail    msg=Profile not found in credit_profile_mng_db
    END

    ${credit_account_mng_db}=    Mongo Db Find    credit-account-mng_db    profiles    ${find_dic}
    IF    len(${credit_account_mng_db['body']}) != 0
        IF    '${credit_account_mng_db['body'][0]['profileId']}' != '${find_dic['profileId']}'
            Fail    msg=Profile not found in credit-account-mng_db
        END
    ELSE
        Fail    msg=Profile not found in credit-account-mng_db
    END

    ${credit_mng_db}=    Mongo Db Find    credit_mng_db    profiles    ${find_dic}
    IF    len(${credit_mng_db['body']}) != 0
        IF    '${credit_mng_db['body'][0]['profileId']}' != '${find_dic['profileId']}'
            Fail    msg=Profile not found in credit_mng_db
        END
    ELSE
        Fail    msg=Profile not found in credit_mng_db
    END

    IF    '${profile_data['has_credit_agreement']}' == 'true'
        ${credit_agreement_db}=    Mongo Db Find    credit_agreement_db    profiles    ${find_dic}
        IF    len(${credit_agreement_db['body']}) != 0
            IF    '${credit_agreement_db['body'][0]['profileId']}' != '${find_dic['profileId']}'
                Fail    msg=Profile not found in credit_agreement_db
            END
        ELSE
            Fail    msg=Profile not found in credit_agreement_db
        END
    END

    IF    '${profile_data['has_residue']}' == 'true'
        ${residue_mng_db}=    Mongo Db Find    residue_mng_db    profiles    ${find_dic}
        IF    len(${residue_mng_db['body']}) != 0
            IF    '${residue_mng_db['body'][0]['profileId']}' != '${find_dic['profileId']}'
                Fail    msg=Profile not found in residue_mng_db
            END
        ELSE
            Fail    msg=Profile not found in residue_mng_db
        END
    END

    IF    '${profile_data['has_revolve']}' == 'true'
        ${revolving_db}=    Mongo Db Find    revolving_db    profiles    ${find_dic}
        IF    len(${revolving_db['body']}) != 0
            IF    '${revolving_db['body'][0]['profileId']}' != '${find_dic['profileId']}'
                Fail    msg=Profile not found in revolving_db
            END
        ELSE
            Fail    msg=Profile not found in revolving_db
        END
    END

    RETURN    True
