*** Settings ***
Documentation    API Keyword for Admin Whitelist Import
Library      OperatingSystem
Variables    data/los/credit.yaml
Resource     services/backend/session-service.resource
Variables    config/environment-stage.yaml

*** Keywords ***
POST Credit Admin Whitelist Import
    [Arguments]    ${user_id}    ${group_id}    ${cell_numbers}
    [Documentation]    Sends POST request to import whitelist.

    ${session}    Create A Session    ${MICROSERVICE_SIDE}

    ${headers}=    Create Dictionary
    ...    User-Id=${user_id}
    ...    Content-Type=${CREDIT_CONTENT_TYPE}

    ${body}=    Create Dictionary
    ...    groupId=${group_id}
    ...    cellNumbers=${cell_numbers}

    ${api_path}=    Set Variable
    ...    ${MS_CREDIT_ONBOARDING_PATH}/admin/whitelist/import

    ${response}=    POST On Session
    ...    ${session}
    ...    ${api_path}
    ...    json=${body}
    ...    headers=${headers}
    ...    expected_status=any

    [Teardown]    Delete A Session    ${session}

    RETURN    ${response}