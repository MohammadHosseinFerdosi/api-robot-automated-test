*** Settings ***
Variables       data/pcm/delivery-reserve-return-post-variables.yaml
Resource        apis/pcm/delivery/api-delivery-deliver-to-post.resource
Resource        apis/pcm/delivery/api-delivery-register-tracking-code.resource
Resource        services/db/postgres-db-service.resource


*** Keywords ***
deliver to post
    [Documentation]    deliver to post
    ${response}    Post Delivery Deliver To Post    ${MICROSERVICE_SIDE}
    ...    ${delivery_ids}
    ...    ${receiver_delivery}

    Should Be Equal As Integers    ${response['status_code']}    200
    ${deliver-to-post_RESULT}    Set Variable    body = response.get('body', 'No body available')

register tracking code
    [Documentation]    register tracking code
    ${response}    Post Delivery Register Tracking Code    ${MICROSERVICE_SIDE}
    ...    ${mobile_number}
    ...    ${tracking_code}

    Should Be Equal As Integers    ${response['status_code']}    200
    ${register-to-post_RESULT}    Set Variable    body = response.get('body')

Check In Db Reserve
    ${result}    POSTGRES Fetch All
    ...    db_name=${PCM_DB_NAME}
    ...    query=SELECT * FROM "Deliveries" WHERE "Id" = '5a5136b3-0a5a-4fd8-9dc5-5af54c39a3c8'

    # Check if the ReserveStatus exists and is equal to 100
    ${body}    Get From Dictionary    ${result}    body
    ${item}    Get From List    ${body}    0
    Dictionary Should Contain Key    ${item}    WorkFlowStep
    Should Be Equal As Integers    ${item['WorkFlowStep']}    50

Check In Db Delete Reserve
    # Update the database to set ReserveStatus to NULL
    ${update_result}    POSTGRES Execute Query
    ...    db_name=${PCM_DB_NAME}
    ...    query=UPDATE "Deliveries" SET "WorkFlowStep" = 30,"TrackingCode"=NULL WHERE "Id"='5a5136b3-0a5a-4fd8-9dc5-5af54c39a3c8'

    # Check if the update was successful
    ${status_code}    Get From Dictionary    ${update_result}    status_code
    Should Be Equal As Integers    ${status_code}    0    There was an error in the update query.
