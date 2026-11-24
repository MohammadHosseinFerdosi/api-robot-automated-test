# MySQL Service

This Robot Framework service enables structured interactions with MySQL databases. It includes keywords for building database configurations, initiating connections, and managing transactional operations. Each operation returns results in a standardized dictionary format, making it ideal for test automation scenarios.

The output follows a standard format similar to API responses:

```bash
{
  'status_code': 0 (success) or 1 (failure),
  'body': <operation result>
}
```

> For more information check the documentations provided at each keyword withing the code

## Table of Keywords

- [Build Config For MYSQL Db Handler](#build-config-for-mysql-db-handler)
- [Initiate MySQL Db Connection](#initiate-mysql-db-connection)
- [MySQL Begin Transaction](#mysql-begin-transaction)
- [MySQL Commit Transaction](#mysql-commit-transaction)
- [MySQL Rollback Transaction](#mysql-rollback-transaction)
- [MySQL Execute Query](#mysql-execute-query)
- [MySQL Fetch One](#mysql-fetch-one)
- [MySQL Fetch All](#mysql-fetch-all)
- [MySQL List Tables](#mysql-list-tables)
- [MySQL Describe Table](#mysql-describe-table)
- [MySQL Count Rows](#mysql-count-rows)

---

## Build Config For MYSQL Db Handler

**Description:**

Creates a configuration dictionary containing the necessary connection details for a MYSQL instance. This includes parameters such as username, password, host, and port, all derived from the given database name. Typically used internally to support other connection-related keywords. Make sure to include or modify this handler if you have a database that does not follow the generic config handler.

> This is a [private] Keyword

**Arguments:**

- `${db_name}`

**Example Usage:**

```bash
Build Config For MYSQL Db Handler    ${db_name}
```

---

## Initiate MySQL Db Connection

**Description:**

Initializes a connection session with a MYSQL server using credentials specific to the database name. This prepares the environment for executing database operations like queries or inserts.

**Arguments:**

- `${db_name}`

**Example Usage:**

```bash
Initiate MySQL Db Connection    ${db_name}
```

---

## MySQL Begin Transaction

**Description:**

Begins a new transaction on the current MySQL connection.

**Arguments:** None

**Returns:** None

**Example Usage:**

```bash
MySQL Begin Transaction
```

---

## MySQL Commit Transaction

**Description:**

Commits the current transaction on the MySQL connection.

**Arguments:** None

**Returns:** None

**Example Usage:**

```bash
MySQL Commit Transaction
```

---

## MySQL Rollback Transaction

**Description:**

Rolls back the current transaction on the MySQL connection.

**Arguments:** None

**Returns:** None

**Example Usage:**

```bash
MySQL Rollback Transaction
```

---

## MySQL Execute Query

**Description:**

Executes an **INSERT, UPDATE, DELETE or DDL query** on MySQL.

**Arguments:**

- `${db_name}`
- `${query}`
- `${params}`
- `${EMPTY}`
- `${use_transaction}`

**Returns:**

```bash
{
  'status_code': 0 (success) or 1 (failure),
  'body': Query result as a list of dictionaries (rows) [Depending on the operation].
}
```

**Example Usage:**

```bash
MySQL Execute Query    ${db_name}    ${query}    ${params}    ${EMPTY}    ${use_transaction}
```

---

## MySQL Fetch One

**Description:**

Executes a **SELECT** query and returns _a single_ row from MySQL.

**Arguments:**

- `${db_name}`
- `${query}`
- `${params}`
- `${EMPTY}`
- `${use_transaction}`

**Returns:**

```bash
{
  'status_code': 0 (success) or 1 (failure),
  'body': Query result as a list of dictionaries (rows).
}
```

**Example Usage:**

```bash
MySQL Fetch One    ${db_name}    ${query}    ${params}    ${EMPTY}    ${use_transaction}
```

---

## MySQL Fetch All

**Description:**

Executes a **SELECT** query and returns _all_ rows from MySQL.

**Arguments:**

- `${db_name}`
- `${query}`
- `${params}`
- `${EMPTY}`
- `${use_transaction}`

**Returns:**

```bash
{
  'status_code': 0 (success) or 1 (failure),
  'body': Query result as a list of dictionaries (rows).
}
```

**Example Usage:**

```bash
MySQL Fetch All    ${db_name}    ${query}    ${params}    ${EMPTY}    ${use_transaction}
```

---

## MySQL List Tables

**Description:**

Lists all tables in the current MySQL database.

**Arguments:**

- `${db_name}`
- `${use_transaction}`

**Returns:**

```bash
{
  'status_code': 0 (success) or 1 (failure),
  'body': List of table names or error
}
```

**Example Usage:**

```bash
MySQL List Tables    ${db_name}    ${use_transaction}
```

---

## MySQL Describe Table

**Description:**

Describes the structure of a MySQL table (columns, types, keys, etc.).

**Arguments:**

- `${db_name}`
- `${table_name}`
- `${use_transaction}`

**Returns:**

```bash
{
  'status_code': 0 (success) or 1 (failure),
  'body': List of column definitions or error
}
```

**Example Usage:**

```bash
MySQL Describe Table    ${db_name}    ${table_name}    ${use_transaction}
```

---

## MySQL Count Rows

**Description:**

Counts rows in a MySQL table with optional WHERE clause filtering.

**Arguments:**

- `${db_name}`
- `${table_name}`
- `${where_clause}=${EMPTY}`
- `${params}=${EMPTY}`
- `${use_transaction}=True`

**Returns:**

```bash
{
  'status_code': 0 (success) or 1 (failure),
  'body': {"count": int} or error
}
```

**Example Usage:**

```bash
MySQL Count Rows    ${db_name}    ${table_name}    ${where_clause}    ${params}
```
