*** Settings ***
Resource        services/backend/session-service.resource



*** Keywords ***
POST Kyc Cell Number Inquiry
    [Documentation]    Call shahkar API with create a session with '${api_call_side}' and POST '${national_code}'
    ...    and '${cell_number}' as '${body}'. Then returned result as dictaniory.
    ...    '${REQUESTER_APP_NAME}' must be set because we use 'MICROSERVISE' as '${api_call_side}'
    [Arguments]
    ...    ${api_call_side}
    ...    ${requester_app_name}
    ...    ${national_code}
    ...    ${cell_number}

    &{body}    Create Dictionary    cellNumber    ${cell_number}    nationalCode    ${national_code}
    
    ${api_path}    Set Variable    ${MS_KYC_PATH}/kyc/cell-number/inquiry

    &{header}    Create Dictionary
    ...    Requester-App-Name=${requester_app_name}

    ${session}    Create A Session    ${api_call_side}
    ${response}    POST On Session
    ...    ${session}
    ...    ${api_path}
    ...    headers=&{header}
    ...    json=&{body}
    ...    expected_status=any

    &{result}    Create Dictionary    status_code=${response.status_code}    body=${response.json()}

    RETURN    &{result}

    [Teardown]    Delete A Session    ${session}
