*** Settings ***
Documentation    API Keyword for Admin Whitelist Search
Library      OperatingSystem
Variables    data/los/credit.yaml
Resource     services/backend/session-service.resource
Variables    config/environment-stage.yaml
*** Keywords ***
POST Credit Admin Whitelist Search
    [Arguments]    ${user_id}    ${page}    ${size}    ${restrictions}    ${orders}
    [Documentation]    Sends POST request to search whitelist.

    ${session}    Create A Session    ${MICROSERVICE_SIDE}

    ${headers}=    Create Dictionary
    ...    User-Id=${user_id}
    ...    Content-Type=${CREDIT_CONTENT_TYPE}

    ${body}=    Create Dictionary
    ...    restrictions=${restrictions}
    ...    orders=${orders}

    ${api_path}=    Set Variable
    ...    ${MS_CREDIT_ONBOARDING_PATH}/admin/whitelist/search?page=${page}&size=${size}

    ${response}=    POST On Session
    ...    ${session}
    ...    ${api_path}
    ...    json=${body}
    ...    headers=${headers}
    ...    expected_status=any

    [Teardown]    Delete A Session    ${session}

    RETURN    ${response}