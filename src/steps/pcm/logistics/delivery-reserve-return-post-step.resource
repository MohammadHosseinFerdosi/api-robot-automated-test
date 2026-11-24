*** Settings ***
Variables       data/pcm/delivery-reserve-return-post-variables.yaml
Resource        apis/pcm/logistics/api-logistic-send-otp.resource
Resource        apis/pcm/logistics/api-logistic-verify-otp.resource
Resource        apis/pcm/delivery/api-delivery-reserve-return-post.resource
Resource        services/db/postgres-db-service.resource


*** Keywords ***
An OTP Was Sent
    [Documentation]    send otp
    ${response}    Post api logistic send-otp    ${MICROSERVICE_SIDE}
    ...    ${logistic_token}
    ...    ${direction}

    Should Be Equal As Integers    ${response['status_code']}    200
    ${OTP_RESULT}    Set Variable    ${response['body']}

Verify OTP
    [Documentation]    verify otp
    ${response}    post api logistic verify-otp    ${MICROSERVICE_SIDE}
    ...    ${logistic_token}
    ...    ${otp_code}

    Should Be Equal As Integers    ${response['status_code']}    200

    ${verify_result}    Set Variable    ${response['body']}
    ${reserve_session}    Set Variable    ${verify_result['reserveSession']}
    Set Test Variable    ${reserve_session}

Selecting Return Option Via Post
    [Documentation]    return post

    ${response}    Post delivery reserve return-post    ${MICROSERVICE_SIDE}
    ...    ${reserve_session}
    ...    ${logistic_token}
    ...    ${city_id}
    ...    ${street_address}
    ...    ${postal_code}
    ...    ${number}
    ...    ${unit}
    Should Be Equal As Integers    ${response['status_code']}    200
    ${return_result}    Set Variable    ${response['body']}

Check In Db Reserve
    ${result}    POSTGRES Fetch All
    ...    db_name=${PCM_DB_NAME}
    ...    query=SELECT * FROM "Deliveries" WHERE "Token"='1234567890'

    # Check if the ReserveStatus exists and is equal to 100
    ${body}    Get From Dictionary    ${result}    body
    ${first_item}    Get From List    ${body}    0
    Should Be Equal As Integers    ${first_item['ReserveStatus']}    100

Check In Db Delete Reserve
    # Update the database to set ReserveStatus to NULL
    ${update_result}    POSTGRES Execute Query
    ...    db_name=${PCM_DB_NAME}
    ...    query=UPDATE "Deliveries" SET "ReserveStatus" = 0 WHERE "Token"='1234567890'

    # Check if the update was successful
    ${status_code}    Get From Dictionary    ${update_result}    status_code
    Should Be Equal As Integers    ${status_code}    0    There was an error in the update query.
