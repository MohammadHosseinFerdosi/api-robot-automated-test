*** Settings ***
Resource    services/AI/find-and-click-utility.resource
Resource    services/frontend/browser-service.resource
Library     library/solve_captcha.py
Variables       data/icons/icon-paths.yaml


*** Keywords ***
Pay IPG via AI with Retries on Captcha MLT
    [Documentation]    AI utility to complete purchase in MLT IPG. Contains the MLT IPG strategy.
    [Arguments]
    ...    ${card_number}
    ...    ${CVV2}
    ...    ${month}
    ...    ${year}
    ...    ${card_pass}
    ...    ${save_dir}=captures
    ...    ${prefix}=captcha
    [Tags]    robot:private

    Wait Until Keyword Succeeds    2 minute    5 s    Attempt Payment MLT
    ...    card_number=${card_number}
    ...    CVV2=${CVV2}
    ...    month=${month}
    ...    year=${year}
    ...    card_pass=${card_pass}
    ...    save_dir=${save_dir}
    ...    prefix=${prefix}

Attempt Payment MLT
    [Documentation]    Attempts to pay the MLT IPG given the inputs. 
    ...    Retries if it fails. This is the MLT IPG strategy.
    [Arguments]
    ...    ${card_number}
    ...    ${CVV2}
    ...    ${month}
    ...    ${year}
    ...    ${card_pass}
    ...    ${save_dir}
    ...    ${prefix}
    ...    ${default_sleep}=5sec
    [Tags]    robot:private

    ${initial_url}    Get Location

    Press Keys    None    TAB
    Press Keys    None    TAB
    Press Keys    None    ${card_number}
    Press Keys    None    ${CVV2}
    Press Keys    None    TAB
    Press Keys    None    ${month}
    Press Keys    None    ${year}

    Capture Images Vanilla
    ...    num_scrolls=1
    ...    save_dir=${save_dir}
    ...    prefix=${prefix}
    ...    resize=True

    ${captcha}    Solve Captcha
    ...    image_path=captures/r_captcha_screenshot_0.png
    ...    expected_length=${5}
    ...    save_for_debug=True
    ...    save_location=captures/r_processed_screenshot_0.png

    Press Keys    None    ${captcha}
    Press Keys    None    ${card_pass}

    Find And Click
    ...    icon_path=${ICON_MLT_IPG_ACCEPT}
    ...    debug=False
    ...    version=vanilla
    ...    num_scrolls=2

    Sleep    ${default_sleep}    reason=Wait for the bank to respond!

    ${current_url}    Get Location
    IF    '${current_url}' == '${initial_url}'    Reload Page And Retry

Pay IPG via AI with Retries on Captcha
    [Documentation]    IPG solver service. Based on the type of ipg, a strategy is chosen and then follower; 
    ...    Currently only contains the strategy for the MLT IPGs.
    ...    
    ...    *Inputs*:
    ...    ${URL}: The Internet Payment Gateway url. Must be a valid IPG, otherwise the test will fail 
    ...    ${browser}: The Browser to open the ${URL}.
    ...    ${card_number}: The information that is used to complete the pay.
    ...    ${CVV2}: The information that is used to complete the pay.
    ...    ${month}: The information that is used to complete the pay.
    ...    ${year}: The information that is used to complete the pay.
    ...    ${card_pass}: The information that is used to complete the pay.
    ...    ${concurrent}: Whether you are concurrently opening the url as part of another flow. 
    ...    By default it is set as ```False```

    [Arguments]
    ...    ${card_number}
    ...    ${CVV2}
    ...    ${month}
    ...    ${year}
    ...    ${card_pass}
    ...    ${URL}=${EMPTY}
    ...    ${browser}=${EMPTY}
    ...    ${concurrent}=False

    IF    '${concurrent}'=='False'
        VAR    ${option}    add_argument("--disable-notifications")
        Connect To Browser    ${URL}    browser=${browser}    option=${option}    is_remote=${False}
        Maximize Browser Window
    END
    
    ${current_url}    Get Location
    ${contained_sep}    Evaluate    'sep' in '${current_url}'
    ${contained_sadad}    Evaluate    'sadad' in '${current_url}'
    ${contained_mlt}    Evaluate    'startpay.mellat' in '${current_url}'

    IF    '${contained_mlt}'=='True'
        Pay IPG via AI with Retries on Captcha MLT
        ...    card_number=${card_number}
        ...    CVV2=${CVV2}
        ...    month=${month}
        ...    year=${year}
        ...    card_pass=${card_pass}
        RETURN
    ELSE
        Fail    msg=Strategy Not Implemented!
    END

Reload Page And Retry
    [Documentation]    A fail state; Reloads the page and retry the paying process.
    Reload Page
    Fail    msg=Could not complete the payment, you may need to investigate the possible reasons.
