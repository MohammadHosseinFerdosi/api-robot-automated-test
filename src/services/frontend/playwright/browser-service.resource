*** Settings ***
Library         Browser
Library         Collections
Library         OperatingSystem
Library         String
Variables       data/CONSTANTS.yaml


*** Keywords ***
Start Browser Session
    [Documentation]    Launch or attach to a browser, create context/page, open URL.
    ...    Args:
    ...
    ...    - ${url}: target URL.
    ...
    ...    - ${browser_alias}: CHROME|HEADLESS_CHROME|FIREFOX|HEADLESS_FIREFOX|EDGE|HEADLESS_EDGE.
    ...
    ...    - ${is_remote}: ${True} to connect to a WS endpoint; otherwise launch locally.
    ...
    ...    - ${ws_endpoint}: WebSocket endpoint when ${is_remote} is ${True}.
    ...    ...
    ...    - ${resolution}: dict {"width":int,"height":int} for initial viewport; ${None} keeps Playwright default.
    ...
    ...    - ${context_options}: extra kwargs for New Context (dict).
    ...
    ...    - ${launch_args}: list of browser launch flags (Chromium/Edge support most; Firefox/WebKit may ignore)
    [Arguments]
    ...    ${url}
    ...    ${browser_alias}
    ...    ${is_remote}=${False}
    ...    ${ws_endpoint}=${None}
    ...    ${resolution}=${None}
    ...    ${context_options}=${None}
    ...    ${launch_args}=${None}

    Set Browser Timeout    ${DEFAULT_BROWSER_TIMEOUT}

    ${engine}    ${headless}   Resolve Browser Alias    ${browser_alias}

    ${browser_info}    New Browser
    ...    ${engine}
    ...    headless=${headless}
    ...    args=${launch_args}

    IF    ${is_remote}
        Should Not Be Empty    ${ws_endpoint}    msg=ws_endpoint is required when is_remote is True.
        Connect To Browser    wsEndpoint=${ws_endpoint}
    END

    ${co}    Ensure Dict Or Empty    ${context_options}
    ${vp}    Build Viewport From Resolution    ${resolution}
    IF    ${vp} != ${None}    Set To Dictionary    ${co}    viewport=${vp}

    New Context    &{co}
    ${page_info}    New Page    ${url}

    RETURN    ${browser_info}    ${page_info}

Close Browser By Id
    [Documentation]    Close a specific browser by its id (string returned from New Browser or Connect To Browser).
    ...
    ...    > The Browser/Page closes by default once the test execution is concluded.
    [Arguments]    ${browser_id}
    Switch Browser    ${browser_id}
    Close Browser

Close Page By Id
    [Documentation]    Close a specific page by its id (string returned from New Page).
    ...
    ...    > The Browser/Page closes by default once the test execution is concluded.
    [Arguments]    ${page_id}
    Switch Page    ${page_id}
    Close Page

Resolve Browser Alias
    [Documentation]    Maps alias to Browser config. Returns: ${engine}, ${headless}.
    [Tags]    robot:private
    [Arguments]    ${alias}
    ${alias}    Convert To Upper Case    ${alias}
    ${engine}    Set Variable    chromium
    ${headless}    Set Variable    ${False}
    IF    '${alias}'=='CHROME'
        ${engine}    Set Variable    chromium
        ${headless}    Set Variable    ${False}
    ELSE IF    '${alias}'=='HEADLESSCHROME'
        ${engine}    Set Variable    chromium
        ${headless}    Set Variable    ${True}
    ELSE IF    '${alias}'=='FIREFOX'
        ${engine}    Set Variable    firefox
        ${headless}    Set Variable    ${False}
    ELSE IF    '${alias}'=='HEADLESSFIREFOX'
        ${engine}    Set Variable    firefox
        ${headless}    Set Variable    ${True}
    ELSE IF    '${alias}'=='EDGE'
        ${engine}    Set Variable    chromium
        ${headless}    Set Variable    ${False}
    ELSE IF    '${alias}'=='HEADLESSEDGE'
        ${engine}    Set Variable    chromium
        ${headless}    Set Variable    ${True}
    ELSE
        Fail    Unsupported browser alias: ${alias}
    END
    RETURN    ${engine}    ${headless}

Build Viewport From Resolution
    [Documentation]    If ${resolution} is a dictionary with keys "width" and "height",
    ...    return a viewport dictionary {width: W, height: H}.
    ...    If ${resolution} is ${None}, return ${None}.
    [Tags]    robot:private
    [Arguments]    ${resolution}
    ${is_none}    Run Keyword And Return Status    Should Be Equal    ${resolution}    ${None}
    IF    ${is_none}    RETURN    ${None}
    Dictionary Should Contain Key    ${resolution}    width
    Dictionary Should Contain Key    ${resolution}    height
    ${viewport}    Create Dictionary    width    ${resolution['width']}    height    ${resolution['height']}
    RETURN    ${viewport}

Ensure Dict Or Empty
    [Documentation]    Return {} if ${maybe_dict} is ${None}, otherwise return ${maybe_dict} unchanged.
    [Tags]    robot:private
    [Arguments]    ${maybe_dict}
    ${is_none}    Run Keyword And Return Status    Should Be Equal    ${maybe_dict}    ${None}
    IF    ${is_none}
        ${maybe_dict}    Create Dictionary
    END
    RETURN    ${maybe_dict}
