*** Settings ***
Library         RequestsLibrary
Variables       data/CONSTANTS.yaml
Resource        services/backend/session-service.resource


*** Keywords ***
Post Admin Settlements Calendar Contracts
    [Documentation]    Search on the Contract Detail based on `${merchant_id}` and ${settle_date}.
    ...    `merchant_id` is the id of the specific merchant.
    ...    `settle_date` is a date like format '2024-08-21'
    ...    paginations contain `page` & `size` could be changed based on search parameters.
    ...    the api return the detail of contract like payment term detail start-date end-date ...
    [Arguments]    ${api_call_side}    ${merchant_id}    ${settle_date}    ${page}=0    ${size}=50

    ${api_path}    Set Variable    /admin/settlements/calendar/contracts

    IF    '${api_call_side}' == '${MICROSERVICE_SIDE}'
        ${api_path}    Set Variable    ${MS_SETTLEMENT_PATH}${api_path}
    END

    ${body}    Create Dictionary    merchantId=${merchant_id}    settleDate=${settle_date}
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
