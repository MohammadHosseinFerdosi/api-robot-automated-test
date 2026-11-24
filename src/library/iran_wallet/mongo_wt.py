"""Mongo helpers for Iran Wallet wallet-transfer DB checks."""
from __future__ import annotations

from typing import Any
from urllib.parse import quote_plus

from pymongo.collection import Collection
from pymongo import MongoClient
from pymongo.errors import OperationFailure, PyMongoError
from robot.api import logger
from robot.api.deco import keyword

_client: MongoClient | None = None
_db_name: str | None = None
_cleanup_not_writable_logged = False


@keyword("Iran Wallet Transfer Mongo Is Connected")
def iran_wallet_transfer_mongo_is_connected() -> bool:
    return _client is not None and _db_name is not None


@keyword("Connect Iran Wallet Transfer Mongo")
def connect_iran_wallet_transfer_mongo(
    host: str,
    port: str | int,
    user: str,
    password: CHANGE_ME
    db_name: str,
) -> None:
    global _client, _db_name
    if _client is not None and _db_name == db_name:
        return
    if _client is not None:
        _client.close()
        _client = None
        _db_name = None
    user_q = quote_plus(user)
    pass_q = quote_plus(password)
    uri = (
        f"mongodb://{user_q}:{pass_q}@{host}:{port}/{db_name}"
        f"?authSource={db_name}&directConnection=true"
    )
    _client = MongoClient(uri, serverSelectionTimeoutMS=8000)
    _client.admin.command("ping")
    _db_name = db_name


@keyword("Close Iran Wallet Transfer Mongo")
def close_iran_wallet_transfer_mongo() -> None:
    global _client, _db_name
    if _client is not None:
        _client.close()
    _client = None
    _db_name = None


def _collection(name: str) -> Collection:
    if _client is None or _db_name is None:
        raise RuntimeError("Iran Wallet Mongo not connected")
    return _client[_db_name][name]


@keyword("Count Transfers By Tracking Code")
def count_transfers_by_tracking_code(collection: str, tracking_code: str) -> int:
    return int(_collection(collection).count_documents({"trackingCode": tracking_code}))


def find_transfer_by_tracking_code(collection: str, tracking_code: str) -> dict[str, Any] | None:
    doc = _collection(collection).find_one({"trackingCode": tracking_code})
    return dict(doc) if doc else None


@keyword("Transfer Field Equals")
def transfer_field_equals(collection: str, tracking_code: str, field: str, expected: Any) -> None:
    doc = find_transfer_by_tracking_code(collection, tracking_code)
    if not doc:
        raise AssertionError(f"No transfer for trackingCode={tracking_code!r}")
    actual = doc.get(field)
    if field == "amount":
        if actual is None:
            raise AssertionError(f"field {field!r} missing (trackingCode={tracking_code!r})")
        if int(actual) != int(expected):
            raise AssertionError(
                f"field {field!r}: expected {expected!r}, got {actual!r} (trackingCode={tracking_code!r})"
            )
        return
    if actual != expected:
        raise AssertionError(
            f"field {field!r}: expected {expected!r}, got {actual!r} (trackingCode={tracking_code!r})"
        )


@keyword("Transfer Has Initiated Journal")
def transfer_has_initiated_journal(collection: str, tracking_code: str) -> bool:
    doc = find_transfer_by_tracking_code(collection, tracking_code)
    if not doc:
        return False
    journals = doc.get("journals") or []
    return any(
        j.get("actionType") == "INITIATED" and j.get("currentStatus") == "INITIATED"
        for j in journals
        if isinstance(j, dict)
    )


@keyword("Try Delete Transfers By Tracking Code")
def try_delete_transfers_by_tracking_code(collection: str, tracking_code: str) -> int:
    """Delete docs for trackingCode. Returns deleted count, or -1 if not writable / error.

    Platform UAT Mongo is often a read-only secondary — cleanup is best-effort and must
    not fail the suite when writes are denied (fail-closed: leave rows, log once).
    """
    global _cleanup_not_writable_logged
    if not tracking_code:
        return 0
    if _client is None or _db_name is None:
        return -1
    try:
        result = _collection(collection).delete_many({"trackingCode": tracking_code})
        return int(result.deleted_count)
    except OperationFailure as exc:
        if not _cleanup_not_writable_logged:
            logger.warn(
                f"Mongo cleanup skipped (not writable / OperationFailure code={exc.code}): "
                f"tracking docs left in place"
            )
            _cleanup_not_writable_logged = True
        return -1
    except PyMongoError as exc:
        if not _cleanup_not_writable_logged:
            logger.warn(f"Mongo cleanup skipped ({exc.__class__.__name__}): tracking docs left in place")
            _cleanup_not_writable_logged = True
        return -1
