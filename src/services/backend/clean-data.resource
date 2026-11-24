*** Settings ***
Resource    services/backend/user-wallet-initializer-service.resource


*** Variables ***
${fallback}     111222333444555666777888999


*** Keywords ***
Reproduce Amount
    [Documentation]    Reproduces the businessId wallets. This is a ```Test Teardown```
    [Arguments]    ${bad_user_id}

    &{user_data}    Create Dictionary    user_id=${bad_user_id}    type=${CUSTOMER_TYPE}
    ${additional_user_lists}    Create List    ${user_data}

    Collect All Amount For Tear Down    additional_user_lists=${additional_user_lists}

Get User Details And Credit IDs
    [Tags]    robot:private
    [Arguments]    ${bad_user_id}    ${as_suite_variable}=False

    ${query}    Set Variable
    ...    SELECT cell_number, national_code FROM users WHERE user_id = '${bad_user_id}'
    ${results}    MySQL Fetch All    user_db    ${query}
    ${results}    Set Variable    ${results['body']}
    ${row}    Get From List    ${results}    0

    ${cell_number}    Get From Dictionary    ${row}    cell_number
    ${national_code}    Get From Dictionary    ${row}    national_code

    IF    '${national_code}'=='${EMPTY}' or '${national_code}'=='None'
        ${national_code}    Set Variable    ${fallback}
    END
    IF    '${cell_number}'=='${EMPTY}' or '${cell_number}'=='None'
        ${cell_number}    Set Variable    ${fallback}
    END

    ${filter}    Create Dictionary    userId    ${bad_user_id}
    ${credit_docs}    Mongo Db Find    switch_credit_db    activations    ${filter}
    ${credit_docs}    Set Variable    ${credit_docs['body']}
    ${credit_length}    Get Length    ${credit_docs}
    IF    '${credit_length}'=='0'
        ${credit_docs}    Mongo Db Find    credit-account-mng_db    accounts    ${filter}
        ${credit_docs}    Set Variable    ${credit_docs['body']}
    END

    ${credit_ids}    Create List
    FOR    ${doc}    IN    @{credit_docs}
        ${credit_id}    Get From Dictionary    ${doc}    creditId
        IF    '${credit_id}' != 'None'
            Append To List    ${credit_ids}    ${credit_id}
        END
    END
    ${credit_length}    Get Length    ${credit_ids}
    IF    '${credit_length}'=='0'
        ${credit_ids}    Create List    ${fallback}
    END

    IF    '${as_suite_variable}' == 'True'
        Set Suite Variable    ${cell_number}
    ELSE
        Set Test Variable    ${cell_number}
    END

    IF    '${as_suite_variable}' == 'True'
        Set Suite Variable    ${national_code}
    ELSE
        Set Test Variable    ${national_code}
    END

    IF    '${as_suite_variable}' == 'True'
        Set Suite Variable    ${credit_ids}
    ELSE
        Set Test Variable    ${credit_ids}
    END

Wallet Provider Mongo Db Cleaner
    [Tags]    robot:private
    [Arguments]    ${bad_user_id}

    ${filter_1}    Create Dictionary    sources.ownerId    ${bad_user_id}
    ${result}    Mongo Db Delete Many    wallet_provider_db    transactions    ${filter_1}
    Should Be Equal As Strings
    ...    ${result['status_code']}
    ...    0
    ...    Wallet Provider Cleaner - Failed while deleting transactions by sources.ownerId

    ${filter_2}    Create Dictionary    destinations.ownerId    ${bad_user_id}
    ${result}    Mongo Db Delete Many    wallet_provider_db    transactions    ${filter_2}
    Should Be Equal As Strings
    ...    ${result['status_code']}
    ...    0
    ...    Wallet Provider Cleaner - Failed while deleting transactions by destinations.ownerId

    ${filter_3}    Create Dictionary    ownerId    ${bad_user_id}
    ${results}    Mongo Db Find    wallet_provider_db    wallets    ${filter_3}
    Should Be Equal As Strings
    ...    ${results['status_code']}
    ...    0
    ...    Wallet Provider Cleaner - Failed while detecting wallet ids by ownerId.

    ${length}    Get Length    ${results['body']}
    ${credit_wallet_ids}    Create List
    FOR    ${i}    IN RANGE    ${0}    ${length}    ${1}
        ${record_i}    Set Variable    ${results['body']}[${i}]
        ${record_i_wallet_name}    Set Variable    ${record_i['walletName']}
        ${is_credit}    Run Keyword And Return Status    Should Match Regexp    ${record_i_wallet_name}    ^credit_.*
        IF    ${is_credit}
            Append To List    ${credit_wallet_ids}    ${record_i['walletId']}
        END
    END
    ${length}    Get Length    ${credit_wallet_ids}
    FOR    ${i}    IN RANGE    ${0}    ${length}    ${1}
        ${filter_i}    Create Dictionary    walletId    ${credit_wallet_ids}[${i}]
        ${result}    Mongo Db Delete One    wallet_provider_db    wallets    ${filter_i}   
        Should Be Equal As Strings
        ...    ${result['status_code']}
        ...    0
        ...    Wallet Provider Cleaner - Failed while deleting walletId by walletId.
    END
        
Refund Mng Mongo Db Cleaner
    [Tags]    robot:private
    [Arguments]    ${bad_user_id}

    ${filter}    Create Dictionary    refundData.userId    ${bad_user_id}
    ${result}    Mongo Db Delete Many    refund_db    refund_journal    ${filter}
    Should Be Equal As Strings
    ...    ${result['status_code']}
    ...    0
    ...    Refund Mng Cleaner - Failed while deleting refund_journal by refundData.userId

Topup Mng Mongo Db Cleaner
    [Tags]    robot:private
    [Arguments]    ${bad_user_id}
    # No Longer Available

    ${filter}    Create Dictionary    debtor.userId    ${bad_user_id}    paymentGateway    CPG
    ${result}    Mongo Db Delete Many    topup_db    top_ups    ${filter}
    Should Be Equal As Strings
    ...    ${result['status_code']}
    ...    0
    ...    Topup Mng Cleaner - Failed while deleting top_ups by debtor.userId and paymentGateway=CPG

Debt Collection Mng Mongo Db Cleaner
    [Tags]    robot:private
    [Arguments]
    ...    ${bad_user_id}
    ...    ${cell_number}=${cell_number}
    ...    ${national_code}=${national_code}
    ...    ${credit_ids}=${credit_ids}

    ${collections}    Create List
    ...    credit_account
    ...    credit_activation
    ...    credit_contract
    ...    credit_installment
    ...    credit_payment_order
    ...    debt_case
    ...    debt_installment_integrations
    ...    debt_integration

    ${keys}    Create List
    IF    '${bad_user_id}' != '${EMPTY}' and '${bad_user_id}' != 'None'
        ${key}    Create Dictionary    field=userId    value=${bad_user_id}
        Append To List    ${keys}    ${key}
    END
    IF    '${cell_number}' != '${EMPTY}' and '${cell_number}' != 'None'
        ${key}    Create Dictionary    field=cellNumber    value=${cell_number}
        Append To List    ${keys}    ${key}
    END
    IF    '${national_code}' != '${EMPTY}' and '${national_code}' != 'None'
        ${key}    Create Dictionary    field=nationalCode    value=${national_code}
        Append To List    ${keys}    ${key}
    END

    ${length}    Get Length    ${credit_ids}
    IF    '${length}'!='0'
        FOR    ${credit_id}    IN    @{credit_ids}
            ${key}    Create Dictionary    field=creditId    value=${credit_id}
            Append To List    ${keys}    ${key}
        END
    END

    FOR    ${collection}    IN    @{collections}
        FOR    ${key}    IN    @{keys}
            ${field}    Set Variable    ${key['field']}
            ${value}    Set Variable    ${key['value']}
            ${filter}    Create Dictionary    ${field}    ${value}
            ${result}    Mongo Db Delete Many    debt_collection_db    ${collection}    ${filter}
            Should Be Equal As Strings
            ...    ${result['status_code']}
            ...    0
            ...    Debt Collection Cleaner - Failed deleting from ${collection} where ${field}=${value}
        END
    END

Credit Account Mng Mongo Db Cleaner
    [Tags]    robot:private
    [Arguments]    ${bad_user_id}

    ${filter}    Create Dictionary    userId    ${bad_user_id}
    ${segment_filter}    Create Dictionary    userId    ${bad_user_id}
    ${result}    Mongo Db Delete Many    credit-account-mng_db    accounts    ${filter}
    Should Be Equal As Strings
    ...    ${result['status_code']}
    ...    0
    ...    Credit Account Cleaner - Failed deleting from accounts by userId

    ${result}    Mongo Db Delete Many    credit-account-mng_db    segments    ${segment_filter}
    Should Be Equal As Strings
    ...    ${result['status_code']}
    ...    0
    ...    Credit Account Cleaner - Failed deleting from segments by creditId

    ${result}    Mongo Db Delete Many    credit-account-mng_db    credit_allocations    ${filter}
    Should Be Equal As Strings
    ...    ${result['status_code']}
    ...    0
    ...    Credit Account Cleaner - Failed deleting from credit_allocations by userId

    ${result}    Mongo Db Delete Many    credit-account-mng_db    credit_wallet_deactivations    ${filter}
    Should Be Equal As Strings
    ...    ${result['status_code']}
    ...    0
    ...    Credit Account Cleaner - Failed deleting from credit_wallet_deactivations by userId

Report Mng Mongo Db Cleaner
    [Tags]    robot:private
    [Arguments]    ${bad_user_id}

    ${filter_activities}    Create Dictionary    owner.username    ${bad_user_id}
    ${result}    Mongo Db Delete Many    report_mng_db    activities    ${filter_activities}
    Should Be Equal As Strings
    ...    ${result['status_code']}
    ...    0
    ...    Report Mng Cleaner - Failed while deleting activities by owner.username

    ${filter_dashboard}    Create Dictionary    owners    ${bad_user_id}
    ${result}    Mongo Db Delete Many    report_mng_db    dashboard_transactions    ${filter_dashboard}
    Should Be Equal As Strings
    ...    ${result['status_code']}
    ...    0
    ...    Report Mng Cleaner - Failed while deleting dashboard_transactions by owners

    ${filter_user_tx}    Create Dictionary    owners    ${bad_user_id}
    ${result}    Mongo Db Delete Many    report_mng_db    user_transactions    ${filter_user_tx}
    Should Be Equal As Strings
    ...    ${result['status_code']}
    ...    0
    ...    Report Mng Cleaner - Failed while deleting user_transactions by owners

Revolving Mongo Db Cleaner
    [Tags]    robot:private
    [Arguments]    ${bad_user_id}

    ${filter}    Create Dictionary    userId    ${bad_user_id}
    ${result}    Mongo Db Delete Many    revolving_db    revolves    ${filter}
    Should Be Equal As Strings
    ...    ${result['status_code']}
    ...    0
    ...    Revolving Cleaner - Failed while deleting revolves by userId

Credit Mng Mongo Db Cleaner
    [Tags]    robot:private
    [Arguments]    ${bad_user_id}

    ${filter_1}    Create Dictionary    debtor.userId    ${bad_user_id}
    ${result}    Mongo Db Delete Many    credit_mng_db    purchases    ${filter_1}
    Should Be Equal As Strings
    ...    ${result['status_code']}
    ...    0
    ...    Credit Mng Cleaner - Failed while deleting purchases by debtor.userId

    ${result}    Mongo Db Delete Many    credit_mng_db    prepayments    ${filter_1}
    Should Be Equal As Strings
    ...    ${result['status_code']}
    ...    0
    ...    Credit Mng Cleaner - Failed while deleting prepayments by debtor.userId

    ${result}    Mongo Db Delete Many    credit_mng_db    reverses    ${filter_1}
    Should Be Equal As Strings
    ...    ${result['status_code']}
    ...    0
    ...    Credit Mng Cleaner - Failed while deleting reverses by debtor.userId

    ${result}    Mongo Db Delete Many    credit_mng_db    early_settlements    ${filter_1}
    Should Be Equal As Strings
    ...    ${result['status_code']}
    ...    0
    ...    Credit Mng Cleaner - Failed while deleting early_settlements by debtor.userId

    ${filter_2}    Create Dictionary    userId    ${bad_user_id}
    ${result}    Mongo Db Delete Many    credit_mng_db    billing_cycles    ${filter_2}
    Should Be Equal As Strings
    ...    ${result['status_code']}
    ...    0
    ...    Credit Mng Cleaner - Failed while deleting billing_cycles by userId

    ${result}    Mongo Db Delete Many    credit_mng_db    contracts    ${filter_2}
    Should Be Equal As Strings
    ...    ${result['status_code']}
    ...    0
    ...    Credit Mng Cleaner - Failed while deleting contracts by userId

    ${filter_3}    Create Dictionary    creditor.userId    ${bad_user_id}
    ${result}    Mongo Db Delete Many    credit_mng_db    refunds    ${filter_3}
    Should Be Equal As Strings
    ...    ${result['status_code']}
    ...    0
    ...    Credit Mng Cleaner - Failed while deleting refunds by creditor.userId

    ${filter_4}    Create Dictionary    user.userId    ${bad_user_id}
    ${result}    Mongo Db Delete Many    credit_mng_db    credit_residues    ${filter_4}
    Should Be Equal As Strings
    ...    ${result['status_code']}
    ...    0
    ...    Credit Mng Cleaner - Failed while deleting credit_residues by user.userId

Switch Credit Mongo Db Cleaner
    [Tags]    robot:private
    [Arguments]    ${bad_user_id}    ${cell_number}

    ${filter_user}    Create Dictionary    userId    ${bad_user_id}
    ${result}    Mongo Db Delete Many    switch_credit_db    activations    ${filter_user}
    Should Be Equal As Strings
    ...    ${result['status_code']}
    ...    0
    ...    Switch Credit Cleaner - Failed while deleting activations by userId

    ${result}    Mongo Db Delete Many    switch_credit_db    purchases    ${filter_user}
    Should Be Equal As Strings
    ...    ${result['status_code']}
    ...    0
    ...    Switch Credit Cleaner - Failed while deleting purchases by userId

    ${result}    Mongo Db Delete Many    switch_credit_db    send_sms_restriction    ${filter_user}
    Should Be Equal As Strings
    ...    ${result['status_code']}
    ...    0
    ...    Switch Credit Cleaner - Failed while deleting send_sms_restriction by userId

    ${result}    Mongo Db Delete Many    switch_credit_db    volunteers    ${filter_user}
    Should Be Equal As Strings
    ...    ${result['status_code']}
    ...    0
    ...    Switch Credit Cleaner - Failed while deleting volunteers by userId

    ${filter_cell}    Create Dictionary    cellNumber    ${cell_number}
    ${result}    Mongo Db Delete Many    switch_credit_db    allocation_prepayment    ${filter_cell}
    Should Be Equal As Strings
    ...    ${result['status_code']}
    ...    0
    ...    Switch Credit Cleaner - Failed while deleting allocation_prepayment by cellNumber

    ${result}    Mongo Db Delete Many    switch_credit_db    register_journals    ${filter_cell}
    Should Be Equal As Strings
    ...    ${result['status_code']}
    ...    0
    ...    Switch Credit Cleaner - Failed while deleting register_journals by cellNumber

Switch Credit Mysql Cleaner
    [Tags]    robot:private
    [Arguments]    ${bad_user_id}

    ${result}    MySQL Execute Query
    ...    switch_credit_db
    ...    update switch_credit_db.accounts set cheque_detail_id = null where user_id in (select id from switch_credit_db.users where users.user_id = '${bad_user_id}')
    Should Be Equal As Strings
    ...    ${result['status_code']}
    ...    0
    ...    Switch Credit Mysql Cleaner - Failed while updating cheque_detail_id

    ${result}    MySQL Execute Query
    ...    switch_credit_db
    ...    delete from switch_credit_db.cheque_details where account_id in (select id from switch_credit_db.accounts where user_id in (select id from switch_credit_db.users where users.user_id = '${bad_user_id}'))
    Should Be Equal As Strings
    ...    ${result['status_code']}
    ...    0
    ...    Switch Credit Mysql Cleaner - Failed while deleting cheque_details

    ${result}    MySQL Execute Query
    ...    switch_credit_db
    ...    delete from switch_credit_db.account_blocking_journals where account_id in (select id from switch_credit_db.accounts where user_id in (select id from switch_credit_db.users where users.user_id = '${bad_user_id}'))
    Should Be Equal As Strings
    ...    ${result['status_code']}
    ...    0
    ...    Switch Credit Mysql Cleaner - Failed while deleting account_blocking_journals

    ${result}    MySQL Execute Query
    ...    switch_credit_db
    ...    delete from switch_credit_db.bank_accounts where account_id in (select id from switch_credit_db.accounts where user_id in (select id from switch_credit_db.users where users.user_id = '${bad_user_id}'))
    Should Be Equal As Strings
    ...    ${result['status_code']}
    ...    0
    ...    Switch Credit Mysql Cleaner - Failed while deleting bank_accounts

    ${result}    MySQL Execute Query
    ...    switch_credit_db
    ...    delete from switch_credit_db.e_notes where account_id in (select id from switch_credit_db.accounts where user_id in (select id from switch_credit_db.users where users.user_id = '${bad_user_id}'))
    Should Be Equal As Strings
    ...    ${result['status_code']}
    ...    0
    ...    Switch Credit Mysql Cleaner - Failed while deleting e_notes

    ${result}    MySQL Execute Query
    ...    switch_credit_db
    ...    delete from switch_credit_db.accounts where user_id in (select id from switch_credit_db.users where users.user_id = '${bad_user_id}')
    Should Be Equal As Strings
    ...    ${result['status_code']}
    ...    0
    ...    Switch Credit Mysql Cleaner - Failed while deleting accounts

Installment Mysql Cleaner
    [Tags]    robot:private
    [Arguments]    ${bad_user_id}    ${cell_number}=${cell_number}

    ${result}    MySQL Execute Query
    ...    installment_db
    ...    delete from installment_db.ipg_routes_info where payment_detail_id in (select id from installment_db.payment_details where payment_order_id in (select id from installment_db.payment_orders where contract_id in (select id from installment_db.contracts c where account_id in (select id from installment_db.accounts a where user_id = (select id from installment_db.users u where u.user_id = '${bad_user_id}')))));
    Should Be Equal As Strings
    ...    ${result['status_code']}
    ...    0
    ...    Installment Mysql Cleaner - Failed deleting ipg_routes_info

    ${result}    MySQL Execute Query
    ...    installment_db
    ...    delete from installment_db.payment_details where payment_order_id in (select id from installment_db.payment_orders where contract_id in (select id from installment_db.contracts c where account_id in (select id from installment_db.accounts a where user_id = (select id from installment_db.users u where u.user_id = '${bad_user_id}'))));
    Should Be Equal As Strings
    ...    ${result['status_code']}
    ...    0
    ...    Installment Mysql Cleaner - Failed deleting payment_details

    ${result}    MySQL Execute Query
    ...    installment_db
    ...    delete from installment_db.manual_payment_events where payment_order_id in (select id from installment_db.payment_orders where contract_id in (select id from installment_db.contracts c where account_id in (select id from installment_db.accounts a where user_id = (select id from installment_db.users u where u.user_id = '${bad_user_id}'))));
    Should Be Equal As Strings
    ...    ${result['status_code']}
    ...    0
    ...    Installment Mysql Cleaner - Failed deleting manual_payment_events

    ${result}    MySQL Execute Query
    ...    installment_db
    ...    delete from installment_db.manual_payment_statements where payment_order_id in (select id from installment_db.payment_orders where contract_id in (select id from installment_db.contracts c where account_id in (select id from installment_db.accounts a where user_id = (select id from installment_db.users u where u.user_id = '${bad_user_id}'))));
    Should Be Equal As Strings
    ...    ${result['status_code']}
    ...    0
    ...    Installment Mysql Cleaner - Failed deleting manual_payment_statements by order

    ${result}    MySQL Execute Query
    ...    installment_db
    ...    delete from installment_db.payment_orders where contract_id in (select id from installment_db.contracts c where account_id in (select id from installment_db.accounts a where user_id = (select id from installment_db.users u where u.user_id = '${bad_user_id}')));
    Should Be Equal As Strings
    ...    ${result['status_code']}
    ...    0
    ...    Installment Mysql Cleaner - Failed deleting payment_orders

    ${result}    MySQL Execute Query
    ...    installment_db
    ...    delete from installment_db.payment_order_reports where contract_id in (select id from installment_db.contracts c where account_id in (select id from installment_db.accounts a where user_id = (select id from installment_db.users u where u.user_id = '${bad_user_id}')));
    Should Be Equal As Strings
    ...    ${result['status_code']}
    ...    0
    ...    Installment Mysql Cleaner - Failed deleting payment_order_reports by contract

    ${result}    MySQL Execute Query
    ...    installment_db
    ...    delete from installment_db.notification_info where contract_id in (select id from installment_db.contracts c where account_id in (select id from installment_db.accounts a where user_id = (select id from installment_db.users u where u.user_id = '${bad_user_id}')));
    Should Be Equal As Strings
    ...    ${result['status_code']}
    ...    0
    ...    Installment Mysql Cleaner - Failed deleting notification_info

    ${result}    MySQL Execute Query
    ...    installment_db
    ...    delete from installment_db.prepayments where contract_id in (select id from installment_db.contracts c where account_id in (select id from installment_db.accounts a where user_id = (select id from installment_db.users u where u.user_id = '${bad_user_id}')));
    Should Be Equal As Strings
    ...    ${result['status_code']}
    ...    0
    ...    Installment Mysql Cleaner - Failed deleting prepayments

    ${result}    MySQL Execute Query
    ...    installment_db
    ...    delete from installment_db.contract_journals where contract_id in (select id from installment_db.contracts c where account_id in (select id from installment_db.accounts a where user_id = (select id from installment_db.users u where u.user_id = '${bad_user_id}')));
    Should Be Equal As Strings
    ...    ${result['status_code']}
    ...    0
    ...    Installment Mysql Cleaner - Failed deleting contract_journals

    ${result}    MySQL Execute Query
    ...    installment_db
    ...    delete from installment_db.contract_restrictions where contract_id in (select id from installment_db.contracts c where account_id in (select id from installment_db.accounts a where user_id = (select id from installment_db.users u where u.user_id = '${bad_user_id}')));
    Should Be Equal As Strings
    ...    ${result['status_code']}
    ...    0
    ...    Installment Mysql Cleaner - Failed deleting contract_restrictions

    ${result}    MySQL Execute Query
    ...    installment_db
    ...    delete from installment_db.internal_installments where contract_id in (select id from installment_db.contracts c where account_id in (select id from installment_db.accounts a where user_id = (select id from installment_db.users u where u.user_id = '${bad_user_id}')));
    Should Be Equal As Strings
    ...    ${result['status_code']}
    ...    0
    ...    Installment Mysql Cleaner - Failed deleting contracts


    ${result}    MySQL Execute Query
    ...    installment_db
    ...    delete from installment_db.contracts c where account_id in (select id from installment_db.accounts a where user_id = (select id from installment_db.users u where u.user_id = '${bad_user_id}'));
    Should Be Equal As Strings
    ...    ${result['status_code']}
    ...    0
    ...    Installment Mysql Cleaner - Failed deleting contracts

    ${result}    MySQL Execute Query
    ...    installment_db
    ...    delete from installment_db.accounts a where user_id = (select id from installment_db.users u where u.user_id = '${bad_user_id}');
    Should Be Equal As Strings    ${result['status_code']}    0    Installment Mysql Cleaner - Failed deleting accounts

    ${result}    MySQL Execute Query
    ...    installment_db
    ...    delete from installment_db.credit_links a where user_id = (select id from installment_db.users u where u.user_id = '${bad_user_id}');
    Should Be Equal As Strings
    ...    ${result['status_code']}
    ...    0
    ...    Installment Mysql Cleaner - Failed deleting credit_links

    ${result}    MySQL Execute Query    installment_db
    ...    delete from installment_db.users u where u.user_id = '${bad_user_id}';
    Should Be Equal As Strings    ${result['status_code']}    0    Installment Mysql Cleaner - Failed deleting users

    ${result}    MySQL Execute Query
    ...    installment_db
    ...    delete from installment_db.manual_payment_events where manual_payment_statement_id in (select id from installment_db.manual_payment_statements where user_id in (select id from installment_db.user_details where cell_number = '${cell_number}'));
    Should Be Equal As Strings
    ...    ${result['status_code']}
    ...    0
    ...    Installment Mysql Cleaner - Failed deleting manual_payment_events by cell_number

    ${result}    MySQL Execute Query
    ...    installment_db
    ...    delete from installment_db.manual_payment_statements where user_id in (select id from installment_db.user_details where cell_number = '${cell_number}');
    Should Be Equal As Strings
    ...    ${result['status_code']}
    ...    0
    ...    Installment Mysql Cleaner - Failed deleting manual_payment_statements by cell_number

    ${result}    MySQL Execute Query    installment_db
    ...    delete from installment_db.user_details where cell_number = '${cell_number}';
    Should Be Equal As Strings
    ...    ${result['status_code']}
    ...    0
    ...    Installment Mysql Cleaner - Failed deleting user_details

Residue Mng Mongo Db Cleaner
    [Tags]    robot:private
    [Arguments]    ${bad_user_id}

    ${filter_collections}    Create Dictionary    userId    ${bad_user_id}
    ${result}    Mongo Db Delete Many    residue_mng_db    credit_residue_collections    ${filter_collections}
    Should Be Equal As Strings
    ...    ${result['status_code']}
    ...    0
    ...    Residue Mng Mongo Db Cleaner - Failed deleting credit_residue_collections

    ${filter_residues}    Create Dictionary    user.userId    ${bad_user_id}
    ${result}    Mongo Db Delete Many    residue_mng_db    credit_residues    ${filter_residues}
    Should Be Equal As Strings
    ...    ${result['status_code']}
    ...    0
    ...    Residue Mng Mongo Db Cleaner - Failed deleting credit_residues

Clean User Account
    [Arguments]    ${bad_user_id}    ${as_suite_variable}=False

    Should Not Be Empty    ${bad_user_id}    User ID cannot be empty
    Should Not Contain    ${bad_user_id}    *    User ID cannot contain '*'
    Should Not Contain    ${bad_user_id}    ;    User ID cannot contain SQL separator ';'
    Should Match Regexp
    ...    ${bad_user_id}
    ...    ^[A-Za-z0-9_-]+$
    ...    User ID must only contain letters, digits, underscores, or hyphens

    Get User Details And Credit IDs    bad_user_id=${bad_user_id}    as_suite_variable=${as_suite_variable}
    Reproduce Amount    bad_user_id=${bad_user_id}
    Installment Mysql Cleaner    bad_user_id=${bad_user_id}
    Switch Credit Mysql Cleaner    bad_user_id=${bad_user_id}
    Switch Credit Mongo Db Cleaner    bad_user_id=${bad_user_id}    cell_number=${cell_number}
    Credit Mng Mongo Db Cleaner    bad_user_id=${bad_user_id}
    Residue Mng Mongo Db Cleaner    bad_user_id=${bad_user_id}
    Revolving Mongo Db Cleaner    bad_user_id=${bad_user_id}
    Report Mng Mongo Db Cleaner    bad_user_id=${bad_user_id}
    Credit Account Mng Mongo Db Cleaner    bad_user_id=${bad_user_id}
    Wallet Provider Mongo Db Cleaner    bad_user_id=${bad_user_id}
    Refund Mng Mongo Db Cleaner    bad_user_id=${bad_user_id}
    # Topup Mng Mongo Db Cleaner    bad_user_id=${bad_user_id}
    Debt Collection Mng Mongo Db Cleaner
    ...    bad_user_id=${bad_user_id}
    ...    cell_number=${cell_number}
    ...    national_code=${national_code}
    ...    credit_ids=${credit_ids}
