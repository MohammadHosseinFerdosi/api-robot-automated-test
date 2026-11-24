*** Settings ***
Library         RequestsLibrary
Library         Collections
Resource        services/backend/session-service.resource

*** Keywords ***
POST Credit Admin Reject
    [Arguments]
    ...    ${credit_id}
    ...    ${content_type}
    ...    ${admin_user_id}
    ...    ${api_call_side}

    &{header}=    Create Dictionary
    ...    Content-Type=${content_type}
    ...    User-Id=${admin_user_id}

    &{body}=    Create Dictionary

    ${api_path}=    Set Variable    ${MS_CREDIT_ONBOARDING_PATH}/admin/subscription/reject/${credit_id}

    ${session}    Create A Session    ${api_call_side}

    ${response}    POST On Session
    ...    ${session}
    ...    ${api_path}
    ...    headers=${header}
    ...    json=${body}
    ...    expected_status=any

    &{result}=    Create Dictionary    status_code=${response.status_code}    body=${None}
    TRY
        ${json_body}=    Evaluate    json.loads('''${response.text}''')    modules=json
        Set To Dictionary    ${result}    body=${json_body}
    EXCEPT
        Set To Dictionary    ${result}    body=${response.text}
    END

    [Teardown]    Delete A Session    ${session}
    RETURN    ${result}
