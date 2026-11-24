*** Settings ***
Library     String
Library     Collections
Library     RequestsLibrary
Resource    services/backend/session-service.resource

*** Keywords ***
Post Coupon Admin Coupon Codes
    [Documentation]    Sends a request to create a coupon with the specified parameters.
    [Arguments]
    ...    ${api_call_side}
    ...    ${coupon_id}

    ${api_path}=    Set Variable    /admin/coupon/codes/${coupon_id}
    ${headers}=    Create Dictionary

    IF    '${api_call_side}' == '${MICROSERVICE_SIDE}'
        ${api_path}=    Set Variable    ${MS_COUPON}/admin/coupon/codes/${coupon_id}
        Set To Dictionary    ${headers}    User-Id=${DASHBOARD_USERNAME}
    END
    
    ${session}    Create A Session    ${api_call_side}
    ${response}=    POST On Session
    ...    ${session}
    ...    ${api_path}
    ...    headers=${headers}
    ...    expected_status=any

    ${result}=    Create Dictionary    status_code=${response.status_code}    body=${response.json()}
    [Teardown]    Delete A Session    ${session}
    RETURN    ${result}