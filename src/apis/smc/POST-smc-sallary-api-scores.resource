*** Settings ***
Library         Collections
Library         string
Library         JSONLibrary
Library         RequestsLibrary
Variables       data/CONSTANTS.yaml
Variables       data/smc/score.yaml
Resource        services/backend/session-service.resource

*** Keywords ***
POST SMC Sllary API Scores
    [Documentation]    POST Test Score User for Sallry
    [Arguments]  
    ...   ${scoreType}
    ...   ${nationalCode}
    ...   ${cellNumber}
    ...   ${trackingCode}
    ...   ${serviceType}

    ${api_path}   Set Variable    /smc/platform/api/scores

    ${body}    Create Dictionary
    ...   scoreType=${scoreType}
    ...   nationalCode=${nationalCode}
    ...   cellNumber=${cellNumber}
    ...   trackingCode=${trackingCode}
    ...   serviceType=${serviceType}

    ${session}    Create A Session   ${MICROSERVICE_SIDE}

    ${response}   POST On Session    ${session}
    ...    ${api_path}
    ...    json=${body}
    ...    expected_status=any

    ${result}    Create Dictionary    status_code=${response.status_code}  body=${response.json()}
    Set Test Variable   ${result}
    RETURN    ${result}

    [Teardown]    Delete A Session    ${session}
