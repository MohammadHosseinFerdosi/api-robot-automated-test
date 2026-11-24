*** Settings ***
Library         library/faker_utils.py    WITH NAME    FakerLibrary
Library         RequestsLibrary
Resource        apis/lms/credit-core/post-credit-gateway-activate.resource
Resource        apis/lms/credit-core/post-credit-gateways-disable.resource
Variables       data/lms/purchase-bnpl.yaml


*** Keywords ***
Disable Credit Gateway For Merchant On Channel UPG And C-Credit Payment Gateway
    ${disable_response} =    POST Credit Gateway Disable
    ...    ${MICROSERVICE_SIDE}
    ...    ${TEST_BUSINESS_ID}
    ...    ${CHANNEL.UPG}
    ...    ${LMS_PAYMENT_GATEWAY.CPG}
    Set Test Variable    ${disable_response}

Credit Gateway Activate For Merchant On Channel UPG And C-Credit Payment Gateway
    @{repayment_options} =    Create List    ${LMS_REPAYMENT_OPTION.ONEPAY}    ${LMS_REPAYMENT_OPTION.XPAY}
    ${activate_response} =    POST Credit Gateway Activate
    ...    ${MICROSERVICE_SIDE}
    ...    ${TEST_BUSINESS_ID}
    ...    ${CHANNEL.UPG}
    ...    ${LMS_PAYMENT_GATEWAY.CPG}
    ...    0    # trigger_action
    ...    ${DASHBOARD_USERNAME}
    ...    ${repayment_options}
    Set Test Variable    ${activate_response}

Credit Gateway Should Be Activated For Merchant On Channel UPG And C-Credit Payment Gateway
    Should Be Equal As Integers
    ...    ${disable_response['status_code']}
    ...    200
    ...    msg="Expected status code for Credit Gateway Disable API should be 200, and got" ${disable_response['status_code']}
    Should Be Equal As Integers
    ...    ${activate_response['status_code']}
    ...    200
    ...    msg="Expected status code for Credit Gateway Activate API should be 200, and got" ${activate_response['status_code']}
