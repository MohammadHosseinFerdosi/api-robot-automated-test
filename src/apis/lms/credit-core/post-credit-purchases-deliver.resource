*** Settings ***
Library     String
Library     Collections
Library     RequestsLibrary
Resource    services/backend/session-service.resource


*** Keywords ***
POST Credit Purchases Deliver
    [Documentation]    Delivers products with given details.
    ...    This keyword handles the delivery process of products by posting to the delivery API.
    [Arguments]
    ...    ${api_call_side}=${EMPTY}
    ...    ${delivery_date}=${EMPTY}
    ...    ${invoice_number}=${EMPTY}
    ...    ${tracking_code}=${EMPTY}
    ...    ${type}=${EMPTY}
    ...    ${products}=${EMPTY}
    ...    ${user_id}=${EMPTY}

    ${api_path}=    Set Variable    /purchases/deliver

    ${headers}=    Create Dictionary    User-Id=${user_id}

    IF    '${api_call_side}' == '${MICROSERVICE_SIDE}'
        ${api_path}=    Set Variable    ${MS_CREDIT_MNG_PATH}${api_path}
    END

    ${body}=    Create Dictionary
    ...    deliveryDate=${delivery_date}
    ...    invoiceNumber=${invoice_number}
    ...    trackingCode=${tracking_code}
    ...    products=${products}
    ${params}=    Create Dictionary    type=${type}
    ${session}=    Create A Session    ${api_call_side}

    ${response}=    POST On Session
    ...    ${session}
    ...    ${api_path}
    ...    params=${params}
    ...    json=${body}
    ...    headers=${headers}
    ...    expected_status=any

    IF    '${response.status_code}'=='400'
        ${result}=    Create Dictionary    status_code=400    body=[]
    ELSE
        ${result}=    Create Dictionary    status_code=${response.status_code}    body=${response.json()}
    END

    RETURN    ${result}

    [Teardown]    Delete A Session    ${session}
