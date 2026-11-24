# Robot Framework Resource Keywords Documentation


This document provides a minimal documentation for the 

## Table of Contents

- [pin-service](#-pin-service)

- [walkthrough](#-walkthrough)

- [browser-service](#browser-service)

- [front-auth-service](#front-auth-service)



## pin service

Solves the pin.

### Enter Pin - UI
**Description:** This Keywords, given a `${pin_code}`, tries to enter in in an E2E manner. Meaning It will click on the pin password selector and enters the pin
**Arguments:**
- ``${pin_code}``

Clicks on the element `css=#password` and Fill it with the text `${pin}`.

### Enter Pin - API
**Description:** This Keywords, given a ${pin_code}, tries to enter in in an API call manner. Meaning It will call the API that is responsible for the user login.
**Arguments:**
- ``${cell_number}``
- ``${pin_code}``
- ``${api_call_side}=${APP_SIDE}``

It will call the `POST Users Login` API and checks if the user has been activated.


## walkthrough

Skips the walkthrough and onboarding in the hub.

### Skip Walkthrough - UI
**Description:** This keywords aims to skip the walkthrough process in an E2E manner, meaning *Given the element existence*,
**Arguments:**
- ``${skip_hub_onboarding}=${True}``

It will find the button with selector `css=ngx-button.close-btn button` and clicks on it. 

> Only skips the hub walkthrough

If `${skip_hub_onboarding}` is given, then manually skips the hub onboarding as well by clicking on the appropriate buttons. 

### Skip Walkthrough - Local Storage
**Description:** This keywords aims to skip the walkthrough process via local storage manipulation, meaning it will set their values to their final state.
**Arguments:**
- ``${skip_hub_onboarding}=${True}``

Updated the local storage and skips all onboarding throughout the app (not just hub)

> Remember to use strings for all values you set in the local storage


## browser-service

Core Browser service, intended for initialization and teardown on UI tests using playwright services.

### Start Browser Session
**Description:** Launch or attach to a browser, create context/page, open URL.
**Arguments:**
- ``${url}`` : target URL
- ``${browser_alias}`` : CHROME|HEADLESS_CHROME|FIREFOX|HEADLESS_FIREFOX|EDGE|HEADLESS_EDGE.
- ``${is_remote}=${True}`` : `${True}` to connect to a WS endpoint; otherwise launch locally.
- ``${ws_endpoint}=${None}`` : WebSocket endpoint when `${is_remote}` is `${True}`.
- ``${resolution}=${None}`` : dict `{"width":int,"height":int}` for initial viewport; `${None}` keeps Playwright default.
- ``${context_options}=${None}`` : extra `kwargs` for New Context (dict). > [Check the official documentations]
- ``${launch_args}=${None}``: list of browser launch flags (Chromium/Edge support most; Firefox/WebKit may ignore)

Returns `${browser_info}`  and  `${page_info}`
```bash
${browser_info}    New Browser
    ...    ${engine}
    ...    headless=${headless}
    ...    args=${launch_args}

${page_info}    New Page    ${url}
```
### Close Browser By Id
**Description:** Close a specific browser by its id (string returned from New Browser or Connect To Browser).
**Arguments:**
- ``${browser_id}``

### Close Page By Id
**Description:** Close a specific page by its id (string returned from New Page).
**Arguments:**
- ``${page_id}``

### Resolve Browser Alias
**Description:** Maps alias to Browser config.
**Arguments:**
- ``${alias}``

The `${alias}` is found in the `${CONSTANTS.yaml}`.

Returns: 
- `${engine}`:browser type    
- `${headless}`:boolean    


### Build Viewport From Resolution
**Description:** If `${resolution}` is a dictionary with keys "width" and "height",
**Arguments:**
- ``${resolution}``

### Ensure Dict Or Empty
**Description:** Return {} if `${maybe_dict}`is `${None}`, otherwise return `${maybe_dict}` unchanged.
**Arguments:**
- ``${maybe_dict}``

## front-auth-service

### UI Login To App
**Description:** Logs into the app using the specified method (`${type}`), with inputs: `${cell_number}`, `${pin_code}`, `${skip_walk_through}`;

If `${type}` is `API`, then follows an API based approach to login to app (still a UI process); otherwise does an E2E process and manually insert user info into the login page and clicks on the login. 

> Handles negative cases as well. 

### UI Login To Dashboard
**Description:** Logs into the dashboard using the specified method (`${type}`), with inputs: `${user_name}`, `${password}`;

If `${type}` is `API`, then follows an API based approach to login to dashboard (still a UI process); otherwise does an E2E process and manually insert user info into the login page and clicks on the login. 

> Handles negative cases as well. 

### API Login To App Handler
**Description:** This handler provides the core utility to log in to the base app via an API call. The procedure is as follows:

1. Log in to the app and retrieve relevant information such as device_id, access_token, and refresh_token.
2. Clear the local storage.
3. Set the retrieved information in local storage.
4. Reload the page.

Returns: The storage configuration.

### APP Login To App Handler
**Description:** This handler provides the core utility to log in to the base app via an APP intended process. The procedure is as follows:

1. Enter the cell number.
2. Retrieve the OTP from Redis.
3. Enter the OTP.
4. Enter The Pin If Required.
5. Wait For The Hub Page To Load

Returns: The Current URL

### API Login To DASHBOARD Handler
**Description:** This handler provides the core utility to log in to the dashboard via an API call. The procedure is as follows:

1. Log in to the dashboard and retrieve relevant information such as device_id, access_token, and refresh_token.
2. Call The permission API and retrieve its results.
3. Clear the local storage.
4. Set the retrieved information in local storage.
5. Reload the page.
    
Returns: The storage configuration.


### APP Login To DASHBOARD Handler
**Description:** This handler provides the core utility to log in to the dashboard via an APP intended process. The procedure is as follows:

1. Enter Username And Password
2. Click Confirm
3. Wait to be at dashboard home page

Returns: The current url.