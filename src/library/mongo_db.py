from pymongo import MongoClient
from pymongo import ReturnDocument
from urllib.parse import quote_plus
from robot.api.deco import keyword
import json
import ast

_client = None
_db = None


@keyword
def connect_to_db(host, port, user, password, db_name):
    """
    Connect to MongoDB using provided connection parameters.

    Args:
        host (str): MongoDB host address.
        port (int): MongoDB port number.
        user (str): Username for MongoDB authentication.
        password (str): Password for MongoDB authentication.
        db_name (str): Name of the database to connect to.

    Side Effects:
        - Establishes a global MongoClient connection.
        - Sets the global _db variable to the specified database.

    Raises:
        pymongo.errors.ConnectionError: If the connection to MongoDB fails.
    """
    global _client, _db

    user = quote_plus(user)
    password = CHANGE_ME
    uri = (
        f"mongodb://{user}:{password}@{host}:{port}/{db_name}"
        f"?authSource={db_name}"
        "&authMechanism=SCRAM-SHA-1"
        "&connectTimeoutMS=20000"
        "&serverSelectionTimeoutMS=20000"
        "&directConnection=true"
    )

    _client = MongoClient(uri)
    _db = _client[db_name]
    print(f"Connected to database: {db_name}")


@keyword
def close_db_connection():
    """
    Close the MongoDB connection and reset global variables.

    Side Effects:
        - Closes the active MongoClient connection if open.
        - Resets _client and _db to None.
    """
    global _client, _db
    if _client:
        _client.close()
        print("MongoDB connection closed.")
    _client = None
    _db = None


def _collection(name):
    """
    Get the MongoDB collection object by name.

    Args:
        name (str): The name of the collection.

    Returns:
        pymongo.collection.Collection: The MongoDB collection object.

    Raises:
        RuntimeError: If the database connection is not established.
    """
    if _db is None:
        raise RuntimeError("Database not connected. Call connect_to_db first.")
    return _db[name]


def _prepare(data):
    """
    Accept either:
    - A proper Python dict (ideal)
    - A JSON string (fallback)
    - A Python-literal string (safely parsed with literal_eval)

    Raises clear error if input can't be parsed.
    """
    if isinstance(data, (dict, list)):
        return data
    if isinstance(data, str):
        try:
            return json.loads(data)
        except json.JSONDecodeError:
            try:
                return ast.literal_eval(data)
            except Exception as e:
                raise ValueError(
                    f"Could not parse string input as dict or list: {data}"
                ) from e
    raise TypeError(f"Unsupported type for MongoDB update input: {type(data)}")


@keyword
def insert_one(collection_name, data):
    """
    Insert a single document into the specified collection.

    Returns:
        dict:
            - status_code: HTTP-style status code
                * 0: Insert successful
                * 1: Internal error occurred
            - body: Dictionary containing inserted ID or error
    """
    try:
        result = _collection(collection_name).insert_one(_prepare(data))
        return {"status_code": 0, "body": {"inserted_id": str(result.inserted_id)}}

    except Exception as e:
        return {"status_code": 1, "body": {"error": str(e)}}


@keyword
def insert_many(collection_name, data_list):
    """
    Insert multiple documents into the specified collection.

    Returns:
        dict:
            - status_code: HTTP-style status code
                * 0: Insert successful
                * 1: Internal error occurred
            - body: Dictionary containing inserted IDs or error
    """
    try:
        prepared_data = _prepare(data_list)
        result = _collection(collection_name).insert_many(prepared_data)
        return {
            "status_code": 0,
            "body": {"inserted_ids": [str(_id) for _id in result.inserted_ids]},
        }

    except Exception as e:
        return {"status_code": 1, "body": {"error": str(e)}}


@keyword
def find_documents(collection_name, query=None, sort=None):
    """
    Find multiple documents based on a query, with optional sorting.

    Args:
        collection_name (str): Name of the MongoDB collection.
        query (dict or JSON string, optional): Filter query. Default is empty query.
        sort (list of tuples, optional): Sorting instructions as list of (field, direction) tuples.
                                         Direction can be pymongo.ASCENDING or pymongo.DESCENDING.

    Returns:
        dict:
            - status_code: HTTP-style status code
                * 0: Query successful
                * 1: Internal error occurred
            - body: List of document dictionaries (with _id converted to string)
    """
    try:
        query = _prepare(query or {})
        result = _collection(collection_name).find(query)

        if sort:
            result = result.sort(sort)

        result = list(result)

        for doc in result:
            doc["_id"] = str(doc["_id"])

        return {"status_code": 0, "body": result}

    except Exception as e:
        return {"status_code": 1, "body": {"error": str(e)}}


@keyword
def find_one(collection_name, query=None, sort=None):
    """
    Find a single document based on a query, with optional sorting.

    Args:
        collection_name (str): Name of the MongoDB collection.
        query (dict or JSON string, optional): Filter query. Default is empty query.
        sort (list of tuples, optional): Sorting instructions as list of (field, direction) tuples.
                                         Direction can be pymongo.ASCENDING or pymongo.DESCENDING.

    Returns:
        dict:
            - status_code: HTTP-style status code
                * 0: Query successful
                * 1: Internal error occurred
            - body: Document dictionary (with _id converted to string) or empty dict
    """
    try:
        query = _prepare(query or {})

        if sort:
            doc = _collection(collection_name).find_one(query, sort=sort)
        else:
            doc = _collection(collection_name).find_one(query)

        if doc and "_id" in doc:
            doc["_id"] = str(doc["_id"])

        return {"status_code": 0, "body": doc or {}}

    except Exception as e:
        return {"status_code": 1, "body": {"error": str(e)}}


@keyword
def update_one(collection_name, filter_query, update_data):
    """
    Update a single document matching the filter query.

    Returns:
        dict:
            - status_code: HTTP-style status code
                * 0: Update successful
                * 1: Internal error occurred
            - body: Dictionary containing update result or error
    """

    print(f"This is the filter query : {_prepare(filter_query)}")
    print(f"This is the update data : {_prepare(update_data)}")

    try:
        result = _collection(collection_name).update_one(
            _prepare(filter_query), _prepare(update_data)
        )

        return {
            "status_code": 0,
            "body": {
                "matched_count": result.matched_count,
                "modified_count": result.modified_count,
            },
        }

    except Exception as e:
        return {"status_code": 1, "body": {"error": str(e)}}


@keyword
def update_many(collection_name, filter_query, update_data):
    """
    Update all documents matching the filter query.

    Returns:
        dict:
            - status_code: HTTP-style status code
                * 0: Update successful
                * 1: Internal error occurred
            - body: Dictionary containing update result or error
    """
    try:
        result = _collection(collection_name).update_many(
            _prepare(filter_query), _prepare(update_data)
        )

        return {
            "status_code": 0,
            "body": {
                "matched_count": result.matched_count,
                "modified_count": result.modified_count,
            },
        }

    except Exception as e:
        return {"status_code": 1, "body": {"error": str(e)}}


@keyword
def delete_one(collection_name, filter_query):
    """
    Delete a single document matching the filter query.

    Returns:
        dict:
            - status_code: HTTP-style status code
                * 0: Delete successful
                * 1: Internal error occurred
            - body: Dictionary containing delete result or error
    """
    try:
        result = _collection(collection_name).delete_one(_prepare(filter_query))

        return {"status_code": 0, "body": {"deleted_count": result.deleted_count}}

    except Exception as e:
        return {"status_code": 1, "body": {"error": str(e)}}


@keyword
def delete_many(collection_name, filter_query):
    """
    Delete all documents matching the filter query.

    Returns:
        dict:
            - status_code: HTTP-style status code
                * 0: Delete successful
                * 1: Internal error occurred
            - body: Dictionary containing delete result or error
    """
    try:
        result = _collection(collection_name).delete_many(_prepare(filter_query))

        return {"status_code": 0, "body": {"deleted_count": result.deleted_count}}

    except Exception as e:
        return {"status_code": 1, "body": {"error": str(e)}}


@keyword
def aggregate(collection_name, pipeline):
    """
    Run an aggregation pipeline on the specified collection.

    Returns:
        dict:
            - status_code: HTTP-style status code
                * 0: Aggregation successful
                * 1: Internal error occurred
            - body: List containing aggregation results or error
    """
    try:
        pipeline = _prepare(pipeline)
        result = list(_collection(collection_name).aggregate(pipeline))
        return {"status_code": 0, "body": result}
    except Exception as e:
        return {"status_code": 1, "body": {"error": str(e)}}


@keyword
def count_documents(collection_name, query=None):
    """
    Count the number of documents matching the query.

    Returns:
        dict:
            - status_code: HTTP-style status code
                * 0: Count successful
                * 1: Internal error occurred
            - body: Dictionary containing count or error
    """
    try:
        query = _prepare(query or {})
        count = _collection(collection_name).count_documents(query)
        return {"status_code": 0, "body": {"count": count}}
    except Exception as e:
        return {"status_code": 1, "body": {"error": str(e)}}


@keyword
def estimated_document_count(collection_name):
    """
    Estimate the number of documents in the collection (faster but less accurate).

    Returns:
        dict:
            - status_code: HTTP-style status code
                * 0: Estimate successful
                * 1: Internal error occurred
            - body: Dictionary containing estimated count or error
    """
    try:
        count = _collection(collection_name).estimated_document_count()
        return {"status_code": 0, "body": {"estimated_count": count}}
    except Exception as e:
        return {"status_code": 1, "body": {"error": str(e)}}


@keyword
def distinct(collection_name, key, query=None):
    """
    Return distinct values for a key across documents matching the query.

    Args:
        collection_name (str): The name of the collection.
        key (str): The field name to return distinct values for.
        query (dict, optional): A MongoDB query to filter documents before applying distinct.

    Returns:
        dict:
            - status_code: HTTP-style status code
                * 0: Operation successful
                * 1: Internal error occurred
            - body: List containing distinct values or error
    """
    try:
        query = _prepare(query or {})
        result = _collection(collection_name).distinct(key, query)
        return {"status_code": 0, "body": result}
    except Exception as e:
        return {"status_code": 1, "body": {"error": str(e)}}


@keyword
def find_one_and_update(
    collection_name, filter_query, update_data, return_updated=True
):
    """
    Find a single document matching the filter query and update it.

    Args:
        collection_name (str): The name of the collection.
        filter_query (dict): The filter criteria for selecting the document.
        update_data (dict): The update operations to apply.
        return_updated (bool, optional):
            If True (default), return the updated document after update.
            If False, return the document before the update.

    Returns:
        dict:
            - status_code: HTTP-style status code
                * 0: Update successful
                * 1: Internal error occurred
            - body: Dictionary containing updated document or error
    """
    try:
        doc = _collection(collection_name).find_one_and_update(
            _prepare(filter_query),
            _prepare(update_data),
            return_document=(
                ReturnDocument.AFTER if return_updated else ReturnDocument.BEFORE
            ),
        )

        if doc and "_id" in doc:
            doc["_id"] = str(doc["_id"])

        return {"status_code": 0, "body": doc or {}}

    except Exception as e:
        return {"status_code": 1, "body": {"error": str(e)}}


@keyword
def find_one_and_replace(
    collection_name, filter_query, replacement_data, return_updated=True
):
    """
    Find a single document matching the filter query and replace it completely.

    Args:
        collection_name (str): The name of the collection.
        filter_query (dict): The filter criteria for selecting the document.
        replacement_data (dict): The new document to replace the matched document.
        return_updated (bool, optional):
            If True (default), return the new document after replacement.
            If False, return the document before replacement.

    Returns:
        dict:
            - status_code: HTTP-style status code
                * 0: Replace successful
                * 1: Internal error occurred
            - body: Dictionary containing replaced document or error
    """
    try:
        doc = _collection(collection_name).find_one_and_replace(
            _prepare(filter_query),
            _prepare(replacement_data),
            return_document=(
                ReturnDocument.AFTER if return_updated else ReturnDocument.BEFORE
            ),
        )

        if doc and "_id" in doc:
            doc["_id"] = str(doc["_id"])

        return {"status_code": 0, "body": doc or {}}

    except Exception as e:
        return {"status_code": 1, "body": {"error": str(e)}}


@keyword
def find_one_and_delete(collection_name, filter_query):
    """
    Find a single document matching the filter query and delete it.

    Args:
        collection_name (str): The name of the collection.
        filter_query (dict): The filter criteria for selecting the document to delete.

    Returns:
        dict:
            - status_code: HTTP-style status code
                * 0: Delete successful
                * 1: Internal error occurred
            - body: Dictionary containing deleted document or error
    """
    try:
        doc = _collection(collection_name).find_one_and_delete(_prepare(filter_query))

        if doc and "_id" in doc:
            doc["_id"] = str(doc["_id"])

        return {"status_code": 0, "body": doc or {}}

    except Exception as e:
        return {"status_code": 1, "body": {"error": str(e)}}


@keyword
def list_indexes(collection_name):
    """
    List all indexes defined on the specified collection.

    Args:
        collection_name (str): The name of the collection.

    Returns:
        dict:
            - status_code: HTTP-style status code
                * 0: Operation successful
                * 1: Internal error occurred
            - body: List of index information or error
    """
    try:
        indexes = list(_collection(collection_name).list_indexes())
        return {"status_code": 0, "body": indexes}
    except Exception as e:
        return {"status_code": 1, "body": {"error": str(e)}}


@keyword
def create_index(collection_name, keys, unique=False):
    """
    Create an index on the specified keys.

    Args:
        keys (list of tuples): e.g. [("field1", 1), ("field2", -1)]
        unique (bool): whether to create a unique index

    Returns:
        dict: status_code and index name
    """
    try:
        index_name = _collection(collection_name).create_index(keys, unique=unique)
        return {"status_code": 0, "body": {"index_name": index_name}}
    except Exception as e:
        return {"status_code": 1, "body": {"error": str(e)}}


@keyword
def drop_index(collection_name, index_name):
    """
    Drop an index from the collection.

    Returns:
        dict: status_code and result
    """
    try:
        _collection(collection_name).drop_index(index_name)
        return {"status_code": 0, "body": {"dropped": index_name}}
    except Exception as e:
        return {"status_code": 1, "body": {"error": str(e)}}


@keyword
def list_collections():
    """
    List all collection names in the current database.

    Returns:
        dict:
            - status_code: HTTP-style status code
                * 0: Operation successful
                * 1: Internal error occurred
            - body: List of collection names or error
    """
    try:
        if _db is None:
            raise RuntimeError("Database not connected.")

        collections = _db.list_collection_names()

        return {"status_code": 0, "body": collections}
    except Exception as e:
        return {"status_code": 1, "body": {"error": str(e)}}
