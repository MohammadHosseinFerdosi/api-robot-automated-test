*** Settings ***
Resource    services/backend/session-service.resource
Variables   config/environment-stage.yaml
Variables   data/los/credit.yaml

*** Keywords ***
GET Credit Admin Allocation Contradictions By Credit Id
    [Arguments]    ${user_id}    ${credit_id}    ${fund_provider_code}

    ${session}    Create A Session    ${MICROSERVICE_SIDE}

    ${headers}=    Create Dictionary
    ...    User-Id=${user_id}
    ...    Content-Type=${CREDIT_CONTENT_TYPE}

    ${api_path}=    Set Variable
    ...    ${MS_CREDIT_ONBOARDING_PATH}/admin/allocation-contradictions/${credit_id}?fundProviderCode=${fund_provider_code}

    ${response}=    GET On Session
    ...    ${session}
    ...    ${api_path}
    ...    headers=${headers}
    ...    expected_status=any

    [Teardown]    Delete A Session    ${session}

    RETURN    ${response}