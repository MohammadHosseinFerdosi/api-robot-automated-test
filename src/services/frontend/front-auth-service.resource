*** Settings ***
Library     SeleniumLibrary    plugins=SeleniumTestability;True;10 Seconds;False
Resource    services/backend/auth-service.resource
Resource    pages/app/hub.resource


*** Keywords ***

Login To A Specific Account
    [Documentation]    Logs into the application using the given cell number.
    ...    This keyword can log in using either the API or the UI based on the `type` argument.
    ...
    ...    *Arguments:*
    ...    - ``cell_number``: The mobile number of the account to log in with.
    ...    - ``type`` (optional): Determines the login method:
    ...    - ``0``: Login using API (default).
    ...    - ``1``: Login using the UI.
    ...    - ``walk_through`` (optional): Boolean indicating whether to show or skip the app walkthrough.
    ...    - ``False``: Skip the walkthrough (default).
    ...    - ``True``: Do not skip the walkthrough and allow it to complete.
    ...    - ``pin_code`` (optional): The PIN code for accounts that require a PIN.
    ...    If not provided, it defaults to an empty value.
    ...
    ...    *Behavior:*
    ...    - If ``type=0``, performs login using the `Login To App With API` keyword.
    ...    - If ``type=1``, the login should be performed through the UI (this part not currently implemented in the snippet).
    ...    - If ``walk_through=False``, the walkthrough screens will be skipped.
    ...    - If ``walk_through=True``, the walkthrough will be displayed.
    ...    - If the account has a PIN, it should be supplied via `pin_code`.
    ...
    ...    *Examples:*
    ...    | Login To A Specific Account | 1234567890 | 0 | True | 1234 |
    ...    | Login To A Specific Account | 0987654321 | 1 | False |
    [Arguments]    ${cell_number}    ${type}=0    ${walk_through}=False    ${pin_code}=${EMPTY}

    IF    ${type} == 0
    Login To App With API    cell_number=${cell_number}    pin_code=${pin_code}    walk_through=${walk_through}
    END


    Should Be On Hub Page

Login To App With API
    [Documentation]    Logs into the application using the given cell number.
    ...    This keyword logs in using the provided cell number and PIN code, and manages local storage based on the walk-through flag.
    ...
    ...    *Arguments:*
    ...    - ``cell_number``: The mobile number of the account to log in with.
    ...    - ``pin_code`` (optional): The PIN code for accounts that require a PIN. Defaults to empty if not provided.
    ...    - ``walk_through`` (optional): Boolean indicating whether to show or skip the app walkthrough.
    ...    - ``False``: Skip the walkthrough (default).
    ...    - ``True``: Do not skip the walkthrough and allow it to complete.
    ...
    ...    *Behavior:*
    ...    - Performs login via the `Login To App` keyword with the provided cell number and PIN code.
    ...    - Creates and updates local storage items related to authentication and walkthrough steps.
    ...    - If ``walk_through=False``, the walkthrough screens will be skipped and marked as completed.
    ...    - If ``walk_through=True``, the walkthrough items will be removed, allowing the walkthrough to be reset.
    ...    - Updates the local storage with authentication tokens and user device ID.
    ...
    ...    *Examples:*
    ...    | Login To App With API | 1234567890 | 1234 | False |
    ...    | Login To App With API | 0987654321 |    | True |
    [Arguments]    ${cell_number}    ${pin_code}=${EMPTY}    ${walk_through}=False

    Login To App    ${cell_number}    ${pin_code}
    ${auth_params}=    Create Dictionary
    ...    access=${AUTHENTICATED_USER_PARAMETERS['access_token']}
    ...    refresh=${AUTHENTICATED_USER_PARAMETERS['refresh_token']}
    ...    userId=${AUTHENTICATED_USER_PARAMETERS['user_id']}

    ${created_dp_storage}=    Create Dictionary
    ...    navSupported=1
    ...    auth=${auth_params}

    Remove Storage Item    __dp_storage    storage_type=localStorage
    Set Storage Item    __dp_storage    ${created_dp_storage}    storage_type=localStorage

    Remove Storage Item    __dp_machine_id    storage_type=localStorage
    Set Storage Item    __dp_machine_id    ${AUTHENTICATED_USER_PARAMETERS['device_id']}    storage_type=localStorage

    IF    ${walk_through} == False
        Set Storage Item    walk-through-dpx    {"step":"done"}    storage_type=localStorage
        Set Storage Item    hub-walk-through    {"step":"done"}    storage_type=localStorage
        Set Storage Item    profile-walk-through    {"step":"done"}    storage_type=localStorage
        Set Storage Item    stores-walk-through    {"step":"done"}    storage_type=localStorage
        Set Storage Item    transaction-walk-through    {"step":"done"}    storage_type=localStorage
    ELSE IF    ${walk_through} == True
        Remove Storage Item    walk-through-dpx    storage_type=localStorage
        Remove Storage Item    hub-walk-through    storage_type=localStorage
        Remove Storage Item    profile-walk-through    storage_type=localStorage
        Remove Storage Item    stores-walk-through    storage_type=localStorage
        Remove Storage Item    transaction-walk-through    storage_type=localStorage
    END

    Reload Page
