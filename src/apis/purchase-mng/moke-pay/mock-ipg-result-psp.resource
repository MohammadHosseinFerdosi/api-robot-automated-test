*** Settings ***
Library         Collections
Library         String
Library         XML
Library         RequestsLibrary
Variables       data/CONSTANTS.yaml
Variables       config/environment-stage.yaml
Variables       data/payment/purchase/purchase-ipg.yaml
Resource        services/backend/session-service.resource


*** Keywords ***
POST IPG Result PSP
    [Documentation]    Sends a POST request to simulate IPG result callback to Platform mock server.
    [Arguments]
    ...    ${api_call_side}
    ...    ${token}
    ...    ${status}
    ...    ${traceId}
    ...    ${rrn}    
    ...    ${sale_order_id}


    ${api_path}    Set Variable    /purchases/ipg/result?pspCode=${MOCk_PSP_CODE}&traceId=${traceId}

    ${headers}    Create Dictionary
    ...    Content-Type=application/x-www-form-urlencoded

    ${data}    Create Dictionary
    ...    token=${token}
    ...    status=${status}
    ...    rrn=${rrn}
    ...    SaleOrderId=${sale_order_id}

    ${session}    Create A Session    ${api_call_side}
    ${response}    POST On Session    ${session}
    ...    ${api_path}
    ...    headers=${headers}
    ...    data=${data}
    ...    expected_status=any
    ${response.xml}    Set Variable    ${response.text}
    RETURN    ${response.xml}
    [Teardown]    Delete A Session    ${session}
