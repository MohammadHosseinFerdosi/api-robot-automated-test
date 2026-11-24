*** Settings ***
Library         library/faker_utils.py    WITH NAME    FakerLibrary
Resource        services/backend/user-wallet-initializer-service.resource
Resource        apis/settlement/post-contract.resource
Resource        apis/settlement/post-contract-search.resource
Variables       data/settlement/contract_variables.yaml


*** Keywords ***
Generate Feature Date
    [Arguments]    ${days_from_now}
    ${current_time}    Get Time    epoch
    ${specific_date}    Evaluate    int(${current_time} * 1000 + (${days_from_now} * 24 * 60 * 60 * 1000))
    RETURN    ${specific_date}

Initiate Merchant
    ${B_WALLET_SPEND_DEFINITION_EXPECTED_BALANCE}    Set Variable    0
    ${business_wallet_spend_config}    Create Dictionary
    ...    definition=${B_WALLET_SPEND_DEFINITION}
    ...    wallet_charge_amount=0
    @{main_business_config}    Create List    ${business_wallet_spend_config}

    @{role_list}    Create List    merchant-business

    ${init_business_obj}    Create Business For Initialize    ${role_list}    ${DASHBOARD_ZONE}

    Login To Dashboard    ${init_business_obj['user_name']}    ${init_business_obj['password']}

    RETURN    ${init_business_obj}

Initiate Merchant Contract
    ${business_content}    Initiate Merchant

    ${start_date1}    Generate Feature Date    1
    ${end_date1}    Generate Feature Date    365

    Post Contract
    ...    ${DASHBOARD_SIDE}
    ...    ${business_content['business_id']}
    ...    ${SETTLE_DATE_CONTRACT_CONTENT1['payment_term_id']}
    ...    ${start_date1}
    ...    ${end_date1}
    ...    ${SETTLE_DATE_CONTRACT_CONTENT1['supported_condition1']}
    ...    ${SETTLE_DATE_CONTRACT_CONTENT1['period_params']}
    ...    ${settlementDelayDays}
    ...    ${active}
    Post Contract
    ...    ${DASHBOARD_SIDE}
    ...    ${business_content['business_id']}
    ...    ${SETTLE_DATE_CONTRACT_CONTENT1['payment_term_id']}
    ...    ${start_date1}
    ...    ${end_date1}
    ...    ${SETTLE_DATE_CONTRACT_CONTENT1['supported_condition2']}
    ...    ${SETTLE_DATE_CONTRACT_CONTENT1['period_params']}
    ...    ${settlementDelayDays}
    ...    ${active}

    ${business_content}    Initiate Merchant

    ${start_date1}    Generate Feature Date    1
    ${end_date1}    Generate Feature Date    365

    Post Contract
    ...    ${DASHBOARD_SIDE}
    ...    ${business_content['business_id']}
    ...    ${SETTLE_DATE_CONTRACT_CONTENT1['payment_term_id']}
    ...    ${start_date1}
    ...    ${end_date1}
    ...    ${SETTLE_DATE_CONTRACT_CONTENT1['supported_condition1']}
    ...    ${SETTLE_DATE_CONTRACT_CONTENT1['period_params']}
    ...    ${settlementDelayDays}
    ...    ${active}
    Post Contract
    ...    ${DASHBOARD_SIDE}
    ...    ${business_content['business_id']}
    ...    ${SETTLE_DATE_CONTRACT_CONTENT1['payment_term_id']}
    ...    ${start_date1}
    ...    ${end_date1}
    ...    ${SETTLE_DATE_CONTRACT_CONTENT1['supported_condition2']}
    ...    ${SETTLE_DATE_CONTRACT_CONTENT1['period_params']}
    ...    ${settlementDelayDays}
    ...    ${active}
