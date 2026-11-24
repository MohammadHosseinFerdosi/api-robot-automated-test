*** Settings ***
Resource            steps/app/dashboard/dashboard-login-steps.resource

Test Setup          Start Browser
Test Teardown       End Browser


*** Test Cases ***
User Successful Login To Dashboard Via API Processes
    Given User Has Access To Authenticated Account
    When Logins To Dashboard Via API Calls
    Then Login Returned Status Should Be PASSED
    And Should Be At The Home Page

User Successful Login To Dashboard Via APP Processes
    Given User Has Access To Authenticated Account
    When Logins To Dashboard Via APP Processes
    Then Should Be At The Home Page

User Failed Login To Dashboard Via API Processes
    Given User Does Not Have Access To Authenticated Account
    When Logins To Dashboard Via API Calls
    Then Login Returned Status Should Be Failed
    And Should Not Be At The Home Page

User FAILED Login To Dashboard Via APP Processes
    Given User Does Not Have Access To Authenticated Account
    When Logins To Dashboard Via APP Processes
    Then Should not Be At The Home Page
