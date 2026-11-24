*** Settings ***
Documentation       Post order swap Api calling from ${MICROSERVICE_SIDE} and ${APP_SIDE}
Resource            services/backend/session-service.resource


*** Keywords ***
Post Order Swap
    [Documentation]    Send a request to order swap
    [Arguments]
    ...    ${api_call_side}
    ...    ${platform-version}
    ...    ${userid}

    ${headers}    Create Dictionary    Platform-Version=${platform-version}
    ${api_path}    Set Variable    /plans
    IF    '${api_call_side}' == '${MICROSERVICE_SIDE}'
        ${api_path}    Set Variable    ${MS_CREDIT_ONBOARDING_PATH}${api_path}
        Set To Dictionary    ${headers}    User-Id=${userid}
    ELSE
        ${api_path}    Set Variable    /credit${api_path}
    END

    ${session}    Create A Session    ${api_call_side}
    ${response}    GET On Session
    ...    ${session}
    ...    ${api_path}
    ...    headers=${headers}
    ...    expected_status=any

    &{result}    Create Dictionary    status_code=${response.status_code}    body=${response.json()}

    RETURN    ${result}
    [Teardown]    Delete A Session    ${session}