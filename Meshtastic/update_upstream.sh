#!/bin/sh
# Move the pinned Meshtastic firmware to a release tag and build H3S-Dev.
#   ./update_upstream.sh              -> latest stable Meshtastic release
#   ./update_upstream.sh v2.x.y.abc   -> a specific tag
# Does not commit; prints the git commands to run if the build is good.
set -eu

HERE=$(cd "$(dirname "$0")" && pwd)
UP="$HERE/upstream"
ENV=${PIO_ENV:-h3s-dev}
TAG=${1:-}

if [ -z "$TAG" ]; then
    TAG=$(curl -fsSL https://api.github.com/repos/meshtastic/firmware/releases/latest \
          | sed -n 's/.*"tag_name": *"\([^"]*\)".*/\1/p')
    [ -n "$TAG" ] || { echo "could not get the latest release tag; pass one as argument" >&2; exit 1; }
fi

OLD=$(cat "$HERE/UPSTREAM_TAG" 2>/dev/null || echo none)
echo "Meshtastic firmware: $OLD -> $TAG"

git -C "$UP" fetch --force origin tag "$TAG"
git -C "$UP" checkout --quiet "$TAG"
git -C "$UP" submodule update --init --recursive
echo "$TAG" > "$HERE/UPSTREAM_TAG"

sh "$HERE/link_variant.sh"
pio run -d "$UP" -e "$ENV"

REL=$(git -C "$HERE" rev-parse --show-prefix)
echo
echo "Build OK. Flash and test, then commit with:"
echo "  git add ${REL}upstream ${REL}UPSTREAM_TAG"
echo "  git commit -m \"Meshtastic firmware -> $TAG\""
