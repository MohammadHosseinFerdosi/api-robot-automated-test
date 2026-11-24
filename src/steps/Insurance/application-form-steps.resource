*** Settings ***
Resource        apis/Insurance/post-api-v1-application-form.resource
Variables       data/Insurance/application-form-variables.yml
Resource        services/backend/auth-service.resource


*** Keywords ***
I have license and national code
    Set Test Variable    ${license}    ${LICENSE}
    Set Test Variable    ${national_code}    ${NATIONAL_CODE}

I don't have license and national code
    Set Test Variable    ${license}    ${EMPTY}
    Set Test Variable    ${national_code}    ${EMPTY}

Insurance User Is Logged In
    Login To App    cell_number=${INSURANCE_CELL_NUMBER}    pin_code=${INSURANCE_PIN_CODE}

I send request to create application form
    ${result}=    POST API V1 Application Forms    ${APP_SIDE}    ${license}    ${national_code}    ${DP_USER_ID}
    ${response}=    Set Variable    ${result['body']}
    ${status_code}=    Set Variable    ${result['status_code']}
    Set Test Variable    ${response}
    Set Test Variable    ${status_code}

Application form should be created successfully
    Should Be Equal As Strings    ${status_code}    200
    Should Be True    ${response['success']}
    ${id}=    Set Variable    ${response['result']['id']}
    Length Should Be    ${id}    ${ID_LENGTH}
    Set Suite Variable    ${APPLICATION_FORM_ID}    ${id}
