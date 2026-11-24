*** Settings ***
Library         RequestsLibrary
Library         Collections
Resource        services/backend/session-service.resource
Variables       data/los/credit.yaml

*** Keywords ***
POST Credit Activation Cancel
    [Arguments]
    ...    ${fund_provider_code}
    ...    ${credit_id}
    ...    ${cancel_reason_type}
    ...    ${cancel_reason}
    ...    ${api_call_side}
    ...    ${user_id}

    &{headers}=    Create Dictionary
    ...    Referer=${MICROSERVICE_BASE_URL}
    ...    User-Id=${user_id}
    ...    Content-Type=${CREDIT_CONTENT_TYPE}

    ${api_path}=    Set Variable    ${MS_CREDIT_ONBOARDING_PATH}/activations/cancel

    &{body}=    Create Dictionary
    ...    fundProviderCode=${fund_provider_code}
    ...    creditId=${credit_id}
    ...    cancelReasonType=${cancel_reason_type}
    ...    cancelReason=${cancel_reason}

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
    RETURN      ${result}

