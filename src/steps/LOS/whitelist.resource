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

Resource    apis/los/dashboard/post-credit-admin-whitelist-import.resource
Resource    apis/los/dashboard/post-credit-admin-whitelist-search.resource
Resource    apis/los/dashboard/post-credit-admin-whitelist-remove.resource

*** Keywords ***
Admin Imports Whitelist Successfully
    Admin Submits Whitelist Import Request
    Check Whitelist Import Success
    Admin Finds Whitelist Record In Mongo

Admin Searches Whitelist Successfully
    Admin Submits Whitelist Search Request
    Check Whitelist Search Success

Admin Single Removes Whitelist Successfully
    Admin Submits Whitelist Single Remove Request
    Check Whitelist Single Remove Success
    Admin Does Not Find Whitelist Record In Mongo

Admin All Removes Whitelist Successfully
    Admin Submits Whitelist All Remove Request
    Check Whitelist All Remove Success
    Admin Does Not Find Whitelist Record In Mongo

Admin Submits Whitelist Import Request
    ${group_id}=    Set Variable    ${GROUP_RESPONSE}[body][groupId]
    ${cell_numbers}=    Create List    ${CREDIT_CELL_NUMBER}

    ${result}=    POST Credit Admin Whitelist Import
    ...    user_id=${ADMIN_USER_ID}
    ...    group_id=${group_id}
    ...    cell_numbers=${cell_numbers}

    Set Test Variable    ${WHITELIST_IMPORT_RESPONSE}    ${result}

Check Whitelist Import Success
    Should Be Equal As Numbers    ${WHITELIST_IMPORT_RESPONSE.status_code}    200

Admin Submits Whitelist Search Request
    ${group_id}=    Set Variable    ${GROUP_RESPONSE}[body][groupId]

    ${group_id_restriction}=    Create Dictionary
    ...    type=simple
    ...    field=groupId
    ...    value=${group_id}
    ...    operation=eq

    ${cell_number_restriction}=    Create Dictionary
    ...    type=simple
    ...    field=cellNumber
    ...    value=${CREDIT_CELL_NUMBER}
    ...    operation=eq

    ${restrictions}=    Create List
    ...    ${group_id_restriction}
    ...    ${cell_number_restriction}

    ${orders}=    Create List

    ${result}=    POST Credit Admin Whitelist Search
    ...    user_id=${ADMIN_USER_ID}
    ...    page=${PAGE}
    ...    size=${SIZE}
    ...    restrictions=${restrictions}
    ...    orders=${orders}

    Set Test Variable    ${WHITELIST_SEARCH_RESPONSE}    ${result}

Check Whitelist Search Success
    Should Be Equal As Numbers    ${WHITELIST_SEARCH_RESPONSE.status_code}    200

Admin Finds Whitelist Record In Mongo
    ${group_id}=    Set Variable    ${GROUP_RESPONSE}[body][groupId]
    Should Not Be Empty    ${group_id}

    ${cell_number}=    Set Variable    ${CREDIT_CELL_NUMBER}
    Should Not Be Empty    ${cell_number}

    ${filter}=    Create Dictionary    groupId=${group_id}    cellNumber=${cell_number}

    ${result}=    Mongo Db Find One
    ...    ${SWITCH_CREDIT_DB_NAME}
    ...    whitelists
    ...    ${filter}

    Should Be Equal As Numbers    ${result['status_code']}    0

    ${document}=    Set Variable    ${result['body']}
    Run Keyword If    not ${document}    Fail
    ...    No record found in mongo collection=whitelists for group_id=${group_id} and cell_number=${cell_number}.

Admin Submits Whitelist Single Remove Request
    ${group_id}=    Set Variable    ${GROUP_RESPONSE}[body][groupId]
    ${cell_number}=    Set Variable    ${CREDIT_CELL_NUMBER}

    ${result}=    POST Credit Admin Whitelist Remove
    ...    user_id=${ADMIN_USER_ID}
    ...    group_id=${group_id}
    ...    cell_number=${cell_number}

    Set Test Variable    ${WHITELIST_REMOVE_RESPONSE}    ${result}

Check Whitelist Single Remove Success
    Should Be Equal As Numbers    ${WHITELIST_REMOVE_RESPONSE.status_code}    200

Admin Submits Whitelist All Remove Request
    ${group_id}=    Set Variable    ${GROUP_RESPONSE}[body][groupId]
    ${null}=        Evaluate    None

    ${result}=    POST Credit Admin Whitelist Remove
    ...    user_id=${ADMIN_USER_ID}
    ...    group_id=${group_id}
    ...    cell_number=${null}

    Set Test Variable    ${WHITELIST_REMOVE_RESPONSE}    ${result}

Check Whitelist All Remove Success
    Should Be Equal As Numbers    ${WHITELIST_REMOVE_RESPONSE.status_code}    200

Admin Does Not Find Whitelist Record In Mongo
    ${group_id}=    Set Variable    ${GROUP_RESPONSE}[body][groupId]
    Should Not Be Empty    ${group_id}

    ${cell_number}=    Set Variable    ${CREDIT_CELL_NUMBER}
    Should Not Be Empty    ${cell_number}

    ${filter}=    Create Dictionary    groupId=${group_id}    cellNumber=${cell_number}

    ${result}=    Mongo Db Find One
    ...    ${SWITCH_CREDIT_DB_NAME}
    ...    whitelists
    ...    ${filter}

    Should Be Equal As Numbers    ${result['status_code']}    0

    ${document}=    Set Variable    ${result['body']}
    Run Keyword If    ${document}    Fail
    ...    Record still exists in mongo collection=whitelists for group_id=${group_id} and cell_number=${cell_number}.