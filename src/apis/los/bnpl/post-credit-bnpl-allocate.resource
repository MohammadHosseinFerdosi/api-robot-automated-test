*** Settings ***
Resource    services/backend/session-service.resource

*** Keywords ***
POST Credit BNPL Allocate
    [Arguments]
    ...    ${balance}
    ...    ${birth_date}
    ...    ${cell_number}
    ...    ${initiator_business_id}
    ...    ${item}
    ...    ${national_code}
    ...    ${service_type}
    ...    ${tracking_code}
    ...    ${user_id}
    ...    ${api_call_side}
    ${headers}    Create Dictionary    User-Id=${user_id}
    ${api_path}    Set Variable    /bnpl/allocate
    IF    '${api_call_side}' == '${MICROSERVICE_SIDE}'
        ${api_path}    Set Variable    ${MS_CREDIT_ONBOARDING_PATH}${api_path}
    END
    ${body}    Create Dictionary
    ...    balance=${balance}
    ...    birthDate=${birth_date}
    ...    cellNumber=${cell_number}
    ...    allocationInitiatorId=${initiator_business_id}
    ...    item=${item}
    ...    nationalCode=${national_code}
    ...    serviceType=${service_type}
    ...    trackingCode=${tracking_code}
    ${session}    Create A Session    ${api_call_side}
    ${response}    POST On Session
    ...    ${session}
    ...    ${api_path}
    ...    json=${body}
    ...    headers=${headers}
    ...    expected_status=any
    RETURN    ${response}
    [Teardown]    Delete A Session    ${session}

