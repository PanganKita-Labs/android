"""Fetch the unmodified Satoshi Bold font from its licensed official source."""

import hashlib
import io
from pathlib import Path
from urllib.request import urlopen
from zipfile import ZipFile

FONT_HASH = "4b7a5e6f7673cf13e96ec2b8dd20897a6a1ac2e548f1bb78b475ebc4c787deaa"
FONT_DIR = Path(__file__).resolve().parents[2] / "app/assets/fonts"


def main():
    """Download the font and its license without redistributing them in Git."""
    with urlopen("https://api.fontshare.com/v2/fonts/download/satoshi", timeout=60) as response:
        with ZipFile(io.BytesIO(response.read())) as archive:
            font = archive.read("Satoshi_Complete/Fonts/WEB/fonts/Satoshi-Bold.ttf")
            license_text = archive.read("Satoshi_Complete/License/FFL.txt")
    if hashlib.sha256(font).hexdigest() != FONT_HASH:
        raise ValueError("The official Satoshi Bold file changed; review it before use.")
    FONT_DIR.mkdir(parents=True, exist_ok=True)
    (FONT_DIR / "Satoshi-Bold.ttf").write_bytes(font)
    (FONT_DIR / "Satoshi-FFL.txt").write_bytes(license_text)
    print("Installed Satoshi Bold and its ITF Free Font License (Git-ignored).")


if __name__ == "__main__":
    main()
