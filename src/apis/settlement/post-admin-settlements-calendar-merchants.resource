*** Settings ***
Library         RequestsLibrary
Variables       data/CONSTANTS.yaml
Resource        services/backend/session-service.resource


*** Keywords ***
Post Admin Settlements Calendar Merchants
    [Documentation]    Find the merchants that should be Settle on `${date}`.
    ...    `date` is a date like format '2024-08-21'
    ...    paginations contain `page` & `size` could be changed based on search parameters.
    ...    the api return list of merchants
    [Arguments]    ${api_call_side}    ${date}    ${page}=0    ${size}=50

    ${api_path}    Set Variable    /admin/settlements/calendar/merchants

    IF    '${api_call_side}' == '${MICROSERVICE_SIDE}'
        ${api_path}    Set Variable    ${MS_SETTLEMENT_PATH}${api_path}
    END

    ${body}    Create Dictionary    date=${date}    page=${page}    size=${size}

    ${session}    Create A Session    ${api_call_side}
    ${response}    POST On Session
    ...    ${session}
    ...    ${api_path}
    ...    json=${body}
    ...    expected_status=any
    ${result}    Create Dictionary    status_code=${response.status_code}    body=${response.json()}
    RETURN    ${result}

    [Teardown]    Delete A Session    ${session}
