*** Settings ***
Variables       data/pcm/delivery-reserve-return-post-variables.yaml
Variables       data/pcm/Constants.yaml
Resource        apis/pcm/collaterals/collaterals-send-to-debt-collection-from-treasury.resource
Resource        apis/pcm/requests/api-requests-reject.resource
Resource        apis/pcm/requests/api-requests-accept.resource
Resource        services/db/postgres-db-service.resource


*** Keywords ***
Send To Debt Collection From Treasury
    [Documentation]    Send To Finance From Treasury
    ${response}    Post Collateral Send To Debt Collection From Treasury    ${MICROSERVICE_SIDE}
    ...    ${COLLATERAL_IDS_DEBT}
    ...    ${COLLATERAL_REASEN_ID_DEBT}

    Should Be Equal As Integers    ${response['status_code']}    200
    ${deliver-to-post_RESULT}    Set Variable    body = response.get('body', 'No body available')

Requests Accept Treasury
    ${query_result}    POSTGRES Fetch All
    ...    db_name=${PCM_DB_NAME}
    ...    query=SELECT "Id" FROM "Requests" ORDER BY "CreationTime" DESC LIMIT 1

    ${request_id}    Set Variable    ${query_result['body'][0]['Id']}
    ${request_ids}    Create List    ${request_id}
    ${response}    Post Requests Accept    ${MICROSERVICE_SIDE}    ${request_ids}    ${DASHBOARD_USERNAME}
    Should Be Equal As Integers    ${response['status_code']}    200

Requests Reject Treasury

    ${query_result}    POSTGRES Fetch All
    ...    db_name=${PCM_DB_NAME}
    ...    query=SELECT "Id" FROM "Requests" ORDER BY "CreationTime" DESC LIMIT 1

    ${request_id}    Set Variable    ${query_result['body'][0]['Id']}
    ${request_ids}    Create List    ${request_id}
    ${response}    Post Requests Reject    ${MICROSERVICE_SIDE}    ${request_ids}    ${reject_reasonid}    ${DASHBOARD_USERNAME}
    Should Be Equal As Integers    ${response['status_code']}    200

Requests Reject Debt Collection

    ${query_result}    POSTGRES Fetch All
    ...    db_name=${PCM_DB_NAME}
    ...    query=SELECT "Id" FROM "Requests" ORDER BY "CreationTime" DESC LIMIT 1

    ${request_id}    Set Variable    ${query_result['body'][0]['Id']}
    ${request_ids}    Create List    ${request_id}
    ${response}    Post Requests Reject    ${MICROSERVICE_SIDE}    ${request_ids}    ${reject_reasonid}    ${DASHBOARD_USERNAME}
    Should Be Equal As Integers    ${response['status_code']}    200

Requests Accept Debt Collection
    ${query_result}    POSTGRES Fetch All
    ...    db_name=${PCM_DB_NAME}
    ...    query=SELECT "Id" FROM "Requests" ORDER BY "CreationTime" DESC LIMIT 1

    ${request_id}    Set Variable    ${query_result['body'][0]['Id']}
    ${requestids}    Create List    ${request_id}
    ${response}    Post Requests Accept    ${MICROSERVICE_SIDE}    ${request_ids}    ${DASHBOARD_USERNAME}
    Should Be Equal As Integers    ${response['status_code']}    200

Check In Database From Accept Debt Collection
    ${result}    POSTGRES Fetch All
    ...    db_name=${PCM_DB_NAME}
    ...    query=SELECT * FROM "Collaterals" WHERE "Id" = '${ID_COLLATERAL_FROM_SEND_TO_DEBT_COLLECTION_FROM_TREASURY_QUERY}'

    ${body}    Get From Dictionary    ${result}    body
    ${item}    Get From List    ${body}    0
    Dictionary Should Contain Key    ${item}    WorkFlowStep
    Should Be Equal As Integers    ${item['WorkFlowStep']}    900
    
Check In Database From Reject Treasury First
    ${result}    POSTGRES Fetch All
    ...    db_name=${PCM_DB_NAME}
    ...    query=SELECT * FROM "Collaterals" WHERE "Id" = '${ID_COLLATERAL_FROM_SEND_TO_DEBT_COLLECTION_FROM_TREASURY_QUERY}'

    ${body}    Get From Dictionary    ${result}    body
    ${item}    Get From List    ${body}    0
    Dictionary Should Contain Key    ${item}    WorkFlowStep
    Should Be Equal As Integers    ${item['WorkFlowStep']}    550

Check In Database From Accept Treasury And Reject Debt Collection And Accept Treasury
    ${result}    POSTGRES Fetch All
    ...    db_name=${PCM_DB_NAME}
    ...    query=SELECT * FROM "Collaterals" WHERE "Id" = '${ID_COLLATERAL_FROM_SEND_TO_DEBT_COLLECTION_FROM_TREASURY_QUERY}'

    ${body}    Get From Dictionary    ${result}    body
    ${item}    Get From List    ${body}    0
    Dictionary Should Contain Key    ${item}    WorkFlowStep
    Should Be Equal As Integers    ${item['WorkFlowStep']}    550

Check In Database From Accept Treasury And Reject Debt Collection And Reject Treasury
    ${result}    POSTGRES Fetch All
    ...    db_name=${PCM_DB_NAME}
    ...    query=SELECT * FROM "Collaterals" WHERE "Id" = '${ID_COLLATERAL_FROM_SEND_TO_DEBT_COLLECTION_FROM_TREASURY_QUERY}'

    ${body}    Get From Dictionary    ${result}    body
    ${item}    Get From List    ${body}    0
    Dictionary Should Contain Key    ${item}    WorkFlowStep
    Should Be Equal As Integers    ${item['WorkFlowStep']}    2400

Update Database to Treasury Flow 
    ${update_result}    POSTGRES Execute Query
    ...    db_name=${PCM_DB_NAME}
    ...    query=UPDATE "Collaterals" SET "WorkFlowStep" = ${WORKFLOW_FROM_SEND_TO_DEBT_COLLECTION_FROM_TREASURY_QUERY} , "LocationType" = ${LOCATION_TYPE_FROM_SEND_TO_DEBT_COLLECTION_FROM_TREASURY_QUERY} , "LocationId" = ${LOCATION_ID_FROM_SEND_TO_DEBT_COLLECTION_FROM_TREASURY_QUERY} WHERE "Id" = '${ID_COLLATERAL_FROM_SEND_TO_DEBT_COLLECTION_FROM_TREASURY_QUERY}'
   
    ${status_code}    Get From Dictionary    ${update_result}    status_code
    Should Be Equal As Integers    ${status_code}    0    There was an error in the update query.
