*** Settings ***
Library         String
Library         Collections
Library         RequestsLibrary
Library         JSONLibrary
Resource        services/backend/session-service.resource
Resource        services/backend/auth-service.resource

*** Keywords ***
POST Merchant Register
    ${random_string}    Generate Random String    10
    [Arguments]
    ...    ${api_call_side}
    ...    ${type}
    ...    ${settlement_bucket}
    ...    ${name}
    ...    ${national_code}
    ...    ${cell_number} 
    ...    ${register_cell_number}

    ${dic_body}       Create Dictionary
    ...    providerId=${random_string}
    ...    type=${type}
    ...    settlementBucket=${settlement_bucket}
    ...    name=${name}
    ...    nationalCode=${national_code}

    ${agent_dict} =    Create Dictionary    
    ...    name=${name}
    ...    cellNumber=${cell_number}  
    ...    email=Test1.Test@gmail.com
    ...    registerCellNumber=${register_cell_number}

    Set To Dictionary    ${dic_body}    agent=${agent_dict}
 

    ${session}    Create A Session    ${api_call_side}
    ${response}    POST On Session
    ...    ${session}
    ...    /credit/merchants/register
    ...    json=${dic_body}
    ...    expected_status=any
    ${result}    Create Dictionary    status_code=${response.status_code}    body=${response.json()}
    RETURN    ${result}

    [Teardown]    Delete A Session    ${session}