*** Settings ***
Library         DateTime
Resource        apis/tgs/post-tickets-business.resource
Resource        apis/tgs/post-tickets-features-select.resource
Resource        apis/tgs/get-tickets.resource
Resource        services/backend/user-wallet-initializer-service.resource
Variables       data/payment/purchase/purchase-dpg.yaml
Variables       data/payment/purchase/purchase-wallet.yaml
Variables       data/payment/tgs/tgs.yaml
################# POST TICKET BUSINESS ##########################


*** Keywords ***
###############################    ANDROID PURCHASE    ##############################################
Create A New User And Assign Default Wallet
    [Documentation]    Create A New User And Assign Default Wallet

    ${wallet_config}    Create Dictionary
    ...    definition=${WALLET_DEFAULT_DEFINITION}
    ...    wallet_charge_amount=${TEST_AMOUNT}
    ...    cashoutable_charge_amount=${TEST_AMOUNT}
    @{wallet_config_list}    Create List    ${wallet_config}

    ${new_user}    Get Initialized User With Charged Wallet Based On Configuration
    ...    ${CELL_NUMBER_PREFIX}
    ...    ${wallet_config_list}
    ${TEST_CELLNUMBER_PAY}    Set Variable    ${new_user['user_cell_number']}
    RETURN    ${TEST_CELLNUMBER_PAY}

Success Getting Ticket For Purchase With Android Agent(Gateway)
    [Documentation]    This API Will Be Called From Gateway, So Platform Business Token Should Be Set And Agent Is Android
    ${providerId}    Generate Random String    15
    ${post_ticket_response}    POST Tickets Business
    ...    ${GENERAL_SIDE}
    ...    ${TEST_CELLNUMBER_PAY}
    ...    ${TEST_AMOUNT}
    ...    ${TEST_CALLBACK_URL}
    ...    ${providerId}
    ...    ${UPG_TICKET_TYPE}
    ...    ${ANDROID_AGENT}
    ...    ${PLATFORM_VERSION_2020}
    Should Be Equal As Integers    ${post_ticket_response['status_code']}    200    Invalid response code
    Set Test Variable    ${SDK_Ticket}    ${post_ticket_response['body']['ticket']}
    ${redirctUrl}    Get Value From Json    ${post_ticket_response['body']}    $.redirectUrl
    # Should Be Equal As Strings    ${post_ticket_response["body"].result.title}    ${SUCCESS_TITLE}
    Should Be Equal As Integers    ${post_ticket_response['body'].result.status}    ${SUCCESS_STATUS_CODE}
    Should Be Equal As Strings    ${post_ticket_response['body'].result.message}    ${SUCCESS_MESSAGE}
    Should Be Equal As Strings    ${post_ticket_response['body'].result.level}    ${INFO_LEVEL}

Success Getting Ticket For Purchase With Android Agent (Microservice)
    [Documentation]    This API Will Be Called Through Microservice, So Platform User Id Should Exist In Header And Agent Is Android
    ${providerId}    Generate Random String    15

    ${post_ticket_response}    POST Tickets Business
    ...    ${MICROSERVICE_SIDE}
    ...    ${TEST_CELLNUMBER_PAY}
    ...    ${TEST_AMOUNT}
    ...    ${TEST_CALLBACK_URL}
    ...    ${providerId}
    ...    ${UPG_TICKET_TYPE}
    ...    ${ANDROID_AGENT}
    ...    ${PLATFORM_VERSION_2020}
    ...    ${PLATFORM_UESERNAME}
    Should Be Equal As Integers    ${post_ticket_response['status_code']}    200    Invalid response code
    Set Test Variable    ${SDK_Ticket}    ${post_ticket_response['body']['ticket']}
    ${redirctUrl}    Get Value From Json    ${post_ticket_response['body']}    $.redirectUrl
    Should Be Equal As Strings    ${post_ticket_response['body'].result.title}    ${SUCCESS_TITLE}
    Should Be Equal As Integers    ${post_ticket_response['body'].result.status}    ${SUCCESS_STATUS_CODE}
    Should Be Equal As Strings    ${post_ticket_response['body'].result.message}    ${SUCCESS_MESSAGE}
    Should Be Equal As Strings    ${post_ticket_response['body'].result.level}    ${INFO_LEVEL}

Failed Getting Ticket With Android Agent And Null Provider Id On Platform (Gateway)
    [Documentation]    This API Will Be Called From Gateway, So Platform Business Token Should Be Set And Agent Is Android Then
    ...    Provider Id Will Be Sent With Null Value In Request Body
    ${providerId}    Set Variable    ${EMPTY}
    Login For Business    ${PLATFORM_UESERNAME}    ${PLATFORM_PASSWORD}
    ${post_ticket_response}    POST Tickets Business
    ...    ${GENERAL_SIDE}
    ...    ${TEST_CELLNUMBER_PAY}
    ...    ${TEST_AMOUNT}
    ...    ${TEST_CALLBACK_URL}
    ...    ${providerId}
    ...    ${UPG_TICKET_TYPE}
    ...    ${ANDROID_AGENT}
    ...    ${PLATFORM_VERSION_2020}
    Should Be Equal As Integers    ${post_ticket_response['status_code']}    422
    Should Be Equal As Strings    ${post_ticket_response['body'].result.title}    ${INVALID_TITLE}
    Should Be Equal As Integers    ${post_ticket_response['body'].result.status}    ${INVALID_STATUS_CODE}
    Should Be Equal As Strings    ${post_ticket_response['body'].result.message}    ${PROVIDER_ID_MESSAGE}
    Should Be Equal As Strings    ${post_ticket_response['body'].result.level}    ${BLOCKER_LEVEL}

Failed Getting Ticket With Android Agent And Duplicated Provider Id On Platform (Gateway)
    [Documentation]    This API Will Be Called From Gateway, So Platform Business Token Should Be Set And Agent Is Android Then
    ...    Provider Id Will Be Sent With Null Value In Request Body
    ${providerId}    Set Variable    1234
    Login For Business    ${PLATFORM_UESERNAME}    ${PLATFORM_PASSWORD}
    ${post_ticket_response}    POST Tickets Business
    ...    ${GENERAL_SIDE}
    ...    ${TEST_CELLNUMBER_PAY}
    ...    ${TEST_AMOUNT}
    ...    ${TEST_CALLBACK_URL}
    ...    ${providerId}
    ...    ${UPG_TICKET_TYPE}
    ...    ${ANDROID_AGENT}
    ...    ${PLATFORM_VERSION_2020}
    Should Be Equal As Integers    ${post_ticket_response['status_code']}    422
    Should Be Equal As Strings    ${post_ticket_response['body'].result.title}    ${TICKET_EXPIRATION_TITLE}
    Should Be Equal As Integers    ${post_ticket_response['body'].result.status}    ${EXPIRATION_STATUS_CODE}
    Should Be Equal As Strings    ${post_ticket_response['body'].result.message}    ${EXPIRATION_MESSAGE}
    Should Be Equal As Strings    ${post_ticket_response['body'].result.level}    ${WARNING_LEVEL}

Failed Getting Ticket With Android Agent And Null Cell Number On Platform (Gateway)
    [Documentation]    This API Will Be Called From Gateway, So Platform Business Token Should Be Set And Agent Is Android Then
    ...    Cell Number Will Be Sent With Null Value In Request Body
    ${providerId}    Generate Random String    15
    ${cellNumber}    Set Variable    ${EMPTY}
    ${post_ticket_response}    POST Tickets Business
    ...    ${GENERAL_SIDE}
    ...    ${cellNumber}
    ...    ${TEST_AMOUNT}
    ...    ${TEST_CALLBACK_URL}
    ...    ${providerId}
    ...    ${UPG_TICKET_TYPE}
    ...    ${ANDROID_AGENT}
    ...    ${PLATFORM_VERSION_2020}
    Should Be Equal As Integers    ${post_ticket_response['status_code']}    422
    Should Be Equal As Strings    ${post_ticket_response['body'].result.title}    ${INVALID_TITLE}
    Should Be Equal As Integers    ${post_ticket_response['body'].result.status}    ${INVALID_STATUS_CODE}
    Should Be Equal As Strings    ${post_ticket_response['body'].result.message}    ${WRONG_INFO_MESSAGE}
    Should Be Equal As Strings    ${post_ticket_response['body'].result.level}    ${BLOCKER_LEVEL}

Failed Getting Ticket With Android Agent And Wrong Cell Number On Platform (Gateway)
    [Documentation]    This API Will Be Called From Gateway, So Platform Business Token Should Be Set And Agent Is Android Then
    ...    Cell Number Will Be Sent In A Wrong Format In Request Body
    ${providerId}    Generate Random String    15
    ${cellNumber}    Generate Random String    11
    ${post_ticket_response}    POST Tickets Business
    ...    ${GENERAL_SIDE}
    ...    ${cellNumber}
    ...    ${TEST_AMOUNT}
    ...    ${TEST_CALLBACK_URL}
    ...    ${providerId}
    ...    ${UPG_TICKET_TYPE}
    ...    ${ANDROID_AGENT}
    ...    ${PLATFORM_VERSION_2020}
    Should Be Equal As Integers    ${post_ticket_response['status_code']}    422
    Should Be Equal As Strings    ${post_ticket_response['body'].result.title}    ${INVALID_TITLE}
    Should Be Equal As Integers    ${post_ticket_response['body'].result.status}    ${INVALID_STATUS_CODE}
    Should Be Equal As Strings    ${post_ticket_response['body'].result.message}    ${WRONG_INFO_MESSAGE}
    Should Be Equal As Strings    ${post_ticket_response['body'].result.level}    ${BLOCKER_LEVEL}

Failed Getting Ticket With Android Agent And Null Amount On Platform (Gateway)
    [Documentation]    This API Will Be Called From Gateway, So Platform Business Token Should Be Set And Agent Is Android Then
    ...    Amount Will Be Sent With Null Value In Request Body
    ${providerId}    Generate Random String    15
    ${amount}    Set Variable    ${EMPTY}
    ${post_ticket_response}    POST Tickets Business
    ...    ${GENERAL_SIDE}
    ...    ${TEST_CELLNUMBER_PAY}
    ...    ${amount}
    ...    ${TEST_CALLBACK_URL}
    ...    ${providerId}
    ...    ${UPG_TICKET_TYPE}
    ...    ${ANDROID_AGENT}
    ...    ${PLATFORM_VERSION_2020}
    Should Be Equal As Integers    ${post_ticket_response['status_code']}    422
    Should Be Equal As Strings    ${post_ticket_response['body'].result.title}    ${Not_FOUNT_TITLE}
    Should Be Equal As Integers    ${post_ticket_response['body'].result.status}    ${Not_FOUNT_STATUS_CODE}
    Should Be Equal As Strings    ${post_ticket_response['body'].result.message}    ${Not_FOUNT_MESSAGE}
    Should Be Equal As Strings    ${post_ticket_response['body'].result.level}    ${WARNING_LEVEL}

Failed Getting Ticket With Android Agent And Null CallbackUrl On Platform (Gateway)
    [Documentation]    This API Will Be Called From Gateway, So Platform Business Token Should Be Set And Agent Is Android Then
    ...    CallbackUrl Will Be Sent With Null Value In Request Body
    ${providerId}    Generate Random String    15
    ${callbackUrl}    Set Variable    ${EMPTY}
    ${post_ticket_response}    POST Tickets Business
    ...    ${GENERAL_SIDE}
    ...    ${TEST_CELLNUMBER_PAY}
    ...    ${TEST_AMOUNT}
    ...    ${callbackUrl}
    ...    ${providerId}
    ...    ${UPG_TICKET_TYPE}
    ...    ${ANDROID_AGENT}
    ...    ${PLATFORM_VERSION_2020}
    Should Be Equal As Integers    ${post_ticket_response['status_code']}    422
    Should Be Equal As Strings    ${post_ticket_response['body'].result.title}    ${INVALID_TITLE}
    Should Be Equal As Integers    ${post_ticket_response['body'].result.status}    ${INVALID_STATUS_CODE}
    Should Be Equal As Strings    ${post_ticket_response['body'].result.message}    ${WRONG_INFO_MESSAGE}
    Should Be Equal As Strings    ${post_ticket_response['body'].result.level}    ${BLOCKER_LEVEL}

###############################    WEB PURCHASE    ##############################################

Success Getting Ticket For Purchase With Web Agent(Gateway)
    [Documentation]    This API Will Be Called From Gateway, So Business Token Should Be Set And Agent Is Web
    ${providerId}    Generate Random String    15
    ${post_ticket_response}    POST Tickets Business
    ...    ${GENERAL_SIDE}
    ...    ${TEST_CELLNUMBER_PAY}
    ...    ${TEST_AMOUNT}
    ...    ${TEST_CALLBACK_URL}
    ...    ${providerId}
    ...    ${UPG_TICKET_TYPE}
    ...    ${WEB_AGENT}
    ...    ${PLATFORM_VERSION_2020}
    Should Be Equal As Integers    ${post_ticket_response['status_code']}    200    Invalid response code
    Set Test Variable    ${UPG_Ticket}    ${post_ticket_response['body']['ticket']}
    ${redirctUrl}    Get Value From Json    ${post_ticket_response['body']}    $.redirectUrl
    # Should Be Equal As Strings    ${post_ticket_response['body'].result.title}    ${SUCCESS_TITLE}
    Should Be Equal As Integers    ${post_ticket_response['body'].result.status}    ${SUCCESS_STATUS_CODE}
    Should Be Equal As Strings    ${post_ticket_response['body'].result.message}    ${SUCCESS_MESSAGE}
    Should Be Equal As Strings    ${post_ticket_response['body'].result.level}    ${INFO_LEVEL}

Success Getting Ticket For Purchase With Web Agent(Microservice)
    [Documentation]    This API Will Be Called Through Microservice, So User Id Should Exist In Header And Agent Is Web
    ${providerId}    Generate Random String    15

    ${post_ticket_response}    POST Tickets Business
    ...    ${MICROSERVICE_SIDE}
    ...    ${TEST_CELLNUMBER_PAY}
    ...    ${TEST_AMOUNT}
    ...    ${TEST_CALLBACK_URL}
    ...    ${providerId}
    ...    ${UPG_TICKET_TYPE}
    ...    ${WEB_AGENT}
    ...    ${PLATFORM_VERSION_2020}
    ...    ${PLATFORM_UESERNAME}
    Should Be Equal As Integers    ${post_ticket_response['status_code']}    200    Invalid response code
    ${ticket}    Get Value From Json    ${post_ticket_response['body']}    $.ticket
    Set Test Variable    ${UPG_Ticket}    ${ticket[0]}
    ${redirctUrl}    Get Value From Json    ${post_ticket_response['body']}    $.redirectUrl
    Should Be Equal As Strings    ${post_ticket_response['body'].result.title}    ${SUCCESS_TITLE}
    Should Be Equal As Integers    ${post_ticket_response['body'].result.status}    ${SUCCESS_STATUS_CODE}
    Should Be Equal As Strings    ${post_ticket_response['body'].result.message}    ${SUCCESS_MESSAGE}
    Should Be Equal As Strings    ${post_ticket_response['body'].result.level}    ${INFO_LEVEL}

###############################    ANDROID ICP    ##############################################

Success Getting Ticket For ICP With Android Agent On Platform Business(Gateway)
    [Documentation]    This API Will Be Called From Gateway, So Token Should Be Set And Agent Is Android
    ${providerId}    Generate Random String    15
    Login For Business    ${PLATFORM_UESERNAME}    ${PLATFORM_PASSWORD}
    ${post_ticket_response}    POST Tickets Business
    ...    ${GENERAL_SIDE}
    ...    ${TEST_CELLNUMBER_ICP}
    ...    ${TEST_ICP_AMOUNT}
    ...    ${TEST_CALLBACK_URL}
    ...    ${providerId}
    ...    ${UPG_TICKET_TYPE}
    ...    ${ANDROID_AGENT}
    ...    ${PLATFORM_VERSION_2024}
    Should Be Equal As Integers    ${post_ticket_response['status_code']}    200    Invalid response code
    Set Test Variable    ${SDK_Ticket}    ${post_ticket_response['body']['ticket']}
    ${redirctUrl}    Get Value From Json    ${post_ticket_response['body']}    $.redirectUrl
    # Should Be Equal As Strings    ${post_ticket_response["body"].result.title}    ${SUCCESS_TITLE}
    Should Be Equal As Integers    ${post_ticket_response['body'].result.status}    ${SUCCESS_STATUS_CODE}
    Should Be Equal As Strings    ${post_ticket_response['body'].result.message}    ${SUCCESS_MESSAGE}
    Should Be Equal As Strings    ${post_ticket_response['body'].result.level}    ${INFO_LEVEL}

Success Getting Ticket For ICP With Android Agent(Microservice)
    [Documentation]    This API Will Be Called Through Microservice, So User Id Should Exist In Header And Agent Is Android
    ${providerId}    Generate Random String    15
    ${post_ticket_response}    POST Tickets Business
    ...    ${MICROSERVICE_SIDE}
    ...    ${TEST_CELLNUMBER_ICP}
    ...    ${TEST_AMOUNT}
    ...    ${TEST_CALLBACK_URL}
    ...    ${providerId}
    ...    ${UPG_TICKET_TYPE}
    ...    ${ANDROID_AGENT}
    ...    ${PLATFORM_VERSION_2024}
    ...    ${PLATFORM_BUSINESS_ID}
    Should Be Equal As Integers    ${post_ticket_response['status_code']}    200    Invalid response code
    Set Test Variable    ${SDK_Ticket}    ${post_ticket_response['body']['ticket']}
    ${redirctUrl}    Get Value From Json    ${post_ticket_response['body']}    $.redirectUrl
    Should Be Equal As Strings    ${post_ticket_response['body'].result.title}    ${SUCCESS_TITLE}
    Should Be Equal As Integers    ${post_ticket_response['body'].result.status}    ${SUCCESS_STATUS_CODE}
    Should Be Equal As Strings    ${post_ticket_response['body'].result.message}    ${SUCCESS_MESSAGE}
    Should Be Equal As Strings    ${post_ticket_response['body'].result.level}    ${INFO_LEVEL}

Success Getting Ticket For ICP With Android Agent(Gateway)
    [Documentation]    This API Will Be Called From Gateway, So Business Token Should Be Set And Agent Is Android
    ${providerId}    Generate Random String    15
    Login For Business    ${COMPANY_USERNAME}    ${COMPANY_PASSWORD}
    ${post_ticket_response}    POST Tickets Business
    ...    ${GENERAL_SIDE}
    ...    ${TEST_CELLNUMBER_ICP}
    ...    ${TEST_AMOUNT}
    ...    ${TEST_CALLBACK_URL}
    ...    ${providerId}
    ...    ${UPG_TICKET_TYPE}
    ...    ${ANDROID_AGENT}
    ...    ${PLATFORM_VERSION_2024}
    Should Be Equal As Integers    ${post_ticket_response['status_code']}    200    Invalid response code
    Set Test Variable    ${SDK_Ticket}    ${post_ticket_response['body']['ticket']}
    ${redirctUrl}    Get Value From Json    ${post_ticket_response['body']}    $.redirectUrl
    # Should Be Equal As Strings    ${post_ticket_response["body"].result.title}    ${SUCCESS_TITLE}
    Should Be Equal As Integers    ${post_ticket_response['body'].result.status}    ${SUCCESS_STATUS_CODE}
    Should Be Equal As Strings    ${post_ticket_response['body'].result.message}    ${SUCCESS_MESSAGE}
    Should Be Equal As Strings    ${post_ticket_response['body'].result.level}    ${INFO_LEVEL}

###############################    WEB ICP    ##############################################

Success Getting Ticket For ICP With Web Agent(Gateway)
    [Documentation]    This API Will Be Called From Gateway, So Business Token Should Be Set And Agent Is Web
    ${providerId}    Generate Random String    15
    Login For Business    ${PLATFORM_UESERNAME}    ${PLATFORM_PASSWORD}
    ${post_ticket_response}    POST Tickets Business
    ...    ${GENERAL_SIDE}
    ...    ${TEST_CELLNUMBER_ICP}
    ...    ${TEST_AMOUNT}
    ...    ${TEST_CALLBACK_URL}
    ...    ${providerId}
    ...    ${UPG_TICKET_TYPE}
    ...    ${WEB_AGENT}
    ...    ${PLATFORM_VERSION_2020}
    Should Be Equal As Integers    ${post_ticket_response['status_code']}    200    Invalid response code
    Set Test Variable    ${UPG_Ticket}    ${post_ticket_response['body']['ticket']}
    ${redirctUrl}    Get Value From Json    ${post_ticket_response['body']}    $.redirectUrl
    # Should Be Equal As Strings    ${post_ticket_response["body"].result.title}    ${SUCCESS_TITLE}
    Should Be Equal As Integers    ${post_ticket_response['body'].result.status}    ${SUCCESS_STATUS_CODE}
    Should Be Equal As Strings    ${post_ticket_response['body'].result.message}    ${SUCCESS_MESSAGE}
    Should Be Equal As Strings    ${post_ticket_response['body'].result.level}    ${INFO_LEVEL}

Success Getting Ticket For ICP With Web Agent On Platform Business(Microservice)
    [Documentation]    This API Will Be Called Through Microservice, So Platform User Id Should Exist In Header And Agent Is Web
    ${providerId}    Generate Random String    15
    ${post_ticket_response}    POST Tickets Business
    ...    ${MICROSERVICE_SIDE}
    ...    ${TEST_CELLNUMBER_ICP}
    ...    ${TEST_AMOUNT}
    ...    ${TEST_CALLBACK_URL}
    ...    ${providerId}
    ...    ${UPG_TICKET_TYPE}
    ...    ${WEB_AGENT}
    ...    ${PLATFORM_VERSION_2023}
    ...    ${PLATFORM_BUSINESS_ID}
    Should Be Equal As Integers    ${post_ticket_response['status_code']}    200    Invalid response code
    Set Test Variable    ${UPG_Ticket}    ${post_ticket_response['body']['ticket']}
    ${redirctUrl}    Get Value From Json    ${post_ticket_response['body']}    $.redirectUrl
    Should Be Equal As Strings    ${post_ticket_response['body'].result.title}    ${SUCCESS_TITLE}
    Should Be Equal As Integers    ${post_ticket_response['body'].result.status}    ${SUCCESS_STATUS_CODE}
    Should Be Equal As Strings    ${post_ticket_response['body'].result.message}    ${SUCCESS_MESSAGE}
    Should Be Equal As Strings    ${post_ticket_response['body'].result.level}    ${INFO_LEVEL}

Success Getting Ticket For ICP With Web Agent On Company Business(Gateway)
    [Documentation]    This API Will Be Called From Gateway, So Company Business Token Should Be Set And Agent Is Web
    ${providerId}    Generate Random String    15
    Login For Business    ${COMPANY_USERNAME}    ${COMPANY_PASSWORD}
    ${post_ticket_response}    POST Tickets Business
    ...    ${GENERAL_SIDE}
    ...    ${TEST_CELLNUMBER_ICP}
    ...    ${TEST_AMOUNT}
    ...    ${TEST_CALLBACK_URL}
    ...    ${providerId}
    ...    ${UPG_TICKET_TYPE}
    ...    ${WEB_AGENT}
    ...    ${PLATFORM_VERSION_2020}
    Should Be Equal As Integers    ${post_ticket_response['status_code']}    200    Invalid response code
    Set Test Variable    ${UPG_Ticket}    ${post_ticket_response['body']['ticket']}
    ${redirctUrl}    Get Value From Json    ${post_ticket_response['body']}    $.redirectUrl
    # Should Be Equal As Strings    ${post_ticket_response["body"].result.title}    ${SUCCESS_TITLE}
    Should Be Equal As Integers    ${post_ticket_response['body'].result.status}    ${SUCCESS_STATUS_CODE}
    Should Be Equal As Strings    ${post_ticket_response['body'].result.message}    ${SUCCESS_MESSAGE}
    Should Be Equal As Strings    ${post_ticket_response['body'].result.level}    ${INFO_LEVEL}

Success Getting Ticket For ICP With Web Agent On Company Business(Microservice)
    [Documentation]    This API Will Be Called Through Microservice, So Company User Id Should Exist In Header And Agent Is Web
    ${providerId}    Generate Random String    15
    ${post_ticket_response}    POST Tickets Business
    ...    ${MICROSERVICE_SIDE}
    ...    ${TEST_CELLNUMBER_ICP}
    ...    ${TEST_AMOUNT}
    ...    ${TEST_CALLBACK_URL}
    ...    ${providerId}
    ...    ${UPG_TICKET_TYPE}
    ...    ${WEB_AGENT}
    ...    ${PLATFORM_VERSION_2023}
    ...    ${COMPANY_USER_ID}
    Should Be Equal As Integers    ${post_ticket_response['status_code']}    200    Invalid response code
    Set Test Variable    ${UPG_Ticket}    ${post_ticket_response['body']['ticket']}
    ${redirctUrl}    Get Value From Json    ${post_ticket_response['body']}    $.redirectUrl
    Should Be Equal As Strings    ${post_ticket_response['body'].result.title}    ${SUCCESS_TITLE}
    Should Be Equal As Integers    ${post_ticket_response['body'].result.status}    ${SUCCESS_STATUS_CODE}
    Should Be Equal As Strings    ${post_ticket_response['body'].result.message}    ${SUCCESS_MESSAGE}
    Should Be Equal As Strings    ${post_ticket_response['body'].result.level}    ${INFO_LEVEL}

###############################    ANDROID CASHIN & PAY    ##############################################

Success Getting Ticket For CashIn & Pay With Android Agent On Platform Business(Gateway)
    [Documentation]    This API Will Be Called From Gateway, So Platform Business Token Should Be Set And Agent Is Android
    ${providerId}    Generate Random String    15
    Login For Business    ${PLATFORM_UESERNAME}    ${PLATFORM_PASSWORD}
    ${post_ticket_response}    POST Tickets Business
    ...    ${GENERAL_SIDE}
    ...    ${TEST_CELLNUMBER_CASHIN&PAY}
    ...    ${TEST_AMOUNT}
    ...    ${TEST_CALLBACK_URL}
    ...    ${providerId}
    ...    ${UPG_TICKET_TYPE}
    ...    ${ANDROID_AGENT}
    ...    ${PLATFORM_VERSION_2020}
    Should Be Equal As Integers    ${post_ticket_response['status_code']}    200    Invalid response code
    Set Test Variable    ${SDK_Ticket}    ${post_ticket_response['body']['ticket']}
    ${redirctUrl}    Get Value From Json    ${post_ticket_response['body']}    $.redirectUrl
    # Should Be Equal As Strings    ${post_ticket_response["body"].result.title}    ${SUCCESS_TITLE}
    Should Be Equal As Integers    ${post_ticket_response['body'].result.status}    ${SUCCESS_STATUS_CODE}
    Should Be Equal As Strings    ${post_ticket_response['body'].result.message}    ${SUCCESS_MESSAGE}
    Should Be Equal As Strings    ${post_ticket_response['body'].result.level}    ${INFO_LEVEL}

Success Getting Ticket For CashIn & Pay With Android Agent On Platform Business(Microservice)
    [Documentation]    This API Will Be Called Through Microservice, So Platform User Id Should Exist In Header And Agent Is Android
    ${providerId}    Generate Random String    15
    ${post_ticket_response}    POST Tickets Business
    ...    ${MICROSERVICE_SIDE}
    ...    ${TEST_CELLNUMBER_CASHIN&PAY}
    ...    ${TEST_AMOUNT}
    ...    ${TEST_CALLBACK_URL}
    ...    ${providerId}
    ...    ${UPG_TICKET_TYPE}
    ...    ${ANDROID_AGENT}
    ...    ${PLATFORM_VERSION_2023}
    ...    ${PLATFORM_BUSINESS_ID}
    Should Be Equal As Integers    ${post_ticket_response['status_code']}    200    Invalid response code
    Set Test Variable    ${SDK_Ticket}    ${post_ticket_response['body']['ticket']}
    ${redirctUrl}    Get Value From Json    ${post_ticket_response['body']}    $.redirectUrl
    Should Be Equal As Strings    ${post_ticket_response['body'].result.title}    ${SUCCESS_TITLE}
    Should Be Equal As Integers    ${post_ticket_response['body'].result.status}    ${SUCCESS_STATUS_CODE}
    Should Be Equal As Strings    ${post_ticket_response['body'].result.message}    ${SUCCESS_MESSAGE}
    Should Be Equal As Strings    ${post_ticket_response['body'].result.level}    ${INFO_LEVEL}

Success Getting Ticket For CashIn & Pay With Android Agent On Company Business(Gateway)
    [Documentation]    This API Will Be Called From Gateway, So Company Business Token Should Be Set And Agent Is Android
    ${providerId}    Generate Random String    15
    Login For Business    ${COMPANY_USERNAME}    ${COMPANY_PASSWORD}
    ${post_ticket_response}    POST Tickets Business
    ...    ${GENERAL_SIDE}
    ...    ${TEST_CELLNUMBER_CASHIN&PAY}
    ...    ${TEST_AMOUNT}
    ...    ${TEST_CALLBACK_URL}
    ...    ${providerId}
    ...    ${UPG_TICKET_TYPE}
    ...    ${ANDROID_AGENT}
    ...    ${PLATFORM_VERSION_2020}
    Should Be Equal As Integers    ${post_ticket_response['status_code']}    200    Invalid response code
    Set Test Variable    ${SDK_Ticket}    ${post_ticket_response['body']['ticket']}
    ${redirctUrl}    Get Value From Json    ${post_ticket_response['body']}    $.redirectUrl
    # Should Be Equal As Strings    ${post_ticket_response["body"].result.title}    ${SUCCESS_TITLE}
    Should Be Equal As Integers    ${post_ticket_response['body'].result.status}    ${SUCCESS_STATUS_CODE}
    Should Be Equal As Strings    ${post_ticket_response['body'].result.message}    ${SUCCESS_MESSAGE}
    Should Be Equal As Strings    ${post_ticket_response['body'].result.level}    ${INFO_LEVEL}

Success Getting Ticket For CashIn & Pay With Android Agent On Company Business(Microservice)
    [Documentation]    This API Will Be Called Through Microservice, So Company User Id Should Exist In Header And Agent Is Android
    ${providerId}    Generate Random String    15
    ${post_ticket_response}    POST Tickets Business
    ...    ${MICROSERVICE_SIDE}
    ...    ${TEST_CELLNUMBER_CASHIN&PAY}
    ...    ${TEST_AMOUNT}
    ...    ${TEST_CALLBACK_URL}
    ...    ${providerId}
    ...    ${UPG_TICKET_TYPE}
    ...    ${ANDROID_AGENT}
    ...    ${PLATFORM_VERSION_2023}
    ...    ${COMPANY_USER_ID}
    Should Be Equal As Integers    ${post_ticket_response['status_code']}    200    Invalid response code
    Set Test Variable    ${SDK_Ticket}    ${post_ticket_response['body']['ticket']}
    ${redirctUrl}    Get Value From Json    ${post_ticket_response['body']}    $.redirectUrl
    Should Be Equal As Strings    ${post_ticket_response['body'].result.title}    ${SUCCESS_TITLE}
    Should Be Equal As Integers    ${post_ticket_response['body'].result.status}    ${SUCCESS_STATUS_CODE}
    Should Be Equal As Strings    ${post_ticket_response['body'].result.message}    ${SUCCESS_MESSAGE}
    Should Be Equal As Strings    ${post_ticket_response['body'].result.level}    ${INFO_LEVEL}

###############################    WEB CASHIN & PAY    ##############################################

Success Getting Ticket For CashIn & Pay With Web Agent On Platform Business(Gateway)
    [Documentation]    This API Will Be Called From Gateway, So Platform Business Token Should Be Set And Agent Is Web
    ${providerId}    Generate Random String    15
    Login For Business    ${PLATFORM_UESERNAME}    ${PLATFORM_PASSWORD}
    ${post_ticket_response}    POST Tickets Business
    ...    ${GENERAL_SIDE}
    ...    ${TEST_CELLNUMBER_CASHIN&PAY}
    ...    ${TEST_AMOUNT}
    ...    ${TEST_CALLBACK_URL}
    ...    ${providerId}
    ...    ${UPG_TICKET_TYPE}
    ...    ${WEB_AGENT}
    ...    ${PLATFORM_VERSION_2020}
    Should Be Equal As Integers    ${post_ticket_response['status_code']}    200    Invalid response code
    Set Test Variable    ${UPG_Ticket}    ${post_ticket_response['body']['ticket']}
    ${redirctUrl}    Get Value From Json    ${post_ticket_response['body']}    $.redirectUrl
    # Should Be Equal As Strings    ${post_ticket_response["body"].result.title}    ${SUCCESS_TITLE}
    Should Be Equal As Integers    ${post_ticket_response['body'].result.status}    ${SUCCESS_STATUS_CODE}
    Should Be Equal As Strings    ${post_ticket_response['body'].result.message}    ${SUCCESS_MESSAGE}
    Should Be Equal As Strings    ${post_ticket_response['body'].result.level}    ${INFO_LEVEL}

Success Getting Ticket For CashIn & Pay With Web Agent On Platform Business(Microservice)
    [Documentation]    This API Will Be Called Through Microservice, So Platform User Id Should Exist In Header And Agent Is Web
    ${providerId}    Generate Random String    15
    ${post_ticket_response}    POST Tickets Business
    ...    ${MICROSERVICE_SIDE}
    ...    ${TEST_CELLNUMBER_CASHIN&PAY}
    ...    ${TEST_AMOUNT}
    ...    ${TEST_CALLBACK_URL}
    ...    ${providerId}
    ...    ${UPG_TICKET_TYPE}
    ...    ${WEB_AGENT}
    ...    ${PLATFORM_VERSION_2023}
    ...    ${PLATFORM_BUSINESS_ID}
    Should Be Equal As Integers    ${post_ticket_response['status_code']}    200    Invalid response code
    Set Test Variable    ${UPG_Ticket}    ${post_ticket_response['body']['ticket']}
    ${redirctUrl}    Get Value From Json    ${post_ticket_response['body']}    $.redirectUrl
    Should Be Equal As Strings    ${post_ticket_response['body'].result.title}    ${SUCCESS_TITLE}
    Should Be Equal As Integers    ${post_ticket_response['body'].result.status}    ${SUCCESS_STATUS_CODE}
    Should Be Equal As Strings    ${post_ticket_response['body'].result.message}    ${SUCCESS_MESSAGE}
    Should Be Equal As Strings    ${post_ticket_response['body'].result.level}    ${INFO_LEVEL}

Success Getting Ticket For CashIn & Pay With Web Agent On Company Business(Gateway)
    [Documentation]    This API Will Be Called From Gateway, So Company Business Token Should Be Set And Agent Is Web
    ${providerId}    Generate Random String    15
    Login For Business    ${COMPANY_USERNAME}    ${COMPANY_PASSWORD}
    ${post_ticket_response}    POST Tickets Business
    ...    ${GENERAL_SIDE}
    ...    ${TEST_CELLNUMBER_CASHIN&PAY}
    ...    ${TEST_AMOUNT}
    ...    ${TEST_CALLBACK_URL}
    ...    ${providerId}
    ...    ${UPG_TICKET_TYPE}
    ...    ${WEB_AGENT}
    ...    ${PLATFORM_VERSION_2020}
    Should Be Equal As Integers    ${post_ticket_response['status_code']}    200    Invalid response code
    Set Test Variable    ${UPG_Ticket}    ${post_ticket_response['body']['ticket']}
    ${redirctUrl}    Get Value From Json    ${post_ticket_response['body']}    $.redirectUrl
    # Should Be Equal As Strings    ${post_ticket_response["body"].result.title}    ${SUCCESS_TITLE}
    Should Be Equal As Integers    ${post_ticket_response['body'].result.status}    ${SUCCESS_STATUS_CODE}
    Should Be Equal As Strings    ${post_ticket_response['body'].result.message}    ${SUCCESS_MESSAGE}
    Should Be Equal As Strings    ${post_ticket_response['body'].result.level}    ${INFO_LEVEL}

Success Getting Ticket For CashIn & Pay With Web Agent On Company Business(Microservice)
    [Documentation]    This API Will Be Called Through Microservice, So Company User Id Should Exist In Header And Agent Is Web
    ${providerId}    Generate Random String    15
    ${post_ticket_response}    POST Tickets Business
    ...    ${MICROSERVICE_SIDE}
    ...    ${TEST_CELLNUMBER_CASHIN&PAY}
    ...    ${TEST_AMOUNT}
    ...    ${TEST_CALLBACK_URL}
    ...    ${providerId}
    ...    ${UPG_TICKET_TYPE}
    ...    ${WEB_AGENT}
    ...    ${PLATFORM_VERSION_2023}
    ...    ${COMPANY_USER_ID}
    Should Be Equal As Integers    ${post_ticket_response['status_code']}    200    Invalid response code
    Set Test Variable    ${UPG_Ticket}    ${post_ticket_response['body']['ticket']}
    ${redirctUrl}    Get Value From Json    ${post_ticket_response['body']}    $.redirectUrl
    Should Be Equal As Strings    ${post_ticket_response['body'].result.title}    ${SUCCESS_TITLE}
    Should Be Equal As Integers    ${post_ticket_response['body'].result.status}    ${SUCCESS_STATUS_CODE}
    Should Be Equal As Strings    ${post_ticket_response['body'].result.message}    ${SUCCESS_MESSAGE}
    Should Be Equal As Strings    ${post_ticket_response['body'].result.level}    ${INFO_LEVEL}

####################### GET TICKET INFO #####################################
################################# ANDROID PURCHASE ##########################################

Success Getting Ticket's Features With Android Agent(Gateway)
    [Documentation]    Getting Features Of Ticket In TGS On Android Agent Through Gateway Request
    ${get_ticket_info_response}    Get Tickets    ${GENERAL_SIDE}
    ...    ${SDK_Ticket}
    ...    ${PLATFORM_VERSION_2020}
    Should Be Equal As Integers    ${get_ticket_info_response['status_code']}    200    Invalid response code
    Should Be Equal As Strings    ${get_ticket_info_response['body'].result.title}    ${SUCCESS_TITLE}
    Should Be Equal As Integers    ${get_ticket_info_response['body'].result.status}    ${SUCCESS_STATUS_CODE}
    Should Be Equal As Strings    ${get_ticket_info_response['body'].result.message}    ${SUCCESS_MESSAGE}
    Should Be Equal As Strings    ${get_ticket_info_response['body'].result.level}    ${INFO_LEVEL}
    ${payment_method_length}    Get Length    ${get_ticket_info_response['body'].features}
    ${features_list}    Create List    ${get_ticket_info_response['body'].features[0].name}

    FOR    ${index}    IN RANGE    1    ${payment_method_length}
        Append To List    ${features_list}    ${get_ticket_info_response['body'].features[${index}].name}
        ${features_list_length}    Get Length    ${features_list}
    END
    Sort List    ${features_list}
    Should Be Equal    ${features_list}    ${DEBIT_UPG_FEATURES}

Success Getting Ticket's Features With Android Agent(Microservice)
    [Documentation]    Getting Features Of Ticket In TGS On Android Agent Through Microservice Request
    ${get_ticket_info_response}    Get Tickets    ${MICROSERVICE_SIDE}
    ...    ${SDK_Ticket}
    ...    ${PLATFORM_VERSION_2020}
    Should Be Equal As Integers    ${get_ticket_info_response['status_code']}    200    Invalid response code
    Should Be Equal As Strings    ${get_ticket_info_response['body'].result.title}    ${SUCCESS_TITLE}
    Should Be Equal As Integers    ${get_ticket_info_response['body'].result.status}    ${SUCCESS_STATUS_CODE}
    Should Be Equal As Strings    ${get_ticket_info_response['body'].result.message}    ${SUCCESS_MESSAGE}
    Should Be Equal As Strings    ${get_ticket_info_response['body'].result.level}    ${INFO_LEVEL}

    ${payment_method_length}    Get Length    ${get_ticket_info_response['body'].features}
    ${features_list}    Create List    ${get_ticket_info_response['body'].features[0].name}

    FOR    ${index}    IN RANGE    1    ${payment_method_length}
        Append To List    ${features_list}    ${get_ticket_info_response['body'].features[${index}].name}
        ${features_list_length}    Get Length    ${features_list}
    END
    Sort List    ${features_list}
    Should Be Equal    ${features_list}    ${DEBIT_UPG_FEATURES}

Call Get Feature API With Fake Ticket On Android Agent (Microservice)
    [Documentation]    Generate A Random String And Set As Ticket In "get-ticket-business" API
    ${fake_ticket}    Generate Random String    length=20
    ${get_ticket_info_response}    Get Tickets    ${MICROSERVICE_SIDE}
    ...    ${fake_ticket}
    ...    ${PLATFORM_VERSION_2020}
    Should Be Equal As Integers    ${get_ticket_info_response['status_code']}    422    Invalid response code
    Should Be Equal As Strings    ${get_ticket_info_response['body'].result.title}    ${INVALID_TICKET_TITLE}
    Should Be Equal As Integers    ${get_ticket_info_response['body'].result.status}    ${INVALID_TICKET_STATUS_CODE}
    Should Be Equal As Strings    ${get_ticket_info_response['body'].result.message}    ${INVALID_TICKET_MESSAGE}
    Should Be Equal As Strings    ${get_ticket_info_response['body'].result.level}    ${WARNING_LEVEL}

Call Get Feature API With Fake Ticket On Android Agent (Gateway)
    [Documentation]    Generate A Random String And Set As Ticket In "get-ticket-business" API
    ${fake_ticket}    Generate Random String    length=20
    ${get_ticket_info_response}    Get Tickets    ${GENERAL_SIDE}
    ...    ${fake_ticket}
    ...    ${PLATFORM_VERSION_2020}
    Should Be Equal As Integers    ${get_ticket_info_response['status_code']}    422    Invalid response code
    Should Be Equal As Strings    ${get_ticket_info_response['body'].result.title}    ${INVALID_TICKET_TITLE}
    Should Be Equal As Integers    ${get_ticket_info_response['body'].result.status}    ${INVALID_TICKET_STATUS_CODE}
    Should Be Equal As Strings    ${get_ticket_info_response['body'].result.message}    ${INVALID_TICKET_MESSAGE}
    Should Be Equal As Strings    ${get_ticket_info_response['body'].result.level}    ${WARNING_LEVEL}

################################# WEB PURCHASE ##########################################

Success Getting Ticket's Features With Web Agent(Gateway)
    [Documentation]    Getting Features Of Ticket In TGS On Web Agent Through Gateway Request
    ${get_ticket_info_response}    Get Tickets    ${GENERAL_SIDE}
    ...    ${UPG_Ticket}
    ...    ${PLATFORM_VERSION_2020}
    Should Be Equal As Integers    ${get_ticket_info_response['status_code']}    200    Invalid response code
    Should Be Equal As Strings    ${get_ticket_info_response['body'].result.title}    ${SUCCESS_TITLE}
    Should Be Equal As Integers    ${get_ticket_info_response['body'].result.status}    ${SUCCESS_STATUS_CODE}
    Should Be Equal As Strings    ${get_ticket_info_response['body'].result.message}    ${SUCCESS_MESSAGE}
    Should Be Equal As Strings    ${get_ticket_info_response['body'].result.level}    ${INFO_LEVEL}

    ${payment_method_length}    Get Length    ${get_ticket_info_response['body'].features}
    ${features_list}    Create List    ${get_ticket_info_response['body'].features[0].name}

    FOR    ${index}    IN RANGE    1    ${payment_method_length}
        Append To List    ${features_list}    ${get_ticket_info_response['body'].features[${index}].name}
        ${features_list_length}    Get Length    ${features_list}
    END
    Sort List    ${features_list}
    Should Be Equal    ${features_list}    ${WEB_DEBIT_UPG_FEATURES}

Success Getting Ticket's Features With Web Agent(Microservice)
    [Documentation]    Getting Features Of Ticket In TGS On Web Agent Through Microservice Request
    ${get_ticket_info_response}    Get Tickets    ${MICROSERVICE_SIDE}
    ...    ${UPG_Ticket}
    ...    ${PLATFORM_VERSION_2020}
    Should Be Equal As Integers    ${get_ticket_info_response['status_code']}    200    Invalid response code
    Should Be Equal As Strings    ${get_ticket_info_response['body'].result.title}    ${SUCCESS_TITLE}
    Should Be Equal As Integers    ${get_ticket_info_response['body'].result.status}    ${SUCCESS_STATUS_CODE}
    Should Be Equal As Strings    ${get_ticket_info_response['body'].result.message}    ${SUCCESS_MESSAGE}
    Should Be Equal As Strings    ${get_ticket_info_response['body'].result.level}    ${INFO_LEVEL}

    ${payment_method_length}    Get Length    ${get_ticket_info_response['body'].features}
    ${features_list}    Create List    ${get_ticket_info_response['body'].features[0].name}

    FOR    ${index}    IN RANGE    1    ${payment_method_length}
        Append To List    ${features_list}    ${get_ticket_info_response['body'].features[${index}].name}
        ${features_list_length}    Get Length    ${features_list}
    END
    Sort List    ${features_list}
    Should Be Equal    ${features_list}    ${WEB_DEBIT_UPG_FEATURES}

Call Get Feature API With Fake Ticket On Web Agent (Microservice)
    [Documentation]    Generate A Random String And Set As Ticket In "get-ticket-business" API
    ${fake_ticket}    Generate Random String    length=20
    ${get_ticket_info_response}    Get Tickets    ${MICROSERVICE_SIDE}
    ...    ${fake_ticket}
    ...    ${PLATFORM_VERSION_2020}
    Should Be Equal As Integers    ${get_ticket_info_response['status_code']}    422    Invalid response code
    Should Be Equal As Strings    ${get_ticket_info_response['body'].result.title}    ${INVALID_TICKET_TITLE}
    Should Be Equal As Integers    ${get_ticket_info_response['body'].result.status}    ${INVALID_TICKET_STATUS_CODE}
    Should Be Equal As Strings    ${get_ticket_info_response['body'].result.message}    ${INVALID_TICKET_MESSAGE}
    Should Be Equal As Strings    ${get_ticket_info_response['body'].result.level}    ${WARNING_LEVEL}

Call Get Feature API With Fake Ticket On Web Agent (Gateway)
    [Documentation]    Generate A Random String And Set As Ticket In "get-ticket-business" API
    ${fake_ticket}    Generate Random String    length=20
    ${get_ticket_info_response}    Get Tickets    ${GENERAL_SIDE}
    ...    ${fake_ticket}
    ...    ${PLATFORM_VERSION_2020}
    Should Be Equal As Integers    ${get_ticket_info_response['status_code']}    422    Invalid response code
    Should Be Equal As Strings    ${get_ticket_info_response['body'].result.title}    ${INVALID_TICKET_TITLE}
    Should Be Equal As Integers    ${get_ticket_info_response['body'].result.status}    ${INVALID_TICKET_STATUS_CODE}
    Should Be Equal As Strings    ${get_ticket_info_response['body'].result.message}    ${INVALID_TICKET_MESSAGE}
    Should Be Equal As Strings    ${get_ticket_info_response['body'].result.level}    ${WARNING_LEVEL}

######################################### WEB CASH IN & PAY ############################################

Success Getting Ticket's Features (Cashin & Pay) With Web Agent On Platform Business(Gateway)
    [Documentation]    Getting Features Of Ticket In TGS On Web Agent Through Microservice Request
    ${get_ticket_info_response}    Get Tickets    ${GENERAL_SIDE}
    ...    ${UPG_Ticket}
    ...    ${PLATFORM_VERSION_2020}
    Should Be Equal As Integers    ${get_ticket_info_response['status_code']}    200
    Should Be Equal As Strings    ${get_ticket_info_response['body'].result.title}    ${SUCCESS_TITLE}
    Should Be Equal As Integers    ${get_ticket_info_response['body'].result.status}    ${SUCCESS_STATUS_CODE}
    Should Be Equal As Strings    ${get_ticket_info_response['body'].result.message}    ${SUCCESS_MESSAGE}
    Should Be Equal As Strings    ${get_ticket_info_response['body'].result.level}    ${INFO_LEVEL}

    ${payment_method_length}    Get Length    ${get_ticket_info_response['body'].features}
    ${features_list}    Create List    ${get_ticket_info_response['body'].features[0].name}

    FOR    ${index}    IN RANGE    1    ${payment_method_length}
        Append To List    ${features_list}    ${get_ticket_info_response['body'].features[${index}].name}
        ${features_list_length}    Get Length    ${features_list}
    END
    Sort List    ${features_list}
    Should Be Equal    ${features_list}    ${WEB_IPG_CASHIN_PAY_FEATURES}

Success Getting Ticket's Features (Cashin & Pay) With Web Agent On Platform Business(Microservice)
    [Documentation]    Getting Features Of Ticket In TGS On Web Agent Through Microservice Request
    ${get_ticket_info_response}    Get Tickets    ${MICROSERVICE_SIDE}
    ...    ${UPG_Ticket}
    ...    ${PLATFORM_VERSION_2020}
    Should Be Equal As Integers    ${get_ticket_info_response['status_code']}    200
    Should Be Equal As Strings    ${get_ticket_info_response['body'].result.title}    ${SUCCESS_TITLE}
    Should Be Equal As Integers    ${get_ticket_info_response['body'].result.status}    ${SUCCESS_STATUS_CODE}
    Should Be Equal As Strings    ${get_ticket_info_response['body'].result.message}    ${SUCCESS_MESSAGE}
    Should Be Equal As Strings    ${get_ticket_info_response['body'].result.level}    ${INFO_LEVEL}

    ${payment_method_length}    Get Length    ${get_ticket_info_response['body'].features}
    ${features_list}    Create List    ${get_ticket_info_response['body'].features[0].name}

    FOR    ${index}    IN RANGE    1    ${payment_method_length}
        Append To List    ${features_list}    ${get_ticket_info_response['body'].features[${index}].name}
        ${features_list_length}    Get Length    ${features_list}
    END
    Sort List    ${features_list}
    Should Be Equal    ${features_list}    ${WEB_IPG_CASHIN_PAY_FEATURES}

Success Getting Ticket's Features (Cashin & Pay) With Web Agent On Company Business(Gateway)
    [Documentation]    Getting Features Of Ticket In TGS On Web Agent Through Microservice Request
    ${get_ticket_info_response}    Get Tickets    ${GENERAL_SIDE}
    ...    ${UPG_Ticket}
    ...    ${PLATFORM_VERSION_2020}
    Should Be Equal As Integers    ${get_ticket_info_response['status_code']}    200
    Should Be Equal As Strings    ${get_ticket_info_response['body'].result.title}    ${SUCCESS_TITLE}
    Should Be Equal As Integers    ${get_ticket_info_response['body'].result.status}    ${SUCCESS_STATUS_CODE}
    Should Be Equal As Strings    ${get_ticket_info_response['body'].result.message}    ${SUCCESS_MESSAGE}
    Should Be Equal As Strings    ${get_ticket_info_response['body'].result.level}    ${INFO_LEVEL}

    ${payment_method_length}    Get Length    ${get_ticket_info_response['body'].features}
    ${features_list}    Create List    ${get_ticket_info_response['body'].features[0].name}

    FOR    ${index}    IN RANGE    1    ${payment_method_length}
        Append To List    ${features_list}    ${get_ticket_info_response['body'].features[${index}].name}
        ${features_list_length}    Get Length    ${features_list}
    END
    Sort List    ${features_list}
    Should Be Equal    ${features_list}    ${WEB_IPG_CASHIN_PAY_FEATURES}

Success Getting Ticket's Features (Cashin & Pay) With Web Agent On Company Business(Microservice)
    [Documentation]    Getting Features Of Ticket In TGS On Web Agent Through Microservice Request
    Success Getting Ticket For CashIn & Pay With Web Agent On Company Business(Microservice)
    ${get_ticket_info_response}    Get Tickets    ${MICROSERVICE_SIDE}
    ...    ${UPG_Ticket}
    ...    ${PLATFORM_VERSION_2020}
    Should Be Equal As Integers    ${get_ticket_info_response['status_code']}    200
    Should Be Equal As Strings    ${get_ticket_info_response['body'].result.title}    ${SUCCESS_TITLE}
    Should Be Equal As Integers    ${get_ticket_info_response['body'].result.status}    ${SUCCESS_STATUS_CODE}
    Should Be Equal As Strings    ${get_ticket_info_response['body'].result.message}    ${SUCCESS_MESSAGE}
    Should Be Equal As Strings    ${get_ticket_info_response['body'].result.level}    ${INFO_LEVEL}

    ${payment_method_length}    Get Length    ${get_ticket_info_response['body'].features}
    ${features_list}    Create List    ${get_ticket_info_response['body'].features[0].name}

    FOR    ${index}    IN RANGE    1    ${payment_method_length}
        Append To List    ${features_list}    ${get_ticket_info_response['body'].features[${index}].name}
        ${features_list_length}    Get Length    ${features_list}
    END
    Sort List    ${features_list}
    Should Be Equal    ${features_list}    ${WEB_IPG_CASHIN_PAY_FEATURES}

################################## ANDROID CASH IN & PAY #############################################

Success Getting Ticket's Features (Cashin & Pay) With Android Agent On Platform Business(Gateway)
    [Documentation]    Getting Features Of Ticket In TGS On Android Agent Through Microservice Request
    ${get_ticket_info_response}    Get Tickets    ${GENERAL_SIDE}
    ...    ${SDK_Ticket}
    ...    ${PLATFORM_VERSION_2020}
    Should Be Equal As Integers    ${get_ticket_info_response['status_code']}    200
    Should Be Equal As Strings    ${get_ticket_info_response['body'].result.title}    ${SUCCESS_TITLE}
    Should Be Equal As Integers    ${get_ticket_info_response['body'].result.status}    ${SUCCESS_STATUS_CODE}
    Should Be Equal As Strings    ${get_ticket_info_response['body'].result.message}    ${SUCCESS_MESSAGE}
    Should Be Equal As Strings    ${get_ticket_info_response['body'].result.level}    ${INFO_LEVEL}

    ${payment_method_length}    Get Length    ${get_ticket_info_response['body'].features}
    ${features_list}    Create List    ${get_ticket_info_response['body'].features[0].name}

    FOR    ${index}    IN RANGE    1    ${payment_method_length}
        Append To List    ${features_list}    ${get_ticket_info_response['body'].features[${index}].name}
        ${features_list_length}    Get Length    ${features_list}
    END
    Sort List    ${features_list}
    Should Be Equal    ${features_list}    ${ANDROID_DPG_CASHINPAY__FEATURES}

Success Getting Ticket's Features (Cashin & Pay) With Android Agent On Platform Business(Microservice)
    [Documentation]    Getting Features Of Ticket In TGS On Android Agent Through Microservice Request
    ${get_ticket_info_response}    Get Tickets    ${MICROSERVICE_SIDE}
    ...    ${SDK_Ticket}
    ...    ${PLATFORM_VERSION_2020}
    Should Be Equal As Integers    ${get_ticket_info_response['status_code']}    200
    Should Be Equal As Strings    ${get_ticket_info_response['body'].result.title}    ${SUCCESS_TITLE}
    Should Be Equal As Integers    ${get_ticket_info_response['body'].result.status}    ${SUCCESS_STATUS_CODE}
    Should Be Equal As Strings    ${get_ticket_info_response['body'].result.message}    ${SUCCESS_MESSAGE}
    Should Be Equal As Strings    ${get_ticket_info_response['body'].result.level}    ${INFO_LEVEL}

    ${payment_method_length}    Get Length    ${get_ticket_info_response['body'].features}
    ${features_list}    Create List    ${get_ticket_info_response['body'].features[0].name}

    FOR    ${index}    IN RANGE    1    ${payment_method_length}
        Append To List    ${features_list}    ${get_ticket_info_response['body'].features[${index}].name}
        ${features_list_length}    Get Length    ${features_list}
    END
    Sort List    ${features_list}
    Should Be Equal    ${features_list}    ${ANDROID_DPG_CASHINPAY__FEATURES}

Success Getting Ticket's Features (Cashin & Pay) With Android Agent On Company Business(Gateway)
    [Documentation]    Getting Features Of Ticket In TGS On Android Agent Through Microservice Request
    ${get_ticket_info_response}    Get Tickets    ${GENERAL_SIDE}
    ...    ${SDK_Ticket}
    ...    ${PLATFORM_VERSION_2020}
    Should Be Equal As Integers    ${get_ticket_info_response['status_code']}    200
    Should Be Equal As Strings    ${get_ticket_info_response['body'].result.title}    ${SUCCESS_TITLE}
    Should Be Equal As Integers    ${get_ticket_info_response['body'].result.status}    ${SUCCESS_STATUS_CODE}
    Should Be Equal As Strings    ${get_ticket_info_response['body'].result.message}    ${SUCCESS_MESSAGE}
    Should Be Equal As Strings    ${get_ticket_info_response['body'].result.level}    ${INFO_LEVEL}

    ${payment_method_length}    Get Length    ${get_ticket_info_response['body'].features}
    ${features_list}    Create List    ${get_ticket_info_response['body'].features[0].name}

    FOR    ${index}    IN RANGE    1    ${payment_method_length}
        Append To List    ${features_list}    ${get_ticket_info_response['body'].features[${index}].name}
        ${features_list_length}    Get Length    ${features_list}
    END
    Sort List    ${features_list}
    Should Be Equal    ${features_list}    ${ANDROID_DPG_CASHINPAY__FEATURES}

Success Getting Ticket's Features (Cashin & Pay) With Android Agent On Company Business(Microservice)
    [Documentation]    Getting Features Of Ticket In TGS On Android Agent Through Microservice Request
    ${get_ticket_info_response}    Get Tickets    ${MICROSERVICE_SIDE}
    ...    ${SDK_Ticket}
    ...    ${PLATFORM_VERSION_2020}
    Should Be Equal As Integers    ${get_ticket_info_response['status_code']}    200
    Should Be Equal As Strings    ${get_ticket_info_response['body'].result.title}    ${SUCCESS_TITLE}
    Should Be Equal As Integers    ${get_ticket_info_response['body'].result.status}    ${SUCCESS_STATUS_CODE}
    Should Be Equal As Strings    ${get_ticket_info_response['body'].result.message}    ${SUCCESS_MESSAGE}
    Should Be Equal As Strings    ${get_ticket_info_response['body'].result.level}    ${INFO_LEVEL}

    ${payment_method_length}    Get Length    ${get_ticket_info_response['body'].features}
    ${features_list}    Create List    ${get_ticket_info_response['body'].features[0].name}

    FOR    ${index}    IN RANGE    1    ${payment_method_length}
        Append To List    ${features_list}    ${get_ticket_info_response['body'].features[${index}].name}
        ${features_list_length}    Get Length    ${features_list}
    END
    Sort List    ${features_list}
    Should Be Equal    ${features_list}    ${ANDROID_DPG_CASHINPAY__FEATURES}

#################################### WEB ICP ############################################

Success Getting Ticket's Features (ICP) With Web Agent On Platform Business(Gateway)
    [Documentation]    Getting Features Of Ticket In TGS On Web Agent Through Microservice Request
    Success Getting Ticket For ICP With Web Agent On Platform Business(Gateway)
    ${get_ticket_info_response}    Get Tickets    ${GENERAL_SIDE}
    ...    ${UPG_Ticket}
    ...    ${PLATFORM_VERSION_2020}
    Should Be Equal As Integers    ${get_ticket_info_response['status_code']}    200
    Should Be Equal As Strings    ${get_ticket_info_response['body'].result.title}    ${SUCCESS_TITLE}
    Should Be Equal As Integers    ${get_ticket_info_response['body'].result.status}    ${SUCCESS_STATUS_CODE}
    Should Be Equal As Strings    ${get_ticket_info_response['body'].result.message}    ${SUCCESS_MESSAGE}
    Should Be Equal As Strings    ${get_ticket_info_response['body'].result.level}    ${INFO_LEVEL}

    ${payment_method_length}    Get Length    ${get_ticket_info_response['body'].features}
    ${features_list}    Create List    ${get_ticket_info_response['body'].features[0].name}

    FOR    ${index}    IN RANGE    1    ${payment_method_length}
        Append To List    ${features_list}    ${get_ticket_info_response['body'].features[${index}].name}
        ${features_list_length}    Get Length    ${features_list}
    END
    Sort List    ${features_list}
    Should Be Equal    ${features_list}    ${WEB_ICP_FEATURES}

Success Getting Ticket's Features (ICP) With Web Agent On Platform Business(Microservice)
    [Documentation]    Getting Features Of Ticket In TGS On Web Agent Through Microservice Request
    Success Getting Ticket For ICP With Web Agent On Platform Business(Microservice)
    ${get_ticket_info_response}    Get Tickets    ${MICROSERVICE_SIDE}
    ...    ${UPG_Ticket}
    ...    ${PLATFORM_VERSION_2020}
    Should Be Equal As Integers    ${get_ticket_info_response['status_code']}    200
    Should Be Equal As Strings    ${get_ticket_info_response['body'].result.title}    ${SUCCESS_TITLE}
    Should Be Equal As Integers    ${get_ticket_info_response['body'].result.status}    ${SUCCESS_STATUS_CODE}
    Should Be Equal As Strings    ${get_ticket_info_response['body'].result.message}    ${SUCCESS_MESSAGE}
    Should Be Equal As Strings    ${get_ticket_info_response['body'].result.level}    ${INFO_LEVEL}

    ${payment_method_length}    Get Length    ${get_ticket_info_response['body'].features}
    ${features_list}    Create List    ${get_ticket_info_response['body'].features[0].name}

    FOR    ${index}    IN RANGE    1    ${payment_method_length}
        Append To List    ${features_list}    ${get_ticket_info_response['body'].features[${index}].name}
        ${features_list_length}    Get Length    ${features_list}
    END
    Sort List    ${features_list}
    Should Be Equal    ${features_list}    ${WEB_ICP_FEATURES}

Success Getting Ticket's Features (ICP) With Web Agent On Company Business(Gateway)
    [Documentation]    Getting Features Of Ticket In TGS On Web Agent Through Microservice Request
    Success Getting Ticket For ICP With Web Agent On Company Business(Gateway)
    ${get_ticket_info_response}    Get Tickets    ${GENERAL_SIDE}
    ...    ${UPG_Ticket}
    ...    ${PLATFORM_VERSION_2020}
    Should Be Equal As Integers    ${get_ticket_info_response['status_code']}    200
    Should Be Equal As Strings    ${get_ticket_info_response['body'].result.title}    ${SUCCESS_TITLE}
    Should Be Equal As Integers    ${get_ticket_info_response['body'].result.status}    ${SUCCESS_STATUS_CODE}
    Should Be Equal As Strings    ${get_ticket_info_response['body'].result.message}    ${SUCCESS_MESSAGE}
    Should Be Equal As Strings    ${get_ticket_info_response['body'].result.level}    ${INFO_LEVEL}

    ${payment_method_length}    Get Length    ${get_ticket_info_response['body'].features}
    ${features_list}    Create List    ${get_ticket_info_response['body'].features[0].name}

    FOR    ${index}    IN RANGE    1    ${payment_method_length}
        Append To List    ${features_list}    ${get_ticket_info_response['body'].features[${index}].name}
        ${features_list_length}    Get Length    ${features_list}
    END
    Sort List    ${features_list}
    Should Be Equal    ${features_list}    ${WEB_ICP_FEATURES}

Success Getting Ticket's Features (ICP) With Web Agent On Company Business(Microservice)
    [Documentation]    Getting Features Of Ticket In TGS On Web Agent Through Microservice Request
    Success Getting Ticket For ICP With Web Agent On Company Business(Microservice)
    ${get_ticket_info_response}    Get Tickets    ${MICROSERVICE_SIDE}
    ...    ${UPG_Ticket}
    ...    ${PLATFORM_VERSION_2020}
    Should Be Equal As Integers    ${get_ticket_info_response['status_code']}    200
    Should Be Equal As Strings    ${get_ticket_info_response['body'].result.title}    ${SUCCESS_TITLE}
    Should Be Equal As Integers    ${get_ticket_info_response['body'].result.status}    ${SUCCESS_STATUS_CODE}
    Should Be Equal As Strings    ${get_ticket_info_response['body'].result.message}    ${SUCCESS_MESSAGE}
    Should Be Equal As Strings    ${get_ticket_info_response['body'].result.level}    ${INFO_LEVEL}

    ${payment_method_length}    Get Length    ${get_ticket_info_response['body'].features}
    ${features_list}    Create List    ${get_ticket_info_response['body'].features[0].name}

    FOR    ${index}    IN RANGE    1    ${payment_method_length}
        Append To List    ${features_list}    ${get_ticket_info_response['body'].features[${index}].name}
        ${features_list_length}    Get Length    ${features_list}
    END
    Sort List    ${features_list}
    Should Be Equal    ${features_list}    ${WEB_ICP_FEATURES}

#################################### ANDROID ICP ############################################

Success Getting Ticket's Features (ICP) With Android Agent On Platform Business(Gateway)
    [Documentation]    Getting Features Of Ticket In TGS On Android Agent Through Microservice Request
    Success Getting Ticket For ICP With ANDROID Agent On Platform Business(Gateway)
    ${get_ticket_info_response}    Get Tickets    ${GENERAL_SIDE}
    ...    ${SDK_Ticket}
    ...    ${PLATFORM_VERSION_2020}
    Should Be Equal As Integers    ${get_ticket_info_response['status_code']}    200
    Should Be Equal As Strings    ${get_ticket_info_response['body'].result.title}    ${SUCCESS_TITLE}
    Should Be Equal As Integers    ${get_ticket_info_response['body'].result.status}    ${SUCCESS_STATUS_CODE}
    Should Be Equal As Strings    ${get_ticket_info_response['body'].result.message}    ${SUCCESS_MESSAGE}
    Should Be Equal As Strings    ${get_ticket_info_response['body'].result.level}    ${INFO_LEVEL}

    ${payment_method_length}    Get Length    ${get_ticket_info_response['body'].features}
    ${features_list}    Create List    ${get_ticket_info_response['body'].features[0].name}

    FOR    ${index}    IN RANGE    1    ${payment_method_length}
        Append To List    ${features_list}    ${get_ticket_info_response['body'].features[${index}].name}
        ${features_list_length}    Get Length    ${features_list}
    END
    Sort List    ${features_list}
    Should Be Equal    ${features_list}    ${ANDROID_ICP_FEATURES}

Success Getting Ticket's Features (ICP) With Android Agent On Platform Business(Microservice)
    [Documentation]    Getting Features Of Ticket In TGS On Android Agent Through Microservice Request
    Success Getting Ticket For ICP With ANDROID Agent On Platform Business(Microservice)
    ${get_ticket_info_response}    Get Tickets    ${MICROSERVICE_SIDE}
    ...    ${SDK_Ticket}
    ...    ${PLATFORM_VERSION_2020}
    Should Be Equal As Integers    ${get_ticket_info_response['status_code']}    200
    Should Be Equal As Strings    ${get_ticket_info_response['body'].result.title}    ${SUCCESS_TITLE}
    Should Be Equal As Integers    ${get_ticket_info_response['body'].result.status}    ${SUCCESS_STATUS_CODE}
    Should Be Equal As Strings    ${get_ticket_info_response['body'].result.message}    ${SUCCESS_MESSAGE}
    Should Be Equal As Strings    ${get_ticket_info_response['body'].result.level}    ${INFO_LEVEL}

    ${payment_method_length}    Get Length    ${get_ticket_info_response['body'].features}
    ${features_list}    Create List    ${get_ticket_info_response['body'].features[0].name}

    FOR    ${index}    IN RANGE    1    ${payment_method_length}
        Append To List    ${features_list}    ${get_ticket_info_response['body'].features[${index}].name}
        ${features_list_length}    Get Length    ${features_list}
    END
    Sort List    ${features_list}
    Should Be Equal    ${features_list}    ${ANDROID_ICP_FEATURES}

Success Getting Ticket's Features (ICP) With Android Agent On Company Business(Gateway)
    [Documentation]    Getting Features Of Ticket In TGS On Android Agent Through Microservice Request
    Success Getting Ticket For ICP With ANDROID Agent On Company Business(Gateway)
    ${get_ticket_info_response}    Get Tickets    ${GENERAL_SIDE}
    ...    ${SDK_Ticket}
    ...    ${PLATFORM_VERSION_2020}
    Should Be Equal As Integers    ${get_ticket_info_response['status_code']}    200
    Should Be Equal As Strings    ${get_ticket_info_response['body'].result.title}    ${SUCCESS_TITLE}
    Should Be Equal As Integers    ${get_ticket_info_response['body'].result.status}    ${SUCCESS_STATUS_CODE}
    Should Be Equal As Strings    ${get_ticket_info_response['body'].result.message}    ${SUCCESS_MESSAGE}
    Should Be Equal As Strings    ${get_ticket_info_response['body'].result.level}    ${INFO_LEVEL}

    ${payment_method_length}    Get Length    ${get_ticket_info_response['body'].features}
    ${features_list}    Create List    ${get_ticket_info_response['body'].features[0].name}

    FOR    ${index}    IN RANGE    1    ${payment_method_length}
        Append To List    ${features_list}    ${get_ticket_info_response['body'].features[${index}].name}
        ${features_list_length}    Get Length    ${features_list}
    END
    Sort List    ${features_list}
    Should Be Equal    ${features_list}    ${ANDROID_ICP_FEATURES}

Success Getting Ticket's Features (ICP) With Android Agent On Company Business(Microservice)
    [Documentation]    Getting Features Of Ticket In TGS On Android Agent Through Microservice Request
    Success Getting Ticket For ICP With ANDROID Agent On Company Business(Microservice)
    ${get_ticket_info_response}    Get Tickets    ${MICROSERVICE_SIDE}
    ...    ${SDK_Ticket}
    ...    ${PLATFORM_VERSION_2020}
    Should Be Equal As Integers    ${get_ticket_info_response['status_code']}    200
    Should Be Equal As Strings    ${get_ticket_info_response['body'].result.title}    ${SUCCESS_TITLE}
    Should Be Equal As Integers    ${get_ticket_info_response['body'].result.status}    ${SUCCESS_STATUS_CODE}
    Should Be Equal As Strings    ${get_ticket_info_response['body'].result.message}    ${SUCCESS_MESSAGE}
    Should Be Equal As Strings    ${get_ticket_info_response['body'].result.level}    ${INFO_LEVEL}

    ${payment_method_length}    Get Length    ${get_ticket_info_response['body'].features}
    ${features_list}    Create List    ${get_ticket_info_response['body'].features[0].name}

    FOR    ${index}    IN RANGE    1    ${payment_method_length}
        Append To List    ${features_list}    ${get_ticket_info_response['body'].features[${index}].name}
        ${features_list_length}    Get Length    ${features_list}
    END
    Sort List    ${features_list}
    Should Be Equal    ${features_list}    ${ANDROID_ICP_FEATURES}

########################### POST TICKETS FEATURES SELECT ################################

Get Successful Select Feature
    [Documentation]    This Keyword Is A Rapper To Call "Post Tickets Features Select" API
    [Arguments]
    ...    ${api_call_side}
    ...    ${ticket}
    ...    ${featureName}
    ...    ${Agent}
    ...    ${PLATFORM_VERSION}

    ${response}    Post Tickets Features Select
    ...    ${api_call_side}
    ...    ${ticket}
    ...    ${featureName}
    ...    ${Agent}
    ...    ${PLATFORM_VERSION}
    Should Be Equal As Integers    ${response['status_code']}    200
    RETURN    ${response}

################################### ANDROID WALLET SELECTION ##################################

Success Select Wallet On Android Agent(Gateway)
    [Documentation]    This API Gets Ticket And Wallet Feature Name And Wallet Feature Should Be Selected
    ...    And A Record Should Exist In Purchase DB After Selection
    ${select_feature_response}    Post Tickets Features Select
    ...    ${GENERAL_SIDE}
    ...    ${SDK_Ticket}
    ...    ${WALLET_FEATURE_NAME}
    ...    ${ANDROID_AGENT}
    ...    ${PLATFORM_VERSION_2020}
    Should Be Equal As Integers    ${select_feature_response['status_code']}    200    msg=Invalid response code
    Should Be Equal As Strings    ${select_feature_response["body"].result.title}    ${SUCCESS_TITLE}
    Should Be Equal As Integers    ${select_feature_response['body'].result.status}    ${SUCCESS_STATUS_CODE}
    Should Be Equal As Strings    ${select_feature_response['body'].result.message}    ${SUCCESS_MESSAGE}
    Should Be Equal As Strings    ${select_feature_response['body'].result.level}    ${INFO_LEVEL}

    Dictionary Should Contain Key
    ...    ${select_feature_response['body']}
    ...    amount
    Dictionary Should Contain Key
    ...    ${select_feature_response['body']}
    ...    walletBalance
    Dictionary Should Contain Key
    ...    ${select_feature_response['body']}
    ...    redirectUrl
    Dictionary Should Contain Key
    ...    ${select_feature_response['body']}
    ...    payUrl
    Should Be Equal As Strings    ${select_feature_response['body']['payUrl']}    ${WALLET_PAY_URL}
    ${filter_query}    Create Dictionary    ticket=${SDK_Ticket}
    ${data_response}    Mongo Db Find
    ...    ${PURCHASE_MNG_DB_MANE}
    ...    ${PURCHASE_MNG_PURCHASE_COLLECTION}
    ...    ${filter_query}
    Should Be Equal As Integers    ${data_response['status_code']}    0
    Should Not Be Empty    ${data_response['body']}
    Should Be Equal As Strings    ${data_response['body'][0]['payGateway']}    WALLET
    Should Be Equal As Strings    ${data_response['body'][0]['status']}    INITIATED
    Should Be Equal As Strings    ${data_response['body'][0]['owner']['agent']}    ${ANDROID_AGENT}
    Set Test Variable    ${purchase_trackingCode}    ${data_response['body'][0]['trackingCode']}

Success Select Wallet On Android Agent(Microservice)
    [Documentation]    This API Gets Ticket And Wallet Feature Name And Wallet Feature Should Be Selected
    ...    And A Record Should Exist In Purchase DB After Selection
    ${select_feature_response}    Post Tickets Features Select
    ...    ${MICROSERVICE_SIDE}
    ...    ${SDK_Ticket}
    ...    ${WALLET_FEATURE_NAME}
    ...    ${ANDROID_AGENT}
    ...    ${PLATFORM_VERSION_2020}
    Should Be Equal As Integers    ${select_feature_response['status_code']}    200    msg=Invalid response code
    Should Be Equal As Strings    ${select_feature_response["body"].result.title}    ${SUCCESS_TITLE}
    Should Be Equal As Integers    ${select_feature_response['body'].result.status}    ${SUCCESS_STATUS_CODE}
    Should Be Equal As Strings    ${select_feature_response['body'].result.message}    ${SUCCESS_MESSAGE}
    Should Be Equal As Strings    ${select_feature_response['body'].result.level}    ${INFO_LEVEL}

    Dictionary Should Contain Key
    ...    ${select_feature_response['body']}
    ...    amount
    Dictionary Should Contain Key
    ...    ${select_feature_response['body']}
    ...    walletBalance
    Dictionary Should Contain Key
    ...    ${select_feature_response['body']}
    ...    redirectUrl
    Dictionary Should Contain Key
    ...    ${select_feature_response['body']}
    ...    payUrl
    Should Be Equal As Strings    ${select_feature_response['body']['payUrl']}    ${WALLET_PAY_URL}
    ${filter_query}    Create Dictionary    ticket=${SDK_Ticket}
    ${data_response}    Mongo Db Find
    ...    ${PURCHASE_MNG_DB_MANE}
    ...    ${PURCHASE_MNG_PURCHASE_COLLECTION}
    ...    ${filter_query}
    Should Be Equal As Integers    ${data_response['status_code']}    0
    Should Not Be Empty    ${data_response['body']}
    Should Be Equal As Strings    ${data_response['body'][0]['payGateway']}    WALLET
    Should Be Equal As Strings    ${data_response['body'][0]['status']}    INITIATED
    Should Be Equal As Strings    ${data_response['body'][0]['owner']['agent']}    ${ANDROID_AGENT}
    Set Test Variable    ${purchase_trackingCode}    ${data_response['body'][0]['trackingCode']}

############################## WEB WALLET SELECTION #######################################

Success Select Wallet On Web Agent(Gateway)
    [Documentation]    This API Gets Ticket And Wallet Feature Name And Wallet Feature Should Be Selected
    ...    And A Record Should Exist In Purchase DB After Selection
    ${select_feature_response}    Post Tickets Features Select
    ...    ${GENERAL_SIDE}
    ...    ${UPG_Ticket}
    ...    ${WALLET_FEATURE_NAME}
    ...    ${WEB_AGENT}
    ...    ${PLATFORM_VERSION_2020}
    Should Be Equal As Integers    ${select_feature_response['status_code']}    200    msg=Invalid response code
    Should Be Equal As Strings    ${select_feature_response["body"].result.title}    ${SUCCESS_TITLE}
    Should Be Equal As Integers    ${select_feature_response['body'].result.status}    ${SUCCESS_STATUS_CODE}
    Should Be Equal As Strings    ${select_feature_response['body'].result.message}    ${SUCCESS_MESSAGE}
    Should Be Equal As Strings    ${select_feature_response['body'].result.level}    ${INFO_LEVEL}

    Dictionary Should Contain Key
    ...    ${select_feature_response['body']}
    ...    amount
    Dictionary Should Contain Key
    ...    ${select_feature_response['body']}
    ...    walletBalance
    Dictionary Should Contain Key
    ...    ${select_feature_response['body']}
    ...    redirectUrl
    Dictionary Should Contain Key
    ...    ${select_feature_response['body']}
    ...    payUrl
    Should Be Equal As Strings    ${select_feature_response['body']['payUrl']}    ${WALLET_PAY_URL}
    ${filter_query}    Create Dictionary    ticket=${UPG_Ticket}
    ${data_response}    Mongo Db Find
    ...    ${PURCHASE_MNG_DB_MANE}
    ...    ${PURCHASE_MNG_PURCHASE_COLLECTION}
    ...    ${filter_query}
    Should Be Equal As Integers    ${data_response['status_code']}    0
    Should Not Be Empty    ${data_response['body']}
    Should Be Equal As Strings    ${data_response['body'][0]['payGateway']}    WALLET
    Should Be Equal As Strings    ${data_response['body'][0]['status']}    INITIATED
    Should Be Equal As Strings    ${data_response['body'][0]['owner']['agent']}    ${WEB_AGENT}
    Set Test Variable    ${wallet_purchase_trackingCode}    ${data_response['body'][0]['trackingCode']}

Success Select Wallet On Web Agent(Microservice)
    [Documentation]    This API Gets Ticket And Wallet Feature Name And Wallet Feature Should Be Selected
    ...    And A Record Should Exist In Purchase DB After Selection
    Success Getting Ticket's Features With Web Agent On Platform Business(Microservice)
    ${select_feature_response}    Post Tickets Features Select
    ...    ${MICROSERVICE_SIDE}
    ...    ${UPG_Ticket}
    ...    ${WALLET_FEATURE_NAME}
    ...    ${WEB_AGENT}
    ...    ${PLATFORM_VERSION_2020}
    Should Be Equal As Integers    ${select_feature_response['status_code']}    200    msg=Invalid response code
    Should Be Equal As Strings    ${select_feature_response["body"].result.title}    ${SUCCESS_TITLE}
    Should Be Equal As Integers    ${select_feature_response['body'].result.status}    ${SUCCESS_STATUS_CODE}
    Should Be Equal As Strings    ${select_feature_response['body'].result.message}    ${SUCCESS_MESSAGE}
    Should Be Equal As Strings    ${select_feature_response['body'].result.level}    ${INFO_LEVEL}

    Dictionary Should Contain Key
    ...    ${select_feature_response['body']}
    ...    amount
    Dictionary Should Contain Key
    ...    ${select_feature_response['body']}
    ...    walletBalance
    Dictionary Should Contain Key
    ...    ${select_feature_response['body']}
    ...    redirectUrl
    Dictionary Should Contain Key
    ...    ${select_feature_response['body']}
    ...    payUrl
    Should Be Equal As Strings    ${select_feature_response['body']['payUrl']}    ${WALLET_PAY_URL}
    ${filter_query}    Create Dictionary    ticket=${UPG_Ticket}
    ${data_response}    Mongo Db Find
    ...    ${PURCHASE_MNG_DB_MANE}
    ...    ${PURCHASE_MNG_PURCHASE_COLLECTION}
    ...    ${filter_query}
    Should Be Equal As Integers    ${data_response['status_code']}    0
    Should Not Be Empty    ${data_response['body']}
    Should Be Equal As Strings    ${data_response['body'][0]['payGateway']}    WALLET
    Should Be Equal As Strings    ${data_response['body'][0]['status']}    INITIATED
    Should Be Equal As Strings    ${data_response['body'][0]['owner']['agent']}    ${WEB_AGENT}
    Set Test Variable    ${purchase_trackingCode}    ${data_response['body'][0]['trackingCode']}

################################## ANDROID IPG SELECTION #####################################

Success Select IPG On Android Agent For Platform (Gateway)
    [Documentation]    This API Gets Ticket And IPG Feature Name And IPG Feature Should Be Selected
    ...    And A Record Should Exist In Purchase DB After Selection
    Success Getting Ticket's Features With Android Agent On Platform Business(Gateway)

    ${select_feature_response}    Wait Until Keyword Succeeds    1 minute    5 s    Get Successful Select Feature
    ...    ${GENERAL_SIDE}
    ...    ${SDK_Ticket}
    ...    ${IPG_FEATURE_NAME}
    ...    ${ANDROID_AGENT}
    ...    ${PLATFORM_VERSION_2023}
    Should Be Equal As Integers    ${select_feature_response['status_code']}    200    msg=Invalid response code
    Should Be Equal As Strings    ${select_feature_response["body"].result.title}    ${SUCCESS_TITLE}
    Should Be Equal As Integers    ${select_feature_response['body'].result.status}    ${SUCCESS_STATUS_CODE}
    Should Be Equal As Strings    ${select_feature_response['body'].result.message}    ${SUCCESS_MESSAGE}
    Should Be Equal As Strings    ${select_feature_response['body'].result.level}    ${INFO_LEVEL}

    Dictionary Should Contain Key
    ...    ${select_feature_response['body']}
    ...    amount
    Dictionary Should Contain Key
    ...    ${select_feature_response['body']}
    ...    pspCode
    Dictionary Should Contain Key
    ...    ${select_feature_response['body']}
    ...    redirectUrl
    Dictionary Should Contain Key
    ...    ${select_feature_response['body']}
    ...    payUrl
    Should Be Equal As Strings    ${select_feature_response['body']['payUrl']}    ${IPG_PAY_URL}/${SDK_Ticket}
    ${filter_query}    Create Dictionary    ticket=${SDK_Ticket}
    ${data_response}    Mongo Db Find
    ...    ${PURCHASE_MNG_DB_MANE}
    ...    ${PURCHASE_MNG_PURCHASE_COLLECTION}
    ...    ${filter_query}
    Should Be Equal As Integers    ${data_response['status_code']}    0
    Should Not Be Empty    ${data_response['body']}
    Should Be Equal As Strings    ${data_response['body'][0]['payGateway']}    IPG
    Should Be Equal As Strings    ${data_response['body'][0]['status']}    INITIATED
    Should Be Equal As Strings    ${data_response['body'][0]['owner']['agent']}    ${ANDROID_AGENT}
    Set Test Variable    ${purchase_trackingCode}    ${data_response['body'][0]['trackingCode']}

Success Select IPG On Android Agent For Platform (Microservice)
    [Documentation]    This API Gets Ticket And IPG Feature Name And IPG Feature Should Be Selected
    ...    And A Record Should Exist In Purchase DB After Selection
    Success Getting Ticket's Features With Android Agent On Platform Business(Microservice)
    ${select_feature_response}    Wait Until Keyword Succeeds    1 minute    5 s    Get Successful Select Feature
    ...    ${MICROSERVICE_SIDE}
    ...    ${SDK_Ticket}
    ...    ${IPG_FEATURE_NAME}
    ...    ${ANDROID_AGENT}
    ...    ${PLATFORM_VERSION_2023}
    Should Be Equal As Integers    ${select_feature_response['status_code']}    200
    Should Be Equal As Strings    ${select_feature_response["body"].result.title}    ${SUCCESS_TITLE}
    Should Be Equal As Integers    ${select_feature_response['body'].result.status}    ${SUCCESS_STATUS_CODE}
    Should Be Equal As Strings    ${select_feature_response['body'].result.message}    ${SUCCESS_MESSAGE}
    Should Be Equal As Strings    ${select_feature_response['body'].result.level}    ${INFO_LEVEL}

    Dictionary Should Contain Key
    ...    ${select_feature_response['body']}
    ...    amount
    Dictionary Should Contain Key
    ...    ${select_feature_response['body']}
    ...    pspCode
    Dictionary Should Contain Key
    ...    ${select_feature_response['body']}
    ...    redirectUrl
    Dictionary Should Contain Key
    ...    ${select_feature_response['body']}
    ...    payUrl
    Should Be Equal As Strings    ${select_feature_response['body']['payUrl']}    ${IPG_PAY_URL}/${SDK_Ticket}
    ${filter_query}    Create Dictionary    ticket=${SDK_Ticket}
    ${data_response}    Mongo Db Find
    ...    ${PURCHASE_MNG_DB_MANE}
    ...    ${PURCHASE_MNG_PURCHASE_COLLECTION}
    ...    ${filter_query}
    Should Be Equal As Integers    ${data_response['status_code']}    0
    Should Not Be Empty    ${data_response['body']}
    Should Be Equal As Strings    ${data_response['body'][0]['payGateway']}    IPG
    Should Be Equal As Strings    ${data_response['body'][0]['status']}    INITIATED
    Should Be Equal As Strings    ${data_response['body'][0]['owner']['agent']}    ${ANDROID_AGENT}
    Set Test Variable    ${purchase_trackingCode}    ${data_response['body'][0]['trackingCode']}

Success Select IPG On Android Agent For Company (Gateway)
    [Documentation]    This API Gets Ticket And IPG Feature Name And IPG Feature Should Be Selected
    ...    And A Record Should Exist In Purchase DB After Selection
    Success Getting Ticket's Features With Android Agent On Company Business(Gateway)
    ${select_feature_response}    Wait Until Keyword Succeeds    1 minute    5 s    Get Successful Select Feature
    ...    ${GENERAL_SIDE}
    ...    ${SDK_Ticket}
    ...    ${IPG_FEATURE_NAME}
    ...    ${ANDROID_AGENT}
    ...    ${PLATFORM_VERSION_2020}
    Should Be Equal As Integers    ${select_feature_response['status_code']}    200
    Should Be Equal As Strings    ${select_feature_response["body"].result.title}    ${SUCCESS_TITLE}
    Should Be Equal As Integers    ${select_feature_response['body'].result.status}    ${SUCCESS_STATUS_CODE}
    Should Be Equal As Strings    ${select_feature_response['body'].result.message}    ${SUCCESS_MESSAGE}
    Should Be Equal As Strings    ${select_feature_response['body'].result.level}    ${INFO_LEVEL}

    Dictionary Should Contain Key
    ...    ${select_feature_response['body']}
    ...    amount
    Dictionary Should Contain Key
    ...    ${select_feature_response['body']}
    ...    pspCode
    Dictionary Should Contain Key
    ...    ${select_feature_response['body']}
    ...    redirectUrl
    Dictionary Should Contain Key
    ...    ${select_feature_response['body']}
    ...    payUrl
    Should Be Equal As Strings    ${select_feature_response['body']['payUrl']}    ${IPG_PAY_URL}/${SDK_Ticket}
    ${filter_query}    Create Dictionary    ticket=${SDK_Ticket}
    ${data_response}    Mongo Db Find
    ...    ${PURCHASE_MNG_DB_MANE}
    ...    ${PURCHASE_MNG_PURCHASE_COLLECTION}
    ...    ${filter_query}
    Should Be Equal As Integers    ${data_response['status_code']}    0
    Should Not Be Empty    ${data_response['body']}
    Should Be Equal As Strings    ${data_response['body'][0]['payGateway']}    IPG
    Should Be Equal As Strings    ${data_response['body'][0]['status']}    INITIATED
    Should Be Equal As Strings    ${data_response['body'][0]['owner']['agent']}    ${ANDROID_AGENT}
    Set Test Variable    ${purchase_trackingCode}    ${data_response['body'][0]['trackingCode']}

Success Select IPG On Android Agent For Company (Microservice)
    [Documentation]    This API Gets Ticket And IPG Feature Name And IPG Feature Should Be Selected
    ...    And A Record Should Exist In Purchase DB After Selection
    Success Getting Ticket's Features With Android Agent On Company Business(Microservice)
    ${select_feature_response}    Wait Until Keyword Succeeds    1 minute    5 s    Get Successful Select Feature
    ...    ${MICROSERVICE_SIDE}
    ...    ${SDK_Ticket}
    ...    ${IPG_FEATURE_NAME}
    ...    ${ANDROID_AGENT}
    ...    ${PLATFORM_VERSION_2020}
    Should Be Equal As Integers    ${select_feature_response['status_code']}    200
    Should Be Equal As Strings    ${select_feature_response["body"].result.title}    ${SUCCESS_TITLE}
    Should Be Equal As Integers    ${select_feature_response['body'].result.status}    ${SUCCESS_STATUS_CODE}
    Should Be Equal As Strings    ${select_feature_response['body'].result.message}    ${SUCCESS_MESSAGE}
    Should Be Equal As Strings    ${select_feature_response['body'].result.level}    ${INFO_LEVEL}

    Dictionary Should Contain Key
    ...    ${select_feature_response['body']}
    ...    amount
    Dictionary Should Contain Key
    ...    ${select_feature_response['body']}
    ...    pspCode
    Dictionary Should Contain Key
    ...    ${select_feature_response['body']}
    ...    redirectUrl
    Dictionary Should Contain Key
    ...    ${select_feature_response['body']}
    ...    payUrl
    Should Be Equal As Strings    ${select_feature_response['body']['payUrl']}    ${IPG_PAY_URL}/${SDK_Ticket}
    ${filter_query}    Create Dictionary    ticket=${SDK_Ticket}
    ${data_response}    Mongo Db Find
    ...    ${PURCHASE_MNG_DB_MANE}
    ...    ${PURCHASE_MNG_PURCHASE_COLLECTION}
    ...    ${filter_query}
    Should Be Equal As Integers    ${data_response['status_code']}    0
    Should Not Be Empty    ${data_response['body']}
    Should Be Equal As Strings    ${data_response['body'][0]['payGateway']}    IPG
    Should Be Equal As Strings    ${data_response['body'][0]['status']}    INITIATED
    Should Be Equal As Strings    ${data_response['body'][0]['owner']['agent']}    ${ANDROID_AGENT}
    Set Test Variable    ${purchase_trackingCode}    ${data_response['body'][0]['trackingCode']}

################################## WEB IPG SELECTION #####################################

Success Select IPG On Web Agent For Platform (Gateway)
    [Documentation]    This API Gets Ticket And IPG Feature Name And IPG Feature Should Be Selected
    ...    And A Record Should Exist In Purchase DB After Selection
    Success Getting Ticket's Features With Web Agent On Platform Business(Gateway)
    ${select_feature_response}    Wait Until Keyword Succeeds    1 minute    5 s    Get Successful Select Feature
    ...    ${GENERAL_SIDE}
    ...    ${UPG_Ticket}
    ...    ${IPG_FEATURE_NAME}
    ...    ${WEB_AGENT}
    ...    ${PLATFORM_VERSION_2020}
    Should Be Equal As Integers    ${select_feature_response['status_code']}    200
    Should Be Equal As Strings    ${select_feature_response["body"].result.title}    ${SUCCESS_TITLE}
    Should Be Equal As Integers    ${select_feature_response['body'].result.status}    ${SUCCESS_STATUS_CODE}
    Should Be Equal As Strings    ${select_feature_response['body'].result.message}    ${SUCCESS_MESSAGE}
    Should Be Equal As Strings    ${select_feature_response['body'].result.level}    ${INFO_LEVEL}

    Dictionary Should Contain Key
    ...    ${select_feature_response['body']}
    ...    amount
    Dictionary Should Contain Key
    ...    ${select_feature_response['body']}
    ...    pspCode
    Dictionary Should Contain Key
    ...    ${select_feature_response['body']}
    ...    redirectUrl
    Dictionary Should Contain Key
    ...    ${select_feature_response['body']}
    ...    payUrl
    Should Be Equal As Strings    ${select_feature_response['body']['payUrl']}    ${IPG_PAY_URL}/${UPG_Ticket}
    ${filter_query}    Create Dictionary    ticket=${UPG_Ticket}
    ${data_response}    Mongo Db Find
    ...    ${PURCHASE_MNG_DB_MANE}
    ...    ${PURCHASE_MNG_PURCHASE_COLLECTION}
    ...    ${filter_query}
    Should Be Equal As Integers    ${data_response['status_code']}    0
    Should Not Be Empty    ${data_response['body']}
    Should Be Equal As Strings    ${data_response['body'][0]['payGateway']}    IPG
    Should Be Equal As Strings    ${data_response['body'][0]['status']}    INITIATED
    Should Be Equal As Strings    ${data_response['body'][0]['owner']['agent']}    ${WEB_AGENT}
    Set Test Variable    ${purchase_trackingCode}    ${data_response['body'][0]['trackingCode']}

Success Select IPG On Web Agent For Platform (Microservice)
    [Documentation]    This API Gets Ticket And IPG Feature Name And IPG Feature Should Be Selected
    ...    And A Record Should Exist In Purchase DB After Selection
    Success Getting Ticket's Features With Web Agent On Platform Business(Microservice)
    ${select_feature_response}    Wait Until Keyword Succeeds    1 minute    5 s    Get Successful Select Feature
    ...    ${MICROSERVICE_SIDE}
    ...    ${UPG_Ticket}
    ...    ${IPG_FEATURE_NAME}
    ...    ${WEB_AGENT}
    ...    ${PLATFORM_VERSION_2020}
    Should Be Equal As Integers    ${select_feature_response['status_code']}    200
    Should Be Equal As Strings    ${select_feature_response["body"].result.title}    ${SUCCESS_TITLE}
    Should Be Equal As Integers    ${select_feature_response['body'].result.status}    ${SUCCESS_STATUS_CODE}
    Should Be Equal As Strings    ${select_feature_response['body'].result.message}    ${SUCCESS_MESSAGE}
    Should Be Equal As Strings    ${select_feature_response['body'].result.level}    ${INFO_LEVEL}

    Dictionary Should Contain Key
    ...    ${select_feature_response['body']}
    ...    amount
    Dictionary Should Contain Key
    ...    ${select_feature_response['body']}
    ...    pspCode
    Dictionary Should Contain Key
    ...    ${select_feature_response['body']}
    ...    redirectUrl
    Dictionary Should Contain Key
    ...    ${select_feature_response['body']}
    ...    payUrl
    Should Be Equal As Strings    ${select_feature_response['body']['payUrl']}    ${IPG_PAY_URL}/${UPG_Ticket}
    ${filter_query}    Create Dictionary    ticket=${UPG_Ticket}
    ${data_response}    Mongo Db Find
    ...    ${PURCHASE_MNG_DB_MANE}
    ...    ${PURCHASE_MNG_PURCHASE_COLLECTION}
    ...    ${filter_query}
    Should Be Equal As Integers    ${data_response['status_code']}    0
    Should Not Be Empty    ${data_response['body']}
    Should Be Equal As Strings    ${data_response['body'][0]['payGateway']}    IPG
    Should Be Equal As Strings    ${data_response['body'][0]['status']}    INITIATED
    Should Be Equal As Strings    ${data_response['body'][0]['owner']['agent']}    ${WEB_AGENT}
    Set Test Variable    ${purchase_trackingCode}    ${data_response['body'][0]['trackingCode']}

Success Select IPG On Web Agent For Company (Gateway)
    [Documentation]    This API Gets Ticket And IPG Feature Name And IPG Feature Should Be Selected
    ...    And A Record Should Exist In Purchase DB After Selection
    Success Getting Ticket's Features With Web Agent On Company Business(Gateway)
    ${select_feature_response}    Wait Until Keyword Succeeds    1 minute    5 s    Get Successful Select Feature
    ...    ${GENERAL_SIDE}
    ...    ${UPG_Ticket}
    ...    ${IPG_FEATURE_NAME}
    ...    ${WEB_AGENT}
    ...    ${PLATFORM_VERSION_2020}
    Should Be Equal As Integers    ${select_feature_response['status_code']}    200    msg=Invalid response code
    Should Be Equal As Strings    ${select_feature_response["body"].result.title}    ${SUCCESS_TITLE}
    Should Be Equal As Integers    ${select_feature_response['body'].result.status}    ${SUCCESS_STATUS_CODE}
    Should Be Equal As Strings    ${select_feature_response['body'].result.message}    ${SUCCESS_MESSAGE}
    Should Be Equal As Strings    ${select_feature_response['body'].result.level}    ${INFO_LEVEL}

    Dictionary Should Contain Key
    ...    ${select_feature_response['body']}
    ...    amount
    Dictionary Should Contain Key
    ...    ${select_feature_response['body']}
    ...    pspCode
    Dictionary Should Contain Key
    ...    ${select_feature_response['body']}
    ...    redirectUrl
    Dictionary Should Contain Key
    ...    ${select_feature_response['body']}
    ...    payUrl
    Should Be Equal As Strings    ${select_feature_response['body']['payUrl']}    ${IPG_PAY_URL}/${UPG_Ticket}
    ${filter_query}    Create Dictionary    ticket=${UPG_Ticket}
    ${data_response}    Mongo Db Find
    ...    ${PURCHASE_MNG_DB_MANE}
    ...    ${PURCHASE_MNG_PURCHASE_COLLECTION}
    ...    ${filter_query}
    Should Be Equal As Integers    ${data_response['status_code']}    0
    Should Not Be Empty    ${data_response['body']}
    Should Be Equal As Strings    ${data_response['body'][0]['payGateway']}    IPG
    Should Be Equal As Strings    ${data_response['body'][0]['status']}    INITIATED
    Should Be Equal As Strings    ${data_response['body'][0]['owner']['agent']}    ${WEB_AGENT}
    Set Test Variable    ${purchase_trackingCode}    ${data_response['body'][0]['trackingCode']}

Success Select IPG On Web Agent For Company (Microservice)
    [Documentation]    This API Gets Ticket And IPG Feature Name And IPG Feature Should Be Selected
    ...    And A Record Should Exist In Purchase DB After Selection
    Success Getting Ticket's Features With Web Agent On Company Business(Microservice)
    ${select_feature_response}    Wait Until Keyword Succeeds    1 minute    5 s    Get Successful Select Feature
    ...    ${MICROSERVICE_SIDE}
    ...    ${UPG_Ticket}
    ...    ${IPG_FEATURE_NAME}
    ...    ${WEB_AGENT}
    ...    ${PLATFORM_VERSION_2020}
    Should Be Equal As Integers    ${select_feature_response['status_code']}    200
    Should Be Equal As Strings    ${select_feature_response["body"].result.title}    ${SUCCESS_TITLE}
    Should Be Equal As Integers    ${select_feature_response['body'].result.status}    ${SUCCESS_STATUS_CODE}
    Should Be Equal As Strings    ${select_feature_response['body'].result.message}    ${SUCCESS_MESSAGE}
    Should Be Equal As Strings    ${select_feature_response['body'].result.level}    ${INFO_LEVEL}

    Dictionary Should Contain Key
    ...    ${select_feature_response['body']}
    ...    amount
    Dictionary Should Contain Key
    ...    ${select_feature_response['body']}
    ...    pspCode
    Dictionary Should Contain Key
    ...    ${select_feature_response['body']}
    ...    redirectUrl
    Dictionary Should Contain Key
    ...    ${select_feature_response['body']}
    ...    payUrl
    Should Be Equal As Strings    ${select_feature_response['body']['payUrl']}    ${IPG_PAY_URL}/${UPG_Ticket}
    ${filter_query}    Create Dictionary    ticket=${UPG_Ticket}
    ${data_response}    Mongo Db Find
    ...    ${PURCHASE_MNG_DB_MANE}
    ...    ${PURCHASE_MNG_PURCHASE_COLLECTION}
    ...    ${filter_query}
    Should Be Equal As Integers    ${data_response['status_code']}    0
    Should Not Be Empty    ${data_response['body']}
    Should Be Equal As Strings    ${data_response['body'][0]['payGateway']}    IPG
    Should Be Equal As Strings    ${data_response['body'][0]['status']}    INITIATED
    Should Be Equal As Strings    ${data_response['body'][0]['owner']['agent']}    ${WEB_AGENT}
    Set Test Variable    ${purchase_trackingCode}    ${data_response['body'][0]['trackingCode']}

################################## ANDROID DPG SELECTION #####################################

Success Select DPG On Android Agent(Microservice)
    [Documentation]    This API Gets Ticket And DPG Feature Name And DPG Feature Should Be Selected
    ...    And A Record Should Exist In Purchase DB After Selection
    Success Getting Ticket's Features With Android Agent On Platform Business(Microservice)
    ${select_feature_response}    Wait Until Keyword Succeeds    1 minute    5 s    Get Successful Select Feature
    ...    ${MICROSERVICE_SIDE}
    ...    ${SDK_Ticket}
    ...    ${DPG_FEATURE_NAME}
    ...    ${ANDROID_AGENT}
    ...    ${PLATFORM_VERSION_2020}
    Should Be Equal As Integers    ${select_feature_response['status_code']}    200
    Should Be Equal As Strings    ${select_feature_response["body"].result.title}    ${SUCCESS_TITLE}
    Should Be Equal As Integers    ${select_feature_response['body'].result.status}    ${SUCCESS_STATUS_CODE}
    Should Be Equal As Strings    ${select_feature_response['body'].result.message}    ${SUCCESS_MESSAGE}
    Should Be Equal As Strings    ${select_feature_response['body'].result.level}    ${INFO_LEVEL}

    Dictionary Should Contain Key
    ...    ${select_feature_response['body']}
    ...    amount
    Dictionary Should Contain Key
    ...    ${select_feature_response['body']}
    ...    pspCode
    Dictionary Should Contain Key
    ...    ${select_feature_response['body']}
    ...    certFile
    Dictionary Should Contain Key
    ...    ${select_feature_response['body']}
    ...    redirectUrl
    Dictionary Should Contain Key
    ...    ${select_feature_response['body']}
    ...    payUrl
    Should Be Equal As Strings    ${select_feature_response['body']['payUrl']}    ${DPG_PAY_URL}
    ${filter_query}    Create Dictionary    ticket=${SDK_Ticket}
    ${data_response}    Mongo Db Find
    ...    ${PURCHASE_MNG_DB_MANE}
    ...    ${PURCHASE_MNG_PURCHASE_COLLECTION}
    ...    ${filter_query}
    Should Be Equal As Integers    ${data_response['status_code']}    0
    Should Not Be Empty    ${data_response['body']}
    Should Be Equal As Strings    ${data_response['body'][0]['payGateway']}    DPG
    Should Be Equal As Strings    ${data_response['body'][0]['status']}    INITIATED
    Should Be Equal As Strings    ${data_response['body'][0]['owner']['agent']}    ${ANDROID_AGENT}
    Set Test Variable    ${purchase_trackingCode}    ${data_response['body'][0]['trackingCode']}

Success Select DPG On Android Agent(Gateway)
    [Documentation]    This API Gets Ticket And DPG Feature Name And DPG Feature Should Be Selected
    ...    And A Record Should Exist In Purchase DB After Selection
    ${select_feature_response}    Wait Until Keyword Succeeds    1 minute    5 s    Get Successful Select Feature
    ...    ${GENERAL_SIDE}
    ...    ${SDK_Ticket}
    ...    ${DPG_FEATURE_NAME}
    ...    ${ANDROID_AGENT}
    ...    ${PLATFORM_VERSION_2020}
    Should Be Equal As Integers    ${select_feature_response['status_code']}    200
    Should Be Equal As Strings    ${select_feature_response["body"].result.title}    ${SUCCESS_TITLE}
    Should Be Equal As Integers    ${select_feature_response['body'].result.status}    ${SUCCESS_STATUS_CODE}
    Should Be Equal As Strings    ${select_feature_response['body'].result.message}    ${SUCCESS_MESSAGE}
    Should Be Equal As Strings    ${select_feature_response['body'].result.level}    ${INFO_LEVEL}

    Dictionary Should Contain Key
    ...    ${select_feature_response['body']}
    ...    amount
    Dictionary Should Contain Key
    ...    ${select_feature_response['body']}
    ...    pspCode
    Dictionary Should Contain Key
    ...    ${select_feature_response['body']}
    ...    redirectUrl
    Dictionary Should Contain Key
    ...    ${select_feature_response['body']}
    ...    payUrl
    Should Be Equal As Strings    ${select_feature_response['body']['payUrl']}    ${DPG_PAY_URL}
    ${filter_query}    Create Dictionary    ticket=${SDK_Ticket}
    ${data_response}    Mongo Db Find
    ...    ${PURCHASE_MNG_DB_MANE}
    ...    ${PURCHASE_MNG_PURCHASE_COLLECTION}
    ...    ${filter_query}
    Should Be Equal As Integers    ${data_response['status_code']}    0
    Should Not Be Empty    ${data_response['body']}
    Should Be Equal As Strings    ${data_response['body'][0]['payGateway']}    DPG
    Should Be Equal As Strings    ${data_response['body'][0]['status']}    INITIATED
    Should Be Equal As Strings    ${data_response['body'][0]['owner']['agent']}    ${ANDROID_AGENT}
    Set Test Variable    ${purchase_trackingCode}    ${data_response['body'][0]['trackingCode']}

############################### WEB IPG CASHIN SELECTION #################################

Success Select IPG CashIn On Web Agent For Platform (Gateway)
    [Documentation]    This API Gets Ticket And IPG-CashIn Feature Name And IPG-CashIn Feature Should Be Selected
    ...    And A Record Should Exist In Nemo DB After Selection
    Success Getting Ticket's Features (Cashin & Pay) With Web Agent On Platform Business(Gateway)
    ${select_feature_response}    Wait Until Keyword Succeeds    1 minute    5 s    Get Successful Select Feature
    ...    ${GENERAL_SIDE}
    ...    ${UPG_Ticket}
    ...    ${IPG_CASHIN_FEATURE_NAME}
    ...    ${WEB_AGENT}
    ...    ${PLATFORM_VERSION_2020}
    Should Be Equal As Integers    ${select_feature_response['status_code']}    200
    Should Be Equal As Strings    ${select_feature_response["body"].result.title}    ${SUCCESS_TITLE}
    Should Be Equal As Integers    ${select_feature_response['body'].result.status}    ${SUCCESS_STATUS_CODE}
    Should Be Equal As Strings    ${select_feature_response['body'].result.message}    ${SUCCESS_MESSAGE}
    Should Be Equal As Strings    ${select_feature_response['body'].result.level}    ${INFO_LEVEL}

    Dictionary Should Contain Key
    ...    ${select_feature_response['body']}
    ...    amount
    Dictionary Should Contain Key
    ...    ${select_feature_response['body']}
    ...    pspCode
    Dictionary Should Contain Key
    ...    ${select_feature_response['body']}
    ...    redirectUrl
    Dictionary Should Contain Key
    ...    ${select_feature_response['body']}
    ...    payUrl
    Dictionary Should Contain Key
    ...    ${select_feature_response['body']}
    ...    rawAmount
    Dictionary Should Contain Key
    ...    ${select_feature_response['body']}
    ...    cashInXferMin
    Dictionary Should Contain Key
    ...    ${select_feature_response['body']}
    ...    cashInXferMax
    Dictionary Should Contain Key
    ...    ${select_feature_response['body']}
    ...    cashInDefaultValue
    Dictionary Should Contain Key
    ...    ${select_feature_response['body']}
    ...    needsKyc
    Should Be Equal As Strings    ${select_feature_response['body']['payUrl']}    ${IPG_CASHIN_PAY_URL}/${UPG_Ticket}
    ${filter_query}    Create Dictionary    ticket=${UPG_Ticket}
    ${data_response}    Mongo Db Find
    ...    ${NEMO_DB_NAME}
    ...    ${NEMO_PAYMENT_COLLECTION}
    ...    ${filter_query}
    Should Be Equal As Integers    ${data_response['status_code']}    0
    Should Not Be Empty    ${data_response['body']}
    Should Be Equal As Strings    ${data_response['body'][0]['type']}    CASH_IN
    Should Be Equal As Integers    ${data_response['body'][0]['status']}    1
    Should Be Equal As Strings    ${data_response['body'][0]['owner']['agent']}    ${WEB_AGENT}
    Set Test Variable    ${purchase_trackingCode}    ${data_response['body'][0]['trackingCode']}

Success Select IPG CashIn On Web Agent For Platform (Microservice)
    [Documentation]    This API Gets Ticket And IPG-CashIn Feature Name And IPG-CashIn Feature Should Be Selected
    ...    And A Record Should Exist In Nemo DB After Selection
    Success Getting Ticket's Features (Cashin & Pay) With Web Agent On Platform Business(Microservice)
    ${select_feature_response}    Wait Until Keyword Succeeds    1 minute    5 s    Get Successful Select Feature
    ...    ${MICROSERVICE_SIDE}
    ...    ${UPG_Ticket}
    ...    ${IPG_CASHIN_FEATURE_NAME}
    ...    ${WEB_AGENT}
    ...    ${PLATFORM_VERSION_2020}
    Should Be Equal As Integers    ${select_feature_response['status_code']}    200
    Should Be Equal As Strings    ${select_feature_response["body"].result.title}    ${SUCCESS_TITLE}
    Should Be Equal As Integers    ${select_feature_response['body'].result.status}    ${SUCCESS_STATUS_CODE}
    Should Be Equal As Strings    ${select_feature_response['body'].result.message}    ${SUCCESS_MESSAGE}
    Should Be Equal As Strings    ${select_feature_response['body'].result.level}    ${INFO_LEVEL}

    Dictionary Should Contain Key
    ...    ${select_feature_response['body']}
    ...    amount
    Dictionary Should Contain Key
    ...    ${select_feature_response['body']}
    ...    pspCode
    Dictionary Should Contain Key
    ...    ${select_feature_response['body']}
    ...    redirectUrl
    Dictionary Should Contain Key
    ...    ${select_feature_response['body']}
    ...    payUrl
    Dictionary Should Contain Key
    ...    ${select_feature_response['body']}
    ...    rawAmount
    Dictionary Should Contain Key
    ...    ${select_feature_response['body']}
    ...    cashInXferMin
    Dictionary Should Contain Key
    ...    ${select_feature_response['body']}
    ...    cashInXferMax
    Dictionary Should Contain Key
    ...    ${select_feature_response['body']}
    ...    cashInDefaultValue
    Dictionary Should Contain Key
    ...    ${select_feature_response['body']}
    ...    needsKyc
    Should Be Equal As Strings    ${select_feature_response['body']['payUrl']}    ${IPG_CASHIN_PAY_URL}/${UPG_Ticket}
    ${filter_query}    Create Dictionary    ticket=${UPG_Ticket}
    ${data_response}    Mongo Db Find
    ...    ${NEMO_DB_NAME}
    ...    ${NEMO_PAYMENT_COLLECTION}
    ...    ${filter_query}
    Should Be Equal As Integers    ${data_response['status_code']}    0
    Should Not Be Empty    ${data_response['body']}
    Should Be Equal As Strings    ${data_response['body'][0]['type']}    CASH_IN
    Should Be Equal As Integers    ${data_response['body'][0]['status']}    1
    Should Be Equal As Strings    ${data_response['body'][0]['owner']['agent']}    ${WEB_AGENT}
    Set Test Variable    ${purchase_trackingCode}    ${data_response['body'][0]['trackingCode']}

Success Select IPG CashIn On Web Agent For Company (Gateway)
    [Documentation]    This API Gets Ticket And IPG-CashIn Feature Name And IPG-CashIn Feature Should Be Selected
    ...    And A Record Should Exist In Nemo DB After Selection
    Success Getting Ticket's Features (Cashin & Pay) With Web Agent On Company Business(Gateway)
    ${select_feature_response}    Wait Until Keyword Succeeds    1 minute    5 s    Get Successful Select Feature
    ...    ${GENERAL_SIDE}
    ...    ${UPG_Ticket}
    ...    ${IPG_CASHIN_FEATURE_NAME}
    ...    ${WEB_AGENT}
    ...    ${PLATFORM_VERSION_2020}
    Should Be Equal As Integers    ${select_feature_response['status_code']}    200    msg=Invalid response code
    Should Be Equal As Strings    ${select_feature_response["body"].result.title}    ${SUCCESS_TITLE}
    Should Be Equal As Integers    ${select_feature_response['body'].result.status}    ${SUCCESS_STATUS_CODE}
    Should Be Equal As Strings    ${select_feature_response['body'].result.message}    ${SUCCESS_MESSAGE}
    Should Be Equal As Strings    ${select_feature_response['body'].result.level}    ${INFO_LEVEL}

    Dictionary Should Contain Key
    ...    ${select_feature_response['body']}
    ...    amount
    Dictionary Should Contain Key
    ...    ${select_feature_response['body']}
    ...    pspCode
    Dictionary Should Contain Key
    ...    ${select_feature_response['body']}
    ...    redirectUrl
    Dictionary Should Contain Key
    ...    ${select_feature_response['body']}
    ...    payUrl
    Dictionary Should Contain Key
    ...    ${select_feature_response['body']}
    ...    rawAmount
    Dictionary Should Contain Key
    ...    ${select_feature_response['body']}
    ...    cashInXferMin
    Dictionary Should Contain Key
    ...    ${select_feature_response['body']}
    ...    cashInXferMax
    Dictionary Should Contain Key
    ...    ${select_feature_response['body']}
    ...    cashInDefaultValue
    Dictionary Should Contain Key
    ...    ${select_feature_response['body']}
    ...    needsKyc
    Should Be Equal As Strings    ${select_feature_response['body']['payUrl']}    ${IPG_CASHIN_PAY_URL}/${UPG_Ticket}
    ${filter_query}    Create Dictionary    ticket=${UPG_Ticket}
    ${data_response}    Mongo Db Find
    ...    ${NEMO_DB_NAME}
    ...    ${NEMO_PAYMENT_COLLECTION}
    ...    ${filter_query}
    Should Be Equal As Integers    ${data_response['status_code']}    0
    Should Not Be Empty    ${data_response['body']}
    Should Be Equal As Strings    ${data_response['body'][0]['type']}    CASH_IN
    Should Be Equal As Integers    ${data_response['body'][0]['status']}    1
    Should Be Equal As Strings    ${data_response['body'][0]['owner']['agent']}    ${WEB_AGENT}
    Set Test Variable    ${purchase_trackingCode}    ${data_response['body'][0]['trackingCode']}

Success Select IPG CashIn On Web Agent For Company (Microservice)
    [Documentation]    This API Gets Ticket And IPG-CashIn Feature Name And IPG-CashIn Feature Should Be Selected
    ...    And A Record Should Exist In Nemo DB After Selection
    Success Getting Ticket's Features (Cashin & Pay) With Web Agent On Company Business(Microservice)
    ${select_feature_response}    Wait Until Keyword Succeeds    1 minute    5 s    Get Successful Select Feature
    ...    ${MICROSERVICE_SIDE}
    ...    ${UPG_Ticket}
    ...    ${IPG_CASHIN_FEATURE_NAME}
    ...    ${WEB_AGENT}
    ...    ${PLATFORM_VERSION_2020}
    Should Be Equal As Integers    ${select_feature_response['status_code']}    200
    Should Be Equal As Strings    ${select_feature_response["body"].result.title}    ${SUCCESS_TITLE}
    Should Be Equal As Integers    ${select_feature_response['body'].result.status}    ${SUCCESS_STATUS_CODE}
    Should Be Equal As Strings    ${select_feature_response['body'].result.message}    ${SUCCESS_MESSAGE}
    Should Be Equal As Strings    ${select_feature_response['body'].result.level}    ${INFO_LEVEL}

    Dictionary Should Contain Key
    ...    ${select_feature_response['body']}
    ...    amount
    Dictionary Should Contain Key
    ...    ${select_feature_response['body']}
    ...    pspCode
    Dictionary Should Contain Key
    ...    ${select_feature_response['body']}
    ...    redirectUrl
    Dictionary Should Contain Key
    ...    ${select_feature_response['body']}
    ...    payUrl
    Dictionary Should Contain Key
    ...    ${select_feature_response['body']}
    ...    rawAmount
    Dictionary Should Contain Key
    ...    ${select_feature_response['body']}
    ...    cashInXferMin
    Dictionary Should Contain Key
    ...    ${select_feature_response['body']}
    ...    cashInXferMax
    Dictionary Should Contain Key
    ...    ${select_feature_response['body']}
    ...    cashInDefaultValue
    Dictionary Should Contain Key
    ...    ${select_feature_response['body']}
    ...    needsKyc
    Should Be Equal As Strings    ${select_feature_response['body']['payUrl']}    ${IPG_CASHIN_PAY_URL}/${UPG_Ticket}
    ${filter_query}    Create Dictionary    ticket=${UPG_Ticket}
    ${data_response}    Mongo Db Find
    ...    ${NEMO_DB_NAME}
    ...    ${NEMO_PAYMENT_COLLECTION}
    ...    ${filter_query}
    Should Be Equal As Integers    ${data_response['status_code']}    0
    Should Not Be Empty    ${data_response['body']}
    Should Be Equal As Strings    ${data_response['body'][0]['type']}    CASH_IN
    Should Be Equal As Integers    ${data_response['body'][0]['status']}    1
    Should Be Equal As Strings    ${data_response['body'][0]['owner']['agent']}    ${WEB_AGENT}
    Set Test Variable    ${purchase_trackingCode}    ${data_response['body'][0]['trackingCode']}
