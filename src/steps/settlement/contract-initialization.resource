*** Settings ***
Library         library/faker_utils.py    WITH NAME    FakerLibrary
Resource        services/backend/user-wallet-initializer-service.resource
Variables       data/settlement/contract_variables.yaml


*** Keywords ***
Initialize Merchant
    ${B_WALLET_SPEND_DEFINITION_EXPECTED_BALANCE}    Set Variable    0
    ${business_wallet_spend_config}    Create Dictionary
    ...    definition=${B_WALLET_SPEND_DEFINITION}
    ...    wallet_charge_amount=0
    @{main_business_config}    Create List    ${business_wallet_spend_config}

    @{role_list}    Create List    merchant-business

    ${init_business_obj}    Create Business For Initialize    ${role_list}    ${DASHBOARD_ZONE}

    ${BUSINESS_ID}    Set Variable    ${init_business_obj['business_id']}
    Set Test Variable    ${BUSINESS_ID}
    Set Test Variable    ${init_business_obj}
