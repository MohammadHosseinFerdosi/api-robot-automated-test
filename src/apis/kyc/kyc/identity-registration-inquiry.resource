*** Settings ***
Resource        services/backend/session-service.resource



*** Keywords ***
POST Kyc Identity Registration Inquiry
    [Arguments]
    ...    ${api_call_side}
    ...    ${requester_app_name}
    ...    ${force_inquiry}
    ...    ${strong_validation}
    ...    ${national_code}
    ...    ${birth_date}
    ...    ${inquiry_type}

    &{body}    Create Dictionary    
    ...    nationalCode    ${national_code}
    ...    birthDate    ${birth_date}
    ...    forceInquiry    ${force_inquiry}
    ...    inquiryType    ${inquiry_type}
    ...    strongValidation    ${strong_validation}
    
    ${api_path}    Set Variable    ${MS_KYC_PATH}/kyc/identity/registration/inquiry

    &{header}    Create Dictionary
    ...    Requester-App-Name=${requester_app_name}

    ${session}    Create A Session    ${api_call_side}
    ${response}    POST On Session
    ...    ${session}
    ...    ${api_path}
    ...    headers=&{header}
    ...    json=&{body}
    ...    expected_status=any

    &{result}    Create Dictionary    status_code=${response.status_code}    body=${response.json()}

    RETURN    &{result}

    [Teardown]    Delete A Session    ${session}
