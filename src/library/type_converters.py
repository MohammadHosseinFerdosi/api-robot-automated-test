from robot.api.deco import keyword
import base64
import binascii
from datetime import datetime
from bson.binary import Binary
from bson import ObjectId


@keyword
def binary_from_base64(b64_string: str, subtype: str = "00") -> Binary:
    """
    Convert a base64-encoded string to a BSON Binary object.
    """
    raw_bytes = base64.b64decode(b64_string)
    return Binary(raw_bytes, int(subtype, 16))


@keyword
def binary_from_hex(hex_string: str, subtype: str = "00") -> Binary:
    """
    Convert a hex string to a BSON Binary object.
    """
    raw_bytes = binascii.unhexlify(hex_string)
    return Binary(raw_bytes, int(subtype, 16))


@keyword
def parse_object_id(id_str: str) -> ObjectId:
    """
    Convert a string to a BSON ObjectId.
    """
    return ObjectId(id_str)


@keyword
def to_long(value) -> int:
    """
    Convert a value to a long integer (just Python int).
    """
    return int(value)


@keyword
def to_date(value: str, fmt: str = "%Y-%m-%dT%H:%M:%S") -> datetime:
    """
    Convert a string to a datetime object using the given format.
    """
    return datetime.strptime(value, fmt)
