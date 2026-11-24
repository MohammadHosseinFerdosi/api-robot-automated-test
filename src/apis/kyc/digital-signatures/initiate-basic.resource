*** Settings ***
Resource    services/backend/session-service.resource


*** Keywords ***
POST Digital Signatures Initiate Basic
    [Arguments]
    ...    ${api_call_side}
    ...    ${requester_app_name}
    ...    ${user_id}
    ...    ${digital_signature_user_data}
    ...    ${custom_video_text}=None
    ...    ${with_password}=${True}

    &{body}    Create Dictionary
    ...    birthDate    ${digital_signature_user_data['birthDate']}
    ...    name    ${digital_signature_user_data['name']}
    ...    englishName    ${digital_signature_user_data['englishName']}
    ...    nationalCard    ${digital_signature_user_data['nationalCard']}
    ...    postalCode    ${digital_signature_user_data['postalCode']}
    ...    type    ${digital_signature_user_data['type']}
    ...    livenessType    ${digital_signature_user_data['livenessType']}
    ...    gender    ${digital_signature_user_data['gender']}

    IF    ${with_password}
        Set To Dictionary    ${body}    password    ${digital_signature_user_data['password']}
    END

    IF    '${custom_video_text}' != 'None'
        Set To Dictionary    ${body}    customVideoText    ${custom_video_text}
    ELSE
        Set To Dictionary    ${body}    customVideoText    ${digital_signature_user_data['customVideoText']}
    END

    ${api_path}    Set Variable    ${MS_DIGITAL_SIGNATURE_PATH}/digital-signatures/initiate/basic

    &{header}    Create Dictionary
    ...    Requester-App-Name=${requester_app_name}
    ...    User-Id=${user_id}

    ${session}    Create A Session    ${api_call_side}
    ${response}    POST On Session
    ...    ${session}
    ...    ${api_path}
    ...    headers=&{header}
    ...    json=${body}
    ...    expected_status=any

    ${result}    Create Dictionary    status_code=${response.status_code}    body=${response.json()}

    RETURN    ${result}

    [Teardown]    Delete A Session    ${session}
