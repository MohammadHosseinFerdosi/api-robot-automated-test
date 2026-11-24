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
Resource    apis/los/dashboard/post_credit_admin_activations_extend_file_import.resource
Resource    apis/los/dashboard/post-credit-admin-activation-extend.resource

*** Keywords ***
Update Activation Due Date
    Update Activation Due Date To Ten Days Ago

Bulk Extend Call Api
    Admin Imports Activation Extension File
    Verify Activation Extend Journal Status

Single Extend Call Api
    Admin Extends Activation


Update Activation Due Date To Ten Days Ago
    ${due_date}=    Evaluate    int((__import__('time').time() - 864000) * 1000)
    ${filter}=    Create Dictionary    creditId=${credit_id}
    ${update_data}=    Create Dictionary    $set=${{ {'dueDate': ${due_date}} }}
    ${result}=    Mongo Db Update One
    ...    ${SWITCH_CREDIT_DB_NAME}
    ...    ${ACTIVATION_COLLECTION}
    ...    ${filter}
    ...    ${update_data}
    Should Be Equal As Numbers    ${result['status_code']}    0

Generate 24 Digit Tracking Code
    ${timestamp}=    Evaluate    str(int(__import__('time').time() * 1000))
    ${random_part}=    Evaluate    str(__import__('random').randint(100000000,999999999))
    ${tracking_code}=    Catenate    SEPARATOR=    ${timestamp}    ${random_part}
    ${tracking_code}=    Evaluate    ${tracking_code}[:24]
    RETURN    ${tracking_code}

Admin Imports Activation Extension File
    ${data_row}=    Create List
    ...    ${CREDIT_NATIONAL_CODE}
    ...    ${CREDIT_CELL_NUMBER}
    ...    ${CREDIT_BALANCE}
    ...    ${INISTALLMENTS_COUNT}
    ${data}=    Create List    ${data_row}
    ${tracking_code}=    Generate 24 Digit Tracking Code
    Set Suite Variable    ${tracking_code}
    ${response}=    POST Credit Admin Activation Extend File Import
    ...    ${MICROSERVICE_SIDE}
    ...    ${ADMIN_USER_ID}
    ...    ${data}
    ...    ${EXTEND_FILENAME}/${credit_id}
    ...    ${CREDIT_TEJARAT_FP_CODE}
    ...    ${tracking_code}
    Activation Extension File Import Should Be Successful    ${response}

Activation Extension File Import Should Be Successful
    [Arguments]    ${response}
    Should Be Equal As Numbers
    ...    ${response['status_code']}
    ...    200

Verify Activation Extend Journal Status
    Run Keyword And Continue On Failure
    ...    Wait Until Keyword Succeeds
    ...    25x
    ...    15s
    ...    Check Activation Extend Status

Check Activation Extend Status
    ${filter}=    Create Dictionary
    ...    trackingCode=${{str($tracking_code)}}
    ${result}=    Mongo Db Find One
    ...    ${SWITCH_CREDIT_DB_NAME}
    ...    ${EXTEND_COLLECTION}
    ...    ${filter}
    Should Be Equal As Numbers    ${result['status_code']}    0
    ${status}=    Set Variable    ${result['body']['status']}
    ${processing_states}=    Create List    INITIATED
    Should Not Contain    ${processing_states}    ${status}
    ...    msg=Still processing (Status: ${status})
    IF    '${status}' == 'INVALID' or '${status}' == 'REJECTED'
        Set Test Message    This request is not valid    append=True
    END

Admin Extends Activation
    ${result}    POST Credit Admin Activation Extend
    ...    ${MICROSERVICE_SIDE}
    ...    ${ADMIN_USER_ID}
    ...    ${credit_id}
    Should Be Equal As Numbers
    ...    ${result['status_code']}
    ...    200