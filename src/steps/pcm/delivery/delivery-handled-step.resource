*** Settings ***
Variables       data/pcm/delivery-reserve-return-post-variables.yaml
Variables       data/pcm/Constants.yaml
Resource        apis/pcm/delivery/delivery-handled.resource
Resource        services/db/postgres-db-service.resource


*** Keywords ***
Delivery Handled
    [Documentation]    Send To Finance From Treasury
    ${response}    Post Delivery Handled    ${MICROSERVICE_SIDE}
    ...    ${DELIVERY_HANDLED_ID}

    Should Be Equal As Integers    ${response['status_code']}    200
    ${deliver-to-post_RESULT}    Set Variable    body = response.get('body', 'No body available')

Check In Delivery Handled Database
    ${result}    POSTGRES Fetch All
    ...    db_name=${PCM_DB_NAME}
    ...    query=SELECT * FROM "Deliveries" WHERE "Id"='${ID_IN_QUERY_HANDLED}'

    
     ${body}    Get From Dictionary    ${result}    body
    ${item}    Get From List    ${body}    0
    Dictionary Should Contain Key    ${item}    WorkFlowStep
    Should Be Equal As Integers    ${item['WorkFlowStep']}    1000

Delete Delivery Handled In Database 
    ${update_result}    POSTGRES Execute Query
    ...    db_name=${PCM_DB_NAME}
    ...    query=UPDATE "Deliveries" SET "ReserveStatus" = ${STATUS_RESERVE_DELIVERY} , "WorkFlowStep" = ${WORKFLOW_RESERVE_DELIVERY} WHERE "Id" ='${ID_IN_QUERY_HANDLED}'
   
    ${status_code}    Get From Dictionary    ${update_result}    status_code
    Should Be Equal As Integers    ${status_code}    0    There was an error in the update query.
