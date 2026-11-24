*** Settings ***
Variables       data/pcm/delivery-reserve-return-post-variables.yaml
Resource        apis/pcm/delivery/api-delivery-reserve-pickup-post.resource
Resource        services/db/postgres-db-service.resource


*** Keywords ***
Selecting pickup Post
    [Documentation]    return post

    ${response}    Post delivery reserve pickup-post    ${MICROSERVICE_SIDE}
    ...    ${logistic_token3}
    ...    ${city_id}
    ...    test1
    ...    2

    Should Be Equal As Integers    ${response['status_code']}    200
    ${return_result}    Set Variable    ${response['body']}

Check In Db Reserve
    ${result}    POSTGRES Fetch All
    ...    db_name=${PCM_DB_NAME}
    ...    query=SELECT * FROM "Deliveries" WHERE "Token"='12345678910'
    # Check if the ReserveStatus exists and is equal to 100
    ${body}    Get From Dictionary    ${result}    body
    ${first_item}    Get From List    ${body}    0
    Should Be Equal As Integers    ${first_item['ReserveStatus']}    100

Check In Db Delete Reserve
    # Update the database to set ReserveStatus to NULL
    ${update_result}    POSTGRES Execute Query
    ...    db_name=${PCM_DB_NAME}
    ...    query=UPDATE "Deliveries" SET "ReserveStatus" = 0 WHERE "Token"='12345678910'

    # Check if the update was successful
    ${status_code}    Get From Dictionary    ${update_result}    status_code
    Should Be Equal As Integers    ${status_code}    0    There was an error in the update query.
