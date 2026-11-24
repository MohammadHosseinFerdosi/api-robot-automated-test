*** Settings ***
Library     Collections
Resource    services/backend/auth-service.resource
Resource    apis/purchase-mng/refund/get-purchases-refunds-inquiry-id.resource


*** Keywords ***
Run refund inquiry with providerId and trakingCode and check response
    [Arguments]    ${testcase_name}    ${refund_inquiry_id_type}    ${refund_inquiry_Id}

# login for call refund inquiry
    Login For Business    ${PLATFORM_UESERNAME}    ${PLATFORM_PASSWORD}

# run refund Inquiry
    ${response}    GET Purchases Refunds Inquiry Id    ${GENERAL_SIDE}    ${refund_inquiry_id}    ${PLATFORM_UESERNAME}
    Set Test Variable    ${response}

# Assertion for status and inquiry id
    ${is_Valid_Inquiry_id_type}    Evaluate    'InValid' in '${testcase_name}'
    IF    ${is_Valid_Inquiry_id_type}
        Should Be Equal As Integers    ${response['status_code']}    422
        Should Be Equal As Integers    ${response['body']['result']['status']}    1121
    ELSE
        Should Be Equal As Integers    ${response['status_code']}    200
        Should Be Equal As Integers    ${response['body']['result']['status']}    0
        
        ${is_Provider_id}    Evaluate    'providerId' in '${refund_inquiry_id_type}'
        IF    ${is_Provider_id}
            Should Be Equal As Strings    ${refund_inquiry_Id}    ${response['body']['providerId']}
        ELSE
            Should Be Equal As Strings    ${refund_inquiry_Id}    ${response['body']['trackingCode']}
        END
        Should Be Equal As Integers    ${response['body']['status']}    0
        Should Be Equal As Integers    ${response['body']['resultCode']}    0

        ${wallet_refund}    Evaluate    'Wallet' in '${testcase_name}'
        ${iban_refund}    Evaluate    'Iban' in '${testcase_name}'
        IF    ${wallet_refund}
            Should Be Equal As Integers    ${response['body']['destinationType']}    2
        ELSE IF    ${iban_refund}
            Should Be Equal As Integers    ${response['body']['destinationType']}    1
            Should Not Be Empty    ${response['body']['destination']}
        END
    END

Run Refund inquiry with Different Refund's Username
    [Arguments]    ${refund_inquiry_id_type}    ${refund_inquiry_id}

# login for call refund inquiry
    Login For Business    ${COMPANY_USERNAME}    ${COMPANY_PASSWORD}

# run refund Inquiry
    ${response}    GET Purchases Refunds Inquiry Id    ${GENERAL_SIDE}    ${refund_inquiry_id}    ${PLATFORM_UESERNAME}
    Set Test Variable    ${response}

# Assertion Different Refund's Username
    ${is_Provider_id}    Evaluate    'ProviderId' in '${refund_inquiry_id_type}'
    IF    ${is_Provider_id}
        Should Be Equal As Integers    ${response['status_code']}    422
        Should Be Equal As Integers    ${response['body']['result']['status']}    1121
    ELSE
        Should Be Equal As Integers    ${response['status_code']}    200
    END
