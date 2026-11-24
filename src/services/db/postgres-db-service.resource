*** Settings ***
Library     String
Library     library/postgres_db.py    WITH NAME    POSTGRES_DB


*** Keywords ***
Build Config For POSTGRES Db Handler
    [Documentation]    Builds the POSTGRES connection configuration dictionary for the specified database.
    ...
    ...    This internal keyword generates the connection parameters (host, port, user, password)
    ...    dynamically for POSTGRES, based on the provided database name.
    ...
    ...    Arguments:
    ...    - db_name (str): Name of the POSTGRES database to build the config for.
    ...
    ...    Returns:
    ...    Dictionary:
    ...    {
    ...    "user": str,
    ...    "password": str,
    ...    "host": str,
    ...    "port": int
    ...    }
    [Tags]    robot:private
    [Arguments]    ${db_name}

    IF    '${db_name}' == 'collateralmanagement_db'
        ${user}    Set Variable    ${POSTGRES_DB_COLLATERAL_MANAGEMENT_USER}
        ${password}    Set Variable    ${POSTGRES_DB_COLLATERAL_MANAGEMENT_PASS}
        ${host}    Set Variable    ${POSTGRES_DB_COLLATERAL_MANAGEMENT_HOST}
        ${port}    Set Variable    ${POSTGRES_DB_COLLATERAL_MANAGEMENT_PORT}
        ${config}    Create Dictionary    user=${user}    password=${password}    host=${host}    port=${port}
        RETURN    ${config}
    END

    IF    '${db_name}' == 'treasurymanagement'
        ${user}    Set Variable    ${POSTGRES_DB_TREASURY_STATMENT_USER}
        ${password}    Set Variable    ${POSTGRES_DB_TREASURY_STATMENT_PASS}
        ${host}    Set Variable    ${POSTGRES_DB_COLLATERAL_MANAGEMENT_HOST}
        ${port}    Set Variable    ${POSTGRES_DB_COLLATERAL_MANAGEMENT_PORT}
        ${config}    Create Dictionary    user=${user}    password=${password}    host=${host}    port=${port}
        RETURN    ${config}
    END

    Fail    msg=Handler Not implemented for the database ${db_name}. Please implement your database specific handler!

Initiate POSTGRES Db Connection
    [Documentation]    Initiates the POSTGRES connection by dynamically building the connection config
    ...    and calling the Python POSTGRES Connect To Db keyword.
    ...
    ...    Arguments:
    ...    - db_name (str): Name of the POSTGRES database to connect to.
    [Arguments]    ${db_name}
    ${config}    Build Config For POSTGRES Db Handler    ${db_name}
    POSTGRES_DB.Connect To Db
    ...    host=${config['host']}
    ...    port=${config['port']}
    ...    user=${config['user']}
    ...    password=${config['password']}
    ...    database=${db_name}

POSTGRES Begin Transaction
    [Documentation]    Begins a new transaction on the current POSTGRES connection.
    ...
    ...    The database connection must already be established before calling this keyword.
    ...
    ...    Raises:
    ...    - RuntimeError: If starting the transaction fails.
    ...
    ...    Example Usage:
    ...
    ...    ```POSTGRES Initiate Db Connection    my_database```
    ...
    ...    ```POSTGRES Begin Transaction```
    POSTGRES_DB.Begin Transaction

POSTGRES Commit Transaction
    [Documentation]    Commits the current transaction on the POSTGRES connection.
    ...
    ...    The database connection must already be established before calling this keyword.
    ...
    ...    Raises:
    ...    - RuntimeError: If committing the transaction fails.
    ...
    ...    Example Usage:
    ...
    ...    ```
    ...    POSTGRES Commit Transaction
    ...    ```
    POSTGRES_DB.Commit Transaction

POSTGRES Rollback Transaction
    [Documentation]    Rolls back the current transaction on the POSTGRES connection.
    ...
    ...    The database connection must already be established before calling this keyword.
    ...
    ...    Raises:
    ...    - RuntimeError: If rolling back the transaction fails.
    ...
    ...    Example Usage:
    ...
    ...    ```
    ...    POSTGRES Rollback Transaction
    ...    ```
    POSTGRES_DB.Rollback Transaction

POSTGRES Execute Query
    [Documentation]    Executes an INSERT, UPDATE, DELETE or DDL query on POSTGRES.
    ...
    ...    This keyword wraps the Python `execute_query` function and returns a dictionary
    ...    with status_code and body containing affected_rows or error.
    ...
    ...    Arguments:
    ...    - db_name (str): Name of the POSTGRES database to connect to.
    ...    - query (str): SQL query string to execute.
    ...    - params (tuple or list, optional): Parameters for the query.
    ...    - use_transaction (bool, optional): Whether to wrap execution in explicit transaction.
    ...
    ...    Status Codes:
    ...    - 0: Query executed successfully.
    ...    - 1: Internal error occurred.
    ...
    ...    Returns:
    ...    Dictionary:
    ...    {
    ...    "status_code": int,
    ...    "body": {"affected_rows": int} or {"error": str}
    ...    }
    ...
    ...    Example Usage:
    ...
    ...    `*** Variables ***`
    ...
    ...    ```${INSERT_QUERY}    INSERT INTO users (username, email) VALUES (%s, %s)```
    ...
    ...    ```${INSERT_PARAMS}    ["john_doe", "john@example.com"]```
    ...
    ...    ```${UPDATE_QUERY}    UPDATE users SET email = %s WHERE id = %s```
    ...
    ...    ```${UPDATE_PARAMS}    ["new_email@example.com", 5]```
    ...
    ...    ```${DELETE_QUERY}    DELETE FROM users WHERE id = %s```
    ...
    ...    ```${DELETE_PARAMS}    [5]```
    ...
    ...    ```${DDL_QUERY}    CREATE TABLE test_table (id INT PRIMARY KEY, name VARCHAR(255))```
    ...
    ...    `*** Test Cases ***`
    ...
    ...    ```
    ...    ${response}    POSTGRES Execute Query    my_database    ${INSERT_QUERY}    ${INSERT_PARAMS}```
    ...
    ...    ```
    ...    ${response}    POSTGRES Execute Query    my_database    ${UPDATE_QUERY}    ${UPDATE_PARAMS}```
    ...
    ...    ```
    ...    ${response}    POSTGRES Execute Query    my_database    ${DELETE_QUERY}    ${DELETE_PARAMS}```
    ...
    ...    ```
    ...    ${response}    POSTGRES Execute Query    my_database    ${DDL_QUERY}```
    ...    ```
    [Arguments]    ${db_name}    ${query}    ${params}=${EMPTY}    ${use_transaction}=True
    Initiate POSTGRES Db Connection    ${db_name}
    ${response}    POSTGRES_DB.Execute Query    ${query}    ${params}    ${use_transaction}
    POSTGRES_DB.Close Db Connection
    RETURN    ${response}

POSTGRES Fetch One
    [Documentation]    Executes a SELECT query and returns a single row from POSTGRES.
    ...
    ...    This keyword wraps the Python `fetch_one` function and returns a dictionary
    ...    with status_code and body containing fetched row or error.
    ...
    ...    Arguments:
    ...    - db_name (str): Name of the POSTGRES database to connect to.
    ...    - query (str): SQL SELECT query string to execute.
    ...    - params (tuple or list, optional): Parameters for the query.
    ...    - use_transaction (bool, optional): Whether to wrap execution in explicit transaction.
    ...
    ...    Status Codes:
    ...    - 0: Query executed successfully.
    ...    - 1: Internal error occurred.
    ...
    ...    Returns:
    ...    Dictionary:
    ...    {
    ...    "status_code": int,
    ...    "body": single row dictionary or empty dict or error
    ...    }
    ...
    ...    Example Usage:
    ...
    ...    `*** Variables ***`
    ...
    ...    ```${SELECT_QUERY}    SELECT * FROM users WHERE id = %s```
    ...
    ...    ```${SELECT_PARAMS}    [5]```
    ...
    ...    `*** Test Cases ***`
    ...
    ...    ```
    ...    ${response}    POSTGRES Fetch One    my_database    ${SELECT_QUERY}    ${SELECT_PARAMS}
    ...    ```
    [Arguments]    ${db_name}    ${query}    ${params}=${EMPTY}    ${use_transaction}=True
    Initiate POSTGRES Db Connection    ${db_name}
    ${response}    POSTGRES_DB.Fetch One    ${query}    ${params}    ${use_transaction}
    POSTGRES_DB.Close Db Connection
    RETURN    ${response}

POSTGRES Fetch All
    [Documentation]    Executes a SELECT query and returns all rows from POSTGRES.
    ...
    ...    This keyword wraps the Python `fetch_all` function and returns a dictionary
    ...    with status_code and body containing list of rows or error.
    ...
    ...    Arguments:
    ...    - db_name (str): Name of the POSTGRES database to connect to.
    ...    - query (str): SQL SELECT query string to execute.
    ...    - params (tuple or list, optional): Parameters for the query.
    ...    - use_transaction (bool, optional): Whether to wrap execution in explicit transaction.
    ...
    ...    Status Codes:
    ...    - 0: Query executed successfully.
    ...    - 1: Internal error occurred.
    ...
    ...    Returns:
    ...    Dictionary:
    ...    {
    ...    "status_code": int,
    ...    "body": list of row dictionaries or error
    ...    }
    ...
    ...    Example Usage:
    ...
    ...    `*** Variables ***`
    ...
    ...    ```${SELECT_QUERY}    SELECT * FROM users WHERE status = %s ORDER BY created_at DESC LIMIT 10```
    ...    ```${SELECT_PARAMS}    ["active"]```
    ...
    ...    `*** Test Cases ***`
    ...
    ...    ```
    ...    ${response}    POSTGRES Fetch All    my_database    ${SELECT_QUERY}    ${SELECT_PARAMS}
    ...    ```
    [Arguments]    ${db_name}    ${query}    ${params}=${EMPTY}    ${use_transaction}=True
    Initiate POSTGRES Db Connection    ${db_name}
    ${response}    POSTGRES_DB.Fetch All    ${query}    ${params}    ${use_transaction}
    POSTGRES_DB.Close Db Connection
    RETURN    ${response}

POSTGRES List Tables
    [Documentation]    Lists all tables in the current POSTGRES database.
    ...
    ...    This keyword wraps the Python `list_tables` function and returns a dictionary
    ...    with status_code and body containing list of table names or error.
    ...
    ...    Arguments:
    ...    - db_name (str): Name of the POSTGRES database to connect to.
    ...    - use_transaction (bool, optional): Whether to wrap execution in explicit transaction.
    ...
    ...    Status Codes:
    ...    - 0: Query executed successfully.
    ...    - 1: Internal error occurred.
    ...
    ...    Returns:
    ...    Dictionary:
    ...    {
    ...    "status_code": int,
    ...    "body": list of table names or error
    ...    }
    ...
    ...    Example Usage:
    ...
    ...    `*** Test Cases ***`
    ...
    ...    ```
    ...    ${response}    POSTGRES List Tables    my_database
    ...    ```
    [Arguments]    ${db_name}    ${use_transaction}=True
    Initiate POSTGRES Db Connection    ${db_name}
    ${response}    POSTGRES_DB.List Tables    ${use_transaction}
    POSTGRES_DB.Close Db Connection
    RETURN    ${response}

POSTGRES Describe Table
    [Documentation]    Describes the structure of a POSTGRES table (columns, types, keys, etc.).
    ...
    ...    This keyword wraps the Python `describe_table` function and returns a dictionary
    ...    with status_code and body containing table structure or error.
    ...
    ...    Arguments:
    ...    - db_name (str): Name of the POSTGRES database to connect to.
    ...    - table_name (str): Name of the table to describe.
    ...    - use_transaction (bool, optional): Whether to wrap execution in explicit transaction.
    ...
    ...    Status Codes:
    ...    - 0: Query executed successfully.
    ...    - 1: Internal error occurred.
    ...
    ...    Returns:
    ...    Dictionary:
    ...    {
    ...    "status_code": int,
    ...    "body": list of column definitions or error
    ...    }
    ...
    ...    Example Usage:
    ...
    ...    `*** Test Cases ***`
    ...
    ...    ```
    ...    ${response}    POSTGRES Describe Table    my_database    users
    ...    ```
    [Arguments]    ${db_name}    ${table_name}    ${use_transaction}=True
    Initiate POSTGRES Db Connection    ${db_name}
    ${response}    POSTGRES_DB.Describe Table    ${table_name}    ${use_transaction}
    POSTGRES_DB.Close Db Connection
    RETURN    ${response}

POSTGRES Count Rows
    [Documentation]    Counts rows in a POSTGRES table with optional WHERE clause filtering.
    ...
    ...    This keyword wraps the Python `count_rows` function and returns a dictionary
    ...    with status_code and body containing count or error.
    ...
    ...    Arguments:
    ...    - db_name (str): Name of the POSTGRES database to connect to.
    ...    - table_name (str): Name of the table to count rows.
    ...    - where_clause (str, optional): The WHERE clause (without 'WHERE').
    ...    - params (tuple or list, optional): Parameters for the WHERE clause.
    ...    - use_transaction (bool, optional): Whether to wrap execution in explicit transaction.
    ...
    ...    Status Codes:
    ...    - 0: Query executed successfully.
    ...    - 1: Internal error occurred.
    ...
    ...    Returns:
    ...    Dictionary:
    ...    {
    ...    "status_code": int,
    ...    "body": {"count": int} or error
    ...    }
    ...
    ...    Example Usage:
    ...
    ...    `*** Variables ***`
    ...
    ...    ```${WHERE}    status = %s```
    ...    ```${PARAMS}    ["active"]```
    ...
    ...    `*** Test Cases ***`
    ...
    ...    ```
    ...    ${response}    POSTGRES Count Rows    my_database    users    ${WHERE}    ${PARAMS}
    ...    ```
    [Arguments]
    ...    ${db_name}
    ...    ${table_name}
    ...    ${where_clause}=${EMPTY}
    ...    ${params}=${EMPTY}
    ...    ${use_transaction}=True
    Initiate POSTGRES Db Connection    ${db_name}
    ${response}    POSTGRES_DB.Count Rows    ${table_name}    ${where_clause}    ${params}    ${use_transaction}
    POSTGRES_DB.Close Db Connection
    RETURN    ${response}
