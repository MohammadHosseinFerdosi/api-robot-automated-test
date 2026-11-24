*** Settings ***
Resource    steps/LOS/credit-plans.resource


*** Test Cases ***
Correct redirect to steper with credit id generation from microservices side
    [Documentation]    This testcase Checks get plan api functionality overall when calling from microservices side
    [Tags]    los    credit    get plan    from microservices side
    When the user saw plans from MICROSERVICE_SIDE
    Then the correct data should show to user

Correct redirect to steper with credit id generation from app side
    [Documentation]    This testcase Checks get plan api functionality overall when calling from app side
    [Tags]    los    credit    get plan from app side
    Given the user is logged in to the app
    When the user saw plans from APP_SIDE
    Then the correct data should show to user

existance of public plan
    [Documentation]    This testcase Checks existance of public plan
    [Tags]    los    credit    existanse of a public plan 
    When the user saw plans from MICROSERVICE_SIDE
    Then plans has a public plan available

existance of platform fundprovider
    [Documentation]    This test Checks existance of platform rules and plans
    [Tags]    los    credit    existanse of a platform plan
    When the user saw plans from MICROSERVICE_SIDE
    Then it should contain platform fund provider