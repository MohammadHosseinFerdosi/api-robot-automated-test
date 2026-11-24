*** Settings ***
Resource        apis/los/Journey/get-credit-plans.resource
Resource        apis/los/Journey/post-credit-volunteers-pre-register.resource
Resource        apis/los/bnpl/post-credit-activations-profile-in-progress.resource
Resource        apis/los/bnpl/post-credit-users-profile.resource
Resource        apis/los/bnpl/post-credit-smc-init.resource
Resource        services/backend/auth-service.resource
Resource        services/backend/clean-data.resource
Resource        services/backend/import-allocation.resource
Variables       data/los/bnpl.yaml


*** Keywords ***
Getting Token
    [Documentation]    This Part Will Be Call Login To App Keyword And Get App Token
    Login To App    ${BNPL_CELL_NUMBER_ARASTOO}

User is successfully allocated in Indirect Journey
    [Documentation]    This Part Will Be Close Allocation Or Show Any Information From Allocation Flow.
    Clean User Account    ${BNPL_USER_ID_ARASTOO}
    
Plans API is called successfully (Indirect)
    [Documentation]    This Part Will Be Call Plans API In Indirect Flow
    ${get_credit_plans}    GET Credit Plans
    ...    ${APP_SIDE}
    ...    ${BNPL_PLATFORM_VERSION}
    ...    ${BNPL_USER_ID_ARASTOO}
    Should Be Equal As Integers    ${get_credit_plans['status_code']}    200    Invalid response code
    Should Be Equal As Strings    ${get_credit_plans["body"].result.title}    ${SUCCESS_TITLE}
    Should Be Equal As Integers    ${get_credit_plans['body'].result.status}    ${SUCCESS_STATUS_CODE}
    Should Be Equal As Strings    ${get_credit_plans['body'].result.message}    ${SUCCESS_MESSAGE}
    Should Be Equal As Strings    ${get_credit_plans['body'].result.level}    ${INFO_LEVEL}


Pre-Register API is called successfully (Indirect)
    [Documentation]    This Part Will Be Call Pre-Register API In Indirect Flow
    ${post_credit_volunteers_pre_register}    POST Credit Volunteers Pre Register
    ...    ${APP_SIDE}
    ...    ${BNPL_PLATFORM_VERSION}
    ...    ${BNPL_USER_ID_ARASTOO}
    ...    ${BNPL_NATIONAL_CODE_ARASTOO}
    ...    ${BNPL_TIME_STAMP_BIRTH_DATE_ARASTOO}
    ...    ${BNPL_Group_ID_ARASTOO}
    ...    ${BNPL_PLAN_ID_ARASTOO}
    ...    ${BNPL_BNPL_CART_RESERVATION_REQUEST_ARASTOO}
    ...    ${BNPL_BALANCE_ARASTOO}
    Should Be Equal As Integers    ${post_credit_volunteers_pre_register['status_code']}    200    Invalid response code
    Set Test Variable    ${CREDIT_ID}    ${post_credit_volunteers_pre_register['body']['creditId']}
    Should Be Equal As Strings    ${post_credit_volunteers_pre_register["body"].result.title}    ${SUCCESS_TITLE}
    Should Be Equal As Integers    ${post_credit_volunteers_pre_register['body'].result.status}    ${SUCCESS_STATUS_CODE}
    Should Be Equal As Strings    ${post_credit_volunteers_pre_register['body'].result.message}    ${SUCCESS_MESSAGE}
    Should Be Equal As Strings    ${post_credit_volunteers_pre_register['body'].result.level}    ${INFO_LEVEL}

Profile In-Progress API is called successfully (Indirect)
    [Documentation]    This Part Will Be Call Profile/In-Progress API In Indirect Flow
    ${post_credit_activations_profile_in_progress}    POST Credit Activations Profile In Progress
    ...    ${APP_SIDE}
    ...    ${CREDIT_ID}
    ...    ${BNPL_CONTENT_TYPE}
    ...    ${BNPL_COOKIE}
    
    Should Be Equal As Integers    ${post_credit_activations_profile_in_progress['status_code']}    200    Invalid response code
    Should Be Equal As Strings    ${post_credit_activations_profile_in_progress["body"].result.title}    ${SUCCESS_TITLE}
    Should Be Equal As Integers    ${post_credit_activations_profile_in_progress['body'].result.status}    ${SUCCESS_STATUS_CODE}
    Should Be Equal As Strings    ${post_credit_activations_profile_in_progress['body'].result.message}    ${SUCCESS_MESSAGE}
    Should Be Equal As Strings    ${post_credit_activations_profile_in_progress['body'].result.level}    ${INFO_LEVEL}

Users Profile API is called successfully (Indirect)
    [Documentation]    This Part Will Be Call Users/Profile API In Indirect Flow
    ${post_credit_users_profile}    POST Credit Users Profile
    ...    ${APP_SIDE}
    ...    ${BNPL_PLATFORM_VERSION}
    ...    ${BNPL_AGENT}
    ...    ${BNPL_CONTENT_TYPE}
    ...    ${BNPL_POSTAL_CODE}
    ...    ${BNPL_CITY_UUID}
    ...    ${BNPL_PROVINCE_UUID}
    ...    ${BNPL_ADDRESS}
    ...    ${BNPL_ADDRESS_NO}
    ...    ${BNPL_ADDRESS_UNIT}
    ...    ${BNPL_PHONE_NUMBER}
    ...    ${BNPL_BIRTH_PLACE}
    ...    ${BNPL_EDUCATION_UUID}
    ...    ${BNPL_JOB_UUID}
    ...    ${CREDIT_ID}
    ...    ${BNPL_USER_ID_ARASTOO}
    Should Be Equal As Integers    ${post_credit_users_profile['status_code']}    200    Invalid response code
    Should Be Equal As Strings    ${post_credit_users_profile["body"].result.title}    ${SUCCESS_TITLE}
    Should Be Equal As Integers    ${post_credit_users_profile['body'].result.status}    ${SUCCESS_STATUS_CODE}
    Should Be Equal As Strings    ${post_credit_users_profile['body'].result.message}    ${SUCCESS_MESSAGE}
    Should Be Equal As Strings    ${post_credit_users_profile['body'].result.level}    ${INFO_LEVEL}

SMC Init API is called successfully (Indirect)
    [Documentation]    This Part Will Be Call SMC/Init API In Indirect Flow
    ${post_credit_smc_init}    POST Credit SMC Init
    ...    ${APP_SIDE}
    ...    ${CREDIT_ID}
    Should Be Equal As Integers    ${post_credit_smc_init['status_code']}    200    Invalid response code
    Should Be Equal As Strings    ${post_credit_smc_init["body"].result.title}    ${SUCCESS_TITLE}
    Should Be Equal As Integers    ${post_credit_smc_init['body'].result.status}    ${SUCCESS_STATUS_CODE}
    Should Be Equal As Strings    ${post_credit_smc_init['body'].result.message}    ${SUCCESS_MESSAGE}
    Should Be Equal As Strings    ${post_credit_smc_init['body'].result.level}    ${INFO_LEVEL}

User is successfully allocated (Indirect)
    [Documentation]    This Part Will Be Close Allocation Or Show Any Information From Allocation Flow.
    Clean User Account    ${BNPL_USER_ID_ARASTOO}