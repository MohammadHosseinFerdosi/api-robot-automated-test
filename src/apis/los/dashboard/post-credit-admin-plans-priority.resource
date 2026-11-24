*** Settings ***
Resource         services/backend/session-service.resource
Library          RequestsLibrary
Variables        data/los/credit.yaml


*** Keywords ***
POST Credit Admin Plans Priority
    [Arguments]    ${api_call_side}    ${user_id}    ${body}    ${basic_auth_param}=${EMPTY}
    [Teardown]    Delete A Session    ${session}

    ${header}    Create Dictionary
    ...    User-Id=${user_id}
    ...    Content-Type=${CREDIT_CONTENT_TYPE}

    ${api_path}    Set Variable    ${MICROSERVICE_BASE_URL}${MS_CREDIT_ONBOARDING_PATH}/admin/plans/priority

    ${session}    Create A Session    ${api_call_side}    ${basic_auth_param}

    ${response}    POST On Session
    ...    ${session}
    ...    ${api_path}
    ...    headers=${header}
    ...    json=${body}
    ...    expected_status=any

    ${response_body}    Set Variable    ${response.json()}

    ${result}    Create Dictionary
    ...    status_code=${response.status_code}
    ...    body=${response_body}

    RETURN    ${result}