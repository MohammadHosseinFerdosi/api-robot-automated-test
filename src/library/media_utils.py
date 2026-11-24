from pathlib import Path
import base64

from robot.api.deco import keyword


@keyword
def file_to_base64(file_path: str) -> str:
    return base64.b64encode(Path(file_path).read_bytes()).decode("ascii")
