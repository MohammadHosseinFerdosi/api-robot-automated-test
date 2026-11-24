*** Settings ***
Library         RequestsLibrary
Library         Collections
Resource        services/backend/session-service.resource
Variables       data/los/credit.yaml

*** Keywords ***
POST Credit Admin Activations Suspend Restriction Save
    [Arguments]
    ...    ${api_call_side}
    ...    ${user_id}
    ...    ${activation_status}
    ...    ${group_ids}
    ...    ${basic_auth_param}=${EMPTY}

    ${header}    Create Dictionary
    ...    Content-Type=${CREDIT_CONTENT_TYPE}
    ...    User-Id=${user_id}

    ${api_path}    Set Variable
    ...    ${MS_CREDIT_ONBOARDING_PATH}/admin/activations/suspend/restriction/save

    ${body}    Create Dictionary
    ...    activationStatus=${activation_status}
    ...    groupIds=${group_ids}

    ${session}    Create A Session    ${api_call_side}    ${basic_auth_param}

    ${response}    POST On Session
    ...    ${session}
    ...    ${api_path}
    ...    headers=${header}
    ...    json=${body}
    ...    expected_status=any

    &{result}    Create Dictionary
    ...    status_code=${response.status_code}
    ...    body=${response.json()}

    [Teardown]    Delete A Session    ${session}
    RETURN    ${result}