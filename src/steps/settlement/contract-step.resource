*** Settings ***
Library     library/faker_utils.py    WITH NAME    FakerLibrary
Library     DateTime
Library     Collections
Resource    services/backend/auth-service.resource
Resource    apis/settlement/post-admin-settlements-contracts.resource
Resource    apis/settlement/post-admin-settlements-contracts-search.resource
Resource    apis/settlement/post-admin-settlements-contracts-reject.resource
Resource    apis/settlement/post-admin-settlements-contracts-suspend.resource
Resource    apis/settlement/post-admin-settlements-contracts-terminate.resource
Resource    apis/settlement/post-admin-settlements-contracts-activate.resource
Resource    apis/settlement/post-admin-settlements-contracts-sales_approved.resource
Resource    apis/settlement/post-admin-settlements-contracts-sales_reject.resource
Resource    apis/settlement/post-admin-settlements-contracts-finance_approved.resource
Resource    apis/settlement/post-admin-settlements-contracts-finance_reject.resource
Resource    services/db/mongo-db-service.resource


*** Keywords ***
Login To Dashboard as Business Admin
    Login To Dashboard    ${init_business_obj['user_name']}    ${init_business_obj['password']}

Generate future Date
    [Arguments]    ${days_from_now}
    ${current_time}    Get Time    epoch
    ${specific_date}    Evaluate    int(${current_time} * 1000 + (${days_from_now} * 24 * 60 * 60 * 1000))
    RETURN    ${specific_date}

Settlement Admin Create A Contract
    ${start_date}    Generate future Date    1
    ${end_date}    Generate future Date    365

    ${create_contract_response}    Post Admin Settlements Contracts
    ...    ${DASHBOARD_SIDE}
    ...    ${BUSINESS_ID}
    ...    ${start_date}
    ...    ${end_date}
    ...    ${CLAUSES}
    ...    ${BPG_GATEWAY_ID}
    ...    ${GUILD_CONTRACT}
    ...    ${CHANNEL_UPG_CONTRACT}
    ...    ${MERCHANT_PANEL_OWNER_GROUP}
    ...    ${CREATE_CONTRACT_USER_ID}

    Contract Response Should Be Equal    ${create_contract_response}    ${SUCCESSFUL_CREATE_CONTRACT_CONTENT}

Add The Business To The Contract Ownerships
    &{DATA}    Create Dictionary    ownerGroup=${MERCHANT_PANEL_OWNER_GROUP}    userId=${BUSINESS_ID}
    ${result}    Mongo Db Insert One    settlement_db    contract_ownerships    ${DATA}

Add The Business To The Contract Ownerships That Does Not Match To The Contract
    &{DATA}    Create Dictionary    ownerGroup=${SALES_OFFLINE_INTERNAL_OWNER_GROUP}    userId=${BUSINESS_ID}
    ${result}    Mongo Db Insert One    settlement_db    contract_ownerships    ${DATA}

Settlement Admin Create A Contract twice
    ${start_date}    Generate future Date    1
    ${end_date}    Generate future Date    365
    ${create_contract_response}    Post Admin Settlements Contracts
    ...    ${DASHBOARD_SIDE}
    ...    ${BUSINESS_ID}
    ...    ${start_date}
    ...    ${end_date}
    ...    ${CLAUSES}
    ...    ${BPG_GATEWAY_ID}
    ...    ${GUILD_CONTRACT}
    ...    ${CHANNEL_UPG_CONTRACT}
    ...    ${MERCHANT_PANEL_OWNER_GROUP}
    ...    ${CREATE_CONTRACT_USER_ID}

    ${create_contract_response}    Post Admin Settlements Contracts
    ...    ${DASHBOARD_SIDE}
    ...    ${BUSINESS_ID}
    ...    ${start_date}
    ...    ${end_date}
    ...    ${CLAUSES}
    ...    ${BPG_GATEWAY_ID}
    ...    ${GUILD_CONTRACT}
    ...    ${CHANNEL_UPG_CONTRACT}
    ...    ${MERCHANT_PANEL_OWNER_GROUP}
    ...    ${CREATE_CONTRACT_USER_ID}

    Contract Response Should Be Equal    ${create_contract_response}    ${DUPLICATE_CONTRACT_CONTENT}

Settlement Admin Try To Create A Contract With Invalid Period Params
    ${start_date}    Generate future Date    1
    ${end_date}    Generate future Date    365
    ${create_contract_response}    Post Admin Settlements Contracts
    ...    ${DASHBOARD_SIDE}
    ...    ${BUSINESS_ID}
    ...    ${start_date}
    ...    ${end_date}
    ...    ${CLAUSES_WITH_INVALID_PERIOD_PARAMS}
    ...    ${BPG_GATEWAY_ID}
    ...    ${GUILD_CONTRACT}
    ...    ${CHANNEL_UPG_CONTRACT}
    ...    ${MERCHANT_PANEL_OWNER_GROUP}
    ...    ${CREATE_CONTRACT_USER_ID}

    Contract Response Should Be Equal    ${create_contract_response}    ${INVALID_PERIOD_PARAMS_MATCH_CONTENT}

Settlement Admin Try To Create A Contract With Invalid Gateway (Does Not Match With Method)
    ${start_date}    Generate future Date    1
    ${end_date}    Generate future Date    365
    ${create_contract_response}    Post Admin Settlements Contracts
    ...    ${DASHBOARD_SIDE}
    ...    ${BUSINESS_ID}
    ...    ${start_date}
    ...    ${end_date}
    ...    ${CLAUSES}
    ...    ${ICP_GATEWAY_ID}
    ...    ${GUILD_CONTRACT}
    ...    ${CHANNEL_UPG_CONTRACT}
    ...    ${MERCHANT_PANEL_OWNER_GROUP}
    ...    ${CREATE_CONTRACT_USER_ID}

    Set Test Variable    ${create_contract_response}

Settlement Admin Try To Create A Contract With Invalid Channel
    ${start_date}    Generate future Date    1
    ${end_date}    Generate future Date    365
    ${create_contract_response}    Post Admin Settlements Contracts
    ...    ${DASHBOARD_SIDE}
    ...    ${BUSINESS_ID}
    ...    ${start_date}
    ...    ${end_date}
    ...    ${CLAUSES}
    ...    ${BPG_GATEWAY_ID}
    ...    ${GUILD_CONTRACT}
    ...    ${INVALID_CHANNEL_CONTRACT}
    ...    ${MERCHANT_PANEL_OWNER_GROUP}
    ...    ${CREATE_CONTRACT_USER_ID}

    Set Test Variable    ${create_contract_response}

The Contract Should Not be Created
    Contract Response Should Be Equal    ${create_contract_response}    ${INVALID_PARAMETERS_CONTENT}

Settlement Admin Try To Create A Contract
    ${start_date}    Generate future Date    1
    ${end_date}    Generate future Date    365
    ${create_contract_response}    Post Admin Settlements Contracts
    ...    ${DASHBOARD_SIDE}
    ...    ${BUSINESS_ID}
    ...    ${start_date}
    ...    ${end_date}
    ...    ${CLAUSES}
    ...    ${BPG_GATEWAY_ID}
    ...    ${GUILD_CONTRACT}
    ...    ${CHANNEL_UPG_CONTRACT}
    ...    ${MERCHANT_PANEL_OWNER_GROUP}
    ...    ${CREATE_CONTRACT_USER_ID}

    Contract Response Should Be Equal    ${create_contract_response}    ${SUCCESSFUL_CREATE_CONTRACT_CONTENT}

    ${restrictions}    Create List
    ${restriction_merchantId}    Create Dictionary
    ...    type=simple
    ...    field=merchantId
    ...    value=${BUSINESS_ID}
    ...    operation=eq
    ${restriction_gateway}    Create Dictionary
    ...    type=simple
    ...    field=gateway
    ...    value=${BPG_GATEWAY_ID}
    ...    operation=eq
    ${restriction_channel}    Create Dictionary
    ...    type=simple
    ...    field=channel
    ...    value=${CHANNEL_UPG_CONTRACT}
    ...    operation=eq
    ${restriction_status}    Create Dictionary    type=simple    field=status    value=${DRAFT_STATUS}    operation=eq

    Append To List    ${restrictions}    ${restriction_merchantId}
    Append To List    ${restrictions}    ${restriction_gateway}
    Append To List    ${restrictions}    ${restriction_channel}
    Append To List    ${restrictions}    ${restriction_status}

    ${ORDERS}    Create List
    ${result}    POST Admin Settlements Contracts Search    ${DASHBOARD_SIDE}    ${restrictions}    ${ORDERS}

    Set Test Variable    ${contract_id}    ${result['body']['contracts'][0]['contractId']}

Sales Try To Change Contract To Reject (Sales Reject)
    [Arguments]    ${Expected_value}

    ${CHANGE_STATUS_RESPONSE}    Post Admin Settlements Contracts Sales Reject
    ...    ${DASHBOARD_SIDE}
    ...    ${contract_id}
    ...    ${SALES_REJECT_DESCRIPTION}
    Set Test Variable    ${CHANGE_STATUS_RESPONSE}

Finance Try To Change Contract To Reject (Finance Reject)
    [Arguments]    ${Expected_value}
    ${CHANGE_STATUS_RESPONSE}    Post Admin Settlements Contracts Finance Reject
    ...    ${DASHBOARD_SIDE}
    ...    ${contract_id}
    ...    ${FINANCE_REJECT_DESCRIPTION}
    Set Test Variable    ${CHANGE_STATUS_RESPONSE}

Sales Try To Change Contract To Sales Approve (sales Approved)
    [Arguments]    ${Expected_value}

    ${CHANGE_STATUS_RESPONSE}    Post Admin Settlements Contracts Sales Approve
    ...    ${DASHBOARD_SIDE}
    ...    ${contract_id}
    ...    ${CREATE_CONTRACT_USER_ID}
    Set Test Variable    ${CHANGE_STATUS_RESPONSE}

Finance Try To Change Contract To Active (Finance Approved)
    [Arguments]    ${Expected_value}

    ${CHANGE_STATUS_RESPONSE}    Post Admin Settlements Contracts Finance Approve
    ...    ${DASHBOARD_SIDE}
    ...    ${contract_id}
    ...    ${CREATE_CONTRACT_USER_ID}
    Set Test Variable    ${CHANGE_STATUS_RESPONSE}

Settlement Admin Try To change The Contract To Active
    [Arguments]    ${Expected_value}

    ${CHANGE_STATUS_RESPONSE}    Post Admin Settlements Contracts Activate    ${DASHBOARD_SIDE}    ${contract_id}
    Set Test Variable    ${CHANGE_STATUS_RESPONSE}

Settlement Admin Try To Change The Contract To Suspend
    [Arguments]    ${Expected_value}

    ${CHANGE_STATUS_RESPONSE}    Post Admin Settlements Contracts Suspend    ${DASHBOARD_SIDE}    ${contract_id}
    Set Test Variable    ${CHANGE_STATUS_RESPONSE}

Settlement Admin Try To change The Contract To Terminate
    [Arguments]    ${Expected_value}

    ${CHANGE_STATUS_RESPONSE}    Post Admin Settlements Contracts Terminate    ${DASHBOARD_SIDE}    ${contract_id}
    Set Test Variable    ${CHANGE_STATUS_RESPONSE}

The Contract Status Should be Changed Successfuly
    Should Be Equal As Integers
    ...    ${CHANGE_STATUS_RESPONSE['status_code']}
    ...    200
    ...    msg="Expected status code for change contract should be 200, but got ${CHANGE_STATUS_RESPONSE['status_code']}"

    Should Be Equal As Strings
    ...    ${CHANGE_STATUS_RESPONSE['body']['result']['title']}
    ...    ${SUCCESS_CHANGE_STATUS_CONTRACT_RESPONSE}
    ...    msg="Expected result title to be ${SUCCESS_CHANGE_STATUS_CONTRACT_RESPONSE}, but got ${CHANGE_STATUS_RESPONSE['body']['result']['title']}

The Contract Status Should Not be Changed Successfuly
    Should Be Equal As Integers
    ...    ${CHANGE_STATUS_RESPONSE['status_code']}
    ...    422
    ...    msg="Expected status code for change contract should be 422, but got ${CHANGE_STATUS_RESPONSE['status_code']}

The Contract Should be Synced With Credit
    &{query_find}    Create Dictionary
    ...    businessId=${BUSINESS_ID}
    ...    channel=${UPG_CREDIT_CHANNEL}
    ...    paymentGateway=${BPG_CREDIT_GATEWAY}
    ${result}    Mongo Db Count Documents    credit_merchant_mng_db    gateways    ${query_find}
    Should Be Equal As Integers
    ...    ${result['body']['count']}
    ...    1
    ...    msg="contract with id ${contract_id} is not synced with credit."

The Contract Should Not Be Exsits With Credit
    &{query_find}    Create Dictionary
    ...    businessId=${BUSINESS_ID}
    ...    channel=${UPG_CREDIT_CHANNEL}
    ...    paymentGateway=${BPG_CREDIT_GATEWAY}
    ${result}    Mongo Db Count Documents    credit_merchant_mng_db    gateways    ${query_find}
    Should Be Equal As Integers
    ...    ${result['body']['count']}
    ...    0
    ...    msg="the contract with id ${contract_id} is synced with credit."

 Settlement Create and Sales Approved A Contract
    Settlement Admin Try To Create A Contract
    Sales Try To Change Contract To Sales Approve (sales Approved)    ${SUCCESSFUL_CHANGE_CONTRACT_STATUS}

Settlement Create and Finance Approved(activate)
    Settlement Create and Sales Approved A Contract
    Finance Try To Change Contract To Active (Finance Approved)    ${SUCCESSFUL_CHANGE_CONTRACT_STATUS}
    The Contract Should be Synced With Credit

Settlement Create and Suspend Contract
    Settlement Create and Finance Approved(activate)
    Settlement Admin Try To Change The Contract To Suspend    ${SUCCESSFUL_CHANGE_CONTRACT_STATUS}
    The Contract Should Not Be Exsits With Credit

Settlement Create and Terminate Contract
    Settlement Create and Finance Approved(activate)
    Settlement Admin Try To change The Contract To Terminate    ${SUCCESSFUL_CHANGE_CONTRACT_STATUS}
    The Contract Should Not Be Exsits With Credit

 Settlement Create and Reject A Contract
    Settlement Admin Try To Create A Contract
    Sales Try To Change Contract To Reject (Sales Reject)    ${SUCCESSFUL_CHANGE_CONTRACT_STATUS}
    The Contract Should Not Be Exsits With Credit

Contract Should be Founded
    [Documentation]    This function checks if exactly one contract is found.
    [Arguments]    ${status}
    ${restrictions}    Create List
    ${restriction_merchantId}    Create Dictionary
    ...    type=simple
    ...    field=merchantId
    ...    value=${BUSINESS_ID}
    ...    operation=eq
    ${restriction_gateway}    Create Dictionary
    ...    type=simple
    ...    field=gateway
    ...    value=${BPG_GATEWAY_ID}
    ...    operation=eq
    ${restriction_channel}    Create Dictionary
    ...    type=simple
    ...    field=channel
    ...    value=${CHANNEL_UPG_CONTRACT}
    ...    operation=eq
    ${restriction_status}    Create Dictionary    type=simple    field=status    value=${status}    operation=eq

    Append To List    ${restrictions}    ${restriction_merchantId}
    Append To List    ${restrictions}    ${restriction_gateway}
    Append To List    ${restrictions}    ${restriction_channel}
    Append To List    ${restrictions}    ${restriction_status}

    ${ORDERS}    Create List
    ${result}    POST Admin Settlements Contracts Search    ${DASHBOARD_SIDE}    ${restrictions}    ${ORDERS}
    ${total_elements}    Get From Dictionary    ${result.body}    totalElements
    Should Be Equal As Numbers    ${total_elements}    1

Contract Should Not be Founded
    [Documentation]    This function checks if no contracts are found.
    [Arguments]    ${status}
    ${restrictions}    Create List
    ${restriction_merchantId}    Create Dictionary
    ...    type=simple
    ...    field=merchantId
    ...    value=${BUSINESS_ID}
    ...    operation=eq
    ${restriction_gateway}    Create Dictionary
    ...    type=simple
    ...    field=gateway
    ...    value=${BPG_GATEWAY_ID}
    ...    operation=eq
    ${restriction_channel}    Create Dictionary
    ...    type=simple
    ...    field=channel
    ...    value=${CHANNEL_UPG_CONTRACT}
    ...    operation=eq
    ${restriction_status}    Create Dictionary    type=simple    field=status    value=${status}    operation=eq

    Append To List    ${restrictions}    ${restriction_merchantId}
    Append To List    ${restrictions}    ${restriction_gateway}
    Append To List    ${restrictions}    ${restriction_channel}
    Append To List    ${restrictions}    ${restriction_status}

    ${ORDERS}    Create List
    ${result}    POST Admin Settlements Contracts Search    ${DASHBOARD_SIDE}    ${restrictions}    ${ORDERS}
    ${total_elements}    Get From Dictionary    ${result.body}    totalElements
    Should Be Equal As Numbers    ${total_elements}    0

Contract Response Should Be Equal
    [Arguments]    ${contract_reponse}    ${expected_contract_response}
    Should Be Equal As Integers
    ...    ${contract_reponse['status_code']}
    ...    ${expected_contract_response['status_code']}
    ...    msg="Expected status code to be ${expected_contract_response['status_code']}, but got ${contract_reponse['status_code']}"

    Should Be Equal As Strings
    ...    ${contract_reponse['body']['result']['title']}
    ...    ${expected_contract_response['result']['title']}
    ...    msg="Expected result title to be '${expected_contract_response['result']['title']}', but got '${contract_reponse['body']['result']['title']}'"
