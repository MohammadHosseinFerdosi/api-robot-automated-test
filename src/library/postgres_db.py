import psycopg2
from psycopg2 import Error
from psycopg2.extras import RealDictCursor
from robot.api.deco import keyword

_connection = None
_cursor = None


@keyword
def connect_to_db(host, port, user, password, database):
    """
    Connect to PostgreSQL server and select the database.

    Args:
        host (str): PostgreSQL host address.
        port (int): PostgreSQL port number.
        user (str): Username for authentication.
        password (str): Password for authentication.
        database (str): Name of the database to connect to.

    Raises:
        RuntimeError: If the connection to PostgreSQL fails.
    """
    global _connection, _cursor
    try:
        _connection = psycopg2.connect(
            host=host, port=port, user=user, password=password, dbname=database
        )
        _cursor = _connection.cursor(cursor_factory=RealDictCursor)
        print(f"Connected to PostgreSQL database: {database}")
    except Error as e:
        raise RuntimeError(f"Error connecting to PostgreSQL: {e}")


@keyword
def close_db_connection():
    """
    Close the PostgreSQL connection and reset global variables.

    Raises:
        RuntimeError: If closing the connection fails.
    """
    global _connection, _cursor
    try:
        if _cursor:
            _cursor.close()
        if _connection:
            _connection.close()
            print("PostgreSQL connection closed.")
    except Error as e:
        raise RuntimeError(f"Error closing PostgreSQL connection: {e}")
    finally:
        _connection = None
        _cursor = None


@keyword
def begin_transaction():
    """
    Begin a new transaction.

    Raises:
        RuntimeError: If starting the transaction fails.
    """
    global _connection
    if _connection is None:
        raise RuntimeError("Database not connected.")
    try:
        _connection.autocommit = False
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
        _connection.autocommit = True
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
        _connection.autocommit = True
    except Error as e:
        raise RuntimeError(f"Failed to rollback transaction: {e}")


@keyword
def execute_query(query, params=None, use_transaction=False):
    """
    Execute INSERT, UPDATE, DELETE, or DDL statements.

    Args:
        query (str): SQL query string.
        params (tuple or list, optional): Parameters for the query.
        use_transaction (bool, optional): If True, wraps query inside explicit transaction.

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
def fetch_one(query, params=None, use_transaction=False):
    """
    Execute a SELECT query and return a single row.

    Args:
        query (str): SQL SELECT query string.
        params (tuple or list, optional): Parameters for the query.
        use_transaction (bool, optional): If True, wraps query inside explicit transaction.

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
def fetch_all(query, params=None, use_transaction=False):
    """
    Execute a SELECT query and return all rows.

    Args:
        query (str): SQL SELECT query string.
        params (tuple or list, optional): Parameters for the query.
        use_transaction (bool, optional): If True, wraps query inside explicit transaction.

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
def list_tables(use_transaction=False):
    """
    List all tables in the current PostgreSQL database (public schema only).

    Args:
        use_transaction (bool, optional): If True, wraps query inside explicit transaction.

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

        _cursor.execute(
            """
            SELECT table_name
            FROM information_schema.tables
            WHERE table_schema = 'public'
            ORDER BY table_name
            """
        )
        tables = [row["table_name"] for row in _cursor.fetchall()]

        if use_transaction:
            commit_transaction()

        return {"status_code": 0, "body": tables}
    except Error as e:
        return {"status_code": 1, "body": {"error": str(e)}}


@keyword
def describe_table(table_name, use_transaction=False):
    """
    Describe the structure of a table (columns, types, nullability).

    Args:
        table_name (str): The name of the table.
        use_transaction (bool, optional): If True, wraps query inside explicit transaction.

    Returns:
        dict:
            - status_code: HTTP-style status code
                * 0: Query executed successfully
                * 1: Internal error occurred
            - body: Dictionary containing column details or error
    """
    global _cursor
    if _cursor is None:
        return {"status_code": 1, "body": {"error": "Database not connected."}}

    try:
        if use_transaction:
            begin_transaction()

        _cursor.execute(
            """
            SELECT column_name, data_type, is_nullable
            FROM information_schema.columns
            WHERE table_name = %s
            """,
            (table_name,),
        )
        structure = _cursor.fetchall()

        if use_transaction:
            commit_transaction()

        return {"status_code": 0, "body": structure}
    except Error as e:
        return {"status_code": 1, "body": {"error": str(e)}}


@keyword
def count_rows(table_name, where_clause=None, params=None, use_transaction=False):
    """
    Count number of rows in a table, with optional filtering.

    Args:
        table_name (str): The name of the table.
        where_clause (str, optional): WHERE condition (without 'WHERE' keyword).
        params (tuple, optional): Parameters for WHERE clause.
        use_transaction (bool, optional): If True, wraps query inside explicit transaction.

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
