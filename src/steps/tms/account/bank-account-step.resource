*** Settings ***
Variables       data/tms/treasury-statment-variables.yaml
Resource        apis/tms/accounts/api-admin-bank-accounts.resource
Resource        services/db/postgres-db-service.resource


*** Keywords ***
create a account
    [Documentation]    create bank account
    ${response}    Post create bank accounts    ${MICROSERVICE_SIDE}
    ...    ${account_Number}
    ...    ${account_TypeId}
    ...    ${bank_Id}
    ...    ${branch_Id}
    ...    ${project_Id}
    ...    ${minimum_Balance}
    ...    ${maximum_Balance}
    ...    ${rahkaranDetailed_AccountCode}
    ...    ${account_CodeId}
    ...    ${iban}
    ...    ${description}

    Should Be Equal As Integers    ${response['status_code']}    200
    ${deliver-to-post_RESULT}    Set Variable    body = response.get('body', 'No body available')

Check In Db Reserve
    ${result}    POSTGRES Fetch All
    ...    db_name=${TCM_DB_NAME}
    ...    query=SELECT * FROM "BankAccounts" WHERE "AccountNumber" = '${accountNumber}'

    ${body}    Get From Dictionary    ${result}    body

    Length Should Be    ${body}    1    msg=❌ Bank account ${accountNumber} not found in DB

    
Check In Db Delete Reserve
    ${deleteResult}    POSTGRES Execute Query
    ...    db_name=${TCM_DB_NAME}
    ...    query=DELETE FROM "BankAccounts" WHERE "AccountNumber" = '${accountNumber}'

    ${result}    POSTGRES Fetch All
    ...    db_name=${TCM_DB_NAME}
    ...    query=SELECT * FROM "BankAccounts" WHERE "AccountNumber" = '${accountNumber}'

    ${body}    Get From Dictionary    ${result}    body

     Run Keyword If    ${body}    Fail    ❌ Account ${accountNumber} already exists in DB
