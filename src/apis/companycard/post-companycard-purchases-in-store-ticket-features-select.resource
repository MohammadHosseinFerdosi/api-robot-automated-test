*** Settings ***
Library         Collections
Library         RequestsLibrary
Variables       data/CONSTANTS.yaml
Resource        services/backend/session-service.resource


*** Keywords ***
POST CompanyCard Purchases In Store Ticket Features Select
    [Documentation]    This API Gets `${ticket}` , `${featureName}` As Mandatory Data To Return A Pay URL.
    [Arguments]
    ...    ${api_call_side}
    ...    ${ticket}
    ...    ${featureName}
    ...    ${agent}
    ...    ${PLATFORM_VERSION}
    

    ${api_path}    Set Variable    /companycard/purchases/in-store/ticket/features/select
    IF    '${api_call_side}' == '${MICROSERVICE_SIDE}'
        ${api_path}    Set Variable   ${MS_COMPANYCARD_PATH}${api_path}

    END
    
    ${body}    Create Dictionary 
    ...    ticket=${ticket}
    ...    featureName=${featureName}

    ${headers}    Create Dictionary    
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
