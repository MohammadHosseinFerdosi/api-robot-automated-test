*** Settings ***
Resource    services/backend/session-service.resource


*** Keywords ***
GET Admin Users Permissions
    [Documentation]    Get The Permissions for a user in dashboard. Supports both ${MICROSERVICE_SIDE} and ${DASHBOARD_SIDE}.
    [Arguments]
    ...    ${api_call_side}
    ...    ${username}
    ...    ${zone}

    ${header}    Create Dictionary

    ${api_path}    Set Variable    /admin/users/permissions
    IF    '${api_call_side}' == '${MICROSERVICE_SIDE}'
        ${api_path}    Set Variable    ${MS_UAA_PATH}${api_path}
        Set To Dictionary    ${header}    User-Id=${username}
    END

    IF    '${zone}' != '${EMPTY}'
        Set To Dictionary    ${header}    Zone=${zone}
    END

    ${body}    Create Dictionary

    ${session}    Create A Session    ${api_call_side}
    ${response}    Get On Session
    ...    ${session}
    ...    ${api_path}
    ...    headers=${header}
    ...    data=${body}
    ...    expected_status=any

    ${result}    Create Dictionary    status_code=${response.status_code}    body=${response.json()}
    RETURN    ${result}

    [Teardown]    Delete A Session    ${session}
