*** Settings ***
Library         Collections
Library         String
Resource        apis/switch-psp/post-terminal.resource
Resource        services/db/mongo-db-service.resource
Resource        apis/tgs/post-tickets-business.resource
Resource        apis/tgs/get-tickets.resource
Resource        apis/tgs/post-tickets-features-select.resource
Resource        apis/purchase-mng/post-purchases-verify.resource
Variables       data/payment/purchase/purchase-ipg.yaml
Variables       config/environment-stage.yaml


*** Keywords ***
Assign Mock PSP To A New Business
    [Arguments]    ${api_call_side}    ${new_business_id}
    ${assigning_result}    POST Terminals
    ...    ${IPG_GATEWAY}
    ...    ${PURCHASE_TRANSACTION_TYPE}
    ...    ${api_call_side}
    ...    ${MOCK_TERMINAL_ID}
    ...    ${MOCK_KYC_SUPPORTED}
    ...    ${MOCK_BANK_CODE}
    ...    ${MOCK_PIN_CODE}
    ...    ${MOCK_MERCHANT_ID}
    ...    ${new_business_id}
    ...    ${MOCK_PSP_CODE}
    ...    ${MOCK_ACTIVATION_STATUS}
    RETURN    ${assigning_result}


Delete Assigned Mock Terminal From DB As A Teae Down
    [Arguments]    ${terminal_uid}
    ${delete_terminal_query}    Create Dictionary    uid=${terminal_uid}
    ${delete_terminal}    Mongo Db Delete One
    ...    ${SWITCH_PSP_DB_NAME}
    ...    ${SWITCH_PSP_TERMINALS_COLLECTION}
    ...    ${delete_terminal_query}
    RETURN    ${delete_terminal}


