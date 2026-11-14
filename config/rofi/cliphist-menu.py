#!/usr/bin/env python3
import html
import os
import re
import subprocess
import sys

CACHE_DIR = "/tmp/cliphist-thumbs"
THEME_PATH = os.path.expanduser("~/.config/rofi/clipboard.rasi")

os.makedirs(CACHE_DIR, exist_ok=True)

try:
    raw_list = subprocess.check_output(["cliphist", "list"]).decode("utf-8", errors="ignore")
except Exception:
    sys.exit(0)

if not raw_list.strip():
    sys.exit(0)

lines = raw_list.strip().split("\n")
items = []
image_map = {}  # cid -> thumb_path

# Regex to parse cliphist image metadata: [[ binary data 58 KiB png 629x535 ]]
img_regex = re.compile(r"\[\[\s*binary data\s+([0-9.]+\s*\w+)\s+(\w+)\s+(\d+x\d+)\s*\]\]")

for line in lines:
    if not line:
        continue
    parts = line.split("\t", 1)
    if len(parts) < 2:
        continue
    cid, content = parts[0], parts[1]

    match = img_regex.match(content.strip())
    if match:
        size_str, fmt, res = match.groups()
        thumb_path = os.path.join(CACHE_DIR, f"{cid}.png")
        if not os.path.exists(thumb_path):
            try:
                img_data = subprocess.check_output(["cliphist", "decode", cid])
                with open(thumb_path, "wb") as f:
                    f.write(img_data)
            except Exception:
                thumb_path = ""

        if thumb_path and os.path.exists(thumb_path):
            image_map[cid] = thumb_path

        # Pure typography: grey number, clean gap, concise description
        label = f"<span color='#656977'>{cid}</span>  Screenshot {res} ({size_str})"
        items.append((cid, label))
    else:
        # Regular text: escape XML for pango, collapse newlines
        clean_text = html.escape(content.replace("\n", " ").replace("\r", ""))
        label = f"<span color='#656977'>{cid}</span>  {clean_text}"
        items.append((cid, label))

if not items:
    sys.exit(0)

payload = "\n".join(label for _, label in items)

selected_row = 0
while True:
    cmd = [
        "rofi",
        "-dmenu",
        "-theme", THEME_PATH,
        "-markup-rows",
        "-kb-custom-1", "space",
        "-selected-row", str(selected_row),
    ]

    try:
        proc = subprocess.Popen(cmd, stdin=subprocess.PIPE, stdout=subprocess.PIPE, stderr=subprocess.DEVNULL)
        stdout, _ = proc.communicate(input=payload.encode("utf-8"))
        ret = proc.returncode
        selected = stdout.decode("utf-8", errors="ignore").strip()
    except Exception:
        sys.exit(0)

    # Cancel (Esc or window close)
    if ret == 1 or not selected:
        sys.exit(0)

    # Extract ID (must match digits inside >ID<, NOT the hex color in #656977!)
    match_id = re.search(r">(\d+)<", selected)
    if not match_id:
        match_id = re.search(r"^\s*(\d+)", selected)
    if not match_id:
        sys.exit(0)
    selected_id = match_id.group(1)

    # Track current row index to keep focus on reopen
    for idx, (cid, _) in enumerate(items):
        if cid == selected_id:
            selected_row = idx
            break

    # Space (or Right / Tab) pressed -> Open in imv if image
    if ret == 10:
        if selected_id in image_map:
            img_path = image_map[selected_id]
            subprocess.run(["imv", img_path])
        # Loop back to keep rofi open on the same item
        continue

    # Enter pressed (ret == 0) -> copy and exit
    if ret == 0:
        try:
            decoded = subprocess.check_output(["cliphist", "decode", selected_id])
            subprocess.run(["wl-copy"], input=decoded, check=True)
        except Exception:
            pass
        sys.exit(0)
