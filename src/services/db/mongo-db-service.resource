*** Settings ***
Library     String
Library     library/mongo_db.py    WITH NAME    MONGO_DB


*** Keywords ***
Build Config For Mongo Db Handler
    [Documentation]    Builds the MongoDB connection configuration dictionary for the specified database.
    ...
    ...    This internal keyword generates the connection parameters (host, port, user, password)
    ...    dynamically for MongoDB, based on the provided database name.
    ...
    ...    Arguments:
    ...    - db_name (str): Name of the MongoDB database to build the config for.
    ...
    ...    Returns:
    ...    Dictionary:
    ...    {
    ...    "user": str,
    ...    "password": str,
    ...    "host": str,
    ...    "port": int
    ...    }
    ...
    ...    Note:
    ...    This keyword is intended for internal use and does not need to be called directly in test cases.
    [Tags]    robot:private
    [Arguments]    ${db_name}
    ${user}    Replace String    ${db_name}    _db    _user
    ${password}    Set Variable    123456
    ${host}    Set Variable    10.198.111.51
    ${port}    Set Variable    27017

    ${config}    Create Dictionary
    ...    user=${user}
    ...    password=${MONGO_DB_DEFAULT_PASS}
    ...    host=${MONGO_DB_DEFAULT_HOST}
    ...    port=${MONGO_DB_DEFAULT_PORT}
    RETURN    ${config}

Initiate Mongo Db Connection
    [Documentation]    Initiates the MongoDB connection by dynamically building the connection config
    ...    and calling the Python MongoDB Connect To Db keyword.
    ...
    ...    Arguments:
    ...    - db_name (str): Name of the MongoDB database to connect to.
    [Arguments]    ${db_name}
    ${config}    Build Config For Mongo Db Handler    ${db_name}
    MONGO_DB.Connect To Db
    ...    host=${config['host']}
    ...    port=${config['port']}
    ...    user=${config['user']}
    ...    password=${config['password']}
    ...    db_name=${db_name}

Mongo Db Find
    [Documentation]    Connects to a MongoDB database and collection, runs a find query
    ...    with optional sorting, and returns a dictionary containing status_code and result body.
    ...
    ...    Arguments:
    ...    - db_name (str): Name of the MongoDB database to connect to.
    ...    - collection_name (str): Name of the collection to query.
    ...    - query_dict (dict or JSON string): Query to execute (filter conditions).
    ...    - sort (list of tuples, optional): Sorting instructions as list of [field, direction] pairs.
    ...    Example: [["created_at", 1], ["priority", -1]]
    ...    Where 1 = ascending, -1 = descending.
    ...
    ...    Status Codes:
    ...    - 0: Documents found and returned.
    ...    - 1: Internal error occurred.
    ...
    ...    Returns:
    ...    Dictionary:
    ...    {
    ...    "status_code": int,
    ...    "body": list of documents (with _id converted to string)
    ...    }
    ...
    ...    Example Usage:
    ...
    ...    `*** Variables ***`
    ...
    ...    ```${QUERY}    {"username": "john.doe", "active": true}```
    ...
    ...    ```${SORT}    [["creationDate", -1]]```
    ...
    ...    `*** Test Cases ***`
    ...
    ...    ```Find Active Users With Sorting
    ...    ${response}    Mongo Db Find    my_database    users    ${QUERY}    ${SORT}
    ...    ```
    [Arguments]    ${db_name}    ${collection_name}    ${query_dict}    ${sort}=None
    Initiate Mongo Db Connection    ${db_name}
    ${response}    MONGO_DB.Find Documents    ${collection_name}    ${query_dict}    ${sort}
    MONGO_DB.Close Db Connection
    RETURN    ${response}

Mongo Db Find One
    [Documentation]    Connects to a MongoDB database and collection, runs a find_one query
    ...    with optional sorting, and returns a dictionary containing status_code and result body.
    ...
    ...    Arguments:
    ...    - db_name (str): Name of the MongoDB database to connect to.
    ...    - collection_name (str): Name of the collection to query.
    ...    - query_dict (dict or JSON string): Query to execute (filter condition).
    ...    - sort (list of tuples, optional): Sorting instructions as list of [field, direction] pairs.
    ...    Example: [["created_at", 1], ["priority", -1]]
    ...    Where 1 = ascending, -1 = descending.
    ...
    ...    Status Codes:
    ...    - 0: Document found and returned.
    ...    - 1: Internal error occurred.
    ...
    ...    Returns:
    ...    Dictionary:
    ...    {
    ...    "status_code": int,
    ...    "body": document dictionary (with _id converted to string) or empty dict
    ...    }
    ...
    ...    Example Usage:
    ...
    ...    `*** Variables ***`
    ...
    ...    ```${QUERY}    {"status": "active"}```
    ...
    ...    ```${SORT}    [["created_at", -1]]```
    ...
    ...    `*** Test Cases ***`
    ...
    ...    ```
    ...    ${response}    Mongo Db Find One    my_database    users    ${QUERY}    ${SORT}
    ...    ```
    [Arguments]    ${db_name}    ${collection_name}    ${query_dict}    ${sort}=None
    Initiate Mongo Db Connection    ${db_name}
    ${response}    MONGO_DB.Find One    ${collection_name}    ${query_dict}    ${sort}
    MONGO_DB.Close Db Connection
    RETURN    ${response}

Mongo Db Insert One
    [Documentation]    Connects to a MongoDB database and collection, inserts a single document,
    ...    and returns a dictionary containing status_code and inserted ID.
    ...
    ...    Arguments:
    ...    - db_name (str): Name of the MongoDB database to connect to.
    ...    - collection_name (str): Name of the collection where document will be inserted.
    ...    - data (dict or JSON string): Document to insert.
    ...
    ...    Status Codes:
    ...    - 0: Insert successful.
    ...    - 1: Internal error occurred.
    ...
    ...    Returns:
    ...    Dictionary:
    ...    {
    ...    "status_code": int,
    ...    "body": {"inserted_id": str} or {"error": str}
    ...    }
    ...
    ...    Example Usage:
    ...
    ...    `*** Variables ***`
    ...
    ...    ```${DATA}    {"username": "john.doe", "email": "john.doe@email.com"}```
    ...
    ...    `*** Test Cases ***`
    ...
    ...    ```
    ...    ${response}    Mongo Db Insert One    my_database    users    ${DATA}
    ...    ```
    [Arguments]    ${db_name}    ${collection_name}    ${data}
    Initiate Mongo Db Connection    ${db_name}
    ${response}    MONGO_DB.Insert One    ${collection_name}    ${data}
    MONGO_DB.Close Db Connection
    RETURN    ${response}

Mongo Db Insert Many
    [Documentation]    Connects to a MongoDB database and collection, inserts multiple documents,
    ...    and returns a dictionary containing status_code and inserted IDs.
    ...
    ...    Arguments:
    ...    - db_name (str): Name of the MongoDB database to connect to.
    ...    - collection_name (str): Name of the collection where documents will be inserted.
    ...    - data_list (list of dicts or JSON string): List of documents to insert.
    ...
    ...    Status Codes:
    ...    - 0: Insert successful.
    ...    - 1: Internal error occurred.
    ...
    ...    Returns:
    ...    Dictionary:
    ...    {
    ...    "status_code": int,
    ...    "body": {"inserted_ids": [str, str, ...]} or {"error": str}
    ...    }
    ...
    ...    Example Usage:
    ...
    ...    `*** Variables ***`
    ...
    ...    ```@{DATA_LIST}    [{"username": "john.doe"}, {"username": "jane.smith"}]```
    ...
    ...    `*** Test Cases ***`
    ...
    ...    ```
    ...    ${response}    Mongo Db Insert Many    my_database    users    ${DATA_LIST}
    ...    ```
    [Arguments]    ${db_name}    ${collection_name}    ${data_list}
    Initiate Mongo Db Connection    ${db_name}
    ${response}    MONGO_DB.Insert Many    ${collection_name}    ${data_list}
    MONGO_DB.Close Db Connection
    RETURN    ${response}

Mongo Db Update One
    [Documentation]    Connects to a MongoDB database and collection, updates a single document
    ...    matching the filter query, and returns a dictionary containing status_code and update result.
    ...
    ...    Arguments:
    ...    - db_name (str): Name of the MongoDB database to connect to.
    ...    - collection_name (str): Name of the collection where document will be updated.
    ...    - filter_query (dict or JSON string): Query to match the document to update.
    ...    - update_data (dict or JSON string): The update operations to apply (e.g. {"$set": {...}}).
    ...
    ...    Status Codes:
    ...    - 0: Update successful.
    ...    - 1: Internal error occurred.
    ...
    ...    Returns:
    ...    Dictionary:
    ...    {
    ...    "status_code": int,
    ...    "body": {
    ...    "matched_count": int,
    ...    "modified_count": int
    ...    }
    ...    }
    ...
    ...    Example Usage:
    ...
    ...    `*** Variables ***`
    ...
    ...    ```${FILTER}    {"username": "john.doe"}```
    ...
    ...    ```${UPDATE}    {"$set": {"email": "new.email@email.com"}}```
    ...
    ...    `*** Test Cases ***`
    ...
    ...    ```
    ...    ${response}    Mongo Db Update One    my_database    users    ${FILTER}    ${UPDATE}
    ...    ```
    [Arguments]    ${db_name}    ${collection_name}    ${filter_query}    ${update_data}
    Initiate Mongo Db Connection    ${db_name}
    ${response}    MONGO_DB.Update One    ${collection_name}    ${filter_query}    ${update_data}
    MONGO_DB.Close Db Connection
    RETURN    ${response}

Mongo Db Update Many
    [Documentation]    Connects to a MongoDB database and collection, updates multiple documents
    ...    matching the filter query, and returns a dictionary containing status_code and update result.
    ...
    ...    Arguments:
    ...    - db_name (str): Name of the MongoDB database to connect to.
    ...    - collection_name (str): Name of the collection where documents will be updated.
    ...    - filter_query (dict or JSON string): Query to match the documents to update.
    ...    - update_data (dict or JSON string): The update operations to apply (e.g. {"$set": {...}}).
    ...
    ...    Status Codes:
    ...    - 0: Update successful.
    ...    - 1: Internal error occurred.
    ...
    ...    Returns:
    ...    Dictionary:
    ...    {
    ...    "status_code": int,
    ...    "body": {
    ...    "matched_count": int,
    ...    "modified_count": int
    ...    }
    ...    }
    ...
    ...    Example Usage:
    ...
    ...    `*** Variables ***`
    ...
    ...    ```${FILTER}    {"active": false}```
    ...
    ...    ```${UPDATE}    {"$set": {"status": "archived"}}```
    ...
    ...    `*** Test Cases ***`
    ...
    ...    ```
    ...    ${response}    Mongo Db Update Many    my_database    users    ${FILTER}    ${UPDATE}
    ...    ```
    [Arguments]    ${db_name}    ${collection_name}    ${filter_query}    ${update_data}
    Initiate Mongo Db Connection    ${db_name}
    ${response}    MONGO_DB.Update Many    ${collection_name}    ${filter_query}    ${update_data}
    MONGO_DB.Close Db Connection
    RETURN    ${response}

Mongo Db Delete One
    [Documentation]    Connects to a MongoDB database and collection, deletes a single document
    ...    matching the filter query, and returns a dictionary containing status_code and delete result.
    ...
    ...    Arguments:
    ...    - db_name (str): Name of the MongoDB database to connect to.
    ...    - collection_name (str): Name of the collection where document will be deleted.
    ...    - filter_query (dict or JSON string): Query to match the document to delete.
    ...
    ...    Status Codes:
    ...    - 0: Delete successful.
    ...    - 1: Internal error occurred.
    ...
    ...    Returns:
    ...    Dictionary:
    ...    {
    ...    "status_code": int,
    ...    "body": {
    ...    "deleted_count": int
    ...    }
    ...    }
    ...
    ...    Example Usage:
    ...
    ...    `*** Variables ***`
    ...
    ...    ```${FILTER}    {"username": "john.doe"}```
    ...
    ...    `*** Test Cases ***`
    ...
    ...    ```
    ...    ${response}    Mongo Db Delete One    my_database    users    ${FILTER}
    ...    ```
    [Arguments]    ${db_name}    ${collection_name}    ${filter_query}
    Initiate Mongo Db Connection    ${db_name}
    ${response}    MONGO_DB.Delete One    ${collection_name}    ${filter_query}
    MONGO_DB.Close Db Connection
    RETURN    ${response}

Mongo Db Delete Many
    [Documentation]    Connects to a MongoDB database and collection, deletes all documents
    ...    matching the filter query, and returns a dictionary containing status_code and delete result.
    ...
    ...    Arguments:
    ...    - db_name (str): Name of the MongoDB database to connect to.
    ...    - collection_name (str): Name of the collection where documents will be deleted.
    ...    - filter_query (dict or JSON string): Query to match documents to delete.
    ...
    ...    Status Codes:
    ...    - 0: Delete successful.
    ...    - 1: Internal error occurred.
    ...
    ...    Returns:
    ...    Dictionary:
    ...    {
    ...    "status_code": int,
    ...    "body": {
    ...    "deleted_count": int
    ...    }
    ...    }
    ...
    ...    Example Usage:
    ...
    ...    `*** Variables ***`
    ...
    ...    ```${FILTER}    {"status": "inactive"}```
    ...
    ...    `*** Test Cases ***`
    ...
    ...    ```
    ...    ${response}    Mongo Db Delete Many    my_database    users    ${FILTER}
    ...    ```
    [Arguments]    ${db_name}    ${collection_name}    ${filter_query}
    Initiate Mongo Db Connection    ${db_name}
    ${response}    MONGO_DB.Delete Many    ${collection_name}    ${filter_query}
    MONGO_DB.Close Db Connection
    RETURN    ${response}

Mongo Db Aggregate
    [Documentation]    Connects to a MongoDB database and collection, executes an aggregation pipeline,
    ...    and returns a dictionary containing status_code and aggregation results.
    ...
    ...    Arguments:
    ...    - db_name (str): Name of the MongoDB database to connect to.
    ...    - collection_name (str): Name of the collection to run aggregation on.
    ...    - pipeline (list of dicts or JSON string): Aggregation pipeline stages.
    ...
    ...    Status Codes:
    ...    - 0: Aggregation successful.
    ...    - 1: Internal error occurred.
    ...
    ...    Returns:
    ...    Dictionary:
    ...    {
    ...    "status_code": int,
    ...    "body": list of aggregation results
    ...    }
    ...
    ...    Example Usage:
    ...
    ...    `*** Variables ***
    ...
    ...    ```${PIPELINE}    [{"$match": {"status": "active"}}, {"$group": {"_id": "$category", "count": {"$sum": 1}}}]```
    ...
    ...    `*** Test Cases ***`
    ...
    ...    ```
    ...    ${response}    Mongo Db Aggregate    my_database    users    ${PIPELINE}
    ...    ```
    [Arguments]    ${db_name}    ${collection_name}    ${pipeline}
    Initiate Mongo Db Connection    ${db_name}
    ${response}    MONGO_DB.Aggregate    ${collection_name}    ${pipeline}
    MONGO_DB.Close Db Connection
    RETURN    ${response}

Mongo Db Count Documents
    [Documentation]    Connects to a MongoDB database and collection, counts the number of documents
    ...    matching the provided query, and returns a dictionary containing status_code and count result.
    ...
    ...    Arguments:
    ...    - db_name (str): Name of the MongoDB database to connect to.
    ...    - collection_name (str): Name of the collection to count documents from.
    ...    - query_dict (dict or JSON string): Query to filter documents (optional, default is empty query).
    ...
    ...    Status Codes:
    ...    - 0: Count successful.
    ...    - 1: Internal error occurred.
    ...
    ...    Returns:
    ...    Dictionary:
    ...    {
    ...    "status_code": int,
    ...    "body": {"count": int}
    ...    }
    ...
    ...    Example Usage:
    ...
    ...    `*** Variables ***`
    ...
    ...    ```${QUERY}    {"status": "active"}```
    ...
    ...    `*** Test Cases ***`
    ...
    ...    ```
    ...    ${response}    Mongo Db Count Documents    my_database    users    ${QUERY}
    ...    ```
    [Arguments]    ${db_name}    ${collection_name}    ${query_dict}=${EMPTY}
    Initiate Mongo Db Connection    ${db_name}
    ${response}    MONGO_DB.Count Documents    ${collection_name}    ${query_dict}
    MONGO_DB.Close Db Connection
    RETURN    ${response}

Mongo Db Estimated Document Count
    [Documentation]    Connects to a MongoDB database and collection, estimates the number of documents
    ...    (faster but less accurate than exact count), and returns a dictionary containing status_code
    ...    and estimated count result.
    ...
    ...    Arguments:
    ...    - db_name (str): Name of the MongoDB database to connect to.
    ...    - collection_name (str): Name of the collection to estimate document count.
    ...
    ...    Status Codes:
    ...    - 0: Estimate successful.
    ...    - 1: Internal error occurred.
    ...
    ...    Returns:
    ...    Dictionary:
    ...    {
    ...    "status_code": int,
    ...    "body": {"estimated_count": int}
    ...    }
    ...
    ...    Example Usage:
    ...
    ...    `*** Test Cases ***`
    ...
    ...    ```
    ...    ${response}    Mongo Db Estimated Document Count    my_database    users
    ...    ```
    [Arguments]    ${db_name}    ${collection_name}
    Initiate Mongo Db Connection    ${db_name}
    ${response}    MONGO_DB.Estimated Document Count    ${collection_name}
    MONGO_DB.Close Db Connection
    RETURN    ${response}

Mongo Db Distinct
    [Documentation]    Connects to a MongoDB database and collection, returns distinct values
    ...    for the specified key across documents matching the optional query.
    ...
    ...    Arguments:
    ...    - db_name (str): Name of the MongoDB database to connect to.
    ...    - collection_name (str): Name of the collection to query.
    ...    - key (str): The field name to return distinct values for.
    ...    - query_dict (dict or JSON string, optional): Query to filter documents before applying distinct.
    ...
    ...    Status Codes:
    ...    - 0: Operation successful.
    ...    - 1: Internal error occurred.
    ...
    ...    Returns:
    ...    Dictionary:
    ...    {
    ...    "status_code": int,
    ...    "body": list of distinct values
    ...    }
    ...
    ...    Example Usage:
    ...
    ...    `*** Variables ***`
    ...
    ...    ```${QUERY}    {"status": "active"}```
    ...
    ...    `*** Test Cases ***`
    ...
    ...    ```
    ...    ${response}    Mongo Db Distinct    my_database    users    role    ${QUERY}
    ...    ```
    [Arguments]    ${db_name}    ${collection_name}    ${key}    ${query_dict}=${EMPTY}
    Initiate Mongo Db Connection    ${db_name}
    ${response}    MONGO_DB.Distinct    ${collection_name}    ${key}    ${query_dict}
    MONGO_DB.Close Db Connection
    RETURN    ${response}

Mongo Db Find One And Update
    [Documentation]    Connects to a MongoDB database and collection, finds a single document matching
    ...    the filter query and updates it. Optionally returns either the updated or original document.
    ...
    ...    Arguments:
    ...    - db_name (str): Name of the MongoDB database to connect to.
    ...    - collection_name (str): Name of the collection to update.
    ...    - filter_query (dict or JSON string): Query to select the document to update.
    ...    - update_data (dict or JSON string): Update operations to apply (e.g. {"$set": {...}}).
    ...    - return_updated (bool, optional): If True (default), returns the updated document;
    ...    if False, returns the document before update.
    ...
    ...    Status Codes:
    ...    - 0: Update successful.
    ...    - 1: Internal error occurred.
    ...
    ...    Returns:
    ...    Dictionary:
    ...    {
    ...    "status_code": int,
    ...    "body": updated document (with _id converted to string) or empty dict
    ...    }
    ...
    ...    Example Usage:
    ...
    ...    `*** Variables ***`
    ...
    ...    ```${FILTER}    {"username": "john.doe"}```
    ...    ```${UPDATE}    {"$set": {"email": "new.email@email.com"}}```
    ...
    ...    `*** Test Cases ***`
    ...
    ...    ```
    ...    ${response}    Mongo Db Find One And Update    my_database    users    ${FILTER}    ${UPDATE}    ${True}
    ...    ```
    [Arguments]    ${db_name}    ${collection_name}    ${filter_query}    ${update_data}    ${return_updated}=True
    Initiate Mongo Db Connection    ${db_name}
    ${response}    MONGO_DB.Find One And Update
    ...    ${collection_name}
    ...    ${filter_query}
    ...    ${update_data}
    ...    ${return_updated}
    MONGO_DB.Close Db Connection
    RETURN    ${response}

Mongo Db Find One And Replace
    [Documentation]    Connects to a MongoDB database and collection, finds a single document matching
    ...    the filter query and completely replaces it with new data. Optionally returns either the
    ...    replaced or original document.
    ...
    ...    Arguments:
    ...    - db_name (str): Name of the MongoDB database to connect to.
    ...    - collection_name (str): Name of the collection to update.
    ...    - filter_query (dict or JSON string): Query to select the document to replace.
    ...    - replacement_data (dict or JSON string): New document to completely replace the matched document.
    ...    - return_updated (bool, optional): If True (default), returns the new document;
    ...    if False, returns the document before replacement.
    ...
    ...    Status Codes:
    ...    - 0: Replace successful.
    ...    - 1: Internal error occurred.
    ...
    ...    Returns:
    ...    Dictionary:
    ...    {
    ...    "status_code": int,
    ...    "body": replaced document (with _id converted to string) or empty dict
    ...    }
    ...
    ...    Example Usage:
    ...
    ...    `*** Variables ***`
    ...
    ...    ```${FILTER}    {"user_id": 123}```
    ...    ```${REPLACEMENT}    {"user_id": 123, "username": "newuser", "status": "active"}```
    ...
    ...    `*** Test Cases ***`
    ...
    ...    ```
    ...    ${response}    Mongo Db Find One And Replace    my_database    users    ${FILTER}    ${REPLACEMENT}    ${True}
    ...    ```
    [Arguments]    ${db_name}    ${collection_name}    ${filter_query}    ${replacement_data}    ${return_updated}=True
    Initiate Mongo Db Connection    ${db_name}
    ${response}    MONGO_DB.Find One And Replace
    ...    ${collection_name}
    ...    ${filter_query}
    ...    ${replacement_data}
    ...    ${return_updated}
    MONGO_DB.Close Db Connection
    RETURN    ${response}

Mongo Db Find One And Delete
    [Documentation]    Connects to a MongoDB database and collection, finds a single document matching
    ...    the filter query and deletes it. Returns the deleted document.
    ...
    ...    Arguments:
    ...    - db_name (str): Name of the MongoDB database to connect to.
    ...    - collection_name (str): Name of the collection to delete from.
    ...    - filter_query (dict or JSON string): Query to select the document to delete.
    ...
    ...    Status Codes:
    ...    - 0: Delete successful.
    ...    - 1: Internal error occurred.
    ...
    ...    Returns:
    ...    Dictionary:
    ...    {
    ...    "status_code": int,
    ...    "body": deleted document (with _id converted to string) or empty dict
    ...    }
    ...
    ...    Example Usage:
    ...
    ...    `*** Variables ***`
    ...
    ...    ```${FILTER}    {"username": "john.doe"}```
    ...
    ...    `*** Test Cases ***`
    ...
    ...    ```
    ...    ${response}    Mongo Db Find One And Delete    my_database    users    ${FILTER}
    ...    ```
    [Arguments]    ${db_name}    ${collection_name}    ${filter_query}
    Initiate Mongo Db Connection    ${db_name}
    ${response}    MONGO_DB.Find One And Delete    ${collection_name}    ${filter_query}
    MONGO_DB.Close Db Connection
    RETURN    ${response}

Mongo Db List Indexes
    [Documentation]    Connects to a MongoDB database and collection, lists all indexes
    ...    defined on the specified collection, and returns a dictionary containing status_code and index list.
    ...
    ...    Arguments:
    ...    - db_name (str): Name of the MongoDB database to connect to.
    ...    - collection_name (str): Name of the collection to list indexes for.
    ...
    ...    Status Codes:
    ...    - 0: Operation successful.
    ...    - 1: Internal error occurred.
    ...
    ...    Returns:
    ...    Dictionary:
    ...    {
    ...    "status_code": int,
    ...    "body": list of index information
    ...    }
    ...
    ...    Example Usage:
    ...
    ...    `*** Test Cases ***`
    ...
    ...    ```
    ...    ${response}    Mongo Db List Indexes    my_database    users
    ...    ```
    [Arguments]    ${db_name}    ${collection_name}
    Initiate Mongo Db Connection    ${db_name}
    ${response}    MONGO_DB.List Indexes    ${collection_name}
    MONGO_DB.Close Db Connection
    RETURN    ${response}

Mongo Db Create Index
    [Documentation]    Connects to a MongoDB database and collection, creates an index on the specified keys,
    ...    and returns the created index name.
    ...
    ...    Arguments:
    ...    - db_name (str): Name of the MongoDB database to connect to.
    ...    - collection_name (str): Name of the collection to create index on.
    ...    - keys (list of tuples): Index keys, e.g. [["field1", 1], ["field2", -1]].
    ...    - unique (bool, optional): Whether to create a unique index (default: False).
    ...
    ...    Status Codes:
    ...    - 0: Index created successfully.
    ...    - 1: Internal error occurred.
    ...
    ...    Returns:
    ...    Dictionary:
    ...    {
    ...    "status_code": int,
    ...    "body": {"index_name": str}
    ...    }
    ...
    ...    Example Usage:
    ...
    ...    `*** Variables ***`
    ...
    ...    ```${KEYS}    [["username", 1]]```
    ...
    ...    `*** Test Cases ***`
    ...
    ...    ```
    ...    ${response}    Mongo Db Create Index    my_database    users    ${KEYS}    ${True}
    ...    ```
    [Arguments]    ${db_name}    ${collection_name}    ${keys}    ${unique}=False
    Initiate Mongo Db Connection    ${db_name}
    ${response}    MONGO_DB.Create Index    ${collection_name}    ${keys}    ${unique}
    MONGO_DB.Close Db Connection
    RETURN    ${response}

Mongo Db Drop Index
    [Documentation]    Connects to a MongoDB database and collection, drops the specified index.
    ...
    ...    Arguments:
    ...    - db_name (str): Name of the MongoDB database to connect to.
    ...    - collection_name (str): Name of the collection.
    ...    - index_name (str): Name of the index to drop.
    ...
    ...    Status Codes:
    ...    - 0: Index dropped successfully.
    ...    - 1: Internal error occurred.
    ...
    ...    Returns:
    ...    Dictionary:
    ...    {
    ...    "status_code": int,
    ...    "body": {"dropped": str}
    ...    }
    ...
    ...    Example Usage:
    ...
    ...    ```
    ...    ${response}    Mongo Db Drop Index    my_database    users    username_1
    ...    ```
    [Arguments]    ${db_name}    ${collection_name}    ${index_name}
    Initiate Mongo Db Connection    ${db_name}
    ${response}    MONGO_DB.Drop Index    ${collection_name}    ${index_name}
    MONGO_DB.Close Db Connection
    RETURN    ${response}

Mongo Db List Collections
    [Documentation]    Connects to a MongoDB database and lists all collection names.
    ...
    ...    Arguments:
    ...    - db_name (str): Name of the MongoDB database to connect to.
    ...
    ...    Status Codes:
    ...    - 0: Operation successful.
    ...    - 1: Internal error occurred.
    ...
    ...    Returns:
    ...    Dictionary:
    ...    {
    ...    "status_code": int,
    ...    "body": list of collection names
    ...    }
    ...
    ...    Example Usage:
    ...
    ...    ```
    ...    ${response}    Mongo Db List Collections    my_database
    ...    ```
    [Arguments]    ${db_name}
    Initiate Mongo Db Connection    ${db_name}
    ${response}    MONGO_DB.List Collections
    MONGO_DB.Close Db Connection
    RETURN    ${response}
