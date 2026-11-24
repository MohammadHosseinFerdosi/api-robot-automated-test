*** Settings ***
Library         Collections
Library         RequestsLibrary
Variables       data/CONSTANTS.yaml
Resource        services/backend/session-service.resource


*** Keywords ***
POST Platform Purchases In-Store Reports Search
    [Documentation]    Search on the companycard
    [Arguments]    ${api_call_side}    ${restrictions}    ${orders}    ${page}=0    ${size}=50    ${user_id}=${EMPTY}

    ${api_path}    Set Variable    /companycard/purchases/in-store/reports/search
    IF    '${api_call_side}' == '${MICROSERVICE_SIDE}'
        ${api_path}    Set Variable    ${MS_COMPANYCARD_PATH}${api_path}
        ${header}    Create Dictionary    User-Id=${user_id}
    END
    ${header}    Create Dictionary    User-Id=${user_id}
    ${body}    Create Dictionary    restrictions=${restrictions}    orders=${orders}
    ${param}    Create Dictionary    page=${page}    size=${size}
    ${session}    Create A Session    ${api_call_side}
    ${response}    POST On Session
    ...    ${session}
    ...    ${api_path}
    ...    params=${param}
    ...    headers=${header}
    ...    json=${body}
    ...    expected_status=any
    ${result}    Create Dictionary    status_code=${response.status_code}    body=${response.json()}
    RETURN    ${result}

    [Teardown]    Delete A Session    ${session}