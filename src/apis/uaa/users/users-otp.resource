*** Settings ***
Library         String
Library         Collections
Library         JSONLibrary
Library         RequestsLibrary
Variables       data/CONSTANTS.yaml
Resource        services/backend/session-service.resource


*** Keywords ***
POST Users OTP
    [Documentation]    Create OTP token based on `${cell_number}`. This api return `status code` and
    ...    `result` section with `userId` field in response and otp token should get with redis api.
    [Arguments]    ${api_call_side}    ${ticket}      ${agent}    ${PLATFORM_VERSION} 

    # Microservice call side not implemented.
    ${api_path}    Set Variable    /users/otp
    ${headers}    Create Dictionary    &{EMPTY}
    ...    Agent=${agent}       
    ...    Platform-Version=${PLATFORM_VERSION}        
    ...    ticket=${ticket}

    ${body}    Create Dictionary    
    ${session}    Create A Session    ${GENERAL_SIDE}
    ${response}    POST On Session
    ...    ${session}
    ...    ${api_path}
    ...    json=${body}
    ...    headers=${headers}
    ...    expected_status=any

    ${result}    Create Dictionary
    ...    status_code=${response.status_code}
    ...    body=${response.json()}
    RETURN    ${result}

    [Teardown]    Delete A Session    ${session}

