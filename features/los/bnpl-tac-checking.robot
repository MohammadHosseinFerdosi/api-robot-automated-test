*** Settings ***
Resource            steps/LOS/bnpl-tac-cheking.resource

Test Setup          Setup User informations Except TAC version By Suite Variable
Test Teardown       Delete Created User Tacs from DB


*** Test Cases ***
User's TAC version is higher than the business's business TAC version
    Given the user's TAC version is higher than the business TAC version
    And we apply our query is based on nationalCode, cellNumber, externalRequesterId, and the TAC version set by the business
    When we check if the TAC should be accepted using the API too
    Then the API response should indicate that the TAC should be accepted

User's TAC version is lower than the business's business TAC version
    Given the user's TAC version is lower than the business TAC version
    And we apply our query is based on nationalCode, cellNumber, externalRequesterId, and the TAC version set by the business
    When we check if the TAC should be accepted using the API too
    Then the API response should indicate that the TAC should be accepted

User's TAC version is equal to the business's business TAC version
    Given the user's TAC version is equal to the business TAC version
    And we apply our query is based on nationalCode, cellNumber, externalRequesterId, and the TAC version set by the business
    When we check if the TAC should be accepted using the API too
    Then the API response should indicate that the TAC should not be accepted
