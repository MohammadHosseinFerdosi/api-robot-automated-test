*** Settings ***
Variables       data/gl/gl.yaml
Resource        apis/gl/incoming-transactions/post-financial-transactions-manual.resource
Resource        services/db/mysql-db-service.resource
Library         DateTime



*** Keywords ***
Create A Transaction
    [Documentation]    Create Financial Transaction

    [Arguments]
    ...    ${event_code}
    ...    ${inner_json}

    ${transaction_request_id} =    Generate Random Request Id
    IF  not '${transaction_request_id}'
        Fail    request_id was not generated
    END    


    ${response}    Post create Financial Transaction    ${MICROSERVICE_SIDE} 
    ...    ${event_code}
    ...    ${inner_json}
    ...    ${transaction_request_id}
    ...    ${PARENT_EVENT_CODE}
    ...    ${AMOUNT}
    ...    ${CLIENT_ID}
    ...    ${USER_ID}
    ...    ${COOKIE} 

    Should Be Equal As Integers
    ...    ${response.status_code}
    ...    200
    ...    msg=❌ HTTP Status must be 200 but was ${response.status_code}. Response body: ${response['body']}
    Set Test Variable    ${response}




Transaction Should Be Present In The Transaction Table

    ${transaction_request_id}=  Set Variable     ${response['body']['response']['requestId']}   
    ${query}=    Set Variable
    ...    SELECT * FROM transaction_req WHERE request_id = %s

    ${params}=    Create List    ${transaction_request_id}

    ${result}=    MySQL Fetch All
    ...    general_ledger_db
    ...    ${query}
    ...    ${params}


    Should Be Equal As Integers    
    ...    ${result['status_code']}    
    ...    0
    ...    msg=❌ Database query execution failed. Expected DB status_code=0 but got ${result['status_code']}.

    Should Not Be Empty           
    ...    ${result['body']}
    ...    msg=❌ Transaction table must not be empty. Full response: ${result}

    ${transaction_id}=    Set Variable    ${result['body'][0]['id']}
    Set Test Variable    ${transaction_id}




Transaction Should Be Present In The Voucher Table

    ${query}=    Set Variable
    ...    SELECT * FROM voucher where f_transaction_req = %s

    ${params}=    Create List    ${transaction_id}

    ${result}=    MySQL Fetch All
    ...    general_ledger_db
    ...    ${query}
    ...    ${params}


    Should Be Equal As Integers    
    ...    ${result['status_code']}    
    ...    0
    ...    msg=❌ Database query execution failed. Expected DB status_code=0 but got ${result['status_code']}.

    Should Not Be Empty           
    ...    ${result['body']}
    ...    msg=❌ Voucher table must not be empty. Full response: ${result}


    ${transaction_voucher_id}=    Set Variable    ${result['body'][0]['id']}
    Set Test Variable  ${transaction_voucher_id}  




Transaction Should Be Present In The Article Table    

    ${query}=    Set Variable
    ...    SELECT * FROM article where f_voucher = %s

    ${params}=    Create List    ${transaction_voucher_id}

    ${result}=    MySQL Fetch All
    ...    general_ledger_db
    ...    ${query}
    ...    ${params}

    Should Be Equal As Integers    
    ...    ${result['status_code']}    
    ...    0
    ...    msg=❌ Database query execution failed. Expected DB status_code=0 but got ${result['status_code']}.

    Should Not Be Empty           
    ...    ${result['body']}
    ...    msg=❌ Article table must not be empty. Full response: ${result}




Generate Random Request Id

    ${uuid}=    Evaluate    __import__('uuid').uuid4().hex   
    ${transaction_request_id}=        Set Variable    ${uuid}
    RETURN  ${transaction_request_id}




Amount Should Be Correct
   
        Should Be Equal As Integers    
    ...    ${response['body']['voucher']['transactionRequest']['amount']}   
    ...    ${AMOUNT}
    ...    msg=❌ Amount should be ${AMOUNT} but it is ${response['body']['voucher']['transactionRequest']['amount']}.