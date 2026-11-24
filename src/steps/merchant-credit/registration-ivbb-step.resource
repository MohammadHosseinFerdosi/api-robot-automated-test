*** Settings ***
Library     Collections
Resource    services/backend/auth-service.resource
Resource    apis/merchant-credit/registration/post-register.resource
Resource    apis/merchant-credit/registration/post-assign-rule.resource
Resource    apis/merchant-credit/registration/put-max-amount.resource
Resource    apis/merchant-credit/admin/put-admin-merchants.resource
Resource    steps/merchant-credit/utilities/get-merchant-credit-db-data.resource
Resource    steps/merchant-credit/utilities/common-step.resource
# Variables    data/lms/activate-bnpl.yaml


*** Keywords ***
Call Register Api With Legal User Data
    # Login For Business    company-ipg-test    d1g1k@l@t3st
    ${BUSINESS_ID}    Login Per Business And Set Business Id    ${DG_USERNAME}
    Set Suite Variable    ${BUSINESS_ID}
    ${RESULTS}    POST Merchant Register    ${GENERAL_SIDE}
    ...    ${MERCHANT_TYPE_LEGAL}
    ...    20
    ...    TestLegalUser
    ...    ${NATIONAL_CODE_LEGAL}
    ...    ${CELL_NUMBER_LEGAL}
    ...    ${REGISTER_CELL_NUMBER_LEGAL}

    ${REGISTRATION_ID}    Set Variable    ${RESULTS.body.registrationId}
    ${Rticket}    Set Variable    ${RESULTS.body.ticket}
    # Set Suite Variable    ${REGISTRATION_ID}

Assign Ivb Rule
    [Documentation]    This keyword Choose iran venezuela bank as a fund provider
    POST Assign Rule    ${Rticket}    ${GENERAL_SIDE}    ${IRAN_VENEZULEA_LEGAL_RULE_ID}    ${REGISTRATION_ID}

The User Choose Max Credit Amount
    [Arguments]    ${credit_id}
    ${RESULTS}    Get Merchant Credit Data By Specific Field
    ...    merchants
    ...    creditId
    ...    nationalCode=${NATIONAL_CODE_LEGAL}
    Set Test Variable    ${CREDIT_ID}    ${RESULTS}

    ${RESULTS}    Get Merchant Credit Data By Specific Field
    ...    merchants
    ...    currentState
    ...    nationalCode=${NATIONAL_CODE_LEGAL}
    Should Be Equal    ${RESULTS}    MAX_CREDIT_AMOUNT_REVISE

    PUT Max Amount    ${Rticket}    ${GENERAL_SIDE}    4990000000    ${CREDIT_ID}

The User Approve by operation
    [Arguments]    ${credit_id}
    Login To Dashboard    ${DASHBOARD_USERNAME}    ${DASHBOARD_PASSWORD}
    PUT Admin Merchants    ${DASHBOARD_SIDE}    ${credit_id}    APPROVE
    PUT Admin Merchants    ${DASHBOARD_SIDE}    ${credit_id}    FUND_PROVIDER_ACTIVATION

    ${bank_account}    Create Dictionary
    ...    accountNumber=1234
    ...    customerNumber=1234
    ...    iban=IR370550190580005749240001
    ...    Type=305
    # Set To Dictionary    ${bank_account}    message=finalyApprove

    PUT Admin Merchants    ${DASHBOARD_SIDE}    APPROVE    ${bank_account}
    ${RESULTS}    Get Merchant Credit Data By Specific Field
    ...    merchants
    ...    currentState
    ...    nationalCode=${NATIONAL_CODE_LEGAL}
    Should Be Equal    ${RESULTS}    APPROVED
