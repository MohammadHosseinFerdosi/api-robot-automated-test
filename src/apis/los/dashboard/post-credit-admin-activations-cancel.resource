*** Settings ***
Library         RequestsLibrary
Library         Collections
Resource        services/backend/session-service.resource
Variables       data/los/credit.yaml

*** Keywords ***
POST Credit Admin Activations Cancel
    [Arguments]
    ...    ${fund_provider_code}
    ...    ${user_id}
    ...    ${credit_id}
    ...    ${admin_user_id}
    ...    ${api_call_side}

    &{headers}=    Create Dictionary
    ...    User-Id=${admin_user_id}
    ...    Content-Type=${CREDIT_CONTENT_TYPE}

    &{body}=    Create Dictionary
    ...    fundProviderCode=${fund_provider_code}
    ...    userId=${user_id}
    ...    creditId=${credit_id}

    ${api_path}=    Set Variable    ${MS_CREDIT_ONBOARDING_PATH}/admin/activations/cancel

    ${session}=    Create A Session    ${api_call_side}

    ${response}=    POST On Session
    ...    ${session}
    ...    ${api_path}
    ...    json=${body}
    ...    headers=${headers}
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
