# Redis Service

This Robot Framework service provides Redis interaction capabilities for automated testing. It supports connecting via Redis Sentinel, performing key-value operations, checking connection health, and more. All keywords return structured outputs that can be easily used for validations within test cases.

The output follows a standard format similar to API responses:

```bash
{
  'status_code': 0 (success) or 1 (failure),
  'body': <operation result>
}
```

> For more information check the documentations provided at each keyword withing the code

## Table of Keywords

- [Build Config For REDIS Db Handler](#build-config-for-redis-db-handler)
- [Initiate REDIS Db Connection](#initiate-redis-db-connection)
- [Redis Ping](#redis-ping)
- [Redis Set Key](#redis-set-key)
- [Redis Get Key](#redis-get-key)
- [Redis Delete Key](#redis-delete-key)
- [Redis Exists Key](#redis-exists-key)
- [Redis Expire Key](#redis-expire-key)
- [Redis TTL Key](#redis-ttl-key)
- [Redis Incr Key](#redis-incr-key)
- [Redis HSet Key](#redis-hset-key)
- [Redis HGet Key](#redis-hget-key)
- [Redis HGetAll Key](#redis-hgetall-key)
- [Redis LPush Key](#redis-lpush-key)
- [Redis LRange Key](#redis-lrange-key)
- [Redis SAdd Key](#redis-sadd-key)
- [Redis SMembers Key](#redis-smembers-key)
- [Redis ZAdd Key](#redis-zadd-key)
- [Redis ZRange Key](#redis-zrange-key)

---

## Build Config For REDIS Db Handler

**Description:**

Builds the Redis Sentinel connection configuration dictionary for the specified master group

> This is a [private] Keyword

**Arguments:**

- `${master_name}` — one of `redis-platform`, `standalone`, `second_standalone`, `redis-new-master`

**Master groups:**

| `master_name` | Topology | Config source |
|---|---|---|
| `redis-platform` | Sentinel (1 node) | `REDIS_PLATFORM_SENTIENT_HOST` / `_PORT` |
| `standalone` | Standalone | `REDIS_PLATFORM_STANDALONE_HOST` / `_PORT` |
| `second_standalone` | Standalone | `REDIS_PLATFORM_SECOND_STANDALONE_HOST` / `_PORT` |
| `redis-new-master` | Sentinel (3 nodes) — used for OTP storage | `REDIS_OTP_SENTINEL_HOSTS` (list) / `REDIS_OTP_SENTINEL_PORT` |

**Example Usage:**

```bash
Build Config For REDIS Db Handler    ${master_name}
```

---

## Initiate REDIS Db Connection

**Description:**

Initializes a connection session with a Redis server using credentials specific to the database name. This prepares the environment for executing database operations like queries or inserts.

**Arguments:**

- `${master_name}`

**Example Usage:**

```bash
Initiate REDIS Db Connection    ${master_name}
```

---

## Redis Ping

**Description:**

Pings the active Redis connection to verify connectivity.

**Arguments:** None

**Returns:**

```ping

```

**Example Usage:**

```bash
Redis Ping
```

---

## Redis Set Key

**Description:**

Sets a string key in Redis with optional expiration.

**Arguments:**

- `${key}`
- `${value}`
- `${expire}`
- `${master_name}`

**Returns:**

```python
{
  'status_code': 0 (success) or 1 (failure),
  'body': Confirmation (True/False) of successful storage or error message.
}
```

**Example Usage:**

```bash
Redis Set Key    ${key}    ${value}    ${expire}    ${master_name}
```

---

## Redis Get Key

**Description:**

Retrieves the value of a string key from Redis.

**Arguments:**

- `${key}`
- `${master_name}`

**Returns:**

```python
{
  'status_code': 0 (success) or 1 (failure),
  'body': Value stored at the specified Redis key, or None if key does not exist.
}
```

**Example Usage:**

```bash
Redis Get Key    ${key}    ${master_name}
```

---

## Redis Delete Key

**Description:**

Deletes a key from Redis.

**Arguments:**

- `${key}`
- `${master_name}`

**Returns:**

```python
{
  'status_code': 0 (success) or 1 (failure),
  'body': Number of keys that were removed.
}
```

**Example Usage:**

```bash
Redis Delete Key    ${key}    ${master_name}
```

---

## Redis Exists Key

**Description:**

Checks if a key exists in Redis.

**Arguments:**

- `${key}`
- `${master_name}`

**Returns:**

```python
{
  'status_code': 0 (success) or 1 (failure),
  'body': 1 if the key exists, 0 otherwise.
}
```

**Example Usage:**

```bash
Redis Exists Key    ${key}    ${master_name}
```

---

## Redis Expire Key

**Description:**

Sets expiration time (TTL) for a Redis key.

**Arguments:**

- `${key}`
- `${seconds}`
- `${master_name}`

**Returns:**

```python
{
  'status_code': 0 (success) or 1 (failure),
  'body': {"expire_set": bool (True if expiration was set, False otherwise)}
}
```

**Example Usage:**

```bash
Redis Expire Key    ${key}    ${seconds}    ${master_name}
```

---

## Redis TTL Key

**Description:**

Retrieves the remaining TTL (Time-To-Live) of a Redis key.

**Arguments:**

- `${key}`
- `${master_name}`

**Returns:**

```python
{
  'status_code': 0 (success) or 1 (failure),
  'body': {"ttl": int (-1 = no expiry, -2 = key doesn't exist)}
}
```

**Example Usage:**

```bash
Redis TTL Key    ${key}    ${master_name}
```

---

## Redis Incr Key

**Description:**

Increments the integer value of a Redis key by 1.

**Arguments:**

- `${key}`
- `${master_name}`

**Returns:**

```python
{
  'status_code': 0 (success) or 1 (failure),
  'body': {"value": int (new incremented value)}
}
```

**Example Usage:**

```bash
Redis Incr Key    ${key}    ${master_name}
```

---

## Redis HSet Key

**Description:**

Sets the value of a field inside a Redis hash key.

**Arguments:**

- `${key}`
- `${field}`
- `${value}`
- `${master_name}`

**Returns:**

```python
{
  'status_code': 0 (success) or 1 (failure),
  'body': {"result": int (1 if field created, 0 if updated)}
}
```

**Example Usage:**

```bash
Redis HSet Key    ${key}    ${field}    ${value}    ${master_name}
```

---

## Redis HGet Key

**Description:**

Retrieves the value of a field from a Redis hash key.

**Arguments:**

- `${key}`
- `${field}`
- `${master_name}`

**Returns:**

```python
{
  'status_code': 0 (success) or 1 (failure),
  'body': Value stored at the specified Redis key, or None if key does not exist.
}
```

**Example Usage:**

```bash
Redis HGet Key    ${key}    ${field}    ${master_name}
```

---

## Redis HGetAll Key

**Description:**

Retrieves all fields and values from a Redis hash key.

**Arguments:**

- `${key}`
- `${master_name}`

**Returns:**

```python
{
  'status_code': 0 (success) or 1 (failure),
  'body': Value stored at the specified Redis key, or None if key does not exist.
}
```

**Example Usage:**

```bash
Redis HGetAll Key    ${key}    ${master_name}
```

---

## Redis LPush Key

**Description:**

Pushes a value to the beginning of a Redis list key.

**Arguments:**

- `${key}`
- `${value}`
- `${master_name}`

**Returns:**

```python
{
  'status_code': 0 (success) or 1 (failure),
  'body': {"length": int (new list length)}
}
```

**Example Usage:**

```bash
Redis LPush Key    ${key}    ${value}    ${master_name}
```

---

## Redis LRange Key

**Description:**

Retrieves a range of elements from a Redis list key.

**Arguments:**

- `${key}`
- `${start}`
- `${stop}`
- `${master_name}`

**Returns:**

```python
{
  'status_code': 0 (success) or 1 (failure),
  'body': List of elements
}
```

**Example Usage:**

```bash
Redis LRange Key    ${key}    ${start}    ${stop}    ${master_name}
```

---

## Redis SAdd Key

**Description:**

Adds a member to a Redis set key.

**Arguments:**

- `${key}`
- `${value}`
- `${master_name}`

**Returns:**

```python
{
  'status_code': 0 (success) or 1 (failure),
  'body': {"added": int (1 if added, 0 if already exists)}
}
```

**Example Usage:**

```bash
Redis SAdd Key    ${key}    ${value}    ${master_name}
```

---

## Redis SMembers Key

**Description:**

Retrieves all members of a Redis set key.

**Arguments:**

- `${key}`
- `${master_name}`

**Returns:**

```python
{
  'status_code': 0 (success) or 1 (failure),
  'body': List of members
}
```

**Example Usage:**

```bash
Redis SMembers Key    ${key}    ${master_name}
```

---

## Redis ZAdd Key

**Description:**

Adds a member with score to a Redis sorted set key.

**Arguments:**

- `${key}`
- `${score}`
- `${value}`
- `${master_name}`

**Returns:**

```python
{
  'status_code': 0 (success) or 1 (failure),
  'body': {"added": int (1 if new, 0 if updated)}
}
```

**Example Usage:**

```bash
Redis ZAdd Key    ${key}    ${score}    ${value}    ${master_name}
```

---

## Redis ZRange Key

**Description:**

Retrieves elements from a Redis sorted set key within a range.

**Arguments:**

- `${key}`
- `${start}`
- `${stop}`
- `${withscores}`
- `${master_name}`

**Returns:**

```python
{
  'status_code': 0 (success) or 1 (failure),
  'body': List of elements (or List of (value, score) if withscores True)
}
```

**Example Usage:**

```bash
Redis ZRange Key    ${key}    ${start}    ${stop}    ${withscores}    ${master_name}
```
