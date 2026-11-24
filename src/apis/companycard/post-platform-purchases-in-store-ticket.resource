*** Settings ***
Library         Collections
Library         RequestsLibrary
Variables       data/CONSTANTS.yaml
Resource        services/backend/session-service.resource


*** Keywords ***
POST CompanyCard Purchases In Store Ticket
    [Documentation]    This API Gets `${api_call_side}` , `${amount}` , `${hashedPan}` , `${terminalId} , `${pspCode}`  And `${Agent}` As Mandatory Data To Get A Pos Purchase Ticket.
    [Arguments]
    ...    ${api_call_side}
    ...    ${terminalId}
    ...    ${hashedPan}
    ...    ${amount}
    ...    ${pspCode}
    ...    ${agent}
    ...    ${PLATFORM_VERSION}
    ...    ${user-id}=${EMPTY}


    ${api_path}    Set Variable    /companycard/purchases/in-store/ticket
    IF    '${api_call_side}' == '${MICROSERVICE_SIDE}'
        ${api_path}    Set Variable   ${MS_COMPANYCARD_PATH}${api_path}

    END
    
    ${body}    Create Dictionary 
    ...    terminalId=${terminalId}
    ...    hashedPan=${hashedPan}
    ...    amount=${amount}
    ...    pspCode=${pspCode}

    ${headers}    Create Dictionary    
    ...        User-Id=${user-id}
    ...        Agent=${agent}
    ...        Platform-Version=${PLATFORM_VERSION}

    ${session}    Create A Session    ${api_call_side}
    ${result}    POST On Session
    ...    ${session}
    ...    ${api_path}
    ...    json=${body}
    ...    headers=${headers}
    ...    expected_status=any

    ${response}    Create Dictionary    status_code=${result.status_code}    body=${result.json()}
    RETURN    ${response}
    [Teardown]    Delete A Session    ${session}
