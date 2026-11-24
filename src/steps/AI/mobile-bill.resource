*** Settings ***
Resource        services/AI/find-and-click-utility.resource
Resource        services/AI/IPG.resource


*** Keywords ***
Pay Top Up Mobile Bill With a Predefined User
    [Documentation]    This is a utility that pays the topup mobile bill for a specific user
    ...    We do not actually pay!
    [Arguments]
    ...    ${cell_number}=09911772110
    ...    ${debug}=True
    Empty Captures

    Find And Click
    ...    icon_path=${ICON_TOPUP_MOBILE_BILL_VERSION_2}
    ...    debug=${debug}
    ...    version=platform-1
    ...    num_scrolls=10

    Find And Click And Insert
    ...    input=${cell_number}
    ...    input_delay=${EMPTY}
    ...    icon_path=${ICON_TOPUP_INSERT_PHONE_NUMBER}
    ...    debug=${debug}
    ...    version=vanilla
    ...    num_scrolls=2

    Find And Click
    ...    icon_path=${ICON_CONFIRM_PAY_VERSION_4}
    ...    debug=${debug}
    ...    version=vanilla
    ...    num_scrolls=2

    Find And Click
    ...    icon_path=${ICON_TOPUP_CHOOSE_BILL_VERSION_1}
    ...    debug=${debug}
    ...    version=vanilla
    ...    num_scrolls=2

    Find And Click
    ...    icon_path=${ICON_TOPUP_CHOOSE_PLAN}
    ...    debug=${debug}
    ...    version=vanilla
    ...    num_scrolls=4

    Find And Click
    ...    icon_path=${ICON_TOPUP_PAY_METHOD_3}
    ...    debug=${debug}
    ...    version=platform-2
    ...    div_config=.tgs-container.d-flex.flex-column.flex-grow.h-100.px-big.pt-big
    ...    num_scrolls=2

    Find And Click
    ...    icon_path=${ICON_CONFIRM_PAY_VERSION_2}
    ...    debug=${debug}
    ...    version=vanilla
    ...    num_scrolls=2

    # Wait Until Keyword Succeeds    
    # ...    1 minute    
    # ...    5 s    
    # ...    Pay IPG via AI with Retries on Captcha
    # ...    card_number=5047061071188482
    # ...    CVV2=325
    # ...    month=12
    # ...    year=04
    # ...    card_pass=833327
    # ...    concurrent=True
