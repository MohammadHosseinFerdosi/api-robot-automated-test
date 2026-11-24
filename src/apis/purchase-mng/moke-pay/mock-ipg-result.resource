*** Settings ***
Library         Collections
Library         String
Library         XML
Library         RequestsLibrary
Variables       data/CONSTANTS.yaml
Variables       config/environment-stage.yaml
Resource        services/backend/session-service.resource


*** Keywords ***
POST IPG Result
    [Documentation]    Sends a POST request to simulate IPG result callback to Platform mock server.
    [Arguments]
    ...    ${api_call_side}
    ...    ${token}
    ...    ${status}

    ${api_path}    Set Variable    /ipg/result

    IF    '${api_call_side}' == '${MICROSERVICE_SIDE}'
        ${api_path}    Set Variable    ${MS_MOCK_PATH}${api_path}
    END

    ${headers}    Create Dictionary
    ...    Content-Type=application/x-www-form-urlencoded

    ${data}    Create Dictionary
    ...    token=${token}
    ...    status=${status}

    ${session}    Create A Session    ${api_call_side}
    ${response}    POST On Session    ${session}
    ...    ${api_path}
    ...    headers=${headers}
    ...    data=${data}
    ...    expected_status=any
    ${response.xml}    Set Variable    ${response.text}
    ${rrn}    Evaluate    re.search(r'name="rrn" value="(.*?)"', '''${response.xml}''').group(1)    re
    ${sale_order_id}    Evaluate
    ...    re.search(r'name="SaleOrderId" value="(.*?)"', '''${response.xml}''').group(1)
    ...    re
    Set Test Variable    ${rrn}
    Set Test Variable    ${sale_order_id}
    RETURN    ${rrn}    ${sale_order_id}
    [Teardown]    Delete A Session    ${session}
    