*** Settings ***
Resource    services/backend/session-service.resource


*** Keywords ***
Post Delivery Deliver To Post
    [Documentation]    deliver to post
    ...    ${delivery_ids}
    ...    ${receiver_delivery}
    [Arguments]
    ...    ${api_call_side}
    ...    ${delivery_ids}
    ...    ${receiver_delivery}
    ${body}    Create Dictionary
    ...    deliveryids=${delivery_ids}
    ...    receiverDelivery=${receiver_delivery}

    ${api_path}    Set Variable    /api/admin/delivery/deliver-to-post

    IF    '${api_call_side}' == '${MICROSERVICE_SIDE}'
        ${api_path}    Set Variable    ${MS_BACKOFFICE_LANDING_PATH}${api_path}
    END

    ${session}    Create A Session    ${api_call_side}
    ${response}    POST On Session    ${session}    ${api_path}    json=${body}    expected_status=any
    ${result}    Create Dictionary    status_code=${response.status_code}
    RETURN    ${result}
