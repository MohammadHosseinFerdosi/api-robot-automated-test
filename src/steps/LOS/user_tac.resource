*** Settings ***
Variables   data/los/credit.yaml
Variables   config/environment-stage.yaml
Library     RequestsLibrary
Library     Collections

Resource    services/db/mongo-db-service.resource
Resource    apis/los/Journey/post_credit_tac_general.resource

*** Keywords ***
Accepts General Tac 
    User Accepts General Tac
    Check General Tac Acceptance Success

Clean Data From Database
    Delete Latest User Tac Record If Exist

User Accepts General Tac
    ${response}=    POST Credit Tac General
    ...    user_id=${CREDIT_USER_ID}
    Set Test Variable    ${TAC_RESPONSE}    ${response}

Check General Tac Acceptance Success
    Should Be Equal As Numbers    ${TAC_RESPONSE.status_code}    200

Delete Latest User Tac Record If Exist
    ${filter}=    Create Dictionary    userId=${CREDIT_USER_ID}
    ${sort_item}=    Create List    acceptedTime    ${-1}
    ${sort}=    Create List    ${sort_item}
    ${res}=    Mongo Db Find One    ${SWITCH_CREDIT_DB_NAME}    ${T&C_COLLECTIONS}    ${filter}    sort=${sort}
    ${status}    ${body}=    Run Keyword And Ignore Error    Get From Dictionary    ${res}    body
    ${has_data}=    Evaluate    isinstance($body, dict) and 'acceptedTime' in $body
    IF    ${has_data}
        ${acc_time}=    Set Variable    ${body['acceptedTime']}
        ${delete_filter}=    Create Dictionary    
        ...    userId=${CREDIT_USER_ID}    
        ...    acceptedTime=${acc_time}
        ${delete_res}=    Mongo Db Delete One    ${SWITCH_CREDIT_DB_NAME}    ${T&C_COLLECTIONS}    ${delete_filter}
    ELSE
        No Operation
    END