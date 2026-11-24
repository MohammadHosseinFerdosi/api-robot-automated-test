*** Settings ***
Library     library/faker_utils.py    WITH NAME    FakerLibrary
Resource    services/db/mysql-db-service.resource
Resource    services/backend/auth-service.resource


*** Keywords ***
Check If Cell Number Does exist
    [Documentation]    Checks the **users_db** and the **switch_credit_db** :
    ...
    ...    RETURNs `True` if the cell number does exist, otherwise RETURNs `False`
    [Tags]    robot:private
    [Arguments]    ${cell_number}

    ${found_cell_number}    Set Variable    False

    ${switch_credit_search_query}    Set Variable
    ...    SELECT * FROM switch_credit_db.users WHERE cell_number = '${cell_number}'
    ${switch_credit_result}    MySQL Fetch All    db_name=switch_credit_db    query=${switch_credit_search_query}
    ${switch_credit_body}    Set Variable    ${switch_credit_result['body']}
    ${switch_credit_length}    Get Length    ${switch_credit_body}
    IF    '${switch_credit_length}'!='0'
        ${found_cell_number}    Set Variable    True
    END

    ${users_search_query}    Set Variable    SELECT * FROM user_db.users WHERE cell_number = '${cell_number}'
    ${users_result}    MySQL Fetch All    db_name=user_db    query=${users_search_query}
    ${users_body}    Set Variable    ${users_result['body']}
    ${users_length}    Get Length    ${users_body}
    IF    '${users_length}'!='0'
        ${found_cell_number}    Set Variable    True
    END

    RETURN    ${found_cell_number}

Check If National Code Does exist
    [Documentation]    Checks the **users_db** and the **switch_credit_db** :
    ...
    ...    RETURNs `True` if the national code does exist, otherwise RETURNs `False`
    [Tags]    robot:private
    [Arguments]    ${national_code}

    ${found_national_code}    Set Variable    False

    ${switch_credit_search_query}    Set Variable
    ...    SELECT * FROM switch_credit_db.users WHERE national_code = '${national_code}'
    ${switch_credit_result}    MySQL Fetch All    db_name=switch_credit_db    query=${switch_credit_search_query}
    ${switch_credit_body}    Set Variable    ${switch_credit_result['body']}
    ${switch_credit_length}    Get Length    ${switch_credit_body}
    IF    '${switch_credit_length}'!='0'
        ${found_national_code}    Set Variable    True
    END

    ${users_search_query}    Set Variable    SELECT * FROM user_db.users WHERE national_code = '${national_code}'
    ${users_result}    MySQL Fetch All    db_name=user_db    query=${users_search_query}
    ${users_body}    Set Variable    ${users_result['body']}
    ${users_length}    Get Length    ${users_body}
    IF    '${users_length}'!='0'
        ${found_national_code}    Set Variable    True
    END

    RETURN    ${found_national_code}

Generate A Fresh Cell Number
    [Documentation]    Generates a Fresh Cell Number. A Fresh ${cell_number} is a cell number that does not exist in the users db or the switch credit db.
    ...    Retries for    ${max_retry} times. If the ${predefined_cell_number_prefix} is not `None` (default),
    ...    then that value is going to be used as the prefix for the cell number. The length of the prefix should not be longer than ${11}.
    ...
    ...    RETURNs the generated cell number!
    [Tags]    robot:private
    [Arguments]    ${max_retry}=60    ${predefined_cell_number_prefix}=None

    ${cell_number}    Set Variable    ${EMPTY}
    FOR    ${i}    IN RANGE    ${0}    ${max_retry}    ${1}
        ${cell_number}    Fake Cell Number    predefined_cell_number_prefix=${predefined_cell_number_prefix}
        ${found_cell_number}    Check If Cell Number Does exist    cell_number=${cell_number}
        IF    '${found_cell_number}'=='False'    BREAK
    END
    IF    '${cell_number}'=='${EMPTY}'
        Fail    msg=cell number generation FAILED after ${max_retry} tries.
    END

    RETURN    ${cell_number}

Generate A Fresh National Code
    [Documentation]    Generates a Fresh National Code. A Fresh ${national_code} is a national code that does not exist in the users db or the switch credit db.
    ...    Retries for    ${max_retry} times.
    ...
    ...    RETURNs the generated national code!
    [Tags]    robot:private
    [Arguments]    ${max_retry}=60

    ${national_code}    Set Variable    ${EMPTY}
    FOR    ${i}    IN RANGE    ${0}    ${max_retry}    ${1}
        ${national_code}    Fake National Code
        ${found_national_code}    Check If National Code Does exist    national_code=${national_code}
        IF    '${found_national_code}'=='False'    BREAK
    END
    IF    '${national_code}'=='${EMPTY}'
        Fail    msg=national code generation FAILED after ${max_retry} tries.
    END

    RETURN    ${national_code}

Retrieve User Id From Cell Number
    [Documentation]    RETURNs the ${user_id} for a given ${cell_number}
    [Tags]    robot:private
    [Arguments]    ${cell_number}

    ${search_query}    Set Variable    SELECT * FROM user_db.users WHERE cell_number = '${cell_number}'
    ${result}    MySQL Fetch All    db_name=user_db    query=${search_query}
    ${body}    Set Variable    ${result['body']}[0]
    ${user_id}    Set Variable    ${body['user_id']}

    RETURN    ${user_id}

Update User Database by National Code
    [Documentation]    Update the user_db, users table to include the national code as well. Users allocated randomly haven not been part of the system previously
    ...    and it is required for them to include the national code.
    ...
    ...    Make sure that the **Login** process is carried out previously
    ...
    ...    Input arguments are: ${cell_number} and ${national_code}
    [Tags]    robot:private
    [Arguments]    ${cell_number}    ${national_code}

    ${users_search_query}    Set Variable    SELECT * FROM user_db.users WHERE cell_number = '${cell_number}'
    ${users_result}    MySQL Fetch All    db_name=user_db    query=${users_search_query}
    ${users_body}    Set Variable    ${users_result['body']}
    ${users_length}    Get Length    ${users_body}
    IF    '${users_length}'=='0'
        Fail
        ...    msg=Expected The user to have logged in at least once, please make sure your user has logged into the app!
    END
    ${users_body}    Set Variable    ${users_body}[0]
    ${found_national_code}    Set Variable    ${users_body['national_code']}
    IF    '${found_national_code}'=='None'
        ${update_query}    Set Variable
        ...    UPDATE user_db.users SET national_code = '${national_code}' WHERE cell_number = '${cell_number}'
        ${result}    MySQL Execute Query    db_name=user_db    query=${update_query}
    ELSE IF    '${found_national_code}'!='${national_code}'
        Fail
        ...    msg=Invalid national_code : ${national_code}. Found national_code : ${found_national_code} which is inconsistent with the given national_code ${national_code}.
    END

Generate A Fresh User
    [Documentation]    Attempts to generate a fresh new user. **A new user, is someone who has no user_id**.
    ...    Retries for the ${max_retry} times if it fails.
    ...    If the ${predefined_cell_number_prefix} is not EMPTY (default),
    ...    then that value is going to be used as the prefix for the cell number. The length of the prefix should not be longer than ${11}.
    ...
    ...
    ...    Input variable is:
    ...
    ...    1. ${max_retry}: By default is set as ${60}. If it can not generate a *fresh* ${cell_number} or a *fresh* ${national_code}, the service will **FAIL**
    ...
    ...    2. ${predefined_cell_number_prefix}: is used to used a predefined prefix for the cell number generation.
    ...    The default value for this variable is `None`.
    ...    The length of this prefix should not be longer than 11
    ...
    ...    RETURNs a dictionary ${generated_user_info} with key: {${generated_user_id}, ${generated_cell_number}, ${generated_national_code}}
    [Arguments]    ${predefined_cell_number_prefix}=None    ${max_retry}=60

    ${generated_cell_number}    Generate A Fresh Cell Number
    ...    max_retry=${max_retry}
    ...    predefined_cell_number_prefix=${predefined_cell_number_prefix}
    ${generated_national_code}    Generate A Fresh National Code
    ...    max_retry=${max_retry}

    Wait Until Keyword Succeeds
    ...    1 minute
    ...    1 s
    ...    Login To App
    ...    cell_number=${generated_cell_number}
    ...    pin_code=${EMPTY}

    ${generated_user_id}    Retrieve User Id From Cell Number    cell_number=${generated_cell_number}

    ${generated_user_info}    Create Dictionary
    ...    user_id=${generated_user_id}
    ...    user_cell_number=${generated_cell_number}
    ...    user_national_code=${generated_national_code}

    Update User Database by National Code
    ...    cell_number=${generated_cell_number}
    ...    national_code=${generated_national_code}

    RETURN    ${generated_user_info}

Generate A Predefined User
    [Documentation]    given the ${cell_number} and the ${national_code}, evaluate their credibility and consistency across switch_credit_db and users_db.
    ...
    ...    RETURNs a dictionary ${user_info} with key: {${generated_user_id}, ${generated_cell_number}, ${generated_national_code}}
    [Arguments]    ${cell_number}    ${national_code}

    ${found_cell_number}    Check If Cell Number Does exist    cell_number=${cell_number}
    ${found_national_code}    Check If National Code Does exist    national_code=${national_code}

    ${user_id}    Set Variable    ${EMPTY}

    IF    '${found_cell_number}'=='False'
        IF    '${found_national_code}' == 'False'
            Wait Until Keyword Succeeds
            ...    1 minute
            ...    1 s
            ...    Login To App
            ...    cell_number=${cell_number}
            ...    pin_code=${EMPTY}

            ${user_id}    Retrieve User Id From Cell Number    cell_number=${cell_number}
        ELSE
            Fail
            ...    msg=cell number was not found, but a matching national code ${national_code} was found in either switch_credit_db or users_db. Make sure your cell number is correct or use a generate a different national code
        END
    ELSE
        ${user_id}    Retrieve User Id From Cell Number    cell_number=${cell_number}
    END

    Update User Database by National Code    cell_number=${cell_number}    national_code=${national_code}

    ${user_info}    Create Dictionary
    ...    user_id=${user_id}
    ...    user_cell_number=${cell_number}
    ...    user_national_code=${national_code}

    RETURN    ${user_info}
