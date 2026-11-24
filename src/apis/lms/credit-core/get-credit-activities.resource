*** Settings ***
Library         String
Library         Collections
Library         JSONLibrary
Library         RequestsLibrary
Resource        services/backend/session-service.resource


*** Keywords ***
GET Credit Activity
    [Arguments]
    ...    ${api_call_side}
    ...    ${purchase_tracking_code}
    ...    ${user_id}

    ${headers}    Create Dictionary
    ...    User-Id=${user_id}
    ${api_path}    Set Variable    /activities/app/${purchase_tracking_code}
    IF    '${api_call_side}' == '${MICROSERVICE_SIDE}'
        ${api_path}    Set Variable    ${MS_REPORT_MNG_PATH}${api_path}
    END

    ${session}    Create A Session    ${api_call_side}

    ${response}    GET On Session
    ...    ${session}
    ...    ${api_path}
    ...    headers=${headers}
    ...    expected_status=any

    ${result}    Create Dictionary    status_code=${response.status_code}    body=${response.json()}
    RETURN    ${result}

    [Teardown]    Delete A Session    ${session}
