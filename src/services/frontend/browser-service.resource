*** Settings ***
Library         SeleniumLibrary    plugins=SeleniumTestability;True;10 Seconds;True
Library         library/browser_downloader.py
Variables       data/CONSTANTS.yaml

Library         Collections

*** Keywords ***
Connect To Browser
    [Arguments]
    ...    ${url}                  # The URL to open in the browser.
    ...    ${browser}              # The browser to use (e.g., Chrome, Firefox).
    ...    ${is_remote}=${False}   # Boolean indicating whether the browser is remote. Default is False.
    ...    ${option}=${None}       # Browser-specific options (optional).
    ...    ${desired_capabilities}=${None}     # Desired capabilities for the browser (optional).
    ...    ${ff_profile_dir}=${None}       # Firefox profile directory (optional).

    # Documentation:
    # This keyword initializes a browser session. It either downloads and opens a local browser
    # or connects to a remote Selenium Grid session based on the value of ${is_remote}.
    #
    # Arguments:
    # 1. ${url} - The target URL to be opened in the browser.
    # 2. ${browser} - The browser to use (e.g., Chrome, Firefox).
    # 3. ${is_remote} - A flag indicating whether to connect to a remote Selenium Grid.
    #    - If True, connects to the Selenium Grid via GRID_REMOTE_URL.
    #    - If False, downloads and launches the browser locally.
    # 4. ${option}, ${desired_capabilities}, ${ff_profile_dir} - Optional arguments for browser customization.
    #
    # Steps:
    # 1. If ${is_remote} is False, download the browser binary.
    # 2. If ${is_remote} is True, set the remote URL to GRID_REMOTE_URL for connecting to the Selenium Grid.
    # 3. Open the browser using the specified parameters.

    # Download browser only if not remote
    IF    ${is_remote} == ${False}
        Download Browser    browser=${browser}
    END

    # Set the Selenium Grid remote URL if needed
    ${remote_url}    Set Variable    ${False}
    IF    ${is_remote} == ${True}
        ${remote_url}    Set Variable    ${GRID_REMOTE_URL}    # GRID_REMOTE_URL connects to the Selenium Grid.
    END

    # Open the browser session
    Open Browser
    ...    ${url}
    ...    browser=${browser}
    ...    options=${option}
    ...    desired_capabilities=${desired_capabilities}
    ...    ff_profile_dir=${ff_profile_dir}
    ...    remote_url=${remote_url}
