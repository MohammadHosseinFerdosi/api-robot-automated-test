*** Settings ***
Library     String
Resource    steps/merchant-credit/utilities/get-merchant-credit-db-data.resource
Resource    steps/merchant-credit/utilities/settlement-utilities.resource


*** Keywords ***
The DueDate Of Invoice Lesser Than Tottal Delay Day and Minimum Day Of Iran-Ven Provider
    ${min_due_date}    Get Merchant Credit Data By Specific Field    fees    minDueDate    providerId=iran-venezuela
    ${delay}    Get Merchant Credit Data By Specific Field    fees    delay    providerId=iran-venezuela
    ${calculate_due_date}    Evaluate    ${delay} + ${min_due_date}
    ${calculate_due_date}    Evaluate    ${calculate_due_date} - 3
    Set Test Variable    ${calculate_due_date}

The user Sumbit Ealy settlement Request
    ${result_kosar_file}    Create Settlement    ${REGISTRATION_ID}    ${calculate_due_date}    10000000

    Set Test Variable    ${result_kosar_file}    ${result_kosar_file}[response][result]

Submit Settlement Request With INIT Status
    ${QUERY_RESULTS}    Get Merchant Credit Data By Specific Field
    ...    settlements
    ...    status
    ...    merchant.nationalCode=${NATIONAL_CODE_LEGAL}

    Should Be Equal As Integers    ${QUERY_RESULTS}    0
