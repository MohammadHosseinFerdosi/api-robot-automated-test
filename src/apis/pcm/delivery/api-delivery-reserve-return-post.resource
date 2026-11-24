*** Settings ***
Library     RequestsLibrary
Resource    services/backend/session-service.resource


*** Keywords ***
Post Delivery Reserve Return-Post
    [Documentation]    return-post for ${reserve_session} ${logistic_token} ${city_id} ${street_address} ${postal_code} ${number} ${unit}
    [Arguments]    ${api_call_side}
    ...    ${reserve_session}
    ...    ${logistic_token}
    ...    ${city_id}
    ...    ${street_address}
    ...    ${postal_code}
    ...    ${number}
    ...    ${unit}

    ${api_path}    Set Variable    /api/delivery/reserve/return-post

    IF    '${api_call_side}' == '${MICROSERVICE_SIDE}'
        ${api_path}    Set Variable    ${MS_BACKOFFICE_LANDING_PATH}${api_path}
    END

    ${body}    Create Dictionary    reserveSession=${reserve_session}
    ...    logisticToken=${logistic_token}
    ...    cityId=${city_id}
    ...    streetAddress=${street_address}
    ...    postalCode=${postal_code}
    ...    no=${number}
    ...    unit=${unit}

    ${session}    Create A Session    ${api_call_side}
    ${response}    POST On Session
    ...    ${session}
    ...    ${api_path}
    ...    json=${body}
    ...    expected_status=any
    ${result}    Create Dictionary    status_code=${response.status_code}    body=${response.json()}
    RETURN    ${result}
