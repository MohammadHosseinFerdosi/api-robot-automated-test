*** Settings ***
Variables       data/los/credit.yaml
Resource        apis/los/Journey/get-credit-plans.resource
Resource        services/frontend/front-auth-service.resource


*** Keywords ***
the user is logged in to the app
    Login To App    ${CREDIT_CELL_NUMBER}

the user saw plans from MICROSERVICE_SIDE
    ${res}    GET Credit Plans
    ...    ${MICROSERVICE_SIDE}
    ...    ${CREDIT_PLATFORM_VERSION}
    ...    ${CREDIT_USER_ID}
    Should Be Equal As Numbers    ${res['status_code']}    200
    Should Not Be Empty    ${res["body"]}
    Set Suite Variable    ${res}

the user saw plans from APP_SIDE
    ${res}    GET Credit Plans
    ...    ${APP_SIDE}
    ...    ${CREDIT_PLATFORM_VERSION}
    ...    ${CREDIT_USER_ID}
    Set Suite Variable    ${res}
    Should Be Equal As Numbers    ${res['status_code']}    200
    Should Not Be Empty    ${res["body"]}
    Set Suite Variable    ${res}

the correct data should show to user
    Dictionary Should Contain Key    ${res['body']}    planGroupDetails
    Should Not Contain    ${res['body']['planGroupDetails']}    Null

plans has a public plan available
    ${index}    Set Variable
    ${lenght}    Get Length    ${res['body']['planGroupDetails']}
    FOR    ${index}    IN RANGE    ${lenght}
        ${plan_group_detail}    Set Variable    ${res['body']['planGroupDetails'][${index}]['userEntryPoint']}

        ${result1}    Evaluate    ${plan_group_detail} == 1
        IF    ${result1}    BREAK
    END
    Should Be True    ${result1}

it should contain platform fundprovider
    ${index}    Set Variable
    ${lenght}    Get Length    ${res['body']['planGroupDetails']}
    FOR    ${index}    IN RANGE    ${lenght}
        ${plan_group_detail}    Set Variable
        ...    ${res['body']['planGroupDetails'][${index}]['fundProvider']['fundProviderCode']}
        ${result1}    Evaluate    ${plan_group_detail} == 7
        IF    ${result1}    BREAK
    END
    Should Be True    ${result1}
