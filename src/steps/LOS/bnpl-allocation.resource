*** Settings ***
Resource        apis/los/bnpl/post-credit-bnpl-allocate.resource
Resource        services/backend/LMS/credit-core/close-account.resource
Variables       data/los/bnpl.yaml


*** Keywords ***
All Parameters Are Correctly Set For The Allocation API
    Set Suite Variable    ${3PAY_BIZ_ID}    ${BNPL_3PAY_BIZ_ID}
    Set Suite Variable    ${BIRTH_DATE}    ${BNPL_BIRTH_DATE_ARASTOO}
    Set Suite Variable    ${CELL_NUMBER}    ${BNPL_CELL_NUMBER_ARASTOO}
    Set Suite Variable    ${NATIONAL_CODE}    ${BNPL_NATIONAL_CODE_ARASTOO}
    Set Suite Variable    ${USER_ID}    ${BNPL_USER_ID_ARASTOO}

    ${TRACKING_CODE}=    Unique Tracking Code
    Set Suite Variable    ${TRACKING_CODE}    ${TRACKING_CODE}

Unique Tracking Code
    FOR    ${index}    IN RANGE    10
        ${code}=    Evaluate    random.randint(10**10, 10**11 - 1)    modules=random
        ${is_unique}=    Check Tracking Code Is Unique    ${code}
        IF    ${is_unique} == ${True}    RETURN    ${code}
    END
    Fail    Bad Luck! Could not generate a unique tracking code after ${index} attempts

we call the allocation API
    ${resp}=    POST Credit BNPL Allocate
    ...    200000
    ...    ${BIRTH_DATE}
    ...    ${CELL_NUMBER}
    ...    ${3PAY_BIZ_ID}
    ...    1
    ...    ${NATIONAL_CODE}
    ...    1
    ...    ${TRACKING_CODE}
    ...    ${USER_ID}
    ...    ${MICROSERVICE_SIDE}
    Set Suite Variable    ${resp}

the response should be successful
    Should Be Equal As Strings    ${resp.status_code}    200
    Should Be Equal As Strings    ${resp.json()['result']['title']}    SUCCESS

close the user accounts
    Evaluate    exec("import builtins; builtins.ObjectId = lambda *a, **k: None")
    ${myres}=    Close User Accounts    user_id=${BNPL_USER_ID_ARASTOO}

Check Tracking Code is unique
    [Arguments]    ${tracking_code}
    ${filter_query}=    Create Dictionary    additionalInfo.trackingCode=${tracking_code}
    ${result}=    Mongo Db Find    ${SWITCH_CREDIT_DB_NAME}    bnpl_allocation_journal    ${filter_query}
    ${length}=    Get Length    ${result}[body]

    IF    ${length} == 0    RETURN    ${True}

all parameters are correctly set for the allocation API, but the phone number does not match the national code
    Set Suite Variable    ${3PAY_BIZ_ID}    ${BNPL_3PAY_BIZ_ID}
    Set Suite Variable    ${BIRTH_DATE}    ${BNPL_BIRTH_DATE_ARASTOO}
    Set Suite Variable    ${CELL_NUMBER}    ${BNPL_CELL_NUMBER_ARASTOO}
    Set Suite Variable    ${NATIONAL_CODE}    1234567890
    Set Suite Variable    ${USER_ID}    ${BNPL_USER_ID_ARASTOO}

    ${TRACKING_CODE}=    Unique Tracking Code
    Set Suite Variable    ${TRACKING_CODE}    ${TRACKING_CODE}

    ${resp}=    POST Credit BNPL Allocate
    ...    200000
    ...    ${BIRTH_DATE}
    ...    ${CELL_NUMBER}
    ...    ${3PAY_BIZ_ID}
    ...    1
    ...    ${NATIONAL_CODE}
    ...    1
    ...    ${TRACKING_CODE}
    ...    ${USER_ID}
    ...    ${MICROSERVICE_SIDE}
    Set Suite Variable    ${resp}

the response should not be successful related to Shahkar validation
    Should Be Equal As Strings    ${resp.status_code}    422
    Should Be Equal As Strings    ${resp.json()['result']['title']}    INVALID_PARAMETER

Find Existing Tracking Code In The Database
    [Arguments]    ${user_id}
    ${filter_query}=    Create Dictionary    userId=${user_id}
    ${result}=    Mongo Db Find    ${SWITCH_CREDIT_DB_NAME}    bnpl_allocation_journal    ${filter_query}

    ${body}=    Get From Dictionary    ${result}    body
    ${first_item}=    Get From List    ${body}    0
    ${additional_info}=    Get From Dictionary    ${first_item}    additionalInfo
    ${tracking_code}=    Get From Dictionary    ${additional_info}    trackingCode
    Set Suite Variable    ${TRACKING_CODE}    ${TRACKING_CODE}

all parameters are correctly set for the allocation API except the tracking code (duplicate)
    Find Existing Tracking Code In The Database    user_id=${BNPL_USER_ID_ARASTOO}
    Set Suite Variable    ${3PAY_BIZ_ID}    ${BNPL_3PAY_BIZ_ID}
    Set Suite Variable    ${BIRTH_DATE}    ${BNPL_BIRTH_DATE_ARASTOO}
    Set Suite Variable    ${CELL_NUMBER}    ${BNPL_CELL_NUMBER_ARASTOO}
    Set Suite Variable    ${NATIONAL_CODE}    ${BNPL_NATIONAL_CODE_ARASTOO}
    Set Suite Variable    ${USER_ID}    ${BNPL_USER_ID_ARASTOO}

the response should not be successful related to duplicated tracking code
    Should Be Equal As Strings    ${resp.status_code}    422
    Should Be Equal As Strings    ${resp.json()['result']['title']}    CREDIT_ONB_DUPLICATE_VALUE

all parameters are correctly set for the allocation API, but the user is marked as deceased
    Set Suite Variable    ${3PAY_BIZ_ID}    ${BNPL_3PAY_BIZ_ID}
    Set Suite Variable    ${BIRTH_DATE}    ${BNPL_DEAD_BIRTH_DATE}
    Set Suite Variable    ${CELL_NUMBER}    ${BNPL_DEAD_CELL_NUMBER}
    Set Suite Variable    ${NATIONAL_CODE}    ${BNPL_DEAD_NATIONAL_CODE}
    Set Suite Variable    ${USER_ID}    ${BNPL_DEAD_USER_ID}

    ${TRACKING_CODE}=    Unique Tracking Code
    Set Suite Variable    ${TRACKING_CODE}    ${TRACKING_CODE}

the response should not be successful related to death validation
    ${status_code}=    Set Variable    ${resp.status_code}
    ${error_title}=    Set Variable    ${resp.json()['result']['title']}

    Should Be Equal As Strings    ${status_code}    422
    Should Be Equal As Strings    ${error_title}    CREDIT_ONB_USER_IS_DECEASED

all parameters are correctly set for the allocation API, but birthdate not correct
    Set Suite Variable    ${3PAY_BIZ_ID}    ${BNPL_3PAY_BIZ_ID}
    Set Suite Variable    ${BIRTH_DATE}     ${BNPL_BIRTH_DATE_ARASTOO}
    Set Suite Variable    ${CELL_NUMBER}    ${BNPL_CELL_NUMBER_ARASTOO}
    Set Suite Variable    ${NATIONAL_CODE}    ${BNPL_NATIONAL_CODE_ARASTOO}
    Set Suite Variable    ${USER_ID}    ${BNPL_USER_ID_ARASTOO}

    ${TRACKING_CODE}=    Unique Tracking Code
    Set Suite Variable    ${TRACKING_CODE}    ${TRACKING_CODE}

the response should not be successful related to birthdate validation
    Should Be Equal As Strings    ${resp.status_code}    422
    Should Be Equal As Strings    ${resp.json()['result']['title']}    CREDIT_ONB_USER_INVALID_BIRTH_DATE
