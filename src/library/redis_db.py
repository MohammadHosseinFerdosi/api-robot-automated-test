import redis
from redis.sentinel import Sentinel
from redis.exceptions import RedisError
from redis.cluster import RedisCluster
from robot.api.deco import keyword

_connection = None
_sentinel = None


@keyword
def connect_to_redis_standalone(host, port, db=0):
    """
    Connect to a standalone Redis server.

    Args:
        host (str): Redis server hostname or IP.
        port (int): Redis server port.
        db (int, optional): Redis database index (default 0).

    Raises:
        RuntimeError: If the connection fails.
    """
    global _connection
    try:
        _connection = redis.Redis(
            host=host, port=port, db=db, socket_timeout=5, decode_responses=False
        )
        _connection.ping()
        print("Connected to Redis Standalone.")
    except RedisError as e:
        raise RuntimeError(f"Error connecting to Redis Standalone: {e}")


@keyword
def connect_to_redis_tls(host, port, db=0, ssl_cert_reqs=None):
    """
    Connect to Redis server using SSL/TLS.

    Args:
        host (str): Redis server hostname or IP.
        port (int): Redis server port.
        db (int, optional): Redis database index (default 0).
        ssl_cert_reqs: Certificate validation mode (None disables validation).

    Raises:
        RuntimeError: If the connection fails.
    """
    global _connection
    try:
        _connection = redis.Redis(
            host=host,
            port=port,
            db=db,
            ssl=True,
            ssl_cert_reqs=ssl_cert_reqs,
            socket_timeout=5,
            decode_responses=False,
        )
        _connection.ping()
        print("Connected to Redis with TLS.")
    except RedisError as e:
        raise RuntimeError(f"Error connecting to Redis TLS: {e}")


@keyword
def connect_to_redis_sentinel(sentinel_hosts, sentinel_port, master_name):
    """
    Connect to Redis Sentinel master.

    Args:
        sentinel_hosts (str or list): Single sentinel host, or a list of sentinel
            hosts when the deployment runs multiple sentinel nodes on the same port.
        sentinel_port (int): Sentinel port number, shared by all sentinel nodes.
        master_name (str): Redis master group name defined in Sentinel.

    Raises:
        RuntimeError: If the connection fails.
    """
    global _connection, _sentinel
    try:
        hosts = [sentinel_hosts] if isinstance(sentinel_hosts, str) else list(sentinel_hosts)
        sentinel_nodes = [(host, int(sentinel_port)) for host in hosts]
        _sentinel = Sentinel(sentinel_nodes, socket_timeout=5)
        _connection = _sentinel.master_for(
            service_name=master_name, socket_timeout=5, decode_responses=False
        )
        _connection.ping()
        print(f"Connected to Redis master '{master_name}' via Sentinel {sentinel_nodes}.")
    except RedisError as e:
        raise RuntimeError(f"Error connecting to Redis Sentinel: {e}")


@keyword
def connect_to_redis_cluster(startup_nodes):
    """
    Connect to a Redis Cluster.

    Args:
        startup_nodes (list): List of dicts containing host/port nodes.
            Example: [{"host": "10.0.0.1", "port": 6379}, {"host": "10.0.0.2", "port": 6379}]

    Raises:
        RuntimeError: If connection fails.
    """
    global _connection
    try:
        _connection = RedisCluster(
            startup_nodes=startup_nodes, socket_timeout=5, decode_responses=False
        )
        _connection.ping()
        print("Connected to Redis Cluster.")
    except RedisError as e:
        raise RuntimeError(f"Error connecting to Redis Cluster: {e}")


@keyword
def close_connection():
    """
    Close the Redis connection and reset global state.
    """
    global _connection, _sentinel
    _connection = None
    _sentinel = None
    print("Redis connection closed.")


@keyword
def ping():
    """
    Ping the Redis connection.

    Returns:
        bool: True if connection is alive.
    """
    global _connection
    if _connection is None:
        raise RuntimeError("No Redis connection available.")
    return _connection.ping()


@keyword
def set_key(key, value, expire=None):
    """
    Set a string key in Redis with optional expiration.

    Args:
        key (str): Key name.
        value (str or bytes): Value to store.
        expire (int, optional): Expiration time in seconds.

    Returns:
        dict:
            - status_code: HTTP-style status code
                * 0: Key set successfully
                * 1: Internal error occurred
            - body: Dictionary containing operation result (True/False) or error
    """
    try:
        result = _connection.set(key, value, ex=expire)
        return {"status_code": 0, "body": {"result": result}}
    except RedisError as e:
        return {"status_code": 1, "body": {"error": str(e)}}


@keyword
def get_key(key):
    """
    Retrieve the value of a string key from Redis.

    Args:
        key (str): Key name.

    Returns:
        dict:
            - status_code: HTTP-style status code
                * 0: Value retrieved successfully
                * 1: Internal error occurred
            - body: Dictionary containing retrieved value or error
    """
    try:
        value = _connection.get(key)
        return {"status_code": 0, "body": {"value": value}}
    except RedisError as e:
        return {"status_code": 1, "body": {"error": str(e)}}


@keyword
def delete_key(key):
    """
    Delete a key from Redis.

    Args:
        key (str): Key name.

    Returns:
        dict:
            - status_code: HTTP-style status code
                * 0: Key deleted successfully
                * 1: Internal error occurred
            - body: Dictionary containing number of deleted keys or error
    """
    try:
        count = _connection.delete(key)
        return {"status_code": 0, "body": {"deleted": count}}
    except RedisError as e:
        return {"status_code": 1, "body": {"error": str(e)}}


@keyword
def exists_key(key):
    """
    Check if a key exists.

    Args:
        key (str): Key name.

    Returns:
        dict: status_code and body with existence status or error.
    """
    try:
        exists = _connection.exists(key)
        return {"status_code": 0, "body": {"exists": bool(exists)}}
    except RedisError as e:
        return {"status_code": 1, "body": {"error": str(e)}}


@keyword
def expire_key(key, seconds):
    """
    Set expiration time for a key.

    Args:
        key (str): Key name.
        seconds (int): Expiration time in seconds.

    Returns:
        dict: status_code and body with operation result or error.
    """
    try:
        result = _connection.expire(key, seconds)
        return {"status_code": 0, "body": {"expire_set": bool(result)}}
    except RedisError as e:
        return {"status_code": 1, "body": {"error": str(e)}}


@keyword
def ttl_key(key):
    """
    Get the remaining time to live (TTL) for a key.

    Args:
        key (str): Key name.

    Returns:
        dict:
            - status_code:
                * 0: TTL retrieved successfully.
                * 1: Internal error occurred.
            - body: {"ttl": int or -1 (if no expiration set), or -2 (if key does not exist)}
    """
    try:
        ttl = _connection.ttl(key)
        return {"status_code": 0, "body": {"ttl": ttl}}
    except RedisError as e:
        return {"status_code": 1, "body": {"error": str(e)}}


@keyword
def incr_key(key):
    """
    Increment the integer value of a key by one.

    Args:
        key (str): Key name.

    Returns:
        dict:
            - status_code:
                * 0: Value incremented successfully.
                * 1: Internal error occurred.
            - body: {"value": int (new incremented value)}
    """
    try:
        value = _connection.incr(key)
        return {"status_code": 0, "body": {"value": value}}
    except RedisError as e:
        return {"status_code": 1, "body": {"error": str(e)}}


@keyword
def hset_key(key, field, value):
    """
    Set the value of a field inside a hash.

    Args:
        key (str): Hash key name.
        field (str): Field name.
        value (str or bytes): Value to store.

    Returns:
        dict:
            - status_code:
                * 0: Field set successfully.
                * 1: Internal error occurred.
            - body: {"result": int (1 if field created, 0 if updated)}
    """
    try:
        result = _connection.hset(key, field, value)
        return {"status_code": 0, "body": {"result": result}}
    except RedisError as e:
        return {"status_code": 1, "body": {"error": str(e)}}


@keyword
def hget_key(key, field):
    """
    Retrieve value of a field from hash.

    Args:
        key (str): Hash key name.
        field (str): Field name.

    Returns:
        dict:
            - status_code:
                * 0: Field retrieved successfully.
                * 1: Internal error occurred.
            - body: {"value": value or None (if field does not exist)}
    """
    try:
        value = _connection.hget(key, field)
        return {"status_code": 0, "body": {"value": value}}
    except RedisError as e:
        return {"status_code": 1, "body": {"error": str(e)}}


@keyword
def hgetall_key(key):
    """
    Retrieve all fields and values from hash.

    Args:
        key (str): Hash key name.

    Returns:
        dict:
            - status_code:
                * 0: Hash retrieved successfully.
                * 1: Internal error occurred.
            - body: Full dictionary of hash fields/values.
    """
    try:
        result = _connection.hgetall(key)
        return {"status_code": 0, "body": result}
    except RedisError as e:
        return {"status_code": 1, "body": {"error": str(e)}}


@keyword
def lpush_key(key, value):
    """
    Push a value to beginning of list.

    Args:
        key (str): List key name.
        value (str or bytes): Value to push.

    Returns:
        dict:
            - status_code:
                * 0: Value pushed successfully.
                * 1: Internal error occurred.
            - body: {"length": int (new list length)}
    """
    try:
        result = _connection.lpush(key, value)
        return {"status_code": 0, "body": {"length": result}}
    except RedisError as e:
        return {"status_code": 1, "body": {"error": str(e)}}


@keyword
def lrange_key(key, start, stop):
    """
    Retrieve list items in specified range.

    Args:
        key (str): List key name.
        start (int): Start index.
        stop (int): Stop index.

    Returns:
        dict:
            - status_code:
                * 0: List retrieved successfully.
                * 1: Internal error occurred.
            - body: List of elements.
    """
    try:
        result = _connection.lrange(key, start, stop)
        return {"status_code": 0, "body": result}
    except RedisError as e:
        return {"status_code": 1, "body": {"error": str(e)}}


@keyword
def sadd_key(key, value):
    """
    Add member to set.

    Args:
        key (str): Set key name.
        value (str or bytes): Member value to add.

    Returns:
        dict:
            - status_code:
                * 0: Member added successfully.
                * 1: Internal error occurred.
            - body: {"added": int (1 if added, 0 if already exists)}
    """
    try:
        result = _connection.sadd(key, value)
        return {"status_code": 0, "body": {"added": result}}
    except RedisError as e:
        return {"status_code": 1, "body": {"error": str(e)}}


@keyword
def smembers_key(key):
    """
    Retrieve all members of set.

    Args:
        key (str): Set key name.

    Returns:
        dict:
            - status_code:
                * 0: Set retrieved successfully.
                * 1: Internal error occurred.
            - body: List of members.
    """
    try:
        result = _connection.smembers(key)
        return {"status_code": 0, "body": list(result)}
    except RedisError as e:
        return {"status_code": 1, "body": {"error": str(e)}}


@keyword
def zadd_key(key, score, value):
    """
    Add member to sorted set with score.

    Args:
        key (str): Sorted set key name.
        score (float): Score for sorting.
        value (str or bytes): Value to add.

    Returns:
        dict:
            - status_code:
                * 0: Member added successfully.
                * 1: Internal error occurred.
            - body: {"added": int (1 if new element added, 0 if updated)}
    """
    try:
        result = _connection.zadd(key, {value: score})
        return {"status_code": 0, "body": {"added": result}}
    except RedisError as e:
        return {"status_code": 1, "body": {"error": str(e)}}


@keyword
def zrange_key(key, start, stop, withscores=False):
    """
    Retrieve elements from sorted set in range.

    Args:
        key (str): Sorted set key name.
        start (int): Start index.
        stop (int): Stop index.
        withscores (bool): Whether to include scores.

    Returns:
        dict:
            - status_code:
                * 0: Range retrieved successfully.
                * 1: Internal error occurred.
            - body: List of elements (with or without scores).
    """
    try:
        result = _connection.zrange(key, start, stop, withscores=withscores)
        return {"status_code": 0, "body": result}
    except RedisError as e:
        return {"status_code": 1, "body": {"error": str(e)}}
