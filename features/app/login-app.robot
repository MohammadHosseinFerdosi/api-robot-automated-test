*** Settings ***
Resource            steps/app/core/app-login-steps.resource

Test Setup          Start Browser
Test Teardown       Close Browser And Reproduce Amounts And Clear The Redis For The User


*** Test Cases ***
User Successful Login To APP Via API Processes With No PIN
    Given A Random User Is Generated
    When Logins To App Via API Calls
    Then Login Returned Status Should Be PASSED
    And Should Be At The HUB Page

User Successful Login To APP Via APP Processes With No PIN
    Given A Random User Is Generated
    When Logins To App Via APP Processes    skip_walkthrough=${True}
    Then Should Be At The HUB Page

User Failed Login To APP Via API Processes With No PIN But Wrong OTP
    Given A Random User Is Generated
    When Logins To App Via API Calls With Wrong OTP
    Then Login Returned Status Should Be Failed
    And Should Not Be At The HUB Page

User Failed Login To APP Via APP Processes With No PIN But Wrong OTP
    Given A Random User Is Generated
    When Logins To App Via APP Processes With Wrong OTP
    Then Should Not Be At The HUB Page

User Successful Login To APP Via API Processes With PIN
    Given A Predefined User With Pin Is Prepared
    When Logins To App Via API Calls With Pin
    Then Login Returned Status Should Be PASSED
    And Should Be At The HUB Page

User Successful Login To APP Via APP Processes With PIN
    Given A Predefined User With Pin Is Prepared
    When Logins To App Via APP Processes With Pin    skip_walk_through=${True}
    Then Should Be At The HUB Page

User Failed Login To APP Via API Processes With Wrong PIN
    Given A Predefined User With Pin Is Prepared
    When Logins To App Via API Calls With Wrong PIN
    Then Login Returned Status Should Be Failed
    And Should Not Be At The HUB Page

User Failed Login To APP Via APP Processes With Wrong PIN
    Given A Predefined User With Pin Is Prepared
    When Logins To App Via APP Processes With Wrong PIN
    Then Should Not Be At The HUB Page
