*** Settings ***
Documentation    API Keyword for Creating a Credit Rule
Resource    services/backend/session-service.resource
Variables   data/los/credit.yaml
Variables   config/environment-stage.yaml

*** Keywords ***
POST Credit Admin Rules Create
    [Arguments]    ${user_id}    ${profile_id}    ${fund_provider_code}    ${customer_type}    ${user_type}    ${close_type}    ${activation_offset}    ${register_offset}    ${step_items_template_id}    ${installment_payable}    ${supported_collateral_types}    ${cheque_relative_support}    ${is_need_to_dp_score}    ${min_balance}    ${max_balance}    ${allocation_payment_method_type}    ${step_type}
    [Documentation]    Sends POST request to create a new credit rule
    
    ${headers}=    Create Dictionary    
    ...    User-Id=${user_id}    
    ...    Content-Type=${CREDIT_CONTENT_TYPE}

    ${balance}=    Create Dictionary
    ...    min=${min_balance}
    ...    max=${max_balance}

    ${body}=    Create Dictionary
    ...    profileId=${profile_id} 
    ...    fundProviderCode=${fund_provider_code}
    ...    customerType=${customer_type}
    ...    userType=${user_type}
    ...    closeType=${close_type}
    ...    activationOffset=${activation_offset}
    ...    registerOffset=${register_offset}
    ...    stepItemsTemplateId=${step_items_template_id}
    ...    installmentPayable=${installment_payable}
    ...    supportedCollateralTypes=${supported_collateral_types}
    ...    chequeRelativeSupport=${cheque_relative_support}
    ...    isNeedToDpScore=${is_need_to_dp_score}
    ...    balance=${balance}
    ...    allocationPaymentMethodType=${allocation_payment_method_type}
    ...    stepType=${step_type}

    ${url}=    Set Variable    ${MICROSERVICE_BASE_URL}${MS_CREDIT_ONBOARDING_PATH}/admin/rules/create
    
    ${response}=    POST    url=${url}    json=${body}    headers=${headers}    expected_status=any
    
    RETURN    ${response}