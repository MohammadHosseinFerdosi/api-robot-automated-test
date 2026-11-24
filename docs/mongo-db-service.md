# MongoDB Service

This Robot Framework service enables seamless interaction with MongoDB databases for automated testing purposes. It encapsulates various database operations into easy-to-use keywords, allowing you to connect to a MongoDB instance, execute queries, retrieve or insert documents, and manage data dynamically. These keywords are especially useful in end-to-end and integration testing scenarios where database state validation is essential.

The output follows a standard format similar to API responses:

```bash
{
  'status_code': 0 (success) or 1 (failure),
  'body': <operation result>
}
```

## Table of Keywords

- [Build Config For Mongo Db Handler](#build-config-for-mongo-db-handler)
- [Initiate Mongo Db Connection](#initiate-mongo-db-connection)
- [Mongo Db Find](#mongo-db-find)
- [Mongo Db Find One](#mongo-db-find-one)
- [Mongo Db Insert One](#mongo-db-insert-one)
- [Mongo Db Insert Many](#mongo-db-insert-many)
- [Mongo Db Update One](#mongo-db-update-one)
- [Mongo Db Update Many](#mongo-db-update-many)
- [Mongo Db Delete One](#mongo-db-delete-one)
- [Mongo Db Delete Many](#mongo-db-delete-many)
- [Mongo Db Aggregate](#mongo-db-aggregate)
- [Mongo Db Count Documents](#mongo-db-count-documents)
- [Mongo Db Estimated Document Count](#mongo-db-estimated-document-count)
- [Mongo Db Distinct](#mongo-db-distinct)
- [Mongo Db Find One And Update](#mongo-db-find-one-and-update)
- [Mongo Db Find One And Replace](#mongo-db-find-one-and-replace)
- [Mongo Db Find One And Delete](#mongo-db-find-one-and-delete)
- [Mongo Db List Indexes](#mongo-db-list-indexes)
- [Mongo Db Create Index](#mongo-db-create-index)
- [Mongo Db Drop Index](#mongo-db-drop-index)
- [Mongo Db List Collections](#mongo-db-list-collections)

---

## Build Config For Mongo Db Handler

**Description:**

Creates a configuration dictionary containing the necessary connection details for a MongoDB instance. This includes parameters such as username, password, host, and port, all derived from the given database name. Typically used internally to support other connection-related keywords. Make sure to include or modify this handler if you have a database that does not follow the generic config handler.

> This is a [private] Keyword

**Arguments:**

- `${db_name}`

**Example Usage:**

```bash

Build Config For Mongo Db Handler    ${db_name}
```

---

## Initiate Mongo Db Connection

**Description:**

Initializes a connection session with a MongoDB server using credentials specific to the database name. This prepares the environment for executing database operations like queries or inserts.

**Arguments:**

- `${db_name}`

**Example Usage:**

```bash

Initiate Mongo Db Connection    ${db_name}
```

---

## Mongo Db Find

**Description:**

Retrieves multiple documents from a specified collection in MongoDB that match a given query.

**Arguments:**

- `${db_name}`
- `${collection_name}`
- `${query_dict}`
- `${sort}=None`

```bash
Dictionary: {
  'status_code': 0 (success) or 1 (failure),
  'body': List of matched documents
}
```

**Example Usage:**

```bash

Mongo Db Find    ${db_name}    ${collection_name}    ${query_dict}    ${sort}=None
```

---

## Mongo Db Find One

**Description:**

Searches for and returns the first document from a MongoDB collection that matches the provided query.

**Arguments:**

- `${db_name}`
- `${collection_name}`
- `${query_dict}`
- `${sort}=None`

**Returns:**

```bash
Dictionary: {
  'status_code': 0 (success) or 1 (failure),
  'body': A single matched document or None
}
```

**Example Usage:**

```bash

Mongo Db Find One    ${db_name}    ${collection_name}    ${query_dict}    ${sort}=None
```

---

## Mongo Db Insert One

**Description:**

Adds a single document to the specified MongoDB collection.

**Arguments:**

- `${db_name}`
- `${collection_name}`
- `${data}`

**Returns:**

```bash
Dictionary: {
  'status_code': 0 (success) or 1 (failure),
  'body': Inserted document ID
}
```

> For more information check the documentations provided at each keyword withing the code

**Example Usage:**

```bash

Mongo Db Insert One    ${db_name}    ${collection_name}    ${data}
```

---

## Mongo Db Insert Many

**Description:**

Connects to a MongoDB database and collection and inserts multiple documents.

**Arguments:**

- `${db_name}`
- `${collection_name}`
- `&{data_list}`

**Returns:**

```bash
Dictionary: {
  'status_code': 0 (success) or 1 (failure),
  'body': List of inserted document IDs
}
```

**Example Usage:**

```bash

Mongo Db Insert Many    ${db_name}    ${collection_name}    ${data_list}
```

---

## Mongo Db Update One

**Description:**

Connects to a MongoDB database and collection and updates a single document matching the filter query.

**Arguments:**

- `${db_name}`
- `${collection_name}`
- `${filter_query}`
- `${update_data}`

**Returns:**

```bash
Dictionary: {
  'status_code': 0 (success) or 1 (failure),
  'body': {'matched_count': int, 'modified_count': int}
}
```

**Example Usage:**

```bash

Mongo Db Update One    ${db_name}    ${collection_name}    ${filter_query}    ${update_data}
```

---

## Mongo Db Update Many

**Description:**

Connects to a MongoDB database and collection and updates multiple documents matching the filter query.

**Arguments:**

- `${db_name}`
- `${collection_name}`
- `${filter_query}`
- `${update_data}`

**Returns:**

```bash
Dictionary: {
  'status_code': 0 (success) or 1 (failure),
  'body': {'matched_count': int, 'modified_count': int}
}
```

**Example Usage:**

```bash

Mongo Db Update Many    ${db_name}    ${collection_name}    ${filter_query}    ${update_data}
```

---

## Mongo Db Delete One

**Description:**

Connects to a MongoDB database and collection and deletes a single document matching the filter query.

**Arguments:**

- `${db_name}`
- `${collection_name}`
- `${filter_query}`

**Returns:**

```bash
Dictionary: {
  'status_code': 0 (success) or 1 (failure),
  'body': Deleted document or deletion count
}
```

**Example Usage:**

```bash

Mongo Db Delete One    ${db_name}    ${collection_name}    ${filter_query}
```

---

## Mongo Db Delete Many

**Description:**

Connects to a MongoDB database and collection and deletes all documents matching the filter query.

**Arguments:**

- `${db_name}`
- `${collection_name}`
- `${filter_query}`

**Returns:**

```bash
Dictionary: {
  'status_code': 0 (success) or 1 (failure),
  'body': Count of deleted documents
}
```

**Example Usage:**

```bash

Mongo Db Delete Many    ${db_name}    ${collection_name}    ${filter_query}
```

---

## Mongo Db Aggregate

**Description:**

Connects to a MongoDB database and collection and executes an aggregation pipeline.

**Arguments:**

- `${db_name}`
- `${collection_name}`
- `${pipeline}`

**Returns:**

```bash
Dictionary: {
  'status_code': 0 (success) or 1 (failure),
  'body': List of aggregation result documents
}
```

**Example Usage:**

```bash

Mongo Db Aggregate    ${db_name}    ${collection_name}    ${pipeline}
```

---

## Mongo Db Count Documents

**Description:**

Connects to a MongoDB database and collection and counts the number of documents matching the provided query.

**Arguments:**

- `${db_name}`
- `${collection_name}`
- `${query_dict}=${EMPTY}`

**Returns:**

```bash
Dictionary: {
  'status_code': 0 (success) or 1 (failure),
  'body': Count of matching documents
}
```

**Example Usage:**

```bash

Mongo Db Count Documents    ${db_name}    ${collection_name}    ${query_dict}=${EMPTY}
```

---

## Mongo Db Estimated Document Count

**Description:**

Connects to a MongoDB database and collection and estimates the number of documents (faster but less accurate than exact count).

**Arguments:**

- `${db_name}`
- `${collection_name}`

**Returns:**

```bash
Dictionary: {
  'status_code': 0 (success) or 1 (failure),
  'body': Estimated document count (int)
}
```

**Example Usage:**

```bash

Mongo Db Estimated Document Count    ${db_name}    ${collection_name}
```

---

## Mongo Db Distinct

**Description:**

Connects to a MongoDB database and collection and returns distinct values for the specified key across documents matching the optional query.

**Arguments:**

- `${db_name}`
- `${collection_name}`
- `${key}`
- `${query_dict}=${EMPTY}`

**Returns:**

```bash
Dictionary: {
  'status_code': 0 (success) or 1 (failure),
  'body': List of distinct values
}
```

**Example Usage:**

```bash

Mongo Db Distinct    ${db_name}    ${collection_name}    ${key}    ${query_dict}=${EMPTY}
```

---

## Mongo Db Find One And Update

**Description:**

Connects to a MongoDB database and collection and finds a single document matching the filter query and updates it. Optionally returns either the updated or original document.

**Arguments:**

- `${db_name}`
- `${collection_name}`
- `${filter_query}`
- `${update_data}`
- `${return_updated}=True`

**Returns:**

```bash
Dictionary: {
  'status_code': 0 (success) or 1 (failure),
  'body': The updated (or original) document
}
```

**Example Usage:**

```bash

Mongo Db Find One And Update    ${db_name}    ${collection_name}    ${filter_query}    ${update_data}    ${return_updated}=True
```

---

## Mongo Db Find One And Replace

**Description:**

Connects to a MongoDB database and collection and finds a single document matching the filter query and completely replaces it with new data. Optionally returns either the replaced or original document.

**Arguments:**

- `${db_name}`
- `${collection_name}`
- `${filter_query}`
- `${replacement_data}`
- `${return_updated}=True`

**Returns:**

```bash
Dictionary: {
  'status_code': 0 (success) or 1 (failure),
  'body': The replaced (or original) document
}
```

**Example Usage:**

```bash

Mongo Db Find One And Replace    ${db_name}    ${collection_name}    ${filter_query}    ${replacement_data}    ${return_updated}=True
```

---

## Mongo Db Find One And Delete

**Description:**

Connects to a MongoDB database and collection, finds a single document matching the filter query and deletes it.

**Arguments:**

- `${db_name}`
- `${collection_name}`
- `${filter_query}`

**Returns:**

```bash
Dictionary: {
  'status_code': 0 (success) or 1 (failure),
  'body': The deleted document
}
```

**Example Usage:**

```bash

Mongo Db Find One And Delete    ${db_name}    ${collection_name}    ${filter_query}
```

---

## Mongo Db List Indexes

**Description:**

Connects to a MongoDB database and collection and lists all indexes defined on the specified collection,

**Arguments:**

- `${db_name}`
- `${collection_name}`

**Returns:**

```bash
Dictionary: {
  'status_code': 0 (success) or 1 (failure),
  'body': List of index specifications
}
```

**Example Usage:**

```bash

Mongo Db List Indexes    ${db_name}    ${collection_name}
```

---

## Mongo Db Create Index

**Description:**

Connects to a MongoDB database and collection and creates an index on the specified keys.

**Arguments:**

- `${db_name}`
- `${collection_name}`
- `${keys}`
- `${unique}=False`

**Returns:**

```bash
Dictionary: {
  'status_code': 0 (success) or 1 (failure),
  'body': Name of the created index
}
```

**Example Usage:**

```bash

Mongo Db Create Index    ${db_name}    ${collection_name}    ${keys}    ${unique}=False
```

---

## Mongo Db Drop Index

**Description:**

Connects to a MongoDB database and collection and drops the specified index.

**Arguments:**

- `${db_name}`
- `${collection_name}`
- `${index_name}`

**Returns:**

```bash
Dictionary: {
  'status_code': 0 (success) or 1 (failure),
  'body': Index deletion acknowledgment
}
```

**Example Usage:**

```bash

Mongo Db Drop Index    ${db_name}    ${collection_name}    ${index_name}
```

---

## Mongo Db List Collections

**Description:**

Connects to a MongoDB database and lists all collection names.

**Arguments:**

- `${db_name}`

**Returns:**

```bash
Dictionary: {
  'status_code': 0 (success) or 1 (failure),
  'body': List of collection names
}
```

**Example Usage:**

```bash

Mongo Db List Collections    ${db_name}
```
