*** Settings ***
Library         RequestsLibrary
Variables       data/CONSTANTS.yaml
Resource        services/backend/session-service.resource


*** Keywords ***
Post Admin Settlements Calendar Total
    [Documentation]    Search on the Settle date    based on `${from_date}` and ${to_date}.
    ...    `from_date` is a date like format '2024-08-21'
    ...    `to_date` is a date like format '2024-20-21'
    ...    paginations contain `page` & `size` could be changed based on search parameters.
    ...    the api return the information of each day like total amount number of merchants number of contracts for settle.
    [Arguments]    ${api_call_side}    ${from_date}    ${to_date}    ${page}=0    ${size}=50

    ${api_path}    Set Variable    /admin/settlements/calendar/total

    IF    '${api_call_side}' == '${MICROSERVICE_SIDE}'
        ${api_path}    Set Variable    ${MS_SETTLEMENT_PATH}${api_path}
    END

    ${body}    Create Dictionary    fromDate=${from_date}    toDate=${to_date}
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
