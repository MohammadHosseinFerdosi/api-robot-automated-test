*** Settings ***
Library     RequestsLibrary
Resource    services/backend/session-service.resource


*** Keywords ***
Post delivery reserve pickup-post
    [Documentation]    pickup-post for
    ...    ${logistic_Token3}
    ...    ${city_id}
    [Arguments]    ${api_call_side}
    ...    ${logistic_Token3}
    ...    ${city_id}
    ...    ${user_id}
    ...    ${x_api_version}

    ${body}    Create Dictionary
    ...    logistictoken=${logistic_Token3}
    ...    cityId=${city_id}

    ${api_path}    Set Variable    /api/delivery/reserve/pickup-post

    IF    '${api_call_side}' == '${MICROSERVICE_SIDE}'
        ${api_path}    Set Variable    ${MS_BACKOFFICE_LANDING_PATH}${api_path}
    END

    ${session}    Create A Session    ${api_call_side}
    ${headers}    Create Dictionary
    ...    X-Api-Version=${x_api_version}
    ...    user-id=${user_id}
    ${response}    POST On Session
    ...    ${session}
    ...    ${api_path}
    ...    headers=${headers}
    ...    json=${body}
    ...    expected_status=any
    ${result}    Create Dictionary    status_code=${response.status_code}    body=${response.json()}
    RETURN    ${result}
