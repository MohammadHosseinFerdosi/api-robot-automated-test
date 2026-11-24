*** Settings ***
Resource    apis/lms/credit-core/get-credit-early-settlements-detail.resource
Resource    apis/lms/credit-core/post-credit-early-settlements-init.resource
Resource    apis/lms/credit-core/post-credit-early-settlements-pay-wallet.resource
Resource    services/backend/auth-service.resource
Resource    services/backend/user-wallet-initializer-service.resource
# Resource    services/AI/IPG.resource


*** Keywords ***
Default Early Settlement Amount Handler
    [Documentation]    Returns the total early settlement amount
    [Tags]    robot:private
    [Arguments]
    ...    ${user_id}
    ...    ${credit_id}
    ${response_detail}    GET Credit Early Settlements Detail
    ...    api_call_side=${MICROSERVICE_SIDE}
    ...    user_id=${user_id}
    ...    credit_id=${credit_id}
    ${amount}    Set Variable    ${response_detail['body']['amount']}
    RETURN    ${amount}

Initiate The Early Settlement
    [Documentation]    Initiates an early settlement ticket. Returns the ${ticket} and the ${pay_url}.
    [Tags]    robot:private
    [Arguments]
    ...    ${user_id}
    ...    ${credit_id}
    ...    ${cell_number}
    ...    ${amount}
    ${data}    Create Dictionary
    ${redirect_details_after_result}    Create Dictionary
    ...    text=ROBOT Automation ES Init
    ...    path=string
    ...    method=1
    ...    data=${data}
    ${response_init}    POST Credit Early Settlements Init
    ...    api_call_side=${MICROSERVICE_SIDE}
    ...    user_id=${user_id}
    ...    credit_id=${credit_id}
    ...    amount=${amount}
    ...    cell_number=${cell_number}
    ...    type=5
    ...    agent=WEB
    ...    redirect_url=string
    ...    redirect_details_after_result=${redirect_details_after_result}

    ${pay_url}    Set Variable    ${response_init['body']['payUrl']}
    ${ticket}    Set Variable    ${response_init['body']['ticket']}

    RETURN    ${ticket}    ${pay_url}

Initiate The User Wallet For The Early Settlement
    [Documentation]    Charges the user's default wallet, which is used to pay the early settlements bills.
    [Tags]    robot:private
    [Arguments]    ${user_id}    ${amount}

    ${default_wallet}    Create Dictionary
    ...    definition=${WALLET_DEFAULT_DEFINITION}
    ...    wallet_charge_amount=${amount}
    ...    cashoutable_charge_amount=${amount}
    ${wallets_config_list}    Create List    ${default_wallet}

    Create And Charge User Wallet Based On Configuration
    ...    user_id=${user_id}
    ...    wallets_config_list=${wallets_config_list}

Pay Early Settlement Via Wallet
    [Documentation]    This methods, initiates an early settlement ticket, Then pays the ticket via the pay-wallet api.
    ...    The users must have enough funds in their default wallets to pay the early settlement!
    ...    If the ${amount} is ${EMPTY}, then the total amount is used to be paid.
    [Arguments]
    ...    ${user_id}
    ...    ${credit_id}
    ...    ${cell_number}
    ...    ${amount}=${EMPTY}

    IF    "${amount}"=="${EMPTY}"
        ${amount}    Default Early Settlement Amount Handler    user_id=${user_id}    credit_id=${credit_id}
    END

    Initiate The User Wallet For The Early Settlement    user_id=${user_id}    amount=${amount}

    ${ticket}    ${pay_url}    Initiate The Early Settlement
    ...    user_id=${user_id}
    ...    credit_id=${credit_id}
    ...    cell_number=${cell_number}
    ...    amount=${amount}

    POST Credit Early Settlements Pay Wallet    api_call_side=${MICROSERVICE_SIDE}    ticket=${ticket}    type=wallet

    RETURN    ${ticket}

# Pay Early Settlement Via IPG
#    [Documentation]    This methods, initiates an early settlement ticket, Then pays the ticket via the IPG which uses the AI utils.
#    ...    The users must have enough funds in their tribe bank accounts to pay the early settlement!
#    ...    If the ${amount} is ${EMPTY}, then the total amount is used to be paid.
#    ...
#    ...    > **Note**: Due to experimental stages of the AI utils, It is advised that the users use this keyword with that in mind.
#    [Arguments]
#    ...    ${user_id}
#    ...    ${credit_id}
#    ...    ${cell_number}
#    ...    ${card_number}
#    ...    ${CVV2}
#    ...    ${month}
#    ...    ${year}
#    ...    ${card_pass}
#    ...    ${amount}=${EMPTY}

#    IF    "${amount}"=="${EMPTY}"
#    ${amount}    Default Early Settlement Amount Handler    user_id=${user_id}    credit_id=${credit_id}
#    END

#    ${ticket}    ${pay_url}    Initiate The Early Settlement
#    ...    user_id=${user_id}
#    ...    credit_id=${credit_id}
#    ...    cell_number=${cell_number}
#    ...    amount=${amount}

#    Pay IPG via AI with Retries on Captcha
#    ...    card_number=${card_number}
#    ...    CVV2=${CVV2}
#    ...    month=${month}
#    ...    year=${year}
#    ...    card_pass=${card_pass}
#    ...    URL=${pay_url}
#    ...    browser=${FIREFOX}
#    ...    concurrent=False
