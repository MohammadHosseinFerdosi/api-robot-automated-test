*** Settings ***
Variables       data/tms/treasury-statment-variables.yaml
Variables       data/tms/Constants.yaml
Resource        apis/tms/accounts/manuall-collect.resource
Resource        services/db/postgres-db-service.resource


*** Keywords ***
Manuall Collect From Fetch Data
    Collect Manuall
    ...    BANK_ACCOUNT_NUMBER_TEJARAT=${BANK_ACCOUNT_NUMBER_TEJARAT_794}
    ...    TIME_FROM_TRANSFER=${TIME_FROM_TRANSFER_794}    
    ...    TIME_TO_TRANSFER=${TIME_TO_TRANSFER_794}    
    ...    ID_BANK_TEJARAT=${ID_BANK_TEJARAT}
    Collect Manuall
    ...    BANK_ACCOUNT_NUMBER_TEJARAT=${BANK_ACCOUNT_NUMBER_TEJARAT_794}    
    ...    TIME_FROM_TRANSFER=${TIME_FROM_INSTALLMENT_DEBIT_794}    
    ...    TIME_TO_TRANSFER=${TIME_TO_INSTALLMENT_DEBIT_794}    
    ...    ID_BANK_TEJARAT=${ID_BANK_TEJARAT}
    

Collect Manuall
    [Documentation]     Collect Manuall With Different Bodies
    [Arguments]    
    ...    ${BANK_ACCOUNT_NUMBER_TEJARAT}
    ...    ${ID_BANK_TEJARAT}
    ...    ${TIME_FROM_TRANSFER}
    ...    ${TIME_TO_TRANSFER}
    ${body}    Create Dictionary
    ...    bankid=${ID_BANK_TEJARAT}
    ...    bankAccountNumber=${BANK_ACCOUNT_NUMBER_TEJARAT}
    ...    from=${TIME_FROM_TRANSFER}
    ...    to=${TIME_TO_TRANSFER}

    ${response}    Post Manuall Collect
    ...    ${MICROSERVICE_SIDE}
    ...    ${body}
    Set Test Variable   ${status_code}    ${response['status_code']}
    RETURN    ${response} 

checking status manual collect

    Should Be Equal As Integers    ${status_code}    200

Update Activation Bankaccount

    ${Update_Result}    POSTGRES Execute Query
    ...    db_name=${TCM_DB_NAME}
    ...    query=UPDATE "BankAccounts" SET "IsActive"=TRUE WHERE "AccountNumber" = '${BANK_ACCOUNT_NUMBER_TEJARAT_794}'
    ${status_code}    Get From Dictionary    ${Update_Result}    status_code
    Should Be Equal As Integers    ${status_code}    0    There was an error in the update query.

Check In Database From Transaction Type
    ${Result_Bank_Fee}    POSTGRES Fetch All
    ...    db_name=${TCM_DB_NAME}
    ...    query=SELECT * FROM "Statements" WHERE "TrackingCode" = '${TRACKING_CODE_FROM_BANFEE_794}'

    ${body}    Get From Dictionary    ${Result_Bank_Fee}    body
    ${item}    Get From List    ${body}    0
    Dictionary Should Contain Key    ${item}    TransactionType
    Should Be Equal As Integers    ${item['TransactionType']}    ${TRANSACTION_TYPE_BANKFEE}


    ${Result_Reciept}    POSTGRES Fetch All
    ...    db_name=${TCM_DB_NAME}
    ...    query=SELECT * FROM "Statements" WHERE "TrackingCode" = '${TRACKING_CODE_FROM_RECIEPT_794}'

    ${body}    Get From Dictionary    ${Result_Reciept}    body
    ${item}    Get From List    ${body}    0
    Dictionary Should Contain Key    ${item}    TransactionType
    Should Be Equal As Integers    ${item['TransactionType']}    ${TRANSACTION_TYPE_RECIEPT}

    ${Result_Installment_Debit}    POSTGRES Fetch All
    ...    db_name=${TCM_DB_NAME}
    ...    query=SELECT * FROM "Statements" WHERE "TrackingCode" = '${TRACKING_CODE_FROM_INSTALLMENT_DEBIT_794}'

    ${body}    Get From Dictionary    ${Result_Installment_Debit}    body
    ${item}    Get From List    ${body}    0
    Dictionary Should Contain Key    ${item}    TransactionType
    Should Be Equal As Integers    ${item['TransactionType']}    ${TRANSACTION_TYPE_INSTALLMENT_DEBIT}

    ${Result_Transfer}    POSTGRES Fetch All
    ...    db_name=${TCM_DB_NAME}
    ...    query=SELECT * FROM "Statements" WHERE "TrackingCode" = '${TRACKING_CODE_FROM_TRANSFER_794}'

    ${body}    Get From Dictionary    ${Result_Transfer}    body
    ${item}    Get From List    ${body}    0
    Dictionary Should Contain Key    ${item}    TransactionType
    Should Be Equal As Integers    ${item['TransactionType']}    1

Delete Statment In Database
 
    ${Delete_result}    POSTGRES Execute Query
    ...    db_name=${TCM_DB_NAME}
    ...    query=DELETE FROM "Statements" WHERE "TrackingCode" IN ('${TRACKING_CODE_FROM_TRANSFER_794}','${TRACKING_CODE_FROM_BANFEE_794}','${TRACKING_CODE_FROM_RECIEPT_794}','${TRACKING_CODE_FROM_INSTALLMENT_DEBIT_794}');
    ${status_code}    Get From Dictionary    ${Delete_result}    status_code
    Should Be Equal As Integers    ${status_code}    0    There was an error in the update query.
