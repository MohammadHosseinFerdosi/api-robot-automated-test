*** Settings ***
Library     RequestsLibrary
Resource    services/backend/session-service.resource


*** Keywords ***
POST Admin Transactions Statement Business Id Wallet Name
    [Documentation]    Give you a transaction report for A wallet of A business based on event time.
    ...    by default search time sets to 10 min ago from current time.
    [Arguments]
    ...    ${api_call_side}
    ...    ${business_id}
    ...    ${wallet_name}
    ...    ${created_from}=${EMPTY}
    ...    ${created_to}=${EMPTY}
    ...    ${completed_from}=${EMPTY}
    ...    ${completed_to}=${EMPTY}
    ...    ${page}=0
    ...    ${size}=30

    ${api_path}    Set Variable    /admin/transactions/statement/${business_id}/${wallet_name}
    ${param}    Create Dictionary    page=${page}    size=${size}

    ${header}    Create Dictionary

    IF    '${api_call_side}' == '${MICROSERVICE_SIDE}'
        ${api_path}    Set Variable    ${MS_WALLET_PROVIDER_PATH}${api_path}
    END

    ${current_time}    Get Time    epoch
    ${current_time}    Evaluate    ${current_time} * 1000
    IF    '${created_from}' == '${EMPTY}'
        ${created_from}    Evaluate    ${current_time} - 600000
    END
    IF    '${created_to}' == '${EMPTY}'
        ${created_to}    Set Variable    ${current_time}
    END

    ${body}    Create Dictionary
    ...    createdFrom=${created_from}
    ...    createdTo=${created_to}
    ...    completedFrom=${completed_from}
    ...    completedTo=${completed_to}

    ${session}    Create A Session    ${api_call_side}
    ${response}    POST On Session
    ...    ${session}
    ...    ${api_path}
    ...    headers=${header}
    ...    params=${param}
    ...    json=${body}
    ...    expected_status=any
    ${result}    Create Dictionary    status_code=${response.status_code}    body=${response.json()}
    RETURN    ${result}

    [Teardown]    Delete A Session    ${session}
