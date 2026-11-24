*** Settings ***
Library         Collections
Library         RequestsLibrary
Variables       data/CONSTANTS.yaml
Resource        services/backend/session-service.resource


*** Keywords ***
POST Tickets Business
    [Documentation]    Post Information Such As ${cellNumber}, ${amount}, ${callbackUrl}, ${providerId}, ${type} And ${Agent} As Mandatory Data To Get Ticket
    ...    For Debit Payment Methods, And ${additionalInfo} Is A Mandatory Data To Get Ticket For Credit Payment Methods
    [Arguments]
    ...    ${api_call_side}
    ...    ${cellNumber}
    ...    ${amount}
    ...    ${callbackUrl}
    ...    ${providerId}
    ...    ${type}
    ...    ${Agent}
    ...    ${PLATFORM_VERSION}
    ...    ${userId}=${EMPTY}
    ...    ${additionalInfo}=&{EMPTY}

    Set Suite Variable    ${additionalInfo}
    Set Suite Variable    ${Agent}
    ${api_path}    Set Variable    /tickets/business
    IF    '${api_call_side}' == '${MICROSERVICE_SIDE}'
        ${api_path}    Set Variable    ${MS_TGS_PATH}${api_path}
    END

    ${body}    Create Dictionary
    ...    cellNumber=${cellNumber}
    ...    amount=${amount}
    ...    callbackUrl=${callbackUrl}
    ...    providerId=${providerId}
    ...    additionalInfo=${additionalInfo}

    ${header}    Create Dictionary
    ...    Agent=${Agent}
    ...    Platform-Version=${PLATFORM_VERSION}
    ...    User-Id=${userId}

    ${param}    Create Dictionary    type=${type}

    ${session}    Create A Session    ${api_call_side}
    ${result}    POST On Session
    ...    ${session}
    ...    ${api_path}
    ...    headers=${header}
    ...    params=${param}
    ...    json=${body}
    ...    expected_status=any
    ${response}    Create Dictionary    status_code=${result.status_code}    body=${result.json()}
    RETURN    ${response}

    [Teardown]    Delete A Session    ${session}
