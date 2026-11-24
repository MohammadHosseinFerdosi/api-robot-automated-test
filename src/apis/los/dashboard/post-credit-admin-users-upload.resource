*** Settings ***
Library      RequestsLibrary
Library      OperatingSystem
Variables    data/los/credit.yaml
Resource     services/backend/session-service.resource
Variables    config/environment-stage.yaml

*** Keywords ***
POST Credit Admin Users Upload
    [Arguments]
    ...    ${microservice_side}
    ...    ${api_path}
    ...    ${header}
    ...    ${files}

    ${session_name}=    Create A Session    ${microservice_side}

    ${response}=    POST On Session
    ...    ${session_name}
    ...    ${api_path}
    ...    headers=${header}
    ...    files=${files}
    ...    expected_status=any

    &{result}=    Create Dictionary
    ...    status_code=${response.status_code}
    ...    body=${None}

    TRY
        ${json_body}=    Evaluate    json.loads('''${response.text}''')    modules=json
        Set To Dictionary    ${result}    body=${json_body}
    EXCEPT
        Set To Dictionary    ${result}    body=${response.text}
    END

    [Teardown]    Delete A Session    ${session_name}
    RETURN    ${result}