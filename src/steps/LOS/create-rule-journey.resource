*** Settings ***
Variables   data/los/credit.yaml
Variables   config/environment-stage.yaml
Library     Process
Library     RequestsLibrary
Library     DateTime
Library     String

Resource    services/db/mysql-db-service.resource
Resource    services/db/mongo-db-service.resource
Resource    services/backend/LMS/credit-core/close-account.resource

Resource    apis/los/dashboard/post-credit-admin-rules-preview.resource
Resource    apis/los/dashboard/post-credit-admin-rules-create.resource
Resource    apis/los/dashboard/post-credit-admin-groups.resource
Resource    apis/los/dashboard/post-credit-admin-groups-confirmation-request.resource
Resource    apis/los/dashboard/post-credit-admin-groups-review.resource
Resource    apis/los/dashboard/post-credit-admin-groups-activation-decision.resource
Resource    apis/los/dashboard/post-credit-admin-groups-state.resource
Resource    apis/los/dashboard/post-credit-admin-plans.resource

*** Keywords ***
Admin Completes Rule Credit Cheque Creation Process
    The Admin Previews The Credit Rule
    Check Preview Details Success
    The Admin Creates The Cheque Credit Rule
    Check Rule Creation Success

Admin Completes Rule Credit E_note Creation Process
    The Admin Previews The Credit Rule
    Check Preview Details Success
    The Admin Creates The e-note Credit Rule
    Check Rule Creation Success

Admin Completes Rule Credit Un_Payble Creation Process
    The Admin Previews The Credit Rule
    Check Preview Details Success
    The Admin Creates The Un_Payble Credit Rule
    Check Rule Creation Success

Admin Completes Rule BNPL Creation Process
    The Admin Previews The Credit Rule
    Check Preview Details Success
    The Admin Creates The BNPL Rule
    Check Rule Creation Success

Admin Completes Rule Installment_Cheque Creation Process
    The Admin Previews The Credit Rule
    Check Preview Details Success
    The Admin Creates The Installment_Cheque Rule
    Check Rule Creation Success

Admin Completes Rule Without_Collateral Credit Creation Process  
    The Admin Previews The Credit Rule
    Check Preview Details Success
    The Admin Creates The Without_Collateral Credit Rule
    Check Rule Creation Success
    
Admin Completes Public Group Creation Process
    The Admin Creates A New Credit Group Public Plan
    Check Group Creation Success
    The Admin Requests Group Confirmation
    Check Group Confirmation Request Success
    The Admin Reviews The Credit Group
    Check Group Review Success
    The Admin Decides On Group Activation
    Check Group Activation Success
    The Admin Updates The Credit Group State
    Check Group State Update Success

Admin Completes Whitelist Group Creation Process
    The Admin Creates A New Credit Group Whitelist
    Check Group Creation Success
    The Admin Requests Group Confirmation
    Check Group Confirmation Request Success
    The Admin Reviews The Credit Group
    Check Group Review Success
    The Admin Decides On Group Activation
    Check Group Activation Success
    The Admin Updates The Credit Group State
    Check Group State Update Success

Admin Completes Plan Creation Process
    The Admin Creates The Credit Plan 
    Check Plan Creation Success

Admin Cleans Up Created Data
    Delete Created Plan From MongoDB
    Delete Created Group From MySQL
    Delete Created Rule From MongoDB

The Admin Previews The Credit Rule
    ${result}=    POST Credit Admin Rules Preview
    ...    user_id=${ADMIN_USER_ID}
    ...    fund_provider_code=${CREDIT_TEJARAT_FP_CODE}
    ...    profile_id=${CREDIT_PROFILE_ID}
    ...    min_balance=${MIN_BALANCE}
    ...    max_balance=${MAX_BALANCE}
    Set Test Variable    ${PREVIEW_RESPONSE}    ${result}

Check Preview Details Success
    Should Be Equal As Numbers       ${PREVIEW_RESPONSE}[status_code]    200
    Should Be Equal As Strings       ${PREVIEW_RESPONSE}[body][fundProviderName]    ${TEJARAT_FP_NAME}
    Should Be Equal As Strings       ${PREVIEW_RESPONSE}[body][color]               ${COLOR}
    Dictionary Should Contain Key    ${PREVIEW_RESPONSE}[body]                      planDetails

The Admin Creates The Cheque Credit Rule
    ${collateral_types}=    Create List    ${1}
    ${cheque_support}=      Create List    ${0}
    ${result}=    POST Credit Admin Rules Create
    ...    user_id=${ADMIN_USER_ID}
    ...    profile_id=${CREDIT_PROFILE_ID}
    ...    fund_provider_code=${CREDIT_TEJARAT_FP_CODE}
    ...    min_balance=${MIN_BALANCE}
    ...    max_balance=${MAX_BALANCE}
    ...    customer_type=${0}
    ...    user_type=${0}
    ...    close_type=${0}
    ...    activation_offset=${30}
    ...    register_offset=${0}
    ...    step_items_template_id=${STEP_ITEMS_TEMPLATE_ID_CHEQUE}
    ...    installment_payable=${TRUE}
    ...    supported_collateral_types=${collateral_types}
    ...    cheque_relative_support=${cheque_support}
    ...    is_need_to_dp_score=${FALSE}
    ...    allocation_payment_method_type=${1}
    ...    step_type=${1}
    Set Test Variable    ${CREATE_RESPONSE}    ${result}

The Admin Creates The e-note Credit Rule
    ${collateral_types}=    Create List    ${2}
    ${cheque_support}=      Create List    ${0}
    ${result}=    POST Credit Admin Rules Create
    ...    user_id=${ADMIN_USER_ID}
    ...    profile_id=${CREDIT_PROFILE_ID}
    ...    fund_provider_code=${CREDIT_TEJARAT_FP_CODE}
    ...    min_balance=${MIN_BALANCE}
    ...    max_balance=${MAX_BALANCE}
    ...    customer_type=${0}
    ...    user_type=${0}
    ...    close_type=${0}
    ...    activation_offset=${30}
    ...    register_offset=${0}
    ...    step_items_template_id=${STEP_ITEMS_TEMPLATE_ID_E_NOTE}
    ...    installment_payable=${TRUE}
    ...    supported_collateral_types=${collateral_types}
    ...    cheque_relative_support=${cheque_support}
    ...    is_need_to_dp_score=${FALSE}
    ...    allocation_payment_method_type=${1}
    ...    step_type=${1}
    Set Test Variable    ${CREATE_RESPONSE}    ${result}

The Admin Creates The Un_Payble Credit Rule
    ${collateral_types}=    Create List    ${3}
    ${cheque_support}=      Create List    ${0}
    ${result}=    POST Credit Admin Rules Create
    ...    user_id=${ADMIN_USER_ID}
    ...    profile_id=${CREDIT_PROFILE_ID}
    ...    fund_provider_code=${CREDIT_TEJARAT_FP_CODE}
    ...    min_balance=${MIN_BALANCE}
    ...    max_balance=${MAX_BALANCE}
    ...    customer_type=${0}
    ...    user_type=${0}
    ...    close_type=${0}
    ...    activation_offset=${30}
    ...    register_offset=${0}
    ...    step_items_template_id=${STEP_ITEMS_TEMPLATE_ID_UN_PAYABLE}
    ...    installment_payable=${TRUE}
    ...    supported_collateral_types=${collateral_types}
    ...    cheque_relative_support=${cheque_support}
    ...    is_need_to_dp_score=${FALSE}
    ...    allocation_payment_method_type=${1}
    ...    step_type=${1}
    Set Test Variable    ${CREATE_RESPONSE}    ${result}

The Admin Creates The BNPL Rule
    ${collateral_types}=    Create List    ${4}
    ${cheque_support}=      Create List    ${0}
    ${result}=    POST Credit Admin Rules Create
    ...    user_id=${ADMIN_USER_ID}
    ...    profile_id=${BNPL_PROFILE_ID}
    ...    fund_provider_code=${BNPL_FP_CODE}
    ...    min_balance=${MIN_BALANCE}
    ...    max_balance=${MAX_BALANCE}
    ...    customer_type=${0}
    ...    user_type=${0}
    ...    close_type=${0}
    ...    activation_offset=${30}
    ...    register_offset=${0}
    ...    step_items_template_id=${STEP_ITEMS_TEMPLATE_ID_BNPL}
    ...    installment_payable=${TRUE}
    ...    supported_collateral_types=${collateral_types}
    ...    cheque_relative_support=${cheque_support}
    ...    is_need_to_dp_score=${FALSE}
    ...    allocation_payment_method_type=${0}
    ...    step_type=${null}
    Set Test Variable    ${CREATE_RESPONSE}    ${result}

The Admin Creates The Installment Cheque Rule
    ${collateral_types}=    Create List    ${5}
    ${cheque_support}=      Create List    ${0}
    ${result}=    POST Credit Admin Rules Create
    ...    user_id=${ADMIN_USER_ID}
    ...    profile_id=${INSTALLMENT_CHEQUE_PROFILE_ID}
    ...    fund_provider_code=${BNPL_FP_CODE}
    ...    min_balance=${MIN_BALANCE}
    ...    max_balance=${MAX_BALANCE}
    ...    customer_type=${0}
    ...    user_type=${0}
    ...    close_type=${0}
    ...    activation_offset=${30}
    ...    register_offset=${0}
    ...    step_items_template_id=${STEP_ITEMS_TEMPLATE_ID_INSTALLMENT_CHEQUE}
    ...    installment_payable=${TRUE}
    ...    supported_collateral_types=${collateral_types}
    ...    cheque_relative_support=${cheque_support}
    ...    is_need_to_dp_score=${FALSE}
    ...    allocation_payment_method_type=${0}
    ...    step_type=${null}
    Set Test Variable    ${CREATE_RESPONSE}    ${result}

The Admin Creates The Without_Collateral Credit Rule  
    ${collateral_types}=    Create List    ${7}
    ${cheque_support}=      Create List    ${0}
    ${result}=    POST Credit Admin Rules Create
    ...    user_id=${ADMIN_USER_ID}
    ...    profile_id=${CREDIT_PROFILE_ID}
    ...    fund_provider_code=${CREDIT_TEJARAT_FP_CODE}
    ...    min_balance=${MIN_BALANCE}
    ...    max_balance=${MAX_BALANCE}
    ...    customer_type=${0}
    ...    user_type=${0}
    ...    close_type=${0}
    ...    activation_offset=${30}
    ...    register_offset=${0}
    ...    step_items_template_id=${STEP_ITEMS_TEMPLATE_ID_WITHOUT_COLLATERAL}
    ...    installment_payable=${TRUE}
    ...    supported_collateral_types=${collateral_types}
    ...    cheque_relative_support=${cheque_support}
    ...    is_need_to_dp_score=${FALSE}
    ...    allocation_payment_method_type=${1}
    ...    step_type=${1}
    Set Test Variable    ${CREATE_RESPONSE}    ${result}

Check Rule Creation Success
    Should Be Equal As Numbers    ${CREATE_RESPONSE.status_code}    200
    ${body}=    Set Variable    ${CREATE_RESPONSE.json()}
    Should Be Equal As Numbers    ${body}[result][status]    0
    Should Be Equal As Strings    ${body}[result][title]     SUCCESS
    ${extracted_rule_id}=         Set Variable    ${body}[ruleId]
    Set Suite Variable            ${rule_id}      ${extracted_rule_id}

The Admin Creates A New Credit Group Public Plan
    ${title_string}=    Set Variable    Automation Group for ${rule_id}
    ${result}=    POST Credit Admin Groups
    ...    api_call_side=${MICROSERVICE_SIDE}
    ...    user_id=${ADMIN_USER_ID}
    ...    title=${title_string}
    ...    fund_provider_id=${CREDIT_TEJARAT_FP_ID}
    ...    rule_id=${rule_id}
    ...    user_entry_point=${1}
    ...    crn=${NONE}
    Set Test Variable    ${GROUP_RESPONSE}    ${result}

The Admin Creates A New Credit Group Whitelist
    ${title_string}=    Set Variable    Automation Group for ${rule_id}
    ${result}=    POST Credit Admin Groups
    ...    api_call_side=${MICROSERVICE_SIDE}
    ...    user_id=${ADMIN_USER_ID}
    ...    title=${title_string}
    ...    fund_provider_id=${CREDIT_TEJARAT_FP_ID}
    ...    rule_id=${rule_id}
    ...    user_entry_point=${4}
    ...    crn=${NONE}
    Set Test Variable    ${GROUP_RESPONSE}    ${result}

Check Group Creation Success
    Should Be Equal As Numbers    ${GROUP_RESPONSE}[status_code]    200
    Should Be Equal As Numbers    ${GROUP_RESPONSE}[body][result][status]    0
    Should Be Equal As Strings    ${GROUP_RESPONSE}[body][result][title]     SUCCESS
    ${extracted_group_id}=        Set Variable    ${GROUP_RESPONSE}[body][groupId]
    Set Suite Variable            ${group_id}     ${extracted_group_id}

The Admin Requests Group Confirmation
    ${result}=    POST Credit Admin Groups Confirmation Request
    ...    api_call_side=${MICROSERVICE_SIDE}
    ...    user_id=${ADMIN_USER_ID}
    ...    group_id=${group_id}
    Set Test Variable    ${GROUP_CONFIRM_REQ_RESPONSE}    ${result}

Check Group Confirmation Request Success
    Should Be Equal As Numbers    ${GROUP_CONFIRM_REQ_RESPONSE}[status_code]    200
    Should Be Equal As Numbers    ${GROUP_CONFIRM_REQ_RESPONSE}[body][result][status]    0
    Should Be Equal As Strings    ${GROUP_CONFIRM_REQ_RESPONSE}[body][result][title]     SUCCESS

The Admin Reviews The Credit Group
    ${result}=    POST Credit Admin Groups Review
    ...    api_call_side=${MICROSERVICE_SIDE}
    ...    user_id=${ADMIN_USER_ID}
    ...    group_id=${group_id}
    ...    comment=${COMMENT}
    Set Test Variable    ${GROUP_REVIEW_RESPONSE}    ${result}

Check Group Review Success
    Should Be Equal As Numbers    ${GROUP_REVIEW_RESPONSE}[status_code]    200
    Should Be Equal As Numbers    ${GROUP_REVIEW_RESPONSE}[body][result][status]    0
    Should Be Equal As Strings    ${GROUP_REVIEW_RESPONSE}[body][result][title]     SUCCESS

The Admin Decides On Group Activation
    ${current_date}=    Get Current Date
    ${future_date}=     Add Time To Date    ${current_date}    30 days
    ${epoch_seconds}=   Convert Date    ${future_date}    epoch
    ${deadline_ms}=     Evaluate    int(${epoch_seconds} * 1000)
    ${result}=    POST Credit Admin Groups Activation Decision
    ...    api_call_side=${MICROSERVICE_SIDE}
    ...    user_id=${ADMIN_USER_ID}
    ...    group_id=${group_id}
    ...    deadline_timestamp=${deadline_ms}
    ...    accept_decision=${True}
    Set Test Variable    ${GROUP_ACTIVATION_RESPONSE}    ${result}

Check Group Activation Success
    Should Be Equal As Numbers    ${GROUP_ACTIVATION_RESPONSE}[status_code]    200
    Should Be Equal As Numbers    ${GROUP_ACTIVATION_RESPONSE}[body][result][status]    0
    Should Be Equal As Strings    ${GROUP_ACTIVATION_RESPONSE}[body][result][title]     SUCCESS

The Admin Updates The Credit Group State
    ${result}=    POST Credit Admin Groups State
    ...    api_call_side=${MICROSERVICE_SIDE}
    ...    user_id=${ADMIN_USER_ID}
    ...    group_id=${group_id}
    Set Test Variable    ${GROUP_STATE_RESPONSE}    ${result}

Check Group State Update Success
    Should Be Equal As Numbers    ${GROUP_STATE_RESPONSE}[status_code]    200
    Should Be Equal As Numbers    ${GROUP_STATE_RESPONSE}[body][result][status]    0
    Should Be Equal As Strings    ${GROUP_STATE_RESPONSE}[body][result][title]     SUCCESS

The Admin Creates The Credit Plan
    ${result}=    POST Credit Admin Plans
    ...    api_call_side=${MICROSERVICE_SIDE}
    ...    user_id=${ADMIN_USER_ID}
    ...    group_id=${group_id}
    ...    active=${True}
    ...    visible=${True}
    Set Test Variable    ${PLAN_RESPONSE}    ${result}

Check Plan Creation Success
    Should Be Equal As Numbers    ${PLAN_RESPONSE}[status_code]    200
    Should Be Equal As Numbers    ${PLAN_RESPONSE}[body][result][status]    0
    Should Be Equal As Strings    ${PLAN_RESPONSE}[body][result][title]     SUCCESS
    ${extracted_plan_id}=         Set Variable    ${PLAN_RESPONSE}[body][planId]
    Set Suite Variable            ${plan_id}      ${extracted_plan_id}

Delete Created Plan From MongoDB
    ${is_plan_id_set}=    Run Keyword And Return Status    Variable Should Exist    ${plan_id}
    IF    ${is_plan_id_set}
        ${filter_dict}=    Evaluate    {"planId": "${plan_id}"}
        Run Keyword And Ignore Error    Mongo Db Delete One    ${CREDIT_DB}    plans    ${filter_dict}
    END

Delete Created Group From MySQL
    ${is_group_id_set}=    Run Keyword And Return Status    Variable Should Exist    ${group_id}
    IF    ${is_group_id_set}
        ${query}=    Set Variable    DELETE FROM `groups` WHERE group_id='${group_id}'
        ${response}=    MySQL Execute Query    ${SWITCH_CREDIT_DB_NAME}    ${query}
        Should Be Equal As Numbers    ${response['status_code']}    0
    END

Delete Created Rule From MongoDB
    ${is_rule_id_set}=    Run Keyword And Return Status    Variable Should Exist    ${rule_id}
    IF    ${is_rule_id_set}
        ${filter_dict}=    Evaluate    {"ruleId": "${rule_id}"}
        Run Keyword And Ignore Error    Mongo Db Delete One    ${CREDIT_DB}    rules    ${filter_dict}
    END