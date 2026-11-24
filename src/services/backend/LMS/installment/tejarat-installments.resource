*** Settings ***
Library     library/installment_date_utils.py
Resource    apis/mock-service/mock-api.resource
Resource    services/backend/LMS/installment/credit-installment.resource


*** Variables ***
${TEJARAT_INSTALLMENTS_GET_API_PAYLOAD}     src/services/backend/LMS/installment/models/tejarat_installments_get_api_payload.json
${TEJARAT_PAYMENTS_GET_API_PAYLOAD}         src/services/backend/LMS/installment/models/tejarat_payments_get_api_payload.json
${TEJARAT_PAYMENTS_POST_API_PAYLOAD}        src/services/backend/LMS/installment/models/tejarat_payments_post_api_payload.json


*** Keywords ***
Create Tejarat Payments Post API
    [Documentation]    Create    tejarat payments post api    based on `${external_contract_number}`
    ...    This service uses mock-api service to insert route in mock
    ...    Response Sample
    ...    {'status_code': 201, 'id': ${id}}
    [Arguments]    ${external_contract_number}

    ${payload_dict}=    Load Json From File    ${TEJARAT_PAYMENTS_POST_API_PAYLOAD}
    ${route}=    Replace String
    ...    ${TEJARAT_PAYMENTS_POST_API_ROUTE}
    ...    external_contract_number
    ...    ${external_contract_number}
    ${response}=    Post Credit API    ${route}    POST    200    0    &{payload_dict}
    RETURN    ${response}

Create Tejarat Payments Get API
    [Documentation]    Create    tejarat payments get api    based on `${external_contract_number}`
    ...    This service uses mock-api service to insert route in mock
    ...    Response Sample
    ...    {'status_code': 201, 'id': ${id}}
    [Arguments]    ${external_contract_number}

    ${payload_dict}=    Load Json From File    ${TEJARAT_PAYMENTS_GET_API_PAYLOAD}
    ${route}=    Replace String
    ...    ${TEJARAT_PAYMENTS_GET_API_ROUTE}
    ...    external_contract_number
    ...    ${external_contract_number}
    ${response}=    Post Credit API    ${route}    GET    200    0    &{payload_dict}
    RETURN    ${response}

Create Tejarat Installments List
    [Documentation]    Create    installments list of tejarat installments Get API
    [Arguments]    ${installment_count}    ${start_date}    ${installment_amount}=20000
    @{installments}=    Create List
    @{installment_dates}=    Generate Dates Tejarat    ${start_date}    ${installment_count}
    ${installmentNumber}=    Set Variable    1
    ${paidAmount}=    Convert To Integer    0
    ${penaltyAmount}=    Convert To Integer    0
    ${vatAmount}=    Convert To Integer    0

    ${installmentAmount}=    Convert To Integer    ${installment_amount}

    FOR    ${installment_date}    IN    @{installment_dates}
        ${item}=    Create Dictionary
        ...    installmentNumber=${installmentNumber}
        ...    installmentAmount=${installmentAmount}
        ...    matureDate=${installment_date}
        ...    matureStatus=MATURED
        ...    stageStatus=CURRENT
        ...    payableAmount=${installmentAmount}
        ...    paidAmount=${paidAmount}
        ...    penaltyAmount=${penaltyAmount}
        ...    status=NORMAL
        ...    vatAmount=${vatAmount}

        ${installmentNumber}=    Evaluate    ${installmentNumber} + 1

        Append To List    ${installments}    ${item}
    END

    RETURN    @{installments}

Create Tejarat Installments Get API
    [Documentation]
    ...    settleAmount= totalAmount - discountAmount
    ...    start_date format must be like : 2025-02-08T00:00:00
    [Arguments]    ${external_contract_number}    ${start_date}    ${installment_count}=6

    ${payload_dict}=    Load Json From File    ${TEJARAT_INSTALLMENTS_GET_API_PAYLOAD}
    ${result}=    Get From Dictionary    ${payload_dict}    result
    ${facility}=    Get From Dictionary    ${result}    facility

    Set To Dictionary    ${facility}    facilityId    ${external_contract_number}

    @{installments}=    Create Tejarat Installments List    ${installment_count}    ${start_date}
    Set To Dictionary    ${result}    installments    ${installments}
    ${route}=    Replace String
    ...    ${TEJARAT_INSTALLMENTS_GET_API_ROUTE}
    ...    external_contract_number
    ...    ${external_contract_number}

    ${response}=    Post Credit API    ${route}    GET    200    0    &{payload_dict}
    RETURN    ${response}

Update Tejarat Installment
    [Documentation]    Update &{field_updates} of ${installment_number} of list installments in    Tejarat Installment mock query based on ${id}
    [Arguments]    ${id}    ${installment_number}    &{field_updates}

    ${response}=    Get Route    ${id}

    ${payload}=    Get From Dictionary    ${response}    payload
    ${result}=    Get From Dictionary    ${payload}    result

    ${installments}=    Get From Dictionary    ${result}    installments
    ${installment}=    Get From List    ${installments}    ${installment_number}

    ${facility}=    Get From Dictionary    ${result}    facility
    ${external_contract_number}=    Get From Dictionary    ${facility}    facilityId

    ${installment_int_fields}=    Create List
    ...    installmentAmount
    ...    payableAmount
    ...    paidAmount
    ...    penaltyAmount
    ...    vatAmount

    FOR    ${key}    IN    @{field_updates.keys()}
        ${new_value}=    Get From Dictionary    ${field_updates}    ${key}
        IF    '${key}' in @{installment_int_fields}
            Set Variable    ${new_value}    ${new_value}    ${new_value}=    Convert To Integer    ${new_value}
        END

        Set To Dictionary    ${installment}    ${key}    ${new_value}
    END

    ${header_list}=    Create List
    ${route}=    Set Variable    /v3/facilities/${external_contract_number}/installments
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
