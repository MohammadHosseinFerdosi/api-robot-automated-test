*** Settings ***
Library    RequestsLibrary
Resource    services/backend/session-service.resource
Variables   data/los/credit.yaml

*** Keywords ***
POST Credit Activations Profile In Progress
    [Arguments]
    ...    ${api_call_side}
    ...    ${credit_id}
    ...    ${user_id}

    ${basic_auth_param}=    Set Variable    ${EMPTY}
    &{header}=    Create Dictionary
    ...    User-Id=${user_id}
    ...    Content-Type=${CREDIT_CONTENT_TYPE}
    ${api_path}=    Set Variable    /activations/profile/in-progress/${credit_id}

    IF    '${api_call_side}' == '${MICROSERVICE_SIDE}'
        ${api_path}=    Set Variable    ${MS_CREDIT_ONBOARDING_PATH}${api_path}
    ELSE
        ${api_path}=    Set Variable    /credit${api_path}
    END

    &{body}=    Create Dictionary
    ${session}    Create A Session    ${api_call_side}    ${basic_auth_param}
    ${response}    POST On Session
    ...    ${session}
    ...    ${api_path}
    ...    headers=${header}
    ...    data=${body}
    ...    expected_status=any
    &{result}=    Create Dictionary    status_code=${response.status_code}    body=${None}
    TRY
        ${json_body}=    Evaluate    json.loads('''${response.text}''')    json
        Set To Dictionary    ${result}    body=${json_body}
    EXCEPT
        Set To Dictionary    ${result}    body=${response.text}
    END
    [Teardown]    Delete A Session    ${session}
    RETURN    ${result}
