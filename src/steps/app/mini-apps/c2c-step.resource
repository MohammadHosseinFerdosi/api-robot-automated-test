*** Settings ***
Resource        pages/app/c2c.resource
Resource        services/frontend/browser-service.resource
Resource        services/frontend/front-auth-service.resource
Resource        pages/app/hub.resource
Variables       data/app/mini-apps/c2c.yaml


*** Keywords ***
Init Browser
    ${app_url}    Get App Base URL
    VAR    ${option}    add_argument("--disable-notifications")
    Connect To Browser    ${app_url}    browser=${FIREFOX}    option=${option}    is_remote=${False}
    Login To App With API    ${USER_CELL_NUMBER}

Navigate To C2C Page
    Navigate To    ${C2C_PAGE}
    Should Be In C2C Page

User Enters C2C Information
    Navigate To C2C Page
    C2C Action    ${Source_card['card_num']}    ${Target_Card['card_num']}    ${Transfer_Amount}
    C2C Info Bottom Sheet Will Appear
    ...    ${Target_Card['card_num']}
    ...    ${Target_Card['owner_name']}
    ...    ${Transfer_Amount}
    User Approves C2C Info    save_card=True    frequent_transaction=False

Enters Card Credential Data And Pay
    User Enters Card Credential Data    ${Source_card['cvv2']}    ${Source_card['static_pass']}
    Clicks On Pay Button

C2C Info Bottom Sheet Will Appear
    [Arguments]    ${target_card}    ${target_owner}    ${amount}
    ${actual_target_card}    Return The Target Card Number On C2C Info Buttom Sheet
    ${expected_target_card}    Remove String Using Regexp    ${target_card}    [ ]
    Should Be Equal As Strings    ${actual_target_card}    ${expected_target_card}

    ${actual_target_owner}    Return The Target Card Owner On C2C Info Buttom Sheet
    Should Be Equal As Strings    ${actual_target_owner}    ${target_owner}

    ${actual_amount}    Return The Amount On C2C Info Buttom Sheet
    ${actual_amount}    Remove String Using Regexp    ${actual_amount}    [٬]
    Should Be Equal As Strings    ${actual_amount}    ${amount}

    ${saved_card_result}    Save card button is shown
    Should Be True    ${saved_card_result}

    ${reapeted_result}    Reapeated transaction button is shown
    Should Be True    ${reapeted_result}

The C2C Transfer Should Occur Successfully
    ${tracking_code}    Get Tracking Code On C2C Transaction
    Set Test Variable    ${actual_tracking_code}    ${tracking_code}
    Check c2c transaction receipt
    ...    ${Target_Card['card_num']}
    ...    ${Target_Card['bank_name']}
    ...    ${Source_card['card_num']}
    ...    ${Source_card['bank_name']}
    ...    ${Transfer_Amount}

Check C2C Transaction Receipt
    [Arguments]    ${target_card_num}    ${target_card_bank}    ${source_card_num}    ${source_card_bank}    ${amount}
    ${result}    Return The C2C Transaction Receipt Details

    ${target_last_four_digits}    Set Variable    ${target_card_num}[-4:]
    ${source_last_four_digits}    Set Variable    ${source_card_num}[-4:]

    Should Be Equal    ${result['target_bank_name']}    ${target_card_bank}
    Should Be Equal    ${result['target_last_4_digit']}    ${target_last_four_digits}

    Should Be Equal    ${result['source_bank_name']}    ${source_card_bank}
    Should Be Equal    ${result['source_last_4_digit']}    ${source_last_four_digits}

    Should Be Equal    ${result['transfer_amount']}    ${amount}

User Tries To Add Invalid Source Card
    Add New Card    card_num=${Invalid_Source_card['card_num']}

User Tries To Add Incorrect Source Card
    Add New Card    card_num=${Incorrect_Source_card['card_num']}

Back From C2C To Hub
    [Documentation]    After the completion of the hub page automation, this method will be replaced by a method in the hub automation.
    Go To    url=https://example.com/hub

Continue Button Will Disable
    ${result}    IS Continue Button Disable
    Should Be True    ${result}

Invalid Card Number Message Will Appear
    Run Keyword And Ignore Error    Click On Conitue Button
    ${actual_error_message}    Return The Adding Card Error Message
    Should Be Equal As Strings    ${actual_error_message}    ${Invalid_Source_card['error_message']}
