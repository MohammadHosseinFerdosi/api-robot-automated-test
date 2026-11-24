*** Settings ***
Resource    services/backend/session-service.resource


*** Keywords ***
Post Requests Reject
    [Documentation]    requests accept ${request_ids}.
    [Arguments]
    ...    ${api_call_side}
    ...    ${request_ids}
    ...    ${REJECT_REASON_ID}
    ...    ${user_id}

    ${body}    Create Dictionary
    ...    requestIds=${request_ids}
    ...    rejectReasonid=${REJECT_REASON_ID}

    ${api_path}    Set Variable    /api/admin/requests/reject

    IF    '${api_call_side}' == '${MICROSERVICE_SIDE}'
        ${api_path}    Set Variable    ${MS_BACKOFFICE_LANDING_PATH}${api_path}
    END

    ${session}    Create A Session    ${api_call_side}

    ${headers}    Create Dictionary
    ...    user-id=${user_id}

    ${response}    POST On Session
    ...    ${session}
    ...    ${api_path}
    ...    headers=${headers}
    ...    json=${body}
    ...    expected_status=any
    IF    '${response.status_code}'=='400'
        ${result}    Create Dictionary    status_code=400    body=[]
    ELSE
        ${result}    Create Dictionary    status_code=${response.status_code}    body=${response.json()}
    END

    ${result}    Create Dictionary    status_code=${response.status_code}
    RETURN    ${result}
    [Teardown]    Delete A Session    ${session}