*** Settings ***
Library     JSONLibrary
Library     library/installment_date_utils.py
Resource    apis/mock-service/mock-api.resource
Resource    services/backend/LMS/installment/credit-installment.resource


*** Variables ***
${SADERAT_PAY_POST_API_PAYLOAD}         src/services/backend/LMS/installment/models/saderat_pay_post_api_payload.json
${SADERAT_INQUIRY_GET_API_PAYLOAD}      src/services/backend/LMS/installment/models/saderat_inquiry_get_api_payload.json
${SADERAT_INFO_GET_API_PAYLOAD}         src/services/backend/LMS/installment/models/saderat_info_get_api_payload.json


*** Keywords ***
Create Saderat Pay Post API
    ${payload_dict}=    Load Json From File    ${SADERAT_PAY_POST_API_PAYLOAD}
    ${response['id']}=    Post Credit API    ${SADERAT_PAY_POST_API_ROUTE}    POST    200    0    &{payload_dict}
    RETURN    ${response['id']}

Create Saderat Inquiry GET API
    ${payload_dict}=    Load Json From File    ${SADERAT_INQUIRY_GET_API_PAYLOAD}
    ${response['id']}=    Post Credit API    ${SADERAT_INQUIRY_GET_API_ROUTE}    GET    200    0    &{payload_dict}
    RETURN    ${response['id']}

Create Saderat Info GET API
    ${payload_dict}=    Load Json From File    ${SADERAT_INFO_GET_API_PAYLOAD}
    ${response['id']}=    Post Credit API    ${SADERAT_INFO_GET_API_ROUTE}    GET    200    0    &{payload_dict}
    RETURN    ${response['id']}

Update Saderat API
    [Documentation]    Saderat have just one installment
    [Arguments]    ${id}    &{field_updates}

    ${response}=    Get Route    ${id}

    ${payload}=    Get From Dictionary    ${response}    payload
    ${route}=    Get From Dictionary    ${response}    route

    ${int_fields}=    Create List
    ...    totalInstallmentAmount
    ...    currentInstallmentAmount
    ...    totalInstallmentsNo
    ...    currentInstalledNo
    ...    currentInstalledAmount
    ...    installmentAmount
    ...    currentInstalledPenalty
    ...    payableAmount
    ...    chargeCode

    FOR    ${key}    IN    @{field_updates.keys()}
        ${new_value}=    Get From Dictionary    ${field_updates}    ${key}
        IF    '${key}' in @{int_fields}
            Set Variable    ${new_value}    ${new_value}    ${new_value}=    Convert To Integer    ${new_value}
        END

        Set To Dictionary    ${payload}    ${key}    ${new_value}
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
