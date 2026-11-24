*** Settings ***
Library     String
Library     Collections
Library     JSONLibrary
Library     RequestsLibrary
Resource    services/backend/session-service.resource


*** Keywords ***
POST Credit Purchases Pay
    [Documentation]    This Api Pay the credit Part of Offline Purchase For Channel 5,6
    ...    This API requires several input arguments.
    [Arguments]
    ...    ${api_call_side}=${EMPTY}
    ...    ${tracking_code}=${EMPTY}
    ...    ${provider_id}=${EMPTY}
    # [Arguments]
    # ...    ${api_call_side}
    # ...    ${tracking_code}

    # ${api_path}=    Set Variable    /purchases/pay
    # IF    '${api_call_side}' == '${MICROSERVICE_SIDE}'
    #    ${api_path}=    Set Variable    ${MS_CREDIT_MNG_PATH}${api_path}
    # END

    # ${params}=    Create Dictionary    trackingCode=${tracking_code}

    # ${session}=    Create A Session    ${api_call_side}

    # ${response}=    POST On Session
    # ...    ${session}
    # ...    ${api_path}
    # ...    params=${params}
    # ...    expected_status=any

    # ${result}=    Create Dictionary    status_code=${response.status_code}    body=${response.json()}
    # RETURN    ${result}

    # [Teardown]    Delete A Session    ${session}

    ${body}    Create Dictionary

    IF    '${provider_id}'=='${EMPTY}'
        ${api_path}    Set Variable    /purchases/pay/${tracking_code}
    ELSE
        ${api_path}    Set Variable    /purchases/pay
        ${body}    Create Dictionary    providerId=${provider_id}    trackingCode=${tracking_code}
    END

    IF    '${api_call_side}' == '${MICROSERVICE_SIDE}'
        ${api_path}    Set Variable    ${MS_CREDIT_MNG_PATH}${api_path}
    END

    ${session}    Create A Session    ${api_call_side}

    ${response}    POST On Session
    ...    ${session}
    ...    ${api_path}
    ...    json=${body}
    ...    expected_status=any

    IF    '${response.status_code}'=='400'
        ${result}    Create Dictionary    status_code=400    body=[]
    ELSE
        ${result}    Create Dictionary    status_code=${response.status_code}    body=${response.json()}
    END
    RETURN    ${result}

    [Teardown]    Delete A Session    ${session}
