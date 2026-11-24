*** Settings ***
Resource    steps/payment/companycard/companycard-purchases-in-store-ticket-step.resource
Resource    steps/payment/companycard/companycard-purchases-in-store-ticket-features-select.resource
Resource    steps/payment/companycard/companycard-purchases-in-store-reports-seaech-step.resource

*** Test Cases ***
Success BPG Purchase On Pos Channel 
    [Tags]    severity:high
    Given Login For Business    ${OFFLINE_PAYMENT_USERID}    ${OFFLINE_PAYMENT_PASSWORD}
    When Success Getting Ticket On Pos Terminal
    And Success Select BPG Feature On In-Store Purchase
    Then Get Last Transaction on CompanyCard 


Success CPG Purchase On Pos Channel 
    [Tags]    severity:high
    Given Login For Business    ${OFFLINE_PAYMENT_USERID}    ${OFFLINE_PAYMENT_PASSWORD}
    When Success Getting Ticket On Pos Terminal
    And Success Select CPG Feature On In-Store Purchase
    Then Get Last Transaction on CompanyCard


Get Reports In The Range More Than Two Mounth
    [Tags]     severity:high
    Given Login For Business     ${OFFLINE_PAYMENT_USERID}    ${OFFLINE_PAYMENT_PASSWORD}
    Then Get Transactions on CompanyCard In More Than 60 Days


Get Ticket With Not Related Terminal
    [Tags]    severity:high
    Given Login For Business    ${OFFLINE_PAYMENT_USERID}    ${OFFLINE_PAYMENT_PASSWORD}
    Then Get In-Store Ticket With A TerminalId Not Related To Merchant


Get Ticket With Invalid Hash Pan
    [Tags]    severity:high
    Given Login For Business    ${OFFLINE_PAYMENT_USERID}    ${OFFLINE_PAYMENT_PASSWORD}
    Then Get In-Store Ticket With An Invalid Hashed Pan


Get Ticket With Invalid PSP Code 
    [Tags]    severity:high
    Given Login For Business    ${OFFLINE_PAYMENT_USERID}    ${OFFLINE_PAYMENT_PASSWORD}
    Then Get In-Store Ticket With An Invalid PSP Code


Success Get Ticket And Select A Non-Existent Feature
    [Tags]    severity:high
    Given Login For Business    ${OFFLINE_PAYMENT_USERID}    ${OFFLINE_PAYMENT_PASSWORD}
    When Success Getting Ticket On Pos Terminal
    Then Select A Non-Existent Feature


Success Get Ticket And Select A Feature Then Change Selected Feature
    [Tags]    severity:high
    Given Login For Business    ${OFFLINE_PAYMENT_USERID}    ${OFFLINE_PAYMENT_PASSWORD}
    When Success Getting Ticket On Pos Terminal
    Then Change Selected Feature On In-Store Purchase
    










