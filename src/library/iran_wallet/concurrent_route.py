"""Concurrent POST for Iran Wallet race checks (raw client; headers from Create A Session)."""
from __future__ import annotations

import concurrent.futures
from typing import Any

import requests
from robot.api.deco import keyword


def _status_and_body(resp: requests.Response) -> dict[str, Any]:
    body: Any = None
    try:
        body = resp.json()
    except ValueError:
        body = None
    # Return unmasked body for assertions; callers log via Iran Wallet Log Masked Request.
    return {"status_code": int(resp.status_code), "body": body}


@keyword("Concurrent Post Json Results")
def concurrent_post_json_results(
    url: str,
    body: dict[str, Any],
    workers: int,
    timeout: float,
    headers: dict[str, str] | None = None,
) -> list[dict[str, Any]]:
    """POST same JSON in parallel; return list of {status_code, body}."""
    hdrs = headers if headers is not None else {}

    def _one(_: int) -> dict[str, Any]:
        resp = requests.post(url, json=body, headers=hdrs, timeout=float(timeout))
        return _status_and_body(resp)

    with concurrent.futures.ThreadPoolExecutor(max_workers=int(workers)) as pool:
        return list(pool.map(_one, range(int(workers))))
