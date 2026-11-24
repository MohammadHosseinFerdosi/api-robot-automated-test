*** Settings ***
Resource    steps/merchant-credit/utilities/settlement-utilities.resource


*** Keywords ***
Initiate Settlement Request As Iran Venezuela User
    [Arguments]
    ...    ${amount}
    ${result}    Create Settlement    ${REGISTRATION_ID}    10    ${amount}
    Should Be Equal As Integers    ${result['status_code']}    200
