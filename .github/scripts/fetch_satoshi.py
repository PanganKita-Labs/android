"""Fetch unmodified Satoshi fonts from their licensed official source."""

import hashlib
import io
from pathlib import Path
from urllib.request import urlopen
from zipfile import ZipFile

FONT_HASHES = {
    "Regular": "b94308c3dc042ffbca813300ce851412100b6526ee03594c3137a9bbfab60952",
    "Medium": "1b8add8dd01432467171646ee43f56ef035190f6f5002f80bc1766f03aa0f024",
    "Bold": "4b7a5e6f7673cf13e96ec2b8dd20897a6a1ac2e548f1bb78b475ebc4c787deaa",
}
FONT_DIR = Path(__file__).resolve().parents[2] / "app/assets/fonts"


def main():
    """Download the font and its license without redistributing them in Git."""
    with urlopen("https://api.fontshare.com/v2/fonts/download/satoshi", timeout=60) as response:
        with ZipFile(io.BytesIO(response.read())) as archive:
            fonts = {
                weight: archive.read(f"Satoshi_Complete/Fonts/WEB/fonts/Satoshi-{weight}.ttf")
                for weight in FONT_HASHES
            }
            license_text = archive.read("Satoshi_Complete/License/FFL.txt")
    for weight, font in fonts.items():
        if hashlib.sha256(font).hexdigest() != FONT_HASHES[weight]:
            raise ValueError(f"The official Satoshi {weight} file changed; review it before use.")
    FONT_DIR.mkdir(parents=True, exist_ok=True)
    for weight, font in fonts.items():
        (FONT_DIR / f"Satoshi-{weight}.ttf").write_bytes(font)
    (FONT_DIR / "Satoshi-FFL.txt").write_bytes(license_text)
    print("Installed Satoshi Regular/Medium/Bold and its license (Git-ignored).")


if __name__ == "__main__":
    main()
