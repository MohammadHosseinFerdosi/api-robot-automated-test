*** Settings ***
Library    RequestsLibrary
Library    OperatingSystem
Variables    data/los/credit.yaml

*** Keywords ***
POST Credit Documents Upload
    [Arguments]    ${api_call_side}    ${api_path}    ${header}    ${files_dict}
    ${session_alias}=    Set Variable    upload_session
    Create Session    ${session_alias}    ${api_call_side}    verify=False
    ${response}    POST On Session
    ...    ${session_alias}
    ...    ${api_path}
    ...    headers=${header}
    ...    files=${files_dict}
    ...    expected_status=any
    &{result}=    Create Dictionary    status_code=${response.status_code}    body=${response.json()}
    [Teardown]    Delete All Sessions
    RETURN    ${result}
