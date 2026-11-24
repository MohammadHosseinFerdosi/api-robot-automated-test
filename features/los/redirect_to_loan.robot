*** Settings ***
Resource            steps/LOS/redirect_to_loan.resource

Suite Setup         Init Browser
Suite Teardown      Close All Browsers


*** Test Cases ***
redirect to loan home page
    [Tags]    redirect to credit home page
    Given I am login to app
    When I click on loan Item
    Then I should redirect to loan page
