*** Settings ***
Resource     steps/tms/account/daily-fixed-calculations-account-step.resource
Resource     services/backend/session-service.resource


*** Test Cases ***
[TC-001] Succussfully Daily Calculations Account
      [Tags]     severity:high    e2e    regression    sanity
      When Update Database From Calculate Account
      Then Verify Calculation In Database