*** Settings ***
Library    RequestsLibrary
Variables    data/los/credit.yaml

*** Keywords ***
POST Credit Cheques Confirm
    [Arguments]    ${api_call_side}    ${api_path}    ${header}    ${body}
    ${session_alias}=    Set Variable    confirm_session
    Create Session    ${session_alias}    ${api_call_side}    verify=False
    ${response}    POST On Session
    ...    ${session_alias}
    ...    ${api_path}
    ...    headers=${header}
    ...    json=${body}
    ...    expected_status=any
    &{result}=    Create Dictionary
    ...    status_code=${response.status_code}
    ...    body=${response.json()}
    [Teardown]    Delete All Sessions
    RETURN    ${result}
