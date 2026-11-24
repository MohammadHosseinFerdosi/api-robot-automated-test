*** Settings ***
Resource    apis/merchant-credit/settlement/get-settlement-detail.resource
Resource    services/backend/auth-service.resource
Resource    steps/merchant-credit/utilities/get-merchant-credit-db-data.resource
Resource    services/backend/convert-to-persian-digit.resource
Resource    services/backend/value-handler.resource


*** Keywords ***
Show Invoice Detail
    [Documentation]    This Keyword Call Config Api And Set Response to ${config_result} Variable
    ${details_response}=    GET Settlements Detail
    ...    ${WEB_SIDE}
    ...    ${TRACKING_CODE_SETTLEMENT}

    ${DETAIL_SETTLEMENT}=    Set Variable    ${details_response.body}
    Set Suite Variable    ${DETAIL_SETTLEMENT}

Invoice Detail Displayed Should Be Equal To User's Settlement Detail
    [Documentation]    This Keyword Shoul Be User's Settlemnent Data Equal With Detail Service Response
    ${settlement_document_detabase}=    Get Merchant Credit Data By Specific Field
    ...    settlements
    ...    ${EMPTY}
    ...    trackingCode=${TRACKING_CODE_SETTLEMENT}

    Should Be Equal    ${settlement_document_detabase}[providerId]    ${DETAIL_SETTLEMENT}[settlement][providerId]
    Should Be Equal
    ...    ${settlement_document_detabase}[merchant][name]
    ...    ${DETAIL_SETTLEMENT}[settlement][merchantName]

    ${settlement_document_detabase_invoice_amount}=    Value Handler    ${settlement_document_detabase}[invoiceAmount]

    ${invoiceAmount_database}=    Convert To Integer    ${settlement_document_detabase_invoice_amount}
    Should Be Equal    ${invoiceAmount_database}    ${DETAIL_SETTLEMENT}[settlement][invoiceAmount]

    ${settlement_database_dueDate}    Value Handler    ${settlement_document_detabase['dueDate']}
    ${dueDate_database}=    Convert To Integer    ${settlement_database_dueDate}
    Should Be Equal    ${dueDate_database}    ${DETAIL_SETTLEMENT}[settlement][dueDate]

    ${separatored_number}=    Add Separator To Amount    ${invoiceAmount_database}
    ${invoice_amount_persian}=    Convert English Digit To Persian Digit    ${separatored_number}
    ${invoice_amount_persian}=    Catenate    SEPARATOR=    ${invoice_amount_persian}    ${SPACE}    ریال
    Should Be Equal    ${invoice_amount_persian}    ${DETAIL_SETTLEMENT}[details][2][مبلغ فاکتور][value]
