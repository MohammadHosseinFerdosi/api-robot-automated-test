*** Settings ***
Library     String
Library     library/mysql_db.py    WITH NAME    MYSQL


*** Keywords ***
Build Config For MYSQL Db Handler
    [Documentation]    Builds the MySQL connection configuration dictionary for the specified database.
    ...
    ...    This internal keyword generates the connection parameters (host, port, user, password)
    ...    dynamically for MySQL, based on the provided database name.
    ...
    ...    Special Cases:
    ...    - If db_name is `wallet_provider_db`, it uses `${WALLET_PROVIDER_MYSQL_DB_PASS}` for the password.
    ...
    ...    Arguments:
    ...    - db_name (str): Name of the MySQL database to build the config for.
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

    ${user}    Replace String    ${db_name}    _db    _user

    ${host}    Set Variable    ${MYSQL_DB_DEFAULT_HOST}
    ${port}    Set Variable    ${MYSQL_DB_DEFAULT_PORT}

    ${password}    Set Variable    ${MYSQL_DB_DEFAULT_PASS}

    IF    '${db_name}' == 'wallet_provider_db'
        ${password}    Set Variable    ${WALLET_PROVIDER_MYSQL_DB_PASS}
        ${host}    Set Variable    ${WALLET_PROVIDER_MYSQL_DB_HOST}
    ELSE IF    '${db_name}' == 'general_ledger_db'
        ${password}    Set Variable    ${GENERAL_LEDGER_MYSQL_DB_PASS}
        ${host}        Set Variable    ${GENERAL_LEDGER_MYSQL_DB_HOST} 
    END

    ${config}    Create Dictionary    user=${user}    password=${password}    host=${host}    port=${port}
    RETURN    ${config}

Initiate MySQL Db Connection
    [Documentation]    Initiates the MySQL connection by dynamically building the connection config
    ...    and calling the Python MySQL Connect To Db keyword.
    ...
    ...    Arguments:
    ...    - db_name (str): Name of the MySQL database to connect to.
    [Arguments]    ${db_name}
    ${config}    Build Config For MYSQL Db Handler    ${db_name}
    MYSQL.Connect To Db
    ...    host=${config['host']}
    ...    port=${config['port']}
    ...    user=${config['user']}
    ...    password=${config['password']}
    ...    database=${db_name}

MySQL Begin Transaction
    [Documentation]    Begins a new transaction on the current MySQL connection.
    ...
    ...    The database connection must already be established before calling this keyword.
    ...
    ...    Raises:
    ...    - RuntimeError: If starting the transaction fails.
    ...
    ...    Example Usage:
    ...
    ...    ```MySQL Initiate Db Connection    my_database```
    ...
    ...    ```MySQL Begin Transaction```
    MYSQL.Begin Transaction

MySQL Commit Transaction
    [Documentation]    Commits the current transaction on the MySQL connection.
    ...
    ...    The database connection must already be established before calling this keyword.
    ...
    ...    Raises:
    ...    - RuntimeError: If committing the transaction fails.
    ...
    ...    Example Usage:
    ...
    ...    ```
    ...    MySQL Commit Transaction
    ...    ```
    MYSQL.Commit Transaction

MySQL Rollback Transaction
    [Documentation]    Rolls back the current transaction on the MySQL connection.
    ...
    ...    The database connection must already be established before calling this keyword.
    ...
    ...    Raises:
    ...    - RuntimeError: If rolling back the transaction fails.
    ...
    ...    Example Usage:
    ...
    ...    ```
    ...    MySQL Rollback Transaction
    ...    ```
    MYSQL.Rollback Transaction

MySQL Execute Query
    [Documentation]    Executes an INSERT, UPDATE, DELETE or DDL query on MySQL.
    ...
    ...    This keyword wraps the Python `execute_query` function and returns a dictionary
    ...    with status_code and body containing affected_rows or error.
    ...
    ...    Arguments:
    ...    - db_name (str): Name of the MySQL database to connect to.
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
    ...    ${response}    MySQL Execute Query    my_database    ${INSERT_QUERY}    ${INSERT_PARAMS}```
    ...
    ...    ```
    ...    ${response}    MySQL Execute Query    my_database    ${UPDATE_QUERY}    ${UPDATE_PARAMS}```
    ...
    ...    ```
    ...    ${response}    MySQL Execute Query    my_database    ${DELETE_QUERY}    ${DELETE_PARAMS}```
    ...
    ...    ```
    ...    ${response}    MySQL Execute Query    my_database    ${DDL_QUERY}```
    ...    ```
    [Arguments]    ${db_name}    ${query}    ${params}=${EMPTY}    ${use_transaction}=True
    Initiate MySQL Db Connection    ${db_name}
    ${response}    MYSQL.Execute Query    ${query}    ${params}    ${use_transaction}
    MySQL.Close Db Connection
    RETURN    ${response}

MySQL Fetch One
    [Documentation]    Executes a SELECT query and returns a single row from MySQL.
    ...
    ...    This keyword wraps the Python `fetch_one` function and returns a dictionary
    ...    with status_code and body containing fetched row or error.
    ...
    ...    Arguments:
    ...    - db_name (str): Name of the MySQL database to connect to.
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
    ...    ${response}    MySQL Fetch One    my_database    ${SELECT_QUERY}    ${SELECT_PARAMS}
    ...    ```
    [Arguments]    ${db_name}    ${query}    ${params}=${EMPTY}    ${use_transaction}=True
    Initiate MySQL Db Connection    ${db_name}
    ${response}    MYSQL.Fetch One    ${query}    ${params}    ${use_transaction}
    MySQL.Close Db Connection
    RETURN    ${response}

MySQL Fetch All
    [Documentation]    Executes a SELECT query and returns all rows from MySQL.
    ...
    ...    This keyword wraps the Python `fetch_all` function and returns a dictionary
    ...    with status_code and body containing list of rows or error.
    ...
    ...    Arguments:
    ...    - db_name (str): Name of the MySQL database to connect to.
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
    ...    ${response}    MySQL Fetch All    my_database    ${SELECT_QUERY}    ${SELECT_PARAMS}
    ...    ```
    [Arguments]    ${db_name}    ${query}    ${params}=${EMPTY}    ${use_transaction}=True
    Initiate MySQL Db Connection    ${db_name}
    ${response}    MYSQL.Fetch All    ${query}    ${params}    ${use_transaction}
    MySQL.Close Db Connection
    RETURN    ${response}

MySQL List Tables
    [Documentation]    Lists all tables in the current MySQL database.
    ...
    ...    This keyword wraps the Python `list_tables` function and returns a dictionary
    ...    with status_code and body containing list of table names or error.
    ...
    ...    Arguments:
    ...    - db_name (str): Name of the MySQL database to connect to.
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
    ...    ${response}    MySQL List Tables    my_database
    ...    ```
    [Arguments]    ${db_name}    ${use_transaction}=True
    Initiate MySQL Db Connection    ${db_name}
    ${response}    MYSQL.List Tables    ${use_transaction}
    MySQL.Close Db Connection
    RETURN    ${response}

MySQL Describe Table
    [Documentation]    Describes the structure of a MySQL table (columns, types, keys, etc.).
    ...
    ...    This keyword wraps the Python `describe_table` function and returns a dictionary
    ...    with status_code and body containing table structure or error.
    ...
    ...    Arguments:
    ...    - db_name (str): Name of the MySQL database to connect to.
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
    ...    ${response}    MySQL Describe Table    my_database    users
    ...    ```
    [Arguments]    ${db_name}    ${table_name}    ${use_transaction}=True
    Initiate MySQL Db Connection    ${db_name}
    ${response}    MYSQL.Describe Table    ${table_name}    ${use_transaction}
    MySQL.Close Db Connection
    RETURN    ${response}

MySQL Count Rows
    [Documentation]    Counts rows in a MySQL table with optional WHERE clause filtering.
    ...
    ...    This keyword wraps the Python `count_rows` function and returns a dictionary
    ...    with status_code and body containing count or error.
    ...
    ...    Arguments:
    ...    - db_name (str): Name of the MySQL database to connect to.
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
    ...    ${response}    MySQL Count Rows    my_database    users    ${WHERE}    ${PARAMS}
    ...    ```
    [Arguments]
    ...    ${db_name}
    ...    ${table_name}
    ...    ${where_clause}=${EMPTY}
    ...    ${params}=${EMPTY}
    ...    ${use_transaction}=True
    Initiate MySQL Db Connection    ${db_name}
    ${response}    MYSQL.Count Rows    ${table_name}    ${where_clause}    ${params}    ${use_transaction}
    MySQL.Close Db Connection
    RETURN    ${response}
