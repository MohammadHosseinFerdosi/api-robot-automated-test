*** Settings ***
Resource        steps/LOS/bnpl-allocation.resource
Resource        apis/los/bnpl/post-business-tac-general.resource
Variables       data/los/bnpl.yaml


*** Keywords ***
Check TAC by API
    [Documentation]    Call POST TAC BNPL and return the Boolean value of *shouldAccept*.
    [Arguments]    ${external_requester_id}    ${cell_number}    ${national_code}
    Login For Business    username=${BNPL_CO_USER_NAME}    password=${BNPL_CO_USER_PASSWORD}

    ${response}=    POST Business TAC General
    ...    external_requester_id=${external_requester_id}
    ...    cell_number=${cell_number}
    ...    national_code=${national_code}
    ...    api_call_side=${APP_SIDE}
    RETURN    ${response.json()['shouldAccept']}

Does TAC Document Exist
    [Documentation]    True ↦ at least one matching record in *switch_credit_db.user_tac*;
    ...    False ↦ none.
    [Arguments]    ${tac_version}    ${external_requester_id}    ${national_code}    ${cell_number}
    ${DB}=    Set Variable    switch_credit_db
    ${COLL}=    Set Variable    user_tac
    ${query}=    Create Dictionary
    ...    tacVersion=${tac_version}
    ...    externalRequesterId=${external_requester_id}
    ...    nationalCode=${national_code}
    ...    cellNumber=${cell_number}
    ${res}=    Mongo Db Find One    ${DB}    ${COLL}    ${query}
    ${exists}=    Run Keyword And Return Status    Should Not Be Empty    ${res['body']}
    RETURN    ${exists}

Upsert User Tac
    [Documentation]    Insert or update a TAC record.
    ...    *tac_version* is handled as **string** throughout.
    [Arguments]    ${tac_version}    ${external_requester_id}    ${national_code}    ${cell_number}
    ${DB}=    Set Variable    switch_credit_db
    ${COLL}=    Set Variable    user_tac

    ${query}=    Create Dictionary
    ...    tacVersion=${tac_version}
    ...    externalRequesterId=${external_requester_id}
    ...    nationalCode=${national_code}
    ...    cellNumber=${cell_number}

    ${find_res}=    Mongo Db Find One    ${DB}    ${COLL}    ${query}
    ${exists}=    Run Keyword And Return Status    Should Not Be Empty    ${find_res['body']}

    IF    ${exists}
        ${update}=    Set Variable    {"$set": ${query}}
        ${result}=    Mongo Db Update One    ${DB}    ${COLL}    ${query}    ${update}
    ELSE
        ${doc}=    Copy Dictionary    ${query}
        Set To Dictionary    ${doc}
        ...    ip=172.30.5.253
        ...    _class=com.platform.creditonboarding.model.tac.UserTac
        ...    acceptedTime=1625549325296
        ...    userId=userId_1234567890
        ${result}=    Mongo Db Insert One    ${DB}    ${COLL}    ${doc}
    END
    RETURN    ${result}

Setup User informations Except TAC version By Suite Variable
    Set Suite Variable    ${externalRequesterId}    ${TAPSI_EXTERNAL_REQUESTER_ID}
    Set Suite Variable    ${nationalCode}    ${BNPL_TAC_NATIONAL_CODE}
    Set Suite Variable    ${cellNumber}    ${BNPL_TAC_CELL_NUMBER}

the user's TAC version is higher than the business TAC version
    ${user_tac_version}=    Evaluate    str(int(${BNPL_BIZ_TAC_VERSION}) + 1)
    Set Suite Variable    ${user_tac_version}

the user's TAC version is lower than the business TAC version
    ${user_tac_version}=    Evaluate    str(int(${BNPL_BIZ_TAC_VERSION}) - 1)
    Set Suite Variable    ${user_tac_version}

the user's TAC version is equal to the business TAC version
    ${user_tac_version}=    Convert To String    ${BNPL_BIZ_TAC_VERSION}
    Set Suite Variable    ${user_tac_version}

we apply our query is based on nationalCode, cellNumber, externalRequesterId, and the TAC version set by the business
    Upsert User Tac
    ...    tac_version=${user_tac_version}
    ...    external_requester_id=${externalRequesterId}
    ...    national_code=${nationalCode}
    ...    cell_number=${cellNumber}

    ${exist_in_db}=    Does TAC Document Exist
    ...    tac_version=${user_tac_version}
    ...    external_requester_id=${externalRequesterId}
    ...    national_code=${nationalCode}
    ...    cell_number=${cellNumber}

    IF    not ${exist_in_db}
        Fail    TAC document does not exist in the database. Fix automation code or check the DB.
    END

we check if the TAC should be accepted using the API too
    ${should_accept}=    Check TAC by API
    ...    external_requester_id=${externalRequesterId}
    ...    cell_number=${cellNumber}
    ...    national_code=${nationalCode}
    Set Suite Variable    ${should_accept}

the API response should indicate that the TAC should be accepted
    IF    not ${should_accept}
        Fail    The TAC should not be accepted, but it was.
    END

the API response should indicate that the TAC should not be accepted
    IF    ${should_accept}
        Fail    The TAC should be accepted, but it was not.
    END

Delete Created User Tacs from DB
    [Documentation]    Delete all user TACs created during the test to prepare next test cases.
    ${filter_query}=    Create Dictionary    cellNumber=${BNPL_TAC_CELL_NUMBER}
    Mongo Db Delete Many    db_name=switch_credit_db    collection_name=user_tac    filter_query=${filter_query}
