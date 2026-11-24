*** Settings ***
Variables   data/los/credit.yaml
Variables   config/environment-stage.yaml
Library     Collections

Resource    services/backend/session-service.resource
Resource    apis/los/dashboard/post-credit-admin-step-settings-score.resource


*** Keywords ***

Admin Sets Score Settings Disabled
    Admin Submits Score Settings Request-enabled false
    Check Score Settings Update Success-enabled false

Admin Sets Score Settings Enabled Limited
    Admin Submits Score Settings Request-enabled true-limited
    Check Score Settings Update Success-enabled true-limited

Admin Sets Score Settings Enabled Unlimited
    Admin Submits Score Settings Request-enabled true-unlimited
    Check Score Settings Update Success-enabled true-unlimited


Admin Submits Score Settings Request-enabled true-limited

    ${body}=    Create Dictionary
    ...    fromTime=${LIMITED_FROM_TIME}
    ...    toTime=${LIMITED_TO_TIME}
    ...    enabled=${True}

    ${result}=    POST Credit Admin Step Settings Score
    ...    api_call_side=${MICROSERVICE_SIDE}
    ...    user_id=${ADMIN_USER_ID}
    ...    body=${body}

    Set Test Variable    ${SCORE_SETTINGS_RESPONSE}    ${result}

Check Score Settings Update Success-enabled true-limited
    Should Be Equal As Numbers    ${SCORE_SETTINGS_RESPONSE.status_code}    200


Admin Submits Score Settings Request-enabled true-unlimited

    ${body}=    Create Dictionary
    ...    fromTime=${UNLIMITED_TIME}
    ...    toTime=${UNLIMITED_TIME}
    ...    enabled=${True}

    ${result}=    POST Credit Admin Step Settings Score
    ...    api_call_side=${MICROSERVICE_SIDE}
    ...    user_id=${ADMIN_USER_ID}
    ...    body=${body}

    Set Test Variable    ${SCORE_SETTINGS_RESPONSE}    ${result}

Check Score Settings Update Success-enabled true-unlimited
    Should Be Equal As Numbers    ${SCORE_SETTINGS_RESPONSE.status_code}    200


Admin Submits Score Settings Request-enabled false

    ${body}=    Create Dictionary
    ...    fromTime=${UNLIMITED_TIME}
    ...    toTime=${UNLIMITED_TIME}
    ...    enabled=${False}

    ${result}=    POST Credit Admin Step Settings Score
    ...    api_call_side=${MICROSERVICE_SIDE}
    ...    user_id=${ADMIN_USER_ID}
    ...    body=${body}

    Set Test Variable    ${SCORE_SETTINGS_RESPONSE}    ${result}

Check Score Settings Update Success-enabled false
    Should Be Equal As Numbers    ${SCORE_SETTINGS_RESPONSE.status_code}    200