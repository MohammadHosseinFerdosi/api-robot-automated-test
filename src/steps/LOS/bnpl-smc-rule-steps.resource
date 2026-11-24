*** Settings ***
Variables       data/los/bnpl.yaml
Resource        services/backend/LMS/credit-core/close-account.resource
Resource        apis/los/bnpl/post-credit-activations-profile-in-progress.resource
Resource        apis/los/Journey/post-credit-volunteers-pre-register.resource
Resource        apis/los/bnpl/post-credit-users-profile.resource
Resource        apis/los/bnpl/post-credit-smc-init.resource
Resource        apis/los/bnpl/post-credit-activations-cancel.resource


*** Keywords ***
the user is logged in to the app
    Login To App    ${BNPL_CELL_NUMBER_ARASTOO}

Close all his BNPLs
    Evaluate    exec("import builtins; builtins.ObjectId = lambda *a, **k: None")
    ${myres}=    Close User Accounts    user_id=${BNPL_USER_ID_ARASTOO}

The User Pre-registers For A BNPL Plan
    [Documentation]    Submits the pre-register form with the given plan details.
    [Arguments]    ${group_id}    ${plan_id}    ${balance}
    ${RESULT}=    POST Credit Volunteers Pre Register
    ...    ${APP_SIDE}
    ...    ${BNPL_PLATFORM_VERSION}
    ...    ${BNPL_CELL_NUMBER_ARASTOO}
    ...    ${BNPL_NATIONAL_CODE_ARASTOO}
    ...    ${BNPL_TIME_STAMP_BIRTH_DATE_ARASTOO}
    ...    ${group_id}
    ...    ${plan_id}
    ...    ${BNPL_CART_RESERVATION_REQUEST}
    ...    ${balance}

    Set Suite Variable    ${credit_id}    ${RESULT['body']['creditId']}

Check BNPL Activation Record
    MONGO_DB.Connect To Db
    ...    host=${MONGO_DB_DEFAULT_HOST}
    ...    port=${MONGO_DB_DEFAULT_PORT}
    ...    user=${CREDIT_USER}
    ...    password=${MONGO_DB_DEFAULT_PASS}
    ...    db_name=${CREDIT_DB}

    ${query}=    Create Dictionary    creditId=${credit_id}
    ${result}=    MONGO_DB.Find Documents    activations    ${query}
    ${found}=    Evaluate    len($result['body']) > 0

    IF    ${found} == False
        Sleep    5s
        ${result}=    MONGO_DB.Find Documents    activations    ${query}
        ${found}=    Evaluate    len($result['body']) > 0
    END

    Run Keyword If    ${found} == False
    ...    Fail   برای این کاربر درخواست فعالسازی وجود ندارد. لطفا برای بررسی مشکل کالکشن volunteers را با creditId: "${credit_id}" بررسی بفرمایید

    MONGO_DB.Close Db Connection
    
Activate BNPL Profile In Progress
    ${result}=    POST Credit Activations Profile In Progress
    ...    ${MICROSERVICE_SIDE}
    ...    ${credit_id}
    ...    ${BNPL_USER_ID_ARASTOO}
    Should Be Equal As Numbers    ${result['status_code']}    200

Update BNPL User Profile
    ${result}=    POST Credit Users Profile
    ...    ${MICROSERVICE_SIDE}
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
    ...    ${credit_id}
    ...    ${BNPL_USER_ID_ARASTOO}
    Should Be Equal As Numbers    ${result['status_code']}    200

Test Setup For SMC Rules
    the user is logged in to the app
    Close all his BNPLs

Call The SMC Init API
    [Documentation]    Calls the SMC endpoint for the current credit ID.
    ${result}=    POST Credit SMC Init    api_call_side=${APP_SIDE}    creditid=${credit_id}
    Should Be Equal As Numbers    ${result['status_code']}    200

The Credit Status Should Be Updated To
    [Documentation]    Polls the database until the credit status matches the expected one.
    [Arguments]    ${expected_status}
    Wait Until Keyword Succeeds
    ...    15s
    ...    3s
    ...    _Verify Credit Status In DB    ${credit_id}    ${expected_status}

_Verify Credit Status In DB
    [Documentation]    A helper keyword to check the DB status once. Used by the Wait keyword.
    [Arguments]    ${id_to_check}    ${expected_status}
    ${find_query}=    Create Dictionary    creditId=${id_to_check}
    ${result}=    Mongo Db Find    ${SWITCH_CREDIT_DB_NAME}    activations    ${find_query}
    ${actual_status}=    Set Variable    ${result['body'][0]['status']}
    Should Be Equal As Strings    ${actual_status}    ${expected_status}

Archive the unallocated bnpl successfully

    ${response}=    POST Credit Activation Cancel
    ...    fund_provider_code=${BNPL_DP_FP_CODE}
    ...    credit_id=${credit_id}
    ...    cancel_reason_type=${CREDIT_CANCEL_REASON_TYPE}
    ...    cancel_reason=${CREDIT_CANCEL_REASON}
    ...    api_call_side=${MICROSERVICE_SIDE}
    ...    user_id=${BNPL_USER_ID_ARASTOO}

    Should Be Equal As Strings    ${response['status_code']}    200

    Sleep    5s

    ${find_query}=    Create Dictionary    creditId=${credit_id}
    ${result}=    Mongo Db Find    ${SWITCH_CREDIT_DB_NAME}    activations    ${find_query}
    Should Be Empty    ${result['body']}