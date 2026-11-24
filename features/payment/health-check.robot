*** Settings ***
Resource    apis/health-check/health-check-service.resource
Resource    steps/payment/health-check/health-check-step.resource

*** Test Cases ***
Health Check Service Activity For Platform Business Token
    [Documentation]    This Service Checks Activity Of Health Check Service For Platform Business Token
    Given Login And Getting Token For Platform Business
    When Call Health Check Service With Platform Business Token
    Then Check Response Of Health Service With Permissioned Access


Login And Getting Token For Dashboard Token With User Access
    [Documentation]    This Service Checks Activity Of Health Check Service For Platform Dashboard Token
    Given Login And Getting Token For Dashboard Token With User Access
    When Call Health Check Service With Platform Dashboard Token
    Then Check Response Of Health Service With Permissioned Access


Health Check Service Activity For Platform Dashboard Token With Admin Access
    [Documentation]    This Service Checks Activity Of Health Check Service For Platform Dashboard Token
    Given Login And Getting Token For Dashboard With Admin Access
    When Call Health Check Service With Platform Dashboard Token
    Then Check Response Of Health Service With Permissioned Access


Health Check Service Activity For Platform Dashboard Token With User Access
    [Documentation]    This Service Checks Activity Of Health Check Service For Platform Dashboard Token
    Given Login And Getting Token For Dashboard Token With User Access
    When Call Health Check Service With Platform Dashboard Token
    Then Check Response Of Health Service With Permissioned Access


Health Check Service Activity For Platform App Token
    [Documentation]    This Service Checks Activity Of Health Check Service
    Given Login And Getting Token For Platform App
    When Call Health Check Service With Platform App Token
    Then Check Response Of Health Service With Permissioned Access


Health Check Service Activity For Company Business Token
    [Documentation]    This Service Checks Activity Of Health Check Service For Company Business Token
    Given Login And Getting Token For Company Business
    When Call Health Check Service With Platform Business Token
    Then Check Response Of Health Service With Permissioned Access



Business Health Check Service Activity For Company Business Token
    [Documentation]    This Service Checks Activity Of Business Health Check Service For Company Business Token
    Given Login And Getting Token For Company Business
    When Call Business Health Check Service (Company) With Business Token
    Then Check Response Of Business Health Service With Permissioned Access


Business Health Check Service Activity For Platform Business Token
    [Documentation]    This Service Checks Activity Of Business Health Check Service For Company Business Token
    Given Login And Getting Token For Platform Business
    When Call Business Health Check Service (Platform) With Business Token
    Then Check Response Of Business Health Service With Permissioned Access


Business Health Check Service Activity (Platform) For Dashboard Token With User Access
    [Documentation]    This Service Checks Activity Of Business Health Check Service For Dashboard Token With User Access
    Given Login And Getting Token For Dashboard Token With User Access
    When Call Business Health Check Service (Platform) With Dashboard Token
    Then Check Response Of Business Health Service With Denied Access


Business Health Check Service Activity (Company) For Dashboard Token With User Access
    [Documentation]    This Service Checks Activity Of Business Health Check Service For Dashboard Token With User Access
    Given Login And Getting Token For Dashboard Token With User Access
    When Call Business Health Check Service (Company) With Dashboard Token
    Then Check Response Of Business Health Service With Denied Access


Business Health Check Service Activity (Company) For Platform App Token
    [Documentation]    This Service Checks Activity Of Business Health Check Service For Platform App Token
    Given Login And Getting Token For Platform App
    When Call Business Health Check Service (Company) With Platform App Token
    Then Check Response Of Business Health Service With Denied Access


Business Health Check Service Activity (Platform) For Platform App Token
    [Documentation]    This Service Checks Activity Of Business Health Check Service For Platform App Token
    Given Login And Getting Token For Platform App
    When Call Business Health Check Service (Platform) With Platform App Token
    Then Check Response Of Business Health Service With Denied Access

    