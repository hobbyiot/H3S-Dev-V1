#!/bin/sh
# Link the H3S-Dev variant (and board definition) into the pinned Meshtastic firmware tree
# in ./upstream. Safe to run repeatedly.
set -eu

HERE=$(cd "$(dirname "$0")" && pwd)
UP="$HERE/upstream"
NAME=h3s_dev
ARCH=esp32s3

if [ ! -f "$UP/platformio.ini" ]; then
    echo "upstream/ is empty - run: git submodule update --init --recursive" >&2
    exit 1
fi

for old in "$UP/variants/$NAME" "$UP/variants/$ARCH/$NAME"; do
    [ -L "$old" ] && rm "$old"
done

if [ -d "$UP/variants/$ARCH" ]; then
    VDIR="variants/$ARCH/$NAME"
else
    VDIR="variants/$NAME"
fi

ln -sfn "$HERE/variant/$NAME" "$UP/$VDIR"
echo "linked $VDIR"

[ -L "$UP/boards/$NAME.json" ] && rm "$UP/boards/$NAME.json"
if [ -f "$HERE/boards/$NAME.json" ]; then
    ln -sfn "$HERE/boards/$NAME.json" "$UP/boards/$NAME.json"
    echo "linked boards/$NAME.json"
fi

if ! grep -qF -- "-I $VDIR" "$HERE/variant/$NAME/platformio.ini"; then
    echo "WARNING: variant/$NAME/platformio.ini should contain '-I $VDIR' for this upstream version" >&2
fi
if ! grep -rqs --include='*.ini' '^\[esp32s3_base\]' "$UP"; then
    echo "WARNING: [esp32s3_base] not found upstream - check what the official ESP32-S3 variants extend now" >&2
fi

EXCL=$(git -C "$UP" rev-parse --git-path info/exclude)
case "$EXCL" in /*) ;; *) EXCL="$UP/$EXCL" ;; esac
mkdir -p "$(dirname "$EXCL")"
touch "$EXCL"
for p in "/variants/$NAME" "/variants/$ARCH/$NAME" "/boards/$NAME.json"; do
    grep -qxF "$p" "$EXCL" || echo "$p" >> "$EXCL"
done
