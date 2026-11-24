*** Settings ***
Library         String
Library         Collections
Library         RequestsLibrary
Resource        services/backend/session-service.resource


*** Keywords ***
GET Account Summary CreditId From Credit Account Management
    [Documentation]    This API provides information about the status and details of a user's credit.
    ...    If the creditId status is Blocked, the response will include the blocking details—such as the applicant, timestamp, and reason—if available.


    ...    
    ...    Input variables are: 
    ...    
    ...    ${api_call_side}: This is the side where the api is going to be called.  This API only works with the ${MICROSERVICE_SIDE}. 
    ...    
    ...    ${creditId}: used in the request url of the API. 
    ...        
    [Arguments]    ${api_call_side}    ${creditId}

    ${api_path}    Set Variable   /accounts/${creditId}/summary
    IF    '${api_call_side}'=='${MICROSERVICE_SIDE}'
        ${api_path}    Set Variable    ${MICROSERVICE_BASE_URL}${MS_CREDIT_ACCOUNT_MNG_PATH}${api_path}        
    END
    
    ${session}    Create A Session    ${api_call_side}

    ${result}    GET On Session
    ...    ${session}
    ...    ${api_path}
    ...    expected_status=any

    &{response}    Create Dictionary
    ...    status_code=${result.status_code}
    ...    body=${result.json()}
    RETURN    ${response}

    [Teardown]    Delete A Session    ${session}