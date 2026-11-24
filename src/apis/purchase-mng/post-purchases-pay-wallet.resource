*** Settings ***
Library         Collections
Library         RequestsLibrary
Variables       data/CONSTANTS.yaml
Resource        services/backend/session-service.resource


*** Keywords ***
POST Purchase Pay Wallet
    [Documentation]    Post Information Such As ${type}, ${ticket} As Mandatory Data For Wallet Purchase
    [Arguments]
    ...    ${api_call_side}
    ...    ${type}
    ...    ${ticket}
    ...    ${PLATFORM_VERSION}=${EMPTY}
    ...    ${X-Forwarded-For}=${EMPTY}


    ${api_path}    Set Variable    /purchases/pay/wallet
    IF    '${api_call_side}' == '${MICROSERVICE_SIDE}'
        ${api_path}    Set Variable    ${MS_PURCHASE_PATH}${api_path}
    END
    ${body}    Create Dictionary
    ...    type=${type}
    ...    ticket=${ticket}


    ${header}    Create Dictionary
    ...    Platform-Version=${PLATFORM_VERSION}
    ...    X-Forwarded-For=${X-Forwarded-For}


    ${session}    Create A Session    ${api_call_side}
    ${result}    POST On Session
    ...    ${session}
    ...    ${api_path}
    ...    headers=${header}
    ...    json=${body}
    ...    expected_status=any
    ${response}    Create Dictionary    status_code=${result.status_code}    body=${result.json()}
    RETURN    ${response}
    [Teardown]    Delete A Session    ${session}


