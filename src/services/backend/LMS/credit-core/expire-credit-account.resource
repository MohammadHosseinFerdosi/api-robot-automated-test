*** Settings ***
Library     DateTime
Resource    services/db/mongo-db-service.resource
Resource    services/backend/value-handler.resource


*** Keywords ***
Expiration Time Setter
    [Documentation]    Simply updates and modifies the expiration time for a given credit id.
    ...    If a credit_id as purchases, the expiration time is set as 1 milliseconds after the most recent creation date in the purchases associated with the credit_id.
    ...    Otherwise the expiration time follows the default handler.
    ...
    ...    ${force_default}: is used to forced the default (yesterday expired) strategy to the time setter
    [Arguments]    ${credit_id}    ${force_default}=False

    ${filter_query}    Create Dictionary    creditId=${credit_id}

    ${credit_purchases}    Mongo Db Find    credit_mng_db    purchases    ${filter_query}
    ${credit_purchases_list}    Set Variable    ${credit_purchases}[body]
    ${length_purchase}    Get Length    ${credit_purchases_list}
    ${result_credit_account}    Set Variable    ${EMPTY}

    IF    '${length_purchase}'!='0' and '${force_default}'!='True'
        ${creation_date}    Value Handler    ${credit_purchases_list}[0][creationDate]
        FOR    ${i}    IN RANGE    ${0}    ${length_purchase}    ${1}
            ${purchase_i}    Set Variable    ${credit_purchases_list}[${i}]
            ${creation_date_i}    Value Handler    ${credit_purchases_list}[${i}][creationDate]
            IF    ${creation_date_i}>${creation_date}
                ${creation_date}    Set Variable    ${creation_date_i}
            END
        END
        ${result_credit_account}    Expire Account While Having Purchase Handler
        ...    credit_id=${credit_id}
        ...    creation_date=${creation_date}
    ELSE
        ${result_credit_account}    Expire Account Default Handler    credit_id=${credit_id}
    END

    RETURN    ${result_credit_account}

Expire credit account
    [Arguments]    ${credit_id}    ${force_default}=False
    ${result_credit_account}    Expiration Time Setter    credit_id=${credit_id}    force_default=${force_default}
    ${account_count}    Set Variable    ${result_credit_account}[body][matched_count]
    IF    ${account_count} != 0
        Wait Until Keyword Succeeds    30x    10 s    Check account status    ${credit_id}
        ${account_status}    Check account status    ${credit_id}
        RETURN    ${account_status}
    ELSE
        RETURN    False
    END

Expire Account While Having Purchase Handler
    [Documentation]    Expires the account based on a most recent creation date of the purchase
    [Tags]    robot:private
    [Arguments]    ${credit_id}    ${creation_date}

    ${end_Date}    Evaluate    int(${creation_date} + 1)

    &{find_dic}    Create Dictionary    creditId=${credit_id}
    &{update_query}    Create Dictionary    expirationTime=${end_Date}
    &{set}    Create Dictionary    $set=&{update_query}

    ${result_credit_account}    Mongo Db Update One
    ...    db_name=credit-account-mng_db
    ...    collection_name=accounts
    ...    filter_query=${find_dic}
    ...    update_data=${set}

    RETURN    ${result_credit_account}

Expire Account Default Handler
    [Documentation]    This is the default handler for the expiration of the account. Simply expires the account by setting their expiration date to yesterday.
    [Tags]    robot:private
    [Arguments]    ${credit_id}

    ${now}    Get Time    epoch
    ${end_Date}    Add Time To Date    ${now}    -1 days    epoch
    ${end_Date}    Evaluate    int(${end_Date} * 1000)

    &{find_dic}    Create Dictionary    creditId=${credit_id}
    &{update_query}    Create Dictionary    expirationTime=${end_Date}
    &{set}    Create Dictionary    $set=&{update_query}

    ${result_credit_account}    Mongo Db Update One
    ...    db_name=credit-account-mng_db
    ...    collection_name=accounts
    ...    filter_query=${find_dic}
    ...    update_data=${set}

    RETURN    ${result_credit_account}

Check account status
    [Tags]    robot:private
    [Arguments]    ${credit_id}
    ${find_dic}    Create Dictionary    creditId=${credit_id}
    ${account}    Mongo Db Find    credit-account-mng_db    accounts    ${find_dic}
    ${account_status}    Set Variable    ${account}[body][0][status]
    ${contain_expire_relay_time}    Evaluate    "expireRelayTime" in ${account}[body][0]
    ${account_expire_relay_time}    Set Variable    ${EMPTY}
    IF    ${contain_expire_relay_time}
        ${account_expire_relay_time}    Set Variable    ${account}[body][0][expireRelayTime]
        ${is_dictionary}    Evaluate    isinstance(${account_expire_relay_time}, dict)
        IF    ${is_dictionary} == True
            ${account_expire_relay_time}    Get Dictionary Values    ${account_expire_relay_time}
            ${account_expire_relay_time}    Set Variable    ${account_expire_relay_time}[0]
        END
    END
    IF    ('${account_expire_relay_time}' == '${EMPTY}') and ('${account_status}' != '1')
        Fail
    END
    RETURN    ${account_status}
