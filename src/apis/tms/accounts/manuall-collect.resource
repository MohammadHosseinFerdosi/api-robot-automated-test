*** Settings ***
Resource        services/backend/session-service.resource
Variables       data/tms/treasury-statment-variables.yaml


*** Keywords ***
Post Manuall Collect
    [Arguments]
    ...    ${api_call_side}
    ...    ${body}

     ${api_path}    Set Variable    /api/admin/statements/collect

    IF    '${api_call_side}' == '${MICROSERVICE_SIDE}'
        ${api_path}    Set Variable    ${MS_BACKOFFICE_TREASURY_PATH}${api_path}
    END

    ${session}    Create A Session    ${api_call_side}

    ${headers}    Create Dictionary
    ...    user-id=backoffice-tms

    ${response}    POST On Session
    ...    ${session}
    ...    ${api_path}
    ...    json=${body}
    ...    headers=${headers}
    ...    expected_status=any
    IF    '${response.status_code}'=='400'
        ${result}    Create Dictionary    status_code=400    body=[]
    ELSE
        ${result}    Create Dictionary    status_code=${response.status_code}    body=${response.json()}
    END

    ${result}    Create Dictionary    status_code=${response.status_code}
    [Teardown]    Delete A Session    ${session}
    RETURN    ${result}