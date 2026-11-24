*** Settings ***
Resource    services/db/mongo-db-service.resource
Resource    services/db/mysql-db-service.resource


*** Keywords ***
Tejarat Bank Installment Initiate Handler
    [Documentation]    A handler for the tejarat bank installment initiation.
    [Tags]    robot:private
    [Arguments]
    ...    ${credit_id}
    ...    ${ECN}=${LMS_TB_Init_Installment_ECN_AUTOMATION}
    ...    ${FBAN}=${LMS_TB_Init_Installment_FBAN_AUTOMATION}
    ${select_query}    Set Variable
    ...    SELECT * FROM installment_db.accounts WHERE credit_id = "${credit_id}"
    ${result}    MySQL Fetch All    db_name=installment_db    query=${select_query}
    ${length}    Get Length    ${result['body']}
    Should Be Equal As Strings
    ...    first=${length}
    ...    second=1
    ...    msg=Expected to find 1 records in installment_db for the ${credit_id}, but got ${length}.

    ${update_query}    Set Variable
    ...    UPDATE installment_db.accounts SET external_contract_number = '${ECN}', facility_bank_account_number = '${FBAN}' WHERE credit_id = '${credit_id}'

    ${result}    MySQL Execute Query    db_name=installment_db    query=${update_query}
    Should Be Equal As Strings
    ...    '${result['status_code']}'
    ...    '0'
    ...    msg=Expected the update connection to installment mysql db to respond with status code 0, but got ${result['status_code']}

Initiate Installment
    [Documentation]    Initiate the installment. Update the external_contract_number and facility_bank_account_number from installment_db.
    ...    Based on the type of allocation and the fund_provider_code, The initiation may differ. Some implementations may not be available at the moment,
    ...    Hence you may see a Log message "Not Implemented. Initialization is ignored!" every now and then.
    ...
    ...    inputs:
    ...    
    ...    1. ${credit_id}: the credit id of the user you wish to initiated the installment on
    ...    
    ...    2. ${fp_code}: the fund provider code for the credit id, ['MELLAT', 'SADERAT_BANK', 'PLATFORM', 'TEJARAT_BANK', 'GARDESHGARI_BANK',  'COMPANY'].
    ...    
    ...    3. ${national_code}: the national code fo of the user, can be empty; only used for the MELLAT initiations .
    ...    
    ...    4. ${request_origin}: The origin of the request, whether it is AUTOMATION or APP.
    ...    
    ...    5. ${custom_ECN}: Used to overwrite the the External Contract Number default value based on the ${request_origin}
    ...    
    ...    6. ${custom_FBAN}: Used to overwrite the Facility Bank Account Number default value based on the ${request_origin}
    ...
    ...    TEJARAT_BANK: Is currently available to initiate and works.
    [Arguments]
    ...    ${credit_id}
    ...    ${fp_code}
    ...    ${national_code}=${EMPTY}
    ...    ${request_origin}=${ROBOT_AUTOMATION}
    ...    ${custom_ECN}=${LMS_TB_Init_Installment_ECN_AUTOMATION}
    ...    ${custom_FBAN}=${LMS_TB_Init_Installment_FBAN_AUTOMATION}

    IF    '${fp_code}'=='TEJARAT_BANK'
        IF    '${request_origin}'=='${ROBOT_AUTOMATION}'
            Wait Until Keyword Succeeds
            ...    2 minute
            ...    15 s
            ...    Tejarat Bank Installment Initiate Handler
            ...    credit_id=${credit_id}
            ...    ECN=${custom_ECN}
            ...    FBAN=${custom_FBAN}
        ELSE
            Wait Until Keyword Succeeds
            ...    2 minute
            ...    15 s
            ...    Tejarat Bank Installment Initiate Handler
            ...    credit_id=${credit_id}
            ...    ECN=${LMS_TB_Init_Installment_ECN_APP}
            ...    FBAN=${LMS_TB_Init_Installment_FBAN_APP}
        END
    END
