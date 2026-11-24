*** Settings ***
Library         Collections
Library         RequestsLibrary
Variables       data/CONSTANTS.yaml
Resource        services/backend/session-service.resource


*** Keywords ***
POST Purchase Pay DPG
    [Documentation]    Post Information Such As ${cellNumber}, ${amount}, ${callbackUrl}, ${providerId}, ${type} And ${Agent} As Mandatory Data To Get Ticket
    ...    For Debit Payment Methods, And ${additionalInfo} Is A Mandatory Data To Get Ticket For Credit Payment Methods
    [Arguments]
    ...    ${api_call_side}
    ...    ${destinationType}
    ...    ${ticket}
    ...    ${type}
    ...    ${value}
    ...    ${expireDate}
    ...    ${prefix}
    ...    ${postfix}
    ...    ${encryptedPinDto}
    ...    ${certFile}
    ...    ${Agent}
    ...    ${PLATFORM_VERSION}=${EMPTY}
    ...    ${X-Forwarded-For}=${EMPTY}



    ${api_path}    Set Variable    /purchases/pay/dpg
    IF    '${api_call_side}' == '${MICROSERVICE_SIDE}'
        ${api_path}    Set Variable    ${MS_PURCHASE_PATH}${api_path}
    END
    ${source}    Create Dictionary    value=${value}     type=${type}   expireDate=${expireDate}    prefix=${prefix}    postfix=${postfix}    
    ${body}    Create Dictionary
    ...    type=${destinationType}
    ...    ticket=${ticket}
    ...    source=${source}
    ...    encryptedPinDto=${encryptedPinDto}
    ...    certFile=${certFile}

    ${header}    Create Dictionary
    ...    ticket=${ticket}
    ...    Agent=${Agent}
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


