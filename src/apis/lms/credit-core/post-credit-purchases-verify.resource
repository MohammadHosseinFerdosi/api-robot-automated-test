*** Settings ***
Library     String
Library     Collections
Library     RequestsLibrary
Resource    services/backend/session-service.resource


*** Keywords ***
POST Credit Purchases Verify
    [Documentation]    Verifies a purchase using a transaction ID and a type. If a ${provider_id}
    ...    is given then the offline verification is followed, otherwise it performs an online verification process
    [Arguments]
    ...    ${api_call_side}=${EMPTY}
    ...    ${tracking_code}=${EMPTY}
    ...    ${user_id}=${EMPTY}
    ...    ${provider_id}=${EMPTY}
    ...    ${type}=${EMPTY}

    ${body}    Create Dictionary
    ${headers}    Create Dictionary

    IF    '${provider_id}'=='${EMPTY}'
        ${api_path}    Set Variable    /purchases/verify/${tracking_code}
    ELSE
        ${api_path}    Set Variable    /purchases/verify
        ${body}    Create Dictionary    providerId=${provider_id}    trackingCode=${tracking_code}
    END

    IF    '${api_call_side}' == '${MICROSERVICE_SIDE}'
        ${api_path}    Set Variable    ${MS_CREDIT_MNG_PATH}${api_path}
        ${headers}    Create Dictionary    User-Id=${user_id}
    END

    ${params}    Create Dictionary    type=${type}
    ${session}    Create A Session    ${api_call_side}

    ${response}    POST On Session
    ...    ${session}
    ...    ${api_path}
    ...    params=${params}
    ...    json=${body}
    ...    headers=${headers}
    ...    expected_status=any

    IF    '${response.status_code}'=='400'
        ${result}    Create Dictionary    status_code=400    body=[]
    ELSE
        ${result}    Create Dictionary    status_code=${response.status_code}    body=${response.json()}
    END
    RETURN    ${result}

    [Teardown]    Delete A Session    ${session}
