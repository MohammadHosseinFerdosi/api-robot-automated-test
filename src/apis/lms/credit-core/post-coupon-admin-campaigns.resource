*** Settings ***
Library     String
Library     Collections
Library     RequestsLibrary
Resource    services/backend/session-service.resource

*** Keywords ***
Post Coupon Admin Campaigns
    [Documentation]    Sends a request to create a coupon campaign with the specified parameters.
    [Arguments]
    ...    ${api_call_side}
    ...    ${name}
    ...    ${description}
    ...    ${funderWalletUserId}
    ...    ${funderWalletName}
    ...    ${totalBudget}
    ...    ${totalUsageLimit}
    ...    ${startDate}
    ...    ${endDate}
    ${api_path}=    Set Variable    /admin/campaigns
    ${headers}=    Create Dictionary
    ${campaign_data}=    Create Dictionary
    ...    name=${name}
    ...    description=${description}
    ...    funderWalletUserId=${funderWalletUserId}
    ...    funderWalletName=${funderWalletName}
    ...    totalBudget=${totalBudget}
    ...    totalUsageLimit=${totalUsageLimit}
    ...    startDate=${startDate}
    ...    endDate=${endDate}

    IF    '${api_call_side}' == '${MICROSERVICE_SIDE}'
        ${api_path}=    Set Variable    ${MS_COUPON}/admin/campaigns
        Set To Dictionary    ${headers}    User-Id=${DASHBOARD_USERNAME}
    END
    
    ${session}    Create A Session    ${api_call_side}
    ${response}=    POST On Session
    ...    ${session}
    ...    ${api_path}
    ...    json=${campaign_data}
    ...    headers=${headers}
    ...    expected_status=any

    ${result}=    Create Dictionary    status_code=${response.status_code}    body=${response.json()}
    [Teardown]    Delete A Session    ${session}
    RETURN    ${result}