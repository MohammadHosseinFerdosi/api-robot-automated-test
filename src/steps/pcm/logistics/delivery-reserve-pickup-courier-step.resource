*** Settings ***
Variables       data/pcm/delivery-reserve-return-post-variables.yaml
Resource        apis/pcm/delivery/api-delivery-reserve-pickup-courier.resource
Resource        services/db/postgres-db-service.resource


*** Keywords ***
Selecting pickup courier
    [Documentation]    pickup courier
    ${tomorrow}    Evaluate
    ...    (lambda now, holidays: next((now + datetime.timedelta(days=i) for i in range(1, 15) if (now + datetime.timedelta(days=i)).weekday() != 4 and (now + datetime.timedelta(days=i)).strftime('%Y-%m-%d') not in holidays)).replace(hour=0, minute=0, second=0, microsecond=0).astimezone(datetime.timezone(datetime.timedelta(hours=3, minutes=30))).isoformat())(datetime.datetime.now(), ["2025-03-21", "2025-03-22", "2025-03-23", "2025-03-24", "2025-03-18", "2025-04-20", "2025-04-21", "2025-06-29", "2025-08-15", "2025-08-16", "2025-05-01", "2025-04-01", "2025-04-02", "2025-09-16", "2025-02-11", "2025-10-05", "2025-12-21" ])
    ...    modules=datetime

    ${response}    Post delivery reserve pickup-courier    ${MICROSERVICE_SIDE}
    ...    ${logistic_token1}
    ...    ${city_id}
    ...    ${street_address}
    ...    ${postal_code}
    ...    ${number}
    ...    ${unit}
    ...    ${latitude}
    ...    ${longitude}
    ...    ${timeslotid}
    ...    ${tomorrow}
    ...    test2
    ...    2
    Should Be Equal As Integers    ${response['status_code']}    200
    ${return_result}    Set Variable    ${response['body']}

Check In Db Reserve
    ${result}    POSTGRES Fetch All
    ...    db_name=${PCM_DB_NAME}
    ...    query=SELECT * FROM "Deliveries" WHERE "Token"='12345678901'

    # Check if the ReserveStatus exists and is equal to 100
    ${body}    Get From Dictionary    ${result}    body
    ${first_item}    Get From List    ${body}    0
    Should Be Equal As Integers    ${first_item['ReserveStatus']}    100

Check In Db Delete Reserve
    # Update the database to set ReserveStatus to NULL
    ${update_result}    POSTGRES Execute Query
    ...    db_name=${PCM_DB_NAME}
    ...    query=UPDATE "Deliveries" SET "ReserveStatus" = 0 WHERE "Token"='12345678901'

    # Check if the update was successful
    ${status_code}    Get From Dictionary    ${update_result}    status_code
    Should Be Equal As Integers    ${status_code}    0    There was an error in the update query.
