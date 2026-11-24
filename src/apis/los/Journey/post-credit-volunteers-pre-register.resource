*** Settings ***
Resource    services/backend/session-service.resource

*** Keywords ***
POST Credit Volunteers Pre Register
    [Arguments]    ${api_call_side}    ${platform_version}    ${user_id}    ${nationalcode}    ${birthdate}    ${groupid}    ${planid}    ${cartreservationrequest}    ${balance}

    ${header}    Create Dictionary    Platform-Version=${platform_version}

    ${api_path}    Set Variable    /volunteers/pre-register

    IF    '${api_call_side}' == '${MICROSERVICE_SIDE}'
        ${api_path}    Set Variable    ${MS_CREDIT_ONBOARDING_PATH}${api_path}
        Set To Dictionary    ${header}    user-id    ${user_id}
    ELSE
        ${api_path}    Set Variable    /credit${api_path}
    END

    ${body}    Create Dictionary
    ...    nationalCode=${nationalcode}
    ...    birthDate=${birthdate}
    ...    groupId=${groupid}
    ...    planId=${planid}
    ...    cartReservationRequest=${cartreservationrequest}
    ...    balance=${balance}

    ${session}    Create A Session    ${api_call_side}
    ${response}    POST On Session    ${session}    ${api_path}    json=${body}    headers=${header}    expected_status=any
    &{result}    Create Dictionary    status_code=${response.status_code}    body=${response.json()}

    RETURN    ${result}
    [Teardown]    Delete A Session    ${session}
