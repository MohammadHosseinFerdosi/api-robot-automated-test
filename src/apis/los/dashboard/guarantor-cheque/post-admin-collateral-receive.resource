*** Settings ***
Resource    services/backend/session-service.resource
*** Keywords ***
POST Admin Collateral Receive
    [Arguments]
    ...    ${api_call_side}
    ...    ${user_id}
    ...    ${collateral_id}
    ...    ${docs}
    ...    ${collateral_type}=0
    ...    ${barcode}=1234
    ...    ${bank_code}=064
    ...    ${force_update}=false
    ${headers}    Create Dictionary    User-id=${user_id}    Content-Type=application/json
    ${api_path}    Set Variable    /admin/collateral/receive
    IF    '${api_call_side}' == '${MICROSERVICE_SIDE}'
        ${api_path}    Set Variable    ${MS_CREDIT_ONBOARDING_PATH}${api_path}
    END
    ${body}    Create Dictionary
    ...    collateralId=${collateral_id}
    ...    docs=${docs}
    ...    collateralType=${collateral_type}
    ...    barcode=${barcode}
    ...    bankCode=${bank_code}
    ...    forceUpdate=${force_update}
    ${session}    Create A Session    ${api_call_side}
    ${response}    POST On Session
    ...    ${session}
    ...    ${api_path}
    ...    json=${body}
    ...    headers=${headers}
    ...    expected_status=any
    ${status_code}    Create Dictionary
    ...    status_code=${response.status_code}
    RETURN    ${status_code}
    [Teardown]    Delete A Session    ${session}