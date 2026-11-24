*** Settings ***
Resource    services/backend/session-service.resource


*** Keywords ***
Post Delivery Register Tracking Code
    [Documentation]    register tracking code
    ...    ${mobile-number}
    ...    ${tracking-code}
    [Arguments]
    ...    ${api_call_side}
    ...    ${mobile-number}
    ...    ${tracking-code}
    ${body}    Create Dictionary
    ...    mobilenumber=${mobile-number}
    ...    trackingCode=${tracking-code}

    ${api_path}    Set Variable    /api/admin/delivery/register-tracking-code

    IF    '${api_call_side}' == '${MICROSERVICE_SIDE}'
        ${api_path}    Set Variable    ${MS_BACKOFFICE_LANDING_PATH}${api_path}
    END

    ${session}    Create A Session    ${api_call_side}
    ${response}    POST On Session    ${session}    ${api_path}    json=${body}    expected_status=any
    ${result}    Create Dictionary    status_code=${response.status_code}
    RETURN    ${result}
