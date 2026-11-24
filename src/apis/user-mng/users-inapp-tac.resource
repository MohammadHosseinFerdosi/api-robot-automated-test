*** Settings ***
Library         String
Library         Collections
Library         JSONLibrary
Library         RequestsLibrary
Variables       data/CONSTANTS.yaml
Resource        services/backend/session-service.resource
Resource        services/backend/auth-service.resource


*** Keywords ***
POST Users In-App TAC
    [Documentation]    Call Terms And Conditions API For A User Ehit Wallet Activation Ticket.
    [Arguments]    ${api_call_side}    ${ticket}    ${agent}    ${Platform_Version}
    # Microservice call side not implemented yet.
    ${api_path}    Set Variable    /users/in-app/tac
    ${body}    Create Dictionary    &{EMPTY}
    ${headers}    Create Dictionary    
    ...    ticket=${ticket}
    ...    Agent=${agent}
    ...    Platform-Version=${Platform_Version}
    ...    Cookie=_ga=GA1.2.1056947256.1728891286; _gid=GA1.2.556817409.1728891286; _ga_XMYM18D4GP=GS1.2.1728902419.4.0.1728902419.0.0.0; TS01502e64=01faf121e381ae4f60b962e7cda749ab534ba1c626a738c46dfc936b0bda756dcab48e6cd4fc480c613685f6098f08ba245a371ed6

    ${session}    Create A Session    ${GENERAL_SIDE} 
    ${response}    POST On Session
    ...    ${session}
    ...    ${api_path}
    ...    headers=${headers}
    ...    json=${body}
    ...    expected_status=any

    ${result}    Create Dictionary
    ...    status_code=${response.status_code}
    ...    body=${response.json()}
    RETURN    ${result}

    [Teardown]    Delete A Session    ${session}
