*** Settings ***
Library         String
Library         Collections
Library         RequestsLibrary
Library         JSONLibrary
Resource        services/db/mongo-db-service.resource
Variables       data/merchant-credit/merchant-credit-variables.yaml


*** Keywords ***
Get Merchant Credit Data By Specific Field
    [Documentation]    this keyword helps to get data from mongodb(merchant_credit_db only) from any collections and any criterias, also optimize result for Specific field
    [Arguments]
    ...    ${collection_name}
    ...    ${field}=${EMPTY}
    ...    &{filter_field}

    &{FILLTER}    Create Dictionary    &{filter_field}
    ${RESULTS}    Mongo Db Find    merchant_credit_db    ${collection_name}    ${FILLTER}

    Should Not Be Empty    ${RESULTS}    this document doesn't exist in database

    IF    '${field}'=='${EMPTY}'
        ${mongo_dict}    Set Variable    ${RESULTS}[body][0]
        RETURN    ${mongo_dict}
    ELSE
        ${mongo_dict}    Set Variable    ${RESULTS}[body][0]
        RETURN    ${mongo_dict['${field}']}
    END

Get Merchant Credit Counter Document By Specific Field
    [Arguments]
    ...    ${collection_name}
    ...    ${field}=${EMPTY}
    ...    &{filter_field}

    &{FILLTER}    Create Dictionary    &{filter_field}
    ${RESULTS}    Mongo Db Count Documents    merchant_credit_db    ${collection_name}    ${FILLTER}
    RETURN    ${RESULTS}[body][count]
