*** Settings ***
Library         Collections
Library         RequestsLibrary
Variables       data/CONSTANTS.yaml
Resource        services/backend/session-service.resource


*** Keywords ***
 Get Tickets
    [Documentation]    This API Gets ${ticket} As Mandatory Data In URL And Will Return Payment Methods.
    [Arguments]
    ...    ${api_call_side}
    ...    ${ticket}
    ...    ${PLATFORM_VERSION}

    ${api_path}    Set Variable    /tickets/${ticket}
    IF    '${api_call_side}' == '${MICROSERVICE_SIDE}'
        ${api_path}    Set Variable   ${MS_TGS_PATH}${api_path}

    END
    
    ${headers}    Create Dictionary    Platform-Version=${PLATFORM_VERSION}
    ${session}    Create A Session    ${api_call_side}
    ${result}    GET On Session
    ...    ${session}
    ...    ${api_path}
    ...    headers=${headers}
    ...    expected_status=any

    ${response}    Create Dictionary    status_code=${result.status_code}    body=${result.json()}
    RETURN    ${response}
    [Teardown]    Delete A Session    ${session}
