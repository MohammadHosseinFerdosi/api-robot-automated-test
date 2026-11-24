*** Settings ***
Variables       data/tms/treasury-statment-variables.yaml
Variables       data/tms/Constants.yaml
Resource        services/db/postgres-db-service.resource



*** Keywords ***
Update Database From Calculate Account

    ${update_bank}    POSTGRES Execute Query
    ...    db_name=${TCM_DB_NAME}
    ...    query=UPDATE "Banks" SET "CollectorRunsPerDay"='${ID_COLLECTOR_RUNS_PERDAY}' , "CollectorRunsBeforeMidday" = '${ID_COLLECTOR_RUNS_BEFORE_MIDDAY}' WHERE "Id"='${GARDESHGARI_BANK_ID}' 

   
    ${status_code}     Get From Dictionary   ${update_bank}    status_code
    Should Be Equal As Integers    ${status_code}    0    There was an error in the update query 


    ${update_account_balance_histories}    POSTGRES Execute Query
    ...    db_name=${TCM_DB_NAME}
    ...    query=UPDATE "AccountBalanceHistories" SET "EndOfDayBalance"= NULL,"TotalOutflowOfDay"= NULL,"TotalInflowOfDay"= NULL,"MinimumBalanceOfDay"=NULL , "Status"= '${STATUS_IN_ACCOUNT_BALANCE_HISTORY}' , "TryCount" = '${TRY_COUNT_IN_ACCOUNT_BALANCE_HISTORY}' WHERE "Id"='${ID_IN_ACCOUNT_BALANCE_HISTORY}' 

   
    ${status_code}     Get From Dictionary   ${update_account_balance_histories}    status_code
    Should Be Equal As Integers    ${status_code}    0    There was an error in the update query 


    ${update_bank_account}    POSTGRES Execute Query
    ...    db_name=${TCM_DB_NAME}
    ...    query=UPDATE "BankAccounts" SET "IsActive"=TRUE WHERE "Id"= '${GARDESHGARI_BANK_ACCOUNT_ID}' 

     ${status_code}     Get From Dictionary   ${update_bank_account}    status_code
    Should Be Equal As Integers    ${status_code}    0    There was an error in the update query 



Verify Calculation In Database
    Wait Until Keyword Succeeds    20x    12s
    ...    Check In Database To Succesfully Calculate



Check In Database To Succesfully Calculate
    ${result}    POSTGRES Fetch All
    ...    db_name=${TCM_DB_NAME}
    ...    query=SELECT * FROM "AccountBalanceHistories" WHERE "Id" = '${ID_IN_ACCOUNT_BALANCE_HISTORY}'

    ${body}    Get From Dictionary    ${result}    body
    Length Should Be    ${body}    1

    ${item}    Get From List    ${body}    0

    Dictionary Should Contain Key    ${item}    EndOfDayBalance
    Dictionary Should Contain Key    ${item}    TotalInflowOfDay
    Dictionary Should Contain Key    ${item}    TotalOutflowOfDay
    Dictionary Should Contain Key    ${item}    MinimumBalanceOfDay

    Should Be Equal As Numbers    ${item['EndOfDayBalance']}        ${END_OF_DAY_BALANCE}
    Should Be Equal As Numbers    ${item['TotalInflowOfDay']}       ${TOTAL_IN_FLOW_OF_DAY}
    Should Be Equal As Numbers    ${item['TotalOutflowOfDay']}      ${TOTAL_OUT_FLOW_OF_DAY}
    Should Be Equal As Numbers    ${item['MinimumBalanceOfDay']}    ${MINIMUM_BALANCE_OF_DAY}