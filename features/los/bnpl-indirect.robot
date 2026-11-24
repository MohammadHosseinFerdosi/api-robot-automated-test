*** Settings ***
Resource        steps/LOS/bnpl-indirect.resource

Suite Setup     Getting Token

*** Test Cases ***
[TC-001] User Successfully Allocated [Indirect API]
    Given User is successfully allocated in Indirect Journey 
    When Plans API is called successfully (Indirect) 
    And Pre-Register API is called successfully (Indirect)
    And Profile In-Progress API is called successfully (Indirect)
    And Users Profile API is called successfully (Indirect)
    And SMC Init API is called successfully (Indirect)
    Then User is successfully allocated (Indirect)
