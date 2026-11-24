*** Settings ***
Library     Collections
Library     String
Resource    services/backend/auth-service.resource
Resource    apis/tgs/post-tickets-business-aggregate.resource
Resource    steps/merchant-credit/utilities/common-step.resource


*** Keywords ***
Run Aggregate Ticket And Check Response
    [Arguments]    ${testcase_type}    ${body}    ${status_code}    ${status_result}    ${level}

    ${GUID}    Evaluate    str(uuid.uuid4())    modules=uuid
    Set Global Variable    ${GUID}

    ${requestBodyJson}    Convert To Dictionary    ${body}

    IF    '${TEST_NAME}'=='Null Provider Id'
        Set To Dictionary    ${requestBodyJson}    providerId    ${EMPTY}
    ELSE IF    '${requestBodyJson['providerId']}'=='${EMPTY}'
        Set To Dictionary    ${requestBodyJson}    providerId    ${GUID}
    END

# login for call aggregate ticket
    Login For Business    ${PLATFORM_UESERNAME}    ${PLATFORM_PASSWORD}

# run aggregate ticket
    ${response}    Post Aggregate Ticket    ${GENERAL_SIDE}    ${requestBodyJson}    WEB    2022-02-02
    Set Test Variable    ${response}
# Assertions
    Should Be Equal As Integers    ${response['status_code']}    ${status_code}
    Should Be Equal As Integers    ${response['body']['result']['status']}    ${status_result}
    Should Be Equal As Strings    ${response['body']['result']['level']}    ${level}

    ${is_positive_testcase}    Evaluate    'POSITIVE' in '${testcase_type}'

    IF    ${is_positive_testcase}
        Should Start With    ${response['body']['ticket']}    v2
        Should Not Be Empty    ${response['body']['redirectUrl']}
    END
