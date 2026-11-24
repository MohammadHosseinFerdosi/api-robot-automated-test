*** Settings ***
Library         String
Library         JSONLibrary
Library         Collections
Library         RequestsLibrary
Library         library/faker_utils.py    WITH NAME    FakerLibrary
Variables       data/CONSTANTS.yaml
Resource        services/backend/session-service.resource


*** Keywords ***
Post Tickets Features Select
    [Documentation]    This API Gets ${ticket} And ${featureName} As Body, And Will Select Payment Method Such As IPG, DPG And Wallet
    ...    And Credit Payment Method Such As BNPL And etc
    [Arguments]
    ...    ${api_call_side}
    ...    ${ticket}
    ...    ${featureName}
    ...    ${Agent}
    ...    ${PLATFORM_VERSION}
    ${api_path}    Set Variable    /tickets/features/select
    IF    '${api_call_side}' == '${MICROSERVICE_SIDE}'
        ${api_path}    Set Variable    ${MS_TGS_PATH}${api_path}
    END

    ${body}    Create Dictionary
    ...    ticket=${ticket}
    ...    featureName=${featureName}

    ${header}    Create Dictionary
    ...    Agent=${Agent}
    ...    Platform-Version=${PLATFORM_VERSION}

    ${session}    Create A Session    ${api_call_side}
    ${result}    POST On Session
    ...    ${session}
    ...    ${api_path}
    ...    headers=${header}
    ...    json=${body}
    ...    expected_status=any
    ${response}    Create Dictionary    status_code=${result.status_code}    body=${result.json()}
    RETURN    ${response}
    # [Teardown]    Delete A Session    ${session}
