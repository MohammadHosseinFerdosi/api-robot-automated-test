*** Settings ***
Library     DateTime
Library     RequestsLibrary
Library     Collections
Library     JSONLibrary
Resource    services/db/mongo-db-service.resource
Resource    services/db/mysql-db-service.resource
Resource    apis/lms/credit-core/post-admin-credit-fund-providers.resource


*** Keywords ***
Create Fund Provider
    [Documentation]    Test case to validate successful Fund Provider creation and database entries.
    [Arguments]    ${fund_provider_data}
    ${response}=    POST Admin Credit Fund Provider
    ...    ${MICROSERVICE_SIDE}
    ...    ${fund_provider_data['business_id']}
    ...    ${fund_provider_data['code']}
    ...    ${fund_provider_data['name']}
    ...    ${fund_provider_data['english_name']}
    ...    ${fund_provider_data['crn']}
    ...    ${fund_provider_data['type']}
    ...    ${fund_provider_data['active']}
    ...    ${fund_provider_data['relay_cutoff_start_time']}
    ...    ${fund_provider_data['relay_cutoff_end_time']}
    ...    ${fund_provider_data['payment_cutoff_start_time']}
    ...    ${fund_provider_data['payment_cutoff_end_time']}
    ...    ${fund_provider_data['payment_flow']}
    ...    ${fund_provider_data['product_types']}
    ...    ${fund_provider_data['minimum_credit_amount']}
    ...    ${fund_provider_data['instant_finalization']}
    ...    ${fund_provider_data['whitelist_merchants']}
    ...    ${fund_provider_data['payment_strategy']}
    ...    ${fund_provider_data['final_refund_strategy']}
    ...    ${fund_provider_data['draft_refund_strategy']}
    ...    ${DASHBOARD_USERNAME}

    IF    '${response['status_code']}' != '200'
        Fail    API call failed with status code: ${response['status_code']}
    END

    ${find_dic}=    Create Dictionary    businessId=${response['body']['businessId']}

    # Retry mechanism to check databases
    ${max_retries}=    Set Variable    300
    ${retry_interval}=    Set Variable    5
    FOR    ${i}    IN RANGE    ${max_retries}
        ${db_check_passed}=    Run Keyword And Return Status    Check Databases    ${find_dic}    ${fund_provider_data}
        IF    ${db_check_passed}    BREAK
        Sleep    ${retry_interval}
    END

    IF    not ${db_check_passed}
        Fail    Database checks failed after ${max_retries} attempts.
    END

    RETURN    ${response}

Check Databases
    [Arguments]    ${find_dic}    ${fund_provider_data}

    ${fund_provider_mng_db}=    Mongo Db Find    fund_provider_mng_db    fund_providers    ${find_dic}
    IF    len(${fund_provider_mng_db['body']}) != 0
        IF    '${fund_provider_mng_db['body'][0]['businessId']}' != '${fund_provider_data['business_id']}'
            Fail    msg=Fund Provider not found in fund_provider_mng_db
        END
    ELSE
        Fail    msg=Fund Provider not found in fund_provider_mng_db
    END

    ${credit_account_mng_db}=    Mongo Db Find    credit-account-mng_db    fund_providers    ${find_dic}
    IF    len(${credit_account_mng_db['body']}) != 0
        IF    '${credit_account_mng_db['body'][0]['businessId']}' != '${fund_provider_data['business_id']}'
            Fail    msg=Fund Provider not found in credit_account_mng_db
        END
    ELSE
        Fail    msg=Fund Provider not found in credit_account_mng_db
    END

    ${credit_mng_db}=    Mongo Db Find    credit_mng_db    fund_providers    ${find_dic}
    IF    len(${credit_mng_db['body']}) != 0
        IF    '${credit_mng_db['body'][0]['businessId']}' != '${fund_provider_data['business_id']}'
            Fail    msg=Fund Provider not found in credit_mng_db
        END
    ELSE
        Fail    msg=Fund Provider not found in credit_mng_db
    END

    ${query}=    Set Variable
    ...    SELECT * FROM installment_db.fund_providers WHERE business_id='${fund_provider_data['business_id']}'
    ${result_installment_fund_providers}=    MySQL Fetch All    db_name=installment_db    query=${query}
    IF    ${result_installment_fund_providers} == 0    Fail
    ${fund_provider_business_id}=    Evaluate    "business_id" in ${result_installment_fund_providers}[body][0]
    IF    '${fund_provider_business_id}' == 'False'
        Fail    msg=Fund Provider not found in installment_db
    END

    RETURN    True
