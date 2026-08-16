"""Render captured MySQL CLI output into legible PNG evidence drafts."""
from pathlib import Path
from PIL import Image, ImageDraw, ImageFont

ROOT = Path(__file__).resolve().parents[1]
SOURCES = [(ROOT / "tmp/query-output", ROOT / "docs/evidence/query-output"),
           (ROOT / "tmp/test-output", ROOT / "docs/evidence/test-output")]
FONT_PATH = "/System/Library/Fonts/Menlo.ttc"
FONT = ImageFont.truetype(FONT_PATH, 18)
TITLE_FONT = ImageFont.truetype(FONT_PATH, 21)

for source_dir, output_dir in SOURCES:
    output_dir.mkdir(parents=True, exist_ok=True)
    for source in sorted(source_dir.glob("*.txt")):
        lines = source.read_text(encoding="utf-8", errors="replace").splitlines() or [""]
        title = f"Cloudrest Wines | MySQL 8.4 | {source.stem}"
        longest = max([title, *lines], key=len)
        width = max(1100, int(TITLE_FONT.getlength(longest)) + 70)
        line_height = 27
        height = 70 + line_height * len(lines) + 35
        image = Image.new("RGB", (width, height), "#111827")
        draw = ImageDraw.Draw(image)
        draw.rectangle((0, 0, width, 54), fill="#1f2937")
        draw.ellipse((18, 19, 30, 31), fill="#ef4444")
        draw.ellipse((38, 19, 50, 31), fill="#f59e0b")
        draw.ellipse((58, 19, 70, 31), fill="#10b981")
        draw.text((88, 14), title, font=TITLE_FONT, fill="#f9fafb")
        y = 69
        for line in lines:
            colour = "#fca5a5" if line.startswith("ERROR") else "#d1fae5"
            draw.text((24, y), line, font=FONT, fill=colour)
            y += line_height
        image.save(output_dir / f"{source.stem}.png", optimize=True)

