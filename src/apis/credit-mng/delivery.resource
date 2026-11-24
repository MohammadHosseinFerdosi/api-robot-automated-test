*** Settings ***
Library         String                                         # Include String library for string manipulation
Library         Collections                                    # Include Collections library for working with collections
Library         RequestsLibrary                                # Include RequestsLibrary for making HTTP requests
Variables       data/CONSTANTS.yaml                 # Include a YAML file with constants              # Include a YAML file with environment-specific variables
Resource        services/backend/session-service.resource  # Include a resource file for session services
*** Keywords ***
POST Purchases Deliver Products
    [Documentation]    Delivers products with given details.
    ...                This keyword handles the delivery process of products by posting to the delivery API.
    [Arguments]        ${api_call_side}
    ...                ${delivery_date}
    ...                ${invoice_number}
    ...                ${tracking_code}
    ...                ${delivery_type}

    # Define the base API path for the delivery
    ${api_path}=    Set Variable    /purchases/deliver

    # Conditional logic to modify the API path based on the side of the API call
    IF    '${api_call_side}' == '${MICROSERVICE_SIDE}'
        # Modify the API path if the call is from the microservice side
        ${api_path}=    Set Variable    ${GATEWAY_PATH}${api_path}?type=${delivery_type}
    ELSE
        # Use the standard API path for other cases
        ${api_path}=    Set Variable    ${api_path}?type=${delivery_type}
    END

    # Create a list of products
    ${products}=    Create List    product-4    product-5    product-6    product-7

    # Create a dictionary for the request body
    ${body}=    Create Dictionary
    ...    deliveryDate=${delivery_date}
    ...    invoiceNumber=${invoice_number}
    ...    trackingCode=${tracking_code}
    ...    products=${products}

    # Create a session for the API call
    ${session}=    Create A Session    ${api_call_side}

    # Perform a POST request with the created session
    ${response}=    POST On Session
    ...    ${session}
    ...    ${api_path}
    ...    json=${body} 
    ...    expected_status=any   # Allow any response status

    # Create a dictionary to store response details
    ${result}=    Create Dictionary    status_code=${response.status_code}    body=${response.json()}

    # Return the result dictionary
    [Return]    ${result}

    # Teardown step to delete the session after the keyword execution
    [Teardown]    Delete A Session    ${session}
