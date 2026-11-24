*** Settings ***
Library         Collections
Library         String
Resource        apis/switch-psp/post-terminal.resource
Resource        services/db/mongo-db-service.resource
Resource        apis/tgs/post-tickets-business.resource
Resource        apis/tgs/get-tickets.resource
Resource        apis/tgs/post-tickets-features-select.resource
Resource        apis/purchase-mng/post-purchases-verify.resource
Resource        apis/purchase-mng/moke-pay/mock-ipg-result.resource
Resource        apis/purchase-mng/moke-pay/mock-ipg-result-psp.resource
Resource        services/backend/purchases.resource
Resource        services/backend/ipg-mock-assigning.resource
Variables       data/payment/purchase/purchase-ipg.yaml
Variables       data/payment/purchase/ipg_mock.yaml
Variables       config/environment-stage.yaml


*** Keywords ***
Get Successful Select Feature
    [Documentation]    This Keyword Is A Rapper To Call "Post Tickets Features Select" API
    [Arguments]
    ...    ${api_call_side}
    ...    ${ticket}
    ...    ${featureName}
    ...    ${Agent}
    ...    ${PLATFORM_VERSION}

    ${response}    Post Tickets Features Select
    ...    ${api_call_side}
    ...    ${ticket}
    ...    ${featureName}
    ...    ${Agent}
    ...    ${PLATFORM_VERSION}
    Should Be Equal As Integers    ${response['status_code']}    200
    RETURN    ${response}

Success Select IPG Payment Method
    [Arguments]    ${ticket}    ${agent}
    ${select_feature_response}    Wait Until Keyword Succeeds    1 minute    5 s    Get Successful Select Feature
    ...    ${GENERAL_SIDE}
    ...    ${ticket}
    ...    ${IPG_FEATURE_NAME}
    ...    ${agent}
    ...    ${PLATFORM_VERSION_2020}


Create a New Business with Purchase Settings, Ticket Configuration, Assign a Mock IPG Terminal, and Perform a Payment on the Mock PSP
    [Arguments]
    ...    ${prefix_cellnumber}
    ...    ${purchase_status}
    ...    ${amount}
    ...    ${agent}    
    # create new business
    @{role_list}    Create List    ${USER_ROLE}    ${LOGIN_STAFF_ROLE}
    ${spend_wallet_for_business}    Create Dictionary
    ...    definition=${B_WALLET_SPEND_DEFINITION}
    ...    wallet_charge_amount=0
    ...    currency=${CURRENCY_IRR}
    ${refund_wallet_for_business}    Create Dictionary
    ...    definition=${B_WALLET_REFUND_DEFINITION}
    ...    wallet_charge_amount=0
    ...    currency=${CURRENCY_IRR}
    @{wallet_list}    Create List
    ...    ${spend_wallet_for_business}
    ...    ${refund_wallet_for_business}
    ${new_business}    Get Initialized Business With Charged Wallet Based On Configuration
    ...    ${wallet_list}
    ...    ${role_list}
    ...    zone=app
    ${new_business_id}    Set Variable    ${new_business['business_id']}
    ${new_business_password}    Set Variable    ${new_business['password']}
    # create purchase setting and ticket config
    @{active_gateways}    Create List    ${IPG_GATEWAY}
    ${new_business_config}    Create Business Purchase And Ticket Setting For Purchase And Refund
    ...    ${new_business_id}
    ...    @{active_gateways}
#Assign IPG Mock To Created Business
    Login To Dashboard    ${DASHBOARD_USERNAME}    ${DASHBOARD_PASSWORD}
    Assign Mock PSP To A New Business    ${MICROSERVICE_SIDE}    ${new_business_id}    
# Create A New User
    ${provider_id}    Generate Random String    15    [LETTERS][NUMBERS]
    ${new_user}    Get A Fresh User
    ...    ${prefix_cellnumber}
    ${user_cellnumber}    Set Variable    ${new_user['user_cell_number']}
# Login For Business And Get Ticket
    Login For Business    ${new_business_id}    ${new_business_password}
    ${ticket_response}    POST Tickets Business    ${GENERAL_SIDE}
    ...    ${user_cellnumber}
    ...    ${amount}
    ...    ${TEST_CALLBACK_URL}
    ...    ${provider_id}
    ...    ${UPG_TICKET_TYPE}
    ...    ${WEB_AGENT}
    ...    ${PLATFORM_VERSION_2023}
    ${ticket}    Set Variable    ${ticket_response['body']['ticket']}
    ${ticket_info}    Get Tickets    ${GENERAL_SIDE}    ${ticket}    ${PLATFORM_VERSION_2023}
# Select IPG
    Success Select IPG Payment Method    ${ticket}    ${agent}
    ${purchase_query}    Create Dictionary             ticket=${ticket}
    ${purchase_data_response}    Mongo Db Find One
    ...    ${PURCHASE_MNG_DB_MANE}
    ...    ${PURCHASE_MNG_PURCHASE_COLLECTION}
    ...    ${purchase_query}
    ${purchase_tracking_code}    Set Variable   ${purchase_data_response['body']['trackingCode']}
    Set Test Variable    ${purchase_tracking_code}
    ${switch_psp_query}    Create Dictionary    trackingCode=${purchase_tracking_code}
    ${purchase_traceId}    Set Variable    ${purchase_data_response['body']['traceId']}
    ${switch_data_response}    Mongo Db Find One
    ...    ${SWITCH_PSP_DB_NAME}
    ...    ${SWITCH_PSP_IPG_DETAILS_CHOICE}
    ...    ${switch_psp_query}
    ${psp_token}    Set Variable    ${switch_data_response['body']['token']}
    ${route_mock_response}    POST IPG Result
    ...    ${MICROSERVICE_SIDE}
    ...    ${psp_token}
    ...    ${purchase_status}
    ${rrn}    Get From List    ${route_mock_response}    0
    ${sale_order_id}    Get From List    ${route_mock_response}    1
    ${psp_result}    POST IPG Result PSP
    ...    ${GENERAL_SIDE}
    ...    ${psp_token}
    ...    ${purchase_status}
    ...    ${purchase_traceId}
    ...    ${rrn}
    ...    ${sale_order_id}