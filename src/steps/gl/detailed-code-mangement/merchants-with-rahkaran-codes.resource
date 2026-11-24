*** Settings ***
Variables       data/gl/gl.yaml
Resource        apis/gl/detailed-code-mangement/post-with-rahkaran-codes.resource
Resource        services/db/mysql-db-service.resource
Library         DateTime



*** Keywords ***
Get All Merchants With Rahkaran Codes

    ${size}=    Set Variable    250
    ${page}=    Set Variable    0
    ${all_merchants}=    Create List

    # ---page 0 ---
    ${response}=    POST search merchants with rahkaran code
    ...    ${MICROSERVICE_SIDE}
    ...    ${page}
    ...    ${size}

    Should Be Equal As Integers    ${response.status_code}    200

    ${body}=    Set Variable    ${response.body}
    ${totalPages}=    Get From Dictionary    ${body}    totalPages
    ${merchants}=     Get From Dictionary    ${body}    merchants

    Append To List    ${all_merchants}    @{merchants}

    # --- other pages ---
    FOR    ${page}    IN RANGE    1    ${totalPages}
        ${response}=    POST search merchants with rahkaran code
        ...    ${MICROSERVICE_SIDE}
        ...    ${page}
        ...    ${size}

        Should Be Equal As Integers    ${response.status_code}    200

        ${body}=    Set Variable    ${response.body}
        ${merchants}=    Get From Dictionary    ${body}    merchants

        Append To List    ${all_merchants}    @{merchants}
    END

    ${count}=    Get Length    ${all_merchants}

    ${merchants_with_rahkaran_codes}    Set Variable    ${all_merchants} 
    Set Test Variable    ${merchants_with_rahkaran_codes}




All Rahkaran Codes Must Consist Of Exactly Six Digits

    @{errors}=    Create List

    FOR    ${item}    IN    @{merchants_with_rahkaran_codes}
        ${rahkaranCode}=    Get From Dictionary    ${item}    rahkaranCode    default=None
        
        ${is_valid}=    Run Keyword And Return Status
        ...    Should Match Regexp    ${rahkaranCode}    ^[0-9]{6}$
        ...    Merchant "${item['businessName']}" has rahkaran code "${rahkaranCode}" – it must be exactly 6 digits.

        
        Run Keyword If     not ${is_valid}    Append To List    ${errors}    Merchant= ${item['businessName']}    rahkaran code= ${rahkaranCode}    
    END

    Run Keyword If    ${errors}
    ...    Fail    The following merchants have missing or invalid rahkaran codes:\n${errors}




Merchants With The Same National Code Must Have The Same Rahkaran Code

    ${mapping}=    Create Dictionary
    ${conflicts}=  Create List

    FOR    ${item}    IN    @{merchants_with_rahkaran_codes}

    ${national}=    Get From Dictionary    ${item}    nationalCode    default=None
    ${rahkaran}=    Get From Dictionary    ${item}    rahkaranCode    default=None

    ${national}=    Convert To String    ${national}
    ${rahkaran}=    Convert To String    ${rahkaran}
    ${national}=    Strip String    ${national}
    ${rahkaran}=    Strip String    ${rahkaran}

    ${exists}=    Evaluate    $national in $mapping

    IF    not ${exists}
        Set To Dictionary    ${mapping}    ${national}=${rahkaran}
    ELSE
        ${stored}=    Get From Dictionary    ${mapping}    ${national}
        IF    '${stored}' != '${rahkaran}'
            Append To List    ${conflicts}
            ...    nationalCode=${national} | expected=${stored} | actual=${rahkaran}
        END
    END
    END

    Should Be Empty    ${conflicts}
        ...    message=Conflicts found:\n${conflicts}




Filter Merchants By Desired Field

    [Arguments]
    ...    ${filtering_field}

    Should Not Be Empty    ${merchants_with_rahkaran_codes}    msg=❌ Merchant list is empty. Cannot select random merchant for filtering.

    ${random_merchant}=    Evaluate    random.choice(${merchants_with_rahkaran_codes})    modules=random
    ${filtering_value}=      Get From Dictionary    ${random_merchant}    ${filtering_field}


    ${restriction}=    Create Dictionary
    ...    type=simple
    ...    field=${filtering_field}
    ...    value=${filtering_value}
    ...    operation=eq

    ${restrictions}=    Create List    ${restriction}

    ${order}=    Create Dictionary
    ...    field=creationDate
    ...    order=desc

    ${orders}=    Create List    ${order}

    ${payload}=    Create Dictionary
    ...    restrictions=${restrictions}
    ...    orders=${orders}

    ${result}=    POST search merchants with rahkaran code
    ...    ${MICROSERVICE_SIDE}    
    ...    page=0    
    ...    size=250    
    ...    payload=${payload}

    Should Be Equal As Integers
    ...    ${result['status_code']}
    ...    200
    ...    msg=❌ Filter API call failed. Status=${result['status_code']}

    ${output}=    Create Dictionary
    ...    merchants=${result['body']['merchants']}
    ...    merchant=${random_merchant}
    ...    field=rahkaranCode
    
    ${filtered_merchants}    Set Variable    ${output}    
    Set Test Variable    ${filtered_merchants}




Filtered Merchants Must Contain The Desired Field

    ${merchants}=    Set Variable    ${filtered_merchants.merchants}
    ${random_merchant}=    Set Variable    ${filtered_merchants.merchant}
    ${field}=    Set Variable    ${filtered_merchants.field}


    FOR    ${merchant}    IN    @{merchants}
        ${business_field}=    Get From Dictionary    ${merchant}    ${field}
        Should Contain    ${business_field}    ${random_merchant['${field}']}
    END




All Merchants Must Have A National Code

    @{errors}=    Create List
    FOR    ${item}    IN    @{merchants_with_rahkaran_codes}
        ${national}=    Get From Dictionary    ${item}    nationalCode    default=None
        IF    $national == ""
            Append To List    ${errors}    ${item['businessName']}
        END
    END 
    
    Run Keyword If    ${errors}
    ...    Fail    The following merchants have missing national codes:\n${errors}