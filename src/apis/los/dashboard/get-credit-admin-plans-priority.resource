*** Settings ***
Resource    services/backend/session-service.resource
Variables   data/los/credit.yaml
Variables   config/environment-stage.yaml

*** Keywords ***
GET Credit Admin Plans Priority
    [Arguments]    ${api_call_side}    ${user_id}    ${basic_auth_param}=${EMPTY}    ${body}=${NONE}
    [Documentation]    Constructs and sends the GET request to retrieve plans priority.
    [Teardown]    Delete A Session    ${session}

    ${header}    Create Dictionary
    ...    User-Id=${user_id}
    ...    Content-Type=${CREDIT_CONTENT_TYPE}

    ${api_path}    Set Variable    ${MICROSERVICE_BASE_URL}${MS_CREDIT_ONBOARDING_PATH}/admin/plans/priority

    ${session}    Create A Session    ${api_call_side}    ${basic_auth_param}

    ${response}    GET On Session
    ...    ${session}
    ...    ${api_path}
    ...    headers=${header}
    ...    data=${body}
    ...    expected_status=any

    ${result}    Create Dictionary
    ...    status_code=${response.status_code}
    ...    body=${response.json()}

    RETURN    ${result}