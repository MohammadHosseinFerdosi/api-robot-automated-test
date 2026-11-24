*** Settings ***
Variables       data/pcm/delivery-reserve-return-post-variables.yaml
Resource        apis/pcm/delivery/api-delivery-request-treasury-output.resource
Resource        apis/pcm/requests/api-requests-accept.resource
Resource        services/db/postgres-db-service.resource


*** Keywords ***
request treasury output
    [Documentation]    request treasury output
    ${response}    Post Delivery Request Treasury Output    ${MICROSERVICE_SIDE}
    ...    ${deliveryids1}

    Should Be Equal As Integers    ${response['status_code']}    200
    ${deliver-to-post_RESULT}    Set Variable    body = response.get('body', 'No body available')

requests accept
# Send Request ID From DB To Accept API As JSON List Without Changing Method Name
    # Step 1: اجرای کوئری برای گرفتن آخرین request_id
    ${query_result}    POSTGRES Fetch All
    ...    db_name=${PCM_DB_NAME}
    ...    query=SELECT "Id" FROM "Requests" ORDER BY "CreationTime" DESC LIMIT 1

    ${request_id}    Set Variable    ${query_result['body'][0]['Id']}

    # Step 2: ساخت لیست برای requestIds
    ${requestids}    Create List    ${request_id}

    # Step 3: فراخوانی API با استفاده از request_id داخل لیست
    ${response}    Post Requests Accept    ${MICROSERVICE_SIDE}    ${requestids}    ${DASHBOARD_USERNAME}

    Should Be Equal As Integers    ${response['status_code']}    200

    ${register-to-post_RESULT}    Set Variable    body = response.get('body', 'No body available')

Check In Db Reserve
    ${result}    POSTGRES Fetch All
    ...    db_name=${PCM_DB_NAME}
    ...    query=SELECT * FROM "Deliveries" WHERE "Id" = '05ae7ed9-3a8a-4c57-a9b8-605060802663'

    # Check if the ReserveStatus exists and is equal to 100
    ${body}    Get From Dictionary    ${result}    body
    ${item}    Get From List    ${body}    0
    Dictionary Should Contain Key    ${item}    WorkFlowStep
    Should Be Equal As Integers    ${item['WorkFlowStep']}    30

Check In Db Delete Reserve
    # Update the database to set ReserveStatus to NULL
    ${update_result}    POSTGRES Execute Query
    ...    db_name=${PCM_DB_NAME}
    ...    query=UPDATE "Deliveries" SET "WorkFlowStep" = 10,"ReserveStatus"=100 WHERE "Id"='05ae7ed9-3a8a-4c57-a9b8-605060802663'
    # Check if the update was successful
    ${status_code}    Get From Dictionary    ${update_result}    status_code
    Should Be Equal As Integers    ${status_code}    0    There was an error in the update query.
