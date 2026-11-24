*** Settings ***
Library     JSONLibrary
Library     library/installment_date_utils.py
Resource    apis/mock-service/mock-api.resource
Resource    services/backend/LMS/installment/credit-installment.resource


*** Variables ***
${MELLAT_INSTALLMENTS_GET_API_PAYLOAD}      src/services/backend/LMS/installment/models/mellat_installments_get_api_payload.json


*** Keywords ***
Create Mellat Installments List
    [Documentation]    Create    installments list of mellat installments Get API
    ...    start_date fromat is like: 14030911
    [Arguments]
    ...    ${installment_count}
    ...    ${start_date}
    ...    ${installment_amount}=20000
    ...    ${capital_amount}=20000
    ...    ${interest_amount}=2000
    ...    ${penalty_amount}=0
    @{installment_dates}=    Generate Dates Mellat    ${start_date}    ${installment_count}
    ${installment_number}=    Convert To Integer    1
    ${payment_state}=    Convert To Integer    0
    ${due_state}=    Convert To Integer    1
    ${type}=    Convert To Integer    1

    ${capital_amount}=    Convert To Integer    ${capital_amount}
    ${interest_amount}=    Convert To Integer    ${interest_amount}
    ${penalty_amount}=    Convert To Integer    ${penalty_amount}
    ${installment_amount}=    Convert To Integer    ${installment_amount}

    @{installments}=    Create List
    FOR    ${installment_date}    IN    @{installment_dates}
        ${item}=    Create Dictionary
        ...    installmentNo=${installment_number}
        ...    paymentState=${payment_state}
        ...    dueState=${due_state}
        ...    type=${type}
        ...    dueDate=${installment_date}
        ...    capitalAmount=${capital_amount}
        ...    interestAmount=${interest_amount}
        ...    penaltyAmount=${penalty_amount}
        ...    installmentAmount=${installment_amount}
        ${installment_number}=    Evaluate    ${installment_number} + 1

        Append To List    ${installments}    ${item}
    END

    RETURN    @{installments}

Create Mellat Installments Get API
    [Arguments]    ${national_code_value}    ${external_contract_number_value}

    ${payload_dict}=    Load Json From File    ${MELLAT_INSTALLMENTS_GET_API_PAYLOAD}

    ${installment_count}=    Get From Dictionary    ${payload_dict}    installmentCount
    ${start_date}=    Get From Dictionary    ${payload_dict}    earlierInstallmentDate
    ${start_date_str}=    Convert To String    ${start_date}
    @{installments}=    Create Mellat Installments List    ${installment_count}    ${start_date_str}
    Set To Dictionary    ${payload_dict}    installment    ${installments}
    Set To Dictionary    ${payload_dict}    contractNumber    ${external_contract_number_value}

    # ${external_contract_number_value}=    Get From Dictionary    ${payload_dict}    contractNumber

    ${route}=    Replace String    ${MELLAT_INSTALLMENTS_GET_API_ROUTE}    national_code    ${national_code_value}
    ${route}=    Replace String    ${route}    external_contract_number    ${external_contract_number_value}

    ${response['id']}=    Post Credit API    ${route}    GET    200    0    &{payload_dict}
    RETURN    ${response['id']}

Update Mellat Installment
    [Documentation]    Update &{field_updates} of ${installment_number} of list installment in
    ...    Mellat Installment mock query based on ${id}
    [Arguments]    ${id}    ${installment_number}    &{field_updates}

    ${response}=    Get Route    ${id}

    ${payload}=    Get From Dictionary    ${response}    payload

    ${external_contract_number}=    Get From Dictionary    ${payload}    contractNumber
    ${route}=    Get From Dictionary    ${response}    route
    ${installments}=    Get From Dictionary    ${payload}    installment
    ${installment}=    Get From List    ${installments}    ${installment_number}

    FOR    ${key}    IN    @{field_updates.keys()}
        ${new_value}=    Get From Dictionary    ${field_updates}    ${key}
        IF    '${key}'=='dueDate'
            Set Variable    ${new_value}    ${new_value}    ${new_value}=    Convert To Integer    ${new_value}
        END

        Set To Dictionary    ${installment}    ${key}    ${new_value}
    END

    ${header_list}=    Create List
    &{body}=    Create Dictionary
    ...    id=${id}
    ...    route=${route}
    ...    httpMethod=GET
    ...    statusCode=200
    ...    delay=0
    ...    payload=&{payload}
    ...    headers=${header_list}

    ${result}=    Put Route    &{body}
    RETURN    ${result}
