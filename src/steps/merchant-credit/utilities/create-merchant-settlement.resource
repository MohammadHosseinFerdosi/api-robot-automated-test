*** Settings ***
Resource    steps/merchant-credit/utilities/merchant-utilities.resource
Resource    steps/merchant-credit/utilities/settlement-utilities.resource
Resource    steps/merchant-credit/utilities/get-merchant-credit-db-data.resource


*** Keywords ***
Create Merchant And Settlement
    [Documentation]    This Keywords Create A Merchant And Create An Early Settlement Request Using Registration Id
    [Arguments]    ${api_call_side}
    ...    ${type}
    ...    ${settlement_bucket}
    ...    ${name}
    ...    ${national_code}
    ...    ${cell_number}
    ...    ${register_cell_number}
    ...    ${rule_id}
    ...    ${max_amount}
    ...    ${invoice_amount}

    Create Merchant    ${api_call_side}
    ...    ${type}
    ...    ${settlement_bucket}
    ...    ${name}
    ...    ${national_code}
    ...    ${cell_number}
    ...    ${register_cell_number}
    ...    ${rule_id}
    ...    ${max_amount}

    ${Result_registrationId}    Get Merchant Credit Data By Specific Field
    ...    merchants
    ...    registrationId
    ...    nationalCode=${national_code}

    Create Settlement    ${Result_registrationId}
    ...    ${settlement_bucket}
    ...    ${invoice_amount}
