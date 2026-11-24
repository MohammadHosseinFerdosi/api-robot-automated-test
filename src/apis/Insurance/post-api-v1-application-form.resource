*** Settings ***
Resource    services/backend/session-service.resource


*** Keywords ***
POST API V1 Application Forms
    [Arguments]    ${api_call_side}    ${license}    ${national_code}    ${user_id}
    ${headers}    Create Dictionary    user-id=${user_id}
    ${body}    Create Dictionary
    ...    license=${license}
    ...    nationalCode=${national_code}

    ${api_path}    Set Variable    /insurance/vehicle-thirdparty/v1/application-forms

    ${session}    Create A Session    ${api_call_side}
    ${response}    POST On Session
    ...    ${session}
    ...    ${api_path}
    ...    json=${body}
    ...    expected_status=any

    ${result}    Create Dictionary    status_code=${response.status_code}    body=${response.json()}

    RETURN    ${result}

    [Teardown]    Delete A Session    ${session}
