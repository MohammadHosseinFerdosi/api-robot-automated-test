*** Settings ***
Variables       data/gl/gl.yaml
Resource        apis/gl/detailed-code-mangement/post-without-rahkaran-codes.resource
Resource        apis/gl/detailed-code-mangement/post-suspend-merchant.resource
Resource        apis/gl/detailed-code-mangement/post-get-suspended-list.resource
Resource        services/db/mysql-db-service.resource
Library         DateTime

*** Variables ***
${business_name}    ${EMPTY}


*** Keywords ***
Get All Merchants Without Rahkaran Codes
  
    ${size}=    Set Variable    250
    ${page}=    Set Variable    0
    ${all_merchants}=    Create List

    # ---page 0 ---
    ${response}=    POST search merchants without rahkaran code
    ...    ${MICROSERVICE_SIDE}
    ...    ${page}
    ...    ${size}

    Should Be Equal As Integers    ${response.status_code}    200

    ${body}=    Set Variable    ${response.body}
    ${totalPages}=    Get From Dictionary    ${body}    totalPages
    ${merchants}=     Get From Dictionary    ${body}    profileMappings

    Append To List    ${all_merchants}    @{merchants}

    # --- other pages ---
    FOR    ${page}    IN RANGE    1    ${totalPages}

        ${response}=    POST search merchants without rahkaran code
        ...    ${MICROSERVICE_SIDE}
        ...    ${page}
        ...    ${size}

        Should Be Equal As Integers    ${response.status_code}    200

        ${body}=    Set Variable    ${response.body}
        ${merchants}=    Get From Dictionary    ${body}    profileMappings

        Append To List    ${all_merchants}    @{merchants}
    END

    ${count}=    Get Length    ${all_merchants}

    ${merchants-without-rahkaran-codes}    Set Variable    ${all_merchants} 
    Set Test Variable    ${merchants-without-rahkaran-codes}     




No Merchant Record Exists Without A Detailed Code

    ${invalid_merchants}=    Create List

    FOR    ${item}    IN    @{merchants-without-rahkaran-codes}
    ${has_key}=    Run Keyword And Return Status
    ...    Dictionary Should Contain Key    ${item}    rahkaranCode

    IF    ${has_key}
            ${value}=    Get From Dictionary    ${item}    rahkaranCode
            IF    '${value}' != '' and '${value}' != 'None'
                Append To List    ${invalid_merchants}    ${item}
            END
        END
    END

    Should Be Empty    ${invalid_merchants}




Get Random Merchant

    Should Not Be Empty    ${merchants-without-rahkaran-codes}    msg=❌ Merchant list is empty. Cannot select random merchant for filtering.

    ${random_merchant}=    Evaluate    random.choice(${merchants-without-rahkaran-codes})    modules=random
    ${business_name}=      Get From Dictionary    ${random_merchant}    businessName
    Set Test Variable    ${random_merchant}
    Set Suite Variable    ${business_name}




Filter Merchants By Name

    ${restriction}=    Create Dictionary
    ...    type=simple
    ...    field=businessName
    ...    value=${business_name}
    ...    operation=eq

    ${restrictions}=    Create List    ${restriction}

    ${order}=    Create Dictionary
    ...    field=creationDate
    ...    order=desc

    ${orders}=    Create List    ${order}

    ${payload}=    Create Dictionary
    ...    restrictions=${restrictions}
    ...    orders=${orders}


    ${result}=    POST search merchants without rahkaran code
    ...    ${MICROSERVICE_SIDE}    
    ...    page=0    
    ...    size=250    
    ...    payload=${payload}

    Should Be Equal As Integers
    ...    ${result['status_code']}
    ...    200
    ...    msg=❌ Filter API call failed. Status=${result['status_code']}

    ${output}=    Create Dictionary
    ...    merchants=${result['body']['profileMappings']}
    ...    merchant=${random_merchant}

    ${filtered_merchants}    Set Variable    ${output} 
    Set Test Variable    ${filtered_merchants}   




Filtered Merchants Must Contain The Name
    
    ${merchants}=    Set Variable    ${filtered_merchants.merchants}
    ${random_merchant}=    Set Variable    ${filtered_merchants.merchant}

    FOR    ${merchant}    IN    @{merchants}
        ${business_name}=    Get From Dictionary    ${merchant}    businessName
        Should Contain    ${business_name}    ${random_merchant['businessName']}
    END




Get Id Of Merchant

    ${query}=    Set Variable
    ...    SELECT id FROM biz_mapping WHERE biz_name = '${business_name}' AND f_profile IN (26, 12) ORDER BY f_profile DESC LIMIT 1

    ${result}=    MySQL Fetch All
    ...    general_ledger_db
    ...    ${query}

    Should Be Equal As Integers    
    ...    ${result['status_code']}    
    ...    0
    ...    msg=❌ Database query execution failed. Expected DB status_code=0 but got ${result['status_code']}.

    Should Not Be Empty           
    ...    ${result['body']}
    ...    msg=❌ Merchant ${business_name} does not exist. Full response: ${result}

    ${business_id}=    Set Variable    ${result['body'][0]['id']}
    Set Test Variable    ${business_id}   




Suspend Merchant

    ${response}=    POST suspend merchant 
    ...    ${MICROSERVICE_SIDE}    
    ...    ${business_id}    
    ...    True  

    Should Be Equal As Integers
    ...    ${response.status_code}
    ...    200
    ...    msg=❌ HTTP Status must be 200 but was ${response.status_code}. Response body: ${response['body']}
    Set Test Variable    ${response}




Suspended Merchant Should Not Be In 'Merchants Without Rahkaran' Menu


    Should Be Empty    ${filtered_merchants['merchants']}
        ...    message=❌ The 'Merchants without Rahkaran' menu still contains the business '${business_name}'. The suspension did not take effect as expected. Response is: ${filtered_merchants}




Filter Suspended Merchants By Name

    ${restriction}=    Create Dictionary
    ...    type=simple
    ...    field=businessName
    ...    value=${business_name}
    ...    operation=eq

    ${restrictions}=    Create List    ${restriction}

    ${order}=    Create Dictionary
    ...    field=creationDate
    ...    order=desc

    ${orders}=    Create List    ${order}

    ${payload}=    Create Dictionary
    ...    restrictions=${restrictions}
    ...    orders=${orders}


    ${result}=    POST get suspended list
    ...    ${MICROSERVICE_SIDE}    
    ...    page=0    
    ...    size=250    
    ...    payload=${payload}

    Should Be Equal As Integers
    ...    ${result['status_code']}
    ...    200
    ...    msg=❌ Filter API call failed. Status=${result['status_code']}

    ${output}=    Create Dictionary
    ...    merchants=${result['body']['profileMappings']}
    ...    merchant=${random_merchant}

    ${filtered_merchants}    Set Variable    ${output} 
    Set Test Variable    ${filtered_merchants}   




Suspended Merchant Should Be in 'Suspended Merchants' Menu

    Should Not Be Empty
    ...    ${filtered_merchants['merchants']}
    ...    msg=❌ The 'Suspended Merchants' menu is missing the business '${business_name}'. The suspension did not work as expected.




Unsuspend Merchant

    ${query}=    Set Variable
    ...    UPDATE biz_mapping SET suspended = NULL WHERE biz_name = '${business_name}';

    MySQL Fetch All
    ...    general_ledger_db
    ...    ${query} 