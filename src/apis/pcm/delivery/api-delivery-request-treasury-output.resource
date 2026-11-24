*** Settings ***
Resource        services/backend/session-service.resource
Variables       data/pcm/delivery-reserve-return-post-variables.yaml


*** Keywords ***
Post Delivery Request Treasury Output
    [Documentation]    request treasury output
    ...    ${delivery_ids1}
    [Arguments]
    ...    ${api_call_side}
    ...    ${delivery_ids1}
    ${body}    Create Dictionary
    ...    deliveryids=${delivery_ids1}

    ${api_path}    Set Variable    /api/admin/delivery/request-treasury-output

    IF    '${api_call_side}' == '${MICROSERVICE_SIDE}'
        ${api_path}    Set Variable    ${MS_BACKOFFICE_LANDING_PATH}${api_path}
    END

    ${session}    Create A Session    ${api_call_side}

    ${headers}    Create Dictionary
    ...    user-id=test-staff-user

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
