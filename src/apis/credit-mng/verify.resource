*** Settings ***
Library         String                                         # Include String library for string manipulation
Library         Collections                                    # Include Collections library for working with collections
Library         RequestsLibrary                                # Include RequestsLibrary for making HTTP requests
Variables       data/CONSTANTS.yaml                 # Include a YAML file with constants               # Include a YAML file with environment-specific variables
Resource        services/backend/session-service.resource   # Include a resource file for session services

*** Keywords ***
POST Purchases Verify Purchase
    [Documentation]    Verifies a purchase using a transaction ID and a type.  # Describes the purpose of the keyword
    [Arguments]        # Declare arguments for the keyword
    ...    ${api_call_side}   # Side from which API is called
    ...    ${tracking_code}  # Transaction ID to verify
    ...    ${transaction_type}            # Type of the transaction

    ${api_path}=    Set Variable    /purchases/verify   # Set the base API path for purchase verification

    # Conditional logic based on the side of the API call
    IF    '${api_call_side}' == '${MICROSERVICE_SIDE}'
        # If the call is from the microservice side, modify the API path accordingly
        ${api_path}=    Set Variable    ${GATEWAY_PATH}${api_path}/${tracking_code}?type=${type}
    ELSE
        # Otherwise, use the standard API path
        ${api_path}=    Set Variable    ${api_path}/${tracking_code}?type=${transaction_type}
    END

    ${body}=    Create Dictionary    # Create a dictionary for the request body. Add necessary parameters here.

    ${session}=    Create A Session    ${api_call_side}   # Create a session for the API call

    # Make a POST request on the created session
    ${response}=    POST On Session
    ...    ${session}
    ...    ${api_path}
    ...    json=${body}
    ...    expected_status=any   # Allow any response status

    # Create a dictionary with response details
    ${result}=    Create Dictionary    status_code=${response.status_code}    body=${response.json()}
    [Return]    ${result}   # Return the result dictionary

    [Teardown]    Delete A Session    ${session}   # Teardown step to delete the session after the keyword execution
