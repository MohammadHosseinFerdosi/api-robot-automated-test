*** Settings ***
Library         Collections
Library         RequestsLibrary
Variables       data/CONSTANTS.yaml
Resource        services/backend/session-service.resource
Resource        services/backend/auth-service.resource

*** Keywords ***
POST Terminals
    [Documentation]    This API Gets `${api_call_side}` , `${active}` , `${bankCode}` , `${kycSupported} , `${ownerUserId}` ,
    ...     `${payTypes}`  , `${pinCode}` , `${pspCode} , And `${terminalId}`As Mandatory Data To Assign A Terminal With Special
    ...    Supported Tag To A Business.
    [Arguments]
    ...    ${paymentGateway}
    ...    ${transactionType}
    ...    ${api_call_side}
    ...    ${terminalId}
    ...    ${kycSupportedStatus}
    ...    ${bankCode}
    ...    ${pinCode}
    ...    ${merchantId}
    ...    ${businessId}
    ...    ${pspCode}
    ...    ${activityStatus}

    ${api_path}    Set Variable   /admin/terminals
    IF    '${api_call_side}'=='${MICROSERVICE_SIDE}'
        ${api_path}    Set Variable   ${MS_SWITCH_PSP_PATH}/terminals
        ${paymentTransaction}    Create Dictionary    paymentGateway=${paymentGateway}    transactionType=${transactionType}
        @{payTypes}     Create List        ${paymentTransaction}
    ELSE 

        @{payTypes}    Create List    ${paymentGateway}    
    END

    ${headers}    Create Dictionary    Content-Type=application/json
    ${body}    Create Dictionary 
    ...    terminalId=${terminalId}
    ...    kycSupported=${kycSupportedStatus}
    ...    bankCode=${bankCode}
    ...    pinCode=${pinCode}
    ...    merchantId=${merchantId}
    ...    ownerUserId=${businessId}
    ...    pspCode=${pspCode}
    ...    active=${activityStatus}
    ...    payTypes=@{payTypes}
    
    ${headers}    Create Dictionary    Content-Type=application/json    User-Agent=CONSOLE    Platform-Version=2022-02-02
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
