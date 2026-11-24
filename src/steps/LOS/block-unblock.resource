*** Settings ***
Variables   data/los/credit.yaml
Variables   config/environment-stage.yaml
Library     Process
Library     RequestsLibrary
Library     DateTime
Library     String

Resource    services/db/mysql-db-service.resource
Resource    services/db/mongo-db-service.resource
Resource    services/backend/LMS/credit-core/close-account.resource

Resource    apis/los/dashboard/post_credit_admin_activations_suspend_restriction_search.resource
Resource    apis/los/dashboard/post_credit_admin_activations_suspend_restriction_add.resource
Resource    apis/los/dashboard/post_credit_admin_activations_suspend_restriction_save.resource
Resource    apis/los/dashboard/delete_credit_admin_activations_suspend_restriction.resource
Resource    apis/los/dashboard/post_credit_admin_activations_suspend_rebound.resource
Resource    apis/los/dashboard/post_credit_admin_activations_suspend.resource

*** Keywords ***

Searches Activation Suspend
    Admin Searches Activation Suspend Restriction
    Activation Suspend Restriction Search Should Be Successful

Adds Activation Suspend Restriction
    Admin Adds Activation Suspend Restriction
    Activation Suspend Restriction Add Should Be Successful

Verifies Created Group Exists In Activation Suspend Search
    Admin Searches Activation Suspend Restriction
    Activation Suspend Restriction Add Should Be Successful
    Activation Suspend Restriction Should Contain Created Group

Saves Activation Suspend Restriction
    Admin Saves Activation Suspend Restriction
    Activation Suspend Restriction Save Should Be Successful

Deletes Activation Suspend Restriction
    Admin Deletes Activation Suspend Restriction
    Activation Suspend Restriction Delete Should Be Successful

Suspends Credit Activation
    Admin Suspends Credit Activation
    Activation Suspend Should Be Successful

Rebounds Credit Activation Suspend
    Admin Rebounds Credit Activation Suspend
    Activation Suspend Rebound Should Be Successful


Admin Searches Activation Suspend Restriction
    ${value}=    Set Variable    ${ACTIVATION_STATUS_SUSPEND}
    ${values}=    Create List    ${value}

    ${restriction}=    Create Dictionary
    ...    type=collection
    ...    field=activationStatus
    ...    values=${values}

    ${restrictions}=    Create List    ${restriction}
    ${orders}=    Create List

    ${response}=    POST Credit Admin Activations Suspend Restriction Search
    ...    ${MICROSERVICE_SIDE}
    ...    ${ADMIN_USER_ID}
    ...    ${PAGE}
    ...    ${SIZE}
    ...    ${restrictions}
    ...    ${orders}

    Set Suite Variable    ${activation_restriction_response}    ${response}

Activation Suspend Restriction Search Should Be Successful
    Should Be Equal As Numbers    ${activation_restriction_response['status_code']}    200

Admin Adds Activation Suspend Restriction
    ${group_ids}=    Create List    ${group_id}

    ${response}=    POST Credit Admin Activations Suspend Restriction Add
    ...    ${MICROSERVICE_SIDE}
    ...    ${ADMIN_USER_ID}
    ...    ${ACTIVATION_STATUS_SUSPEND}
    ...    ${group_ids}

    Set Suite Variable    ${activation_suspend_add_response}    ${response}

Activation Suspend Restriction Add Should Be Successful
    Should Be Equal As Numbers    ${activation_suspend_add_response}[status_code]    200
    Should Be Equal As Numbers    ${activation_suspend_add_response}[body][result][status]    0

Activation Suspend Restriction Should Contain Created Group
    ${body}=    Set Variable    ${activation_restriction_response}[body]
    ${restrictions}=    Get From Dictionary    ${body}    restrictions
    ${expected_group_id}=    Convert To String    ${group_id}

    FOR    ${restriction}    IN    @{restrictions}
        ${groups}=    Get From Dictionary    ${restriction}    groups

        FOR    ${group}    IN    @{groups}
            ${found_group_id}=    Get From Dictionary    ${group}    groupId
            ${found_group_id}=    Convert To String    ${found_group_id}

            IF    '${found_group_id}' == '${expected_group_id}'
                RETURN
            END
        END
    END

    Fail    group_id ${expected_group_id} not found in response

Admin Saves Activation Suspend Restriction
    ${group_ids}=    Create List    ${group_id}

    ${response}=    POST Credit Admin Activations Suspend Restriction Save
    ...    ${MICROSERVICE_SIDE}
    ...    ${ADMIN_USER_ID}
    ...    ${ACTIVATION_STATUS_SUSPEND}
    ...    ${group_ids}

    Set Suite Variable    ${activation_suspend_save_response}    ${response}

Activation Suspend Restriction Save Should Be Successful
    Should Be Equal As Numbers    ${activation_suspend_save_response}[status_code]    200
    Should Be Equal As Numbers    ${activation_suspend_save_response}[body][result][status]    0

Admin Deletes Activation Suspend Restriction
    ${response}=    DELETE Credit Admin Activations Suspend Restriction
    ...    ${MICROSERVICE_SIDE}
    ...    ${ADMIN_USER_ID}
    ...    ${ACTIVATION_STATUS_SUSPEND}

    Set Suite Variable    ${activation_suspend_delete_response}    ${response}

Activation Suspend Restriction Delete Should Be Successful
    Should Be Equal As Numbers    ${activation_suspend_delete_response}[status_code]    200
    Should Be Equal As Numbers    ${activation_suspend_delete_response}[body][result][status]    0

Admin Suspends Credit Activation
    ${response}=    POST Credit Admin Activations Suspend
    ...    ${MICROSERVICE_SIDE}
    ...    ${ADMIN_USER_ID}
    ...    ${credit_id}

    Set Suite Variable    ${activation_suspend_response}    ${response}

Activation Suspend Should Be Successful
    Should Be Equal As Numbers    ${activation_suspend_response}[status_code]    200
    Should Be Equal As Numbers    ${activation_suspend_response}[body][result][status]    0

Admin Rebounds Credit Activation Suspend
    ${response}=    POST Credit Admin Activations Suspend Rebound
    ...    ${MICROSERVICE_SIDE}
    ...    ${ADMIN_USER_ID}
    ...    ${credit_id}

    Set Suite Variable    ${activation_suspend_rebound_response}    ${response}

Activation Suspend Rebound Should Be Successful
    Should Be Equal As Numbers    ${activation_suspend_rebound_response}[status_code]    200
    Should Be Equal As Numbers    ${activation_suspend_rebound_response}[body][result][status]    0