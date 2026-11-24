"""Tracking helpers for Iran Wallet Robot suites."""
from __future__ import annotations

import uuid

from robot.api.deco import keyword


@keyword("New Iran Wallet Tracking Code")
def new_iran_wallet_tracking_code(prefix: str = "iw") -> str:
    return f"{prefix}-{uuid.uuid4().hex[:16]}"
