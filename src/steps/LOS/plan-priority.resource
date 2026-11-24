*** Settings ***
Variables   data/los/credit.yaml
Variables   config/environment-stage.yaml
Library     Process
Library     RequestsLibrary
Library     DateTime
Library     String

Resource    services/db/mongo-db-service.resource
Resource    apis/los/dashboard/get-credit-admin-plans-priority.resource
Resource    apis/los/dashboard/post-credit-admin-plans-priority.resource


*** Keywords ***
Gets Credit Plans Priority
    Admin Gets Credit Plans Priority
    Admin Verifies Plans Priority Details Success

Updates Credit Plans Priority
    Admin Updates Credit Plans Priority

Plans Priority Update Should Be Successful
    Admin Verifies Plans Priority Update Success
    Verify Plans Priority Saved In DB


Admin Gets Credit Plans Priority
    ${result}=    GET Credit Admin Plans Priority
    ...    api_call_side=${MICROSERVICE_SIDE}
    ...    user_id=${ADMIN_USER_ID}
    Set Test Variable    ${PRIORITY_RESPONSE}    ${result}

Admin Verifies Plans Priority Details Success
    Should Be Equal As Numbers    ${PRIORITY_RESPONSE}[status_code]    200
    Dictionary Should Contain Key    ${PRIORITY_RESPONSE}[body]    result
    Should Be Equal As Numbers    ${PRIORITY_RESPONSE}[body][result][status]    0
    Should Be Equal As Strings    ${PRIORITY_RESPONSE}[body][result][title]    SUCCESS


Admin Updates Credit Plans Priority
    ${item1}=    Create Dictionary    priority=1    fundProviderCode=${CREDIT_PARSIAN_FP_CODE}
    ${item2}=    Create Dictionary    priority=2    fundProviderCode=${CREDIT_MELLAT_FP_CODE}
    ${item3}=    Create Dictionary    priority=3    fundProviderCode=${CREDIT_TEJARAT_FP_CODE}
    ${item4}=    Create Dictionary    priority=4    fundProviderCode=${CREDIT_SADERAT_FP_CODE}
    ${item5}=    Create Dictionary    priority=5    fundProviderCode=${CREDIT_GARDESHGARI_FP_CODE}
    ${item6}=    Create Dictionary    priority=6    fundProviderCode=${CREDIT_BLU_FP_CODE}

    ${update_model}=    Create List
    ...    ${item1}
    ...    ${item2}
    ...    ${item3}
    ...    ${item4}
    ...    ${item5}
    ...    ${item6}

    Set Test Variable    ${update_model}

    ${body}=    Create Dictionary    updateModel=${update_model}

    ${result}=    POST Credit Admin Plans Priority
    ...    api_call_side=${MICROSERVICE_SIDE}
    ...    user_id=${ADMIN_USER_ID}
    ...    body=${body}

    Set Test Variable    ${PRIORITY_UPDATE_RESPONSE}    ${result}


Admin Verifies Plans Priority Update Success
    Should Be Equal As Numbers    ${PRIORITY_UPDATE_RESPONSE}[status_code]    200
    Dictionary Should Contain Key    ${PRIORITY_UPDATE_RESPONSE}[body]    result
    Should Be Equal As Numbers    ${PRIORITY_UPDATE_RESPONSE}[body][result][status]    0
    Should Be Equal As Strings    ${PRIORITY_UPDATE_RESPONSE}[body][result][title]    SUCCESS


Verify Plans Priority Saved In DB
    Wait Until Keyword Succeeds    5x    3s    Admin Verifies Plans Priority Saved In DB


Admin Verifies Plans Priority Saved In DB
    ${find_query}=    Create Dictionary
    ${mongo_result}=    Mongo Db Find    ${SWITCH_CREDIT_DB_NAME}    plan_priority_settings    ${find_query}
    ${db_records}=    Set Variable    ${mongo_result['body']}

    FOR    ${item}    IN    @{update_model}
        ${fp_code}=    Set Variable    ${item['fundProviderCode']}
        ${expected_priority}=    Set Variable    ${item['priority']}
        ${matched}=    Set Variable    ${None}

        FOR    ${db_row}    IN    @{db_records}
            IF    ${db_row['fundProviderCode']} == ${fp_code}
                ${matched}=    Set Variable    ${db_row}
                Exit For Loop
            END
        END

        Should Not Be Equal    ${matched}    ${None}    Provider ${fp_code} not found in DB
        Should Be Equal As Numbers    ${matched['priority']}    ${expected_priority}
    END