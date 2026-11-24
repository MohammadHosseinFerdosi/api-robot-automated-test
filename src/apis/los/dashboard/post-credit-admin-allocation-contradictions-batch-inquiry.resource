*** Settings ***
Library         Collections
Resource        services/backend/session-service.resource
Variables       data/los/credit.yaml

*** Keywords ***
POST Credit Admin Allocation Contradictions Batch Inquiry
    [Arguments]    ${user_id}    ${from}    ${to}    ${fund_provider_code}
    [Documentation]    Sends POST request to batch inquiry allocation contradictions

    ${session}    Create A Session    ${MICROSERVICE_SIDE}

    ${headers}=    Create Dictionary
    ...    User-Id=${user_id}
    ...    Content-Type=${CREDIT_CONTENT_TYPE}

    ${body}=    Create Dictionary
    ...    from=${from}
    ...    to=${to}
    ...    fundProviderCode=${fund_provider_code}

    ${api_path}=    Set Variable
    ...    ${MS_CREDIT_ONBOARDING_PATH}/admin/allocation-contradictions/batch-inquiry

    ${response}=    POST On Session
    ...    ${session}
    ...    ${api_path}
    ...    json=${body}
    ...    headers=${headers}
    ...    expected_status=any

    [Teardown]    Delete A Session    ${session}

    RETURN    ${response}