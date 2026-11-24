*** Settings ***
Library         Collections
Resource        services/backend/session-service.resource
Variables       data/los/credit.yaml

*** Keywords ***
POST Credit Admin Allocation Contradictions Search
    [Arguments]    ${user_id}    ${page}    ${size}    ${restrictions}    ${orders}
    [Documentation]    Sends POST request to search allocation contradictions

    ${session}    Create A Session    ${MICROSERVICE_SIDE}

    ${headers}=    Create Dictionary
    ...    User-Id=${user_id}
    ...    Content-Type=${CREDIT_CONTENT_TYPE}

    ${body}=    Create Dictionary
    ...    restrictions=${restrictions}
    ...    orders=${orders}

    ${api_path}=    Set Variable
    ...    ${MS_CREDIT_ONBOARDING_PATH}/admin/allocation-contradictions/search?page=${page}&size=${size}

    ${response}=    POST On Session
    ...    ${session}
    ...    ${api_path}
    ...    json=${body}
    ...    headers=${headers}
    ...    expected_status=any

    [Teardown]    Delete A Session    ${session}

    RETURN    ${response}