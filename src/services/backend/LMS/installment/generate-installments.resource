*** Settings ***
Resource    apis/mock-service/mock-api.resource
Resource    services/db/mysql-db-service.resource
Resource    services/backend/LMS/installment/saderat-installments.resource
Resource    services/backend/LMS/installment/mellat-installments.resource
Resource    services/backend/LMS/installment/tejarat-installments.resource


*** Variables ***
${OPTION_MELLAT}        11
${OPTION_TEJARAT}       13
${OPTION_SADERAT}       17


*** Keywords ***
Handle Option Mellat
    [Arguments]    ${external_contract_number}

    ${select_query}=    Set Variable
    ...    SELECT installment_db.user_details.national_code From installment_db.accounts INNER JOIN installment_db.user_details ON installment_db.accounts.cell_number= installment_db.user_details.cell_number where installment_db.accounts.external_contract_number='${external_contract_number}' limit 1;
    ${result}=    MySQL Fetch All    db_name=installment_db    query=${select_query}
    Should Be Equal    '${result['status_code']}'    '0'
    ${national_code_dict}=    Get From List    ${result['body']}    0
    Create Mellat Installments Get API    ${national_code_dict['national_code']}    ${external_contract_number}

Handle Option Saderat
    [Arguments]    ${external_contract_number}

    ${response}=    Create Saderat Pay Post API
    ${response}=    Create Saderat Inquiry GET API
    ${response}=    Create Saderat Info GET API

Handle Option Tejarat
    [Arguments]    ${external_contract_number}

    ${startDate}=    Set Variable    2025-02-08T00:00:00
    Create Tejarat Payments Post API    ${external_contract_number}
    Create Tejarat Payments Get API    ${external_contract_number}
    Create Tejarat Installments Get API    ${external_contract_number}    ${startDate}

Generate Installments
    [Documentation]    Create    installments list of mellat installments Get API
    [Arguments]    ${credit_id}

    ${select_query}=    Set Variable
    ...    SELECT fund_provider_id, external_contract_number FROM installment_db.accounts WHERE credit_id=${credit_id}
    ${result}=    MySQL Fetch All    db_name=installment_db    query=${select_query}

    ${body}=    Set Variable    ${result['body']}

    Should Be Equal As Strings    ${result['status_code']}    0
    Should Not Be Empty    ${result['body']}
    # check if body is empty
    ${first_item}=    Get From List    ${body}    0

    ${fund_provider_id}=    Get From Dictionary    ${first_item}    fund_provider_id
    ${external_contract_number}=    Get From Dictionary    ${first_item}    external_contract_number

    IF    '${fund_provider_id}' == '${OPTION_MELLAT}'
        Handle Option Mellat    ${external_contract_number}
    ELSE IF    '${fund_provider_id}' == '${OPTION_TEJARAT}'
        Handle Option Tejarat    ${external_contract_number}
    ELSE IF    '${fund_provider_id}' == '${OPTION_SADERAT}'
        Handle Option Saderat    ${external_contract_number}
    ELSE
        Fail    Invalid fund provider ID: ${fund_provider_id}
    END

    ${result}=    Create Dictionary    status=1
    RETURN    ${result}
