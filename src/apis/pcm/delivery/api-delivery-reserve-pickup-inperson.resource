*** Settings ***
Library     RequestsLibrary
Resource    services/backend/session-service.resource


*** Keywords ***
Post delivery reserve pickup-inperson
    [Documentation]    pickup-inperson for
    ...    ${logistic_token2}
    ...    ${city_id}
    ...    ${delivery_providerid}
    ...    ${timeslotid1}
    ...    ${reserve_date}
    [Arguments]    ${api_call_side}
    ...    ${logistic_token2}
    ...    ${city_id}
    ...    ${delivery_providerid}
    ...    ${timeslotid1}
    ...    ${reserve_date}
    ...    ${user_id}
    ...    ${x_api_version}

    ${body}    Create Dictionary
    ...    logistictoken=${logistic_token2}
    ...    cityId=${city_id}
    ...    deliveryproviderid=${delivery_providerid}
    ...    timeslotid=${timeslotid1}
    ...    reservedate=${reserve_date}

    ${api_path}    Set Variable    /api/delivery/reserve/pickup-inperson

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
