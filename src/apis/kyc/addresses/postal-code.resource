*** Settings ***
Resource    services/backend/session-service.resource


*** Keywords ***
GET Addresses Postal Code
    [Arguments]
    ...    ${api_call_side}
    ...    ${requester_app_name}
    ...    ${user_id}
    ...    ${postal_code}

    ${api_path}    Set Variable    ${MS_KYC_PATH}/addresses/postal-code/${postal_code}

    &{header}    Create Dictionary
    ...    Requester-App-Name=${requester_app_name}
    ...    User-Id=${user_id}

    ${session}    Create A Session    ${api_call_side}
    ${response}    GET On Session
    ...    ${session}
    ...    ${api_path}
    ...    headers=&{header}
    ...    expected_status=any

    &{result}    Create Dictionary    status_code=${response.status_code}    body=${response.json()}

    RETURN    &{result}

    [Teardown]    Delete A Session    ${session}
