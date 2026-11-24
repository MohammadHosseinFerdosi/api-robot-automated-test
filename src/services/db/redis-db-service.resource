*** Settings ***
Library     String
Library     library/redis_db.py    WITH NAME    REDIS_DB


*** Keywords ***
Build Config For REDIS Db Handler
    [Documentation]    Builds the Redis Sentinel connection configuration dictionary for the specified master group.
    ...
    ...    This internal keyword generates the Sentinel connection parameters (host, port, master_name)
    ...    dynamically for Redis, based on the provided master name.
    ...
    ...    Arguments:
    ...    - master_name (str): Name of the Redis master group to connect to.
    ...
    ...    Returns:
    ...    Dictionary:
    ...    {
    ...    "sentinel_host": str,
    ...    "sentinel_port": int,
    ...    "master_name": str
    ...    }
    [Tags]    robot:private
    [Arguments]    ${master_name}

    IF    '${master_name}'=='redis-platform'
        ${host}    Set Variable    ${REDIS_PLATFORM_SENTIENT_HOST}
        ${port}    Set Variable    ${REDIS_PLATFORM_SENTIENT_PORT}
        ${config}    Create Dictionary    sentinel_host=${host}    sentinel_port=${port}    master_name=${master_name}
        RETURN    ${config}
    ELSE IF    '${master_name}'=='standalone'
        ${host}    Set Variable    ${REDIS_PLATFORM_STANDALONE_HOST}
        ${port}    Set Variable    ${REDIS_PLATFORM_STANDALONE_PORT}
        ${db}    Set Variable    0
        ${config}    Create Dictionary    standalone_host=${host}    standalone_port=${port}    db=${db}
        RETURN    ${config}
    ELSE IF    '${master_name}'=='second_standalone'
        ${host}    Set Variable    ${REDIS_PLATFORM_SECOND_STANDALONE_HOST}
        ${port}    Set Variable    ${REDIS_PLATFORM_SECOND_STANDALONE_PORT}
        ${db}    Set Variable    0
        ${config}    Create Dictionary    second_standalone_host=${host}    second_standalone_port=${port}    db=${db}
        RETURN    ${config}
    ELSE IF    '${master_name}'=='redis-new-master'
        ${hosts}    Set Variable    ${REDIS_OTP_SENTINEL_HOSTS}
        ${port}    Set Variable    ${REDIS_OTP_SENTINEL_PORT}
        ${config}    Create Dictionary    sentinel_hosts=${hosts}    sentinel_port=${port}    master_name=${master_name}
        RETURN    ${config}
    END

    Fail
    ...    msg=Redis Handler not not implemented for the master_name! Please implement your ${master_name} specific handler and then retry!

Initiate REDIS Db Connection
    [Documentation]    Initiates the Redis Sentinel connection by dynamically building the connection config
    ...    and calling the Python Redis Connect To Redis Sentinel keyword.
    ...
    ...    Arguments:
    ...    - master_name (str, optional): Name of the Redis master group to connect to.
    ...    Defaults to 'redis-platform' if not provided.
    [Arguments]    ${master_name}=standalone
    ${config}    Build Config For REDIS Db Handler    ${master_name}
    IF    '${master_name}'=='redis-platform'
        REDIS_DB.Connect To Redis Sentinel
        ...    ${config['sentinel_host']}
        ...    ${config['sentinel_port']}
        ...    ${config['master_name']}
        RETURN
    ELSE IF    '${master_name}'=='standalone'
        REDIS_DB.Connect To Redis Standalone
        ...    ${config['standalone_host']}
        ...    ${config['standalone_port']}
        ...    ${config['db']}
        RETURN
    ELSE IF    '${master_name}'=='second_standalone'
        REDIS_DB.Connect To Redis Standalone
        ...    ${config['second_standalone_host']}
        ...    ${config['second_standalone_port']}
        ...    ${config['db']}

        RETURN
    ELSE IF    '${master_name}'=='redis-new-master'
        REDIS_DB.Connect To Redis Sentinel
        ...    ${config['sentinel_hosts']}
        ...    ${config['sentinel_port']}
        ...    ${config['master_name']}
        RETURN
    END
    Fail
    ...    msg=Redis Handler not not implemented for the master_name! Please implement your ${master_name} specific handler and then retry!

Redis Ping
    [Documentation]    Pings the active Redis connection to verify connectivity.
    ...
    ...    This keyword calls the Python Redis `Ping` method to check if the Redis connection is alive.
    ...
    ...    Returns:
    ...    - True: if the Redis server responds successfully.
    ...    - Raises RuntimeError: if no Redis connection exists.
    ...
    ...    Example Usage:
    ...
    ...    ```
    ...    ${result}    Redis Ping
    ...    ```
    ${result}    REDIS_DB.Ping
    RETURN    ${result}

Redis Set Key
    [Documentation]    Sets a string key in Redis with optional expiration.
    ...
    ...    This keyword establishes the Redis connection using Sentinel, stores a value for the specified key,
    ...    and returns a dictionary containing status_code and result body.
    ...
    ...    Arguments:
    ...    - master_name (str): Redis master name (defaults to redis-platform).
    ...    - key (str): Name of the Redis key to set.
    ...    - value (str): Value to store.
    ...    - expire (int, optional): Expiration time in seconds (TTL). If not provided, the key won't expire.
    ...
    ...    Status Codes:
    ...    - 0: Key set successfully.
    ...    - 1: Internal error occurred.
    ...
    ...    Returns:
    ...    Dictionary:
    ...    {
    ...    "status_code": int,
    ...    "body": {
    ...    "result": True/False (True if key was set successfully)
    ...    }
    ...    }
    ...
    ...    Example Usage:
    ...
    ...    `*** Variables ***`
    ...
    ...    ```${KEY}    my_cache_key```
    ...
    ...    ```${VALUE}    some_value_here```
    ...
    ...    ```${EXPIRE}    3600```
    ...
    ...    `*** Test Cases ***`
    ...
    ...    ```
    ...    Redis Set Key    redis-platform    ${KEY}    ${VALUE}    ${EXPIRE}
    ...    ```
    [Arguments]    ${key}    ${value}    ${expire}=None    ${master_name}=standalone
    Initiate REDIS Db Connection    ${master_name}
    ${response}    REDIS_DB.Set Key    ${key}    ${value}    ${expire}
    REDIS_DB.Close Connection
    RETURN    ${response}

Redis Get Key
    [Documentation]    Retrieves the value of a string key from Redis.
    ...
    ...    This keyword establishes the Redis connection using Sentinel, retrieves the value for the specified key,
    ...    and returns a dictionary containing status_code and result body.
    ...
    ...    Arguments:
    ...    - key (str): Name of the Redis key to retrieve.
    ...    - master_name (str, optional): Redis master name (defaults to redis-platform).
    ...
    ...    Status Codes:
    ...    - 0: Value retrieved successfully.
    ...    - 1: Internal error occurred.
    ...
    ...    Returns:
    ...    Dictionary:
    ...    {
    ...    "status_code": int,
    ...    "body": {
    ...    "value": value (or None if key not found)
    ...    }
    ...    }
    ...
    ...    Example Usage:
    ...
    ...    `*** Variables ***`
    ...
    ...    ```${KEY}    my_cache_key```
    ...
    ...    `*** Test Cases ***`
    ...
    ...    ```
    ...    Redis Get Key    ${KEY}
    ...    ```
    [Arguments]    ${key}    ${master_name}=standalone
    Initiate REDIS Db Connection    ${master_name}
    ${response}    REDIS_DB.Get Key    ${key}
    REDIS_DB.Close Connection
    RETURN    ${response}

Redis Delete Key
    [Documentation]    Deletes a key from Redis.
    ...
    ...    This keyword establishes the Redis connection using Sentinel, deletes the specified key,
    ...    and returns a dictionary containing status_code and result body.
    ...
    ...    Arguments:
    ...    - key (str): Name of the Redis key to delete.
    ...    - master_name (str, optional): Redis master name (defaults to redis-platform).
    ...
    ...    Status Codes:
    ...    - 0: Key deleted successfully.
    ...    - 1: Internal error occurred.
    ...
    ...    Returns:
    ...    Dictionary:
    ...    {
    ...    "status_code": int,
    ...    "body": {
    ...    "deleted": int (number of keys deleted: 0 or 1)
    ...    }
    ...    }
    ...
    ...    Example Usage:
    ...
    ...    `*** Variables ***`
    ...
    ...    ```${KEY}    my_cache_key```
    ...
    ...    `*** Test Cases ***`
    ...
    ...    ```
    ...    Redis Delete Key    ${KEY}
    ...    ```
    [Arguments]    ${key}    ${master_name}=standalone
    Initiate REDIS Db Connection    ${master_name}
    ${response}    REDIS_DB.Delete Key    ${key}
    REDIS_DB.Close Connection
    RETURN    ${response}

Redis Exists Key
    [Documentation]    Checks if a key exists in Redis.
    ...
    ...    This keyword establishes the Redis connection using Sentinel, checks if the key exists,
    ...    and returns a dictionary containing status_code and result body.
    ...
    ...    Arguments:
    ...    - key (str): Name of the Redis key to check.
    ...    - master_name (str, optional): Redis master name (defaults to redis-platform).
    ...
    ...    Status Codes:
    ...    - 0: Key existence check completed.
    ...    - 1: Internal error occurred.
    ...
    ...    Returns:
    ...    Dictionary:
    ...    {
    ...    "status_code": int,
    ...    "body": {
    ...    "exists": bool (True if key exists, False otherwise)
    ...    }
    ...    }
    ...
    ...    Example Usage:
    ...
    ...    `*** Variables ***`
    ...
    ...    ```${KEY}    my_cache_key```
    ...
    ...    `*** Test Cases ***`
    ...
    ...    ```
    ...    Redis Exists Key    ${KEY}
    ...    ```
    [Arguments]    ${key}    ${master_name}=standalone
    Initiate REDIS Db Connection    ${master_name}
    ${response}    REDIS_DB.Exists Key    ${key}
    REDIS_DB.Close Connection
    RETURN    ${response}

Redis Expire Key
    [Documentation]    Sets expiration time (TTL) for a Redis key.
    ...
    ...    This keyword establishes the Redis connection using Sentinel, sets the expiration time for the key,
    ...    and returns a dictionary containing status_code and result body.
    ...
    ...    Arguments:
    ...    - key (str): Name of the Redis key.
    ...    - seconds (int): Expiration time in seconds.
    ...    - master_name (str, optional): Redis master name (defaults to redis-platform).
    ...
    ...    Status Codes:
    ...    - 0: Expiration set successfully.
    ...    - 1: Internal error occurred.
    ...
    ...    Returns:
    ...    Dictionary:
    ...    {
    ...    "status_code": int,
    ...    "body": {
    ...    "expire_set": bool (True if expiration was set, False otherwise)
    ...    }
    ...    }
    ...
    ...    Example Usage:
    ...
    ...    `*** Variables ***`
    ...
    ...    ```${KEY}    my_cache_key```
    ...    ```${TTL}    3600```
    ...
    ...    `*** Test Cases ***`
    ...
    ...    ```
    ...    Redis Expire Key    ${KEY}    ${TTL}
    ...    ```
    [Arguments]    ${key}    ${seconds}    ${master_name}=standalone
    Initiate REDIS Db Connection    ${master_name}
    ${response}    REDIS_DB.Expire Key    ${key}    ${seconds}
    REDIS_DB.Close Connection
    RETURN    ${response}

Redis TTL Key
    [Documentation]    Retrieves the remaining TTL (Time-To-Live) of a Redis key.
    ...
    ...    This keyword establishes the Redis connection using Sentinel, gets the TTL for the specified key,
    ...    and returns a dictionary containing status_code and result body.
    ...
    ...    Arguments:
    ...    - key (str): Name of the Redis key.
    ...    - master_name (str, optional): Redis master name (defaults to redis-platform).
    ...
    ...    Status Codes:
    ...    - 0: TTL retrieved successfully.
    ...    - 1: Internal error occurred.
    ...
    ...    Returns:
    ...    Dictionary:
    ...    {
    ...    "status_code": int,
    ...    "body": {
    ...    "ttl": int (-1 = no expiry, -2 = key doesn't exist)
    ...    }
    ...    }
    ...
    ...    Example Usage:
    ...
    ...    ```*** Variables ***```
    ...
    ...    ```${KEY}    my_cache_key```
    ...
    ...    ```*** Test Cases ***```
    ...
    ...    ```Redis TTL Key    ${KEY}```
    [Arguments]    ${key}    ${master_name}=standalone
    Initiate REDIS Db Connection    ${master_name}
    ${response}    REDIS_DB.TTL Key    ${key}
    REDIS_DB.Close Connection
    RETURN    ${response}

Redis Incr Key
    [Documentation]    Increments the integer value of a Redis key by 1.
    ...
    ...    This keyword establishes the Redis connection using Sentinel, increments the key value,
    ...    and returns a dictionary containing status_code and result body.
    ...
    ...    Arguments:
    ...    - key (str): Name of the Redis key.
    ...    - master_name (str, optional): Redis master name (defaults to redis-platform).
    ...
    ...    Status Codes:
    ...    - 0: Value incremented successfully.
    ...    - 1: Internal error occurred.
    ...
    ...    Returns:
    ...    Dictionary:
    ...    {
    ...    "status_code": int,
    ...    "body": {
    ...    "value": int (new incremented value)
    ...    }
    ...    }
    ...
    ...    Example Usage:
    ...
    ...    ```*** Variables ***```
    ...
    ...    ```${KEY}    counter_key```
    ...
    ...    ```*** Test Cases ***```
    ...
    ...    ```Redis Incr Key    ${KEY}```
    [Arguments]    ${key}    ${master_name}=standalone
    Initiate REDIS Db Connection    ${master_name}
    ${response}    REDIS_DB.Incr Key    ${key}
    REDIS_DB.Close Connection
    RETURN    ${response}

Redis HSet Key
    [Documentation]    Sets the value of a field inside a Redis hash key.
    ...
    ...    This keyword establishes the Redis connection using Sentinel, sets the field in the hash,
    ...    and returns a dictionary containing status_code and result body.
    ...
    ...    Arguments:
    ...    - key (str): Hash key name.
    ...    - field (str): Field name.
    ...    - value (str): Value to store.
    ...    - master_name (str, optional): Redis master name (defaults to redis-platform).
    ...
    ...    Status Codes:
    ...    - 0: Field set successfully.
    ...    - 1: Internal error occurred.
    ...
    ...    Returns:
    ...    Dictionary:
    ...    {
    ...    "status_code": int,
    ...    "body": {
    ...    "result": int (1 if field created, 0 if updated)
    ...    }
    ...    }
    ...
    ...    Example Usage:
    ...
    ...    ```${KEY}    my_hash```
    ...
    ...    ```${FIELD}    username```
    ...
    ...    ```${VALUE}    john.doe```
    ...
    ...    ```Redis HSet Key    ${KEY}    ${FIELD}    ${VALUE}```
    [Arguments]    ${key}    ${field}    ${value}    ${master_name}=standalone
    Initiate REDIS Db Connection    ${master_name}
    ${response}    REDIS_DB.HSet Key    ${key}    ${field}    ${value}
    REDIS_DB.Close Connection
    RETURN    ${response}

Redis HGet Key
    [Documentation]    Retrieves the value of a field from a Redis hash key.
    ...
    ...    This keyword establishes the Redis connection using Sentinel, gets the field value,
    ...    and returns a dictionary containing status_code and result body.
    ...
    ...    Arguments:
    ...    - key (str): Hash key name.
    ...    - field (str): Field name.
    ...    - master_name (str, optional): Redis master name (defaults to redis-platform).
    ...
    ...    Status Codes:
    ...    - 0: Field retrieved successfully.
    ...    - 1: Internal error occurred.
    ...
    ...    Returns:
    ...    Dictionary:
    ...    {
    ...    "status_code": int,
    ...    "body": {
    ...    "value": str or None (if not found)
    ...    }
    ...    }
    ...
    ...    Example Usage:
    ...
    ...    ```${KEY}    my_hash```
    ...
    ...    ```${FIELD}    username```
    ...
    ...    ```Redis HGet Key    ${KEY}    ${FIELD}```
    [Arguments]    ${key}    ${field}    ${master_name}=standalone
    Initiate REDIS Db Connection    ${master_name}
    ${response}    REDIS_DB.HGet Key    ${key}    ${field}
    REDIS_DB.Close Connection
    RETURN    ${response}

Redis HGetAll Key
    [Documentation]    Retrieves all fields and values from a Redis hash key.
    ...
    ...    This keyword establishes the Redis connection using Sentinel, retrieves the full hash content,
    ...    and returns a dictionary containing status_code and result body.
    ...
    ...    Arguments:
    ...    - key (str): Hash key name.
    ...    - master_name (str, optional): Redis master name (defaults to redis-platform).
    ...
    ...    Status Codes:
    ...    - 0: Hash retrieved successfully.
    ...    - 1: Internal error occurred.
    ...
    ...    Returns:
    ...    Dictionary:
    ...    {
    ...    "status_code": int,
    ...    "body": {
    ...    "field1": value1,
    ...    "field2": value2,
    ...    ...
    ...    }
    ...    }
    ...
    ...    Example Usage:
    ...
    ...    ```${KEY}    my_hash```
    ...
    ...    ```Redis HGetAll Key    ${KEY}```
    [Arguments]    ${key}    ${master_name}=standalone
    Initiate REDIS Db Connection    ${master_name}
    ${response}    REDIS_DB.HGetAll Key    ${key}
    REDIS_DB.Close Connection
    RETURN    ${response}

Redis LPush Key
    [Documentation]    Pushes a value to the beginning of a Redis list key.
    ...
    ...    This keyword establishes the Redis connection using Sentinel, pushes the value,
    ...    and returns a dictionary containing status_code and result body.
    ...
    ...    Arguments:
    ...    - key (str): List key name.
    ...    - value (str): Value to push.
    ...    - master_name (str, optional): Redis master name (defaults to redis-platform).
    ...
    ...    Status Codes:
    ...    - 0: Value pushed successfully.
    ...    - 1: Internal error occurred.
    ...
    ...    Returns:
    ...    Dictionary:
    ...    {
    ...    "status_code": int,
    ...    "body": {
    ...    "length": int (new list length)
    ...    }
    ...    }
    ...
    ...    Example Usage:
    ...
    ...    ```${KEY}    my_list```
    ...
    ...    ```${VALUE}    new_item```
    ...
    ...    ```Redis LPush Key    ${KEY}    ${VALUE}```
    [Arguments]    ${key}    ${value}    ${master_name}=standalone
    Initiate REDIS Db Connection    ${master_name}
    ${response}    REDIS_DB.LPush Key    ${key}    ${value}
    REDIS_DB.Close Connection
    RETURN    ${response}

Redis LRange Key
    [Documentation]    Retrieves a range of elements from a Redis list key.
    ...
    ...    This keyword establishes the Redis connection using Sentinel, retrieves the list range,
    ...    and returns a dictionary containing status_code and result body.
    ...
    ...    Arguments:
    ...    - key (str): List key name.
    ...    - start (int): Start index.
    ...    - stop (int): Stop index.
    ...    - master_name (str, optional): Redis master name (defaults to redis-platform).
    ...
    ...    Status Codes:
    ...    - 0: List retrieved successfully.
    ...    - 1: Internal error occurred.
    ...
    ...    Returns:
    ...    Dictionary:
    ...    {
    ...    "status_code": int,
    ...    "body": list of elements
    ...    }
    ...
    ...    Example Usage:
    ...
    ...    ```${KEY}    my_list```
    ...
    ...    ```${START}    0```
    ...
    ...    ```${STOP}    -1```
    ...
    ...    ```Redis LRange Key    ${KEY}    ${START}    ${STOP}```
    [Arguments]    ${key}    ${start}    ${stop}    ${master_name}=standalone
    Initiate REDIS Db Connection    ${master_name}
    ${response}    REDIS_DB.LRange Key    ${key}    ${start}    ${stop}
    REDIS_DB.Close Connection
    RETURN    ${response}

Redis SAdd Key
    [Documentation]    Adds a member to a Redis set key.
    ...
    ...    This keyword establishes the Redis connection using Sentinel, adds the value to the set,
    ...    and returns a dictionary containing status_code and result body.
    ...
    ...    Arguments:
    ...    - key (str): Set key name.
    ...    - value (str): Value to add.
    ...    - master_name (str, optional): Redis master name (defaults to redis-platform).
    ...
    ...    Status Codes:
    ...    - 0: Member added successfully.
    ...    - 1: Internal error occurred.
    ...
    ...    Returns:
    ...    Dictionary:
    ...    {
    ...    "status_code": int,
    ...    "body": {
    ...    "added": int (1 if added, 0 if already exists)
    ...    }
    ...    }
    ...
    ...    Example Usage:
    ...
    ...    ```${KEY}    my_set```
    ...
    ...    ```${VALUE}    new_member```
    ...
    ...    ```Redis SAdd Key    ${KEY}    ${VALUE}```
    [Arguments]    ${key}    ${value}    ${master_name}=standalone
    Initiate REDIS Db Connection    ${master_name}
    ${response}    REDIS_DB.SAdd Key    ${key}    ${value}
    REDIS_DB.Close Connection
    RETURN    ${response}

Redis SMembers Key
    [Documentation]    Retrieves all members of a Redis set key.
    ...
    ...    This keyword establishes the Redis connection using Sentinel, retrieves the set members,
    ...    and returns a dictionary containing status_code and result body.
    ...
    ...    Arguments:
    ...    - key (str): Set key name.
    ...    - master_name (str, optional): Redis master name (defaults to redis-platform).
    ...
    ...    Status Codes:
    ...    - 0: Set retrieved successfully.
    ...    - 1: Internal error occurred.
    ...
    ...    Returns:
    ...    Dictionary:
    ...    {
    ...    "status_code": int,
    ...    "body": list of members
    ...    }
    ...
    ...    Example Usage:
    ...
    ...    ```${KEY}    my_set```
    ...
    ...    ```Redis SMembers Key    ${KEY}```
    [Arguments]    ${key}    ${master_name}=standalone
    Initiate REDIS Db Connection    ${master_name}
    ${response}    REDIS_DB.SMembers Key    ${key}
    REDIS_DB.Close Connection
    RETURN    ${response}

Redis ZAdd Key
    [Documentation]    Adds a member with score to a Redis sorted set key.
    ...
    ...    This keyword establishes the Redis connection using Sentinel, adds the member with score,
    ...    and returns a dictionary containing status_code and result body.
    ...
    ...    Arguments:
    ...    - key (str): Sorted set key name.
    ...    - score (float): Score for sorting.
    ...    - value (str): Value to add.
    ...    - master_name (str, optional): Redis master name (defaults to redis-platform).
    ...
    ...    Status Codes:
    ...    - 0: Member added successfully.
    ...    - 1: Internal error occurred.
    ...
    ...    Returns:
    ...    Dictionary:
    ...    {
    ...    "status_code": int,
    ...    "body": {
    ...    "added": int (1 if new, 0 if updated)
    ...    }
    ...    }
    ...
    ...    Example Usage:
    ...
    ...    ```${KEY}    my_sorted_set```
    ...
    ...    ```${SCORE}    10.5```
    ...
    ...    ```${VALUE}    member1```
    ...
    ...    ```Redis ZAdd Key    ${KEY}    ${SCORE}    ${VALUE}```
    [Arguments]    ${key}    ${score}    ${value}    ${master_name}=standalone
    Initiate REDIS Db Connection    ${master_name}
    ${response}    REDIS_DB.ZAdd Key    ${key}    ${score}    ${value}
    REDIS_DB.Close Connection
    RETURN    ${response}

Redis ZRange Key
    [Documentation]    Retrieves elements from a Redis sorted set key within a range.
    ...
    ...    This keyword establishes the Redis connection using Sentinel, retrieves the elements from the sorted set,
    ...    and returns a dictionary containing status_code and result body.
    ...
    ...    Arguments:
    ...    - key (str): Sorted set key name.
    ...    - start (int): Start index.
    ...    - stop (int): Stop index.
    ...    - withscores (bool, optional): Whether to include scores (default False).
    ...    - master_name (str, optional): Redis master name (defaults to redis-platform).
    ...
    ...    Status Codes:
    ...    - 0: Sorted set retrieved successfully.
    ...    - 1: Internal error occurred.
    ...
    ...    Returns:
    ...    Dictionary:
    ...    {
    ...    "status_code": int,
    ...    "body": list of elements (or list of (value, score) if withscores True)
    ...    }
    ...
    ...    Example Usage:
    ...
    ...    ```${KEY}    my_sorted_set```
    ...
    ...    ```${START}    0```
    ...
    ...    ```${STOP}    -1```
    ...
    ...    ```Redis ZRange Key    ${KEY}    ${START}    ${STOP}```
    [Arguments]    ${key}    ${start}    ${stop}    ${withscores}=False    ${master_name}=standalone
    Initiate REDIS Db Connection    ${master_name}
    ${response}    REDIS_DB.ZRange Key    ${key}    ${start}    ${stop}    ${withscores}
    REDIS_DB.Close Connection
    RETURN    ${response}
