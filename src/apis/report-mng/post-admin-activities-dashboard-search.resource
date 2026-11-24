*** Settings ***
Library         RequestsLibrary
Variables       data/CONSTANTS.yaml
Resource        services/backend/session-service.resource


*** Keywords ***
POST Admin Activities Dashboard Search
    [Documentation]    Search on the activites based on `${restrictions}` options and sort by `${orders}`
    ...    `restrictions` is a list with a types and values objects and could be `range, collection & or`.
    ...    `orders` is a list and search result ordered based on ASCD & DSCD of a search fields.
    ...    paginations contain `page` & `size` could be changed based on search parameters.
    [Arguments]    ${api_call_side}    ${restrictions}    ${orders}    ${page}=0    ${size}=50

    ${api_path}    Set Variable    admin/activities/dashboard/search
    ${body}    Create Dictionary    restrictions=${restrictions}    orders=${orders}
    ${param}    Create Dictionary    page=${page}    size=${size}

    ${session}    Create A Session    ${api_call_side}
    ${response}    POST On Session
    ...    ${session}
    ...    ${api_path}
    ...    params=${param}
    ...    json=${body}
    ...    expected_status=any
    ${result}    Create Dictionary    status_code=${response.status_code}    body=${response.json()}
    RETURN    ${result}

    [Teardown]    Delete A Session    ${session}
