*** Settings ***
Library         String
Library         Collections
Library         RequestsLibrary
Library         JSONLibrary
Resource        services/backend/session-service.resource
Variables       data/merchant-credit/merchant-credit-variables.yaml


*** Keywords ***
PUT Max Amount
    [Arguments]    
    ...    ${Rticket}
    ...    ${api_call_side}
    ...    ${max_amount}    
    ...    ${credit_id}    
    ...    ${iban}=${EMPTY}


    IF  '${iban}'=='${EMPTY}'
            ${body}    Create Dictionary    
        ...    maxAmount=${max_amount}    
        ELSE
           ${body}    Create Dictionary    
        ...    maxAmount=${max_amount}    
        ...    iban=${iban}
    END
    
    ${header}    Create Dictionary    
     ...    ticket=${Rticket}    

    ${sesion}    Create A Session    ${api_call_side}
    ${response}    PUT On Session    
    ...    ${sesion}
    ...    /credit/merchants/${credit_id}/max-amount
    ...    headers=${header}
    ...    json=${body}
    ...    expected_status=any
    ${result_max_amount}    Create Dictionary    status_code=${response.status_code}    response_rule=${response.json()}
    RETURN    ${result_max_amount}

    [Teardown]    Delete A Session    ${sesion}