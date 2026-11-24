*** Settings ***
Library     Collections
Library     RequestsLibrary
Resource    services/backend/session-service.resource


*** Keywords ***
Post Aggregate Ticket
    [Documentation]    Post a aggregate ticket, for spilit purchase
    [Arguments]
    ...    ${api_call_side}
    ...    ${body}
    ...    ${Agent}
    ...    ${PLATFORM_VERSION}

    ${api_path}    Set Variable    /tickets/business

    IF    '${api_call_side}' == '${MICROSERVICE_SIDE}'
        ${api_path}    Set Variable    ${MS_TGS_PATH}${api_path}
    END

    ${header}    Create Dictionary
    ...    Agent=${Agent}
    ...    Platform-Version=${PLATFORM_VERSION}

    ${session}    Create A Session    ${api_call_side}

    ${response}    POST On Session
    ...    ${session}
    ...    ${api_path}
    ...    headers=${header}
    ...    json=${body}
    ...    expected_status=any

    ${result}    Create Dictionary    status_code=${response.status_code}    body=${response.json()}
    RETURN    ${result}
     [Teardown]    Delete A Session    ${session}