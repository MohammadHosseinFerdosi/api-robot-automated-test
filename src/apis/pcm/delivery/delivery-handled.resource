*** Settings ***
Resource        services/backend/session-service.resource
Variables       data/pcm/delivery-reserve-return-post-variables.yaml


*** Keywords ***
Post Delivery Handled
    [Documentation]    Delivery Handled
    [Arguments]
    ...    ${api_call_side}
    ...    ${DELIVERY_HANDLED_ID}
    ${body}    Create Dictionary
    ...    deliveryIds=${DELIVERY_HANDLED_ID}

    ${api_path}    Set Variable    /api/admin/delivery/handled

    IF    '${api_call_side}' == '${MICROSERVICE_SIDE}'
        ${api_path}    Set Variable    ${MS_BACKOFFICE_LANDING_PATH}${api_path}
    END

    ${session}    Create A Session    ${api_call_side}

    ${headers}    Create Dictionary
    ...    user-id=test-staff-user
    ...    X-Api-Version=1

    ${response}    POST On Session
    ...    ${session}
    ...    ${api_path}
    ...    json=${body}
    ...    headers=${headers}
    ...    expected_status=any
    IF    '${response.status_code}'=='400'
        ${result}    Create Dictionary    status_code=400    body=[]
    ELSE
        ${result}    Create Dictionary    status_code=${response.status_code}    body=${response.json()}
    END

    ${result}    Create Dictionary    status_code=${response.status_code}
    RETURN    ${result}

    [Teardown]    Delete A Session    ${session}
