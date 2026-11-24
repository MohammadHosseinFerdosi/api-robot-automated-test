"""Iran Wallet HTTP helpers: parse, PII mask, mute RequestsLibrary dumps."""
from __future__ import annotations

from typing import Any

from robot.api import logger
from robot.api.deco import keyword
from robot.libraries.BuiltIn import BuiltIn

_SENSITIVE_FRAGMENTS = (
    "password",
    "token",
    "secret",
    "credential",
    "api_key",
    "authorization",
    "national_id",
    "nationalcode",
    "phone",
    "mobile",
    "iban",
    "card_number",
)

_orig_log_request = None
_orig_log_response = None
_mute_depth = 0


def _is_sensitive_key(key: str) -> bool:
    lower = key.lower().replace("-", "").replace("_", "")
    return any(s.replace("_", "") in lower for s in _SENSITIVE_FRAGMENTS)


def _mask_value(value: Any) -> Any:
    if isinstance(value, dict):
        return {k: ("***MASKED***" if _is_sensitive_key(str(k)) else _mask_value(v)) for k, v in value.items()}
    if isinstance(value, list):
        return [_mask_value(v) for v in value]
    return value


@keyword("Mask Sensitive Data")
def mask_sensitive_data(data: Any) -> Any:
    """Replace sensitive fields with ***MASKED*** before logging."""
    return _mask_value(data)


@keyword("Handle API Response")
def handle_api_response(response: Any) -> dict[str, Any]:
    """Parse HTTP response to {status_code, body}. Never raises on non-2xx."""
    status_code = int(response.status_code)
    body: Any = None
    try:
        body = response.json()
    except (ValueError, TypeError, AttributeError):
        body = None
    result = {"status_code": status_code, "body": body}
    logger.info(f"Response: {status_code} | Body: {mask_sensitive_data(result)}")
    return result


@keyword("Iran Wallet Log Masked Request")
def iran_wallet_log_masked_request(method: str, path: str, body: Any = None) -> None:
    safe = mask_sensitive_data(body) if body is not None else None
    logger.info(f"{method} {path} | Body: {safe}")


@keyword("Iran Wallet Mute Requests Library Logs")
def iran_wallet_mute_requests_library_logs() -> None:
    global _orig_log_request, _orig_log_response, _mute_depth
    import RequestsLibrary.log as rl

    if _mute_depth == 0:
        _orig_log_request = rl.log_request
        _orig_log_response = rl.log_response
        rl.log_request = lambda *_a, **_k: None
        rl.log_response = lambda *_a, **_k: None
    _mute_depth += 1


@keyword("Iran Wallet Restore Requests Library Logs")
def iran_wallet_restore_requests_library_logs() -> None:
    global _orig_log_request, _orig_log_response, _mute_depth
    import RequestsLibrary.log as rl

    if _mute_depth <= 0:
        return
    _mute_depth -= 1
    if _mute_depth == 0 and _orig_log_request is not None and _orig_log_response is not None:
        rl.log_request = _orig_log_request
        rl.log_response = _orig_log_response
        _orig_log_request = None
        _orig_log_response = None


@keyword("Iran Wallet Session Headers")
def iran_wallet_session_headers(session_alias: str) -> dict[str, str]:
    rl = BuiltIn().get_library_instance("RequestsLibrary")
    session = rl._cache.switch(session_alias)
    return {str(k): str(v) for k, v in dict(session.headers).items()}
