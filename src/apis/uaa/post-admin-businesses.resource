*** Settings ***
Library     String
Library     Collections
Library     JSONLibrary
Library     RequestsLibrary
Resource    services/backend/session-service.resource


*** Keywords ***
POST Admin Businesses
    [Documentation]    This API gets business parameters ,create a
    ...    business and return business id as string value.`${roles}` should be list object.
    [Arguments]    ${api_call_side}    ${name}    ${username}    ${password}    ${roles}    ${zone}=${EMPTY}

    ${api_path}    Set Variable    /admin/businesses
    IF    '${api_call_side}' == '${MICROSERVICE_SIDE}'
        ${api_path}    Set Variable    ${MS_UAA_PATH}${api_path}
    END

    ${header}    Create Dictionary    Agent=CONSOLE
    IF    '${zone}' != '${EMPTY}'
        Set To Dictionary    ${header}    Zone=${zone}
    END

    ${body}    Create Dictionary
    ...    name=${name}
    ...    username=${username}
    ...    password=${password}
    ...    roles=${roles}
    ...    active=true

    ${session}    Create A Session    ${api_call_side}
    ${response}    POST On Session
    ...    ${session}
    ...    ${api_path}
    ...    headers=${header}
    ...    json=${body}
    ...    expected_status=any
    ${result}    Create Dictionary    status_code=${response.status_code}    body=${response.json()}
    IF    ${response.status_code} == 200
        ${userId}    Get Value From Json    ${response.json()}    $.userDetail.userId    fail_on_empty=True
        Set To Dictionary    ${result}    business_id=${userId}[0]
    END
    RETURN    ${result}
    [Teardown]    Delete A Session    ${session}
