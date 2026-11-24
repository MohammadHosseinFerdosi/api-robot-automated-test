*** Settings ***
Library     String
Resource    steps/merchant-credit/utilities/get-merchant-credit-db-data.resource
Resource    steps/merchant-credit/utilities/settlement-utilities.resource
Resource    services/backend/value-handler.resource


*** Keywords ***
Initiate Settlement Request As Iran Venezuela User
    [Arguments]
    ...    ${amount}
    ${result}    Create Settlement    ${REGISTRATION_ID}    7    ${amount}
    Should Be Equal As Integers    ${result['status_code']}    200

In the border intervals of the minimum fee
    [Arguments]
    ...    ${amount}
    ${QUERY_RESULTS}    Get Merchant Credit Data By Specific Field
    ...    settlements
    ...    invoiceAmount
    ...    merchant.nationalCode=${NATIONAL_CODE_LEGAL}
    ...    businessId=${BUSINESS_ID}
    ${QUERY_RESULTS}    Value Handler    ${QUERY_RESULTS}
    ${amount}    Convert To Integer    ${amount}
    Should Be Equal    ${QUERY_RESULTS}    ${amount}

Submit Settlement Request With INIT Status
    ${QUERY_RESULTS}    Get Merchant Credit Data By Specific Field
    ...    settlements
    ...    status
    ...    merchant.nationalCode=${NATIONAL_CODE_LEGAL}
    ...    businessId=${BUSINESS_ID}
    Should Be Equal As Integers    ${QUERY_RESULTS}    0
