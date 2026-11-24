import mysql.connector
from mysql.connector import Error
from robot.api.deco import keyword

_connection = None
_cursor = None


@keyword
def connect_to_db(host, port, user, password, database):
    """
    Connect to MySQL server and select the database.

    Args:
        host (str): MySQL host address.
        port (int): MySQL port number.
        user (str): Username for MySQL authentication.
        password (str): Password for MySQL authentication.
        database (str): Name of the database to connect to.

    Side Effects:
        - Establishes a global MySQL connection and cursor.

    Raises:
        RuntimeError: If the connection to MySQL fails.
    """
    global _connection, _cursor
    try:
        _connection = mysql.connector.connect(
            host=host, port=port, user=user, password=password, database=database
        )
        _cursor = _connection.cursor(dictionary=True)
        print(f"Connected to MySQL database: {database}")
    except Error as e:
        raise RuntimeError(f"Error connecting to MySQL: {e}")


@keyword
def close_db_connection():
    """
    Close the MySQL connection and reset global variables.

    Side Effects:
        - Closes the active MySQL connection and cursor if open.
        - Resets _connection and _cursor to None.

    Raises:
        RuntimeError: If closing the connection fails.
    """
    global _connection, _cursor
    try:
        if _cursor:
            _cursor.close()
        if _connection:
            _connection.close()
            print("MySQL connection closed.")
    except Error as e:
        raise RuntimeError(f"Error closing MySQL connection: {e}")
    finally:
        _connection = None
        _cursor = None


@keyword
def begin_transaction():
    """
    Begin a new transaction on the current MySQL connection.

    Raises:
        RuntimeError: If starting the transaction fails.
    """
    global _connection
    if _connection is None:
        raise RuntimeError("Database not connected.")
    try:
        _connection.start_transaction()
    except Error as e:
        raise RuntimeError(f"Failed to start transaction: {e}")


@keyword
def commit_transaction():
    """
    Commit the current transaction.

    Raises:
        RuntimeError: If committing the transaction fails.
    """
    global _connection
    if _connection is None:
        raise RuntimeError("Database not connected.")
    try:
        _connection.commit()
    except Error as e:
        raise RuntimeError(f"Failed to commit transaction: {e}")


@keyword
def rollback_transaction():
    """
    Rollback the current transaction.

    Raises:
        RuntimeError: If rolling back the transaction fails.
    """
    global _connection
    if _connection is None:
        raise RuntimeError("Database not connected.")
    try:
        _connection.rollback()
    except Error as e:
        raise RuntimeError(f"Failed to rollback transaction: {e}")


@keyword
def execute_query(query, params=None, use_transaction=True):
    """
    Execute INSERT, UPDATE, DELETE, or DDL statements.

    Args:
        query (str): SQL query string.
        params (tuple or list, optional): Parameters for the query.
        use_transaction (bool, optional): If True, wraps the query inside explicit transaction.

    Returns:
        dict:
            - status_code: HTTP-style status code
                * 0: Query executed successfully
                * 1: Internal error occurred
            - body: Dictionary containing affected_rows or error
    """
    global _cursor
    if _cursor is None:
        return {"status_code": 1, "body": {"error": "Database not connected."}}

    try:
        if use_transaction:
            begin_transaction()

        _cursor.execute(query, params)
        affected_rows = _cursor.rowcount

        if use_transaction:
            commit_transaction()

        return {"status_code": 0, "body": {"affected_rows": affected_rows}}

    except Error as e:
        return {"status_code": 1, "body": {"error": str(e)}}


@keyword
def fetch_one(query, params=None, use_transaction=True):
    """
    Execute a SELECT query and return a single row.

    Args:
        query (str): SQL SELECT query string.
        params (tuple or list, optional): Parameters for the query.
        use_transaction (bool, optional): If True, wraps the query inside explicit transaction.

    Returns:
        dict:
            - status_code: HTTP-style status code
                * 0: Query executed successfully
                * 1: Internal error occurred
            - body: Dictionary containing fetched row or error
    """
    global _cursor
    if _cursor is None:
        return {"status_code": 1, "body": {"error": "Database not connected."}}

    try:
        if use_transaction:
            begin_transaction()

        _cursor.execute(query, params)
        row = _cursor.fetchone()

        if use_transaction:
            commit_transaction()

        return {"status_code": 0, "body": row or {}}
    except Error as e:
        return {"status_code": 1, "body": {"error": str(e)}}


@keyword
def fetch_all(query, params=None, use_transaction=True):
    """
    Execute a SELECT query and return all rows.

    Args:
        query (str): SQL SELECT query string.
        params (tuple or list, optional): Parameters for the query.
        use_transaction (bool, optional): If True, wraps the query inside explicit transaction.

    Returns:
        dict:
            - status_code: HTTP-style status code
                * 0: Query executed successfully
                * 1: Internal error occurred
            - body: Dictionary containing list of rows or error
    """
    global _cursor
    if _cursor is None:
        return {"status_code": 1, "body": {"error": "Database not connected."}}

    try:
        if use_transaction:
            begin_transaction()

        _cursor.execute(query, params)
        rows = _cursor.fetchall()

        if use_transaction:
            commit_transaction()

        return {"status_code": 0, "body": rows}
    except Error as e:
        return {"status_code": 1, "body": {"error": str(e)}}


@keyword
def list_tables(use_transaction=True):
    """
    List all tables in the current database.

    Args:
        use_transaction (bool, optional): If True, wraps the query inside explicit transaction.

    Returns:
        dict:
            - status_code: HTTP-style status code
                * 0: Query executed successfully
                * 1: Internal error occurred
            - body: Dictionary containing list of table names or error
    """
    global _cursor
    if _cursor is None:
        return {"status_code": 1, "body": {"error": "Database not connected."}}

    try:
        if use_transaction:
            begin_transaction()

        _cursor.execute("SHOW TABLES")
        tables = [row[list(row.keys())[0]] for row in _cursor.fetchall()]

        if use_transaction:
            commit_transaction()

        return {"status_code": 0, "body": tables}
    except Error as e:
        return {"status_code": 1, "body": {"error": str(e)}}


@keyword
def describe_table(table_name, use_transaction=True):
    """
    Describe the structure of a table (columns, types, keys, etc.).

    Args:
        table_name (str): The name of the table.
        use_transaction (bool, optional): If True, wraps the query inside explicit transaction.

    Returns:
        dict:
            - status_code: HTTP-style status code
                * 0: Query executed successfully
                * 1: Internal error occurred
            - body: Dictionary containing table structure or error
    """
    global _cursor
    if _cursor is None:
        return {"status_code": 1, "body": {"error": "Database not connected."}}

    try:
        if use_transaction:
            begin_transaction()

        _cursor.execute(f"DESCRIBE {table_name}")
        structure = _cursor.fetchall()

        if use_transaction:
            commit_transaction()

        return {"status_code": 0, "body": structure}
    except Error as e:
        return {"status_code": 1, "body": {"error": str(e)}}


@keyword
def count_rows(table_name, where_clause=None, params=None, use_transaction=True):
    """
    Count rows in the table, optionally filtered by a WHERE clause.

    Args:
        table_name (str): The name of the table.
        where_clause (str, optional): The WHERE clause without 'WHERE' keyword.
        params (tuple, optional): Parameters for the WHERE clause.
        use_transaction (bool, optional): If True, wraps the query inside explicit transaction.

    Returns:
        dict:
            - status_code: HTTP-style status code
                * 0: Query executed successfully
                * 1: Internal error occurred
            - body: Dictionary containing count or error
    """
    global _cursor
    if _cursor is None:
        return {"status_code": 1, "body": {"error": "Database not connected."}}

    try:
        if use_transaction:
            begin_transaction()

        if where_clause:
            query = f"SELECT COUNT(*) AS count FROM {table_name} WHERE {where_clause}"
        else:
            query = f"SELECT COUNT(*) AS count FROM {table_name}"

        _cursor.execute(query, params)
        row = _cursor.fetchone()

        if use_transaction:
            commit_transaction()

        return {"status_code": 0, "body": {"count": row["count"]}}
    except Error as e:
        return {"status_code": 1, "body": {"error": str(e)}}
